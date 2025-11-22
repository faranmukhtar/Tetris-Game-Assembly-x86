MOVEMENT_ASM EQU 1
INCLUDE globals.inc

PUBLIC movePieceHorizontal
PUBLIC movePieceDown
PUBLIC placePiece
PUBLIC rotatePiece
PUBLIC isSafe
PUBLIC checkCollision

.data
	LEFT BYTE 'A'
	RIGHT BYTE 'D'
	msg1 BYTE "SAFE ",0
	msg2 BYTE "BLACK ",0
	movenum SDWORD 0
.code
; moves the current piece based on provided input

;esi has currentpiececordinates
movePieceHorizontal PROC uses eax
	mov ecx, TOTAL_COORDINATES
	call takeInput@0
	
	cmp al , 'A'
	JE moveleft
	cmp al , 'D'
	JNE endfunc
	;Move right
		Rightloop:
			xor ebx , ebx
			mov ebx , [esi]
			add ebx , 1
			
			call isSafe
			cmp eax , -1
			JE endfunc
			mov eax, [esi]
			add eax, 1
			mov [esi], eax
			add esi, 4
		loop Rightloop
			JMP endfunc
	moveleft:
		Leftloop:
			
			mov ebx , [esi]
			sub ebx , 1
			
			call isSafe
			cmp eax , -1
			JE endfunc
			
			mov eax, [esi]
			sub eax, 1
			mov [esi], eax
			add esi, 4
		loop Leftloop
	ret
	endfunc: 
	ret
movePieceHorizontal ENDP

; takes array coordinates in esi and shifts down
movePieceDown PROC uses ecx eax
	mov ecx, TOTAL_COORDINATES
shiftLoop:
	call checkCollision
	cmp eax , -1
	JE endfunc
	mov eax, [esi]
	add eax, 10
	mov [esi], eax
	add esi, 4
loop shiftLoop
endfunc:
	ret

movePieceDown ENDP

; places the current piece.
placePiece PROC uses esi edi ecx eax
	mov ecx , TOTAL_COORDINATES
	placeLoop:
		mov eax , [esi]
		mov edi , OFFSET boardArray
		mov BYTE PTR [edi + eax] , 1
		add esi , 4
		loop placeLoop
	ret
placePiece ENDP

; grabs the rotated piece in the pieces array
rotatePiece PROC
rotatePiece ENDP


; takes current shape coordinates and checks if it is safe 
; assuming x and 
;coordinates are in esi next coordinates are in ebx
isSafe PROC uses ecx  edx edi 
	
	mov eax , [esi]
	
	mov edi , 10
	div edi
	xor edx , edx
	
	call Crlf
	mov ecx , eax
	mov eax , ebx

	div edi
	
	call Crlf
	cmp eax , ecx 
	JNE notsafe

	
		mov eax , 1
		JMP endfunc
		notsafe:
			
			mov eax ,  -1
	endfunc:
	ret
isSafe ENDP



; checks whether shape has collided with already placed shape
checkCollision PROC uses ebx ecx edx edi 
    mov ecx, TOTAL_COORDINATES
    mov edx, esi       
	mov ebx , [edx]

    
shiftLoop:
    mov ebx, [edx]                  
    add ebx, 10                     
    
    ; Check if coordinate is out of bounds (bottom of board)
    cmp ebx, BOARD_SIZE
    jge Collision                   
    
    ; Check if the position below is already occupied
    mov edi, OFFSET boardArray
    movzx eax, BYTE PTR [edi + ebx] 

    cmp eax, 1
    je Collision                 
    
    add edx, 4                     
loop shiftLoop
    
    ; No collision detected
    mov eax, 1
    jmp endfunc
    
Collision:
    mov eax, -1
   
    
endfunc:
    ret
checkCollision ENDP
END