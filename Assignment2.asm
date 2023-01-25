TITLE Program Assignment2   (Assignment2.asm)

; Author(s) : Riley Rice	Date : 1 - 17 - 2023
; Course: CS271
; Description: This program asks the user for the amount of fibonacci numbers the user wants and then prints that out for them. 
; First it will get the user's name then greets them. After doing that it displays instructions. After displaying
; the instructions it prompts the user for input, they must enter a number between 1 and 46. It will keep on prompting the user 
; for input until they enter a valid input. Then the program will print out the amount of fibonacci numbers as the user specified 
; before with their validated input. It will then say goodbye and end the program. 

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
        ;prompt the user to ask for name
        mov EDX, OFFSET askForName
        call WriteString
        
        ;read in the string provided into the uName BYTE array
        mov EDX, OFFSET uName
        mov ECX, 15
        call ReadString
        
        ;print out hello and then thier name that we just got
        mov EDX, OFFSET hello
        call WriteString
        mov EDX, OFFSET uName
        call WriteString
        call Crlf

        ;print out the instructions for the user
        mov EDX, OFFSET instructions
        call WriteString
        call Crlf
        call Crlf

    getUserData:                ;This gets the amount of fib numbers that the user wants and validates that input
        ;ask the user for a number specifyin how long they want the fibonacci sequence to continue
        mov EDX, OFFSET askForNumber
        call WriteString
        
        ;read in the input from the user and store it in the DWORD fibnumbers
        call ReadInt
        mov fibNumbers, EAX

        ;make sure that the number that the user provided isn't greater than 46 and if it is then jump to an error 
        ;section which will print an error message and reprompt the user otherwise jump to another check to make 
        ;sure the number isn't less than one in which case it will jump to an error section and reprompt the user.
        ;if the number is less than 47 and greater than 0 then the program will continue normal execution.
        mov EAX, fibNumbers
        cmp EAX, 46
        JG error
        jmp out_of_error
        
        ;error section: reprompts user by jumping to top of this section
        error:
            call Crlf
            mov EDX, OFFSET out_of_range
            call WriteString
            call Crlf
            call Crlf

            jmp getUserData
        ;second check for user input validation
        out_of_error:
            cmp EAX, 1
            JL error

    displayFibs:                ;This will handle displaying the fib numbers
        ;move the number we just error checked above into the loop counter
        call Crlf
        mov ECX, fibNumbers

        ;initialize some registers so that I can print out the fibonacci numbers correctly
        ;and so that I can make a new line every 5 iterations
        mov EAX, 1
        mov EBX, 1
        mov EDI, 0

        ;load spacing byte string into EDX so every iteration I can print out some spacing between
        ;the current number and other numbers
        mov EDX, OFFSET spacing

        ;start loop which will run the amount of times that the user gave and will print out a fibonacci number 
        ;write some spaces for formatting and then change the registers around accordingly to get ready for the 
        ;next number. Every 5 iterations a new line will be printed.
        fibloop:
            ;call current fibonacci number, stored in EAX. Also write out a few spaces which are stored in EDX
            call WriteDec
            call WriteString

            ;increment EDI to keep track of how many iterations so we know when to do a new line
            inc EDI

            ;if this is the fifth iteration then print out a newline and restart our counter
            cmp EDI, 5
            je newline
            jmp continue
            newline:
                call Crlf
                mov EDI, 0
            continue:

            ;store the old large number in temp then add EBX and EAX and store that in EBX becuase
            ;that will be our new large number and then update EAX with EBX's old value
            mov temp, EBX
            add EBX, EAX
            mov EAX, temp

            ;keep on looping until ECX equals zero. So run the amount of times that user gave
            loop fibloop

    farewell:                   ;This says goodbye to the user before ending the program
        ;print out who certified the results
        call Crlf
        call Crlf
        mov EDX, OFFSET certification
        call WriteString
        call Crlf

        ;print out a goodbye
        mov EDX, OFFSET goodbye
        call WriteString

        ;and then write their name that we got earlier it will look like: Goodbye, uNAME
        mov EDX, OFFSET uName
        call WriteString

     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main