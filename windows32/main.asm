.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	number1 DWORD 0
	number2 DWORD 0
	prompt1 BYTE "Enter first number x", 0
	prompt2 BYTE "Enter second number y", 0
	string BYTE 20 DUP (0)
	resultLabel BYTE "3 * x + 7 * y", 0
	result BYTE 11 DUP (0), 0

.CODE
_MainProc PROC

	; Get number1 from user
	input prompt1, string, 20
	atod string
	mov number1, eax

	; Get number2 from user
	input prompt2, string, 20
	atod string
	mov number2, eax

	push number2				; 2nd parameter
	push number1				; 1st parameter
	call func1					; func1(number1, number2)
	add esp, 8					; remove parameters from stack

	; Display result
	dtoa result, eax
	output resultLabel, result

	mov eax, 0					; exit with return code 0
	
	ret
_MainProc ENDP

; int func1 (int, int)
; returns 3 * x + 7 * y
func1 PROC
	
	push ebp					; save base pointer
	mov ebp, esp				; establish stack frame
	push ebx					; save ebx

	mov eax, [ebp+8]			; eax := x
	imul eax, 3					; eax := x * 3
	mov ebx, [ebp+12]			; ebx := y
	imul ebx, 7					; ebx := y * 7
	add eax, ebx				; eax := x * 3 + y * 7

	pop ebx						; restore ebx
	pop ebp						; restore base pointer

	ret							; return
func1 ENDP

END   ; end of source code
