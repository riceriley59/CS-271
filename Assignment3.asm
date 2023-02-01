TITLE Program Assignment3   (Assignment3.asm)

; Author(s) : Riley Rice	Date : 1 - 31 - 2023
; Course: CS271
; Description: This program converts Miles to KM and farenheit into celcius
; It does this using the FPU, and so there will be float numbers displayed for
; the conversions with a certain precision. It will greet you, get the numbers
; you want to convert, calculate the conversions, display the conversions, and 
; then say goodbye to you.

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096			;SS register
ExitProcess proto, dwExitCode:dword

.data               ;DS register
     ;introduction
     uName BYTE 15 DUP(0)

     intro BYTE "Distance & Temperature Unit Conversion",0
     programmerIntro BYTE "Programmed by Riley Rice",0

     askForName BYTE "Hi, what's your name? ",0
     greeting BYTE "Hello, ",0

     ;getUserData
     askForMiles BYTE "Enter the distance in miles that you want to convert in kilometers: ",0
     askForFarenheit BYTE "Now enter the temperature in Fahrenheit that you want to convert in Celsius: ",0

     ;convertToKM
     miles DWORD ?
     kilometers REAL8 ?

     milesConversion REAL8 1.60934

     ;convertToCelcius
     celcius REAL8 ?
     farenheit DWORD ?

     five DWORD 5
     nine DWORD 9
     thirtytwo DWORD 32
     

     ;displayConvertedData
     beginning BYTE "The conversion of ",0
     kilometersMessage BYTE " miles in kilometers is: ",0
     celciusMessage BYTE " degrees farenheit in celcius is: ",0

     ;farewell
     certification BYTE "Results certified by Riley Rice",0
     goodbye BYTE "Goodbye, ",0

.code               ;CS register
main proc
     introduction:                 ;this handles introducting the user and getting their name which will also be used in the farewell
          ;display the title of program to the user
          mov EDX, OFFSET intro
          call WriteString
          call Crlf

          ;introduce my name and who it was programmed by
          mov EDX, OFFSET programmerIntro
          call WriteString
          call Crlf

          ;prompt the user for their name
          call Crlf
          mov EDX, OFFSET askForName
          call WriteString

          ;get the user's name and store it in uName
          mov EDX, OFFSET uName
          mov ECX, 15
          call ReadString

          ;now that we have their name we greet them and print that name out
          mov EDX, OFFSET greeting
          call WriteString
          mov EDX, OFFSET uName
          call WriteString
          call Crlf
          call Crlf

     getUserData:             ;This gets the units that the user wants to convert
          ;get the miles input from the user so we can convert it
          mov EDX, OFFSET askForMiles
          call WriteString
          call ReadInt
          mov miles, EAX
          
          ;get the farenheit input from the user so we can convert it
          mov EDX, OFFSET askForFarenheit
          call WriteString
          call ReadInt
          mov farenheit, EAX
          call Crlf

     convertToKM:             ;This handles converting the miles input to kilometers
          ;initialize the FPU
          FINIT

          ;push in miles and the miles conversion into the stack so they are the top two
          FILD miles
          FLD milesConversion

          ;multiply those two top values and put them on top of stack
          FMUL
          
          ;pop the top value from the stack which will be our converted kilometers
          FSTP kilometers

     convertToCelcius:             ;This handles converting the farenheit input to celcius
          ;push in the farenheit input and thirty two onto the stack
          FILD farenheit
          FILD thirtytwo
          
          ;then stubtract farenheit and thirty two since they will be the top two
          FSUB

          ;now push in five and nine onto the stack
          FILD five
          FILD nine
          
          ;then divide five and nine since they will be the top two
          FDIV

          ;at this point the results from our division and subtraction will be the top two 
          ;in the stack so when we call this multiply it will multiply those two together which 
          ;is what we want
          FMUL

          ;after the multiplication our converted result will be at the top of stack so we pop 
          ;that into our converted celcius
          FSTP celcius

     displayConvertedData:              ;This takes the data we just converted and displays it in a meaningful and concise way
          ;write beginning
          mov EDX, OFFSET beginning
          call WriteString
          
          ;write out our miles that we wanted to convert
          mov EAX, miles
          call WriteDec
          mov EDX, OFFSET kilometersMessage
          call WriteString
          
          ;load kilometers into stack so it's on top and then write it out so we can see the 
          ;converted value
          FLD kilometers
          call WriteFloat
          call Crlf

          ;print out beginning again
          mov EDX, OFFSET beginning
          call WriteString
          
          ;write out our farenheit that we wanted to convert
          mov EAX, farenheit
          call WriteDec
          mov EDX, OFFSET celciusMessage
          call WriteString
          
          ;load celcius into stack so it's on top and then write it out so we can see the 
          ;converted value
          FLD celcius
          call WriteFloat

          ;spacing
          call Crlf
          call Crlf

     farewell:                ;This prints out the certification of results then says goodbye to the user
          ;print out the certification of results
          mov EDX, OFFSET certification
          call WriteString
          call Crlf

          ;print out the goodbyte prompt
          mov EDX, OFFSET goodbye
          call WriteString

          ;follow that goodbye with their name
          mov EDX, OFFSET uName
          call WriteString
          call Crlf

     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main