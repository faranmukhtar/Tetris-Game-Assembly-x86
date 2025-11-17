INCLUDE globals.inc

PUBLIC startGame
EXTERN drawBoard@0:PROC
EXTERN getRandomPiece@0:PROC

.data
	currentPiece DWORD ?					; contains address of current piece
	nextPiece DWORD ?						; contaisn address of next piece
	currentRotation DWORD ?					; 0 - 3 indicating index of rotated current shape
	nextRotation DWORD ?						; 0 - 3 indicating index of rotated next shape
	currentPieceCoordinates DWORD 4 dup(?)
.code
startGame PROC		; contains the game loop. also initializes everything before the loop

	call getRandomPiece@0
	mov currentPiece, esi
	mov currentRotation, edi

	call getRandomPiece@0
	mov nextPiece, esi
	mov nextRotation, edi

gameloop:

	call drawBoard@0

	mov eax, 100
	call Delay
	jmp gameloop

startGame ENDP

updateGame PROC		; updates the game after each loop
updateGame ENDP

endGame PROC		; Game over loop. Takes input to restart the game
endGame ENDP

checkGameOver PROC
checkGameOver ENDP
END