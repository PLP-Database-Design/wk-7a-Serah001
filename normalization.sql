-- Question 1: Achieving 1NF 🛠️
-- Original table with Products column containing multiple values

CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- 1NF: Split Products into single rows (simulate splitting manually using UNION ALL)

CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, 'Laptop' FROM ProductDetail WHERE Products LIKE '%Laptop%'
UNION ALL
SELECT OrderID, CustomerName, 'Mouse' FROM ProductDetail WHERE Products LIKE '%Mouse%'
UNION ALL
SELECT OrderID, CustomerName, 'Tablet' FROM ProductDetail WHERE Products LIKE '%Tablet%'
UNION ALL
SELECT OrderID, CustomerName, 'Keyboard' FROM ProductDetail WHERE Products LIKE '%Keyboard%'
UNION ALL
SELECT OrderID, CustomerName, 'Phone' FROM ProductDetail WHERE Products LIKE '%Phone%';

-- Check the 1NF result
SELECT * FROM ProductDetail_1NF;

-- Question 2: Achieving 2NF 🧩
-- Table with partial dependency: CustomerName depends only on OrderID

CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Normalize into two tables to remove partial dependency

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert unique orders
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

-- Insert order details without CustomerName
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

-- Check normalized tables
SELECT * FROM Orders;
SELECT * FROM OrderDetails_2NF;
