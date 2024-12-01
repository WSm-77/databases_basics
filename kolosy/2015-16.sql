-- 1.a) Wyświetl imię, nazwisko, dane adresowe oraz ilość wypożyczonych książek dla każdego
-- członka biblioteki. Ilość wypożyczonych książek nie może być nullem, co najwyżej zerem.

select
    m1.firstname
    , m1.lastname
    , count(title_no) as LoanedCnt
from member as m1
left join loan as l1
    on m1.member_no = l1.member_no
group by m1.member_no, m1.firstname, m1.lastname;

-- b) j/w + informacja, czy dany członek jest dzieckiem

select
    m1.member_no
    , m1.firstname
    , m1.lastname
    , 'Child' as PersonType
    , count(title_no) as LoanedCnt
from member as m1
inner join juvenile
    on m1.member_no = juvenile.member_no
left join loan as l1
    on m1.member_no = l1.member_no
group by m1.member_no, m1.firstname, m1.lastname
union all
select
    m1.member_no
    , m1.firstname
    , m1.lastname
    , 'Adult' as PersonType
    , count(title_no) as LoanedCnt
from member as m1
inner join adult
    on m1.member_no = adult.member_no
left join loan as l1
    on m1.member_no = l1.member_no
group by m1.member_no, m1.firstname, m1.lastname;

-- 2. wyświetl imiona i nazwiska osób, które nigdy nie wypożyczyły żadnej książki
-- a) bez podzapytań

select
    distinct
    m.member_no
    , firstname
    , lastname
from loanhist as lh
right join member as m
    on m.member_no = lh.member_no
where lh.member_no is null

-- b) podzapytaniami

select
    distinct
    m.member_no
    , firstname
    , lastname
from member as m
where m.member_no not in (
    select
        distinct
        member_no
    from loanhist as lhinner
    );

-- 3. wyświetl numery zamówień, których cena dostawy była większa niż średnia cena za przesyłkę w tym roku

-- a) bez podzapytań

with YearAvgFreights as (
    select
        year(OrderDate) as OrderYear
        , avg(Freight) as YearAvgFreight
    from Orders as O1
    group by year(OrderDate)
)
select
    distinct
    OrderID
from YearAvgFreights
inner join Orders as O2
    on YearAvgFreights.OrderYear = year(O2.OrderDate)
where O2.Freight > YearAvgFreights.YearAvgFreight;

-- b) podzapytaniami

select
    OrderID
from Orders as OOuter
where OOuter.Freight > (
    select
        avg(OInner.Freight)
    from Orders as OInner
    where year(OOuter.OrderDate) = year(OInner.OrderDate)
);

-- 4. wyświetl ile każdy z przewoźników miał dostać wynagrodzenia w poszczególnych latach i miesiącach.

-- a) bez podzapytań

select
    sh.CompanyName
    , year(OrderDate) as OrderYear
    , month(OrderDate) as OrderMonth
    , sum(Freight) as ShipperProfit
from Orders as o
inner join Shippers as sh
    on o.ShipVia = sh.ShipperID
group by sh.CompanyName, year(o.OrderDate), month(o.OrderDate);

-- b) podzapytaniami

select
    distinct
    sh.CompanyName
    , year(OrderDate) as OrderYear
    , month(OrderDate) as OrderMonth
    , (
        select
            sum(Freight)
        from Orders as o2
        where year(o2.OrderDate) = year(o.OrderDate)
            and month(o2.OrderDate) = month(o.OrderDate)
            and o2.ShipVia = o.ShipVia
        ) as ShipperProfit
from Orders as o
inner join Shippers as sh
    on o.ShipVia = sh.ShipperID;

-- *) Podaj tylko tych przewoźników, którzy mieli największy przychód w danym miesiącu danego roku
-- (to zadanie nie pojawiło sie na kolokwium)

with FreightsSum as (
    select
        distinct
        sh.CompanyName
        , year(OrderDate) as OrderYear
        , month(OrderDate) as OrderMonth
        , (
            select
                sum(Freight)
            from Orders as o2
            where year(o2.OrderDate) = year(o.OrderDate)
                and month(o2.OrderDate) = month(o.OrderDate)
                and o2.ShipVia = o.ShipVia
            ) as ShipperProfit
    from Orders as o
    inner join Shippers as sh
        on o.ShipVia = sh.ShipperID
), FreightsSumRank as (
    select
        *
        , rank() over (partition by OrderYear, OrderMonth order by ShipperProfit desc) as ProfitRank
    from FreightsSum
)
select
    CompanyName
     , OrderYear
     , OrderMonth
--      , ShipperProfit
--      , ProfitRank
from FreightsSumRank
where ProfitRank = 1;
