# -*- coding:utf8 -*-

a = int(input("请输入第一个整数:"))
b = int(input("请输入第二个整数:"))

sum = 0

for i in range(a, b+1):
    if i % 2 == 0:
        sum =sum +i

print("结果为:",sum)