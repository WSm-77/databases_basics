use Northwind

-- 1. Pary szef podwładny.

select
    boss.EmployeeID,
    boss.FirstName,
    boss.LastName,
    emp.FirstName,
    emp.LastName,
    emp.EmployeeID
from Employees as boss
inner join Employees as emp
    on emp.ReportsTo = boss.EmployeeID;

-- 2. Napisz polecenie, które wyświetla pracowników, ktrórzy nie mają podwładnych.

select
    boss.FirstName,
    boss.LastName,
    emp.EmployeeID
from Employees as boss
left join Employees as emp
    on emp.ReportsTo = boss.EmployeeID
where emp.EmployeeID is null;

-- 3. Napisz polecenie, które wyświetla pracowników, którzy mają podwładnych.

select
    boss.FirstName,
    boss.LastName,
    emp.EmployeeID
from Employees as boss
full join Employees as emp
    on boss.EmployeeID = emp.ReportsTo;
