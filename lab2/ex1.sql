use Northwind

select CompanyName, Fax from Suppliers where Fax is not NULL;

select OrderID, OrderDate, CustomerID
from Orders
where (ShipCountry = 'Argentina' and (ShippedDate is NULL or ShippedDate > getdate()));

