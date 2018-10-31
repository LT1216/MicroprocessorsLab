#include p18f87k22.inc
    global Multiply_8_16, arg_8, arg_16L, arg_16H, arg_24L, arg_24H, arg_24U, temp_1

mul_args    udata_acs
    arg_8   res 1
    arg_16L res 1
    arg_16H res 1
    arg_24L res 1
    arg_24H res 1
    arg_24U res 1
    temp_1  res 1

routines code
	
Multiply_8_16			; multiplies arg_8 with arg_16 and puts
				;the result in arg_24
	;Low_byte_multiplication
	movf	arg_8, W
	mulwf	arg_16L	; result in PRODH:PRODL
	movf	PRODL, W
	movwf	arg_24L
	movff	PRODH, temp_1
	movf	arg_8, W
	mulwf	arg_16H	; result in PRODH:PRODL
	;High_byte
	movf	temp_1, W
	addwf	PRODL, W	; i.e.: the end result stored in W
				; should have changed carry flag status
	movwf	arg_24H
	;Upper_byte
	movlw 0x00
	movwf	temp_1
	movf	PRODH, W
	addwfc	temp_1, W	; destination W
	movwf	arg_24U
	return
end


