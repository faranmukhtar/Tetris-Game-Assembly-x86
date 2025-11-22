LINES_ASM EQU 1
INCLUDE globals.inc

PUBLIC clearFullLines
PUBLIC checkFullLine
PUBLIC checkGameOver

.data
.code

;checks all lines from bottom to top and clears any full lines by shifting down
clearFullLines PROC uses eax ebx ecx edx esi edi
    mov ecx, BOARD_HEIGHT           
    mov edi, BOARD_HEIGHT          
    
    checkRowLoop:
        dec edi                      
    
        ;current row start (edi*board-width)
        mov eax, edi
        mov ebx, BOARD_WIDTH
        mul ebx
        mov esi, eax                  
    
        push ecx
        push edi
        call checkFullLine              
        pop edi
        pop ecx
    
        cmp al, 1                      
        jne notFullLine
    
        push ecx
        push edi
        call shiftRowsDown            
        pop edi
        pop ecx
    
        inc edi     
    
notFullLine:
    loop checkRowLoop
    
    ret
clearFullLines ENDP

;helper function to down shift
shiftRowsDown PROC uses eax ebx ecx esi edx
    cmp edi, 0                     
    je clearTopRow
    mov ecx, edi                    
    
shiftLoop:
    dec ecx                        
    
    ;current row 
    mov eax, ecx
    mov ebx, BOARD_WIDTH
    mul ebx
    mov esi, eax                 
    
    ;row below
    mov eax, ecx
    inc eax
    mov ebx, BOARD_WIDTH
    mul ebx
    mov edx, eax     
    
    ;move down by copying
    push ecx
    mov ecx, BOARD_WIDTH
    
copyRowLoop:
    mov al, boardArray[esi]
    mov boardArray[edx], al
    inc esi
    inc edx
    loop copyRowLoop
    
    pop ecx
    cmp ecx, 0
    jne shiftLoop
    
clearTopRow:
    ;clear row above
    mov ecx, BOARD_WIDTH
    mov esi, 0
    
clearTopLoop:
    mov boardArray[esi], 0
    inc esi
    loop clearTopLoop
    
    ret
shiftRowsDown ENDP

;al = 1 if line full, al = 0 if not full
checkFullLine PROC uses ecx ebx
    mov ecx, BOARD_WIDTH          
    mov ebx, esi        ;current position in row
    
checkLoop:
    movzx eax, BYTE PTR boardArray[ebx]
    cmp eax, 0                     
    je notFull             
    
    inc ebx
    loop checkLoop
    
    
    mov al, 1
    jmp checkLineDone   ;line full (returns 1 in al)
    
notFull:
    mov al, 0         ;line not full (returns 0 in al)
    
checkLineDone:
    ret
checkFullLine ENDP

;al = 1 if game over, al = 0 if not game over (if any block non zero = game over)
checkGameOver PROC uses ecx esi
    mov ecx, BOARD_WIDTH    
    mov esi, 0                   
    
checkTopRow:
    movzx eax, BYTE PTR boardArray[esi]
    cmp eax, 0                   
    jne gameOver                    
    
    inc esi
    loop checkTopRow
    
    mov al, 0
    jmp checkDone
    
gameOver:
    mov al, 1
    
checkDone:
    ret
checkGameOver ENDP

END