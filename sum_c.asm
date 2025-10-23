; 函数入口：建立栈帧、保存寄存器
00701870  push        ebp                  ; 保存旧的栈基址
00701871  mov         ebp,esp              ; 建立新的栈帧（ebp = 当前 esp）
00701873  sub         esp,0D8h             ; 为局部变量分配 0xD8 字节空间
00701879  push        ebx
0070187A  push        esi
0070187B  push        edi                  ; 保存被调用者需要保持的寄存器

; 以下几行是调试模式下的初始化内存操作 (填充0xCCCCCCCC 以检测未初始化变量)
0070187C  lea         edi,[ebp-18h]        
0070187F  mov         ecx,6
00701884  mov         eax,0CCCCCCCCh
00701889  rep stos    dword ptr es:[edi]

; VS 调试功能注入的检测代码，与逻辑无关
0070188B  mov         ecx,offset _0697C126_sum@c
00701890  call        @__CheckForDebuggerJustMyCode@4
00701895  nop

;------------------------
; int n = 100;
;------------------------
00701896  mov         dword ptr [n],64h     ; 将立即数100 (0x64) 存入局部变量n

;------------------------
; int sum = n * (n + 1) / 2;
;------------------------
0070189D  mov         eax,dword ptr [n]     ; eax = n
007018A0  add         eax,1                 ; eax = n + 1
007018A3  imul        eax,dword ptr [n]     ; eax = n * (n + 1)
007018A7  cdq                                ; 将 eax 的符号位扩展到 edx，为后续除法准备
007018A8  sub         eax,edx               ; 对偶数修正（除2时确保正数取整）
007018AA  sar         eax,1                 ; 算术右移1位，相当于除以2
007018AC  mov         dword ptr [sum],eax   ; 保存结果 sum = n*(n+1)/2

;------------------------
; printf("%d\n", sum);
;------------------------
007018AF  mov         eax,dword ptr [sum]   ; eax = sum
007018B2  push        eax                   ; 压入 printf 参数2（要输出的整数）
007018B3  push        offset string "%d\n"  ; 压入 printf 参数1（格式化字符串地址）
007018B8  call        _printf               ; 调用C库函数printf
007018BD  add         esp,8                 ; 平衡栈指针，清理两个参数(4字节×2)

;------------------------
; return 0;
;------------------------
007018C0  xor         eax,eax               ; eax = 0（函数返回值）
; 函数尾部：恢复寄存器与栈帧
007018C2  pop         edi
007018C3  pop         esi
007018C4  pop         ebx
007018C5  add         esp,0D8h              ; 释放局部变量空间
007018CB  cmp         ebp,esp
007018CD  call        __RTC_CheckEsp        ; 调试模式下的ESP一致性检查
007018D2  mov         esp,ebp               ; 恢复原esp
007018D4  pop         ebp                   ; 弹出旧栈帧
007018D5  ret                               ; 返回调用者
