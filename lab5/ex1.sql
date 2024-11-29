use Northwind

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy,
-- interesują nas tylko produkty z kategorii ‘Meat/Poultry’

select ProductName,
       UnitPrice,
       Address,
       CategoryName
from Products
inner join Categories
    on Products.CategoryID = Categories.CategoryID
       and CategoryName = 'Meat/Poultry'
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where UnitPrice between 20 and 30;

-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu
-- podaj nazwę dostawcy.

select ProductName,
       UnitPrice,
       CategoryName,
       CompanyName
from Products
inner join Categories
    on Products.CategoryID = Categories.CategoryID and CategoryName = 'Condiments'
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID;

-- 3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma ‘United Package’

select distinct Customers.CompanyName,
       Customers.Phone,
       ShippedDate,
       Shippers.CompanyName
from Customers
inner join Orders
    on Customers.CustomerID = Orders.CustomerID
inner join Shippers
    on Orders.ShipVia = Shippers.ShipperID
where
    year(ShippedDate) = 1997
    and Shippers.CompanyName = 'United Package';

select distinct Customers.CompanyName,
       Customers.Phone,
       ShippedDate,
       Shippers.CompanyName
from Customers
inner join Orders
    on Customers.CustomerID = Orders.CustomerID and year(ShippedDate) = 1997
inner join Shippers
    on Orders.ShipVia = Shippers.ShipperID
    and Shippers.CompanyName = 'United Package';


-- 4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- ‘Confections’

-- 5. Dla każdego klienta podaj liczbę złożonoych przez niego zamówień.
-- Zbiór wynikowy powinien zawierać nazwę klienta oraz liczbę zamówień.

select
    Orders.CustomerID,
    count(*) as cnt
from Customers
left outer join Orders
    on Orders.CustomerID = Customers.CustomerID
group by Orders.CustomerID;

-- 6. Dla każdego klienta podaj liczbę złożonych przez niego zamówień w marcu 1997.
-- Zbiór wynikowy powinien zawierać nazwę klienta oraz liczbę zamówień.

select
    Orders.CustomerID,
    count(*)
from Customers
left outer join Orders
    on Customers.CustomerID = Orders.CustomerID
                and year(OrderDate) = 1997
                and month(OrderDate) = 3
group by Orders.CustomerID;

-- 7. Który ze spedytorów wybierz tego, który był najaktywniejszy w 1997 roku, podaj nazwę tego spedytora.

select
    top 1
    CompanyName,
    count(*) as cnt
from Orders
inner join Shippers
    on Orders.ShipVia = Shippers.ShipperID and year(ShippedDate) = 1997
group by CompanyName
order by cnt desc;

-- 8. Dla każdego zamówienia podaj wartość zamówionych produktów. Zbiór wynikowy powinien zawierać:
-- nr zamówienia, datę zamówienia, nazwę klienta oraz wartość zamówionych produktów.

select
    Orders.OrderID,
    OrderDate,
    Customers.CompanyName,
    UnitPrice * Quantity * (1 - Discount) as total_price
from [Order Details]
inner join Orders
    on [Order Details].OrderID = Orders.OrderID
inner join Customers
    on Orders.CustomerID = Customers.CustomerID;

select
    Orders.OrderID,
    OrderDate,
    Customers.CompanyName,
    sum(UnitPrice * Quantity * (1 - Discount)) as total_price
from [Order Details]
inner join Orders
    on [Order Details].OrderID = Orders.OrderID
inner join Customers
    on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, OrderDate, Customers.CompanyName, Orders.Freight
order by 4 desc;

-- 9. Dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za presylkę). Zbiór wynikowy
-- powinien zawierać: nr zamówienia, datę zamówienia, nazwę klienta oraz pełną wartość zamwienia.

select
    Orders.OrderID,
    OrderDate,
    Customers.CompanyName,
    Orders.Freight,
    sum(UnitPrice * Quantity * (1 - Discount))  as netto,
    sum(UnitPrice * Quantity * (1 - Discount)) + Orders.Freight as total_price
from [Order Details]
inner join Orders
    on [Order Details].OrderID = Orders.OrderID
inner join Customers
    on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, OrderDate, Customers.CompanyName, Orders.Freight
order by total_price desc;

-- 10. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii "Confections"

select distinct
    Customers.CompanyName
    ,    Customers.Phone
--     ,    Categories.CategoryName
from Customers
inner join Orders
    on Customers.CustomerID = Orders.CustomerID
inner join [Order Details]
    on Orders.OrderID = [Order Details].OrderID
inner join Products
    on [Order Details].ProductID = Products.ProductID
inner join Categories
    on Products.CategoryID = Categories.CategoryID
where CategoryName = 'Confections';


-- 11. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii "Confections".

-- NOTE: musimy uwzględnić klientów, którzy nic nie kupowali (jest 2 takich klientów)

select CompanyName, Phone from Customers

select
    distinct Cus.CompanyName
        , Cus.Phone
--         , C.CategoryName
from Customers as Cus
left join Orders as O
    on Cus.CustomerID = O.CustomerID
left join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
left join dbo.Products P
    on P.ProductID = OD.ProductID
left join dbo.Categories C
    on P.CategoryID = C.CategoryID and CategoryName = 'Confections'
group by Cus.CompanyName, Cus.Phone, O.CustomerID
having min(CategoryName) is null;

select
    distinct Cus.CompanyName
        , Cus.Phone
--         , C.CategoryName
from Customers as Cus
left join Orders as O
    on Cus.CustomerID = O.CustomerID
left join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
left join dbo.Products P
    on P.ProductID = OD.ProductID
left join dbo.Categories C
    on P.CategoryID = C.CategoryID and CategoryName = 'Confections'
group by Cus.CompanyName, Cus.Phone, O.CustomerID
having min(CategoryName) is null
order by 1;

select
    distinct Cus2.CompanyName
        , Cus2.Phone
        , C.CategoryName
from Customers as Cus
inner join Orders as O
    on Cus.CustomerID = O.CustomerID
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join dbo.Products P
    on P.ProductID = OD.ProductID
inner join dbo.Categories C
    on P.CategoryID = C.CategoryID and CategoryName = 'Confections'
right outer join Customers as Cus2
    on Cus.CustomerID = Cus2.CustomerID
where C.CategoryName is null
order by 1;

-- 12. Wybierz nazwy i numery telefonów klientów, którzy w 1997 roku nie kupowali produktów z kategorii "Confections".

select
    distinct Cus2.CompanyName
        , Cus2.Phone
        , C.CategoryName
from Customers as Cus
inner join Orders as O
    on Cus.CustomerID = O.CustomerID and year(O.OrderDate) = 1997
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join dbo.Products P
    on P.ProductID = OD.ProductID
inner join dbo.Categories C
    on P.CategoryID = C.CategoryID and CategoryName = 'Confections'
right outer join Customers as Cus2
    on Cus.CustomerID = Cus2.CustomerID
where C.CategoryName is null
order by 1;
