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

;constants
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
     

.code               ;CS register

; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
introductionProc proc
     pushad

     mov EDX, offset intro
     call WriteString
     call Crlf
     call Crlf

     popad
     ret
introductionProc endp


; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
getUserDataProc proc
     pushad

     mov EDX, OFFSET dataPrompt
     call WriteString

     call ReadInt
     mov userNumber, EAX
     call validate

     popad
     ret
getUserDataProc endp


; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
validate proc
     pushad

     cmp userNumber, MAX
     jg error
     jmp out_of_error

     error:
          mov EDX, OFFSET errorMessage
          call WriteString
          call Crlf
          call Crlf

          call getUserDataProc

     out_of_error:
          cmp userNumber, MIN
          jl error
     
     popad
     ret
validate endp


; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;    EC: Use prime divisors to check if the number is a composite
;**************************************************
isComposite proc
     pushad

     cmp testValue, 3
     jle returnFalse

     cmp testValue, 5
     je returnFalse

     cmp testValue, 7
     je returnFalse

     mov EBX, 0
     mov ESI, OFFSET primes

     divisors:
          mov EDX, 0
          mov EAX, testValue

          mov EBX, [ESI]

          cdq
          div EBX
          cmp EDX, 0
          jz returnTrue
          inc ESI
          mov EBX, [ESI]
          cmp EBX, 0
          je returnFalse
          jmp divisors

     returnFalse:
          popad
          mov EAX, 0
          jmp return

     returnTrue:
          popad
          mov EAX, 1
     
     return:
          ret
isComposite endp


; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
showComposites proc
     pushad
     call Crlf     

     mov ECX, userNumber
     mov ESI, 0

     showCompositesLoop:
          call isComposite

          cmp EAX, 1
          je print
          
          inc ECX
          jmp continue

          print:
               call printNum

               inc ESI
               cmp ESI, 10
               je newline
               jmp continue

               newline:
                    mov ESI, 0
                    call Crlf
          continue:
               inc testValue
               loop showCompositesLoop

     call Crlf
     call Crlf

     popad
     ret
showComposites endp

; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
printNum proc
     pushad

     cmp testValue, 10
     jl singleDigitPrint
     cmp testValue, 100
     jl twoDigitPrint
     cmp testValue, 1000
     jl threeDigitPrint

     singleDigitPrint:
          mov EAX, testValue
          call WriteDec

          mov EDX, OFFSET oneDigit
          call WriteString

          jmp return
     
     twoDigitPrint:
          mov EAX, testValue
          call WriteDec

          mov EDX, OFFSET twoDigit
          call WriteString

          jmp return
     
     threeDigitPrint:
          mov EAX, testValue
          call WriteDec

          mov EDX, OFFSET threeDigit
          call WriteString

     return:
          popad
          ret
printNum endp

; ***************************** MAIN *******************************
;
; main
;	Main function / driver of the program.
;	Receives: N/A
;	Returns:  N/A
;**************************************************
farewell proc
     pushad

     mov EDX, OFFSET goodbyeS
     call WriteString
     call Crlf

     popad
     ret
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
          call introductionProc

     getUserData:
          call getUserDataProc

     displayResults:
          call showComposites

     goodbye:
          call farewell


     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main