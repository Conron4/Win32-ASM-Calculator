section .data
    startmessage: dw "Enter the mode(+ - / * sqrt): ", 0
    retcall: dw "Do you want another calculation(Y/N): ", 0
    num1: dw "Enter the first number: ", 0
    num2: dw "Enter the second number: ", 0 
    num0: dw "Enter the number: ", 0 
    formatin: db "%lf", 0
    sqrti: db "%d", 0
    numout: db "Result: %lf", 10, 0
    start: dd 0 ; 32-bits integer = 4 bytes
    cint1: dq 0.0 
    cint2: dq 0.0 
    retr: dd 0  
    wordin: dd "%s", 0
    clear_command: db "cls", 0
section .text
   global _main 
   extern _scanf 
   extern _printf
   extern _system

_clear_console:
    pusha
    push clear_command
    call _system
    add esp, 4
    popa
    ret

_main:
    call _clear_console
    mov esp, ebp
    push ebx ; save registers
    push ecx
    push startmessage 
    call _printf

    add esp, 4 
    push start 
    push wordin 
    call _scanf
    mov ebx, dword [start]
    cmp ebx, '+'
    je _add
    cmp ebx, '-'
    je _sub
    cmp ebx, '*'
    je _mul
    cmp ebx, '/'
    je _div
    cmp ebx, "sqrt"
    je _sqrt
    ret
_io:
    push ebp
    mov ebp, esp
    push num1
    call _printf

    push cint1
    push formatin
    call _scanf

    push num2
    call _printf

    push cint2
    push formatin
    call _scanf

    movsd xmm0, qword [cint1]
    movsd xmm1, qword [cint2]
    mov esp, ebp
    pop ebp
    ret
_return:
    add esp, 4
    push retcall
    call _printf

    add esp, 4
    push retr
    push wordin
    call _scanf

    add esp, 8
    movzx edx, byte [retr]
    cmp dl, 'Y'
    je _main
    ret
_add:
    call _io
    addsd xmm0, xmm1
    movsd qword [esp], xmm0
    push numout
    call _printf
    call _return
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
    add esp, 8
    push num0
    call _printf

    add esp, 4
    push cint1
    push formatin
    call _scanf
    movsd xmm0, qword [cint1]

    add esp, 8
    sqrtsd    xmm0, xmm0
    movsd qword [esp], xmm0
    push numout
    call _printf
    call _return