	#include p18f87k22.inc

	;extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	;extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	;extern  LCD_Clear, LCD_To1stLine, LCD_To2ndLine ;external LCD subroutine part 2
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage

	constant    LCD_E=5	; LCD enable bit
    	constant    LCD_RS=4	; LCD register select bit
 
 
tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	start
	
main	code
	
start
	setf    TRISE	; turning off drive on pins
	banksel PADCFG1	; PADCFG1 is not in Access Bank!!
	bsf	PADCFG1, REPU, BANKED   ; PortE pull-ups on
	
loopb	
	movlw   0x0F	; turn latter 4 pins to output
	movwf   TRISE
	
	movlw .10
	call LCD_delay_x4us
	
	movlw   0xF0	; turn first 4 bits to output
	movwf   TRISE
	
	movlw .10
	call LCD_delay_x4us
	
	bra loopb
	
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return
    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return

	
	end