-- 1. Wypisz wszystkich członków biblioteki z adresami i info czy jest dzieckiem czy nie
-- ilość wypożyczeń w poszczególnych latach i miesiącach.

-- select
--     member.member_no,
--     case
--         when juvenile.member_no is not null then 'child'
--         when adult.member_no is not null then 'adult'
--         else 'Unknown'
--     end as PersonType,
--     adult.street
-- from member
-- left join adult
--     on member.member_no = adult.member_no
-- left join juvenile
--     on member.member_no = juvenile.member_no

select
    m.member_no,
    m.firstname,
    m.lastname,
    a.state,
    a.street,
    a.city,
    a.zip,
    'Adult' as PersonType
    , year(out_date) as OutYear,
    month(out_date) as OutMonth,
    count(title_no) as BooksLonaed
from member as m
inner join adult as a
    on m.member_no = a.member_no
left join loanhist as lh
    on lh.member_no = m.member_no
group by m.member_no, m.firstname, m.lastname, a.state, a.street, a.city, a.zip, year(out_date), month(out_date)
union
select
    distinct
    m.member_no,
    m.firstname,
    m.lastname,
    a.state,
    a.street,
    a.city,
    a.zip,
    'Child' as PersonType
    , year(out_date) as OutYear,
    month(out_date) as OutMonth,
    count(title_no) as BooksLonaed
from member as m
inner join juvenile
    on m.member_no = juvenile.member_no
inner join adult as a
    on juvenile.adult_member_no = a.member_no
left join loanhist as lh
    on lh.member_no = m.member_no
group by m.member_no, m.firstname, m.lastname, a.state, a.street, a.city, a.zip, year(out_date), month(out_date)
order by member_no, OutYear, OutMonth


-- 2. Zamówienia z Freight większym niż AVG danego roku.

with YearAvg as (
    select
        year(OrderDate) as OrderYear
        , avg(O.Freight) as FreightAvg
    from Orders as O
    group by year(OrderDate)
)
select
    distinct
    OrderID
from YearAvg
inner join Orders as O2
    on year(O2.OrderDate) = OrderYear
where O2.Freight > YearAvg.FreightAvg


-- 3. Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach.

select
    distinct
    Cust.CustomerID
from Customers as Cust
where Cust.CustomerID not in (
        select
            distinct
            O.CustomerID
        from Orders as O
        inner join [Order Details] as OD
        on O.OrderID = OD.OrderID
        inner join Products as Prod
        on OD.ProductID = Prod.ProductID
        inner join Categories as Cat
        on Prod.CategoryID = Cat.CategoryID
        where Cat.CategoryName = 'Seafood'
    )
order by 1

select
    CustomerID
from Customers
except
select
    O.CustomerID
from Orders as O
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID
where Cat.CategoryName = 'Seafood'
order by 1

select
    Cust2.CustomerID
from Customers as Cust
inner join Orders as O
    on Cust.CustomerID = O.CustomerID
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID and Cat.CategoryName = 'Seafood'
right join Customers as Cust2
    on Cust.CustomerID = Cust2.CustomerID
where Cust.CustomerID is null
order by CustomerID

-- 4. Dla każdego klienta najczęściej zamawianą kategorię w dwóch wersjach.

-- wersja 1

with CategoryCount as (
    select
        Cust.CustomerID
        , Cat.CategoryID
        , CategoryName
        , count(O.OrderID) as CatCount
    from Customers as Cust
    inner join Orders as O
        on Cust.CustomerID = O.CustomerID
    inner join [Order Details] as OD
        on O.OrderID = OD.OrderID
    inner join Products as Prod
        on Prod.ProductID = OD.ProductID
    inner join Categories as Cat
        on Prod.CategoryID = Cat.CategoryID
    group by Cat.CategoryID, Cust.CustomerID, Cat.CategoryName
), CustomerMaxCount as (
    select
        CategoryCount.CustomerID,
        max(CatCount) as MaxCount
    from CategoryCount
    group by CategoryCount.CustomerID
)
select
    distinct
    CategoryCount.CustomerID
    , CategoryName
--     , CategoryCount.CatCount
from CustomerMaxCount
inner join CategoryCount
    on CategoryCount.CustomerID = CustomerMaxCount.CustomerID and CatCount = MaxCount
order by 1

-- wersja 2

with CategoryCount as (
    select
        CategoryName
        , CustomerID
        , count(*) as CategoryCount
    from Orders as o1
    inner join [Order Details] as od1
        on o1.OrderID = od1.OrderID
    inner join Products as p1
        on od1.ProductID = p1.ProductID
    inner join Categories as c1
        on p1.CategoryID = c1.CategoryID
    group by CategoryName, CustomerID
), CategoryCountRanking as (
    select
        CategoryName
        , CustomerID
        , CategoryCount
        , rank() over (
            partition by CustomerID
            order by CategoryCount desc
        ) as Rank
    from CategoryCount
)
select
    distinct
    CustomerID
    , CategoryName
from CategoryCountRanking
where Rank = 1
