	; Description of what the code does:
	;   1. define label myArray in RAM, with 0x80 bytes of memory
	;   2. in program memory write the message "Hello World!\n", with label myTable
	;   3. FSR0 pointing at myArray address
	;   4. point the TBLPTR to program memory location of myTable
	;   5. copy myTable message, byte by byte, to myArray
	;   6. display msg on both lines of LCD.
	;   7. send message to UART interface
	
	
	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern  LCD_Clear, LCD_To1stLine, LCD_To2ndLine ;external LCD subroutine part 2
	extern	LCD_Write_Hex			    ; external LCD subroutines	for ADC
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	Multiply_8_16, arg_8, arg_16L, arg_16H, arg_24L, arg_24H, arg_24U, temp_1
	extern	arg1_16L, arg1_16H, arg2_16L, arg2_16H, arg_32L, arg_32H, arg_32U, arg_32UU, Multiply_16_16, Multiply_8_24
	extern	Hex_Dec_converter, MyHexL, MyHexH, MyDecL, MyDecH
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.13	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	goto	start2
	
	; ******* Main programme ****************************************
start1 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	call	LCD_Write_Message
	
	call	LCD_To2ndLine
	
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	call	LCD_Write_Message

	movlw	myTable_l	; output message to UART
	lfsr	FSR2, myArray
	call	UART_Transmit_Message
	;*********Some code to test multiplier subroutine********************
	; use debugger and see that it works using memory registers for MyDecH:MyDecL
start2	
	movlw	0x06
	movwf	MyHexH
	movlw	0x3f
	movwf	MyHexL
	nop
	nop
	call	Hex_Dec_converter
	nop
	
measure_loop
	nop
	call	ADC_Read
	movff	ADRESH, MyHexH
	movff	ADRESL, MyHexL
	
	call	LCD_To1stLine
	movf	MyHexH, W
	call	LCD_Write_Hex
	movf	MyHexL, W
	call	LCD_Write_Hex

	call	LCD_To2ndLine
	call	Hex_Dec_converter
	movf	MyDecH, W
	call	LCD_Write_Hex
	movf	MyDecL, W
	call	LCD_Write_Hex
	
	goto	measure_loop		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	
	return

	end
