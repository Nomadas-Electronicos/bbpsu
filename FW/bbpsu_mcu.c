/*******************************************************
Project : BBPSU_MCU
Version : 1.2
Date    : 02/08/2021
Author  : Argos
Company : N?madas Electr?nicos
Comments: 
Monitoreo de Corriente y Voltaje de fuente de Alimentacion 
Con Respaldo de Bateria para dispositivos
como: Ruteadores, Modems, etc...    

Chip type               : ATmega328
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328.h>

#include <delay.h>
#include <stdio.h>
#include "lcd_i2c.h"


// Definiciones y variables globales

//#define DEBUG_DISPLAY

#ifdef DEBUG_DISPLAY
#define NUM_ESTADOS_DESP 6
#else
#define NUM_ESTADOS_DESP 5
#endif

//**Definicion de Pines
//Salidas de LED
#define LED_VERDE PORTB.7
#define LED_ROJO  PORTB.6
//(des)Habilitador del regulador SEPIC
#define SEPIC_EN  PORTD.5  
//Botones
#define B_1       PIND.2
#define B_2       PIND.3

//Banderas de botones
uint8_t g_boton_display, g_boton_on_off;
//Buffer de salida a LCD 16x2
uint8_t g_buffer_lcd[20];

//variables de calculo
float g_pre_cent, g_pre_csal, g_pre_vbat, g_pre_vsal, g_pre_vent;
float g_cent, g_csal, g_vbat, g_vsal, g_vent, g_pent, g_psal, g_eff;

//bandera de desplegado de estado en lcd
eeprom unsigned char g_desplegar_estado;
//bandera de backlight de lcd (empieza prendida de "f?brica")
eeprom unsigned char g_lcd_backlight = 1;


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{  
 unsigned long int lcd_led_timer = 0;
 delay_ms(50); //debounce
 while(B_1 == 0)
 {
  delay_ms(10);
  lcd_led_timer += 10;      
  //Si se presiona mas de 2 segundos prende/apaga el backlight de la lcd
  if( lcd_led_timer >= 2000 )
  {     
   g_lcd_backlight = !g_lcd_backlight;
   break;
  } 
 }
 delay_ms(50);
                     
 // se presiono el boton 1 (estado en display)
 g_boton_display = 1;  

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{

 delay_ms(50); //debounce
 while(B_2 == 0);
 delay_ms(50);  
       
 //se presiono el boton 2  (on/off de voltaje de salida)
 g_boton_on_off = 1;
}




//Canales del ADC
#define ADC_CENT  0
#define ADC_CSAL  1
#define ADC_VBAT  2
#define ADC_VSAL  3
#define ADC_VENT  6

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

// TWI functions
#include <twi.h>


void hw_init(void);


void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Checa Fuente de Reset
if (MCUSR & (1<<PORF))
   {
   // Power-on 
   MCUSR=0;
   // Place your code here

   }
else if (MCUSR & (1<<EXTRF))
   {
   // Reset Externo
   MCUSR=0;
   // Place your code here

   }
else if (MCUSR & (1<<BORF))
   {
   // Brown-Out
   MCUSR=0;
   // Place your code here

   }
else
   {
   // Watchdog 
   MCUSR=0;
   // Place your code here

   }

hw_init();
      
LED_ROJO =  SEPIC_EN;
LCD_I2C_begin(0);
if(g_lcd_backlight)
{
 LCD_I2C_Backlight();
}
else
{
 LCD_I2C_noBacklight();
}
LCD_I2C_setCursor(0, 0);
LCD_I2C_puts("Nomadas");
LCD_I2C_setCursor(0, 1);
LCD_I2C_puts("    Electronicos");
delay_ms(1500);

while(1)
{
    //Etapa en la que pasan las variables de adc   
    LED_VERDE = 1;
    // #asm("cli")
    g_pre_cent = read_adc(ADC_CENT);
    g_pre_csal = read_adc(ADC_CSAL);
    g_pre_vbat = read_adc(ADC_VBAT);
    g_pre_vsal = read_adc(ADC_VSAL);
    g_pre_vent = read_adc(ADC_VENT);
    // #asm("sei")
    LED_VERDE = 0; 
    
    
    //Se hacen todos los calculos
        
    g_cent = 0.0048875855 * g_pre_cent; // zxct1107 en [A] (5/1023)
    g_csal = 0.0048875855 * g_pre_csal;
                                       
                                     // (1+(Ra/Rb))*(5/1023)
    g_vent = 0.0278592 * g_pre_vent; // Ra = 470k, Rb = 100k
    g_vbat = 0.0146628 * g_pre_vbat; // Ra = 200k, Rb = 100k
    g_vsal = 0.0146628 * g_pre_vsal; // Ra = 200k, Rb = 100k
    
    g_pent = g_cent * g_vent;        //Potencia de entrada
    g_psal = g_csal * g_vsal;        //Potencia de salida
    
    g_eff = 100.0 * g_psal/g_pent;   //Eficiencia
    
    //Se muestran los resultados
    
    switch(g_desplegar_estado)
    {
        case 0:
                sprintf(g_buffer_lcd, "Ient:%6.1f[mA]    ", g_cent*1000.0);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "Vent: %5.2f[V]    ", g_vent);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);
                break;
        case 1: 
                sprintf(g_buffer_lcd, "Isal:%6.1f[mA]    ", g_csal*1000.0);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "Vsal: %5.2f[V]    ", g_vsal);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);  
                break; 
        case 2:    
                sprintf(g_buffer_lcd, "Vent: %5.2f[V]    ", g_vent);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "Vsal: %5.2f[V]    ", g_vsal);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);
                break;     
        case 3:    
                sprintf(g_buffer_lcd, "Pent:%6.1f[W]    ", g_pent);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "Psal:%6.1f[W]    ", g_psal);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);
                break;
        case 4:    
                sprintf(g_buffer_lcd, "Eff: %6.1f[%%]    ", g_eff);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "Vbat: %5.2f[V]    ", g_vbat);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);
                break; 
        case 5: // Solo debe aparece cuando esta en modo DEBUG   
                sprintf(g_buffer_lcd, "%04d %04d %04d  ", (int)g_pre_cent, (int)g_pre_csal, (int)g_pre_vbat);
                LCD_I2C_setCursor(0, 0);
                LCD_I2C_puts(g_buffer_lcd); 
                sprintf(g_buffer_lcd, "%04d %04d        ", (int)g_pre_vent, (int)g_pre_vsal);                    
                LCD_I2C_setCursor(0, 1);
                LCD_I2C_puts(g_buffer_lcd);
                break;
        
    }
      
    if(g_boton_display)
    {          
      g_desplegar_estado = (++g_desplegar_estado)% NUM_ESTADOS_DESP ;        
      g_boton_display = 0;
    }
    if(g_boton_on_off)
    {
      SEPIC_EN = !(SEPIC_EN);
      LED_ROJO =  SEPIC_EN; 
      g_boton_on_off = 0;
    } 
    if(g_lcd_backlight)
    {
     LCD_I2C_Backlight();
    }
    else
    {
     LCD_I2C_noBacklight();
    }


}


}

void hw_init(void)
{
// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=1 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (1<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
EIMSK=(1<<INT1) | (1<<INT0);
EIFR=(1<<INTF1) | (1<<INTF0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (1<<ADC3D) | (1<<ADC2D) | (1<<ADC1D) | (1<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// Mode: TWI Master
// Bit Rate: 100 kHz
twi_master_init(100);

// Global enable interrupts
#asm("sei")
}



