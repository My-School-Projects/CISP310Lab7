.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	numberArray DWORD 25, 47, 15, 50, 32, 95 DUP (0)
	elementCount DWORD 5

.CODE
_MainProc PROC

; Find sum
	mov eax, 0					; sum = 0
	lea ebx, numberArray		; addr = &numberArray
	mov ecx, elementCount		; count = elementCount
	jecxz quit					; quit if no numbers

forCount1:
	add eax, [ebx]				; sum = sum + *addr
	add ebx, 4					; addr += 4
	loop forCount1				; while (count != 0)

; Find average
	cdq							; extend sum to QWORD
	idiv elementCount			; avg = sum / elementCount

; Add 10 to each array element below average
	lea ebx, numberArray		; addr = &numberArray
	mov ecx, elementCount		; count = elementCount
forCount2:
	cmp DWORD PTR[ebx], eax		; (*addr > avg) ?
	jnl endIfSmall				; continue if not less
	add DWORD PTR [ebx], 10		; *addr += 10

endIfSmall:
	add ebx, 4					; addr += 4
	loop forCount2				; while (count != 0)

quit:
	mov eax, 0					; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
