TITLE Program Assignment1(Assignment1.asm)

; Author(s) : Riley Rice	Date : 1 - 17 - 2023
; Course: CS271
; Description: This displays my name and program title and then gets two numbers from
; users and then caclulates the sum, difference, product, integer quotient and remainder
; of the numbers then say goodbye

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;//SS register
ExitProcess proto, dwExitCode:dword

.data				;//DS register
	intro1 BYTE "Hi, this is Riley, and this is my assignment1 for CS271",0
	instructions BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder",0
	promptfirst BYTE "Enter first number: ",0
	promptsecond BYTE "Enter second number: ",0
	firstnumber DWORD ?
	secondnumber DWORD ?
	sum DWORD ?
	difference DWORD ?
	product DWORD ?
	quotient DWORD ?
	remainder DWORD ?
	summ BYTE "The sum is: ",0
	differencem BYTE "The difference is: ",0
	productm BYTE "The product is: ",0
	quotientm BYTE "The quotient is: ",0
	remainderm BYTE "The remainder is: ",0
	bye1 BYTE "Thanks for using my program! Have a nice day!",0
	EC2 BYTE "**EC: Program Verifies second number less than first",0
	numError BYTE "The Second Number must be less than the first!",0
	

.code				;//CS register
main proc
	Introduction:
		mov EDX, OFFSET intro1
		call WriteString
		call Crlf
				
		mov EDX, OFFSET EC2
		call WriteString
		call Crlf
		call Crlf

	GetNumbers:
		mov EDX, OFFSET instructions
		call WriteString
		call Crlf
		call Crlf

		mov EDX, OFFSET promptfirst
		call WriteString
		call ReadInt
		mov firstnumber, EAX
		call Crlf

		mov EDX, OFFSET promptsecond
		call WriteString
		call ReadInt
		mov secondnumber, EAX
		call Crlf

		mov EAX, firstnumber
		cmp EAX, secondnumber
		jle error
		jmp out_of_error
		error:
			mov EDX, OFFSET numError
			call WriteString
			call Crlf
			jmp Goodbye
		out_of_error:

	CalculateValues:
		mov EAX, firstnumber
		add EAX, secondnumber
		mov sum, EAX

		mov EAX, firstnumber
		mov EBX, secondnumber
		sub EAX, EBX
		mov difference, EAX 

		mov EAX, firstnumber
		mul secondnumber
		mov product, EAX

		mov EAX, firstnumber
		mov EBX, secondnumber
		cdq
		div EBX
		mov quotient, EAX
		mov remainder, EDX

	DisplayResults:
		mov EDX, OFFSET summ
		call WriteString
		mov EAX, sum
		call WriteDec
		call Crlf		

		mov EDX, OFFSET differencem
		call WriteString
		mov EAX, difference
		call WriteDec
		call Crlf
		
		mov EDX, OFFSET productm
		call WriteString
		mov EAX, product
		call WriteDec
		call Crlf

		mov EDX, OFFSET quotientm
		call WriteString
		mov EAX, quotient
		call WriteDec
		call Crlf
		
		mov EDX, OFFSET remainderm
		call WriteString
		mov EAX, remainder
		call WriteDec
		call Crlf		

	Goodbye:
		call Crlf
		mov EDX, OFFSET bye1
		call WriteString
		call Crlf

	invoke ExitProcess, 0
main endp
end main