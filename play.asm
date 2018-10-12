	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
    
	lfsr FSR0, feifh		    ; Loading fileregister 0
 
 
	movlw 0x0			    ; Start value-1 of written values
	movwf 0x1			    ; moving start value-1 to "to be written" space
 
	incf 0x1, f
	movff POSTINC0
 
 
	lfsr FSR1, hfhhf
 
	movlw 0x0
	movwf 0x2
 
	incf 0x2, f
	movfw 0x2
	cpfseq POSTINC1
	call ledpattern
 
 

