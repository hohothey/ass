;--------------------------------------------
; 程序功能：求 1 + 2 + ... + 100，并输出结果5050
; 环境：MASM + DOSBox
;--------------------------------------------
data segment
    sum dw 0        ; 存放求和结果
    msg db 'Result: $'  ; 输出提示
data ends

code segment
assume cs:code, ds:data

start:
    mov ax, data
    mov ds, ax

    ;---------------------
    ; 1 + 2 + ... + 100
    ;---------------------
    mov cx, 100      ; 循环次数
    mov ax, 0        ; 累加器
    mov bx, 1        ; 当前加数

sum_loop:
    add ax, bx
    inc bx
    loop sum_loop

    mov sum, ax      ; 保存结果（5050）

    ;---------------------
    ; 输出结果
    ;---------------------
    mov dx, offset msg
    mov ah, 09h
    int 21h           ; 打印提示文字

    mov ax, sum       ; AX = 5050
    call PrintAX      ; 调用十进制输出过程

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
