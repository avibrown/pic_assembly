; -----------------------------------------------
; Lab 3 - Question 1 - LED + button
; -----------------------------------------------

 
	LIST 	P=PIC16F877
	include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF



; Targil 3, ñòéó â

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

check_button:
		btfsc PORTA, 5		; Check if switch at PA3 is set
		goto check_button	; If not, keep checking...
		goto increment		; If yes, go to LED routine

increment:
		incf PORTD, 1		; Increment LED bar

 		movlw   0x05
	    movwf   0x31

delay:		
		decfsz  0x31
	    goto    delay
		
		btfss PORTA, 5
		goto increment
		goto check_button

end
