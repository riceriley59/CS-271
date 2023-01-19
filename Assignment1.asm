TITLE Program Assignment1(Assignment1.asm)

; Author(s) : Riley Rice	Date : 1 - 17 - 2023
; Course: CS271
; Description: This displays my name and program title and then gets two numbers from
; users and then caclulates the sum, difference, product, integer quotient and remainder
; of the numbers then say goodbye

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

.data				;DS register
	;create prompts for getting data
	intro1 BYTE "Hi, this is Riley, and this is my assignment1 for CS271",0
	instructions BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder",0
	promptfirst BYTE "Enter first number: ",0
	promptsecond BYTE "Enter second number: ",0

	;create doublewords for storing the numbers and all the appropriate data needed
	firstnumber DWORD ?
	secondnumber DWORD ?
	sum DWORD ?
	difference DWORD ?
	product DWORD ?
	quotient DWORD ?
	remainder DWORD ?

	;messages for displaying different values that were calculated
	summ BYTE "The sum is: ",0
	differencem BYTE "The difference is: ",0
	productm BYTE "The product is: ",0
	quotientm BYTE "The quotient is: ",0
	remainderm BYTE "The remainder is: ",0

	;different messages for saying goodbye, displaying extra credit, and displaying an error message
	bye1 BYTE "Thanks for using my program! Have a nice day!",0
	EC2 BYTE "**EC: Program Verifies second number less than first",0
	numError BYTE "The Second Number must be less than the first!",0
	

.code				;CS register
main proc ;start main process or the entry point for the program
	Introduction:				;This is the introduction section
		;display intro one prompt
		mov EDX, OFFSET intro1
		call WriteString
		call Crlf
				
		;display ec2 prompt
		mov EDX, OFFSET EC2
		call WriteString
		call Crlf
		call Crlf

	GetNumbers:					;this handles getting numbers from the user
		;display instructions prompt
		mov EDX, OFFSET instructions
		call WriteString
		call Crlf
		call Crlf

		;display promptfirst from the user and get the first number
		mov EDX, OFFSET promptfirst
		call WriteString
		call ReadInt ;read first number from the user and then store in EAX
		mov firstnumber, EAX ;move EAX into firstnumber
		call Crlf

		;display promptsecond from the user and get the second number
		mov EDX, OFFSET promptsecond
		call WriteString
		call ReadInt ;read second number from the user and then store in EAX
		mov secondnumber, EAX ;move EAX into secondnumber
		call Crlf

		;compare the first and second number and if the second number is greater than the first
		;then display error message and exit program otherwise continue
		mov EAX, firstnumber
		cmp EAX, secondnumber ;compare first and second number
		jle error ;if second number is greater than the first number then jump to error
		jmp out_of_error ;otherwise jump to out_of_error continuing program
		error: ;handles error
			;display error message
			mov EDX, OFFSET numError
			call WriteString
			call Crlf
			jmp Goodbye ;jump to goodbye outputting and end message and quitting program
 		out_of_error: ;this continues program if condition is met

	CalculateValues:			;this handles calculating all the values that we need
		;sum the two numbers together and then store in sum
		mov EAX, firstnumber 
		add EAX, secondnumber ;add second and first number
		mov sum, EAX ;move resultant variable into sum

		;subtract the two numbers and then store in difference
		mov EAX, firstnumber
		mov EBX, secondnumber
		sub EAX, EBX ;subtract the numbers and result will be stored in EAX
		mov difference, EAX  ;store EAX in difference
		
		;multiply the two numbers together
		mov EAX, firstnumber
		mul secondnumber ;multiply secondnumber with EAX which has firstnumber stored in it
		mov product, EAX ;store result of multiplcation in product

		;divide the two numbers and store the quotient and remainder
		mov EAX, firstnumber
		mov EBX, secondnumber
		cdq ;call cdq before div call, it's required
		div EBX ;div EAX and EBX, EAX is an implied operator
		mov quotient, EAX ;store the quotient that is stored into the EAX into quotient
		mov remainder, EDX ;store the remainder that is stored in the EDX into remainder

	DisplayResults:				;this handles displaying the results we just calculated
		;display sum message and the value we calculated
		mov EDX, OFFSET summ
		call WriteString
		mov EAX, sum ;move sum into EAX
		call WriteDec ;print sum
		call Crlf		

		;display difference message and the value we calculated
		mov EDX, OFFSET differencem
		call WriteString
		mov EAX, difference ;move difference into EAX
		call WriteDec ;print difference
		call Crlf
		
		;display product message and the value we calculated
		mov EDX, OFFSET productm
		call WriteString
		mov EAX, product ;move product into EAX
		call WriteDec ;print product
		call Crlf

		;display quotient message and the value we calculated
		mov EDX, OFFSET quotientm
		call WriteString
		mov EAX, quotient ;move quotient into EAX
		call WriteDec ;print quotient
		call Crlf
		
		;display remainder message and the value we calculated
		mov EDX, OFFSET remainderm
		call WriteString
		mov EAX, remainder ;move remainder into EAX
		call WriteDec ;print remainder
		call Crlf		

	Goodbye:			;this displays a goodbye message before ending program
		call Crlf
		mov EDX, OFFSET bye1 ;move bye1 string into EDX
		call WriteString ;write bye1 to screen
		call Crlf ;produce new line

	;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main
