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

.data               ;DS register
     

.code               ;CS register

main proc
     

     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main