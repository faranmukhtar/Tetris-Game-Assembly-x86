GAME_ASM EQU 1
INCLUDE globals.inc

PUBLIC startGame

.data
	currentPiece DWORD ?									; contains index of current piece
	nextPiece DWORD ?										; contaisn index of next piece
	currentRotation DWORD ?									; 0 - 3 indicating index of rotated current shape
	nextRotation DWORD ?									; 0 - 3 indicating index of rotated next shape
	currentPieceCoordinates DWORD TOTAL_COORDINATES dup(?)	; indicating mapped coordinates of the piece
.code

; contains the game loop. also initializes everything before the loop
startGame PROC
	; getting and storing current and next piece
	call getRandomPiece@0
	mov currentPiece, esi
	mov currentRotation, edi

	call getRandomPiece@0
	mov nextPiece, esi
	mov nextRotation, edi
	
	; calculating index of piece array
	mov esi, currentPiece
	mov eax, PIECE_SIZE
	mov ebx, currentRotation
	mul ebx
	add esi, eax

	mov edi, OFFSET currentPieceCoordinates

	; taking esi and edi as parameters
	call mapArray@0

gameloop:
	call updateGame

	; delay slightly to make the game speed playable
	mov eax, 100
	call Delay

	; finishes game when checkGameOver returns 1
	call checkGameOver@0
	cmp al, 1
	jne gameloop

	call endGame
	ret
startGame ENDP

; updates the game after each loop
updateGame PROC
	; setting the board with index 1 - 7 where the current piece is supposed to be
	mov esi, OFFSET currentPieceCoordinates
	mov eax, currentPiece
	mov bx, 100
	xor edx, edx
	div bx
	inc eax
	call setBoardCoordinates@0

	call drawBoard@0

	; resetting to 0 to remove the currentPiece
	mov esi, OFFSET currentPieceCoordinates
	mov al, 0
	call setBoardCoordinates@0
	
	; computing index of next piece in piece array
	mov esi, nextPiece
	mov eax, PIECE_SIZE
	mov ebx, nextRotation
	mul ebx
	add esi, eax

	; taking esi as parameter
	call drawNextPiece@0

	; get input in al
	call takeInput@0
	
	; converting to lowercase letters
	or al, 32

	; pushing parameters
	mov ebx, OFFSET currentRotation
	push ebx
	mov ebx, OFFSET currentPiece
	push ebx
	mov ebx, OFFSET currentPieceCoordinates
	push ebx
	;takes al as parameter and stack parameters
	call rotatePiece@0
	; removing parameters
	add esp, 12

	mov esi, OFFSET currentPieceCoordinates
	; takes al and esi as parameters
	call movePieceHorizontal@0

	
	mov esi, OFFSET currentPieceCoordinates

	; pushing parameters
	mov eax, OFFSET currentPiece
	push eax
	mov eax, OFFSET nextPiece
	push eax
	mov eax, OFFSET currentRotation
	push eax
	mov eax, OFFSET nextRotation
	push eax

	; esi and stack parameters
	call movePieceDown@0

	; removing stack parameters
	add esp, 16

	; clear full lines if found
	call clearFullLines@0

	ret
updateGame ENDP

; Game over loop
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