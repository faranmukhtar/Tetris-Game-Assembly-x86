INPUT_ASM EQU 1
INCLUDE globals.inc

PUBLIC takeInput

.data
.code
; get input from the user.
takeInput PROC uses edx
    call ReadKey
    mov dl ,al          
    ret
takeInput ENDP

END