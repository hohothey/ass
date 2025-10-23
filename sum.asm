;--------------------------------------------
; 程序功能：用户输入一个 1~100 的数，求 1+2+...+n 并输出结果
;            同时演示结果存放在寄存器、数据段和栈中
; 环境：MASM + DOSBox
;--------------------------------------------
data segment
    msg1 db 'Enter a number (1-100): $'
    msg2 db 0Dh,0Ah,'Result: $'
    sumData dw 0           ; 数据段存储结果
data ends

code segment
assume cs:code, ds:data

start:
    mov ax, data
    mov ds, ax

    ;---------------------
    ; 提示用户输入
    ;---------------------
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ;---------------------
    ; 读取一位或两位数字
    ;---------------------
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al       ; 第一位存 BL

    mov ah, 01h
    int 21h
    cmp al, 0Dh      ; 判断是否回车
    je one_digit
    sub al, '0'
    mov bh, al       ; 第二位存 BH
    mov al, bl
    mov ah, 0
    mov bl, 10
    mul bl           ; AX = 第一位*10
    add ax, bx       ; 加上第二位
    jmp got_number

one_digit:
    mov ah, 0
    mov al, bl

got_number:
    mov cx, ax       ; n = 用户输入
    ;---------------------
    ; 方法1：结果保存在寄存器 AX
    ;---------------------
    mov ax, 0
    mov bx, 1
reg_loop:
    add ax, bx
    inc bx
    loop reg_loop
    ; AX 中即最终结果

    ; 输出寄存器结果
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    call PrintAX    ; AX 中结果输出

    ;---------------------
    ; 方法2：结果存入数据段 sumData
    ;---------------------
    mov sumData, ax

    ; 输出数据段结果
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    mov ax, sumData
    call PrintAX

    ;---------------------
    ; 方法3：结果存入栈
    ;---------------------
    push ax        ; 将结果压栈
    pop ax         ; 弹出到 AX
    mov dx, offset msg2
    mov ah, 09h
    int 21h
    call PrintAX

    ;---------------------
    ; 程序结束
    ;---------------------
    mov ah, 4Ch
    int 21h

;---------------------------------
; 输出 AX 中的无符号整数（十进制）
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
