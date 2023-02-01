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
     askForCelcius BYTE "Now enter the temperature in Fahrenheit that you want to convert in Celsius: ",0

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
     introduction:
          mov EDX, OFFSET intro
          call WriteString
          call Crlf

          mov EDX, OFFSET programmerIntro
          call WriteString
          call Crlf

          call Crlf
          mov EDX, OFFSET askForName
          call WriteString

          mov EDX, OFFSET uName
          mov ECX, 15
          call ReadString

          mov EDX, OFFSET greeting
          call WriteString
          mov EDX, OFFSET uName
          call WriteString
          call Crlf
          call Crlf

     getUserData:
          mov EDX, OFFSET askForMiles
          call WriteString
          call ReadInt
          mov miles, EAX

          mov EDX, OFFSET askForCelcius
          call WriteString
          call ReadInt
          mov farenheit, EAX
          call Crlf

     convertToKM:
          FINIT

          FILD miles
          FLD milesConversion
          FMUL

          FSTP kilometers

     convertToCelcius:
          FILD farenheit
          FILD thirtytwo
          FSUB

          FILD five
          FILD nine
          FDIV

          FMUL

          FSTP celcius

     displayConvertedData:
          mov EDX, OFFSET beginning
          call WriteString
          
          mov EAX, miles
          call WriteDec
          mov EDX, OFFSET kilometersMessage
          call WriteString
          FLD kilometers
          call WriteFloat
          call Crlf

          mov EDX, OFFSET beginning
          call WriteString
          
          mov EAX, farenheit
          call WriteDec
          mov EDX, OFFSET celciusMessage
          call WriteString
          FLD celcius
          call WriteFloat
          call Crlf
          call Crlf

     farewell:
          mov EDX, OFFSET certification
          call WriteString
          call Crlf

          mov EDX, OFFSET goodbye
          call WriteString

          mov EDX, OFFSET uName
          call WriteString
          call Crlf

     ;end program and return 0 to operating system
	invoke ExitProcess, 0
main endp  ;end main process
end main 	;quit main