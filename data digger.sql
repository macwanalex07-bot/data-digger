CREATE DATABASE data_digger;
USE data_digger;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Email VARCHAR(150),
  Address VARCHAR(255)
);


CREATE TABLE Products (
  ProductID INT PRIMARY KEY AUTO_INCREMENT,
  ProductName VARCHAR(150),
  Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
  Stock INT NOT NULL CHECK (Stock >= 0)
);


CREATE TABLE Orders (
  OrderID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT,
  OrderDate DATE,
  TotalAmount DECIMAL(12,2) NOT NULL CHECK (TotalAmount >= 0),
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE OrderDetails (
  OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID INT,
  ProductID INT,
  Quantity INT NOT NULL CHECK (Quantity > 0),
  SubTotal DECIMAL(12,2) NOT NULL CHECK (SubTotal >= 0),
  CONSTRAINT fk_od_order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT fk_od_product
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (Name, Email, Address) VALUES
('Alice Shah', 'alice@example.com', 'Navrangpura, Ahmedabad'),
('Bob Patel', 'bob@example.com', 'Bopal, Ahmedabad'),
('Charlie Mehta', 'charlie@example.com', 'SG Highway, Ahmedabad'),
('Diana Rao', 'diana@example.com', 'Satellite, Ahmedabad'),
('Eshan Desai', 'eshan@example.com', 'Maninagar, Ahmedabad');


INSERT INTO Products (ProductName, Price, Stock) VALUES
('Wireless Mouse', 799.00, 25),
('Mechanical Keyboard', 3499.00, 10),
('USB-C Cable', 299.00, 100),
('Laptop Stand', 1899.00, 15),
('Bluetooth Speaker', 2199.00, 8);


INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, CURDATE() - INTERVAL 2 DAY, 2998.00),
(1, CURDATE() - INTERVAL 15 DAY, 2199.00),
(2, CURDATE() - INTERVAL 33 DAY, 799.00),
(3, CURDATE() - INTERVAL 1 DAY, 5398.00),
(4, CURDATE() - INTERVAL 27 DAY, 1899.00);


INSERT INTO OrderDetails (OrderID, ProductID, Quantity, SubTotal) VALUES
(1, 4, 2, 3798.00),      -- Laptop Stand
(2, 5, 1, 2199.00),      -- Bluetooth Speaker
(3, 1, 1, 799.00),       -- Wireless Mouse
(4, 2, 1, 3499.00),      -- Mechanical Keyboard
(4, 1, 3, 2397.00),      -- 3 x Wireless Mouse
(5, 4, 1, 1899.00);      -- Laptop Stand


SELECT * FROM Customers;
UPDATE Customers SET Address='Prahlad Nagar' WHERE CustomerID=2;
DELETE FROM Customers WHERE CustomerID=5;
SELECT * FROM Customers WHERE Name='Alice';

SELECT * FROM Orders WHERE CustomerID=1;
UPDATE Orders SET TotalAmount=3198 WHERE OrderID=1;
DELETE FROM OrderDetails WHERE OrderID=3;
DELETE FROM Orders WHERE OrderID=3;
SELECT * FROM Orders WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;
SELECT MAX(TotalAmount), MIN(TotalAmount), AVG(TotalAmount) FROM Orders;

SELECT * FROM Products ORDER BY Price DESC;
UPDATE Products SET Price=349 WHERE ProductID=3;
DELETE FROM Products WHERE Stock=0;
SELECT * FROM Products WHERE Price BETWEEN 500 AND 2000;
SELECT MAX(Price), MIN(Price) FROM Products;

SELECT od.OrderDetailID, od.OrderID, p.ProductName, od.Quantity, od.SubTotal
FROM OrderDetails od JOIN Products p ON od.ProductID=p.ProductID
WHERE od.OrderID=4;

SELECT SUM(TotalAmount) FROM Orders;
SELECT SUM(SubTotal) FROM OrderDetails;

SELECT p.ProductName, SUM(od.Quantity) AS TotalQty
FROM OrderDetails od JOIN Products p ON od.ProductID=p.ProductID
GROUP BY p.ProductName ORDER BY TotalQty DESC LIMIT 3;

SELECT p.ProductName, COUNT(*) AS TimesSold
FROM OrderDetails od JOIN Products p ON od.ProductID=p.ProductID
WHERE p.ProductID=1 GROUP BY p.ProductName;

