	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

	
start
	call SPI_MasterInit
	movlw 0xA3
	call SPI_MasterTransmit
	
	nop
	nop
	nop
	;delay?
	movlw 0xA4		    ; 2nd piece of data
	call SPI_MasterTransmit
	nop
	nop
	nop
	;delay?
	goto finish
setup
	movlw	0xFF		    ; determining delay start value
	movwf	0x1F		    ; position start value of delay decrement
	;movlw	0x10		    ; determining delay2 start value
	movwf	0x21		    ; position start value of delay2 decrement
	return
	
SPI_MasterInit ; Set Clock edge to positive
	bcf SSP2STAT, CKE 
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz) 
	movlw (1<<SSPEN)|(1<<CKP)|(0x02)
	movwf SSP2CON1 
	; SDO2 output; SCK2 output 
	bcf TRISD, SDO2 
	bcf TRISD, SCK2 
	return

SPI_MasterTransmit ; Start transmission of data (held in W) 
	movwf SSP2BUF 
Wait_Transmit ; Wait for transmission to complete 
	btfss PIR2, SSP2IF 
	bra Wait_Transmit 
	bcf PIR2, SSP2IF ; clear interrupt flag 
	return	
	
	
;delay subroutine argument at 0x20
delay	
	movff 0x1F , 0x20	    ; reloading the initial value of decrement	

delay_loop	decfsz 0x20	
	bra delay_loop	    ; reloading the initial value of decrement
	return
	
delay2	
	movff 0x21 , 0x22	    ; reloading the initial value of decrement	

delay2_loop	call delay
	decfsz 0x22	
	bra delay2_loop	    ; reloading the initial value of decrement
	return	
	
finish	
	end
