.ORIG x3000

;=====================================================
; 主程序 MAIN
;=====================================================
MAIN    
        ; 初始化石头数: A=3, B=5, C=8
        LEA     R0, ROW_A
        AND     R1, R1, #0
        ADD     R1, R1, #3
        STR     R1, R0, #0      ; ROW_A = 3
        ADD     R1, R1, #2
        STR     R1, R0, #1      ; ROW_B = 5
        ADD     R1, R1, #3
        STR     R1, R0, #2      ; ROW_C = 8

        ; 当前玩家设为1
        AND     R1, R1, #0
        ADD     R1, R1, #1
        ST      R1, CUR_PLAYER

        ; 首次显示棋盘
        JSR     PRINT_BOARD

GAMELOOP
        JSR     GET_VALID_MOVE   ; 返回 R0=行索引(0/1/2), R1=数量

        ; 更新对应行的石头数
        LEA     R2, ROW_A
        ADD     R2, R2, R0       ; R2 = &ROW_A + row
        LDR     R3, R2, #0       ; 原有数量
        NOT     R1, R1
        ADD     R1, R1, #1       ; R1 = -quantity
        ADD     R3, R3, R1       ; 新数量
        STR     R3, R2, #0

        ; 检查是否所有石头为0 (胜利条件)
        LEA     R4, ROW_A
        LDR     R0, R4, #0
        LDR     R1, R4, #1
        ADD     R0, R0, R1
        LDR     R1, R4, #2
        ADD     R0, R0, R1
        BRz     WIN

        ; 未胜利：切换玩家 (3 - CUR_PLAYER)
        LD      R0, CUR_PLAYER
        NOT     R0, R0
        ADD     R0, R0, #1
        ADD     R0, R0, #3
        ST      R0, CUR_PLAYER

        ; 显示更新后的棋盘
        JSR     PRINT_BOARD
        BRnzp   GAMELOOP

WIN     
        ; 根据 CUR_PLAYER 输出获胜信息
        LD      R0, CUR_PLAYER
        ADD     R0, R0, #-1
        BRz     WIN_P1
        LEA     R0, WIN2_STR
        BR      PUT_WIN
WIN_P1  LEA     R0, WIN1_STR
PUT_WIN TRAP    x22
        HALT

;=====================================================
; 数据区 (靠近 MAIN)
;=====================================================
ROW_A   .BLKW   1   ; 实际用连续3个单元作为数组
ROW_B   .BLKW   1
ROW_C   .BLKW   1
CUR_PLAYER .BLKW 1

WIN1_STR .STRINGZ "Player 1 Wins.\n"
WIN2_STR .STRINGZ "Player 2 Wins.\n"

;=====================================================
; 子程序 GET_VALID_MOVE
; 功能: 反复提示当前玩家，直到输入合法字母(A/B/C)+数字(≤剩余数)
; 返回: R0 = 行索引 (0~2), R1 = 移除数量
;=====================================================
GET_VALID_MOVE
        ; 保存寄存器 (R2~R5, R7)
        ST      R7, GM_SAVE_R7
        ST      R2, GM_SAVE_R2
        ST      R3, GM_SAVE_R3
        ST      R4, GM_SAVE_R4
        ST      R5, GM_SAVE_R5

GM_LOOP 
        ; 根据 CUR_PLAYER 输出提示
        LD      R0, CUR_PLAYER
        ADD     R0, R0, #-1
        BRz     GM_P1
        LEA     R0, GM_PROMPT2
        BR      GM_PUTS
GM_P1   LEA     R0, GM_PROMPT1
GM_PUTS TRAP    x22

        ; 读第一个字符 (行字母)
        TRAP    x20
        TRAP    x21
        ADD     R2, R0, #0          ; R2 = 行字母

        ; 读第二个字符 (数字)
        TRAP    x20
        TRAP    x21
        ADD     R3, R0, #0          ; R3 = 数字字符

        ; 输出换行
        LD      R0, GM_NEWLINE
        TRAP    x21

        ; ----- 验证行字母 (必须为 A/B/C) -----
        LD      R4, GM_CHAR_A
        NOT     R4, R4
        ADD     R4, R4, #1          ; -'A'
        ADD     R0, R2, R4          ; R0 = char - 'A'
        BRn     GM_INVALID
        ADD     R1, R0, #-2
        BRp     GM_INVALID          ; 不是 0~2 则无效
        ADD     R5, R0, #0          ; R5 = 行索引 (0/1/2)

        ; ----- 验证数字字符 (1~8，且 ≤ 该行石头数) -----
        LD      R4, GM_CHAR_0
        NOT     R4, R4
        ADD     R4, R4, #1          ; -'0'
        ADD     R0, R3, R4          ; R0 = 数字值
        ADD     R1, R0, #-1
        BRn     GM_INVALID          ; <1
        ADD     R1, R0, #-8
        BRp     GM_INVALID          ; >8

        ; 检查数字是否 ≤ 该行剩余数量
        LEA     R1, ROW_A
        ADD     R1, R1, R5          ; R1 = &ROW_A[row]
        LDR     R2, R1, #0          ; R2 = 当前石头数
        NOT     R2, R2
        ADD     R2, R2, #1          ; -count
        ADD     R2, R0, R2          ; number - count
        BRp     GM_INVALID          ; number > count 无效

        ; 合法: 设置返回值和恢复寄存器
        ADD     R1, R0, #0          ; R1 = 数量
        ADD     R0, R5, #0          ; R0 = 行索引
        LD      R2, GM_SAVE_R2
        LD      R3, GM_SAVE_R3
        LD      R4, GM_SAVE_R4
        LD      R5, GM_SAVE_R5
        LD      R7, GM_SAVE_R7
        RET

GM_INVALID
        LEA     R0, GM_ERR_MSG
        TRAP    x22
        BRnzp   GM_LOOP

; GET_VALID_MOVE 使用的局部数据
GM_SAVE_R7 .BLKW 1
GM_SAVE_R2 .BLKW 1
GM_SAVE_R3 .BLKW 1
GM_SAVE_R4 .BLKW 1
GM_SAVE_R5 .BLKW 1
GM_CHAR_A  .FILL x0041   ; 'A'
GM_CHAR_0  .FILL x0030   ; '0'
GM_NEWLINE .FILL x000A
GM_PROMPT1 .STRINGZ "Player 1, choose a row and number of rocks: "
GM_PROMPT2 .STRINGZ "Player 2, choose a row and number of rocks: "
GM_ERR_MSG .STRINGZ "Invalid move. Try again.\n"

;=====================================================
; 子程序 PRINT_BOARD
; 功能: 输出三行石头状态 (若某行数量为0，则只输出 ROW X: 和换行)
;=====================================================
PRINT_BOARD
        ST      R7, PB_SAVE_R7
        ST      R0, PB_SAVE_R0
        ST      R1, PB_SAVE_R1
        ST      R2, PB_SAVE_R2
        ST      R3, PB_SAVE_R3
        ST      R4, PB_SAVE_R4

        AND     R3, R3, #0          ; R3 = 行索引 i = 0
PB_LOOP
        ADD     R4, R3, #-3
        BRzp    PB_DONE

        ; 输出行标签 "ROW A:" / "ROW B:" / "ROW C:"
        ADD     R0, R3, #0
        BRz     PB_A
        ADD     R0, R3, #-1
        BRz     PB_B
        LEA     R0, PB_ROW_C
        BR      PB_PUTS
PB_A    LEA     R0, PB_ROW_A
        BR      PB_PUTS
PB_B    LEA     R0, PB_ROW_B
PB_PUTS TRAP    x22

        ; 取该行石头数量
        LEA     R1, ROW_A
        ADD     R1, R1, R3
        LDR     R2, R1, #0          ; R2 = count

        ; 输出 count 个 'o'
PB_O_LOOP
        ADD     R2, R2, #0
        BRz     PB_NL               ; 修改：跳转到输出换行的指令标签
        LD      R0, PB_CHAR_O
        TRAP    x21
        ADD     R2, R2, #-1
        BRnzp   PB_O_LOOP

PB_NL                               ; 新标签名，避免与数据标签冲突
        LD      R0, PB_NEWLINE
        TRAP    x21
        ADD     R3, R3, #1
        BRnzp   PB_LOOP

PB_DONE
        LD      R0, PB_SAVE_R0
        LD      R1, PB_SAVE_R1
        LD      R2, PB_SAVE_R2
        LD      R3, PB_SAVE_R3
        LD      R4, PB_SAVE_R4
        LD      R7, PB_SAVE_R7
        RET

; PRINT_BOARD 使用的局部数据
PB_SAVE_R7 .BLKW 1
PB_SAVE_R0 .BLKW 1
PB_SAVE_R1 .BLKW 1
PB_SAVE_R2 .BLKW 1
PB_SAVE_R3 .BLKW 1
PB_SAVE_R4 .BLKW 1
PB_CHAR_O  .FILL x006F   ; 'o'
PB_NEWLINE .FILL x000A
PB_ROW_A   .STRINGZ "ROW A: "
PB_ROW_B   .STRINGZ "ROW B: "
PB_ROW_C   .STRINGZ "ROW C: "

.END