INCLUDE globals.inc

.data
	
.code
main PROC
	; temporary calling. startGame will be called here	
	call GetMseconds            
    call Randomize
	mov eax, 10000
	call Delay
	call startGame@0
	exit
main ENDP		
END main