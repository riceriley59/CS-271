TITLE Program Assignment4   (Assignment4.asm)

; Author(s) : Riley Rice	Date : 2-21-2023
; Course: CS271
; Description: This program will return all the composite numbers within the range that the 
; user gives, this is restricted to 1-400. It will first greet the user, get the input from the user,
; validate that input and keep on asking until a valid input is entered, print out all the composite numbers
; in that range, and then say a farewell to the user. This program will be decomposed into procedures, and 
; it's main reason is to learn how to use procedures effectively in MASM assembly. 

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

;constants that are used to define my upper and lower limits
MAX=400
MIN=1


.data               ;DS register
     ;introduction
     intro BYTE "Composite Numbers     Programmed by Riley Rice",0

     ;getUserData
     dataPrompt BYTE "Enter the number of composite numbers you would like to see (1 -- 400): ",0
     errorMessage BYTE "Out of Range. Try Again.",0
     userNumber DWORD ?

     ;showComposites
     testValue DWORD 1
     space BYTE " ",0
     primes DWORD 2, 3, 5, 7, 0

     ;numPadding
     threeDigit BYTE " ", 0
     twoDigit BYTE "  ", 0
     oneDigit BYTE "   ", 0

     ;farewell
     goodbyeS BYTE "Results certified by Riley Rice. Goodbye.",0

     ;EC prompts
     EC_align BYTE "**EC: Aligned columns.",0
     EC_prime_divisors BYTE "**EC: Checked against only prime divisors to find composites.",0

.code               ;CS register

; ***************************** INTRODUCTIONPROC *******************************
;
; introductionProc
;	This function writes out an introduction prompt to the user
;	Receives: N/A
;	Returns:  N/A
;**************************************************
introductionProc proc
     pushad ;save registers

     ;print out intro
     mov EDX, OFFSET intro
     call WriteString
     call Crlf
     call Crlf

     ;print out align columns extra credit prompt
     mov EDX, OFFSET EC_align
     call WriteString
     call Crlf

     ;print out prime divisors extra credit prompt
     mov EDX, OFFSET EC_prime_divisors
     call WriteString

     ;formatting
     call Crlf
     call Crlf

     popad ;restore registers
     ret ;return to normal code execution
introductionProc endp


; ***************************** GETUSERDATAPROC *******************************
;
; getUserDataProc
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
getUserDataProc proc
     pushad ;save registers

     ;prompt the user for input
     mov EDX, OFFSET dataPrompt
     call WriteString

     ;get input from the user and store it into userNumber
     call ReadInt
     mov userNumber, EAX
     
     ;call validate helper procedure to make sure the input is valid
     call validate

     popad ;restore registers
     ret ;return to normal code execution
getUserDataProc endp


; ***************************** VALIDATE *******************************
;
; validate
;	This function takes the input in userNumber and make sure that it's
;    within the MAX and MIN constants, thus validating the input.
;	Receives: userNumber
;	Returns: userNumber validated
;**************************************************
validate proc
     pushad ;save registers

     ;cmp users number to the upper limit and if its bigger then 
     ;jump into error section, otherwise jump out of error
     cmp userNumber, MAX
     jg error
     jmp out_of_error

     ;the input isn't valid
     error:    
          ;output errormessage
          mov EDX, OFFSET errorMessage
          call WriteString
          call Crlf
          call Crlf

          ;call getUserDataProc to get input from the user again and validate again
          call getUserDataProc

     ;check for other condition
     out_of_error:
          ;cmp user's number to the lower limit and if it's smaller
          ;then jump to error section otherwise end procedure
          cmp userNumber, MIN
          jl error
     
     popad ;restore registers
     ret ;return to normal code execution
validate endp


; ***************************** ISCOMPOSITE *******************************
;
; isComposite
;	This function returns 1 in EAX if the given number is a composite and 
;    0 if otherwise
;	Receives: number in testValue
;	Returns:  1 for composite and 0 for prime in EAX
;    EC: Use prime divisors to check if the number is a composite
;**************************************************
isComposite proc
     pushad ;save registers

     ;see if the number is below 3 in which it is prime
     cmp testValue, 3
     jle returnFalse

     ;see if the number is equal to 5 in which it is a prime
     cmp testValue, 5
     je returnFalse

     ;see if the number is equal to 7 in which it is a prime
     cmp testValue, 7
     je returnFalse

     ;set EBX to 0 and have ESI point to my prime divisor array
     mov EBX, 0
     mov ESI, OFFSET primes

     divisors:
          ;clear EDX register and move our value into EAX
          mov EDX, 0
          mov EAX, testValue

          ;store the current value getting pointed to in array into EBX
          mov EBX, [ESI]

          ;div our number in EAX with EBX our prime divisor
          cdq
          div EBX

          ;if the remainder is 0 meaning the number is divisble by the prime
          ;divisor then it is a composite number and so we will return true
          cmp EDX, 0
          jz returnTrue

          ;otherwise increment to next element in array and make sure that we arent 
          ;at the end by checking if the current value is equal to 0, that's the end 
          ;of our array, in which we would return false, otherwise jump back up to 
          ;divisors and check next divisor.
          inc ESI
          mov EBX, [ESI]
          cmp EBX, 0
          je returnFalse
          jmp divisors

     returnFalse:
          popad ; restore registers
          mov EAX, 0 ;put 0 in EAX(false)
          jmp return ;jump to return

     returnTrue:
          popad ; restore registers
          mov EAX, 1 ;put 1 in EAX(true)
     
     return:
          ret ;return to normal code execution
isComposite endp


; ***************************** SHOWCOMPOSITES *******************************
;
; showComposites
;	This loops through the numbers until it finds an amount of composite numbers
;    equal to what the user entered. It also handles printing out the number.
;	Receives: userNumber
;	Returns:  Prints to screen a list of composite numbers equal to userNumber
;**************************************************
showComposites proc
     pushad    ;save registers
     call Crlf     ;formatting

     ;store userNumber in the counter register and 0 in ESI to keep track 
     ;of when we need to print out a newline
     mov ECX, userNumber
     mov ESI, 0

     ;loop label
     showCompositesLoop:
          ;call isComposite procedure if the current number in 
          ;testValue is a composite then EAX will have 1
          call isComposite

          ;if the number is composite then print it
          cmp EAX, 1
          je print
          
          ;otherwise increment ECX because we only want the 
          ;ECX to increase when we find composites. This counteracts
          ;the loop call
          inc ECX

          ;then continue to next loop call
          jmp continue

          print:   
               ;call printNum procedure which handles formatting the numbers
               ;and prints them
               call printNum

               ;increment ESI for each composite
               inc ESI

               ;if we have printed 10 composites then restart ESI
               ;and print out a newline otherwise continue
               cmp ESI, 10
               je newline
               jmp continue

               newline:
                    mov ESI, 0
                    call Crlf
          continue:
               inc testValue ;increment testValue to go to next number for next loop
               loop showCompositesLoop ;loop

     ;formatting
     call Crlf
     call Crlf

     popad ;restore registers
     ret ;return to normal code execution
showComposites endp

; ***************************** PRINTNUM *******************************
;
; printNum
;	This takes a num and prints it to the screen with a buffer to keep 
;    all the numbers aligned within columns
;	Receives: value in testValue
;	Returns:  formatted testValue outputted to the Screen
;    EC: Align the output columns
;**************************************************
printNum proc
     pushad ;store registers

     ;if value is one digit then jump to singleDigitPrint
     cmp testValue, 10
     jl singleDigitPrint

     ;if value is two digits then jump to twoDigitPrint
     cmp testValue, 100
     jl twoDigitPrint

     ;if value is three digits then jump to threeDigitPrint
     cmp testValue, 1000
     jl threeDigitPrint

     singleDigitPrint:
          ;print number
          mov EAX, testValue
          call WriteDec

          ;print single digit buffer space
          mov EDX, OFFSET oneDigit
          call WriteString
          
          ;jump to end
          jmp return
     
     twoDigitPrint:
          ;print number
          mov EAX, testValue
          call WriteDec

          ;print double digit buffer space
          mov EDX, OFFSET twoDigit
          call WriteString

          ;jump to end
          jmp return
     
     threeDigitPrint:
          ;print number
          mov EAX, testValue
          call WriteDec

          ;print three digit buffer space
          mov EDX, OFFSET threeDigit
          call WriteString

     return:
          popad ;restore registers
          ret ;return to normal code execution
printNum endp

; ***************************** FAREWELL *******************************
;
; farewell
;	This prints out goodbye message to the user
;	Receives: N/A
;	Returns:  N/A
;**************************************************
farewell proc
     pushad ;save registers

     ;print out goodbye message
     mov EDX, OFFSET goodbyeS
     call WriteString
     call Crlf

     popad ;restore registers
     ret ;return to normal code execution
farewell endp


; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
main proc
     introduction:
          ;call intro procedure
          call introductionProc

     getUserData:   
          ;call procedure to get data
          call getUserDataProc

     displayResults:    
          ;display compsites based on that data
          call showComposites

     goodbye:
          ;call procedure to say goodbye to user
          call farewell


     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main