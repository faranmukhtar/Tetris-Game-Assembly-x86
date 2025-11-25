MAP_ARRAY_ASM EQU 1
INCLUDE globals.inc

PUBLIC mapArray
PUBLIC map_x
PUBLIC map_y

.data
	map_x DWORD SPAWN_X
	map_y DWORD SPAWN_Y
.code
; Turns array into coordinates of board array. esi contains source array and edi contains destination array
; Takes two parameters y stored in ebp + 8 and x stored in ebp + 12
mapArray PROC
	LOCAL arr:DWORD
	mov arr, esi

	mov ecx, PIECE_LENGTH

	mov eax, map_x
	cmp eax, SPAWN_X
	jne checkSafe
	mov eax, map_y
	cmp eax, SPAWN_Y
	jne checkSafe
	jmp mapLoop
checkSafe:
	push ecx
	mov ecx, PIECE_LENGTH
	innerLoop1:
		movzx eax, BYTE PTR pieceArray[esi]
		cmp eax, 0
		je end_conditional1

		; computing y value
		mov eax, [esp]
		xor edx, edx
		sub eax, PIECE_LENGTH
		neg eax
		add eax, map_y
		mov ebx, 10
		mul ebx

		cmp eax, 199
		jg fail

		; computing x value
		mov ebx, ecx
		sub ebx, PIECE_LENGTH
		neg ebx
		add ebx, map_x

		cmp ebx, 0
		jl fail
		cmp ebx, 9
		jg fail

		add eax, ebx

		cmp eax, 0
		jl end_conditional1

		movzx ebx, BYTE PTR boardArray[eax]
		cmp ebx, 0
		jne fail

	end_conditional1:
		inc esi
		loop innerLoop1
	pop ecx
	loop checkSafe

	mov esi, arr
	mov ecx, PIECE_LENGTH
mapLoop:
	push ecx
	mov ecx, PIECE_LENGTH
	innerLoop2:
		movzx eax, BYTE PTR pieceArray[esi]
		cmp eax, 0
		je end_conditional2

		; computing y value
		mov eax, [esp]
		xor edx, edx
		sub eax, PIECE_LENGTH
		neg eax
		add eax, map_y
		mov ebx, 10
		mul ebx

		; computing x value
		mov ebx, ecx
		sub ebx, PIECE_LENGTH
		neg ebx
		add ebx, map_x

		; adding both to get the index of 1D board array
		add eax, ebx

		;storing
		mov [edi], eax
		mov eax, [edi]
		add edi, 4
		
	end_conditional2:
		inc esi
		loop innerLoop2
	pop ecx
	loop mapLoop
	mov eax, 1
	jmp end_func
fail:
	mov eax, 0
end_func:
	ret
mapArray ENDP
END