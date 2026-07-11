.ORIG    x3000
LD R6,STACK  ; 初始化堆栈指针，保存在寄存器R6中
; 设置键盘中断向量表项
LD R1,ENTRANCE  ; 加载中断服务程序的入口地址到R1
LD R2,INTV   ; 加载中断向量地址到R2
STR R1,R2,#0  ; 如果键盘有输入，程序计数器（PC）将跳转到x2000
; 启用键盘中断
LD R3,IE   ; 加载中断使能标志到R3
STI R3,KBSR   ; 设置KBSR的第14位为1，以启用键盘中断
; 开始实际的用户程序，用于打印ICS棋盘图案
PRINT LEA R0,STR1  ; 将第一行字符串的地址加载到R0
TRAP x22   ; 打印R0指向的第一行字符串
LEA R0,STR2  ; 将第二行字符串的地址加载到R0
JSR DELAY   ; 调用延迟子程序
TRAP x22   ; 打印R0指向的第二行字符串
JSR DELAY   ; 调用延迟子程序
BRnzp PRINT  ; 无条件跳转到PRINT标签，继续打印
HALT    ; 停止程序
DELAY   ST  R1, SaveR1  ; 保存R1的值到SaveR1
LD  R1, COUNT   ; 加载计数器初始值到R1
REP     ADD R1,R1,#-1  ; R1减1
BRp REP    ; 如果R1为正，跳转回REP继续循环
LD  R1, SaveR1   ; 恢复R1的原始值
RET    ; 返回调用者
STR1 .STRINGZ "ICS     ICS     ICS     ICS     ICS     ICS\n"
STR2 .STRINGZ "    ICS     ICS     ICS     ICS     ICS\n"
IE  .FILL x4000  ; 中断使能标志位，位14设置为1
KBSR .FILL xFE00  ; 键盘状态寄存器的地址
KBDR .FILL xFE02  ; 键盘数据寄存器的地址
COUNT   .FILL #25000  ; 延迟计数，用于控制显示速度
INTV .FILL x0180  ; 中断向量表的具体位置
ENTRANCE .FILL x2000 ; 中断服务程序的起始地址
SaveR1  .FILL #0  ; 用于保存R1寄存器的值
STACK .FILL x3000  ; 堆栈的初始地址
.END
.ORIG     x2000       ; 设置程序起始地址为x2000
ADD R6,R6,#-1         ; 将栈指针向下移动1位
STR R0,R6,#0          ; 将R0寄存器的内容保存到栈顶
ADD R6,R6,#-1         ; 将栈指针再次向下移动1位
STR R1,R6,#0          ; 将R1寄存器的内容保存到栈顶
ADD R6,R6,#-1         ; 再次将栈指针向下移动1位
STR R2,R6,#0          ; 将R2寄存器的内容保存到栈顶
ADD R6,R6,#-1         ; 再次将栈指针向下移动1位
STR R3,R6,#0          ; 将R3寄存器的内容保存到栈顶

LOOP    ST  R0,SaveR0     ; 在循环开始前保存R0的原始值
CHECK   LDI R1,KBSR       ; 从内存地址KBSR加载键盘状态寄存器的值到R1
ADD R1,R1,#0              ; 检查KBSR的第15位（键盘就绪位）
BRzp    CHECK             ; 如果KBSR[15]=0，继续等待键盘输入

LDI R0,KBDR               ; 从内存地址KBDR加载键盘输入的数据到R0
LD  R2,_ENDLINE           ; 加载_ENDLINE中的值到R2
ADD R2,R2,R0              ; 将R0的值（键盘输入的字符）添加到_ENDLINE
BRnp    LOOP              ; 如果结果为负（即输入非换行符），返回LOOP继续处理输入

AND R3,R3,#0              ; 清除R3的内容（设置R3为0）
ADD R3,R3,#10             ; 将R3设置为10（用于后续打印循环）

P_LOOP  LD  R0,SaveR0     ; 恢复R0的原始值
START   LDI R1,DSR        ; 从内存地址DSR加载显示状态寄存器的值到R1
BRzp    START             ; 如果DSR[15]=0，表示显示设备未就绪，继续等待
STI R0,DDR                ; 向内存地址DDR发送数据（即输出R0的值到显示设备）
ADD R3,R3,#-1             ; R3减1
BRp P_LOOP                ; 如果R3为正，继续P_LOOP循环

P_ENDL  LD  R0,ENDLINE    ; 加载ENDLINE中的换行符到R0
LDI R1,DSR                ; 再次加载显示状态寄存器的值到R1
BRzp    P_ENDL            ; 如果显示设备未就绪，继续等待
STI R0,DDR                ; 输出换行符到显示设备

LDR R3,R6,#0              ; 从栈中恢复R3的原始值
ADD R6,R6,#1              ; 将栈指针向上移动1位
LDR R2,R6,#0              ; 从栈中恢复R2的原始值
ADD R6,R6,#1              ; 将栈指针向上移动1位
LDR R1,R6,#0              ; 从栈中恢复R1的原始值
ADD R6,R6,#1              ; 将栈指针向上移动1位
LDR R0,R6,#0              ; 从栈中恢复R0的原始值
ADD R6,R6,#1              ; 将栈指针向上移动1位

RTI                       ; 返回从中断

; buffer space as required
_ENDLINE .FILL   xFFF6    ; 设置_ENDLINE为'\n'的ASCII值的补码
ENDLINE .FILL   x000A     ; 设置ENDLINE为'\n'的ASCII值
SaveR0  .FILL   #0        ; 为保存R0设置缓冲
KBSR    .FILL   xFE00     ; 键盘状态寄存器的内存地址
KBDR    .FILL   xFE02     ; 键盘数据寄存器的内存地址
DSR     .FILL   xFE04     ; 显示状态寄存器的内存地址
DDR     .FILL   xFE06     ; 显示数据寄存器的内存地址
.END
