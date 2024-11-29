use Northwind

-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)

select
    O.OrderID,
    total_prices.order_price,
    O.Freight,
    total_prices.order_price + O.Freight
from (
    select OD.OrderID,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as order_price
    from [Order Details] as OD
    where OrderID = 10250
    group by OD.OrderID
) as total_prices
inner join Orders AS O
    on O.OrderID = total_prices.OrderID;

-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
-- przesyłkę)

select
    O.OrderID,
    total_prices.order_price,
    O.Freight,
    total_prices.order_price + O.Freight
from (
    select OD.OrderID,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as order_price
    from [Order Details] as OD
    group by OD.OrderID
) as total_prices
inner join Orders AS O
    on O.OrderID = total_prices.OrderID;

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe

select
    CompanyName,
    Address
from Customers
where CustomerID not in (
    select
        distinct
        CustomerID
    from Orders
    where 1997 = year(OrderDate)
)

-- 4. Podaj produkty kupowane przez więcej niż jednego klienta

select
    O.CustomerID,
    OD.ProductID
from [Order Details] as OD
inner join Orders as O
    on OD.OrderID = O.OrderID;

select
    customer_product_pairs.ProductID,
    count(customer_product_pairs.CustomerID)
from (
    select
        O.CustomerID,
        OD.ProductID
    from [Order Details] as OD
    inner join Orders as O
        on OD.OrderID = O.OrderID
) as customer_product_pairs
group by customer_product_pairs.ProductID
having count(customer_product_pairs.CustomerID) > 1;
