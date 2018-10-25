	#include p18f87k22.inc

	;extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	;extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	;extern  LCD_Clear, LCD_To1stLine, LCD_To2ndLine ;external LCD subroutine part 2
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	start

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.13	; length of data
	
main	code
	
start
	setf    TRISE	; turning off drive on pins
	banksel PADCFG1	; PADCFG1 is not in Access Bank!!
	bsf	PADCFG1, REPU, BANKED   ; PortE pull-ups on
	
	goto $
	
	end