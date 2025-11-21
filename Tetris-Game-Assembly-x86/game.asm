GAME_ASM EQU 1
INCLUDE globals.inc

PUBLIC startGame

.data
	currentPiece DWORD ?									; contains index of current piece
	nextPiece DWORD ?										; contaisn index of next piece
	currentRotation DWORD ?									; 0 - 3 indicating index of rotated current shape
	nextRotation DWORD ?									; 0 - 3 indicating index of rotated next shape
	currentPieceCoordinates DWORD TOTAL_COORDINATES dup(?)
.code

; contains the game loop. also initializes everything before the loop
startGame PROC

	call getRandomPiece@0
	mov currentPiece, esi
	mov currentRotation, edi

	call getRandomPiece@0
	mov nextPiece, esi
	mov nextRotation, edi

	mov esi, currentPiece
	mov eax, PIECE_SIZE
	mov ebx, currentRotation
	mul ebx
	add esi, eax

	mov edi, OFFSET currentPieceCoordinates

	push SPAWN_X
	push SPAWN_Y
	call mapArray@0

gameloop:
	
	call updateGame

	mov eax, 100
	call Delay
	jmp gameloop

startGame ENDP

; updates the game after each loop
updateGame PROC
	mov esi, OFFSET currentPieceCoordinates
	mov al, 1
	call setBoardCoordinates@0

	call drawBoard@0
	mov eax , nextRotation
	mov esi , OFFSET nextPiece
	call drawNextPiece@0

	mov esi, OFFSET currentPieceCoordinates
	mov al, 0
	call setBoardCoordinates@0

	mov esi, OFFSET currentPieceCoordinates
	call movePieceHorizontal@0

	call movePieceDown@0
	mov esi, OFFSET currentPieceCoordinates
	call placePiece@0
	ret
updateGame ENDP

; Game over loop. Takes input to restart the game
endGame PROC
endGame ENDP
END