;--------------------------------------------
; 程序功能：用户输入一个 1~100 的数，求 1+2+...+n 并输出结果
; 环境：MASM + DOSBox
;--------------------------------------------
data segment
    msg1 db 'Enter a number (1-100): $'
    msg2 db 0Dh,0Ah,'Result: $'
    num dw 0
    sum dw 0
data ends

code segment
assume cs:code, ds:data

start:
    mov ax, data
    mov ds, ax

    ;---------------------
    ; 提示输入
    ;---------------------
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ;---------------------
    ; 输入一个或两个数字字符
    ;---------------------
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al        ; 第一个数字放 BL

    mov ah, 01h
    int 21h
    cmp al, 0Dh       ; 如果第二个是回车，说明只输入了一位数
    je one_digit

    sub al, '0'
    mov bh, al        ; 第二个数字放 BH
    mov al, bl
    mov ah, 0
    mov bl, 10
    mul bl            ; 第一位 ×10
    add ax, bx        ; 加上第二位
    jmp got_number

one_digit:
    mov ah, 0
    mov al, bl

got_number:
    mov num, ax       ; 保存输入的数字

    ;---------------------
    ; 求 1 + 2 + ... + n
    ;---------------------
    mov cx, ax        ; CX = n
    mov ax, 0         ; sum
    mov bx, 1

sum_loop:
    add ax, bx
    inc bx
    loop sum_loop
    mov sum, ax

    ;---------------------
    ; 输出结果
    ;---------------------
    mov dx, offset msg2
    mov ah, 09h
    int 21h

    mov ax, sum
    call PrintAX

    ;---------------------
    ; 程序结束
    ;---------------------
    mov ah, 4Ch
    int 21h

;---------------------------------
; 输出AX中的无符号整数（十进制）
;---------------------------------
PrintAX proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 0
    mov bx, 10

convert_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintAX endp

code ends
end start
