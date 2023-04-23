; -----------------------------------------------
; Lab 3 - Question 1 - Logical operators + switches
; -----------------------------------------------

 
	LIST 	P=PIC16F877
	include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF



; Targil 3, סעיף ג

		org 	0x00
Reset:
		goto 	start

		org 	0x05
start:
		bcf STATUS,RP0		; Initialize ports A and D
		bcf STATUS,RP1
		clrf PORTA
		clrf PORTD
		bsf STATUS, RP0
		movlw 0x06			; Setting as digital
		movwf ADCON1
		movlw 0x3F			; Setting as OUTPUT
		movwf TRISA
		clrf TRISD
		bcf STATUS,RP0

		movlw 0x0
		movwf PORTD			; Clear PORTD

		movlw 0x0
		movwf 0x20			; Temp

check_switches:
		; Clear PORTD
		clrf PORTD
		clrf W

		; Move PA2 to temp 0
		btfsc PORTA, 2
		bsf 0x20, 0

		; Move PA3 to W
		btfsc PORTA, 3
		movlw 0x01

set_leds:
		; NXOR
		xorwf 0x20, 0
		btfss W, 0
		bsf PORTD, 0
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		; NAND
		andwf 0x20, 0
		btfss W, 0
		bsf PORTD, 1
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		; NOR
		addwf 0x20, 0
		btfss W, 0
		bsf PORTD, 2
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		; OR
		addwf 0x20, 0
		btfsc W, 0
		bsf PORTD, 3
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		; AND
		andwf 0x20, 0
		btfsc W, 0
		bsf PORTD, 4
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		; XOR
		xorwf 0x20, 0
		btfsc W, 0
		bsf PORTD, 5
		clrf W
		btfsc PORTA, 3
		movlw 0x01

		goto check_switches

end
