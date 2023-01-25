TITLE Program Assignment2(Assignment2.asm)

; Author(s) : Riley Rice	Date : 1 - 17 - 2023
; Course: CS271
; Description: 

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

.data               ;DS register
    ;introduction
    intro1 BYTE "Fibonacci Numbers",0
    intro2 BYTE "Riley Rice",0

    ;displaying instructions and getting user's name
    askForName BYTE "What's your name?: ",0
    hello BYTE "Hello, ",0
    instructions BYTE "Enter the number of Fibonacci terms to be displayed give the number as an integer in the range [1 .. 46].",0
    uName BYTE 15 DUP(0)

    ;displaying fibs
    temp DWORD ?
    spacing BYTE "   ",0

    ;get user data
    askForNumber BYTE "How many Fibonacci terms do you want? ",0
    out_of_range BYTE "That number is out of range enter a number in range [1 .. 46]",0
    fibNumbers DWORD ?

    ;farewell
    certification BYTE "Results certified by Riley Rice.",0
    goodbye BYTE "Goodbye, ",0

.code               ;CS register
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

    userInstructions:           ;This gets the user's name and then displays the instructions
        mov EDX, OFFSET askForName
        call WriteString
        
        mov EDX, OFFSET uName
        mov ECX, 15
        call ReadString
        
        mov EDX, OFFSET hello
        call WriteString
        mov EDX, OFFSET uName
        call WriteString
        call Crlf

        mov EDX, OFFSET instructions
        call WriteString
        call Crlf
        call Crlf

    getUserData:                ;This gets the amount of fib numbers that the user wants and validates that input
        mov EDX, OFFSET askForNumber
        call WriteString

        call ReadInt
        mov fibNumbers, EAX

        mov EAX, fibNumbers
        cmp EAX, 46
        JG error
        jmp out_of_error
        
        error:
            call Crlf
            mov EDX, OFFSET out_of_range
            call WriteString
            call Crlf
            call Crlf

            jmp getUserData
        out_of_error:
            cmp EAX, 1
            JL error

    displayFibs:                ;This will handle displaying the fib numbers
        call Crlf
        mov ECX, fibNumbers

        mov EAX, 1
        mov EBX, 1
        mov EDI, 0

        mov EDX, OFFSET spacing

        fibloop:
            call WriteDec
            call WriteString

            inc EDI

            cmp EDI, 5
            je newline
            jmp continue
            newline:
                call Crlf
                mov EDI, 0
            continue:

            mov temp, EBX
            add EBX, EAX
            mov EAX, temp

            loop fibloop

    farewell:                   ;This says goodbye to the user before ending the program
        call Crlf
        call Crlf
        mov EDX, OFFSET certification
        call WriteString
        call Crlf
        
        mov EDX, OFFSET goodbye
        call WriteString

        mov EDX, OFFSET uName
        call WriteString

     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main