use Northwind

-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)

select
    round(O.Freight + (
        select
            sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount))
        from [Order Details] as OD
        group by OrderID
        having OrderID = 10250
        )
    , 2) as order_10250_total_price
from Orders as O
where OrderID = 10250;

-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
-- przesyłkę)

select
    O.OrderID,
    O.Freight,
    total_prices.order_price,
    round(O.Freight + total_prices.order_price, 2) as full_price
from Orders as O
inner join (
    select
        OrderID,
        sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) as order_price
    from [Order Details] as OD
    group by OrderID
) as total_prices
    on total_prices.OrderID = O.OrderID;

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe

select
    CompanyName,
    Address
from Customers
where CustomerID not in (
    select
        distinct
        O.CustomerID
    from Orders as O
    where year(O.OrderDate) = 1997
);

-- 4. Podaj produkty kupowane przez więcej niż jednego klienta

select
    Prod.ProductID,
    Prod.ProductName,
    count(distinct_customer_product_pairs.CustomerID) as CustomerCount
from Products as Prod
inner join (
    select
        distinct
        O.CustomerID,
        OD.ProductID
    from [Order Details] as OD
    inner join Orders as O
    on OD.OrderID = O.OrderID
) as distinct_customer_product_pairs
    on distinct_customer_product_pairs.ProductID = Prod.ProductID
group by Prod.ProductID, Prod.ProductName
order by CustomerCount desc, ProductID;

-- bez podzapytań

select
    OD.ProductID,
    Prod.ProductName,
    count(distinct O.CustomerID) as CustomerCount
from [Order Details] as OD
inner join Orders as O
    on OD.OrderID = O.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
group by OD.ProductID, Prod.ProductName
having count(distinct O.CustomerID) > 1
order by CustomerCount desc, ProductID;
