/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : BBPSU_MCU
Version : 1.0a
Date    : 27/06/2021
Author  : Argos
Company : N�madas Electr�nicos
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


// Declare your global variables here

#define LED_VERDE PORTB.7
#define LED_ROJO  PORTB.6

#define NUM_DESPLIEGUES 50

uint8_t buffer_lcd[20];
int i;
float pre_corriente, pre_voltaje, corriente, voltaje; 


#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 3
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;

// Read the AD conversion result
adc_data[input_index]=ADCW;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
}

// TWI functions
#include <twi.h>


float adc2Vout(float adc);
float adc2Vbat(float adc);
float zxct1107(float adc);


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

// Reset Source checking
if (MCUSR & (1<<PORF))
   {
   // Power-on Reset
   MCUSR=0;
   // Place your code here

   }
else if (MCUSR & (1<<EXTRF))
   {
   // External Reset
   MCUSR=0;
   // Place your code here

   }
else if (MCUSR & (1<<BORF))
   {
   // Brown-Out Reset
   MCUSR=0;
   // Place your code here

   }
else
   {
   // Watchdog Reset
   MCUSR=0;
   // Place your code here

   }

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
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

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
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
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
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Free Running
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=FIRST_ADC_INPUT | ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADATE) | (0<<ADIF) | (1<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
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
ADCSRA|=(1<<ADSC);

LCD_I2C_begin(0);
LCD_I2C_backlight();
LCD_I2C_setCursor(0, 0);
LCD_I2C_puts("Nomadas");
LCD_I2C_setCursor(0, 1);
LCD_I2C_puts("    Electronicos");
delay_ms(1500);

while (1)
      {
      // Place your code here 
                  
          //Muestra los valores de Corriente de Entrada y voltaje de Bateria
          for(i=0; i<NUM_DESPLIEGUES; i++)
          { 
           LED_ROJO =1;
           // Asegura que a media lectura no entre en interrupcion 
           #asm("cli")
           pre_corriente = (float)adc_data[0];
           pre_voltaje   = (float)adc_data[2];
           #asm("sei") 
           
           //Adapta
           corriente =  (1000.0*zxct1107(pre_corriente));
           voltaje   =  adc2Vbat(pre_voltaje); 
                               
           //Despliega
           sprintf(buffer_lcd, "Ient:%6.1f[mA]    ", corriente);
           LCD_I2C_setCursor(0, 0);
           LCD_I2C_puts(buffer_lcd); 
           sprintf(buffer_lcd, "Vbat: %5.2f[V]    ", voltaje);
           //sprintf(buffer_lcd, "Vbat: %6.1f[V]    ", pre_voltaje);
           LCD_I2C_setCursor(0, 1);
           LCD_I2C_puts(buffer_lcd); 
           
           LED_ROJO=0;
           delay_ms(50); 
          }
          
          
          //Muestra los valores de Voltaje y Corriente de Salida
          for(i=0; i<NUM_DESPLIEGUES; i++)
          {
           LED_ROJO =1;        
           // Asegura que a media lectura no entre en interrupcion 
           #asm("cli")
           pre_corriente = (float)adc_data[1];
           pre_voltaje   = (float)adc_data[3];
           #asm("sei")
           
           //Adapta
           corriente =  (1000.0*zxct1107(pre_corriente));
           voltaje   =  adc2Vout(pre_voltaje);
                  
           //Despliega 
           sprintf(buffer_lcd, "Isal:%6.1f[mA]    ", corriente);
           LCD_I2C_setCursor(0, 0);
           LCD_I2C_puts(buffer_lcd); 
           sprintf(buffer_lcd, "Vsal: %5.2f[V]    ", voltaje);
           //sprintf(buffer_lcd, "Vsal: %6.1f[V]    ", pre_voltaje);
           LCD_I2C_setCursor(0, 1);
           LCD_I2C_puts(buffer_lcd);
             
           LED_ROJO=0;
           delay_ms(50);
          }    
          
      }
}


float adc2Vout(float adc)
{
 // por regresion lineal                
 return 0.014812 * adc + 0.012666;
 //return  adc * 0.0048875855;
}

float adc2Vbat(float adc)
{
 return 0.028595 * adc - 0.007506;
}

float zxct1107(float adc)
{
          //   5.0/1024.0                          
 return  adc * 0.0048875855; 
}