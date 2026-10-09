-- BTE 423 Database Management Systems: Term Project 2
-- Group #: 3
-- Member 1: Naomi Pisfil-Capunay Campos
-- Member 2: Michelle Tran
-- Member 3: Juliana Geyer-Kim

-- ---------------------------------------------------------------------------------------------------------------------------
-- Client Form (Student Name: Michelle Tran)
-- Query 1 - What is the average sale price per item 
SELECT item.ItemID, item.Description, AVG(clientorderitem.SalePrice) AS AverageSalePrice
FROM item
INNER JOIN clientorderitem ON item.ItemID = clientorderitem.ItemID
WHERE clientorderitem.SalePrice IS NOT NULL
GROUP BY item.ItemID, item.Description;


-- Query 2 - Which clients have placed more than one project order?
SELECT client.ClientID, client.ClientFirstName, client.ClientLastName,
		Count(clientorderform.ProjectID) AS NumberOfProjects
FROM client
INNER JOIN clientorderform ON client.ClientID = clientorderform.ClientID
WHERE clientorderform.ProjectID IS NOT NULL
GROUP BY client.ClientID, client.ClientFirstName, client.ClientLastName
HAVING COUNT(clientorderform.ProjectID) > 1;

-- Query 3 - What is the totoal quantity of items ordered for each project?
SELECT ProjectID, Sum(Quantity) AS TotalQuantity
FROM ClientOrderItem 
WHERE Quantity is NOT NULL
GROUP BY ProjectID; 


-- Query 4 - Which clients have never placed a project order?
SELECT ClientID, ClientFirstName, ClientLastName
From Client
Where ClientID NOT IN (
	SELECT ClientID
    FROM ClientOrderForm
    WHERE CLientID is NOT NULL

);


-- ---------------------------------------------------------------------------------------------------------------------------
-- Billing Form (Student Name: Juliana Geyer-Kim)
-- Query 1 - Which clients have a total amount paid exceeding $500?

select client.ClientID, client.ClientFirstName, client.ClientLastName
from client
inner join billingform ON client.ClientID = billingForm.ClientID
inner join billingpayment ON billingForm.BillingID = billingPayment.BillingID
WHERE billingPayment.AmountPaid IS NOT NULL
GROUP BY Client.ClientID, Client.ClientFirstName, Client.ClientLastName
HAVING SUM(billingPayment.AmountPaid) > 500;

-- Query 2 - What is the average project total cost per employee who has handled billing?

SELECT employee.EmployeeID, employee.FirstName, employee.LastName, AVG(billingpayment.ProjectTotalCost) AS AvgProjectCost
FROM employee
inner join billingform ON employee.EmployeeID = billingForm.EmployeeID
inner join billingpayment ON billingForm.BillingID = billingPayment.BillingID
WHERE billingpayment.ProjectTotalCost IS NOT NULL
GROUP BY employee.EmployeeID, employee.FirstName, employee.LastName;


-- Query 3 - Which billing payments have an amount paid above the average payment amount?

SELECT BillingID, PaymentID, AmountPaid, ProjectTotalCost
FROM billingpayment
WHERE AmountPaid > (
    SELECT AVG(AmountPaid)
    FROM billingpayment
    WHERE AmountPaid IS NOT NULL
);

-- Query 4 - How many payments has each client made, and what is their remaining balance?

SELECT client.ClientID, client.ClientFirstName, client.ClientLastName,
       COUNT(billingPayment.PaymentID) AS NumberOfPayments,
       SUM(billingPayment.ProjectTotalCost) - SUM(billingPayment.AmountPaid) AS RemainingBalance
FROM client
inner join billingform ON client.ClientID = billingForm.ClientID
inner join billingpayment ON billingForm.BillingID = billingPayment.BillingID
WHERE billingForm.BillingDate IS NOT NULL
GROUP BY client.ClientID, client.ClientFirstName, client.ClientLastName;



-- ---------------------------------------------------------------------------------------------------------------------------
-- Purchase Form (Student Name: Naomi Pisfil Capunay Campos)
-- Query 1 - Problem/Statement
-- Which purchase orders were placed with each vendor location after January 1, 2024?
select purchaseorderform.PurchaseOrder#, purchaseorderform.OrderDate, vendor.VendorFirstName, vendor.VendorLastName, vendorlocation.Address
from purchaseorderform
inner join vendorlocation ON purchaseorderform.LocationID = vendorlocation.LocationID
inner join vendor ON purchaseorderform.VendorID = vendor.VendorID
WHERE purchaseorderform.OrderDate >= '2024-01-01';

-- Query 2 - Problem/Statement
-- Which employees processed more than 1 purchase order?
select employee.EmployeeID, employee.FirstName, employee.LastName, COUNT(purchaseorderform.`PurchaseOrder#`) AS TotalPurchaseOrders
from employee
inner join purchaseorderform ON employee.EmployeeID = purchaseorderform.EmployeeID
WHERE purchaseorderform.OrderDate IS NOT NULL
GROUP BY employee.EmployeeID, employee.FirstName, employee.LastName
HAVING COUNT(purchaseorderform.`PurchaseOrder#`) > 1;


-- Query 3 - Problem/Statement
-- How many purchase orders has each vendor received?

select vendor.VendorID, vendor.VendorFirstName, vendor.VendorLastName, COUNT(purchaseorderform.`PurchaseOrder#`) AS NumberOfPurchaseOrders
from vendor
inner join purchaseorderform ON vendor.VendorID = purchaseorderform.VendorID
WHERE purchaseorderform.VendorID IS NOT NULL
GROUP BY vendor.VendorID, vendor.VendorFirstName, vendor.VendorLastName;


-- Query 4 
-- Which items have a list price higher than the average list price?
select item.ItemID, item.Description, item.ListPrice
from item
WHERE item.ListPrice > (
    select AVG(item.ListPrice)
    from item
    WHERE item.ListPrice IS NOT NULL
);




