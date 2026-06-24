a,b,c=input('输入长方体的长宽高（数据用空格隔开）:').split()
a=float(a)
b=float(b)
c=float(c)
area=2*(a*b+b*c+a*c)
volume=a*b*c
print('长方体的面积等于{0:.2f},面积等于{1:.2f}'.format(area,volume))