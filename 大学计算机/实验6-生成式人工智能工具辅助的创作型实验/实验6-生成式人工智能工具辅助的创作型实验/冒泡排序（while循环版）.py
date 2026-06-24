def bubble_sort_with_while(arr):
    """
    使用 while 循环实现冒泡排序
    :param arr: 待排序的列表
    :return: 排序后的列表
    """
    # 首先创建数组的副本，避免修改原数组
    arr_copy = arr.copy()
    n = len(arr_copy)

    # 如果数组长度小于等于1，直接返回（已经有序）
    if n <= 1:
        return arr_copy

    # 标记是否发生交换，初始为 True 进入循环
    swapped = True
    # 记录已经排好序的元素个数（每轮结束后，最后一个元素就位）
    sorted_count = 0

    # 外层 while 循环：只要发生过交换，就继续排序
    while swapped:
        # 每轮开始时，先假设没有交换
        swapped = False
        # 初始化索引，用于内层 while 循环遍历未排序部分
        i = 0

        # 内层 while 循环：遍历未排序的元素
        # 只需要比较到 n-1-sorted_count 的位置，因为后面的已经排好序了
        while i < (n - 1 - sorted_count):
            # 如果当前元素大于下一个元素，交换它们
            if arr_copy[i] > arr_copy[i + 1]:
                arr_copy[i], arr_copy[i + 1] = arr_copy[i + 1], arr_copy[i]
                swapped = True  # 标记发生了交换
            i += 1  # 索引自增，继续比较下一对元素

        # 每完成一轮，已排序的元素个数加1
        sorted_count += 1

    return arr_copy


# 测试代码
if __name__ == "__main__":
    # 测试用例
    test_array = [64, 34, 25, 12, 22, 11, 90]
    print("原始数组:", test_array)

    sorted_array = bubble_sort_with_while(test_array)
    print("排序后数组:", sorted_array)