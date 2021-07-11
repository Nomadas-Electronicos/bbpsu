#include <mega328.h>
#include <delay.h>
#include <twi.h>


typedef unsigned char uint8_t;
typedef unsigned int size_t;
//bool;

#define I2C_LCD_ADD  0x27

struct OutputState
{
    uint8_t rs;// = 0;
    uint8_t rw;// = 0;
    uint8_t E;// = 0;
    uint8_t Led;// = 0;
    uint8_t data;// = 0;      
} _output;

uint8_t _entryState;
uint8_t _displayState;

uint8_t GetLowData(struct OutputState in)
{
    uint8_t buffer = in.rs;
    buffer |= in.rw << 1;
    buffer |= in.E << 2;
    buffer |= in.Led << 3;
    buffer |= (in.data & 0x0F) << 4;

    return buffer;
}   
uint8_t GetHighData(struct OutputState in)
{
    uint8_t buffer = in.rs;
    buffer |= in.rw << 1;
    buffer |= in.E << 2;
    buffer |= in.Led << 3;
    buffer |= (in.data & 0xF0); 
    
    return buffer;
}

void LCD_I2C_begin(bool beginWire);
void LCD_I2C_backlight(void);
void LCD_I2C_noBacklight(void);
void LCD_I2C_clear(void);
void LCD_I2C_home(void);
void LCD_I2C_leftToRight(void);
void LCD_I2C_rightToLeft(void);
void LCD_I2C_autoscroll(void);
void LCD_I2C_noAutoscroll(void);
void LCD_I2C_display(void);
void LCD_I2C_noDisplay(void);
void LCD_I2C_cursor(void);
void LCD_I2C_noCursor(void);
void LCD_I2C_blink(void);
void LCD_I2C_noBlink(void);
void LCD_I2C_scrollDisplayLeft(void);
void LCD_I2C_scrollDisplayRight(void);
void LCD_I2C_createChar(uint8_t location, uint8_t charmap[]);
void LCD_I2C_setCursor(uint8_t col, uint8_t row);
size_t LCD_I2C_write(uint8_t character);
void LCD_I2C_InitializeLCD();
void LCD_I2C_I2C_Write(uint8_t output);
void LCD_I2C_LCD_Write(uint8_t output, bool initialization);
void LCD_I2C_puts(unsigned char *cad); 
                  


void LCD_I2C_begin(bool beginWire)
{
    if (beginWire)
        twi_master_init(100);

    LCD_I2C_I2C_Write(0b00000000); // Clear i2c adapter
    delay_ms(50); //Wait more than 40ms after powerOn.

    LCD_I2C_InitializeLCD();
}

void LCD_I2C_backlight()
{
    _output.Led = 1;
    LCD_I2C_I2C_Write(0b00000000 | _output.Led << 3); // Led pin is independent from LCD data and control lines.
}

void LCD_I2C_noBacklight()
{
    _output.Led = 0;
    LCD_I2C_I2C_Write(0b00000000 | _output.Led << 3); // Led pin is independent from LCD data and control lines.
}

void LCD_I2C_clear()
{
    _output.rs = 0;
    _output.rw = 0;

    LCD_I2C_LCD_Write(0b00000001, 0);
    delay_us(1600);
}

void LCD_I2C_home()
{
    _output.rs = 0;
    _output.rw = 0;

    LCD_I2C_LCD_Write(0b00000010, 0);
    delay_us(1600);
}

// Part of Entry mode set
void LCD_I2C_leftToRight()
{
    _output.rs = 0;
    _output.rw = 0;

    _entryState |= 1 << 1;

    LCD_I2C_LCD_Write(0b00000100 | _entryState, 0);
    delay_us(37);
}

// Part of Entry mode set
void LCD_I2C_rightToLeft()
{
    _output.rs = 0;
    _output.rw = 0;

    _entryState &= ~(1 << 1);

    LCD_I2C_LCD_Write(0b00000100 | _entryState, 0);
    delay_us(37);
}

// Part of Entry mode set
void LCD_I2C_autoscroll()
{
    _output.rs = 0;
    _output.rw = 0;

    _entryState |= 1;

    LCD_I2C_LCD_Write(0b00000100 | _entryState, 0);
    delay_us(37);
}

// Part of Entry mode set
void LCD_I2C_noAutoscroll()
{
    _output.rs = 0;
    _output.rw = 0;

    _entryState &= ~1;

    LCD_I2C_LCD_Write(0b00000100 | _entryState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_display()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState |= 1 << 2;

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_noDisplay()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState &= ~(1 << 2);

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_cursor()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState |= 1 << 1;

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_noCursor()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState &= ~(1 << 1);

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_blink()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState |= 1;

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Display control
void LCD_I2C_noBlink()
{
    _output.rs = 0;
    _output.rw = 0;

    _displayState &= ~1;

    LCD_I2C_LCD_Write(0b00001000 | _displayState, 0);
    delay_us(37);
}

// Part of Cursor or display shift
void LCD_I2C_scrollDisplayLeft()
{
    _output.rs = 0;
    _output.rw = 0;

    LCD_I2C_LCD_Write(0b00011000, 0);
    delay_us(37);
}

// Part of Cursor or display shift
void LCD_I2C_scrollDisplayRight()
{
    _output.rs = 0;
    _output.rw = 0;

    LCD_I2C_LCD_Write(0b00011100, 0);
    delay_us(37);
}

// Set CGRAM address
void LCD_I2C_createChar(uint8_t location, uint8_t charmap[])
{
    int i;
    _output.rs = 0;
    _output.rw = 0;

    location %= 8;

    LCD_I2C_LCD_Write(0b01000000 | (location << 3), 0);
    delay_us(37);

    for (i = 0; i < 8; i++)
        LCD_I2C_write(charmap[i]);

    LCD_I2C_setCursor(0, 0); // Set the address pointer back to the DDRAM
}

// Set DDRAM address
void LCD_I2C_setCursor(uint8_t col, uint8_t row)
{     
    uint8_t newAddress;
    _output.rs = 0;
    _output.rw = 0;

    newAddress = (row == 0 ? 0x00 : 0x40);
    newAddress += col;

    LCD_I2C_LCD_Write(0b10000000 | newAddress, 0);
    delay_us(37);
}

size_t LCD_I2C_write(uint8_t character)
{
    _output.rs = 1;
    _output.rw = 0;

    LCD_I2C_LCD_Write(character, 0);
    delay_us(41);

    return 1;
}

void LCD_I2C_InitializeLCD()
{
    // See HD44780U datasheet "Initializing by Instruction" Figure 24 (4-Bit Interface)
    _output.rs = 0;
    _output.rw = 0;

    LCD_I2C_LCD_Write(0b00110000, 1);
    delay_us(4200);
    LCD_I2C_LCD_Write(0b00110000, 1);
    delay_us(150);
    LCD_I2C_LCD_Write(0b00110000, 1);
    delay_us(37);
    LCD_I2C_LCD_Write(0b00100000, 1); // Function Set - 4 bits mode
    delay_us(37);
    LCD_I2C_LCD_Write(0b00101000, 0); // Function Set - 4 bits(Still), 2 lines, 5x8 font
    delay_us(37);

    LCD_I2C_display();
    LCD_I2C_clear();
    LCD_I2C_leftToRight();
}

void LCD_I2C_I2C_Write(uint8_t output)
{
    //Wire.beginTransmission(_address);
    //Wire.write(output);
    //Wire.endTransmission();  
    
    twi_master_trans(I2C_LCD_ADD,(unsigned char *) &output,1,0,0);

    
}

void LCD_I2C_LCD_Write(uint8_t output, bool initialization)
{
    _output.data = output;

    _output.E = true;
    LCD_I2C_I2C_Write(GetHighData(_output));
    delay_us(1); // High part of enable should be >450 nS

    _output.E = false;
    LCD_I2C_I2C_Write(GetHighData(_output));

    // During initialization we only send half a byte
    if (!initialization)
    {
        delay_us(37); // I think we need a delay between half byte writes, but no sure how long it needs to be.

        _output.E = true;
        LCD_I2C_I2C_Write(GetLowData(_output));
        delay_us(1); // High part of enable should be >450 nS

        _output.E = false;
        LCD_I2C_I2C_Write(GetLowData(_output));
    }
    //delay_us(37); // Some commands have different timing requirement,
                             // so every command should handle its own delay after execution
}

void LCD_I2C_puts(unsigned char *cad)
{
 while( *cad )
 {
  LCD_I2C_write(*cad++);
 }
 
}


