def insertion_sort(arr):
    """
    插入排序算法实现
    :param arr: 待排序的列表（支持数字类型）
    :return: 排序后的新列表（不修改原列表）
    """
    # 复制原列表，避免修改输入的原始数据
    arr_copy = arr.copy()
    n = len(arr_copy)

    # 从第二个元素开始遍历（索引1），第一个元素默认已排序
    for i in range(1, n):
        # 保存当前待插入的元素
        current_value = arr_copy[i]
        # 指向已排序区域的最后一个元素
        j = i - 1

        # 向前遍历已排序区域，找到插入位置
        # 条件：j >= 0（不越界）且 当前元素小于已排序的元素
        while j >= 0 and current_value < arr_copy[j]:
            # 将已排序元素后移一位，为当前元素腾出位置
            arr_copy[j + 1] = arr_copy[j]
            j -= 1

        # 将当前元素插入到正确位置
        arr_copy[j + 1] = current_value

    return arr_copy


# 测试代码
if __name__ == "__main__":
    # 待排序的测试列表
    test_list = [5, 2, 9, 1, 5, 6]
    # 调用插入排序函数
    sorted_list = insertion_sort(test_list)

    print(f"原始列表: {test_list}")
    print(f"排序后列表: {sorted_list}")