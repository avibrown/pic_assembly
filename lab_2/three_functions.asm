;------------------------------------------------------------------
; All three functions combined
; Aviel Brown 		-- 336073820
; Omer Yacobovitch 	-- 305612657
;------------------------------------------------------------------
;
;
;
;     /\       (_)    | |   ___     / __ \                     
;    /  \__   ___  ___| |  ( _ )   | |  | |_ __ ___   ___ _ __ 
;   / /\ \ \ / / |/ _ \ |  / _ \/\ | |  | | '_ ` _ \ / _ \ '__|
;  / ____ \ V /| |  __/ | | (_>  < | |__| | | | | | |  __/ |   
; /_/    \_\_/ |_|\___|_|  \___/\/  \____/|_| |_| |_|\___|_|   
;                                                              
;
;
; Initialize device
LIST    P=PIC16F877
include <P16f877.inc>

__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; Define program memory locations
org 	0x00
reset:
   		goto start

; Start of the program
start:
		; Set the bank to 0 by clearing RP0 and RP1 bits in the STATUS register
		bcf STATUS, RP0
		bcf STATUS, RP1
		
		; Load numbers into registers 0x20, 0x21
		movlw 0xD0	 ; Larger number should be moved to 0x20
		movwf 0x20
		
		movlw 0x1E
		movwf 0x21
		
		; Initialize subtraction result register
		clrf 0x2A

subtract:
	    ; Move smaller number to W
	    movf 0x21, 0
	
	    ; Subtract number in 0x21 (now in W) from 0x20
	    subwf 0x20, 0
	
	    ; Store the result in 0x2A
	    movwf 0x2A
	
	    ; Go to multiplication
	    goto multiply

multiply:
	    ; Initialize multiplication result register mulH
	    clrf 0x2B
	
	    ; Initialize multiplication result register mulL to multiplier
	    movf 0x20, 0
	    movwf 0x2C
	
	    ; Initialize counter
	    movlw 0x08
	    movwf 0x30

multiply_loop:
	    ; Clear carry bit
	    bcf STATUS, C
	
	    ; Check if lowest bit of mulL == 1
	    btfss 0x2C, 0
	
	    ; If no...
	    goto mul_no
	
	    ; If yes...
	    goto mul_yes
	
mul_yes:
	    ; mulH = mulH + X
	    movf 0x21, 0    ; Load multiplicand to W
	    addwf 0x2B, 1   ; mulL = mulL + W
	
mul_no:
	    ; Rotate mulH right
	    rrf 0x2B
	
	    ; Rotate mulL right
	    rrf 0x2C
	
	    ; Decrement counter
	    decfsz 0x30
	
	    ; If counter not zero, continue loop
	    goto multiply_loop
	
	    ; Otherwise, go to division...
	    goto division

division:
	    ; Initialize division result (not remainder) register
	    clrf 0x2D
	
	    ; Initialize division remainder result register
	    clrf 0x2E
	
	    ; Dividend A - bigger number - is in 0x20
	    ; Let's move it to 0x2D because that's where the result will be
	    movf 0x20, 0
	    movwf 0x2D
	
	    ; Diviser B - smaller number - is in 0x21.
	    ; We can just leave it there.
	
	    ; Initialize extension register (M)
	    ; This will hold the remainder
	    clrf 0x2E
	
	    ; Reset counter to 8
	    movlw 0x08
	    movwf 0x30

division_loop:
	    ; Clear carry bit
	    bcf STATUS, C
	
	    ; Shift left dividend and M
		rlf 0x2D, 1
		rlf 0x2E, 1
		
		; Check if carry bit is set
		btfsc STATUS, C
		    
		; If yes, set LSB in M
		bsf 0x2E, 0
		
		; Otherwise, no op
		nop
		
		; Subtract divisor from M and check if result is positive
		movf 0x21, W
		subwf 0x2E, W
		btfss STATUS, C     ; If carry bit is set, subtraction result is positive
		goto div_default
		
positive_result:
	    movf 0x21, W
	    subwf 0x2E
	    bsf 0x2D, 0     ; Set LSB of A
	    goto div_default

div_default:
	    decfsz 0x30     ; Decrement counter
	    goto division_loop

end