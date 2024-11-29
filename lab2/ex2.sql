use Northwind

-- 1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie
select Customers.CompanyName, Customers.Country from Customers order by Country, CompanyName;

-- 2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg grup a w grupach malejąco wg ceny
select Products.CategoryID, Products.ProductName, Products.UnitPrice
from Products
order by CategoryID, UnitPrice desc;

-- 3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1
select Customers.CompanyName, Customers.Country from Customers where Country in ('Japan', 'Italy') order by Country, CompanyName;
