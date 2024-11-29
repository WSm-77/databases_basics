use Northwind

-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
-- uwzględnij cenę za przesyłkę

select
    Emp.FirstName,
    Emp.LastName,
    round(sum(TotalPrices.order_price), 2) as handled_orders_total_prices
from Employees as Emp
inner join
(
    select
        O.EmployeeID,
        O.Freight,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as order_price
    from [Order Details] as OD
    inner join Orders as O
        on OD.OrderID = O.OrderID
    group by EmployeeID, Freight
) as TotalPrices
    on Emp.EmployeeID = TotalPrices.EmployeeID
group by Emp.FirstName, Emp.LastName
order by handled_orders_total_prices desc;

-- 2. Który z pracowników był najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika

select
    EmployeeID,
    FirstName,
    LastName
from Employees;

select
    top 1
    Emp.FirstName,
    Emp.LastName,
--     OrdersValues.order_year,
    round(sum(OrdersValues.order_price), 2) as handled_orders_total_price
from Employees as Emp
inner join (
    select
        O.EmployeeID,
        O.OrderID,
--         year(O.OrderDate) as order_year,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as order_price
    from [Order Details] as OD
    inner join Orders as O
        on OD.OrderID = O.OrderID and year(O.OrderDate) = 1997
    group by O.EmployeeID, O.OrderID
) as OrdersValues
on OrdersValues.EmployeeID = Emp.EmployeeID
group by Emp.EmployeeID, Emp.FirstName, Emp.LastName
-- , OrdersValues.order_year
order by handled_orders_total_price desc;

-- 3. Ogranicz wynik z pkt 1 tylko do pracowników

-- a) którzy mają podwładnych

select
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    round(sum(OrdersValues.order_total_price), 2) as handled_orders_total_price
from Employees as E
inner join (
    select
        O.EmployeeID,
        O.OrderID,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as order_total_price
        from Orders as O
        inner join [Order Details] as OD
            on O.OrderID = OD.OrderID
        group by O.OrderID, O.EmployeeID, O.Freight
) as OrdersValues
    on E.EmployeeID = OrdersValues.EmployeeID
where E.EmployeeID in (
    select
        distinct
        boss.EmployeeID
    from Employees as emp
    inner join Employees as boss
        on emp.ReportsTo = boss.EmployeeID
)
group by E.EmployeeID, E.FirstName, E.LastName;

select
    distinct
    boss.EmployeeID
from Employees as emp
inner join Employees as boss
    on emp.ReportsTo = boss.EmployeeID;

-- b) którzy nie mają podwładnych

select
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    round(sum(OrdersValues.order_total_price), 2) as handled_orders_total_price
from Employees as E
inner join (
    select
        O.EmployeeID,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as order_total_price
        from Orders as O
        inner join [Order Details] as OD
            on O.OrderID = OD.OrderID
        group by O.OrderID, O.EmployeeID, O.Freight
) as OrdersValues
    on E.EmployeeID = OrdersValues.EmployeeID
        where E.EmployeeID not in (
            select
            distinct
            boss.EmployeeID
        from Employees as emp
        inner join Employees as boss
            on emp.ReportsTo = boss.EmployeeID
    )
group by E.EmployeeID, E.FirstName, E.LastName;

select
    boss.EmployeeID
from Employees as emp
inner join Employees as boss
    on emp.ReportsTo = boss.EmployeeID;

-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
-- ostatnio obsłużonego zamówienia

-- a) którzy mają podwładnych

select
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    max(OrdersValues.OrderDate) as last_handled_order,
    round(sum(OrdersValues.order_total_price), 2) as handled_orders_total_price
from Employees as E
inner join (
    select
        O.EmployeeID,
        O.OrderDate,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as order_total_price
        from Orders as O
        inner join [Order Details] as OD
            on O.OrderID = OD.OrderID
        group by O.OrderID, O.EmployeeID, O.Freight, O.OrderDate
) as OrdersValues
    on E.EmployeeID = OrdersValues.EmployeeID
where E.EmployeeID in (
    select
        distinct
        boss.EmployeeID
    from Employees as emp
    inner join Employees as boss
        on emp.ReportsTo = boss.EmployeeID
)
group by E.EmployeeID, E.FirstName, E.LastName;

-- b) którzy nie mają podwładnych

select
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    max(OrderDate) as last_handled_order,
    round(sum(OrdersValues.order_total_price), 2) as handled_orders_total_price
from Employees as E
inner join (
    select
        O.EmployeeID,
        O.OrderDate,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as order_total_price
        from Orders as O
        inner join [Order Details] as OD
            on O.OrderID = OD.OrderID
        group by O.OrderID, O.EmployeeID, O.Freight, O.OrderDate
) as OrdersValues
    on E.EmployeeID = OrdersValues.EmployeeID
        where E.EmployeeID not in (
            select
            distinct
            boss.EmployeeID
        from Employees as emp
        inner join Employees as boss
            on emp.ReportsTo = boss.EmployeeID
    )
group by E.EmployeeID, E.FirstName, E.LastName
order by handled_orders_total_price desc;

select
    EmployeeID,
    max(OrderDate)
from Orders
group by EmployeeID;
