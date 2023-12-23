--Customers Table
CREATE TABLE Customers (
CustomerID Int PRIMARY KEY,
FirstName Varchar(100),
LastName Varchar(100),
Email Varchar(100),
Phone Varchar(20),
Constraint C_Email UNIQUE(Email)
);
-- Orders Table
CREATE TABLE Orders (
OrderID Int PRIMARY KEY,
CustomerID Int,
OrderDate DATE,
TotalAmount Int
Constraint O_C_ID Foreign key(CustomerID) References Customers(CustomerID)
);
-- MenuItems Table

CREATE TABLE MenuItems (
ItemID Int PRIMARY KEY,
Name Varchar(100),
Price money
);
-- OrderItems Table
CREATE TABLE OrderItems (
OrderItemID Int PRIMARY KEY,
OrderID Int REFERENCES Orders(OrderID),
ItemID Int REFERENCES MenuItems(ItemID),
Quantity Int
);
-- Employees Table
CREATE TABLE Employees (
EmployeeID Int PRIMARY KEY,
FirstName Varchar(100),
LastName Varchar(100),
Position Varchar(50),
HireDate DATE
);
-- Ingredients Table
CREATE TABLE Ingredients (
IngredientID Int PRIMARY KEY,
Name Varchar(100)
);

-- MenuItemIngredients Table

CREATE TABLE MenuItemIngredients (
ItemID Int REFERENCES MenuItems(ItemID),
IngredientID Int REFERENCES Ingredients(IngredientID),
PRIMARY KEY (ItemID, IngredientID)
);

-- Insert data to Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email,
Phone)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '555-1234'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '555-5678'),
(3, 'Bob', 'Johnson', 'bob.johnson@example.com', '555-9876'),
(4, 'Alice', 'Williams', 'alice.williams@example.com', '555-4321'),
(5, 'Charlie', 'Brown', 'charlie.brown@example.com', '555-8765');
-- Insert data to Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(101, 1,'2023-01-15', 100),
(102, 2,'2023-02-20', 50),
(103, 3,'2023-03-25', 75),
(104, 4,'2023-04-10', 30),
(105, 5,'2023-05-05', 80)
--Insert data to OrderItems
INSERT INTO OrderItems (OrderItemID, OrderID, ItemID, Quantity)
VALUES
(201, 101, 1, 2),
(202, 101, 2, 1),
(203, 102, 3, 3),
(204, 103, 2, 2),
(205, 104, 1, 1),
(206, 105, 3, 1);

-- Inserting sample values into MenuItems table
INSERT INTO MenuItems (ItemID, Name, Price)
VALUES
(1, 'Chicken Salad', 10.00),
(2, 'Pizza', 15.00),
(3, 'Pasta', 12.50);
-- Insert data to Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Position,
HireDate)
VALUES
(1, 'Emily', 'Jones', 'Chef','2023-11-15'),
(2, 'Michael', 'Brown', 'Waiter','2022-01-25'),
(3, 'Sara', 'Clark', 'Bartender','2021-01-12'),
(4, 'David', 'Miller', 'Event Coordinator','2023-01-15'),
(5, 'Rachel', 'Moore', 'Server','2023-03-16')
--Insert into Ingredients Table
INSERT INTO Ingredients (IngredientID, Name)
VALUES
(1, 'Chicken'),
(2, 'Lettuce'),
(3, 'Tomato'),
(4, 'Cheese'),
(5, 'Flour'),
(6, 'Tomato Sauce'),
(7, 'Mozzarella Cheese');
-- Inserting sample values into MenuItemIngredients table
INSERT INTO MenuItemIngredients (ItemID, IngredientID)
VALUES
(1, 1), -- Chicken Salad contains Chicken
(1, 2), -- Chicken Salad contains Lettuce
(1, 3), -- Chicken Salad contains Tomato
(2, 5), -- Pizza contains Flour
(2, 6), -- Pizza contains Tomato Sauce
(2, 7); -- Pizza contains Mozzarella Cheese

--Query 1

SELECT
    mi.Name as MenuItem,
    SUM(oi.Quantity) as TotalQuantity,
    SUM(oi.Quantity * mi.Price) as TotalSales
FROM
    MenuItems mi
JOIN
    OrderItems oi ON mi.ItemID = oi.ItemID
GROUP BY
    mi.Name
ORDER BY
    TotalSales DESC;
--Query 2
SELECT
    c.CustomerID,
    c.FirstName as CustomerName,
    COUNT(o.OrderID) as NumberOfOrders,
    SUM(o.TotalAmount) as TotalAmountSpent
FROM
    Customers c
JOIN
    Orders o ON c.CustomerID = o.CustomerID
JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY
    c.CustomerID, c.FirstName
ORDER BY
    TotalAmountSpent DESC
FETCH FIRST 5 ROWS ONLY;
--Query 3
SELECT
    mi.Name as MenuItem,
    i.Name as Ingredient
FROM
    MenuItems mi
JOIN
    MenuItemIngredients mii ON mi.ItemID = mii.ItemID
JOIN
    Ingredients i ON mii.IngredientID = i.IngredientID
WHERE
    i.IngredientID NOT IN (SELECT IngredientID FROM Ingredients)
ORDER BY
    mi.Name, i.Name;
--Query 4
SELECT
    e.EmployeeID,
    e.FirstName as EmployeeName,
    e.Position,
    COUNT(o.OrderID) as OrdersServed
FROM
    Employees e
JOIN
    Orders o ON e.EmployeeID = o.CustomerID
GROUP BY
    e.EmployeeID, e.FirstName, e.Position
ORDER BY
    OrdersServed DESC;
--Query 5
SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName as CustomerName,
    mi.Name as MenuItem,
    oi.Quantity
FROM
    Orders o
JOIN
    Customers c ON o.CustomerID = c.CustomerID
JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
JOIN
    MenuItems mi ON oi.ItemID = mi.ItemID
WHERE
    TRUNC(o.OrderDate) = TO_DATE('03-JAN-2022', 'DD-MON-YYYY')
ORDER BY
    o.OrderID, mi.Name;
--Query 6
SELECT
    i.Name as Ingredient,
    COUNT(DISTINCT mii.ItemID) as NumMenuItems
FROM
    Ingredients i
JOIN
    MenuItemIngredients mii ON i.IngredientID = mii.IngredientID
GROUP BY
    i.IngredientID, i.Name
HAVING
    COUNT(DISTINCT mii.ItemID) > 1
ORDER BY
    NumMenuItems DESC;
--Query 7
SELECT
    mi.Name as MenuItem,
    AVG(oi.Quantity) as AvgQuantity
FROM
    MenuItems mi
JOIN
    OrderItems oi ON mi.ItemID = oi.ItemID
GROUP BY
    mi.Name
ORDER BY
    AvgQuantity DESC;
--Query 8
SELECT
    c.CustomerID,
    c.FirstName as CustomerName
FROM
    Customers c
WHERE
    c.CustomerID in (SELECT DISTINCT CustomerID FROM Orders)
ORDER BY
    c.CustomerID;
--Query 9
SELECT
    mi.Name as MenuItem,
    COUNT(mii.IngredientID) as NumIngredients
FROM
    MenuItems mi
JOIN
    MenuItemIngredients mii ON mi.ItemID = mii.ItemID
GROUP BY
    mi.Name
ORDER BY
    NumIngredients DESC;
--Query 10
SELECT
    c.CustomerID,
    c.FirstName as CustomerName,
    COUNT(o.OrderID) as NumberOfOrders,
    AVG(o.TotalAmount) as AvgAmountSpent
FROM
    Customers c
JOIN
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID, c.FirstName
HAVING
    COUNT(o.OrderID) > 0
ORDER BY
    AvgAmountSpent DESC;
