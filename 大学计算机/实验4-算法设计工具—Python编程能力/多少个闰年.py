leap_year_count = 0

print("2000年到2024年的闰年统计：")
print("年份\t是否闰年")

for year in range(2000, 2025):

    if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
        leap_year_count += 1  # 顺序结构：计数器加1
        print(f"{year}\t是闰年")
    else:
        print(f"{year}\t不是闰年")

print(f"\n从2000年到2024年，共有 {leap_year_count} 个闰年")