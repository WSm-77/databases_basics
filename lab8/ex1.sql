use Northwind

-- 1. Podaj nazwy przewoźników, ktorzy w marcu 1998 przewozili produkty z kategorii 'Meat/Poultry'

select
    distinct
    Ship.CompanyName,
    CategoryName,
    year(O.ShippedDate) as ShipYear,
    datename(month, O.ShippedDate) as ShipMonth
from Products as Prod
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID
inner join [Order Details] as OD
    on Prod.ProductID = OD.ProductID
inner join Orders as O
    on OD.OrderID = O.OrderID
inner join Shippers as Ship
    on O.ShipVia = Ship.ShipperID
where Cat.CategoryName = 'Meat/Poultry' and year(O.ShippedDate) = 1998 and datename(month, O.ShippedDate) = 'March'

select
    distinct
    Ship.CompanyName,
    year(O.ShippedDate) as ShipYear,
    month(O.ShippedDate) as ShipMonth
from Shippers as Ship
inner join Orders as O
    on Ship.ShipperID = O.ShipVia
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
where OD.ProductID in (
        select
            ProductID
        from Products
        inner join Categories
            on Products.CategoryID = Categories.CategoryID
        where CategoryName = 'Meat/Poultry'
    )
    and year(O.ShippedDate) = 1998
    and month(O.ShippedDate) = 3;

-- 2. Podaj nazwy przewoźników, którzy w marcu 1997 r. nie przewozili produktów z kategorii 'Meat/Poultry'

select
    CompanyName
from Shippers
except
select
    distinct
    Ship.CompanyName
--     , CategoryName,
--     year(O.ShippedDate) as ShipYear,
--     datename(month, O.ShippedDate) as ShipMonth
from Products as Prod
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID
inner join [Order Details] as OD
    on Prod.ProductID = OD.ProductID
inner join Orders as O
    on OD.OrderID = O.OrderID
inner join Shippers as Ship
    on O.ShipVia = Ship.ShipperID
where Cat.CategoryName = 'Meat/Poultry'
    and year(O.ShippedDate) = 1997
    and datename(month, O.ShippedDate) = 'March';

select
    CompanyName
from Shippers
where CompanyName not in (
    select
        distinct
        Ship.CompanyName
--         , CategoryName
--         , year(O.ShippedDate) as ShipYear
--         , month(O.ShippedDate) as ShipMonth
    from Shippers as Ship
    inner join Orders as O
        on Ship.ShipperID = O.ShipVia
    inner join [Order Details] as OD
        on O.OrderID = OD.OrderID
    inner join Products
        on OD.ProductID = Products.ProductID
    inner join dbo.Categories C
        on Products.CategoryID = C.CategoryID
    where OD.ProductID in (
            select
                ProductID
            from Products
            inner join Categories
                on Products.CategoryID = Categories.CategoryID
            where CategoryName = 'Meat/Poultry'
    )
    and year(O.ShippedDate) = 1997
    and month(O.ShippedDate) = 3
);

-- 3. Dla każdego przwźnika podaj wartość prduktów z kategorii 'Meat/Poultry', które ten przewoźnik przewiózł w marcu 1997

select
    Ship.CompanyName
--     , Cat.CategoryName
--     , year(O.ShippedDate) as ShipYear
--     , datename(month, O.ShippedDate) as ShipMonth
    , round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as TotalPrice
from [Order Details] as OD
inner join Orders as O
    on OD.OrderID = O.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID
inner join Shippers as Ship
    on O.ShipVia = Ship.ShipperID
where year(O.ShippedDate) = 1997
    and datename(month, O.ShippedDate) = 'March'
    and Cat.CategoryName = 'Meat/Poultry'
group by Ship.CompanyName
order by TotalPrice desc;

select
    Ship.CompanyName
    , round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as TotalPrice
from Shippers as Ship
inner join Orders as O
    on Ship.ShipperID = O.ShipVia
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
where year(O.ShippedDate) = 1997
    and datename(month, O.ShippedDate) = 'March'
    and ProductID in (
        select
            ProductID
        from Products
        where CategoryID = (
            select
                CategoryID
            from Categories
            where CategoryName = 'Meat/Poultry'
        )
    )
group by Ship.CompanyName;
