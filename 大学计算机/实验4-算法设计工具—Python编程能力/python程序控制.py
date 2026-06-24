sname=input('输入姓名：')
age=int(input('输入年龄：'))
if age>=18:
    print('{0}可以参加驾考'.format(sname))
else:
    print('{0}未达到驾考年龄'.format(sname))