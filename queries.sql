USE Small_Business;
go


-- Query 1
SELECT ProductName
FROM Product
ORDER BY ProductName ASC;
go

-- Query 2
SELECT ProductID,  ProductPrice, ProductName
FROM Product
ORDER BY ProductPrice, ProductName;
go

-- Query 3
SELECT ProductID, ProductPrice, ProductName
FROM Product
ORDER BY ProductPrice DESC, ProductName;
go

-- Query 4
SELECT ProductName, ProductPrice
FROM Product
WHERE ProductPrice = 3.49;
go

-- Query 5
SELECT ProductName, ProductPrice
FROM Product
WHERE ProductPrice < 10;
go

-- Query 6
SELECT VendorID, ProductName 
FROM Product
WHERE VendorID != 'DLL01';
go

-- Query 7
SELECT ProductName, ProductPrice
FROM Product
WHERE ProductPrice between 5 and 10;
go

-- Query 8
SELECT ProductName, ProductPrice
FROM Product
WHERE (VendorID = 'DLL01' or VendorID = 'BRS01') and ProductPrice >= 10;
go

-- Query 9
SELECT avg(ProductPrice)
FROM Product;
go

-- Query 10
SELECT count(*)
FROM Customer;
go

-- Query 11
SELECT count(*)
FROM Customer
WHERE CustEmail is not null;
go

-- Query 12
SELECT count(ProductName), min(ProductPrice), max(ProductPrice), avg(ProductPrice)
FROM Product;
go

-- Query 13
SELECT VendorName, ProductName, ProductPrice
FROM Vendor as v
JOIN Product as p
ON v.VendorID = p.VendorID
ORDER BY ProductID;
go

-- Query 14
SELECT ProductName, VendorName, ProductPrice, Quantity
FROM Product as p
JOIN Vendor as v
ON p.VendorID = v.VendorID
JOIN OrderItem as oi
ON p.ProductID = oi.ProductID
WHERE OrderID = 20007;
go

-- Note: population script corrected (5->50)

-- Query 15
-- Step 1 
/*
SELECT OrderID
FROM OrderItem
WHERE ProductID = 'RGAN01';
*/

-- Step 2
/*
SELECT oe.CustID
FROM OrderItem as oi
JOIN OrderEntry as oe
ON oi.OrderID = oe.OrderID
WHERE ProductID = 'RGAN01';
*/

-- Step 3
SELECT CustName, CustContact
FROM Customer
WHERE CustID in (
SELECT oe.CustID
FROM OrderItem as oi
JOIN OrderEntry as oe
ON oi.OrderID = oe.OrderID
WHERE ProductID = 'RGAN01');
go

-- Query 16
SELECT c.CustName, c.CustCity, 
(SELECT COUNT(*) FROM OrderEntry as oe WHERE oe.CustID = c.CustID)
FROM Customer as c
ORDER BY c.CustName;
go


-- Query 17
SELECT CustName, CustContact, CustEmail
FROM Customer as c
WHERE CustName in 
	(SELECT CustName
	FROM Customer
	WHERE CustCity = 'Nelson' or CustCity = 'Wellington')
ORDER BY CustName, CustContact;
go
-- Note: could be done with a union but this method feels more logical to me

-- Query 18
-- Step 1
CREATE VIEW vProductCustomer
AS
SELECT DISTINCT CustName, CustContact, ProductID
FROM Customer as C
JOIN OrderEntry as oe
ON c.CustID = oe.CustID
JOIN OrderItem as oi
ON oe.OrderID = oi.OrderID;
go

-- Step 2
SELECT CustName, CustContact
FROM vProductCustomer
WHERE ProductID = 'RGAN01';
go

-- Query 19

-- Add new customer
INSERT INTO Customer(CustID,CustName,CustPhone)
VALUES('1000000006','The Toy Emporium','09-546-8552');

-- display in format with concat
SELECT CustName, CustAddress, concat(CustCity, ', ', CustPhone) as 'City, Phone'
FROM Customer;
go

-- without filter
DROP VIEW IF EXISTS vCustomerMailingLabel
go
CREATE VIEW vCustomerMailingLabel
AS
SELECT CustName, CustAddress, concat(RTRIM(CustCity), ', ', CustPhone) as 'City, Phone'
FROM Customer;
go
-- note: I added RTRIM to trim CustCity as it was adding a large gap which made the display less practical

-- with filter
DROP VIEW IF EXISTS vCustomerMailingLabel
go
CREATE VIEW vCustomerMailingLabel
AS
SELECT CustName, CustAddress, concat(RTRIM(CustCity), ', ', CustPhone) as 'City, Phone'
FROM Customer
WHERE CustCity is not NULL and CustPhone is not NULL;
go


SELECT *
FROM vCustomerMailingLabel;
go

