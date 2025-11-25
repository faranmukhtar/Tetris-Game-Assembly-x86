INCLUDE globals.inc

.data
	
.code
main PROC
	; temporary calling. startGame will be called here	
	call GetMseconds            
    call Randomize
	call startGame@0
	exit
main ENDP		
END main