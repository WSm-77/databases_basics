-- Zad 1. Wybierz nazwy firm, które zostały obsłużone przez dokładnie jednego pracownika; podaj nazwę tej firmy oraz imię i nazwisko pracownika

with CustomerCnt as (
    select
        CompanyName
        , c.CustomerID
        , count(distinct EmployeeID) as EmployeeCnt
    from Customers as c
    inner join Orders as o
        on c.CustomerID = o.CustomerID
    group by c.CustomerID, CompanyName
), Emp as (
    select
        e1.EmployeeID
        , e1.FirstName
        , e1.LastName
        , CompanyName
    from CustomerCnt
    inner join Orders as o1
        on o1.CustomerID = CustomerCnt.CustomerID
    inner join Employees as e1
        on o1.EmployeeID = e1.EmployeeID
    where EmployeeCnt = 1
)
select
    CompanyName
    , FirstName
    , LastName
from Emp;

-- Zad 2.

with OrdersVals as (
    select
        o.OrderID
        , round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + o.Freight, 2) as OrderValue
    from [Order Details] as od
    inner join Orders as o
        on od.OrderID = o.OrderID
               and year(OrderDate) = 1997
               and month(OrderDate) = 2
    group by o.OrderID, o.Freight
)
select
    e.FirstName
    , e.LastName
    , count(OrdersVals.OrderID) as OrdersCnt
    , isnull(round(sum(OrderValue), 2), 0) as OrdersTotalValue
from OrdersVals
inner join Orders as o2
    on o2.OrderID = OrdersVals.OrderID
right join Employees as e
    on o2.EmployeeID = e.EmployeeID
group by e.FirstName, e.LastName, e.EmployeeID;

-- Zad 3 .

with Parents as (
    select
        a1.member_no
        , m1.firstname
        , m1.lastname
        , count(j1.member_no) as ChildCnt
    from adult as a1
    inner join member as m1
        on a1.member_no = m1.member_no
    left join juvenile as j1
        on a1.member_no = j1.adult_member_no
    group by m1.firstname, a1.member_no, m1.lastname
), ReservationAndLoan as (
    select
        member_no
    from reservation
    union all
    select
        member_no
    from loan
    union all
    select
        member_no
    from loanhist
)
select
    firstname
    , lastname
    , ChildCnt
    , (
        select
            count(*)
        from ReservationAndLoan
        where ReservationAndLoan.member_no = Parents.member_no
            or ReservationAndLoan.member_no in (
                select
                    j2.member_no
                from juvenile as j2
                where j2.adult_member_no = Parents.member_no
            )
    ) as TotalBookCnt
from Parents;


