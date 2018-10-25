#include p18f87k22.inc


acs_kb udata_acs    
    rowcol	res 1	; reserve 1 byte for storing row and column
    

    constant key11
    constant key12
    constant key13
    constant key14
    constant key21
    constant key22
    constant key23
    constant key24
    constant key31
    constant key32
    constant key33
    constant key34
    constant key41
    constant key42
    constant key43
    constant key44
  
KeyBoard code
  
KeyBoard_Setup
    clrf    LATE	; getting rid of residuals
    setf    TRISE	; turning off drive on pins
    banksel PADCFG1	; PADCFG1 is not in Access Bank!!
    bsf	    PADCFG1, REPU, BANKED   ; PortE pull-ups on
    movlb   0x00	; set BSR back to Bank 0
    
KeyBoard_PressGet
    ; getting row
    movlw   0x0F	; turn latter 4 pins to output
    movwf   TRISE
    movff   PORTE, rowcol ; reading in value
    
    ; getting column
    movlw   0xF0	; turn first 4 bits to output
    movwf   TRISE
    movf    PORTE, W	; reading in value
    addwf   rowcol, f	; merge two readings
    
    negf    rowcol	; making up state as to pressed indicator
    return
    
KeyBoard_Decode
    movf    rowcol, W
    
    xorlw   key11
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
    
