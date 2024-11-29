use Northwind

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.

select
    O.OrderID,
    Cust.CompanyName,
    sum(round(UnitPrice * Quantity * (1 - Discount), 2)) as total_price
from Orders as O
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Customers as Cust
    on O.CustomerID = Cust.CustomerID
group by O.OrderID, Cust.CompanyName;

-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.

select
    O.OrderID,
    Cust.CompanyName,
    sum(round(UnitPrice * Quantity * (1 - Discount), 2)) as total_price,
    sum(Quantity) as quantity_sum
from Orders as O
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Customers as Cust
    on O.CustomerID = Cust.CustomerID
group by O.OrderID, Cust.CompanyName
having sum(Quantity) > 250;

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
-- pracownika obsługującego zamówienie

select
    O.OrderID,
    Cust.CompanyName,
    E.FirstName,
    E.LastName,
    sum(round(UnitPrice * Quantity * (1 - Discount), 2)) as total_price,
    sum(Quantity) as quantity_sum
from Orders as O
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Customers as Cust
    on O.CustomerID = Cust.CustomerID
inner join dbo.Employees as E
    on O.EmployeeID = E.EmployeeID
group by O.OrderID, Cust.CompanyName, E.FirstName, E.LastName
having sum(Quantity) > 250
order by total_price;
