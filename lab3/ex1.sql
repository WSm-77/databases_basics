use Northwind;

-- 1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$
select count(UnitPrice) from Products where UnitPrice not between 10 and 20;

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
select max(UnitPrice) from Products where UnitPrice < 20;

-- 3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
-- produktach sprzedawanych w butelkach (‘bottle’)
select max(UnitPrice), min(UnitPrice), avg(UnitPrice) from Products where QuantityPerUnit like '%bottle%';

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
-- select * from Products where UnitPrice > avg(UnitPrice); -- błąd!!!
select * from Products where UnitPrice > (select avg(UnitPrice) from Products);

-- 5. Podaj wartość zamówienia o numerze 10250
select sum(UnitPrice * Quantity * (1 - Discount)) from [Order Details] where OrderID = 10250;
