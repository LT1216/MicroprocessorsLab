	#include p18f87k22.inc

	global KeyBoard_PressGet, KeyBoard_Setup, KeyBoard_Decode
	extern LCD_Send_Byte_D, LCD_delay_x4us
    
acs_kb	udata_acs    
rowcol	res 1	; reserve 1 byte for storing row and column


    constant notpressed= b'00000000'
    constant key11=  b'10001000'
    constant key12=  b'01001000'
    constant key13=  b'00101000'
    constant key14=  b'00011000'
    constant key21=  b'10000100'
    constant key22=  b'01000100'
    constant key23=  b'00100100'
    constant key24=  b'00010100'
    constant key31=  b'10000010'
    constant key32=  b'01000010'
    constant key33=  b'00100010'
    constant key34=  b'00010010'
    constant key41=  b'10000001'
    constant key42=  b'01000001'
    constant key43=  b'00100001'
    constant key44=  b'00010001'
  
KeyBoard code
  
KeyBoard_Setup
    clrf    LATE	; getting rid of residuals
    setf    TRISE	; turning off drive on pins
    banksel PADCFG1	; PADCFG1 is not in Access Bank!!
    bsf	    PADCFG1, REPU, BANKED   ; PortE pull-ups on
    movlb   0x00	; set BSR back to Bank 0
    clrf    rowcol
    return
    
KeyBoard_PressGet
    ; getting row
    movlw   0x0F	; turn latter 4 pins to output
    movwf   TRISE
    movff   PORTE, rowcol ; reading in value
    
    movlw .10		    ; delay to let the pull ups reach max value
    call LCD_delay_x4us
    
    ; getting column
    movlw   0xF0	; turn first 4 bits to output
    movwf   TRISE
    movf    PORTE, W	; reading in value
    addwf   rowcol, f	; merge two readings
    
    comf    rowcol, f	; making up state as to pressed indicator
    setf    TRISE	; turning off drive on pins
    
    return
    
KeyBoard_Decode
    movf    rowcol, W
    
    xorlw   notpressed
    btfsc   STATUS, Z
    goto    NoPress
    
    xorlw   key11^notpressed
    btfsc   STATUS, Z
    goto    Press11
    
    xorlw   key11^key12
    btfsc   STATUS, Z
    goto    Press12
    
    xorlw   key12^key13
    btfsc   STATUS, Z
    goto    Press13
    
    xorlw   key13^key14
    btfsc   STATUS, Z
    goto    Press14
    
    xorlw   key14^key21
    btfsc   STATUS, Z
    goto    Press21
    
    xorlw   key21^key22
    btfsc   STATUS, Z
    goto    Press22
    
    xorlw   key22^key23
    btfsc   STATUS, Z
    goto    Press23
    
    xorlw   key23^key24
    btfsc   STATUS, Z
    goto    Press24
    
    xorlw   key24^key31
    btfsc   STATUS, Z
    goto    Press31
    
    xorlw   key31^key32
    btfsc   STATUS, Z
    goto    Press32
    
    xorlw   key32^key33
    btfsc   STATUS, Z
    goto    Press33
    
    xorlw   key33^key34
    btfsc   STATUS, Z
    goto    Press34
    
    xorlw   key34^key41
    btfsc   STATUS, Z
    goto    Press41
    
    xorlw   key41^key42
    btfsc   STATUS, Z
    goto    Press42
    
    xorlw   key42^key43
    btfsc   STATUS, Z
    goto    Press43
    
    xorlw   key43^key44
    btfsc   STATUS, Z
    goto    Press44
    
    goto    InvalidPress
    
NoPress
    movlw 0x2D
    call LCD_Send_Byte_D
    return
    
Press11
    movlw 0x31
    call LCD_Send_Byte_D
    return
    
Press12
    movlw 0x32
    call LCD_Send_Byte_D
    return

Press13
    movlw 0x33
    call LCD_Send_Byte_D
    return

Press14
    movlw 0x46
    call LCD_Send_Byte_D
    return

Press21
    movlw 0x34
    call LCD_Send_Byte_D
    return

Press22
    movlw 0x35
    call LCD_Send_Byte_D
    return

Press23
    movlw 0x36
    call LCD_Send_Byte_D
    return

Press24
    movlw 0x45
    call LCD_Send_Byte_D
    return

Press31
    
    return

Press32
    
    return

Press33
    
    return

Press34
    
    return

Press41
    
    return

Press42
    
    return

Press43
    
    return

Press44
    ; stuff to do when
    return

InvalidPress
    movlw 0x58
    call LCD_Send_Byte_D
    return
    
end