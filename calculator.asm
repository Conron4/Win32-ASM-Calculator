section .data
    ; Messages displayed to the user
    startmessage: dw "Enter the mode(+ - / * sqrt): ", 0  ; Prompt for entering the calculation mode
    retcall: dw "Do you want another calculation(Y/N): ", 0  ; Prompt for another calculation
    num1: dw "Enter the first number: ", 0  ; Prompt for the first number
    num2: dw "Enter the second number: ", 0  ; Prompt for the second number
    num0: dw "Enter the number: ", 0  ; Prompt for a number (used in sqrt)
    formatin: db "%lf", 0  ; Format string for input as a double
    numout: db "Result: %lf", 10, 0  ; Output format string for displaying the result

    ; Variables for data storage
    start: dd 0 ; ;Selection Variable
    cint1: dq 0.0  ; Variable to store the first number for calculation
    cint2: dq 0.0  ; Variable to store the second number for calculation
    retr: dd 0  ; Variable to store the response for another calculation
    wordin: dd "%s", 0  ; Format string for input as a string
    clear_command: db "cls", 0  ; Command to clear the console

section .text
   global _main 
   extern _scanf 
   extern _printf
   extern _system

_clear_console:
    ; Function to clear the console
    pusha  ; Preserve registers
    push clear_command  ; Push the command to clear the console
    call _system  ; Call system to clear the console
    add esp, 4  ; Adjust the stack pointer after clearing
    popa  ; Restore the registers
    ret  ; Return

_main:
    call _clear_console  ; Clear the console
    mov esp, ebp  ; Set up stack frame
    push ebx ; Save registers
    push ecx

    ; Display the prompt for entering the calculation mode
    push startmessage  
    call _printf

    add esp, 4  ; Adjust the stack pointer

    push start  ; Push the start mode
    push wordin  ; Push the formatting
    call _scanf  ; Read the calculation mode input

    mov ebx, dword [start]  ; Move the input mode to ebx
    cmp ebx, '+'  ; Compare with signs and jump to appropriate function 
    je _add  
    cmp ebx, '-' 
    je _sub  
    cmp ebx, '*'  
    je _mul
    cmp ebx, '/' 
    je _div 
    cmp ebx, "sqrt"
    je _sqrt 
    ret  ; Return if none of the operations match

_io:
    ;function to handle input output
    push ebp ; save base pointer
    mov ebp, esp ; set stack frame

    push num1 ; push num1 data to stack
    call _printf ; print num1

    push cint1 ; push cint1 address
    push formatin ; push formatting
    call _scanf ; accept input

    push num2 ; repeat for number 2
    call _printf

    push cint2
    push formatin
    call _scanf

    movsd xmm0, qword [cint1] ; move cint1 & cint2 to xmm registers
    movsd xmm1, qword [cint2]
    mov esp, ebp ; restore stack
    pop ebp
    ret

_return:
    add esp, 4 ; adjust stack
    push retcall ; return text
    call _printf

    add esp, 4
    push retr ; return adress
    push wordin ; string formatting
    call _scanf

    add esp, 8
    movzx edx, byte [retr]
    cmp dl, 'Y' ; cmp for Y if true, goto main if anything else end
    je _main
    ret

_add:
    call _io ; call io function
    addsd xmm0, xmm1 ; double addition
    movsd qword [esp], xmm0 ; move to stack
    push numout ; formatting
    call _printf
    call _return ; call return function

_sub:
    call _io
    subsd xmm0, xmm1
    movsd qword [esp], xmm0
    push numout
    call _printf
    call _return

_mul:
    call _io
    mulsd xmm0, xmm1
    movsd qword [esp], xmm0
    push numout
    call _printf
    call _return

_div:
    call _io
    divsd xmm0, xmm1
    movsd qword [esp], xmm0
    push numout
    call _printf
    call _return

_sqrt:
    ;sqrt diffrent because it likes to be
    add esp, 8
    push num0 ; push num0 string 
    call _printf

    add esp, 4
    push cint1 ; variable adress
    push formatin ; formatting
    call _scanf
    movsd xmm0, qword [cint1] ; mov to xmm0 register

    add esp, 8
    sqrtsd    xmm0, xmm0 ; sqrt an store result in xmm0
    movsd qword [esp], xmm0 ; push to stack
    push numout ; formatting
    call _printf
    call _return
