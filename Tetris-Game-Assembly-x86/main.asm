INCLUDE globals.inc

.data
	
.code
main PROC
	; temporary calling. startGame will be called here
	call startGame@0
	exit
main ENDP
END main