use Northwind

-- 1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma United Package.

select
    distinct
    Cust.CompanyName,
    Cust.Phone
from Customers as Cust
inner join Orders as O
    on Cust.CustomerID = O.CustomerID
inner join Shippers as S
    on O.ShipVia = S.ShipperID
where S.CompanyName = 'United Package'
    and O.OrderID in (
        select
            OrderID
        from Orders
        where year(O.OrderDate) = 1997
    );

-- 2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- Confections.

select
    Cust.CompanyName,
    Cust.Phone
from Customers as Cust
where CustomerID in (
    select
        distinct
        CustomerID
    from Orders as O
    inner join [Order Details] as OD
        on O.OrderID = OD.OrderID
    inner join Products as Prod
        on OD.ProductID = Prod.ProductID
    inner join Categories as Cat
        on Prod.CategoryID = Cat.CategoryID
    where CategoryName = 'Confections'
);

-- 3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z
-- kategorii Confections.

select
    Cust.CompanyName,
    Cust.Phone
from Customers as Cust
where CustomerID not in (
    select
        distinct
        CustomerID
    from Orders as O
    inner join [Order Details] as OD
        on O.OrderID = OD.OrderID
    inner join Products as Prod
        on OD.ProductID = Prod.ProductID
    inner join Categories as Cat
        on Prod.CategoryID = Cat.CategoryID
    where CategoryName = 'Confections'
);
