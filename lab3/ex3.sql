use Northwind;

-- 1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select OrderID, count(*) from [Order Details] group by OrderID having count(*) > 5;
select OrderID from [Order Details] group by OrderID having count(*) > 5;

-- 2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla
-- każdego z klientów)
select CustomerID, sum(Freight)
from Orders
where year(OrderDate) = 1998
group by CustomerID
having count(*) > 8
order by 2 desc;

