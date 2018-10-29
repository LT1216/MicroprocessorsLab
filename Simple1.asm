	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern  LCD_Clear, LCD_To1stLine, LCD_To2ndLine ;external LCD subroutine part 2
	extern	LCD_Send_Byte_D, LCD_delay_x4us, LCD_delay_ms
	extern	KeyBoard_PressGet, KeyBoard_Setup, KeyBoard_Decode
	
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
	call LCD_Setup
	nop
	call KeyBoard_Setup
	nop
	
loopb	
	call KeyBoard_PressGet
	call KeyBoard_Decode
	movlw .250
	call LCD_delay_ms
	bra loopb
	

	end