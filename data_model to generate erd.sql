-- 指导教师表
CREATE TABLE instructors (
    instructor_id SERIAL PRIMARY KEY,
    instructor_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department VARCHAR(50),
    title VARCHAR(50),          -- e.g., '教授', '讲师'
    office_location VARCHAR(50),
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'active',  -- active, inactive, on_leave
    password_hash VARCHAR(255) NOT NULL,  -- For authentication
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for common queries
CREATE INDEX idx_instructor_email ON instructors(email);
CREATE INDEX idx_instructor_department ON instructors(department);
CREATE INDEX idx_instructor_name ON instructors(instructor_name);

-- 班级表
CREATE TABLE classes (
    class_id SERIAL PRIMARY KEY,
    class_code VARCHAR(20) NOT NULL,      -- e.g., '数据建模01' 教学班可能包括两个班合班来上课例如'24计科01+24计科02'
    class_name VARCHAR(100) NOT NULL,     -- e.g., '24计科01'
    semester VARCHAR(20) NOT NULL,        -- e.g., 'Spring 2025'
    instructor_id INTEGER NOT NULL,       -- 引用指导教师表的指导教师id
    max_students INTEGER,
    start_date DATE,
    end_date DATE,
    credit_hours INTEGER,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active',  -- active, inactive, archived
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)  -- 外键
);

-- Index for common queries
CREATE INDEX idx_class_code ON classes(class_code);  -- 按照教学班查询


-- 学生表
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    student_number VARCHAR(20) UNIQUE NOT NULL,     -- 学号
    admission_year INTEGER,                         --  入学年份
    status VARCHAR(20) DEFAULT 'active',            -- active, inactive, graduated, suspended
    date_of_birth DATE,
    address TEXT,
    password_hash VARCHAR(255) NOT NULL,            -- For authentication
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)  -- 外键
);

-- Indexes for common queries
CREATE INDEX idx_student_email ON students(email);
CREATE INDEX idx_student_number ON students(student_number);
CREATE INDEX idx_student_name ON students(student_name);

-- 实验表
CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    class_id INTEGER REFERENCES classes(class_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    total_quizzes INTEGER DEFAULT 0,      -- Number of quizzes in this assignment
    points_possible INTEGER NOT NULL,
    weight_percentage DECIMAL(4,2),        -- 0-100%
    start_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active',   -- draft, active, archived
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES instructors(instructor_id)
);

-- 习题表
CREATE TABLE quizzes (
    quiz_id SERIAL PRIMARY KEY,
    assignment_id INTEGER REFERENCES assignments(assignment_id),
    quiz_number INTEGER NOT NULL,          -- 1,2,3,etc.
    title VARCHAR(100) NOT NULL,
    description TEXT,
    points_possible INTEGER NOT NULL,
    programming_language VARCHAR(50),
    template_code TEXT,
    test_cases JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(assignment_id, quiz_number)
);

-- 实验提交表
CREATE TABLE assignment_submissions (
    submission_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    assignment_id INTEGER REFERENCES assignments(assignment_id),
    attempt_number INTEGER NOT NULL,
    total_score DECIMAL(5,2),
    ip_address INET,                       -- Store IP address
    mac_address MACADDR,
    submission_status VARCHAR(20),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    graded_at TIMESTAMP,
    grader_hash_verified BOOLEAN DEFAULT FALSE,
    grader_version_used INTEGER,
    UNIQUE(student_id, assignment_id, attempt_number)
);

-- 学生实验成绩表
CREATE TABLE student_grades (
    grade_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    assignment_id INTEGER REFERENCES assignments(assignment_id),
    final_score DECIMAL(5,2),             -- Highest score from submissions
    submission_count INTEGER DEFAULT 0,    -- Track number of submissions
    best_submission_id INTEGER REFERENCES assignment_submissions(submission_id),
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    UNIQUE(student_id, assignment_id)
);



-- Indexes
CREATE INDEX idx_student_grades_student ON student_grades(student_id);
CREATE INDEX idx_student_grades_assignment ON student_grades(assignment_id);
CREATE INDEX idx_submission_attempts ON assignment_submissions(student_id, assignment_id, attempt_number);


-- 自动评分的Python文件表，每个实验对应一个自动评分的Python文件
CREATE TABLE assignment_graders (
    grader_id SERIAL PRIMARY KEY,
    assignment_id INTEGER REFERENCES assignments(assignment_id) UNIQUE,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_hash VARCHAR(128) NOT NULL,       -- SHA-512 hash of grading file
    file_size INTEGER NOT NULL,
    version INTEGER DEFAULT 1,
    last_verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES instructors(instructor_id)
);

-- 安全日志表: 如果同一ip地址或mac地址在短时间（4小时）内，提交了多个不同的学生的作业，可能是作弊行为
CREATE TABLE submission_security_logs (
    log_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES assignment_submissions(submission_id),
    student_id INTEGER REFERENCES students(student_id),
    grader_id INTEGER REFERENCES assignment_graders(grader_id),
    -- Security tracking
    ip_address INET,
    mac_address MACADDR,
    user_agent TEXT,
    geolocation TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Grader verification
    computed_hash VARCHAR(256) NOT NULL,
    grader_hash_valid BOOLEAN NOT NULL,
    -- Common fields
    is_suspicious BOOLEAN DEFAULT false,
    suspicious_reason TEXT,  -- 'MULTIPLE_STUDENTS_SAME_IP', 'INVALID_GRADER_HASH', etc.
    notes TEXT
);

-- Indexes
CREATE INDEX idx_security_logs_submission ON submission_security_logs(submission_id);
CREATE INDEX idx_security_logs_student ON submission_security_logs(student_id);
CREATE INDEX idx_security_logs_ip ON submission_security_logs(ip_address);
CREATE INDEX idx_security_logs_time ON submission_security_logs(submission_timestamp);
