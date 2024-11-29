use Northwind

-- 1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
select *
from Products
where Products.QuantityPerUnit like '%bottle%';

-- 2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
select Title
from Employees
where LastName like '[B-L]%';

-- 3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L
select Title
from Employees
where LastName like '[BL]%';

-- 4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
select CategoryName
from Categories
where Categories.Description like '%,%';

-- 5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo ‘Store’
select *
from Customers
where CompanyName like '%store%';

