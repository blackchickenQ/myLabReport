import openai
import base64
import os

# -------------------------- 1. 关键配置（必须修改！）--------------------------
# 选择你的模型服务类型：1=第三方API（硅基流动/火山引擎），2=本地ollama部署
SERVICE_TYPE = 1

# 如果是SERVICE_TYPE=1（第三方API），修改以下2项：
API_KEY = "sk-icmwqfegdsuppjqnkyhokadjxiuqhjmlvspvyrnhkhrjaeop"  # 替换成你复制的API Key
BASE_URL = "https://api.siliconflow.cn/v1"  # 硅基流动的Base URL，火山引擎可查官网文档

# 如果是SERVICE_TYPE=2（本地ollama），无需修改以下2项：
LOCAL_API_KEY = "EMPTY"
LOCAL_BASE_URL = "http://localhost:11434/v1"


# -----------------------------------------------------------------------------

# -------------------------- 2. 图片转Base64编码（无需修改）--------------------------
def encode_image(image_path):
    """
    功能：把本地图片转换成大模型能识别的Base64字符串
    参数：image_path = 图片文件路径（比如"car1.jpg"）
    返回：Base64编码的字符串
    """
    # 检查图片文件是否存在
    if not os.path.exists(image_path):
        print(f"错误：找不到图片文件 {image_path}")
        return None

    # 读取图片并转换为Base64
    with open(image_path, "rb") as image_file:
        # 转换为Base64编码
        base64_str = base64.b64encode(image_file.read()).decode("utf-8")

    # 返回Data URI格式（部分模型需要，兼容OpenAI格式）
    image_ext = os.path.splitext(image_path)[1].strip(".")  # 获取图片后缀（jpg/png）
    return f"data:image/{image_ext};base64,{base64_str}"


# -------------------------- 3. 初始化大模型客户端（无需修改）--------------------------
def init_client():
    """
    功能：连接大模型服务，创建客户端
    返回：初始化后的客户端
    """
    if SERVICE_TYPE == 1:
        # 连接第三方API（硅基流动/火山引擎）
        client = openai.OpenAI(
            api_key=API_KEY,
            base_url=BASE_URL
        )
    else:
        # 连接本地ollama部署的模型
        client = openai.OpenAI(
            api_key=LOCAL_API_KEY,
            base_url=LOCAL_BASE_URL
        )
    return client


# -------------------------- 4. 核心识别逻辑（无需修改，可优化Prompt）--------------------------
def recognize_license_plate(client, image_base64):
    """
    功能：向大模型发送请求，提取车牌号码
    参数：client=客户端，image_base64=图片的Base64编码
    返回：识别出的车牌号
    """
    # 提示词设计（关键！让模型只输出车牌号，无多余内容）
    system_prompt = """你是一个专业的车牌识别工具，只需要从图片中提取车牌号码，不输出任何额外文字、解释或描述。
    要求：
    1. 严格按照车牌原始格式输出（比如“粤A·88888”“京B12345”，包含省份简称、字母、数字和分隔符）
    2. 若图片中没有车牌或无法识别，输出“未识别到车牌”
    3. 只返回结果，不要加任何前缀或后缀（比如“车牌是：”“答案：”等）"""

    # 构建请求消息（符合Chat Completions API标准）
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": [
            {"type": "text", "text": "提取这张图片中的车牌号码"},
            {"type": "image_url", "image_url": {"url": image_base64}}  # 传入Base64图片
        ]}
    ]

    # 发送请求给模型
    response = client.chat.completions.create(
        model="Pro/Qwen/Qwen2.5-VL-7B-Instruct",  # 模型名称（必须和你选择的一致）
        messages=messages,
        temperature=0.0  # 温度越低，结果越稳定（不建议修改）
    )

    # 提取并返回模型输出（去除多余空格）
    return response.choices[0].message.content.strip()


# -------------------------- 5. 批量测试（修改测试图片路径即可）--------------------------
if __name__ == "__main__":
    # 1. 初始化客户端
    client = init_client()

    # 2. 定义测试图片路径（替换成你的图片文件名）
    test_images = [
        "car1.jpeg",
        "car2.png",
        "car3.jpeg"
    ]

    # 3. 批量识别并打印结果
    print("车牌识别结果：")
    print("-" * 20)
    for img_path in test_images:
        # 转换图片为Base64
        img_base64 = encode_image(img_path)
        if not img_base64:
            continue
        # 识别车牌
        result = recognize_license_plate(client, img_base64)
        # 打印结果
        print(f"图片 {img_path}：{result}")
    print("-" * 20)