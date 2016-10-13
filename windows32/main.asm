.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	

.CODE
_MainProc PROC

	

	mov eax, 0					; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
