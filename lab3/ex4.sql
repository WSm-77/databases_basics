use Northwind;

-- Ile zamówień zostało wykonanych z opóźnienem.
select count(*) from orders where ShippedDate > Orders.RequiredDate;

-- Wyświetl zamówienia bez zniżki.
select OrderID, max(Discount) from [Order Details] group by OrderID having max(Discount) = 0;

-- W którym dniu tygodnia było składane najmniej zamówień.
select OrderID, OrderDate from Orders;
select top 1 datename(dw, OrderDate), count(*) from Orders group by datename(dw, OrderDate) order by 2;
