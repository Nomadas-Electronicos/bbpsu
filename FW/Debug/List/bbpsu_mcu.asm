
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __entryState=R4
	.DEF __displayState=R3
	.DEF _boton_display=R6
	.DEF _boton_on_off=R5
	.DEF _desplegar_estado=R8

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _twi_int_handler
	JMP  0x00

_0x0:
	.DB  0x4E,0x6F,0x6D,0x61,0x64,0x61,0x73,0x0
	.DB  0x20,0x20,0x20,0x20,0x45,0x6C,0x65,0x63
	.DB  0x74,0x72,0x6F,0x6E,0x69,0x63,0x6F,0x73
	.DB  0x0,0x49,0x65,0x6E,0x74,0x3A,0x25,0x36
	.DB  0x2E,0x31,0x66,0x5B,0x6D,0x41,0x5D,0x20
	.DB  0x20,0x20,0x20,0x0,0x56,0x65,0x6E,0x74
	.DB  0x3A,0x20,0x25,0x35,0x2E,0x32,0x66,0x5B
	.DB  0x56,0x5D,0x20,0x20,0x20,0x20,0x0,0x49
	.DB  0x73,0x61,0x6C,0x3A,0x25,0x36,0x2E,0x31
	.DB  0x66,0x5B,0x6D,0x41,0x5D,0x20,0x20,0x20
	.DB  0x20,0x0,0x56,0x73,0x61,0x6C,0x3A,0x20
	.DB  0x25,0x35,0x2E,0x32,0x66,0x5B,0x56,0x5D
	.DB  0x20,0x20,0x20,0x20,0x0,0x50,0x65,0x6E
	.DB  0x74,0x3A,0x25,0x36,0x2E,0x31,0x66,0x5B
	.DB  0x57,0x5D,0x20,0x20,0x20,0x20,0x0,0x50
	.DB  0x73,0x61,0x6C,0x3A,0x25,0x36,0x2E,0x31
	.DB  0x66,0x5B,0x57,0x5D,0x20,0x20,0x20,0x20
	.DB  0x0,0x45,0x66,0x66,0x3A,0x20,0x25,0x36
	.DB  0x2E,0x31,0x66,0x5B,0x25,0x25,0x5D,0x20
	.DB  0x20,0x20,0x20,0x0,0x56,0x62,0x61,0x74
	.DB  0x3A,0x20,0x25,0x35,0x2E,0x32,0x66,0x5B
	.DB  0x56,0x5D,0x20,0x20,0x20,0x20,0x0,0x25
	.DB  0x30,0x34,0x64,0x20,0x25,0x30,0x34,0x64
	.DB  0x20,0x25,0x30,0x34,0x64,0x20,0x0,0x25
	.DB  0x30,0x34,0x64,0x20,0x25,0x30,0x34,0x64
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020003:
	.DB  0x7
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _0x1F
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x1F+8
	.DW  _0x0*2+8

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : BBPSU_MCU
;Version : 1.2
;Date    : 02/08/2021
;Author  : Argos
;Company : Nómadas Electrónicos
;Comments:
;Monitoreo de Corriente y Voltaje de fuente de Alimentacion
;Con Respaldo de Bateria para dispositivos
;como: Ruteadores, Modems, etc...
;
;
;Chip type               : ATmega328
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#include <delay.h>
;#include <stdio.h>
;#include "lcd_i2c.h"

	.CSEG
_GetLowData:
; .FSTART _GetLowData
	CALL SUBOPT_0x0
;	in -> Y+1
;	buffer -> R17
	ANDI R30,LOW(0xF)
	SWAP R30
	ANDI R30,0xF0
	RJMP _0x20C000B
; .FEND
_GetHighData:
; .FSTART _GetHighData
	CALL SUBOPT_0x0
;	in -> Y+1
;	buffer -> R17
	ANDI R30,LOW(0xF0)
_0x20C000B:
	OR   R17,R30
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_LCD_I2C_begin:
; .FSTART _LCD_I2C_begin
	ST   -Y,R26
;	beginWire -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _twi_master_init
_0x3:
	LDI  R26,LOW(0)
	RCALL _LCD_I2C_I2C_Write
	CALL SUBOPT_0x1
	RCALL _LCD_I2C_InitializeLCD
	RJMP _0x20C0008
; .FEND
_LCD_I2C_backlight:
; .FSTART _LCD_I2C_backlight
	LDI  R30,LOW(1)
	__PUTB1MN __output,3
	__GETB1MN __output,3
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R26,R30
	RCALL _LCD_I2C_I2C_Write
	RET
; .FEND
_LCD_I2C_clear:
; .FSTART _LCD_I2C_clear
	CALL SUBOPT_0x2
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3
	__DELAY_USW 3200
	RET
; .FEND
_LCD_I2C_leftToRight:
; .FSTART _LCD_I2C_leftToRight
	CALL SUBOPT_0x2
	LDI  R30,LOW(2)
	OR   R4,R30
	MOV  R30,R4
	ORI  R30,4
	RJMP _0x20C000A
; .FEND
_LCD_I2C_display:
; .FSTART _LCD_I2C_display
	CALL SUBOPT_0x2
	LDI  R30,LOW(4)
	OR   R3,R30
	MOV  R30,R3
	ORI  R30,8
_0x20C000A:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0x4
	RET
; .FEND
;	location -> Y+4
;	charmap -> Y+2
;	i -> R16,R17
_LCD_I2C_setCursor:
; .FSTART _LCD_I2C_setCursor
	ST   -Y,R26
	ST   -Y,R17
;	col -> Y+2
;	row -> Y+1
;	newAddress -> R17
	CALL SUBOPT_0x2
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BRNE _0x7
	LDI  R30,LOW(0)
	RJMP _0x8
_0x7:
	LDI  R30,LOW(64)
_0x8:
	MOV  R17,R30
	LDD  R30,Y+2
	ADD  R17,R30
	MOV  R30,R17
	ORI  R30,0x80
	CALL SUBOPT_0x3
	__DELAY_USB 99
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_LCD_I2C_write:
; .FSTART _LCD_I2C_write
	ST   -Y,R26
;	character -> Y+0
	LDI  R30,LOW(1)
	STS  __output,R30
	LDI  R30,LOW(0)
	__PUTB1MN __output,1
	LD   R30,Y
	CALL SUBOPT_0x3
	__DELAY_USB 109
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20C0008
; .FEND
_LCD_I2C_InitializeLCD:
; .FSTART _LCD_I2C_InitializeLCD
	CALL SUBOPT_0x2
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_I2C_LCD_Write
	__DELAY_USW 8400
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_I2C_LCD_Write
	__DELAY_USW 300
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
	LDI  R30,LOW(40)
	CALL SUBOPT_0x3
	__DELAY_USB 99
	RCALL _LCD_I2C_display
	RCALL _LCD_I2C_clear
	RCALL _LCD_I2C_leftToRight
	RET
; .FEND
_LCD_I2C_I2C_Write:
; .FSTART _LCD_I2C_I2C_Write
	ST   -Y,R26
;	output -> Y+0
	LDI  R30,LOW(39)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _twi_master_trans
	RJMP _0x20C0008
; .FEND
_LCD_I2C_LCD_Write:
; .FSTART _LCD_I2C_LCD_Write
	ST   -Y,R26
;	output -> Y+1
;	initialization -> Y+0
	LDD  R30,Y+1
	__PUTB1MN __output,4
	CALL SUBOPT_0x5
	RCALL _GetHighData
	CALL SUBOPT_0x6
	RCALL _GetHighData
	MOV  R26,R30
	RCALL _LCD_I2C_I2C_Write
	LD   R30,Y
	CPI  R30,0
	BRNE _0xA
	__DELAY_USB 99
	CALL SUBOPT_0x5
	RCALL _GetLowData
	CALL SUBOPT_0x6
	RCALL _GetLowData
	MOV  R26,R30
	RCALL _LCD_I2C_I2C_Write
_0xA:
	RJMP _0x20C0009
; .FEND
_LCD_I2C_puts:
; .FSTART _LCD_I2C_puts
	ST   -Y,R27
	ST   -Y,R26
;	*cad -> Y+0
_0xB:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xD
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _LCD_I2C_write
	RJMP _0xB
_0xD:
_0x20C0009:
	ADIW R28,2
	RET
; .FEND
;
;
;// Declare your global variables here
;
;//Salidas de LED
;#define LED_VERDE PORTB.7
;#define LED_ROJO  PORTB.6
;//(des)Habilitador del regulador SEPIC
;#define SEPIC_EN  PORTD.5
;//Botones
;#define B_1       PIND.2
;#define B_2       PIND.3
;
;uint8_t boton_display, boton_on_off;
;
;uint8_t buffer_lcd[20];
;
;
;float g_pre_cent, g_pre_csal, g_pre_vbat, g_pre_vsal, g_pre_vent;
;float g_cent, g_csal, g_vbat, g_vsal, g_vent, g_pent, g_psal, g_eff;
;
;unsigned char desplegar_estado;
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003A {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x7
; 0000 003B  delay_ms(50); //debounce
; 0000 003C  while(B_1 == 0);
_0xE:
	SBIS 0x9,2
	RJMP _0xE
; 0000 003D  delay_ms(50);
	CALL SUBOPT_0x1
; 0000 003E 
; 0000 003F  boton_display = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0040 
; 0000 0041  //desplegar = (++desplegar)%6;
; 0000 0042  //delay_ms(50);
; 0000 0043 }
	RJMP _0x38
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0047 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x7
; 0000 0048 
; 0000 0049  delay_ms(50); //debounce
; 0000 004A  while(B_2 == 0);
_0x11:
	SBIS 0x9,3
	RJMP _0x11
; 0000 004B  delay_ms(50);
	CALL SUBOPT_0x1
; 0000 004C 
; 0000 004D  boton_on_off = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 004E 
; 0000 004F  //SEPIC_EN = !(SEPIC_EN);
; 0000 0050  //LED_ROJO =  SEPIC_EN;
; 0000 0051  //delay_ms(50);
; 0000 0052 }
_0x38:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;//Canales del ADC
;#define ADC_CENT  0
;#define ADC_CSAL  1
;#define ADC_VBAT  2
;#define ADC_VSAL  3
;#define ADC_VENT  6
;
;
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0062 {
_read_adc:
; .FSTART _read_adc
; 0000 0063 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
; 0000 0064 // Delay needed for the stabilization of the ADC input voltage
; 0000 0065 delay_us(10);
	__DELAY_USB 27
; 0000 0066 // Start the AD conversion
; 0000 0067 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0068 // Wait for the AD conversion to complete
; 0000 0069 while ((ADCSRA & (1<<ADIF))==0);
_0x14:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x14
; 0000 006A ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 006B return ADCW;
	LDS  R30,120
	LDS  R31,120+1
_0x20C0008:
	ADIW R28,1
	RET
; 0000 006C }
; .FEND
;
;// TWI functions
;#include <twi.h>
;
;
;void hw_init(void);
;
;
;void main(void)
; 0000 0076 {
_main:
; .FSTART _main
; 0000 0077 // Declare your local variables here
; 0000 0078 
; 0000 0079 // Crystal Oscillator division factor: 1
; 0000 007A #pragma optsize-
; 0000 007B CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 007C CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 007D #ifdef _OPTIMIZE_SIZE_
; 0000 007E #pragma optsize+
; 0000 007F #endif
; 0000 0080 
; 0000 0081 // Checa Fuente de Reset
; 0000 0082 if (MCUSR & (1<<PORF))
	IN   R30,0x34
	SBRC R30,0
; 0000 0083    {
; 0000 0084    // Power-on
; 0000 0085    MCUSR=0;
	RJMP _0x36
; 0000 0086    // Place your code here
; 0000 0087 
; 0000 0088    }
; 0000 0089 else if (MCUSR & (1<<EXTRF))
	IN   R30,0x34
	SBRC R30,1
; 0000 008A    {
; 0000 008B    // Reset Externo
; 0000 008C    MCUSR=0;
	RJMP _0x36
; 0000 008D    // Place your code here
; 0000 008E 
; 0000 008F    }
; 0000 0090 else if (MCUSR & (1<<BORF))
	IN   R30,0x34
; 0000 0091    {
; 0000 0092    // Brown-Out
; 0000 0093    MCUSR=0;
; 0000 0094    // Place your code here
; 0000 0095 
; 0000 0096    }
; 0000 0097 else
; 0000 0098    {
; 0000 0099    // Watchdog
; 0000 009A    MCUSR=0;
_0x36:
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 009B    // Place your code here
; 0000 009C 
; 0000 009D    }
; 0000 009E 
; 0000 009F hw_init();
	RCALL _hw_init
; 0000 00A0 
; 0000 00A1 LED_ROJO =  SEPIC_EN;
	SBIC 0xB,5
	RJMP _0x1D
	CBI  0x5,6
	RJMP _0x1E
_0x1D:
	SBI  0x5,6
_0x1E:
; 0000 00A2 LCD_I2C_begin(0);
	LDI  R26,LOW(0)
	RCALL _LCD_I2C_begin
; 0000 00A3 LCD_I2C_backlight();
	RCALL _LCD_I2C_backlight
; 0000 00A4 LCD_I2C_setCursor(0, 0);
	CALL SUBOPT_0x8
; 0000 00A5 LCD_I2C_puts("Nomadas");
	__POINTW2MN _0x1F,0
	RCALL _LCD_I2C_puts
; 0000 00A6 LCD_I2C_setCursor(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_I2C_setCursor
; 0000 00A7 LCD_I2C_puts("    Electronicos");
	__POINTW2MN _0x1F,8
	RCALL _LCD_I2C_puts
; 0000 00A8 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 00A9 
; 0000 00AA while(1)
_0x20:
; 0000 00AB {
; 0000 00AC     //Etapa en la que pasan las variables de adc
; 0000 00AD     LED_VERDE = 1;
	SBI  0x5,7
; 0000 00AE     // #asm("cli")
; 0000 00AF     g_pre_cent = read_adc(ADC_CENT);
	LDI  R26,LOW(0)
	RCALL _read_adc
	LDI  R26,LOW(_g_pre_cent)
	LDI  R27,HIGH(_g_pre_cent)
	CALL SUBOPT_0x9
; 0000 00B0     g_pre_csal = read_adc(ADC_CSAL);
	LDI  R26,LOW(1)
	RCALL _read_adc
	LDI  R26,LOW(_g_pre_csal)
	LDI  R27,HIGH(_g_pre_csal)
	CALL SUBOPT_0x9
; 0000 00B1     g_pre_vbat = read_adc(ADC_VBAT);
	LDI  R26,LOW(2)
	RCALL _read_adc
	LDI  R26,LOW(_g_pre_vbat)
	LDI  R27,HIGH(_g_pre_vbat)
	CALL SUBOPT_0x9
; 0000 00B2     g_pre_vsal = read_adc(ADC_VSAL);
	LDI  R26,LOW(3)
	RCALL _read_adc
	LDI  R26,LOW(_g_pre_vsal)
	LDI  R27,HIGH(_g_pre_vsal)
	CALL SUBOPT_0x9
; 0000 00B3     g_pre_vent = read_adc(ADC_VENT);
	LDI  R26,LOW(6)
	RCALL _read_adc
	LDI  R26,LOW(_g_pre_vent)
	LDI  R27,HIGH(_g_pre_vent)
	CALL SUBOPT_0x9
; 0000 00B4     // #asm("sei")
; 0000 00B5     LED_VERDE = 0;
	CBI  0x5,7
; 0000 00B6 
; 0000 00B7 
; 0000 00B8     //Se hacen todos los calculos
; 0000 00B9 
; 0000 00BA     g_cent = 0.0048875855 * g_pre_cent; // zxct1107 en [A] (5/1023)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	STS  _g_cent,R30
	STS  _g_cent+1,R31
	STS  _g_cent+2,R22
	STS  _g_cent+3,R23
; 0000 00BB     g_csal = 0.0048875855 * g_pre_csal;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB
	STS  _g_csal,R30
	STS  _g_csal+1,R31
	STS  _g_csal+2,R22
	STS  _g_csal+3,R23
; 0000 00BC 
; 0000 00BD                                      // (1+(Ra/Rb))*(5/1023)
; 0000 00BE     g_vent = 0.0278592 * g_pre_vent; // Ra = 470k, Rb = 100k
	CALL SUBOPT_0xD
	__GETD2N 0x3CE438FA
	CALL __MULF12
	STS  _g_vent,R30
	STS  _g_vent+1,R31
	STS  _g_vent+2,R22
	STS  _g_vent+3,R23
; 0000 00BF     g_vbat = 0.0146628 * g_pre_vbat; // Ra = 200k, Rb = 100k
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	STS  _g_vbat,R30
	STS  _g_vbat+1,R31
	STS  _g_vbat+2,R22
	STS  _g_vbat+3,R23
; 0000 00C0     g_vsal = 0.0146628 * g_pre_vsal; // Ra = 200k, Rb = 100k
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	STS  _g_vsal,R30
	STS  _g_vsal+1,R31
	STS  _g_vsal+2,R22
	STS  _g_vsal+3,R23
; 0000 00C1 
; 0000 00C2     g_pent = g_cent * g_vent;        //Potencia de entrada
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL __MULF12
	STS  _g_pent,R30
	STS  _g_pent+1,R31
	STS  _g_pent+2,R22
	STS  _g_pent+3,R23
; 0000 00C3     g_psal = g_csal * g_vsal;        //Potencia de salida
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL __MULF12
	STS  _g_psal,R30
	STS  _g_psal+1,R31
	STS  _g_psal+2,R22
	STS  _g_psal+3,R23
; 0000 00C4 
; 0000 00C5     g_eff = 100.0 * g_psal/g_pent;   //Eficiencia
	CALL SUBOPT_0x15
	__GETD2N 0x42C80000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x16
	CALL __DIVF21
	STS  _g_eff,R30
	STS  _g_eff+1,R31
	STS  _g_eff+2,R22
	STS  _g_eff+3,R23
; 0000 00C6 
; 0000 00C7     //Se muestran los resultados
; 0000 00C8 
; 0000 00C9     switch(desplegar_estado)
	MOV  R30,R8
	LDI  R31,0
; 0000 00CA     {
; 0000 00CB         case 0:
	SBIW R30,0
	BRNE _0x2A
; 0000 00CC                 sprintf(buffer_lcd, "Ient:%6.1f[mA]    ", g_cent*1000.0);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,25
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x18
; 0000 00CD                 LCD_I2C_setCursor(0, 0);
; 0000 00CE                 LCD_I2C_puts(buffer_lcd);
	CALL SUBOPT_0x19
; 0000 00CF                 sprintf(buffer_lcd, "Vent: %5.2f[V]    ", g_vent);
	__POINTW1FN _0x0,44
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x1A
; 0000 00D0                 LCD_I2C_setCursor(0, 1);
	RJMP _0x37
; 0000 00D1                 LCD_I2C_puts(buffer_lcd);
; 0000 00D2                 break;
; 0000 00D3         case 1:
_0x2A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00D4                 sprintf(buffer_lcd, "Isal:%6.1f[mA]    ", g_csal*1000.0);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,63
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
; 0000 00D5                 LCD_I2C_setCursor(0, 0);
; 0000 00D6                 LCD_I2C_puts(buffer_lcd);
	CALL SUBOPT_0x19
; 0000 00D7                 sprintf(buffer_lcd, "Vsal: %5.2f[V]    ", g_vsal);
	__POINTW1FN _0x0,82
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1A
; 0000 00D8                 LCD_I2C_setCursor(0, 1);
	RJMP _0x37
; 0000 00D9                 LCD_I2C_puts(buffer_lcd);
; 0000 00DA                 break;
; 0000 00DB         case 2:
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00DC                 sprintf(buffer_lcd, "Pent:%6.1f[W]    ", g_pent);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,101
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1A
; 0000 00DD                 LCD_I2C_setCursor(0, 0);
	CALL SUBOPT_0x8
; 0000 00DE                 LCD_I2C_puts(buffer_lcd);
	CALL SUBOPT_0x19
; 0000 00DF                 sprintf(buffer_lcd, "Psal:%6.1f[W]    ", g_psal);
	__POINTW1FN _0x0,119
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1A
; 0000 00E0                 LCD_I2C_setCursor(0, 1);
	RJMP _0x37
; 0000 00E1                 LCD_I2C_puts(buffer_lcd);
; 0000 00E2                 break;
; 0000 00E3         case 3:
_0x2C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00E4                 sprintf(buffer_lcd, "Eff: %6.1f[%%]    ", g_eff);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,137
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_g_eff
	LDS  R31,_g_eff+1
	LDS  R22,_g_eff+2
	LDS  R23,_g_eff+3
	CALL SUBOPT_0x1A
; 0000 00E5                 LCD_I2C_setCursor(0, 0);
	CALL SUBOPT_0x8
; 0000 00E6                 LCD_I2C_puts(buffer_lcd);
	CALL SUBOPT_0x19
; 0000 00E7                 sprintf(buffer_lcd, "Vbat: %5.2f[V]    ", g_vbat);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_g_vbat
	LDS  R31,_g_vbat+1
	LDS  R22,_g_vbat+2
	LDS  R23,_g_vbat+3
	CALL SUBOPT_0x1A
; 0000 00E8                 LCD_I2C_setCursor(0, 1);
	RJMP _0x37
; 0000 00E9                 LCD_I2C_puts(buffer_lcd);
; 0000 00EA                 break;
; 0000 00EB         case 4:
_0x2D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x29
; 0000 00EC                 sprintf(buffer_lcd, "%04d %04d %04d ", (int)g_pre_cent, (int)g_pre_csal, (int)g_pre_vbat);
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,175
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xC
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 00ED                 LCD_I2C_setCursor(0, 0);
	CALL SUBOPT_0x8
; 0000 00EE                 LCD_I2C_puts(buffer_lcd);
	CALL SUBOPT_0x19
; 0000 00EF                 sprintf(buffer_lcd, "%04d %04d         ", (int)g_pre_vent, (int)g_pre_vsal);
	__POINTW1FN _0x0,191
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1B
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 00F0                 LCD_I2C_setCursor(0, 1);
_0x37:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_I2C_setCursor
; 0000 00F1                 LCD_I2C_puts(buffer_lcd);
	LDI  R26,LOW(_buffer_lcd)
	LDI  R27,HIGH(_buffer_lcd)
	RCALL _LCD_I2C_puts
; 0000 00F2                 break;
; 0000 00F3 
; 0000 00F4     }
_0x29:
; 0000 00F5 
; 0000 00F6     if(boton_display)
	TST  R6
	BREQ _0x2F
; 0000 00F7     {
; 0000 00F8       desplegar_estado = (++desplegar_estado)%5 ;
	INC  R8
	MOV  R26,R8
	CLR  R27
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	MOV  R8,R30
; 0000 00F9       boton_display = 0;
	CLR  R6
; 0000 00FA     }
; 0000 00FB     if(boton_on_off)
_0x2F:
	TST  R5
	BREQ _0x30
; 0000 00FC     {
; 0000 00FD       SEPIC_EN = !(SEPIC_EN);
	SBIS 0xB,5
	RJMP _0x31
	CBI  0xB,5
	RJMP _0x32
_0x31:
	SBI  0xB,5
_0x32:
; 0000 00FE       LED_ROJO =  SEPIC_EN;
	SBIC 0xB,5
	RJMP _0x33
	CBI  0x5,6
	RJMP _0x34
_0x33:
	SBI  0x5,6
_0x34:
; 0000 00FF       boton_on_off = 0;
	CLR  R5
; 0000 0100     }
; 0000 0101     //delay_ms(100);
; 0000 0102 
; 0000 0103 
; 0000 0104 }
_0x30:
	RJMP _0x20
; 0000 0105 
; 0000 0106 
; 0000 0107 }
_0x35:
	RJMP _0x35
; .FEND

	.DSEG
_0x1F:
	.BYTE 0x19
;
;void hw_init(void)
; 0000 010A {

	.CSEG
_hw_init:
; .FSTART _hw_init
; 0000 010B // Input/Output Ports initialization
; 0000 010C // Port B initialization
; 0000 010D // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 010E DDRB=(1<<DDB7) | (1<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(192)
	OUT  0x4,R30
; 0000 010F // State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0110 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0111 
; 0000 0112 // Port C initialization
; 0000 0113 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0114 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
; 0000 0115 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0116 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 0117 
; 0000 0118 // Port D initialization
; 0000 0119 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 011A DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(32)
	OUT  0xA,R30
; 0000 011B // State: Bit7=T Bit6=T Bit5=1 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 011C PORTD=(0<<PORTD7) | (0<<PORTD6) | (1<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0xB,R30
; 0000 011D 
; 0000 011E // Timer/Counter 0 initialization
; 0000 011F // Clock source: System Clock
; 0000 0120 // Clock value: Timer 0 Stopped
; 0000 0121 // Mode: Normal top=0xFF
; 0000 0122 // OC0A output: Disconnected
; 0000 0123 // OC0B output: Disconnected
; 0000 0124 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0125 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0126 TCNT0=0x00;
	OUT  0x26,R30
; 0000 0127 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0128 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0129 
; 0000 012A // Timer/Counter 1 initialization
; 0000 012B // Clock source: System Clock
; 0000 012C // Clock value: Timer1 Stopped
; 0000 012D // Mode: Normal top=0xFFFF
; 0000 012E // OC1A output: Disconnected
; 0000 012F // OC1B output: Disconnected
; 0000 0130 // Noise Canceler: Off
; 0000 0131 // Input Capture on Falling Edge
; 0000 0132 // Timer1 Overflow Interrupt: Off
; 0000 0133 // Input Capture Interrupt: Off
; 0000 0134 // Compare A Match Interrupt: Off
; 0000 0135 // Compare B Match Interrupt: Off
; 0000 0136 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0137 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 0138 TCNT1H=0x00;
	STS  133,R30
; 0000 0139 TCNT1L=0x00;
	STS  132,R30
; 0000 013A ICR1H=0x00;
	STS  135,R30
; 0000 013B ICR1L=0x00;
	STS  134,R30
; 0000 013C OCR1AH=0x00;
	STS  137,R30
; 0000 013D OCR1AL=0x00;
	STS  136,R30
; 0000 013E OCR1BH=0x00;
	STS  139,R30
; 0000 013F OCR1BL=0x00;
	STS  138,R30
; 0000 0140 
; 0000 0141 // Timer/Counter 2 initialization
; 0000 0142 // Clock source: System Clock
; 0000 0143 // Clock value: Timer2 Stopped
; 0000 0144 // Mode: Normal top=0xFF
; 0000 0145 // OC2A output: Disconnected
; 0000 0146 // OC2B output: Disconnected
; 0000 0147 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0148 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0149 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 014A TCNT2=0x00;
	STS  178,R30
; 0000 014B OCR2A=0x00;
	STS  179,R30
; 0000 014C OCR2B=0x00;
	STS  180,R30
; 0000 014D 
; 0000 014E // Timer/Counter 0 Interrupt(s) initialization
; 0000 014F TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0150 
; 0000 0151 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0152 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0153 
; 0000 0154 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0155 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0156 
; 0000 0157 // External Interrupt(s) initialization
; 0000 0158 // INT0: On
; 0000 0159 // INT0 Mode: Falling Edge
; 0000 015A // INT1: On
; 0000 015B // INT1 Mode: Falling Edge
; 0000 015C // Interrupt on any change on pins PCINT0-7: Off
; 0000 015D // Interrupt on any change on pins PCINT8-14: Off
; 0000 015E // Interrupt on any change on pins PCINT16-23: Off
; 0000 015F EICRA=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	STS  105,R30
; 0000 0160 EIMSK=(1<<INT1) | (1<<INT0);
	LDI  R30,LOW(3)
	OUT  0x1D,R30
; 0000 0161 EIFR=(1<<INTF1) | (1<<INTF0);
	OUT  0x1C,R30
; 0000 0162 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 0163 
; 0000 0164 // USART initialization
; 0000 0165 // USART disabled
; 0000 0166 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0167 
; 0000 0168 // Analog Comparator initialization
; 0000 0169 // Analog Comparator: Off
; 0000 016A // The Analog Comparator's positive input is
; 0000 016B // connected to the AIN0 pin
; 0000 016C // The Analog Comparator's negative input is
; 0000 016D // connected to the AIN1 pin
; 0000 016E ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 016F // Digital input buffer on AIN0: On
; 0000 0170 // Digital input buffer on AIN1: On
; 0000 0171 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 0172 
; 0000 0173 // ADC initialization
; 0000 0174 // ADC Clock frequency: 125.000 kHz
; 0000 0175 // ADC Voltage Reference: AREF pin
; 0000 0176 // ADC Auto Trigger Source: ADC Stopped
; 0000 0177 // Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 0178 // ADC4: On, ADC5: On
; 0000 0179 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (1<<ADC3D) | (1<<ADC2D) | (1<<ADC1D) | (1<<ADC0D);
	LDI  R30,LOW(15)
	STS  126,R30
; 0000 017A ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 017B ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	STS  122,R30
; 0000 017C ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 017D 
; 0000 017E // SPI initialization
; 0000 017F // SPI disabled
; 0000 0180 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0181 
; 0000 0182 // TWI initialization
; 0000 0183 // Mode: TWI Master
; 0000 0184 // Bit Rate: 100 kHz
; 0000 0185 twi_master_init(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _twi_master_init
; 0000 0186 
; 0000 0187 // Global enable interrupts
; 0000 0188 #asm("sei")
	sei
; 0000 0189 }
	RET
; .FEND
;
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1C
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000019:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	CALL SUBOPT_0x1C
_0x200001A:
	RJMP _0x200001B
_0x2000016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x1D
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0007
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0007
_0x200001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2000021:
	LDD  R17,Y+11
_0x2000022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000024
	CALL SUBOPT_0x1E
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0x1E
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0x1F
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000027
	CALL SUBOPT_0x1E
_0x2000028:
	CALL SUBOPT_0x1F
	BRLO _0x200002A
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0x1F
	BRSH _0x200002E
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0x1E
_0x200002B:
	__GETD1S 12
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1F
	BRLO _0x200002F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	__GETD2S 4
	CALL SUBOPT_0x25
	CALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x20
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x20
	CALL SUBOPT_0x28
	CALL SUBOPT_0x23
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0x26
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0x29
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000119
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000119:
	ST   X,R30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x29
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1C
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	CALL SUBOPT_0x2A
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0x2A
	RJMP _0x200011A
_0x2000040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000041
	LDI  R16,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R18,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R18,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000046
	ORI  R16,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200004C
	LDI  R17,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R18,48
	BRLO _0x2000051
	CPI  R18,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R18,108
	BRNE _0x2000053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2B
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2D
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x2E
	CALL __GETD1P
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	CPI  R26,LOW(0x20)
	BREQ _0x2000065
	RJMP _0x2000066
_0x2000061:
	CALL SUBOPT_0x31
	CALL __ANEGF1
	CALL SUBOPT_0x2F
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000067
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x2D
	RJMP _0x2000068
_0x2000067:
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000068:
_0x2000066:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x200006A
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x200006B
_0x200006A:
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x200006B:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x32
	RJMP _0x200006C
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006E
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000071
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000073
	CP   R20,R17
	BRLO _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	MOV  R17,R20
_0x2000072:
_0x200006C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000075
_0x2000071:
	CPI  R30,LOW(0x64)
	BREQ _0x2000078
	CPI  R30,LOW(0x69)
	BRNE _0x2000079
_0x2000078:
	ORI  R16,LOW(4)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x75)
	BRNE _0x200007B
_0x200007A:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x34
	LDI  R17,LOW(10)
	RJMP _0x200007D
_0x200007C:
	__GETD1N 0x2710
	CALL SUBOPT_0x34
	LDI  R17,LOW(5)
	RJMP _0x200007D
_0x200007B:
	CPI  R30,LOW(0x58)
	BRNE _0x200007F
	ORI  R16,LOW(8)
	RJMP _0x2000080
_0x200007F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000BE
_0x2000080:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000082
	__GETD1N 0x10000000
	CALL SUBOPT_0x34
	LDI  R17,LOW(8)
	RJMP _0x200007D
_0x2000082:
	__GETD1N 0x1000
	CALL SUBOPT_0x34
	LDI  R17,LOW(4)
_0x200007D:
	CPI  R20,0
	BREQ _0x2000083
	ANDI R16,LOW(127)
	RJMP _0x2000084
_0x2000083:
	LDI  R20,LOW(1)
_0x2000084:
	SBRS R16,1
	RJMP _0x2000085
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200011B
_0x2000085:
	SBRS R16,2
	RJMP _0x2000087
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CALL __CWD1
	RJMP _0x200011B
_0x2000087:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CLR  R22
	CLR  R23
_0x200011B:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000089
	LDD  R26,Y+13
	TST  R26
	BRPL _0x200008A
	CALL SUBOPT_0x31
	CALL __ANEGD1
	CALL SUBOPT_0x2F
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200008A:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x200008B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008C
_0x200008B:
	ANDI R16,LOW(251)
_0x200008C:
_0x2000089:
	MOV  R19,R20
_0x2000075:
	SBRC R16,0
	RJMP _0x200008D
_0x200008E:
	CP   R17,R21
	BRSH _0x2000091
	CP   R19,R21
	BRLO _0x2000092
_0x2000091:
	RJMP _0x2000090
_0x2000092:
	SBRS R16,7
	RJMP _0x2000093
	SBRS R16,2
	RJMP _0x2000094
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000095
_0x2000094:
	LDI  R18,LOW(48)
_0x2000095:
	RJMP _0x2000096
_0x2000093:
	LDI  R18,LOW(32)
_0x2000096:
	CALL SUBOPT_0x2A
	SUBI R21,LOW(1)
	RJMP _0x200008E
_0x2000090:
_0x200008D:
_0x2000097:
	CP   R17,R20
	BRSH _0x2000099
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200009A
	CALL SUBOPT_0x35
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x200009A:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x200009C
	SUBI R21,LOW(1)
_0x200009C:
	SUBI R20,LOW(1)
	RJMP _0x2000097
_0x2000099:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009D
_0x200009E:
	CPI  R19,0
	BREQ _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A2
_0x20000A1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A2:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x20000A3
	SUBI R21,LOW(1)
_0x20000A3:
	SUBI R19,LOW(1)
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x20000A4
_0x200009D:
_0x20000A6:
	CALL SUBOPT_0x36
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A8
	SBRS R16,3
	RJMP _0x20000A9
	SUBI R18,-LOW(55)
	RJMP _0x20000AA
_0x20000A9:
	SUBI R18,-LOW(87)
_0x20000AA:
	RJMP _0x20000AB
_0x20000A8:
	SUBI R18,-LOW(48)
_0x20000AB:
	SBRC R16,4
	RJMP _0x20000AD
	CPI  R18,49
	BRSH _0x20000AF
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AE
_0x20000AF:
	RJMP _0x20000B1
_0x20000AE:
	CP   R20,R19
	BRSH _0x200011C
	CP   R21,R19
	BRLO _0x20000B4
	SBRS R16,0
	RJMP _0x20000B5
_0x20000B4:
	RJMP _0x20000B3
_0x20000B5:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B6
_0x200011C:
	LDI  R18,LOW(48)
_0x20000B1:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B7
	CALL SUBOPT_0x35
	BREQ _0x20000B8
	SUBI R21,LOW(1)
_0x20000B8:
_0x20000B7:
_0x20000B6:
_0x20000AD:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x20000B9
	SUBI R21,LOW(1)
_0x20000B9:
_0x20000B3:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x36
	CALL __MODD21U
	CALL SUBOPT_0x2F
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x34
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
_0x20000A4:
	SBRS R16,0
	RJMP _0x20000BA
_0x20000BB:
	CPI  R21,0
	BREQ _0x20000BD
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2D
	RJMP _0x20000BB
_0x20000BD:
_0x20000BA:
_0x20000BE:
_0x200005A:
_0x200011A:
	LDI  R17,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x37
	SBIW R30,0
	BRNE _0x20000BF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000BF:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x37
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_master_init:
; .FSTART _twi_master_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x1E,1
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDI  R30,LOW(0)
	STS  _twi_slave_rx_handler_G101,R30
	STS  _twi_slave_rx_handler_G101+1,R30
	STS  _twi_slave_tx_handler_G101,R30
	STS  _twi_slave_tx_handler_G101+1,R30
	SBI  0x8,4
	SBI  0x8,5
	STS  188,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	CALL __DIVW21U
	MOV  R17,R30
	CPI  R17,8
	BRLO _0x2020006
	SUBI R17,LOW(8)
_0x2020006:
	STS  184,R17
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_twi_master_trans:
; .FSTART _twi_master_trans
	ST   -Y,R26
	SBIW R28,4
	SBIS 0x1E,1
	RJMP _0x2020007
	LDD  R30,Y+10
	LSL  R30
	STS  _slave_address_G101,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STS  _twi_tx_buffer_G101,R30
	STS  _twi_tx_buffer_G101+1,R31
	LDI  R30,LOW(0)
	STS  _twi_tx_index,R30
	LDD  R30,Y+7
	STS  _bytes_to_tx_G101,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _twi_rx_buffer_G101,R30
	STS  _twi_rx_buffer_G101+1,R31
	LDI  R30,LOW(0)
	STS  _twi_rx_index,R30
	LDD  R30,Y+4
	STS  _bytes_to_rx_G101,R30
	LDI  R30,LOW(6)
	STS  _twi_result,R30
	sei
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2020008
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x20C0005
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x202000B
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BREQ _0x202000C
_0x202000B:
	RJMP _0x202000A
_0x202000C:
	RJMP _0x20C0005
_0x202000A:
	SBI  0x1E,0
	RJMP _0x202000F
_0x2020008:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2020010
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BREQ _0x20C0005
	LDS  R30,_slave_address_G101
	ORI  R30,1
	STS  _slave_address_G101,R30
	CBI  0x1E,0
_0x202000F:
	CBI  0x1E,1
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	__GETD1N 0x7A120
	CALL SUBOPT_0x38
_0x2020016:
	SBIC 0x1E,1
	RJMP _0x2020018
	CALL SUBOPT_0x39
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL SUBOPT_0x38
	BRNE _0x2020019
	LDI  R30,LOW(5)
	STS  _twi_result,R30
	SBI  0x1E,1
	RJMP _0x20C0005
_0x2020019:
	RJMP _0x2020016
_0x2020018:
_0x2020010:
	LDS  R26,_twi_result
	LDI  R30,LOW(0)
	CALL __EQB12
	RJMP _0x20C0004
_0x2020007:
_0x20C0005:
	LDI  R30,LOW(0)
_0x20C0004:
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G101
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G101
	LDS  R27,_twi_rx_buffer_G101+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2020023
	LDI  R18,LOW(0)
	RJMP _0x2020024
_0x2020023:
	CPI  R30,LOW(0x10)
	BRNE _0x2020025
_0x2020024:
	LDS  R30,_slave_address_G101
	RJMP _0x2020080
_0x2020025:
	CPI  R30,LOW(0x18)
	BREQ _0x2020029
	CPI  R30,LOW(0x28)
	BRNE _0x202002A
_0x2020029:
	CP   R16,R19
	BRSH _0x202002B
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2020080:
	STS  187,R30
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x202002C
_0x202002B:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x202002D
	LDS  R30,_slave_address_G101
	ORI  R30,1
	STS  _slave_address_G101,R30
	CBI  0x1E,0
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x2020022
_0x202002D:
	RJMP _0x2020030
_0x202002C:
	RJMP _0x2020022
_0x202002A:
	CPI  R30,LOW(0x50)
	BRNE _0x2020031
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x40)
	BRNE _0x2020033
_0x2020032:
	LDS  R30,_bytes_to_rx_G101
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2020034
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020081
_0x2020034:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2020081:
	STS  188,R30
	RJMP _0x2020022
_0x2020033:
	CPI  R30,LOW(0x58)
	BRNE _0x2020036
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020037
_0x2020036:
	CPI  R30,LOW(0x20)
	BRNE _0x2020038
_0x2020037:
	RJMP _0x2020039
_0x2020038:
	CPI  R30,LOW(0x30)
	BRNE _0x202003A
_0x2020039:
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x48)
	BRNE _0x202003C
_0x202003B:
	CPI  R18,0
	BRNE _0x202003D
	SBIS 0x1E,0
	RJMP _0x202003E
	CP   R16,R19
	BRLO _0x2020040
	RJMP _0x2020041
_0x202003E:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x2020042
_0x2020040:
	LDI  R18,LOW(4)
_0x2020042:
_0x2020041:
_0x202003D:
_0x2020030:
	RJMP _0x2020082
_0x202003C:
	CPI  R30,LOW(0x38)
	BRNE _0x2020045
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020083
_0x2020045:
	CPI  R30,LOW(0x68)
	BREQ _0x2020048
	CPI  R30,LOW(0x78)
	BRNE _0x2020049
_0x2020048:
	LDI  R18,LOW(2)
	RJMP _0x202004A
_0x2020049:
	CPI  R30,LOW(0x60)
	BREQ _0x202004D
	CPI  R30,LOW(0x70)
	BRNE _0x202004E
_0x202004D:
	LDI  R18,LOW(0)
_0x202004A:
	LDI  R17,LOW(0)
	CBI  0x1E,0
	LDS  R30,_twi_rx_buffer_size_G101
	CPI  R30,0
	BRNE _0x2020051
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020084
_0x2020051:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2020084:
	STS  188,R30
	RJMP _0x2020022
_0x202004E:
	CPI  R30,LOW(0x80)
	BREQ _0x2020054
	CPI  R30,LOW(0x90)
	BRNE _0x2020055
_0x2020054:
	SBIS 0x1E,0
	RJMP _0x2020056
	LDI  R18,LOW(1)
	RJMP _0x2020057
_0x2020056:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G101
	CP   R17,R30
	BRSH _0x2020058
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BRNE _0x2020059
	LDI  R18,LOW(6)
	RJMP _0x2020057
_0x2020059:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G101,0
	CPI  R30,0
	BREQ _0x202005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2020022
_0x202005A:
	RJMP _0x202005B
_0x2020058:
	SBI  0x1E,0
_0x202005B:
	RJMP _0x202005E
_0x2020055:
	CPI  R30,LOW(0x88)
	BRNE _0x202005F
_0x202005E:
	RJMP _0x2020060
_0x202005F:
	CPI  R30,LOW(0x98)
	BRNE _0x2020061
_0x2020060:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2020022
_0x2020061:
	CPI  R30,LOW(0xA0)
	BRNE _0x2020062
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SBI  0x1E,1
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BREQ _0x2020065
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G101,0
	RJMP _0x2020066
_0x2020065:
	LDI  R18,LOW(6)
_0x2020066:
	RJMP _0x2020022
_0x2020062:
	CPI  R30,LOW(0xB0)
	BRNE _0x2020067
	LDI  R18,LOW(2)
	RJMP _0x2020068
_0x2020067:
	CPI  R30,LOW(0xA8)
	BRNE _0x2020069
_0x2020068:
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x202006A
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G101,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x202006C
	LDI  R18,LOW(0)
	RJMP _0x202006D
_0x202006A:
_0x202006C:
	LDI  R18,LOW(6)
	RJMP _0x2020057
_0x202006D:
	LDI  R16,LOW(0)
	CBI  0x1E,0
	RJMP _0x2020070
_0x2020069:
	CPI  R30,LOW(0xB8)
	BRNE _0x2020071
_0x2020070:
	SBIS 0x1E,0
	RJMP _0x2020072
	LDI  R18,LOW(1)
	RJMP _0x2020057
_0x2020072:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRSH _0x2020073
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x2020085
_0x2020073:
	SBI  0x1E,0
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x2020085:
	STS  188,R30
	RJMP _0x2020022
_0x2020071:
	CPI  R30,LOW(0xC0)
	BREQ _0x2020078
	CPI  R30,LOW(0xC8)
	BRNE _0x2020079
_0x2020078:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x202007A
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G101,0
_0x202007A:
	RJMP _0x2020043
_0x2020079:
	CPI  R30,0
	BRNE _0x2020022
	LDI  R18,LOW(3)
_0x2020057:
_0x2020082:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x2020083:
	STS  188,R30
_0x2020043:
	SBI  0x1E,1
_0x2020022:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G101,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL SUBOPT_0x38
    brne __floor1
__floor0:
	CALL SUBOPT_0x39
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x39
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0x3A
	__POINTW2FN _0x20A0000,0
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x3A
	__POINTW2FN _0x20A0000,1
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x3E
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x3F
	CALL __ADDF12
	RCALL SUBOPT_0x3B
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x3E
_0x20A0014:
	RCALL SUBOPT_0x3F
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x3E
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x3A
	__POINTW2FN _0x20A0000,5
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001C
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x27
	LDI  R31,0
	RCALL SUBOPT_0x3D
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3B
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x3B
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x27
	LDI  R31,0
	RCALL SUBOPT_0x40
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3B
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
__output:
	.BYTE 0x5
_buffer_lcd:
	.BYTE 0x14
_g_pre_cent:
	.BYTE 0x4
_g_pre_csal:
	.BYTE 0x4
_g_pre_vbat:
	.BYTE 0x4
_g_pre_vsal:
	.BYTE 0x4
_g_pre_vent:
	.BYTE 0x4
_g_cent:
	.BYTE 0x4
_g_csal:
	.BYTE 0x4
_g_vbat:
	.BYTE 0x4
_g_vsal:
	.BYTE 0x4
_g_vent:
	.BYTE 0x4
_g_pent:
	.BYTE 0x4
_g_psal:
	.BYTE 0x4
_g_eff:
	.BYTE 0x4
_slave_address_G101:
	.BYTE 0x1
_twi_tx_buffer_G101:
	.BYTE 0x2
_bytes_to_tx_G101:
	.BYTE 0x1
_twi_rx_buffer_G101:
	.BYTE 0x2
_bytes_to_rx_G101:
	.BYTE 0x1
_twi_rx_buffer_size_G101:
	.BYTE 0x1
_twi_slave_rx_handler_G101:
	.BYTE 0x2
_twi_slave_tx_handler_G101:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	LDD  R17,Y+1
	LDD  R30,Y+2
	LSL  R30
	OR   R17,R30
	LDD  R30,Y+3
	LSL  R30
	LSL  R30
	OR   R17,R30
	LDD  R30,Y+4
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R17,R30
	LDD  R30,Y+5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  __output,R30
	__PUTB1MN __output,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _LCD_I2C_LCD_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	CALL _LCD_I2C_LCD_Write
	__DELAY_USB 99
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	__PUTB1MN __output,2
	LDI  R30,LOW(__output)
	LDI  R31,HIGH(__output)
	LDI  R26,5
	CALL __PUTPARL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	MOV  R26,R30
	CALL _LCD_I2C_I2C_Write
	__DELAY_USB 3
	LDI  R30,LOW(0)
	__PUTB1MN __output,2
	LDI  R30,LOW(__output)
	LDI  R31,HIGH(__output)
	LDI  R26,5
	CALL __PUTPARL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _LCD_I2C_setCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R30,_g_pre_cent
	LDS  R31,_g_pre_cent+1
	LDS  R22,_g_pre_cent+2
	LDS  R23,_g_pre_cent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD2N 0x3BA0280A
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R30,_g_pre_csal
	LDS  R31,_g_pre_csal+1
	LDS  R22,_g_pre_csal+2
	LDS  R23,_g_pre_csal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDS  R30,_g_pre_vent
	LDS  R31,_g_pre_vent+1
	LDS  R22,_g_pre_vent+2
	LDS  R23,_g_pre_vent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R30,_g_pre_vbat
	LDS  R31,_g_pre_vbat+1
	LDS  R22,_g_pre_vbat+2
	LDS  R23,_g_pre_vbat+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD2N 0x3C703C3E
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDS  R30,_g_pre_vsal
	LDS  R31,_g_pre_vsal+1
	LDS  R22,_g_pre_vsal+2
	LDS  R23,_g_pre_vsal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R30,_g_vent
	LDS  R31,_g_vent+1
	LDS  R22,_g_vent+2
	LDS  R23,_g_vent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R26,_g_cent
	LDS  R27,_g_cent+1
	LDS  R24,_g_cent+2
	LDS  R25,_g_cent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_g_vsal
	LDS  R31,_g_vsal+1
	LDS  R22,_g_vsal+2
	LDS  R23,_g_vsal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R26,_g_csal
	LDS  R27,_g_csal+1
	LDS  R24,_g_csal+2
	LDS  R25,_g_csal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDS  R30,_g_psal
	LDS  R31,_g_psal+1
	LDS  R22,_g_psal+2
	LDS  R23,_g_psal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R30,_g_pent
	LDS  R31,_g_pent+1
	LDS  R22,_g_pent+2
	LDS  R23,_g_pent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_buffer_lcd)
	LDI  R31,HIGH(_buffer_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	__GETD1N 0x447A0000
	CALL __MULF12
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_buffer_lcd)
	LDI  R27,HIGH(_buffer_lcd)
	CALL _LCD_I2C_puts
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1A:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	CALL __CFD1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1E:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2B:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2E:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x2B
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x2E
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x35:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
