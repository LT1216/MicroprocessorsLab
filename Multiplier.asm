#include p18f87k22.inc
    global Multiply_8_16, arg_8, arg_16L, arg_16H, arg_24L, arg_24H, arg_24U, temp_1
    global arg1_16L, arg1_16H, arg2_16L, arg2_16H, arg_32L, arg_32H, arg_32U, arg_32UU, Multiply_16_16

mul_args    udata_acs
    arg_8	res 1
    arg_16L	res 1
    arg_16H	res 1
    arg_24L	res 1
    arg_24H	res 1
    arg_24U	res 1
    temp_1	res 1   ; thus far are the terms needed for Multiply_8_16
    arg1_16L	res 1
    arg1_16H	res 1
    arg2_16L	res 1
    arg2_16H	res 1
    arg_32L	res 1
    arg_32H	res 1
    arg_32U	res 1
    arg_32UU	res 1	; thus far are the terms needed for Multiply_16_16
	
routines code
	
Multiply_8_16			; multiplies arg_8 with arg_16 and puts
				; the result in arg_24
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

Multiply_16_16			; multiplies arg1_16 with arg2_16 and puts
				; the result in arg_32
	movff	arg1_16H, arg_16H   ; setting values for Multiply_8_16
	movff	arg1_16L, arg_16L
	movff	arg2_16L, arg_8
	call	Multiply_8_16	    ; result in arg_24
	movff	arg_24L, arg_32L
	movff	arg_24H, arg_32H
	movff	arg_24U, arg_32U    ; first multiplication done
	movff	arg2_16H, arg_8	    ; need to change only arg_8
	call	Multiply_8_16	    ; result in arg_24, second multiplication done
	movf	arg_24L, W
	addwf	arg_32H, F
	movf	arg_24H, W
	addwfc	arg_32U, F
	movf	arg_24U, W
	addwfc	arg_32UU, F	    ; result in arg_32
	return
	end


