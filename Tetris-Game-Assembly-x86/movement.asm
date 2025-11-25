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

;esi has currentpiececordinates
movePieceHorizontal PROC uses eax
	LOCAL coordinateArray:DWORD, addNum:DWORD
	mov coordinateArray, esi
	mov ecx, TOTAL_COORDINATES
	call takeInput@0

	or al, 32
	
	cmp al , 'a'
	JE moveleft
	cmp al , 'd'
	JNE endfunc
	;Move right
	mov addNum, 1
	jmp end_condition
	moveleft:
		mov addNum, -1
	end_condition:
		mov edx, addNum
		addLoop:
			mov ebx , [esi]
			add ebx , edx
			mov [esi], ebx
			add esi, 4
		loop addLoop
			
	mov esi, coordinateArray
	mov edx, addNum
	call isSafe
	cmp eax , 1
	je endfunc

	mov ecx, TOTAL_COORDINATES
	mov esi, coordinateArray
	undo_loop:
		mov ebx, [esi]
		sub ebx, edx
		mov [esi], ebx
		add esi, 4
		loop undo_loop
	endfunc: 
	ret
movePieceHorizontal ENDP

; takes array coordinates in esi and shifts down
movePieceDown PROC uses ecx eax
	LOCAL coordinateArray:DWORD
	mov coordinateArray, esi
	mov ecx, TOTAL_COORDINATES
shiftLoop:
	call checkCollision
	cmp eax , 1
	je handleCollision
	mov eax, [esi]
	add eax, 10
	mov [esi], eax
	add esi, 4
loop shiftLoop
jmp endFunc

handleCollision:
	mov esi, coordinateArray

	mov eax, [ebp + 20]
	push eax
	mov eax, [ebp + 16]
	push eax
	mov eax, [ebp + 12]
	push eax
	mov eax, [ebp + 8]
	push eax
	call placePiece
	add esp, 16
endFunc:
	ret 

movePieceDown ENDP

; places the current piece.
placePiece PROC
	LOCAL coordinateArray:DWORD, currentPiece:DWORD, nextPiece:DWORD, currentRotation:DWORD, nextRotation:DWORD

	mov eax, [ebp + 8]
	mov nextRotation, eax
	mov eax, [ebp + 12]
	mov currentRotation, eax
	mov eax, [ebp + 16]
	mov nextPiece, eax
	mov eax, [ebp + 20]
	mov currentPiece, eax
	mov coordinateArray, esi

	mov ebx, currentPiece
	mov eax, [ebx]
	mov bx, 100
	xor edx, edx
	div bx
	inc eax
	mov ebx, eax

	mov ecx , TOTAL_COORDINATES
	placeLoop:
		mov eax , [esi]
		mov edi , OFFSET boardArray
		mov [edi + eax] , bl
		add esi , 4
	loop placeLoop

	mov eax, currentRotation
	mov edi, nextRotation
	mov ebx, [edi]
	mov [eax], ebx

	mov eax, currentPiece
	mov edi, nextPiece
	mov ebx, [edi]
	mov [eax], ebx


	call getRandomPiece@0
	mov eax, nextPiece
	mov [eax], esi
	mov eax, nextRotation
	mov [eax], edi
	
	mov eax, currentPiece
	mov esi, [eax]
	mov eax, PIECE_SIZE
	mov ecx, currentRotation
	mov ebx, [ecx]
	mul ebx
	add esi, eax

	mov edi, coordinateArray

	push SPAWN_X
	push SPAWN_Y
	call mapArray@0
	add esp, 8
	ret
placePiece ENDP

; grabs the rotated piece in the pieces array
rotatePiece PROC
rotatePiece ENDP


; takes current shape coordinates and checks if it is safe 
; assuming x and 
;coordinates are in esi next coordinates are in ebx
isSafe PROC uses ecx edx 
	mov ecx, TOTAL_COORDINATES
	cmp edx, 1
	je plus
	; minus:
		mov ebx, 9
		jmp end_condition
	plus:
		mov ebx, 0
	end_condition:
	checkLoop:
		mov eax, [esi]
		xor edx, edx
		mov di, 10
		div di
		mov eax, edx

		cmp eax, ebx
		je failed

		mov eax, [esi]
		movzx edx, BYTE PTR boardArray[eax]
		cmp edx, 1
		je failed

		add esi, 4
		loop checkLoop
	jmp success

	failed:
		mov eax, 0
		jmp end_func

	success:
		mov eax, 1

	end_func:
		ret
isSafe ENDP



; checks whether shape has collided with already placed shape
checkCollision PROC uses ebx ecx edx edi 
    mov ecx, TOTAL_COORDINATES
    mov edx, esi       

shiftLoop:
    mov ebx, [edx]                  
    add ebx, 10                     
    
    ; Check if coordinate is out of bounds (bottom of board)
    cmp ebx, BOARD_SIZE
    jge Collision                   
    
    ; Check if the position below is already occupied
    mov edi, OFFSET boardArray
    movzx eax, BYTE PTR [edi + ebx] 
    cmp eax, 0
    jne Collision                 
    
    add edx, 4                     
loop shiftLoop
    
    ; No collision detected
    mov eax, 0
    jmp endfunc
    
Collision:
    mov eax, 1
   
    
endfunc:
    ret
checkCollision ENDP
END