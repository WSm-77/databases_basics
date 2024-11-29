use Northwind

-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- – Ogranicz wynik tylko do pracowników

select
    E.LastName,
    E.FirstName,
    round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as total_price
from Employees as E
inner join dbo.Orders as O
    on E.EmployeeID = O.EmployeeID
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
group by E.EmployeeID, E.LastName, E.FirstName
order by total_price desc;

-- a) którzy mają podwładnych

select
    distinct
    boss.LastName,
    boss.FirstName,
    round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as total_price
from Employees as boss
inner join dbo.Orders as O
    on boss.EmployeeID = O.EmployeeID
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Employees as emp
    on boss.EmployeeID = emp.ReportsTo
group by boss.EmployeeID, boss.LastName, boss.FirstName, emp.EmployeeID
order by total_price desc;

-- z podzapytaniami

select
    bosses.EmployeeID,
    bosses.FirstName,
    bosses.LastName,
    round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as total_price
from (
    select
        distinct
        boss.EmployeeID,
        boss.FirstName,
        boss.LastName
    from Employees as boss
    inner join Employees as emp
        on boss.EmployeeID = emp.ReportsTo
) as bosses
inner join Orders as O
    on O.EmployeeID = bosses.EmployeeID
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
group by bosses.EmployeeID, bosses.LastName, bosses.FirstName
order by total_price desc;

-- b) którzy nie mają podwładnych

select
    distinct
    boss.LastName,
    boss.FirstName,
    round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as total_price
from Employees as boss
inner join dbo.Orders as O
    on boss.EmployeeID = O.EmployeeID
inner join dbo.[Order Details] as OD
    on O.OrderID = OD.OrderID
left join Employees as emp
    on boss.EmployeeID = emp.ReportsTo
where emp.EmployeeID is null
group by boss.EmployeeID, boss.LastName, boss.FirstName, emp.EmployeeID
order by total_price desc;
