SCORE_ASM EQU 1
INCLUDE globals.inc

PUBLIC score
public updateScore

.data
	score DWORD 0
.code
updateScore PROC
updateScore ENDP

; more functions should be added if required
END