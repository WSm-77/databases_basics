-- 1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select  CompanyName, Address from Customers where City = 'London'

-- 2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
select  CompanyName, Address from Customers where Country = 'France' or Country = 'Spain'

-- 3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select  ProductName, UnitPrice from Products where UnitPrice >= 20.00 and UnitPrice <= 30.00

-- 4. Wybierz nazwy i ceny produktów z kategorii ‘meat’
select CategoryID, CategoryName from Categories
select ProductName, UnitPrice from Products where CategoryID = 6

-- 5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
select * from Suppliers where CompanyName = 'Tokyo Traders'
-- select ProductName,  from Products where  SupplierID = 4

--6. Wybierz nazwy produktów których nie ma w magazynie
select ProductName from Products where UnitsInStock = 0
