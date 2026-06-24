import matplotlib.pyplot as plt
import numpy as np

# ===================== 固定配置（不用改）=====================
plt.rcParams['font.sans-serif'] = ['SimHei']   # 解决中文乱码
plt.rcParams['axes.unicode_minus'] = False    # 解决负号显示问题

# ===================== 【这里改你的实验数据】 =====================
x = [0,27.2,38.4,46.4,52.8,57.6]
y = [0,188.9,288.9,644.4,777.8,955.6]

# ===================== 平滑拟合（不用改）=====================
x_smooth = np.linspace(min(x), max(x), 200)
y_smooth = np.interp(x_smooth, x, y)

# ===================== 绘图（不用改）=====================
plt.scatter(x, y, color='red', label='实验数据', s=60)
plt.plot(x_smooth, y_smooth, linestyle='--', color='blue', linewidth=2, label='拟合曲线')

# ===================== 【这里改坐标轴名称、标题】 =====================
plt.xlabel('H / (A/m)', fontsize=12)
plt.ylabel('B / (mT)', fontsize=12)
plt.title('磁化曲线图', fontsize=14)

plt.legend(fontsize=11)
plt.grid(True, linestyle=':')
plt.tight_layout()
plt.show()