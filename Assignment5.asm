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
; introduction
;	This function writes out an introduction prompt to the user
;	Receives: N/A
;	Returns:  N/A
;**************************************************
introduction proc
     pushad

     ;print intro prompt
     mov EDX, OFFSET intro
     call WriteString
     call Crlf
     call Crlf

     ;print first line of explanation
     mov EDX, OFFSET explanation
     call WriteString
     call Crlf

     ;print second line of explanation
     mov EDX, OFFSET explanation2
     call WriteString
     call Crlf
     call Crlf

     popad
     ret
introduction endp

; ***************************** GETDATA *******************************
; getData
;	This function gets the data from the user and makes sure that 
;    the entered data is valid. It then puts the validated data in 
;    passed in reference parameter
;	Receives: Dword paramter passed by reference
;	Returns:  Validated number in parameter
;**************************************************
getData proc
     ;set up base pointer
     push EBP
     mov EBP, ESP

     ;save registers
     pushad

     ;move request pointer into EBX
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

; ***************************** FILLARRAY *******************************
; fillArray
;	This function takes in an initialized size variable passed by value 
;    and an array passed by reference. It then fills the array of with 
;    random variables with the same size as the passed size parameter

;	Receives: dword array by reference and requested size by value
;	Returns:  array filled with the amount of random numbers as the size 
;          parameter
;**************************************************
fillArray proc
     ;set up base pointer
     push EBP
     mov EBP, ESP

     ;save all registers
     pushad

     ;store size of in ECX and array in ESI
     mov ECX, [EBP + 8]
     mov ESI, [EBP + 12]

     ;this is the loop that will loop size times
     loopF:    
          ;get the range plus one of the random number
          ;we want to generate
          mov EAX, HI
          sub EAX, LO
          inc EAX

          ;use randomrange to generate random number and add lo
          ;so the number is in range
          call RandomRange
          add EAX, LO

          ;move the random number into array and then increment to next
          ;array position
          mov [ESI], EAX
          add ESI, 4

          ;loop again until we have filled array size times
          loop loopF

     ;restore registers and return
     popad
     pop EBP
     ret 8
fillArray endp

; ***************************** SORTLIST *******************************
; sortList
;	This function takes a size of an array passed by value and an array 
;    passed by reference. It then takes that array and sorts it in descending
;    order. This is a bubble sort algorithm with n^2 time complexity.
;
;	Receives: size passed by value and array passed by reference
;	Returns:  array sorted in descending order
;**************************************************
sortList proc
     ;set up base pointer
     push EBP
     mov EBP, ESP

     ;save all registers
     pushad

     ;store size of array minus one in loop counter
     mov ECX, [EBP + 8]
     dec ECX

     ;this is the loop for the first number
     loop1:
          ;store ecx for outer loop and move array into ESI
          push ECX
          mov ESI, [EBP + 12]
     
     ;this is the loop for checking all the numbers
     loop2:
          ;mov value of current index of array into EAX
          ;then compare that to the next element into the array
          mov EAX, [ESI]

          ;if the next element is less than the current element
          ;then swap other values otherwise continue to next iteration
          cmp [ESI + 4], EAX
          jl noSwap
          xchg EAX, [ESI + 4]
          mov [ESI], EAX

     ;this handles decrementing our loops
     noSwap:
          ;go to next element then loop
          add ESI, 4
          loop loop2
          
          ;restore counter for outer loop and then loop
          ;again and continue with the new start as the next
          ;index
          pop ECX
          loop loop1

     ;restore registers
     popad
     pop EBP
     ret 8
sortList endp

; ***************************** DISPLAYMEDIAN *******************************
; displayMedian
;	This function takes an array by reference and a size for the array passed
;    by value. The list must be sorted, and if it is then this function will return 
;    and print out the median value of the array.
;
;	Receives: sorted array passed by reference and size of array passed by value
;	Returns:  median of given array
;**************************************************
displayMedian proc
     ;set up base pointer
     push EBP
     mov EBP, ESP

     ;save registers
     pushad

     ;put array in ESI and size in ECX
     mov ESI, [EBP + 12]
     mov ECX, [EBP + 8]

     ;clear EDX register since we will be dividing
     mov EDX, 0

     ;divide size by two
     mov EAX, ECX
     mov ECX, 2
     cdq
     div ECX

     ;if the remainder is 0 after dividing the size by two 
     ;then the array has even elements so jump to even, otherwise
     ;jump to odd
     cmp ECX, 0
     je evenL
     jmp oddL

     ;since it's even we need to take the two middle-most elements
     ;add them up and then divide them by two. At this point EAX
     ;should hold the index for the middle of the array
     evenL:   
          ;so we multiply EAX by 4 to get the offset for the element
          ;at that index and then store the value in EBX
          mov EBX, 4
          mul EBX
          mov EBX, [ESI + EAX]

          ;now we need to get the other element so we take the offset 
          ;we already calculated and subtract 4 to get the next higher 
          ;element since the array is sorted in descending order we then 
          ;store the other value in EAX
          sub EAX, 4
          mov EAX, [ESI + EAX]

          ;now we have the two middle-most elements so I add them together
          ;and divide them by two in order to get the median which will be in EAX
          add EAX, EBX
          mov ECX, 2
          cdq
          div ECX

          ;now that we have median in EAX jump to print median
          jmp printMedian

     ;since it's odd we just need the middle element which eax already
     ;holds the index to
     oddL:    
          ;multiply EAX by 4 to get the offset then store the value of that
          ;index into EAX
          mov EBX, 4
          mul EBX
          mov EBX, [ESI + EAX]
          mov EAX, EBX

     printMedian:
          ;print out median prompt and then the median which is in EAX
          call Crlf
          mov EDX, OFFSET medianPrompt
          call WriteString
          call WriteDec
          call Crlf

     ;restore registers and free stack
     popad
     pop EBP
     ret 8
displayMedian endp

; ***************************** DISPLAYLIST *******************************
; displayList
;	This function gets a size of an array passed by value and an array passed
;    by reference along with a title passed by reference. It will first print out 
;    the given title and then print out the given array to the screen in a clean 
;    format.
;
;	Receives: title and array passed by reference and size of array passed by value
;	Returns:  given array and title printed out to the screen in a clean format
;**************************************************
displayList proc
     ;set up base pointer
     push EBP 
     mov EBP, ESP

     ;save registers
     pushad

     ;store array in ESI and array size in ECX
     mov ESI, [EBP + 16]
     mov ECX, [EBP + 12]

     ;use EBX as counter to know when to print out newline character
     mov EBX, 0

     ;print out the title prompt
     call Crlf
     mov EDX, [EBP + 8]
     call WriteString
     call Crlf

     ;this is the loop which will print out the values in the array
     printLoop:
          ;check if we have printed 10 numbers in which we 
          ;need to print a new line
          cmp EBX, 10
          je newLine

          ;mov current index of array into EAX and then write to screen
          mov EAX, [ESI]
          call WriteDec

          ;increment to next element in array
          add ESI, 4

          ;print out a space to keep it formatted
          mov EDX, OFFSET space
          call WriteString

          ;increment EBX as we printed out a number
          inc EBX

          ;loop again with next index
          loop printLoop

          ;once we have looped through array return
          jmp return

     newLine:
          ;print out newline and reset EBX then jump back
          ;to the printLoop loop in order to keep printing
          call Crlf
          mov EBX, 0
          jmp printLoop

     return:
          ;restore registers and clean stack
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
     ;set seed for random number function
     call Randomize

     introL:
          ;call intro procedure
          call introduction

     getDataL:
          ;pass array size by reference then get validated
          ;input from user
          push OFFSET request
          call getData

     fillArrayL:
          ;push array and size then fill it with random values
          push OFFSET array
          push request
          call fillArray

     displayUnsorted:
          ;push array size and title to print out unsorted array
          push OFFSET array
          push request
          push OFFSET unsortedPrompt
          call displayList

     sortListL:
          ;pass array and size to sort the list in descending order
          push OFFSET array
          push request
          call sortList

     displayMedianL:
          ;pass array and size to calculate and print out the median
          ;of the array
          push OFFSET array
          push request
          call displayMedian

     displaySorted:
          ;pass array, it's size, and title in order to display 
          ;sorted array to screen
          push OFFSET array
          push request
          push OFFSET sortedPrompt
          call displayList

     farewellL:
          ;print out a farewell message
          call farewell

     ;end program and return 0 to operating system
     invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main