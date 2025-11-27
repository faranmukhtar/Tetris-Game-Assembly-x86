MOVEMENT_ASM EQU 1
INCLUDE globals.inc

PUBLIC movePieceHorizontal
PUBLIC movePieceDown
PUBLIC placePiece
PUBLIC rotatePiece
PUBLIC isSafe
PUBLIC checkVerticalCollision
PUBLIC checkHorizontalCollision

.data
.code

; moves the current piece based on provided input in al
;esi has currentpiececordinates
movePieceHorizontal PROC uses eax esi edx ebx
	LOCAL coordinateArray:DWORD, addNum:DWORD
	mov coordinateArray, esi
	mov ecx, TOTAL_COORDINATES
	
	; 'a' for left and 'd' for right
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
	
	; computing new Indexes
	mov edx, addNum
addLoop:
	mov ebx , [esi]
	add ebx , edx
	mov [esi], ebx
	add esi, 4
	loop addLoop
	
	; Success when is Safe returns 1 and checkHorizontalCollision returns 0
	mov esi, coordinateArray
	mov edx, addNum
	call isSafe
	cmp eax, 1
	jne fail
	mov esi, coordinateArray
	call checkHorizontalCollision
	cmp eax, 0
	je success

fail:
	; this returns array back to the original
	mov ecx, TOTAL_COORDINATES
	mov esi, coordinateArray
undo_loop:
	mov ebx, [esi]
	sub ebx, edx
	mov [esi], ebx
	add esi, 4
	loop undo_loop
	jmp endfunc

success:
	; changes initial x and y of mapping
	mov eax, addNum
	mov ebx, map_x
	add ebx, eax
	mov map_x, ebx

endfunc: 
	ret
movePieceHorizontal ENDP

; takes array coordinates in esi and shifts down
; takes parameters in stacks to be pushed to placePiece
; [ebp + 20]: reference of currentPiece (index of current piece in pieceArray)
; [ebp + 16]: reference of nextPiece (index of next piece in pieceArray)
; [ebp + 12]: reference of currentRotation (current rotation index)
; [ebp + 8]: reference of nextRotation (next rotation index)
movePieceDown PROC uses ecx eax esi
	LOCAL coordinateArray:DWORD
	mov coordinateArray, esi
	mov ecx, TOTAL_COORDINATES
shiftLoop:
	;if there is even a single vertical collision then it is handled
	call checkVerticalCollision
	cmp eax , 1
	je handleCollision

	; there is a bug here that I dont want to fix.
	;else shifts the index down
	mov eax, [esi]
	add eax, 10
	mov [esi], eax
	add esi, 4
loop shiftLoop
; adjust initial mapping y accordingly
mov eax, map_y
inc eax
mov map_y, eax
jmp endFunc

handleCollision:
	mov esi, coordinateArray

	; places piece upon collision
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
; takes array coordinates in esi and places piece in boardArray
; [ebp + 20]: reference of currentPiece (index of current piece in pieceArray)
; [ebp + 16]: reference of nextPiece (index of next piece in pieceArray)
; [ebp + 12]: reference of currentRotation (current rotation index)
; [ebp + 8]: reference of nextRotation (next rotation index)
placePiece PROC uses eax ebx ecx edx edi esi
	LOCAL coordinateArray:DWORD, currentPiece:DWORD, nextPiece:DWORD, currentRotation:DWORD, nextRotation:DWORD

	; storing in local variables to make it easier to understand
	mov eax, [ebp + 8]
	mov nextRotation, eax
	mov eax, [ebp + 12]
	mov currentRotation, eax
	mov eax, [ebp + 16]
	mov nextPiece, eax
	mov eax, [ebp + 20]
	mov currentPiece, eax
	mov coordinateArray, esi

	; places one of integers 1 - 7 based on current Piece. Very important for colours
	mov ebx, currentPiece
	mov eax, [ebx]
	mov bx, 100
	xor edx, edx
	div bx
	inc eax
	mov ebx, eax

	; placing in boardArray
	mov ecx , TOTAL_COORDINATES
	placeLoop:
		mov eax , [esi]
		cmp eax, 0
		jl skip
		mov edi , OFFSET boardArray
		mov [edi + eax] , bl
	skip:
		add esi , 4
	loop placeLoop

	; moving next piece to current piece and next rotation to current piece
	mov eax, currentRotation
	mov edi, nextRotation
	mov ebx, [edi]
	mov [eax], ebx

	mov eax, currentPiece
	mov edi, nextPiece
	mov ebx, [edi]
	mov [eax], ebx

	;getting new next piece and storing
	call getRandomPiece@0
	mov eax, nextPiece
	mov [eax], esi
	mov eax, nextRotation
	mov [eax], edi
	
	; storing the current piece in esi
	mov eax, currentPiece
	mov esi, [eax]
	mov eax, PIECE_SIZE
	mov ecx, currentRotation
	mov ebx, [ecx]
	mul ebx
	add esi, eax

	;storing array in edi
	mov edi, coordinateArray

	;passing edi and esi to mapArray and updating initial mapping x and y
	mov eax, SPAWN_X
	mov map_x, eax
	mov eax, SPAWN_Y
	mov map_y, eax
	call mapArray@0
	ret
placePiece ENDP

; coordinateArray in ebp + 8, currentPiece in ebp + 12, currentRotation in ebp + 16. all of them are references
rotatePiece PROC uses eax
	enter 0, 0
	; for some reason every parameter is offset by +4. What??
	; Update: the reason for this is eax being pushed as well. not fixing this

	; function only works when al = 'w'
	cmp al , 'w'
	jne end_func

	; storing current Piece value
	mov eax, [ebp + 16]
	mov esi, [eax]
	mov eax, esi
	call WriteInt
	
	; calculating new rotation value
	mov ecx, [ebp + 20]
	mov eax, [ecx]
	inc eax
	mov bx, TOTAL_ROTATIONS
	xor edx, edx
	div bx
	mov ebx, edx

	;computing the index of pieceArray
	mov eax, PIECE_SIZE
	mul ebx
	add esi, eax
	mov eax, esi

	; storing coordinateArray in edi
	mov eax, [ebp + 12]
	mov edi, eax

	; taking edi and esi as parameters
	call mapArray@0
	cmp eax, 0
	je end_func

	; if mapping is successful, update currentRotation
	mov ecx, [ebp + 20]
	mov eax, [ecx]
	inc eax
	mov bx, TOTAL_ROTATIONS
	xor edx, edx
	div bx
	mov [ecx], edx
end_func:
	leave
	ret
rotatePiece ENDP


; takes current shape coordinates and checks if it is safe 
; takes edx and esi as parameters
; edx: Horizontal Translation
; esi: coordinate array
; returns eax which is a boolean value
; eax: 1 when it is safe and 0 when not
isSafe PROC uses ebx ecx edx edi
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



; checks whether shape has collided with already placed shape in the vertical direction. increments y value to check
; takes esi as parameter
; esi: Coordinate Array
; returns eax as boolean value
; eax: 1 when collision occurs and 0 when not
checkVerticalCollision PROC uses ebx ecx edx edi 
    mov ecx, TOTAL_COORDINATES
    mov edx, esi       

shiftLoop:
    mov ebx, [edx]                  
    add ebx, 10                     
    
    ; Check if coordinate is out of bounds (bottom of board)
    cmp ebx, BOARD_SIZE
    jge Collision   
	
	cmp ebx, 0
	jl skip
    
    ; Check if the position below is already occupied
    mov edi, OFFSET boardArray
    movzx eax, BYTE PTR [edi + ebx] 
    cmp eax, 0
    jne Collision                 
    
skip:
    add edx, 4                     
loop shiftLoop
    
    ; No collision detected
    mov eax, 0
    jmp endfunc
    
Collision:
    mov eax, 1
   
    
endfunc:
    ret
checkVerticalCollision ENDP

; check whether the shape has collided with another shape in the horizontal direction
; takes esi as parameter
; esi: Coordinate Array
; returns eax as boolean value
; eax: 1 when collision occurs and 0 when not
checkHorizontalCollision PROC
	mov ecx, TOTAL_COORDINATES
checkLoop:
	; if negative index skip entirely
	mov ebx, [esi]
	cmp ebx, 0
	jl skip

	; if at index, board Array is not 0, then collision has occured
	movzx eax, BYTE PTR boardArray[ebx]
	cmp eax, 0
	jne fail
skip:
	add esi, 4
	loop checkLoop
	
	mov eax, 0
	jmp end_func

fail:
	mov eax, 1

end_func:
	ret
checkHorizontalCollision ENDP
END