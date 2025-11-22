BOARD_STATE_ASM EQU 1        ; To avoid duplication
INCLUDE globals.inc

PUBLIC initializeBoard
PUBLIC setBoardCoordinates
PUBLIC boardArray

.data
boardArray BYTE BOARD_SIZE dup(0)

.code
; coordinates in esi and set value in al
setBoardCoordinates PROC uses ebx
	mov ecx, TOTAL_COORDINATES

setLoop:
	mov ebx, [esi]
	mov boardArray[ebx], al
	add esi, 4
loop setLoop
	ret
setBoardCoordinates ENDP

initializeBoard PROC uses ecx esi
	mov ecx, BOARD_SIZE
	mov esi, 0
	clearLoop:
		mov boardArray[esi], 0
		add esi, TYPE boardArray
	loop clearLoop
	ret
initializeBoard ENDP

END