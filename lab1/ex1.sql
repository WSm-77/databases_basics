use Northwind
select  * from Customers
select * from Products
select * from Suppliers
select * from Categories
select * from Employees
select * from Shippers
select * from Orders
select * from [Order Details]

-- 1. Wybierz nazwy i adresy wszystkich klientów
select CompanyName, Address from Customers

-- 2. Wybierz nazwiska i numery telefonów pracowników
select LastName, HomePhone from Employees

-- 3. Wybierz nazwy i ceny produktów
select ProductName, UnitPrice from Products

-- 4. Pokaż wszystkie kategorie produktów (nazwy i opisy)
select CategoryName, Description from Categories

-- 5. Pokaż nazwy i adresy stron www dostawców
select CompanyName, HomePage from Suppliers
