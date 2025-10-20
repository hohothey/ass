.MODEL SMALL
.STACK 100H
.DATA
    NEWLINE DB 0DH, 0AH, '$'  ; 回车换行
    SPACE DB ' $'             ; 空格
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; 初始化寄存器
    MOV CL, 'a'        ; CL 存储当前字符
    MOV CH, 26         ; CH 作为计数器，总共26个字母
    MOV BL, 13         ; BL 存储每行字符数
    MOV BH, 0          ; BH 记录当前行已输出字符数
    
PRINT_LOOP:
    ; 输出当前字符
    MOV DL, CL
    MOV AH, 02H
    INT 21H
    
    ; 输出空格
    MOV DX, OFFSET SPACE
    MOV AH, 09H
    INT 21H
    
    ; 更新计数器
    INC CL             ; 下一个字符
    INC BH             ; 当前行字符数+1
    DEC CH             ; 总字符数-1
    
    ; 检查是否需要换行
    CMP BH, BL         ; 比较当前行字符数是否达到13
    JNE CHECK_END      ; 如果不到13，继续
    
    ; 换行处理
    CALL NEW_LINE
    MOV BH, 0          ; 重置当前行字符计数器
    
CHECK_END:
    ; 检查是否所有字符都输出完毕
    CMP CH, 0
    JNE PRINT_LOOP     ; 如果还有字符，继续循环
    
    ; 如果最后一行不满13个，也需要换行
    CMP BH, 0
    JE EXIT
    CALL NEW_LINE
    
EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; 换行子程序
NEW_LINE PROC
    MOV DX, OFFSET NEWLINE
    MOV AH, 09H
    INT 21H
    RET
NEW_LINE ENDP

END MAIN