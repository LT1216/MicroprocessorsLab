	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	call setup
	nop
	call read1


	
setup
	movlw	0x00
	movwf	TRISD, ACCESS	    ; setting Port D to output (control bus)
	movlw	0x55
	movwf	PORTD
	return
	
read1
	;databus to input
	bcf	PORTD, 0	    ; OE1 to zero
	bsf	PORTD, 1	    ; clock pulse pull up
	nop
	nop
	nop
	; pull Port E to register
	nop
	bcf	PORTD, 1	    ; clock pulse down
	bsf	PORTD, 0	    ; OE1 to one, output for chip turned off
	return
	
write1
	; databus to output
	; databus gets written value
	bsf	PORTD, 1	    ; clock pulse pull up
	nop
	nop
	nop
	nop
	bcf	PORTD, 1	    ; clock pulse down
	; databus to Tris state
	return
	
	
	end