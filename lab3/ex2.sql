use Northwind;

select productid, sum(quantity) from orderhist where productid = 1 group by productid;

-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(Quantity * UnitPrice * (1 - Discount)) from [Order Details] group by OrderID;

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu
-- select OrderID, max(Quantity * UnitPrice * (1 - Discount)) as max_price from [Order Details] group by OrderID order by max_price;
select OrderID, max(UnitPrice) as max_price from [Order Details] group by OrderID order by 2;

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(Quantity * UnitPrice * (1 - Discount)), min(Quantity * UnitPrice * (1 - Discount)) from [Order Details] group by OrderID;

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
select ShipVia, count(*) from Orders group by ShipVia;

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku
select ShipVia, count(*) from Orders where year(OrderDate) = 1997 group by ShipVia order by 2 desc ;
