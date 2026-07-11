.ORIG x3000

; ==========================================
; 第一步：数据复制 (x3200 -> x4000)
; 你提供的代码缺少这一步，必须先复制才能排序
; ==========================================
    LEA R0, DATA          ; R0 指向源地址 x3200
    LEA R1, RESULT        ; R1 指向目标地址 x4000
    AND R2, R2, #0        ; R2 计数器 = 0
    BRnzp MIDDLE_COPY

LOOP_COPY
    LDR R3, R0, #0        ; 读取成绩
    STR R3, R1, #0        ; 存入目标地址
    ADD R0, R0, #1        ; 源指针后移
    ADD R1, R1, #1        ; 目标指针后移
    ADD R2, R2, #1        ; 计数器+1
MIDDLE_COPY
    ADD R3, R2, #-16      ; 比较计数器是否达到16
    BRn LOOP_COPY         ; 没复制完16个就继续

; ==========================================
; 第二步：冒泡排序 (降序)
; 修复了语法格式，并补充了缺失的指针初始化
; ==========================================
    AND R1, R1, #0        ; R1 外层循环计数器 i = 0
    ADD R1, R1, #1        ; i 从 1 开始
    BRnzp MIDDLE1

LOOP1
    AND R2, R2, #0        ; R2 内层循环计数器 j = 0
    BRnzp MIDDLE2

LOOP2
    ADD R3, R0, R2        ; R3 = 数组基址 + j
    ADD R4, R3, #1        ; R4 = 数组基址 + j + 1 (指向下一个元素)
    LDR R5, R3, #0        ; R5 = A[j]
    LDR R6, R4, #0        ; R6 = A[j+1]
    NOT R7, R6
    ADD R7, R7, #1        ; R7 = -A[j+1]
    ADD R7, R7, R5        ; R7 = A[j] - A[j+1]
    BRzp END2             ; 如果 A[j] >= A[j+1]，不交换（降序）

    STR R5, R4, #0        ; 交换：A[j+1] = A[j]
    STR R6, R3, #0        ; 交换：A[j] = A[j+1]
END2
    ADD R2, R2, #1        ; j++
MIDDLE2
    ADD R3, R1, R2
    ADD R3, R3, #-16      ; 比较 j + i 与 16
    BRn LOOP2             ; 如果 j < 16 - i，继续内层循环

    ADD R1, R1, #1        ; i++
MIDDLE1
    ADD R3, R1, #-16      ; 比较 i 与 16
    BRn LOOP1             ; 如果 i < 16，继续外层循环

; ==========================================
; 第三步：筛选等级 (统计 A 和 B)
; 逻辑完全保留了你提供的 Jump-to-Middle 结构
; ==========================================
    AND R1, R1, #0        ; R1 索引计数器 = 0
    LD R6, A_GRADE        ; R6 = 85 (x0055)
    LD R7, B_GRADE        ; R7 = 75 (x004B)
    NOT R6, R6
    ADD R6, R6, #1        ; R6 = -85 (用于比较)
    NOT R7, R7
    ADD R7, R7, #1        ; R7 = -75 (用于比较)
    AND R2, R2, #0        ; R2 = A 的人数
    AND R3, R3, #0        ; R3 = B 的人数
    BRnzp MIDDLE3

LOOP3
    ADD R4, R1, #-4       ; 检查是否进入前 4 名 (0-3)
    BRzp IS_B             ; 如果索引 >= 4，跳过 A 的检查，直接去检查 B

    ADD R4, R0, R1        ; R4 指向当前成绩地址
    LDR R4, R4, #0        ; R4 = 当前成绩
    ADD R5, R4, R6        ; 成绩 - 85
    BRn IS_B              ; 如果成绩 < 85，不是 A，去检查 B

    ADD R2, R2, #1        ; 是 A，A 人数 +1
    BRnzp NEXT            ; 处理下一个学生

IS_B
    ADD R4, R0, R1        ; R4 指向当前成绩地址
    LDR R4, R4, #0        ; R4 = 当前成绩
    ADD R5, R4, R7        ; 成绩 - 75
    BRn NEXT              ; 如果成绩 < 75，不是 B

    ADD R3, R3, #1        ; 是 B，B 人数 +1
NEXT
    ADD R1, R1, #1        ; 索引 +1
MIDDLE3
    ADD R4, R1, #-8       ; 检查是否遍历完前 8 名
    BRn LOOP3             ; 如果索引 < 8，继续循环

; ==========================================
; 第四步：保存结果并结束
; ==========================================
    LD R1, A_CNT
    STR R2, R1, #0        ; 保存 A 的人数到 x4100
    LD R1, B_CNT
    STR R3, R1, #0        ; 保存 B 的人数到 x4101

    HALT                  ; 程序结束 (对应 TRAP x25)

; ==========================================
; 数据区
; ==========================================
DATA    .FILL x3200
RESULT  .FILL x4000
A_CNT   .FILL x4100
B_CNT   .FILL x4101
A_GRADE .FILL x0055       ; 85
B_GRADE .FILL x004B       ; 75
.END