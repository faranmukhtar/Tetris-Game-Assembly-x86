MAP_ARRAY_ASM EQU 1
INCLUDE globals.inc

PUBLIC mapArray

.data
.code
; Turns array into coordinates of board array. esi contains source array and edi contains destination array
; Takes two parameters y stored in ebp + 8 and x stored in ebp + 12
mapArray PROC
	enter 0, 0
	mov ecx, PIECE_LENGTH

outerLoop:
	push ecx
	mov ecx, PIECE_LENGTH
	innerLoop:
		movzx eax, BYTE PTR pieceArray[esi]
		cmp eax, 0
		je end_conditional

		; computing y value
		mov eax, [esp]
		xor edx, edx
		sub eax, PIECE_LENGTH
		neg eax
		add eax, [ebp + 8]
		mov ebx, 10
		mul ebx

		; computing x value
		mov ebx, ecx
		sub ebx, PIECE_LENGTH
		neg ebx
		add ebx, [ebp + 12]

		; adding both to get the index of 1D board array
		add eax, ebx

		;storing
		mov [edi], eax
		mov eax, [edi]
		add edi, 4
		
	end_conditional:
		inc esi
		loop innerLoop
	pop ecx
	loop outerLoop
	leave
	ret
mapArray ENDP
END