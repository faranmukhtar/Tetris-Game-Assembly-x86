MAP_ARRAY_ASM EQU 1
INCLUDE globals.inc

PUBLIC mapArray
PUBLIC map_x
PUBLIC map_y

.data
	map_x DWORD SPAWN_X
	map_y DWORD SPAWN_Y
.code
; Turns array into coordinates of board array taking map_x and map_y as starting points. 
; esi contains index of piece array and edi contains the coordinate array which has to be returned
; returns eax 1 when array is successfully mapped else 0
mapArray PROC uses esi ebx ecx edx
	LOCAL arr:DWORD
	mov arr, esi

	mov ecx, PIECE_LENGTH

	; checks if the function is called upon rotation
	; if it is then its safety is first checked
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

		;should be y > 20
		cmp eax, 199
		jg fail

		; computing x value
		mov ebx, ecx
		sub ebx, PIECE_LENGTH
		neg ebx
		add ebx, map_x

		; should be within the range 0 <= x <= 9
		cmp ebx, 0
		jl fail
		cmp ebx, 9
		jg fail

		add eax, ebx

		; is safe when y < 0
		cmp eax, 0
		jl end_conditional1

		; checking for collision
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