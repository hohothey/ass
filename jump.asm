.MODEL SMALL
.STACK 100H
.DATA
    NEWLINE DB 0DH, 0AH, '$'  ; 回车换行
    SPACE DB ' $'             ; 空格
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; 初始化
    MOV CL, 'a'        ; 起始字符 'a'
    MOV CH, 0          ; 当前行字符计数器
    
MAIN_LOOP:
    ; 条件判断：是否超过 'z'
    CMP CL, 'z'
    JG EXIT_PROGRAM    ; 如果大于 'z'，退出
    
    ; 输出字符
    MOV DL, CL
    MOV AH, 02H
    INT 21H
    
    ; 输出空格
    MOV DX, OFFSET SPACE
    MOV AH, 09H
    INT 21H
    
    ; 更新计数器和字符
    INC CL             ; 下一个字符
    INC CH             ; 当前行字符数+1
    
    ; 检查是否需要换行（每行13个字符）
    CMP CH, 13
    JNE MAIN_LOOP      ; 如果不到13个，继续循环
    
    ; 执行换行
    CALL NEW_LINE
    MOV CH, 0          ; 重置行计数器
    JMP MAIN_LOOP      ; 继续循环
    
EXIT_PROGRAM:
    ; 检查最后一行是否需要换行
    CMP CH, 0
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