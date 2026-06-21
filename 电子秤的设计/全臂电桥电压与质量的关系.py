import matplotlib.pyplot as plt
import numpy as np

# ===================== 固定配置（不用改）=====================
plt.rcParams['font.sans-serif'] = ['SimHei']   # 解决中文乱码
plt.rcParams['axes.unicode_minus'] = False    # 解决负号显示问题

# ===================== 【这里改你的实验数据】 =====================
x = [0,20,40,60,80,100,120]
y = [0.0,33.7,74.5,110.1,150.5,189.5,227.0]

# ===================== 平滑拟合（不用改）=====================
x_smooth = np.linspace(min(x), max(x), 200)
y_smooth = np.interp(x_smooth, x, y)

# ===================== 绘图（不用改）=====================
plt.scatter(x, y, color='red', label='实验数据', s=60)
plt.plot(x_smooth, y_smooth, linestyle='--', color='blue', linewidth=2, label='拟合曲线')

# ===================== 【这里改坐标轴名称、标题】 =====================
plt.xlabel('M / g', fontsize=12)
plt.ylabel('ΔU / mV', fontsize=12)
plt.title('全臂电桥电压与质量的关系', fontsize=14)

plt.legend(fontsize=11)
plt.grid(True, linestyle=':')
plt.tight_layout()
plt.show()