use Northwind;

select FirstName, LastName, 'Identyfication nb:', EmployeeID from Employees;

select orderid, UnitPrice * 1.05 as IncreasedPrice
from [Order Details];

select  FirstName + ' ' + LastName as FullName from Employees;
