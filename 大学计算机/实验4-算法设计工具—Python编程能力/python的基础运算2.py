a,b=input('输入两个华氏温度（数据用空格隔开）:').split()
a=float(a)
b=float(b)
c=5*(a-32)/9
d=5*(b-32)/9
print('两个摄氏温度为{0:.2f}，{1:.2f}'.format(c,d))