#include p18f87k22.inc
    global Multiply_8_16, arg_8, arg_16, arg_24, temp_1

mul_args    udata_acs
    arg_8       res 1
    arg_16      res 2
    arg_24	res 3
    temp_1	res 1

routines code
	
Multiply_8_16			; multiplies arg_8 with arg_16 and puts
				;the result in arg_24
	;Low_byte_multiplication
	movf	arg_8, W
	mulwf	low(arg_16)	; result in PRODH:PRODL
	movf	PRODL, W
	movwf	low(arg_24)
	movff	PRODH, temp_1
	movf	arg_8, W
	mulwf	high(arg_16)	; result in PRODH:PRODL
	;High_byte
	movf	temp_1, W
	addwf	PRODL, W	; i.e.: the end result stored in W
				; should have changed carry flag status
	movwf	high(arg_24)
	;Upper_byte
	movlw 0x00
	movwf	temp_1
	movf	PRODH, W
	addwfc	temp_1, W	; destination W
	movwf	upper(arg_24)
	return
end


