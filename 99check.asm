.MODEL SMALL
.STACK 100h

.DATA
TABLE DB 7,2,3,4,5,6,7,8,9
      DB 2,4,7,8,10,12,14,16,18
      DB 3,6,9,12,15,18,21,24,27
      DB 4,8,12,16,7,24,28,32,36
      DB 5,10,15,20,25,30,35,40,45
      DB 6,12,18,24,30,7,42,48,54
      DB 7,14,21,28,35,42,49,56,63
      DB 8,16,24,32,40,48,56,7,72
      DB 9,18,27,36,45,54,63,72,81

HEADER   DB 'x y error',0Dh,0Ah,'$'
NEWLINE  DB 0Dh,0Ah,'$'
DONE_MSG DB 'accomplish!',0Dh,0Ah,'$'

.CODE
ASSUME DS:@DATA

START:
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 9
    LEA DX, HEADER
    INT 21h

    MOV CL, 1          ; row = 1
ROW_LOOP:
    MOV CH, 1          ; col = 1
COLUMN_LOOP:
    MOV DL, CH
    CALL CHECK_CELL

    INC CH
    CMP CH, 10
    JL COLUMN_LOOP

    INC CL
    CMP CL, 10
    JL ROW_LOOP

    MOV AH, 9
    LEA DX, DONE_MSG
    INT 21h

    MOV AH, 4Ch
    INT 21h


;-----------------------------------------
; CHECK_CELL
; 输入：CL=row, DL=col
;-----------------------------------------
CHECK_CELL PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV AL, CL
    DEC AL
    MOV AH, 0
    MOV BL, 9
    MUL BL
    MOV BX, AX
    MOV AL, DL
    DEC AL
    CBW
    ADD BX, AX

    LEA SI, TABLE
    ADD SI, BX
    MOV BL, [SI]

    MOV AL, CL
    MUL DL
    CMP BL, AL
    JE CELL_OK
    CALL DISPLAY_ERROR

CELL_OK:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CHECK_CELL ENDP


;-----------------------------------------
; DISPLAY_ERROR
;-----------------------------------------
DISPLAY_ERROR PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; 打印 row
    MOV AL, CL
    CBW
    CALL DISPLAY_NUMBER

    ; 空格
    MOV AH, 2
    MOV DL, ' '
    INT 21h

    ; 打印 col（从 CH 取，不再用 DL）
    MOV AL, CH
    CBW
    CALL DISPLAY_NUMBER

    MOV AH, 2
    MOV DL, ' '
    INT 21h

    MOV AL, BL
    CBW
    CALL DISPLAY_NUMBER

    MOV AH, 2
    MOV DL, ' '
    INT 21h
    MOV DL, 'e'
    INT 21h
    MOV DL, 'r'
    INT 21h
    MOV DL, 'r'
    INT 21h
    MOV DL, 'o'
    INT 21h
    MOV DL, 'r'
    INT 21h

    MOV AH, 9
    LEA DX, NEWLINE
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_ERROR ENDP


;-----------------------------------------
; DISPLAY_NUMBER
;-----------------------------------------
DISPLAY_NUMBER PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BL, 10
    XOR AH, AH
    DIV BL

    CMP AL, 0
    JE ONLY_UNITS
    MOV DL, AL
    ADD DL, '0'
    MOV AH, 2
    INT 21h
ONLY_UNITS:
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 2
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_NUMBER ENDP

END START
