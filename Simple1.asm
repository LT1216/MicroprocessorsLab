	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0xFF		    ; determining delay start value
	movwf	0x1F		    ; position start value of delay decrement
	;movlw  0x10		    ; determining delay2 start value
	movwf	0x21		    ; position start value of delay2 decrement
	
	movlw	0xFF		    
	movwf	TRISD, ACCESS	    ; Port D to input
	movff	PORTD, 0x05	    ; Getting port D value to storage
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	;movlw 	0x63
	call	delay2
	movf	PORTD, W, ACCESS				    
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
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
	
	
	end
