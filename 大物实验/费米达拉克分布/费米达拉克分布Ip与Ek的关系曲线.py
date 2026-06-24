import matplotlib.pyplot as plt
import numpy as np

# ========== 1. 解决中文乱码的核心配置（必须放在最前面） ==========
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用黑体显示中文（Windows系统通用）
plt.rcParams['axes.unicode_minus'] = False    # 解决负号显示为方块的问题

# ========== 2. 你的实验数据（完全保留） ==========
x = [0.000,0.883,1.766,2.649,3.532,4.415,5.297,6.180,7.063,7.946,8.829,9.712]
y = [34.3,31.0,23.9,13.0,6.4,2.7,1.1,0.4,0.2,0.1,0,0]

# ========== 3. 平滑曲线拟合 ==========
x_smooth = np.linspace(min(x), max(x), 200)
y_smooth = np.interp(x_smooth, x, y)

# ========== 4. 绘图（完全保留你要的样式） ==========
plt.scatter(x, y, color='red', label='实验数据', s=80)
plt.plot(x_smooth, y_smooth, linestyle='--', color='blue', linewidth=2, label='拟合曲线')

# ========== 5. 规范标签（中文正常显示） ==========
plt.xlabel('Ek / eV', fontsize=14)
plt.ylabel('Ip / μA', fontsize=14)
plt.title('Ip与Ek的关系曲线', fontsize=16)
plt.legend(fontsize=12)
plt.grid(True, linestyle=':', linewidth=1)
plt.tick_params(axis='both', labelsize=12)  # 坐标轴刻度字体大小

plt.show()