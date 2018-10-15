	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0xFF		    ; determining delay start value
	movwf	0x1F		    ; position start value of delay decrement
	;movlw	0x10		    ; determining delay2 start value
	movwf	0x21		    ; position start value of delay2 decrement
	
	movlw	0x00		    
	movwf	TRISE, ACCESS	    ; Port E to output
	movwf	TRISF, ACCESS	    ; Port F to output
	
	movlw 	0x0		    ;counter begining
	bsf	PORTE, 0, ACCESS    ; initial clockpulse pull up
	bra 	test
loop	movff 	0x06, PORTF
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	call	delay2
	bcf 	PORTE, 0, ACCESS    ; clock pulse down
	nop			    ; cushion time for flop
	nop
	nop
	movf	0x1F, W, ACCESS	    ; data write out
	nop
	nop
	nop
	bsf	PORTE, 0, ACCESS    ; clockpulse pull up
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
