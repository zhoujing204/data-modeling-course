# 实验一的测试集， 提交实验作业时请不要修改测试文件的内容。
from termcolor import colored

test_ids ={
    "test_name_and_student_id": 0,
}

def test_name_and_student_id(name, student_id):
    """测试学生的名字和学号是否填好"""

    test_ids["test_name_and_student_id"] = 0
    assert name is not None, '请在name变量中填入你的名字'
    assert student_id is not None, '请在student_id变量中填入你的学号'
    print('你的名字是：', name)
    print('你的学号是：', student_id)
    test_ids["test_name_and_student_id"] = 1
    print(colored(f"恭喜你通过了这个测试。{sum(test_ids.values())}/{len(test_ids)} ", "green"))
