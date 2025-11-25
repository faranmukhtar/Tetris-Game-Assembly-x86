INPUT_ASM EQU 1
INCLUDE globals.inc

PUBLIC takeInput

.data
.code
; get input from the user. Might have to make another for input after game over

takeInput PROC uses edx
    ;mov edx, OFFSET Inputmsg
    ;call WriteString
    call ReadKey
    mov dl ,al          
    ret
takeInput ENDP

END