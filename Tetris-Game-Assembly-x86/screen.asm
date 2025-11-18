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
drawBoard PROC
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
drawNextPiece PROC 
drawNextPiece ENDP
END