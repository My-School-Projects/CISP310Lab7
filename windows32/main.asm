.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	; This is an unsigned problem. There are no negative numbers in this code.
	; The array elements will be bytes, because they will be ASCII coded strings.

		; This string will be used with the input macro to get a string from the user.
		; We will make it 40 characters long, because that seems reasonable.
		; We will actually need it to be 41 characters long, because the input macro will add a null terminator.
	inputStr BYTE 41 DUP ("x")

		; This string will serve as a prompt for getting input from the user.
		; It must be null-terminated because that is what the input macro expects.
	inputPrompt BYTE "Please enter a string. (Max 40 characters)", 0

		; This string will be used to output the count values
		; Each variable needs 11 characters because that's what dtoa gives
	outputStr		BYTE "The "
	charCountText	BYTE 11 DUP ("X")
					BYTE " characters in the string represent"
					BYTE 13, 10 ; CRLF
					BYTE 13, 10 ; CRLF
	upperCountText	BYTE 11 DUP ("X")
					BYTE " uppercase letters"
					BYTE 13, 10 ; CRLF
	lowerCountText	BYTE 11 DUP ("X")
					BYTE " lowercase letters"
					BYTE 13, 10 ; CRLF
	digitCountText	BYTE 11 DUP ("X")
					BYTE " digits"
					BYTE 13, 10 ; CRLF
	spaceCountText	BYTE 11 DUP ("X")
					BYTE " spaces"
					BYTE 13, 10 ; CRLF
	otherCountText	BYTE 11 DUP ("X")
					BYTE " other"
					BYTE 0						; null terminator


		; These numbers will track the numbers of different types of characters in inputStr
		; We're using bytes because the length of inputStr will not exceed 40 characters.
	lowerCaseCount BYTE 0
	upperCaseCount BYTE 0
	digitCount BYTE 0
	spaceCount BYTE 0
	otherCount BYTE 0

.CODE
_MainProc PROC
	

	; start at first character in inputStr
	; while (not past end of inputStr) {
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

	input inputPrompt, inputStr, 40	; read input from user into inputStr (max 40 characters)

	lea ebx, inputStr				; address of first byte of inputStr into ebx.
									; char := first character of inputStr
	mov edi, 0						; index := 0
countLoop:
	cmp BYTE PTR [ebx + 1*edi], 0	; char == 0?
	jz exitCountLoop				; quit upon reaching 0
	
	cmp BYTE PTR [ebx + 1*edi], "a"
	jb notLowerCase					; when char < "a", not lower case
	cmp BYTE PTR [ebx + 1*edi], "z"
	ja notLowerCase					; when char > "z", not lower case

	add lowerCaseCount, 1
	jmp continueCountLoop
notLowerCase:
	
	cmp BYTE PTR [ebx + 1*edi], "A"
	jb notUpperCase					; when char < "A", not upper case
	cmp BYTE PTR [ebx + 1*edi], "Z"
	ja notUpperCase					; when char > "Z", not upper case

	add upperCaseCount, 1
	jmp continueCountLoop
notUpperCase:

	cmp BYTE PTR [ebx + 1*edi], "0"
	jb notADigit					; when char < "0", not a digit
	cmp BYTE PTR [ebx + 1*edi], "9"
	ja notADigit					; when char > "9", not a digit

	add digitCount, 1
	jmp continueCountLoop
notADigit:
	
	cmp BYTE PTR [ebx + 1*edi], " "
	jne notASpace					; when char != " ", not a space

	add spaceCount, 1
	jmp continueCountLoop
notASpace:

	; If we get here, it is because the current character is not in any of the categories so far
	
	add otherCount, 1

continueCountLoop:
	add edi, 1						; char := next character
	jmp countLoop
exitCountLoop:

	; Convert values to text for output
	
	; edi started at 0 and incremented for each character.
	; It now holds the number of characters in the string.
	dtoa charCountText, edi
	mov eax, 0						; blank out eax
	mov al, lowerCaseCount
	dtoa lowerCountText, eax
	mov al, upperCaseCount
	dtoa upperCountText, eax
	mov al, digitCount
	dtoa digitCountText, eax
	mov al, spaceCount
	dtoa spaceCountText, eax
	mov al, otherCount
	dtoa otherCountText, eax

	; Display results, using inputStr as the window title
	output inputStr, outputStr

quit:
	mov eax, 0						; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
