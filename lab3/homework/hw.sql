use Northwind;

------------------ EXERCISE 1 ------------------

-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
-- i zwraca wynik posortowany w malejącej kolejności (wg wartości sprzedaży).

select OrderID, round(sum(Quantity*UnitPrice*(1-Discount)), 2, 1) as SalesValue
from [Order Details]
group by OrderID
order by SalesValue desc;

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy
select top 10 OrderID, round(sum(Quantity*UnitPrice*(1-Discount)), 2, 1) as SalesValue
from [Order Details]
group by OrderID
order by SalesValue desc;

------------------ EXERCISE 2 ------------------

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid < 3

select ProductID, sum(Quantity)
from [Order Details]
group by ProductID
having ProductID < 3;

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę
-- zamówionych jednostek produktu dla wszystkich produktów

select ProductID,
       sum(Quantity)
from [Order Details]
group by ProductID
order by ProductID;

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których
-- łączna liczba zamawianych jednostek produktów jest > 250

select OrderID,
       round(sum(Quantity * UnitPrice * (1 - Discount)), 2, 1) as SalesValue
from [Order Details]
group by OrderID
having sum(Quantity) > 250
order by SalesValue desc;

------------------ EXERCISE 3 ------------------

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień

select EmployeeID, count(OrderID)
from Orders
group by EmployeeID
order by 2 desc

-- 2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień

select ShipVia,
       round(sum(Freight), 2) as [Opłata za przesyłkę]
from Orders
group by ShipVia ;

-- 3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień w latach o 1996 do 1997

select ShipVia,
       sum(Freight) as [Opłata za przesyłkę]
from Orders
where year(ShippedDate) between 1996 and 1997
group by ShipVia;

------------------ EXERCISE 4 ------------------

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące

select EmployeeId,
       datename(year, OrderDate) as OrderYear,
       datename(month, OrderDate) as OrderMonth,
       count(OrderID) as OrdersCount
from Orders
group by  EmployeeId,
          datename(year, OrderDate),
          datename(month, OrderDate)
-- with cube
order by EmployeeID,
         OrderYear,
         OrderMonth;

-- 2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej
-- kategorii

select CategoryID
--        , Discontinued
       , max(UnitPrice) as MaxPrice
       , min(UnitPrice)as MinPrice
from Products
where Discontinued = 0
group by CategoryID
--          , Discontinued
order by CategoryID
         , MaxPrice
         , MinPrice desc;
