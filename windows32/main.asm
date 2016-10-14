.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	; This is an unsigned problem. There are no negative numbers in this code.
	; The array elements will be bytes, because they will be ASCII coded strings.

	; This string is null-terminated because it will be the destination of the input macro.
	; This is temporary, because it is currently hard-coded.

	string BYTE "This is a hard-coded example.", 0

	; This number will keep track of the number of lower case letters in the string
	lowerCaseCount WORD 0

.CODE
_MainProc PROC
	
	; for (int i = 0; string[i] != 0; i++) {
	;	if (string[i] >= "a" && string[i] <= "z") {
	;		lowerCaseCount += 1
	;	}
	;}


	lea ebp, string				; address of first byte of string into EBP.
								; i = 0
countLoop:
	cmp BYTE PTR [ebp], 0		; string[i] == 0?
	jz countLoopEnd				; quit upon reaching null
		
	cmp BYTE PTR [ebp], "a"
	jb notLowerCase				; jump if (string[i] < "a")
	cmp BYTE PTR [ebp], "z"
	ja notLowerCase				; jump if (string[i] > "z")

	add lowerCaseCount, 1		; lowerCaseCount += 1
notLowerCase:
	add ebp, 1					; i++
	jmp countLoop
countLoopEnd:
	

quit:
	mov eax, 0					; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
