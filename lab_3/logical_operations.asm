; -----------------------------------------------
; Lab 3 - Question 1 - Logical operators + switches
; -----------------------------------------------

 
	LIST 	P=PIC16F877
	include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; Define variables
operand1	EQU 0x21
operand2	EQU 0x22
result		EQU 0x23

org 	0x00
goto 	reset

reset:
	bcf STATUS,RP0		; Initialize ports A and D
	bcf STATUS,RP1
	clrf PORTA
	clrf PORTD
	bsf STATUS, RP0
	movlw 0x06			; Setting as digital
	movwf ADCON1
	movlw 0xF3
	; movlw 0xFF
	movwf TRISA
	clrf TRISD
	bcf STATUS,RP0

set_switches:
	; Set PORTA[2]
	bsf PORTA, 2
	
	; Clear PORTA[3]
	bsf PORTA, 3

XNOR:
	clrf operand1
	clrf operand2

	btfsc PORTA, 2
	bsf operand1, 0

	btfsc PORTA, 3
	bsf operand2, 0

	movfw operand1
	xorwf operand2, 0	; op
	movwf result

	btfss result, 0
	bsf PORTD, 0

NAND:
	clrf operand1
	clrf operand2

	btfsc PORTA, 2
	bsf operand1, 0

	btfsc PORTA, 3
	bsf operand2, 0

	movfw operand1
	andwf operand2, 0	; op
	movwf result

	btfss result, 0
	bsf PORTD, 1

NOR:
	clrf operand1
	clrf operand2

	btfsc PORTA, 2
	bsf operand1, 0

	btfsc PORTA, 3
	bsf operand2, 0

	movfw operand1
	addwf operand2, 0	; op
	movwf result

	btfss result, 0
	bsf PORTD, 2

OR:
	clrf operand1
	clrf operand2

	btfsc PORTA, 2
	bsf operand1, 0

	btfsc PORTA, 3
	bsf operand2, 0

	movfw operand1
	addwf operand2, 0	; op
	movwf result

	btfsc result, 0
	bsf PORTD, 3

AND:
	clrf operand1
	clrf operand2

	btfsc PORTA, 2
	bsf operand1, 0

	btfsc PORTA, 3
	bsf operand2, 0

	movfw operand1
	andwf operand2, 0	; op
	movwf result

	btfsc result, 0
	bsf PORTD, 4
	
end
