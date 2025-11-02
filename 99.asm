STACKSEG SEGMENT STACK
    DW 100H DUP(0)
STACKSEG ENDS

DATASEG SEGMENT
    TITLE_MSG DB 'The 9*9 table:', 0DH, 0AH, '$'
    SPACE     DB '    $'          ; 四个空格用于对齐
    NEWLINE   DB 0DH, 0AH, '$'    ; 换行符
    BUFFER    DB 10 DUP('$')      ; 用于数字转换的缓冲区
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

; ==================== 主程序 ====================
MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX
    
    ; 显示标题
    MOV AH, 9
    MOV DX, OFFSET TITLE_MSG
    INT 21H
    
    ; 外层循环：从9到1
    MOV CX, 9                    ; CX = 外层循环计数器
    
OUTER_LOOP:
    PUSH CX                      ; 保存外层循环计数器
    
    ; 内层循环：从1到当前外层值
    MOV BX, 1                    ; BX = 内层循环计数器 (从1开始)
    
INNER_LOOP:
    ; 调用过程显示一个乘法项
    CALL DISPLAY_MULTIPLY
    
    ; 显示空格分隔符
    MOV AH, 9
    MOV DX, OFFSET SPACE
    INT 21H
    
    INC BX                       ; 内层循环计数器+1
    CMP BX, CX                   ; 比较 BX 和 CX
    JLE INNER_LOOP               ; 如果 BX <= CX 继续内层循环
    
    ; 显示换行
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    INT 21H
    
    POP CX                       ; 恢复外层循环计数器
    LOOP OUTER_LOOP              ; CX--, 如果CX>0继续循环
    
    ; 程序结束
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ==================== 显示单个乘法项的过程 ====================
; 输入：CX = 被乘数, BX = 乘数
; 输出：在屏幕上显示 "CX*BX=结果"
DISPLAY_MULTIPLY PROC NEAR
    PUSH AX                      ; 保存寄存器
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; 显示被乘数
    MOV AX, CX
    CALL DISPLAY_NUMBER
    
    ; 显示 '*'
    MOV AH, 2
    MOV DL, '*'
    INT 21H
    
    ; 显示乘数
    MOV AX, BX
    CALL DISPLAY_NUMBER
    
    ; 显示 '='
    MOV AH, 2
    MOV DL, '='
    INT 21H
    
    ; 计算乘法结果
    MOV AX, CX                   ; AX = 被乘数
    MUL BX                       ; AX = AX * BX (结果在AX中)
    
    ; 显示结果
    CALL DISPLAY_NUMBER
    
    POP SI                       ; 恢复寄存器
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_MULTIPLY ENDP

; ==================== 显示数字的过程 ====================
; 输入：AX = 要显示的数字
; 输出：在屏幕上显示数字
DISPLAY_NUMBER PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; 准备数字转换
    LEA SI, BUFFER               ; SI指向缓冲区
    MOV CX, 0                    ; 数字位数计数器
    
    ; 处理0的情况
    CMP AX, 0
    JNZ CONVERT_LOOP
    MOV BYTE PTR [SI], '0'
    INC SI
    MOV BYTE PTR [SI], '$'
    JMP DISPLAY_RESULT
    
CONVERT_LOOP:
    MOV DX, 0                    ; 清空DX
    MOV BX, 10                   ; 除数为10
    DIV BX                       ; AX/10, 商在AX, 余数在DX
    
    ADD DL, '0'                  ; 转换为ASCII
    PUSH DX                      ; 保存数字字符（逆序）
    INC CX                       ; 位数+1
    
    CMP AX, 0                    ; 商为0则结束
    JNZ CONVERT_LOOP
    
    ; 从栈中弹出数字（正序）
STORE_LOOP:
    POP DX
    MOV [SI], DL
    INC SI
    LOOP STORE_LOOP
    
    MOV BYTE PTR [SI], '$'       ; 字符串结束符
    
DISPLAY_RESULT:
    ; 显示数字
    MOV AH, 9
    MOV DX, OFFSET BUFFER
    INT 21H
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_NUMBER ENDP

CODESEG ENDS
    END MAIN