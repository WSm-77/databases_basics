use Northwind

-- 9. Dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za presylkę). Zbiór wynikowy
-- powinien zawierać: nr zamówienia, datę zamówienia, nazwę klienta oraz pełną wartość zamwienia.

select
    OrderID
--     , Freight
from Orders
group by OrderID
--        , Freight
order by 1;

select
    O.OrderID,
    O.Freight,
    round(sum(OD.UnitPrice * OD.Quantity * (1 - Discount)), 2) as total_price,
    round(sum(OD.UnitPrice * OD.Quantity * (1 - Discount)) + O.Freight, 2) as total_price_with_freight
from Orders as O
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
group by O.OrderID, O.Freight;

-- 10. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii "Confections"

select
    Cust.CompanyName
    , Cust.Phone
--     , Cat.CategoryName
from Customers as Cust
inner join Orders as O
    on Cust.CustomerID = O.CustomerID
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as P
     on OD.ProductID = P.ProductID
inner join Categories as Cat
    on P.CategoryID = Cat.CategoryID
where Cat.CategoryName = 'Confections'
group by Cust.CompanyName, Cust.Phone;

-- 11. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii "Confections".

select
    Cust.CompanyName
    , Cust.Phone
from Customers as Cust
except
select
    Cust.CompanyName
    , Cust.Phone
--     , Cat.CategoryName
from Customers as Cust
inner join Orders as O
    on Cust.CustomerID = O.CustomerID
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as P
     on OD.ProductID = P.ProductID
inner join Categories as Cat
    on P.CategoryID = Cat.CategoryID
where Cat.CategoryName = 'Confections'
group by Cust.CompanyName, Cust.Phone;

-- NOTE: musimy uwzględnić klientów, którzy nic nie kupowali (jest 2 takich klientów)

-- 12. Wybierz nazwy i numery telefonów klientów, którzy w 1997 roku nie kupowali produktów z kategorii "Confections".

select
    Cust.CompanyName
    , Cust.Phone
from Customers as Cust
except
select
    Cust.CompanyName
    , Cust.Phone
--     , Cat.CategoryName
from Customers as Cust
inner join Orders as O
    on Cust.CustomerID = O.CustomerID
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as P
     on OD.ProductID = P.ProductID
inner join Categories as Cat
    on P.CategoryID = Cat.CategoryID
where Cat.CategoryName = 'Confections' and datepart(year, O.OrderDate) = 1997
group by Cust.CompanyName, Cust.Phone;
