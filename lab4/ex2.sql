use Northwind

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy

select ProductName,
       UnitPrice,
       Address
from Products
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where UnitPrice between 20.00 and 30.00;

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
-- dostarczanych przez firmę ‘Tokyo Traders’

select ProductName,
       UnitsInStock,
       CompanyName
from Products
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where CompanyName = 'Tokyo Traders';

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe

select Customers.CustomerID,
    Address
from Orders
right outer join Customers
    on Orders.CustomerID = Customers.CustomerID and year(OrderDate) = 1997
where OrderID is null
order by CustomerID;

-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
-- których aktualnie nie ma w magazynie

select distinct CompanyName,
       Phone
from Products
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where  UnitsInStock = 0;
