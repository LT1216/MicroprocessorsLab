	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	clrf TRISC		    ; turn Port C to output
	
	call setup
	nop
	movlw 0xA3
	movwf databusadr
	call write1
	
	
	movlw 0x66		    ; change data to be sure that the original value is really stored in the chip
	movwf databusadr
	movff databusadr,PORTC
	
	call read1
	
	movff databusadr, PORTC
	nop
	nop
	nop
	nop
	goto 0x0
	
	constant databusadr=0x30    ; special register in ACCESS bank where
				    ; reads from and write to
	
setup
	clrf	TRISD, ACCESS	    ; setting Port D to output (control bus)
	movlw	0x55
	movwf	PORTD
	banksel PADCFG1		    ; PADCFG1 is not in Access Bank!! 
	bsf PADCFG1, REPU, BANKED   ; PortE pull-ups on 
	movlb 0x00		    ; set BSR back to Bank 0 
	setf	TRISE		    ; setting Port E to not driving state
	return
	
read1
	setf	TRISE		    ;databus to input
	bcf	PORTD, 0	    ; OE1 to zero
	bsf	PORTD, 1	    ; clock pulse pull up
	nop
	nop
	nop
	movff PORTE, databusadr	    ; pull Port E to register
	nop
	bcf	PORTD, 1	    ; clock pulse down
	bsf	PORTD, 0	    ; OE1 to one, output for chip turned off
	return
	
write1
	clrf TRISE		    ; databus to output
	movff databusadr, PORTE	    ; databus gets to be written value
	bsf	PORTD, 1	    ; clock pulse pull up
	nop
	nop
	nop
	nop
	bcf	PORTD, 1	    ; clock pulse down
	setf	TRISE		    ; databus to Tris state
	return
	
	
	
read2
	setf	TRISE		    ;databus to input
	bcf	PORTD, 2	    ; OE1 to zero
	bsf	PORTD, 3	    ; clock pulse pull up
	nop
	nop
	nop
	movff PORTE, databusadr	    ; pull Port E to register
	nop
	bcf	PORTD, 3	    ; clock pulse down
	bsf	PORTD, 2	    ; OE1 to one, output for chip turned off
	return
	
write2
	clrf TRISE		    ; databus to output
	movff databusadr, PORTE	    ; databus gets written value
	bsf	PORTD, 3	    ; clock pulse pull up
	nop
	nop
	nop
	nop
	bcf	PORTD, 3	    ; clock pulse down
	setf	TRISE		    ; databus to Tris state
	return
	
read3
	setf	TRISE		    ;databus to input
	bcf	PORTD, 4	    ; OE1 to zero
	bsf	PORTD, 5	    ; clock pulse pull up
	nop
	nop
	nop
	movff PORTE, databusadr	    ; pull Port E to register
	nop
	bcf	PORTD, 5	    ; clock pulse down
	bsf	PORTD, 4	    ; OE1 to one, output for chip turned off
	return
	
write3
	clrf TRISE		    ; databus to output
	movff databusadr, PORTE	    ; databus gets written value
	bsf	PORTD, 5	    ; clock pulse pull up
	nop
	nop
	nop
	nop
	bcf	PORTD, 5	    ; clock pulse down
	setf	TRISE		    ; databus to Tris state
	return	
	
read4
	setf	TRISE		    ;databus to input
	bcf	PORTD, 6	    ; OE1 to zero
	bsf	PORTD, 7	    ; clock pulse pull up
	nop
	nop
	nop
	movff PORTE, databusadr	    ; pull Port E to register
	nop
	bcf	PORTD, 7	    ; clock pulse down
	bsf	PORTD, 6	    ; OE1 to one, output for chip turned off
	return
	
write4
	clrf TRISE		    ; databus to output
	movff databusadr, PORTE	    ; databus gets written value
	bsf	PORTD, 7	    ; clock pulse pull up
	nop
	nop
	nop
	nop
	bcf	PORTD, 6	    ; clock pulse down
	setf	TRISE		    ; databus to Tris state
	return
	
	end