bits 64
default rel

section .data
    msg_uso     db "Uso: ./line-calc [num1] [operador (+, -, *, /)] [num2]", 0xa, 0
    len_uso     equ $ - msg_uso
    msg_error   db "Error: Operador invalido o division por cero.", 0xa, 0
    len_error   equ $ - msg_error
    format_str  db "%ld", 0xa, 0

section .text
    global main
    extern atoi
    extern printf

main:
    cmp rdi, 4
    jl print_usage

    push rbx
    mov rbx, rsi

    ; --- 1. Convertir argv[1] (primer número) a entero ---
    mov rdi, [rbx + 8]
    call atoi
    push rax                   ; Guardamos temporalmente el num1 en la pila

    ; --- 2. Convertir argv[3] (segundo número) a entero ---
    mov rdi, [rbx + 24]
    call atoi
    mov r9, rax                ; r9 = num2

    pop r8                     ; Recuperamos el num1 desde la pila hacia r8

    ; --- 3. Obtener el operador de argv[2] ---
    mov rax, [rbx + 16]        ; argv[2]
    mov al, [rax]              ; al = operador (+, -, *, /)

    pop rbx

    ; --- 4. Evaluar qué operación hacer ---
    cmp al, '+'
    je do_add
    cmp al, '-'
    je do_sub
    cmp al, '*'
    je do_mul
    cmp al, '/'
    je do_div
    jmp error

do_add:
    mov rax, r8
    add rax, r9
    jmp print_result

do_sub:
    mov rax, r8
    sub rax, r9
    jmp print_result

do_mul:
    mov rax, r8
    imul rax, r9
    jmp print_result

do_div:
    cmp r9, 0
    je error
    mov rax, r8
    cqo
    idiv r9
    jmp print_result

print_result:
    mov rsi, rax               ; El resultado va a rsi para printf
    lea rdi, [format_str]      ; "%ld\n"
    xor rax, rax               ; 0 registros vectoriales
    call printf
    xor rax, rax
    ret

print_usage:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg_uso]
    mov rdx, len_uso
    syscall
    mov rax, 1
    ret

error:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg_error]
    mov rdx, len_error
    syscall
    mov rax, 1
    ret
