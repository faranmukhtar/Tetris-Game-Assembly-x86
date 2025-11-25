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

	call mapArray@0

gameloop:
	
	call updateGame

	mov eax, 100
	call Delay
	call checkGameOver@0
	cmp al, 1
	jne gameloop

	call endGame
	ret
startGame ENDP

; updates the game after each loop
updateGame PROC
	mov esi, OFFSET currentPieceCoordinates
	mov eax, currentPiece
	mov bx, 100
	xor edx, edx
	div bx
	inc eax
	call setBoardCoordinates@0

	call drawBoard@0

	mov esi, OFFSET currentPieceCoordinates
	mov al, 0
	call setBoardCoordinates@0

	mov esi, nextPiece
	mov eax, PIECE_SIZE
	mov ebx, nextRotation
	mul ebx
	add esi, eax
	call drawNextPiece@0

	call takeInput@0
	or al, 32

	mov ebx, OFFSET currentRotation
	push ebx
	mov ebx, OFFSET currentPiece
	push ebx
	mov ebx, OFFSET currentPieceCoordinates
	push ebx
	call rotatePiece@0
	add esp, 12

	mov esi, OFFSET currentPieceCoordinates
	call movePieceHorizontal@0

	mov esi, OFFSET currentPieceCoordinates
	mov eax, OFFSET currentPiece
	push eax
	mov eax, OFFSET nextPiece
	push eax
	mov eax, OFFSET currentRotation
	push eax
	mov eax, OFFSET nextRotation
	push eax
	call movePieceDown@0

	add esp, 16
	ret
updateGame ENDP

; Game over loop. Takes input to restart the game
endGame PROC
	call Clrscr
	gameLoop:
		call drawGameOver@0
		mov eax, 100
		call Delay
		jmp gameLoop
	ret
endGame ENDP
END