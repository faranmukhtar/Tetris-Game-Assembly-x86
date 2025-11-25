
SCREEN_ASM EQU 1
INCLUDE globals.inc

PUBLIC drawBoard
PUBLIC drawNextPiece
PUBLIC drawGameOver

.data
line BYTE 25 dup('-'), 0
startRow BYTE '</ ', 0
endRow BYTE '\>', 0
temp DWORD ?
tetrisColors BYTE 0BBh, 0EEh, 0DDh, 0AAh, 0CCh, 099h, 066h

gameOverText BYTE "  /$$$$$$                                           /$$$$$$                               ", 0Dh,0Ah
			 BYTE " /$$__  $$                                         /$$__  $$                              ", 0Dh,0Ah
			 BYTE "| $$  \__/  /$$$$$$  /$$$$$$/$$$$   /$$$$$$       | $$  \ $$ /$$    /$$ /$$$$$$   /$$$$$$ ", 0Dh,0Ah
			 BYTE "| $$ /$$$$ |____  $$| $$_  $$_  $$ /$$__  $$      | $$  | $$|  $$  /$$//$$__  $$ /$$__  $$", 0Dh,0Ah
			 BYTE "| $$|_  $$  /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$      | $$  | $$ \  $$/$$/| $$$$$$$$| $$  \__/", 0Dh,0Ah
			 BYTE "| $$  \ $$ /$$__  $$| $$ | $$ | $$| $$_____/      | $$  | $$  \  $$$/ | $$_____/| $$      ", 0Dh,0Ah
			 BYTE "|  $$$$$$/|  $$$$$$$| $$ | $$ | $$|  $$$$$$$      |  $$$$$$/   \  $/  |  $$$$$$$| $$      ", 0Dh,0Ah
			 BYTE " \______/  \_______/|__/ |__/ |__/ \_______/       \______/     \_/    \_______/|__/      ", 0

nextPieceLine BYTE 16 dup('-'), 0
startPiece BYTE "|| ", 0
endPiece BYTE " ||", 0
                                                                                          
                                                                                          
                                                                                          

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
			movzx ebx, BYTE PTR boardArray[esi]
			call getColor
			call SetTextColor
			cmp ebx, 0
			je print_0
			mov eax, ebx
			call WriteDec
			jmp end_condition
		print_0:
			mov al, ' '
			call WriteChar
		end_condition:
			mov al, ' '
			call WriteChar
			inc esi
			loop colLoop

		mov eax, white + (black SHL 4)
		call setTextColor
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

getColor PROC uses ebx
	dec ebx
	cmp ebx, 0
	jl not_in_range
	cmp ebx, 6
	jg not_in_range
	movzx eax, tetrisColors[ebx]
	jmp end_func
not_in_range:
	mov eax, white + (black SHL 4)
end_func:
	ret
getColor ENDP

;esi has next piece index
drawNextPiece PROC uses ecx edx ebx eax esi edi
	LOCAL x:BYTE, y:BYTE
	mov dl, 30
	mov dh, 8
	mov x, dl
	mov y, dh
	call Gotoxy

	mov edx, OFFSET nextPieceLine
	call WriteString

	mov dl, x
	mov dh, y
	inc dh
	mov y, dh
	call Gotoxy

    mov ecx, 5
	mov edi, 0
	outerLoop:
		mov edx, OFFSET startPiece
		call WriteString
		push ecx
		mov ecx, 5
		innerLoop:
			movzx ebx, BYTE PTR pieceArray[esi]
			call getColor
			call SetTextColor
			cmp ebx, 0
			je print_0
			mov eax, ebx
			call WriteDec
			jmp end_condition

		print_0:
			mov al, ' '
			call WriteChar

		end_condition:
			mov al, ' '
			call WriteChar
			inc esi

		loop innerLoop

		mov eax, white + (black SHL 4)
		call SetTextColor
		mov edx, OFFSET endPiece
		call WriteString
		mov dl, x
		mov dh, y
		inc dh
		mov y, dh
		call goToxy
		pop ecx

	loop outerLoop
	mov edx, OFFSET nextPieceLine
	call WriteString
	ret
drawNextPiece ENDP

drawGameOver PROC
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET gameOverText
	call WriteString
	ret
drawGameOver ENDP
END