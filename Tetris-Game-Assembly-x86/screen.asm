
SCREEN_ASM EQU 1
INCLUDE globals.inc

PUBLIC drawBoard
PUBLIC drawNextPiece

.data
line BYTE 25 dup('-'), 0
startRow BYTE '</ ', 0
endRow BYTE '\>', 0
temp DWORD ?

.code
drawBoard PROC uses edx ecx eax esi
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET line
	call WriteString
	call Crlf

	mov ecx, BOARD_HEIGHT
	mov esi, 0
	rowLoop:
		mov edx, OFFSET startRow
		call WriteString
		mov temp, ecx
		mov ecx, BOARD_WIDTH

		colLoop:
			movzx eax, BYTE PTR boardArray[esi]
			call WriteDec
			mov al, ' '
			call WriteChar
			inc esi
			loop colLoop

		mov edx, OFFSET endRow
		call WriteString
		call Crlf
		mov ecx, temp
		loop rowLoop

	mov edx, OFFSET line
	call WriteString
	call Crlf
	ret
drawBoard ENDP

; takes next shape as parameter and displays it in a box.
; change cursor to achieve this


;esi has next piece
;eax has next rotation
drawNextPiece PROC uses ecx edx ebx 
	mov ecx , 25
	mul ecx
	add [esi] , eax

    mov ecx, 4          ; 4 blocks in piece

drawLoop:
    mov al, [esi]       ; get the value next piece
    add esi, 1

    cmp al, 0
    je skipBlock        ; skip empty blocks

    mov dh, 2           ; Y offset
    mov dl, 40          ; X offset
    call Gotoxy

    mov al, '1'       
    call WriteChar

skipBlock:
    loop drawLoop
    ret
drawNextPiece ENDP
END