-- 指导教师表
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department VARCHAR(50),
    title VARCHAR(50),
    office_location VARCHAR(50),
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_instructor_email ON instructors(email);
CREATE INDEX idx_instructor_department ON instructors(department);
CREATE INDEX idx_instructor_name ON instructors(instructor_name);

-- 班级表
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_code VARCHAR(20) NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    instructor_id INT NOT NULL,
    max_students INT,
    start_date DATE,
    end_date DATE,
    credit_hours INT,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE INDEX idx_class_code ON classes(class_code);

-- 学生表
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    admission_year INT,
    status VARCHAR(20) DEFAULT 'active',
    date_of_birth DATE,
    address TEXT,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

CREATE INDEX idx_student_email ON students(email);
CREATE INDEX idx_student_number ON students(student_number);
CREATE INDEX idx_student_name ON students(student_name);

-- 实验表
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    total_quizzes INT DEFAULT 0,
    points_possible INT NOT NULL,
    weight_percentage DECIMAL(4,2),
    start_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (created_by) REFERENCES instructors(instructor_id)
);

-- 习题表
CREATE TABLE quizzes (
    quiz_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    quiz_number INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    points_possible INT NOT NULL,
    programming_language VARCHAR(50),
    template_code TEXT,
    test_cases JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(assignment_id, quiz_number),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
);

-- 实验提交表
CREATE TABLE assignment_submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    assignment_id INT,
    attempt_number INT NOT NULL,
    total_score DECIMAL(5,2),
    ip_address VARCHAR(45),
    mac_address VARCHAR(17),
    submission_status VARCHAR(20),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    graded_at TIMESTAMP NULL,
    grader_hash_verified BOOLEAN DEFAULT FALSE,
    grader_version_used INT,
    UNIQUE(student_id, assignment_id, attempt_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
);

-- 学生实验成绩表
CREATE TABLE student_grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    assignment_id INT,
    final_score DECIMAL(5,2),
    submission_count INT DEFAULT 0,
    best_submission_id INT,
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    notes TEXT,
    UNIQUE(student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (best_submission_id) REFERENCES assignment_submissions(submission_id)
);

CREATE INDEX idx_student_grades_student ON student_grades(student_id);
CREATE INDEX idx_student_grades_assignment ON student_grades(assignment_id);
CREATE INDEX idx_submission_attempts ON assignment_submissions(student_id, assignment_id, attempt_number);

-- 自动评分的Python文件表
CREATE TABLE assignment_graders (
    grader_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_hash VARCHAR(128) NOT NULL,
    file_size INT NOT NULL,
    version INT DEFAULT 1,
    last_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    UNIQUE(assignment_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (created_by) REFERENCES instructors(instructor_id)
);

-- 安全日志表
CREATE TABLE submission_security_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id INT,
    student_id INT,
    grader_id INT,
    ip_address VARCHAR(45),
    mac_address VARCHAR(17),
    user_agent TEXT,
    geolocation TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    computed_hash VARCHAR(256) NOT NULL,
    grader_hash_valid BOOLEAN NOT NULL,
    is_suspicious BOOLEAN DEFAULT false,
    suspicious_reason TEXT,
    notes TEXT,
    FOREIGN KEY (submission_id) REFERENCES assignment_submissions(submission_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (grader_id) REFERENCES assignment_graders(grader_id)
);

CREATE INDEX idx_security_logs_submission ON submission_security_logs(submission_id);
CREATE INDEX idx_security_logs_student ON submission_security_logs(student_id);
CREATE INDEX idx_security_logs_ip ON submission_security_logs(ip_address);
CREATE INDEX idx_security_logs_time ON submission_security_logs(submission_timestamp);