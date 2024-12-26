# 实验一的测试集， 进行实验的同学请不要修改测试文件的内容。
from termcolor import colored
import pytest
import math

test_ids ={
    "test_name_and_student_id": 0,
    "test_quiz2": 0,
    "test_subtract_abc": 0,
    "test_greet": 0,
    "test_get_hypotenuse": 0,
    "test_get_third_side": 0,
}

def reset_test_ids_values():
    for key in test_ids.keys():
        test_ids[key] = 0

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

def test_greet(target):
    """测试习题四"""
    test_name="习题四：test_greet"
    test_ids["test_greet"] = 0
    assert target('ada', 'lovelace') == 'Hello, Ada Lovelace!', "第四题答案不正确，请检查你的答案"
    test_ids["test_greet"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))


def test_get_hypotenuse(target):
    """测试习题五"""
    test_name="test_get_hypotenuse"
    test_ids["test_get_hypotenuse"] = 0
    assert target(3, 4) == pytest.approx(5.0) , "第五题答案不正确，请检查你的答案"
    assert target(6, 8) == pytest.approx(10.0)
    assert target(5, 12) == pytest.approx(13.0)
    res = target(2.5, 3.5)
    expected = (2.5**2 + 3.5**2) ** 0.5
    assert res == pytest.approx(expected) , "第五题答案不正确，请检查你的答案"
    test_ids["test_get_hypotenuse"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))

def test_get_third_side(target):
    """测试习题六"""
    test_name="习题六：test_get_third_side"
    test_ids["test_get_third_side"] = 0
    test_get_third_side_right_angle(target)
    test_get_third_side_zero_angle(target)
    test_get_third_side_180_degrees(target)
    test_get_third_side_60_degrees(target)
    test_get_third_side_arbitrary(target)
    test_ids["test_get_third_side"] = 1
    print(colored(f"恭喜你通过了{test_name}测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))


def test_get_third_side_right_angle(target):
    # 当夹角为90度(π/2弧度)时,应该符合勾股定理
    assert target(3, 4, math.pi/2) == pytest.approx(5.0)
    assert target(5, 12, math.pi/2) == pytest.approx(13.0)

def test_get_third_side_zero_angle(target):
    # 当夹角为0时,第三边长度应该是两边之差的绝对值
    assert target(5, 3, 0) == pytest.approx(2.0)
    assert target(10, 7, 0) == pytest.approx(3.0)

def test_get_third_side_180_degrees(target):
    # 当夹角为180度(π弧度)时,第三边长度应该是两边之和
    assert target(3, 4, math.pi) == pytest.approx(7.0)
    assert target(5, 7, math.pi) == pytest.approx(12.0)

def test_get_third_side_60_degrees(target):
    # 当夹角为60度(π/3弧度)时的特殊情况
    # 等边三角形的情况
    result = target(2, 2, math.pi/3)
    assert result == pytest.approx(2.0)

def test_get_third_side_arbitrary(target):
    # 测试任意角度的情况
    result = target(4, 5, math.pi/4)  # 45度
    expected = math.sqrt(4**2 + 5**2 - 2*4*5*math.cos(math.pi/4))
    assert result == pytest.approx(expected)

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
