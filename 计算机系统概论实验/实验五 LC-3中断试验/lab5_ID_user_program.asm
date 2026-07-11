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
