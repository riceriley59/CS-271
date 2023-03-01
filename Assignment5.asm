TITLE Program Assignment5   (Assignment5.asm)

; Author(s) : Riley Rice	Date : 2-21-2023
; Course: CS271
; Description:  

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

;constants
MIN = 10
MAX = 200
LO = 100
HI = 999

.data               ;DS register
     ;introduction
     intro BYTE "Sorting Random Integers                                               Programmed by Riley Rice",0
     explanation BYTE "This program generates random numbers in the range [100 .. 999], displays the original list, sorts", 0 
     explanation2 BYTE "the list, and calculates the median value.  Finally, it displays the list sorted in descending order. ",0

     ;getData
     dataPrompt BYTE "How many numbers should be generated? [10 .. 200]: ",0
     errorPrompt BYTE "Invalid input, try again.",0

     ;displayMedian
     medianPrompt BYTE "The median is: ",0

     ;displayList
     unsortedPrompt BYTE "The unsorted random numbers are: ",0
     sortedPrompt BYTE "The sorted random numbers are: ",0
     space BYTE "  ",0
     
     ;farewell
     goodbyeS BYTE "Results certified by Riley Rice. Goodbye.",0

     ;array and requested size
     request DWORD 0
     array DWORD MAX DUP(?)


.code               ;CS register
; ***************************** INTRODUCTION *******************************
;
; introduction
;	This function writes out an introduction prompt to the user
;	Receives: N/A
;	Returns:  N/A
;**************************************************
introduction proc
     pushad

     mov EDX, OFFSET intro
     call WriteString
     call Crlf
     call Crlf

     mov EDX, OFFSET explanation
     call WriteString
     call Crlf

     mov EDX, OFFSET explanation2
     call WriteString
     call Crlf
     call Crlf

     popad
     ret
introduction endp

; ***************************** GETDATA *******************************
;
; getData
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
getData proc
     push EBP
     mov EBP, ESP

     pushad

     mov EBX, [EBP + 8]

     again:
          ;prompt the user for input
          mov EDX, OFFSET dataPrompt
          call WriteString

          ;get input from the user and store it into userNumber
          call ReadInt
          mov [EBX], EAX

          cmp EAX, MAX
          jg error
          jmp out_of_error

          ;the input isn't valid
          error:    
               ;output errormessage
               mov EDX, OFFSET errorPrompt
               call WriteString
               call Crlf
               call Crlf

               ;call getUserDataProc to get input from the user again and validate again
               jmp again

          ;check for other condition
          out_of_error:
               ;cmp user's number to the lower limit and if it's smaller
               ;then jump to error section otherwise end procedure
               cmp EAX, MIN
               jl error

     popad
     pop EBP ;restore registers
     ret 4;return to normal code execution
getData endp

; ***************************** GETDATA *******************************
;
; getData
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
fillArray proc
     push EBP
     mov EBP, ESP
     pushad

     mov ECX, [EBP + 8]
     mov ESI, [EBP + 12]

     loopF:
          mov EAX, HI
          sub EAX, LO
          inc EAX

          call RandomRange
          add EAX, LO
          mov [ESI], EAX
          add ESI, 4
          loop loopF

     popad
     pop EBP
     ret 8
fillArray endp

; ***************************** GETDATA *******************************
;
; getData
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
sortList proc
     push EBP
     mov EBP, ESP
     pushad

     mov ECX, [EBP + 8]
     dec ECX

     loop1:
          push ECX
          mov ESI, [EBP + 12]
     
     loop2:
          mov EAX, [ESI]
          cmp [ESI + 4], EAX
          jl noSwap
          xchg EAX, [ESI + 4]
          mov [ESI], EAX

     noSwap:
          add ESI, 4
          loop loop2
          pop ECX
          loop loop1

     popad
     pop EBP
     ret 8
sortList endp

; ***************************** GETDATA *******************************
;
; getData
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
displayMedian proc
     push EBP
     mov EBP, ESP
     pushad

     mov ESI, [EBP + 12]
     mov ECX, [EBP + 8]
     mov EDX, 0

     mov EAX, ECX
     mov ECX, 2
     cdq
     div ECX
     cmp ECX, 0
     je evenL
     jmp oddL

     evenL:
          mov EBX, 4
          mul EBX
          mov EBX, [ESI + EAX]

          sub EAX, 4
          mov EAX, [ESI + EAX]
          add EAX, EBX
          mov ECX, 2
          cdq
          div ECX
          jmp printMedian

     oddL:
          mov EBX, 4
          mul EBX
          mov EBX, [ESI + EAX]
          mov EAX, EBX

     printMedian:
          call Crlf
          mov EDX, OFFSET medianPrompt
          call WriteString
          call WriteDec
          call Crlf

     popad
     pop EBP
     ret 8
displayMedian endp

; ***************************** GETDATA *******************************
;
; getData
;	This function gets the data from the user and uses a validate helper procedure
;    to make sure that the data is valid
;	Receives: N/A
;	Returns:  Validated number in userNumber
;**************************************************
displayList proc
     push EBP 
     mov EBP, ESP
     pushad

     mov ESI, [EBP + 16]
     mov ECX, [EBP + 12]
     mov EBX, 0

     call Crlf
     mov EDX, [EBP + 8]
     call WriteString
     call Crlf

     printLoop:
          cmp EBX, 10
          je newLine

          mov EAX, [ESI]
          call WriteDec

          add ESI, 4
          mov EDX, OFFSET space
          call WriteString

          inc EBX

          loop printLoop
          jmp return

     newLine:
          call Crlf
          mov EBX, 0
          jmp printLoop

     return:
          call Crlf
          popad
          pop EBP
          ret 12
displayList endp

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
     call Crlf
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
     call Randomize

     introL:
          call introduction

     getDataL:
          push OFFSET request
          call getData

     fillArrayL:
          push OFFSET array
          push request
          call fillArray

     displayUnsorted:
          push OFFSET array
          push request
          push OFFSET unsortedPrompt
          call displayList

     sortListL:
          push OFFSET array
          push request
          call sortList

     displayMedianL:
          push OFFSET array
          push request
          call displayMedian

     displaySorted:
          push OFFSET array
          push request
          push OFFSET sortedPrompt
          call displayList

     farewellL:
          call farewell

     ;end program and return 0 to operating system
     invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main