DROP DATABASE IF EXISTS mini_project_db;
CREATE DATABASE mini_project_db;
USE mini_project_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, phone, balance)
VALUES 
('admin', '1234', '9876543210', 1000.00),
('john', 'pass123', '9123456780', 500.00);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    category VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

select * from users;