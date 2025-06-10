-- CREATING TABLES

-- =========================
-- Customers
-- =========================
IF OBJECT_ID('Customers', 'U') IS NOT NULL
	DROP TABLE Custumers;
GO

CREATE TABLE Customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL
);
GO

INSERT INTO Customers (name, email, registration_date) VALUES
('Alice Johnson', 'alice.johnson@example.com', '2022-01-15'),
('Bob Smith', 'bob.smith@example.com', '2021-12-22'),
('Charlie Davis', 'charlie.davis@example.com', '2023-03-10'),
('Diana Evans', 'diana.evans@example.com', '2022-08-07'),
('Ethan Brooks', 'ethan.brooks@example.com', '2021-10-05'),
('Fiona Adams', 'fiona.adams@example.com', '2022-05-11'),
('George Miller', 'george.miller@example.com', '2023-02-19'),
('Hannah Clark', 'hannah.clark@example.com', '2021-11-30'),
('Ian Lewis', 'ian.lewis@example.com', '2022-04-25'),
('Julia Wright', 'julia.wright@example.com', '2023-01-17'),
('Kevin Hall', 'kevin.hall@example.com', '2021-09-02'),
('Laura Scott', 'laura.scott@example.com', '2022-06-14'),
('Mike Young', 'mike.young@example.com', '2023-05-02'),
('Nina King', 'nina.king@example.com', '2021-07-28'),
('Oscar Perez', 'oscar.perez@example.com', '2022-03-30'),
('Paula Rivera', 'paula.rivera@example.com', '2023-04-08'),
('Quentin Reed', 'quentin.reed@example.com', '2022-10-21'),
('Rachel Cooper', 'rachel.cooper@example.com', '2021-06-16'),
('Sam Foster', 'sam.foster@example.com', '2023-03-22'),
('Tina Ward', 'tina.ward@example.com', '2022-11-13'),
('Ulysses James', 'ulysses.james@example.com', '2021-05-10'),
('Vera Gray', 'vera.gray@example.com', '2023-01-29'),
('William Diaz', 'william.diaz@example.com', '2022-07-07'),
('Xena Ross', 'xena.ross@example.com', '2021-04-18'),
('Yusuf Morgan', 'yusuf.morgan@example.com', '2022-09-01'),
('Zara Price', 'zara.price@example.com', '2023-02-11'),
('Adam Ford', 'adam.ford@example.com', '2021-03-27'),
('Bella Hayes', 'bella.hayes@example.com', '2022-12-03'),
('Caleb Bennett', 'caleb.bennett@example.com', '2023-04-20'),
('Dana Hughes', 'dana.hughes@example.com', '2021-02-08');
GO

-- =========================
-- Products
-- =========================
IF OBJECT_ID('Products', 'U') IS NOT NULL
	DROP TABLE Products;
GO

CREATE TABLE Products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
GO

INSERT INTO Products (name, category, price) VALUES
('Apple iPhone 14', 'Electronics', 799.99),
('Samsung Galaxy S23', 'Electronics', 849.99),
('Sony WH-1000XM5 Headphones', 'Electronics', 349.00),
('Dell XPS 13 Laptop', 'Computers', 999.99),
('MacBook Air M2', 'Computers', 1199.00),
('Logitech MX Master 3', 'Accessories', 99.99),
('Amazon Kindle Paperwhite', 'Electronics', 139.99),
('HP Envy Printer', 'Office', 179.99),
('Nike Air Max 270', 'Clothing', 150.00),
('Adidas Ultraboost', 'Clothing', 180.00),
('Ray-Ban Sunglasses', 'Accessories', 129.99),
('North Face Backpack', 'Accessories', 89.00),
('Canon EOS Rebel T7', 'Photography', 479.00),
('Samsung 55" 4K TV', 'Electronics', 599.99),
('Bose SoundLink Speaker', 'Electronics', 129.00),
('Apple Watch Series 8', 'Electronics', 399.00),
('Fitbit Charge 5', 'Electronics', 149.95),
('Instant Pot Duo 7-in-1', 'Home Appliances', 99.99),
('Dyson V11 Vacuum', 'Home Appliances', 599.00),
('Philips Airfryer', 'Home Appliances', 199.99),
('Levi''s 501 Jeans', 'Clothing', 69.99),
('Zara Leather Jacket', 'Clothing', 199.00),
('IKEA Desk', 'Furniture', 129.00),
('ASUS ROG Gaming Monitor', 'Computers', 299.99),
('Apple Magic Keyboard', 'Accessories', 99.00),
('TP-Link WiFi Router', 'Electronics', 89.99),
('Crocs Classic Clogs', 'Clothing', 49.99),
('KitchenAid Stand Mixer', 'Home Appliances', 399.00),
('GoPro HERO11', 'Photography', 499.99),
('WD External HDD 2TB', 'Computers', 79.99);
GO

-- =========================
-- Departments
-- =========================
IF OBJECT_ID('Departments', 'U') IS NOT NULL
	DROP TABLE Departments;
GO

CREATE TABLE Departments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
GO

INSERT INTO Departments (name, location) VALUES
('Human Resources', 'Warsaw'),
('Sales', 'Krakow'),
('IT', 'Wroclaw'),
('Finance', 'Gdansk'),
('Marketing', 'Poznan');
GO

-- =========================
-- Employees
-- =========================
IF OBJECT_ID('Employees', 'U') IS NOT NULL
	DROP TABLE Employees;
GO

CREATE TABLE Employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    manager_id INT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(id),
    FOREIGN KEY (manager_id) REFERENCES Employees(id)
);
GO

INSERT INTO Employees (first_name, last_name, hire_date, department_id, position, salary, manager_id) VALUES
('Emma', 'Watson', '2019-03-15', 1, 'HR Manager', 7200.00, NULL),
('Liam', 'Brown', '2020-06-12', 2, 'Sales Manager', 7500.00, NULL),
('Olivia', 'Taylor', '2018-08-01', 3, 'IT Director', 9000.00, NULL),
('Noah', 'Wilson', '2021-09-23', 2, 'Sales Representative', 4200.00, 2),
('Ava', 'Lee', '2020-01-10', 1, 'HR Specialist', 4100.00, 1),
('Elijah', 'Harris', '2022-04-18', 3, 'System Administrator', 5300.00, 3),
('Sophia', 'Clark', '2017-12-30', 4, 'Finance Manager', 7600.00, NULL),
('James', 'Hall', '2020-10-20', 4, 'Accountant', 5100.00, 7),
('Isabella', 'Allen', '2021-02-22', 5, 'Marketing Coordinator', 4300.00, NULL),
('William', 'Scott', '2019-06-11', 3, 'Software Developer', 6000.00, 3),
('Mia', 'Young', '2023-03-27', 2, 'Sales Assistant', 3700.00, 2),
('Benjamin', 'King', '2018-07-05', 5, 'Marketing Manager', 7200.00, NULL),
('Charlotte', 'Wright', '2022-08-09', 5, 'Content Specialist', 4400.00, 12),
('Lucas', 'Green', '2020-11-16', 3, 'IT Support', 3900.00, 3),
('Amelia', 'Baker', '2019-09-14', 4, 'Financial Analyst', 5800.00, 7),
('Henry', 'Gonzalez', '2021-07-12', 3, 'Network Engineer', 5600.00, 3),
('Harper', 'Nelson', '2023-01-05', 1, 'Recruiter', 4100.00, 1),
('Alexander', 'Carter', '2020-05-22', 2, 'Account Executive', 4800.00, 2),
('Evelyn', 'Mitchell', '2018-02-28', 4, 'Auditor', 5500.00, 7),
('Daniel', 'Perez', '2021-06-30', 5, 'SEO Specialist', 4600.00, 12),
('Abigail', 'Roberts', '2017-03-17', 1, 'HR Assistant', 3700.00, 1),
('Matthew', 'Turner', '2023-04-03', 3, 'Junior Developer', 4200.00, 10),
('Ella', 'Phillips', '2019-12-20', 2, 'Sales Consultant', 4600.00, 2),
('Sebastian', 'Campbell', '2022-07-14', 4, 'Payroll Clerk', 4000.00, 7),
('Aria', 'Parker', '2020-03-01', 5, 'PR Specialist', 4700.00, 12),
('Jack', 'Evans', '2021-01-10', 3, 'IT Technician', 4500.00, 3),
('Grace', 'Edwards', '2022-06-25', 1, 'HR Coordinator', 4300.00, 1),
('Logan', 'Collins', '2020-09-18', 2, 'Sales Analyst', 4900.00, 2),
('Chloe', 'Stewart', '2018-04-27', 5, 'Brand Manager', 6800.00, 12),
('Jackson', 'Morris', '2019-05-03', 3, 'DevOps Engineer', 6100.00, 3);
GO

-- =========================
-- Orders
-- =========================
IF OBJECT_ID('Orders', 'U') IS NOT NULL
	DROP TABLE Orders;
GO

CREATE TABLE Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    FOREIGN KEY (employee_id) REFERENCES Employees(id)
);
GO

INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 5, '2023-01-15', 1249.99),
(2, 2, '2023-02-10', 749.00),
(3, 10, '2023-03-05', 210.50),
(4, 22, '2023-04-12', 329.99),
(5, 8, '2023-05-21', 1599.00),
(6, 12, '2023-06-30', 89.99),
(7, 2, '2023-07-10', 219.00),
(8, 10, '2023-07-25', 460.00),
(9, 3, '2023-08-01', 720.00),
(10, 5, '2023-08-14', 1099.00),
(11, 20, '2023-08-29', 650.00),
(12, 2, '2023-09-10', 129.99),
(13, 18, '2023-09-25', 440.00),
(14, 7, '2023-10-05', 1980.00),
(15, 6, '2023-10-20', 145.00),
(16, 9, '2023-11-01', 299.00),
(17, 13, '2023-11-15', 340.00),
(18, 22, '2023-12-03', 90.00),
(19, 5, '2023-12-20', 1500.00),
(20, 8, '2024-01-08', 350.00),
(21, 14, '2024-01-21', 450.00),
(22, 3, '2024-02-10', 670.00),
(23, 17, '2024-02-25', 790.00),
(24, 21, '2024-03-05', 610.00),
(25, 6, '2024-03-20', 119.99),
(26, 10, '2024-04-04', 550.00),
(27, 4, '2024-04-18', 109.00),
(28, 19, '2024-05-02', 875.00),
(29, 23, '2024-05-10', 289.00),
(30, 1, '2024-05-20', 1350.00);
GO

-- =========================
-- OrderItems
-- =========================
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL
	DROP TABLE OrderItems;
GO

CREATE TABLE OrderItems (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);
GO

INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 799.99),
(1, 6, 2, 99.99),
(2, 2, 1, 849.99),
(3, 3, 1, 349.00),
(3, 7, 2, 139.99),
(4, 10, 1, 180.00),
(5, 5, 1, 1199.00),
(5, 25, 2, 99.00),
(6, 24, 1, 299.99),
(7, 8, 1, 179.99),
(8, 9, 2, 150.00),
(9, 11, 1, 129.99),
(9, 12, 1, 89.00),
(10, 13, 1, 479.00),
(10, 6, 3, 99.99),
(11, 14, 1, 599.99),
(12, 15, 2, 129.00),
(13, 17, 1, 149.95),
(14, 18, 1, 99.99),
(14, 19, 1, 599.00),
(14, 20, 2, 199.99),
(15, 21, 1, 69.99),
(15, 22, 1, 199.00),
(16, 23, 1, 129.00),
(17, 4, 1, 999.99),
(18, 26, 2, 89.99),
(19, 27, 1, 49.99),
(19, 28, 1, 399.00),
(20, 29, 1, 499.99),
(20, 30, 1, 79.99),
(21, 16, 1, 399.00),
(22, 3, 2, 349.00),
(23, 12, 1, 89.00),
(24, 8, 1, 179.99),
(25, 7, 1, 139.99),
(26, 5, 1, 1199.00),
(27, 13, 1, 479.00),
(27, 6, 1, 99.99),
(28, 14, 1, 599.99),
(29, 10, 1, 180.00),
(29, 25, 1, 99.00),
(30, 1, 1, 799.99),
(30, 2, 1, 849.99),
(30, 6, 1, 99.99);
GO

-- =========================
-- EmployeeAbsences
-- =========================
IF OBJECT_ID('EmployeeAbsences', 'U') IS NOT NULL
	DROP TABLE EmployeeAbsences;
GO

CREATE TABLE EmployeeAbsences (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    absence_start DATE NOT NULL,
    absence_end DATE NOT NULL,
    absence_reason VARCHAR(255) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(id)
);
GO

INSERT INTO EmployeeAbsences (employee_id, absence_start, absence_end, absence_reason) VALUES
(1, '2023-07-01', '2023-07-10', 'Vacation'),
(3, '2023-05-15', '2023-05-17', 'Sick leave'),
(5, '2023-06-20', '2023-06-21', 'Doctor appointment'),
(7, '2023-12-24', '2024-01-02', 'Christmas break'),
(10, '2023-09-04', '2023-09-08', 'Family emergency'),
(12, '2024-02-01', '2024-02-05', 'Sick leave'),
(15, '2023-11-13', '2023-11-17', 'Vacation'),
(18, '2023-03-01', '2023-03-02', 'Training'),
(20, '2023-08-10', '2023-08-15', 'Vacation'),
(22, '2024-04-18', '2024-04-19', 'Medical leave'),
(23, '2023-10-20', '2023-10-22', 'Personal leave'),
(25, '2023-06-01', '2023-06-03', 'Conference'),
(27, '2024-01-10', '2024-01-14', 'Flu'),
(28, '2023-09-25', '2023-09-29', 'Annual leave'),
(30, '2023-12-18', '2023-12-22', 'Holiday');
GO

-- =========================
-- Payments
-- =========================
IF OBJECT_ID('Payments', 'U') IS NOT NULL
	DROP TABLE Payments;
GO

CREATE TABLE Payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(id)
);
GO

INSERT INTO Payments (order_id, payment_date, payment_method, amount_paid) VALUES
(1, '2023-01-16', 'Credit Card', 1249.99),
(2, '2023-02-11', 'PayPal', 749.00),
(3, '2023-03-06', 'Credit Card', 210.50),
(4, '2023-04-12', 'Bank Transfer', 329.99),
(5, '2023-05-22', 'Credit Card', 1599.00),
(6, '2023-07-01', 'Cash', 89.99),
(7, '2023-07-11', 'Bank Transfer', 219.00),
(8, '2023-07-26', 'Credit Card', 460.00),
(9, '2023-08-02', 'PayPal', 720.00),
(10, '2023-08-15', 'Credit Card', 1099.00),
(11, '2023-08-30', 'Credit Card', 650.00),
(12, '2023-09-11', 'Cash', 129.99),
(13, '2023-09-26', 'Credit Card', 440.00),
(14, '2023-10-06', 'Bank Transfer', 1980.00),
(15, '2023-10-21', 'Credit Card', 145.00),
(16, '2023-11-02', 'PayPal', 299.00),
(17, '2023-11-16', 'Credit Card', 340.00),
(18, '2023-12-04', 'Bank Transfer', 90.00),
(19, '2023-12-21', 'Credit Card', 1500.00),
(20, '2024-01-09', 'PayPal', 350.00),
(21, '2024-01-22', 'Credit Card', 450.00),
(22, '2024-02-11', 'Credit Card', 670.00),
(23, '2024-02-26', 'Bank Transfer', 790.00),
(24, '2024-03-06', 'Credit Card', 610.00),
(25, '2024-03-21', 'PayPal', 119.99),
(26, '2024-04-05', 'Credit Card', 550.00),
(27, '2024-04-19', 'Cash', 109.00),
(28, '2024-05-03', 'Credit Card', 875.00),
(29, '2024-05-11', 'PayPal', 289.00),
(30, '2024-05-21', 'Credit Card', 1350.00);
GO