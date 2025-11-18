MOVEMENT_ASM EQU 1
INCLUDE globals.inc

PUBLIC movePieceHorizontal
PUBLIC movePieceDown
PUBLIC placePiece
PUBLIC rotatePiece
PUBLIC isSafe
PUBLIC checkCollision

.data
.code
; moves the current piece based on provided input
movePieceHorizontal PROC			
movePieceHorizontal ENDP

; takes array coordinates in esi and shifts down
movePieceDown PROC uses ecx eax
	mov ecx, TOTAL_COORDINATES
shiftLoop:
	mov eax, [esi]
	add eax, 10
	mov [esi], eax
	add esi, 4
	loop shiftLoop

	ret

movePieceDown ENDP

; places the current piece.
placePiece PROC
placePiece ENDP

; grabs the rotated piece in the pieces array
rotatePiece PROC
rotatePiece ENDP

; takes current shape coordinates and checks if it is safe 
isSafe PROC
isSafe ENDP

; checks whether shape has collided with already placed shape
checkCollision PROC	
checkCollision ENDP
END