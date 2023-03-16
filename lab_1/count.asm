LIST 	P=PIC16F877
include	<P16f877.inc>

__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; Define program memory locations
org 0x00
reset:	goto start

; Start of the program
start:	
	; Set the bank to 0 by clearing RP0 and RP1 bits in the STATUS register
	bcf STATUS, RP0
	bcf STATUS, RP1

	; Load binary number to be checked into 0x20
	movlw 0xaa		; Load number to be checked into W register
	movwf 0x20		; Move W value into 0x20

	; Initialize the loop counter to 8
	movlw 8			; Load counter into W register
	movwf 0x21		; Move 8 into 0x21

	; Initialize the "1" counter to 0
	movlw 0			; Load 0 into W register
	movwf 0x22		; Move 0 into 0x22

; Loop through the binary number to count the number of 1s
loop:

	; Check if least significant bit of the binary number == 1
	btfsc 0x20, 0		

	; If == 1, increment "1" counter
	incf 0x22, 1	; This line is skipped if ^ == 0

	; If == 0, rotate the binary number right by one
	rrf 0x20, 1

	; Decrement the "loop" counter by 1
	decf 0x21, 1

	; Check if the "loop" counter has reached 0
	btfss STATUS, Z ; Did the decf result in a 0?

	; If not, continue the loop
	goto loop

; Otherwise, end the program
end
