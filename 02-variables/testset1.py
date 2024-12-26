# 实验一的测试集， 进行实验的同学请不要修改测试文件的内容。
from termcolor import colored

test_ids ={
    "test_name_and_student_id": 0,
    "test_quiz2": 0,
    "test_subtract_abc": 0,
}

def test_name_and_student_id(name, student_id):
    """测试习题一：学生的名字和学号是否填好"""
    test_name = "习题一：test_name_and_student_id"
    test_ids["test_name_and_student_id"] = 0
    assert name is not None, '请在name变量中填入你的名字'
    assert student_id is not None, '请在student_id变量中填入你的学号'
    print('你的名字是：', name)
    print('你的学号是：', student_id)
    test_ids["test_name_and_student_id"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))

def test_quiz2(answer2):
    """测试习题二的答案是否正确"""
    test_name = "习题二：test_quiz2"
    test_ids["test_quiz2"] = 0
    assert answer2.strip().upper() == "B", "第二题答案不正确，请检查你的答案"
    test_ids["test_quiz2"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))

def test_subtract_abc(target):
    """测试习题三"""
    test_name="习题三：test_subtract_abc"
    test_ids["test_subtract_abc"] = 0
    assert target(100, 2, 1) == 97, "第三题答案不正确，请检查你的答案"
    test_ids["test_subtract_abc"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))


# TODO
# 第一阶段
# 1. 将学生的信息：姓名，学号，ip地址，mac地址，当前实验id，传输到fastapi服务器，方面实验完成时校验信息。
# 2. 学生在本地编写代码进行实验并对实验代码测试，测试完成后在本地会得到本次实验的实验成绩。
# 3. 将实验成绩、实验代码、测试代码（防止学生修改实验代码）传输到fastapi服务器，方便教师查看学生的实验成绩。
# 4. 校验学生的信息以及实验代码，包括：ip地址，mac地址，实验代码是否被修改，实验代码是否通过测试。
# 5. 将实验成绩保存到数据库。
# 6. 使用网页展示学生的实验成绩、实验代码等相关信息。
# 7. 将学生的实验成绩导出为excel文件。


# TODO
# 第二阶段
# 1. 将所有的实验题目、题目相关的信息以及对应的测试代码、测试用例保存到数据库中。
# 2. 在客户端（Vscode, Jupter Notebook或者网页）可以新建、查看、修改、删除实验题目以及测试代码。
# 3. 在客户端修改的实验题目、测试代码等信息可以同步到fastapi服务器。
