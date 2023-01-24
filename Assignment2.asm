TITLE Program Assignment2(Assignment2.asm)

; Author(s) : Riley Rice	Date : 1 - 17 - 2023
; Course: CS271
; Description: This displays my name and program title and then gets two numbers from
; users and then caclulates the sum, difference, product, integer quotient and remainder
; of the numbers then say goodbye. The first number must be bigger than the second number.

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

.data
    ;introduction
    intro1 BYTE "Fibonacci Numbers",0
    intro2 BYTE "Riley Rice",0

    ;displaying instructions and getting user's name
    askForName BYTE "What's your name?",0
    hello BYTE "Hello, ",0
    instructions BYTE "Enter the number of Fibonacci terms to be displayed give the number as an integer in the range [1 .. 46].",0

    ;get user data
    askForNumber BYTE "How many Fibonacci terms do you want?",0

    ;farewell
    certification BYTE "Results certified by Riley Rice.",0
    goodbye BYTE "Goodbye, ",0

.code
main proc
    introduction:				;This is the introduction section
		;display intro one prompt
		mov EDX, OFFSET intro1
		call WriteString
		call Crlf

        ;display intro two prompt
		mov EDX, OFFSET intro2
		call WriteString
		call Crlf
        call Crlf

    userInstructions:

    getUserData:

    displayFibs:

    farewell:

    ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main