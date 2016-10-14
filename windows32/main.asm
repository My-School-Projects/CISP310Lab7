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

		; These numbers will track the numbers of different types of characters in the string
		; We're using words because the length of the string will not exceed 65535
	lowerCaseCount WORD 0
	upperCaseCount WORD 0
	digitCount WORD 0
	spaceCount WORD 0
	otherCount WORD 0

.CODE
_MainProc PROC
	

	; look for lowercase letters

	; start at first character in string
	; while (not past end of string) {
	;     if (current character is between "a" and "z" inclusive) {
	;	      count it as lowercase
	;     } else
	;     if (current character is between "A" and "Z" inclusive) {
	;	      count it as uppercase
	;     } else
	;     if (current character is between "0" and "9" inclusive) {
	;	      count it as a digit
	;     } else
	;     if (current character is a space) {
	;         count it as a space
	;     } else {
	;         count it as other
	;     }
	;     go to next character
	; }

	lea ebp, string				; address of first byte of string into EBP.
								; char := first character of string
countLoop:
	cmp BYTE PTR [ebp], 0		; char == 0?
	jz exitCountLoop			; quit upon reaching 0
		
	cmp BYTE PTR [ebp], "a"
	jb notLowerCase				; when char < "a", not lower case
	cmp BYTE PTR [ebp], "z"
	ja notLowerCase				; when char > "z", not lower case

	jmp isLowerCase
notLowerCase:
	
	cmp BYTE PTR [ebp], "A"
	jb notUpperCase				; when char < "A", not upper case
	cmp BYTE PTR [ebp], "Z"
	ja notUpperCase				; when char > "Z", not upper case

	jmp isUpperCase
notUpperCase:

	cmp BYTE PTR [ebp], "0"
	jb notADigit				; when char < "0", not a digit
	cmp BYTE PTR [ebp], "9"
	ja notADigit				; when char > "9", not a digit

	jmp isDigit
notADigit:
	
	cmp BYTE PTR [ebp], " "
	jne notASpace				; when char != " ", not a space

	jmp isSpace
notASpace:

	; If we get here, it is because the current character is not in any of the categories so far
	
	add otherCount, 1
	jmp continueCountLoop

isLowerCase:
	add lowerCaseCount, 1
	jmp continueCountLoop
isUpperCase:
	add upperCaseCount, 1
	jmp continueCountLoop
isDigit:
	add digitCount, 1
	jmp continueCountLoop
isSpace:
	add spaceCount, 1

continueCountLoop:
	add ebp, 1					; char := next character
	jmp countLoop
exitCountLoop:
	

quit:
	mov eax, 0					; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
