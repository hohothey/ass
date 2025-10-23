;--------------------------------------------------
; 函数：printASCII_withLoop
; 功能：打印小写 ASCII 字母表，每行 13 个字符
;--------------------------------------------------
00941AF0  push        ebp
; 保存上一级栈基址

00941AF1  mov         ebp,esp
; 建立当前函数栈帧

00941AF3  sub         esp,0D8h
; 为局部变量分配栈空间（216字节）

00941AF9  push        ebx
00941AFA  push        esi
00941AFB  push        edi
; 保存调用者需要保持的寄存器

00941AFC  lea         edi,[ebp-18h]
00941AFF  mov         ecx,6
00941B04  mov         eax,0CCCCCCCCh
00941B09  rep stos    dword ptr es:[edi]
; 调试模式初始化局部变量区域，填充0xCCCCCCCC

00941B0B  mov         ecx,offset _20D96045_ASCII@c (094C008h)
00941B10  call        @__CheckForDebuggerJustMyCode@4 (0941339h)
00941B15  nop
; 调试检查，与逻辑无关

;--------------------------
; printf("方法1 - 使用循环结构：\n");
;--------------------------
00941B16  push        offset string "\xb7\xbd\xb7\xa81..." (0947B30h)
00941B1B  call        _printf (09410D2h)
00941B20  add         esp,4
; 调用 printf 输出提示信息，清理栈 4 字节

;--------------------------
; char ch = 'a';
; int count = 0;
;--------------------------
00941B23  mov         byte ptr [ch],61h
; ch = 'a' (0x61)

00941B27  mov         dword ptr [count],0
; count = 0

;--------------------------
; 循环：for(ch='a'; ch<='z'; ch++)
;--------------------------
00941B2E  mov         byte ptr [ch],61h
; 初始化 ch = 'a'

00941B32  jmp         00941B3Ch
; 跳到循环条件判断

;--------------------------
; 循环体内：ch++
00941B34  mov         al,byte ptr [ch]
00941B37  add         al,1
00941B39  mov         byte ptr [ch],al
; ch 自增 1

;--------------------------
; 比较条件 ch <= 'z'
00941B3C  movsx       eax,byte ptr [ch]
00941B40  cmp         eax,7Ah
00941B43  jg          00941B7Eh
; 如果 ch > 'z' 跳出循环

;--------------------------
; printf("%c ", ch)
00941B45  movsx       eax,byte ptr [ch]
00941B49  push        eax
00941B4A  push        offset string "%c " (0947B4Ch)
00941B4F  call        _printf (09410D2h)
00941B54  add         esp,8
; 将 ch 压栈，调用 printf 输出字符

;--------------------------
; count++
00941B57  mov         eax,dword ptr [count]
00941B5A  add         eax,1
00941B5D  mov         dword ptr [count],eax
; count = count + 1

;--------------------------
; 每行 13 个字符换行
00941B60  mov         eax,dword ptr [count]
00941B63  cdq
00941B64  mov         ecx,0Dh
00941B69  idiv        eax,ecx
00941B6B  test        edx,edx
00941B6D  jne         00941B7Ch
; 判断 count % 13 == 0，如果不等于0跳过换行

00941B6F  push        offset string "\n" (0947B50h)
00941B74  call        _printf (09410D2h)
00941B79  add         esp,4
; 输出换行符

00941B7C  jmp         00941B34
; 循环回到 ch++ 部分

;--------------------------
; 循环结束后，如果最后一行不满 13 个也换行
00941B7E  mov         eax,dword ptr [count]
00941B81  cdq
00941B82  mov         ecx,0Dh
00941B87  idiv        eax,ecx
00941B89  test        edx,edx
00941B8B  je          00941B9Ah
; 判断 count % 13 != 0

00941B8D  push        offset string "\n" (0947B50h)
00941B92  call        _printf (09410D2h)
00941B97  add         esp,4
; 输出换行

;--------------------------
; 最终换行
00941B9A  push        offset string "\n" (0947B50h)
00941B9F  call        _printf (09410D2h)
00941BA4  add         esp,4

;--------------------------
; 函数尾部：恢复寄存器和栈帧
00941BA7  pop         edi
00941BA8  pop         esi
00941BA9  pop         ebx
00941BAA  add         esp,0D8h
00941BB0  cmp         ebp,esp
00941BB2  call        __RTC_CheckEsp (0941258h)
00941BB7  mov         esp,ebp
00941BB9  pop         ebp
00941BBA  ret
; 函数结束，返回调用者
00941890  push        ebp
; 保存上一个函数的栈基址

00941891  mov         ebp,esp
; 建立当前函数的栈帧

00941893  sub         esp,0C0h
; 为局部变量分配栈空间（0xC0 = 192 字节）

00941899  push        ebx
0094189A  push        esi
0094189B  push        edi
; 保存调用者寄存器（被调用者保存寄存器）

0094189C  mov         edi,ebp
0094189E  xor         ecx,ecx
009418A0  mov         eax,0CCCCCCCCh
009418A5  rep stos    dword ptr es:[edi]
; 调试模式初始化栈空间，填充0xCCCCCCCC

009418A7  mov         ecx,offset _20D96045_ASCII@c (094C008h)
009418AC  call        @__CheckForDebuggerJustMyCode@4 (0941339h)
009418B1  nop
; 调试检查（VS 自动生成）

;--------------------------
; printf("ASCII小写字母表（每行13个字符）\n");
;--------------------------
009418B2  push        offset string "ASCII小写字母表（每行13个字符）\n" (0947B88h)
009418B7  call        _printf (09410D2h)
009418BC  add         esp,4
; 参数压栈，调用 printf，返回后清理栈

;--------------------------
; printf("===============================\n");
;--------------------------
009418BF  push        offset string "===============================\n" (0947BB0h)
009418C4  call        _printf (09410D2h)
009418C9  add         esp,4
; 输出分隔线

;--------------------------
; 调用 printASCII_withLoop();
;--------------------------
009418CC  call        _printASCII_withLoop (0941190h)
009418D1  nop
; 调用用户定义函数，返回后占位 nop

;--------------------------
; 调用 printASCII_withConditionalJump();
;--------------------------
009418D2  call        _printASCII_withConditionalJump (094126Ch)
009418D7  nop
; 调用用户定义函数

;--------------------------
; 调用 printASCII_simple();
;--------------------------
009418D8  call        _printASCII_simple (09410FAh)
009418DD  nop
; 调用用户定义函数

;--------------------------
; return 0;
;--------------------------
009418DE  xor         eax,eax
; 函数返回值 eax = 0

;--------------------------
; 恢复寄存器和栈
009418E0  pop         edi
009418E1  pop         esi
009418E2  pop         ebx
009418E3  add         esp,0C0h
; 恢复栈空间和寄存器

009418E9  cmp         ebp,esp
009418EB  call        __RTC_CheckEsp (0941258h)
; 栈检查（调试模式）

009418F0  mov         esp,ebp
009418F2  pop         ebp
009418F3  ret
; 函数返回调用者
