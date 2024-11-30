-- 1. Wybierz dzieci wraz z adresem, które nie wypożyczyły książek w lipcu 2001
-- autorstwa ‘Jane Austin’

select
    m.member_no
    , m.firstname
    , m.lastname
    , a.state
    , a.city
    , a.street
    , a.zip
from juvenile as j
inner join member as m
    on j.member_no = m.member_no
inner join adult as a
    on j.adult_member_no = a.member_no
where m.member_no not in (
    select
        j1.member_no
    from juvenile as j1
    inner join loan as lh1
        on lh1.member_no = j1.member_no
    inner join title as t1
        on lh1.title_no = t1.title_no
    where year(out_date) = 2001
        and month(out_date) = 7
        and author = 'Jane Austin'
    )

-- 2. Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła, podział na miesiące

with CategoriesProfit as (
    select
        CategoryID
        , year(OrderDate) as OrderYear
        , datename(month, OrderDate) as OrderMonth
        , round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as CategorySum
    from [Order Details] as OD
    inner join Products as p
        on OD.ProductID = p.ProductID
    inner join Orders as O
        on OD.OrderID = O.OrderID
    group by CategoryID, year(OrderDate), datename(month, OrderDate)
), RankedCategoriesProfit as (
    select
        CategoryID
        , CategorySum
        , OrderMonth
        , rank() over (partition by OrderMonth order by CategorySum desc) as ProfitRank
    from CategoriesProfit
    where OrderYear = 1997
)
select
    OrderMonth
    , CategoryName
    , CategorySum
from RankedCategoriesProfit
inner join Categories as Cat
    on Cat.CategoryID = RankedCategoriesProfit.CategoryID
where ProfitRank = 1

with CategoriesMonthsProfits as (
    select
        CategoryName
        , datename(month, OrderDate) as OrderMonth
        , round(sum(OD.Quantity * OD.UnitPrice * (1 - Discount)), 2) as CategoryProfit
    from Categories as Cat
    inner join Products as Prod
        on Cat.CategoryID = Prod.CategoryID
    inner join [Order Details] as OD
        on Prod.ProductID = OD.ProductID
    inner join Orders as O
        on OD.OrderID = O.OrderID
    where year(OrderDate) = 1997
    group by CategoryName, datename(month, OrderDate)
)
select
    CategoryName
    , OrderMonth
--     , CategoryProfit
from CategoriesMonthsProfits as CMP1
where CMP1.CategoryProfit = (
    select
        max(CMP2.CategoryProfit)
    from CategoriesMonthsProfits as CMP2
    where CMP1.OrderMonth = CMP2.OrderMonth
    )
order by OrderMonth

-- 3. Dane pracownika i najczęstszy dostawca pracowników bez podwładnych


with EmployeesAndShippers as (
    select
        e.EmployeeID
        , ShipVia
        , count(*) as ShipperCount
    from Employees as e
    inner join Orders as O
        on e.EmployeeID = O.EmployeeID
    group by e.EmployeeID, ShipVia
), MaxShipper as (
    select
        EmployeeID
--         , ShipVia
        , max(ShipperCount) as MaxShipper
    from EmployeesAndShippers
    group by EmployeeID
)
select
    MaxShipper.EmployeeID
    , emp.FirstName
    , emp.LastName
    , ShipVia
    , s.CompanyName
from MaxShipper
inner join EmployeesAndShippers
    on MaxShipper.EmployeeID = EmployeesAndShippers.EmployeeID
inner join Employees as emp
    on MaxShipper.EmployeeID = emp.EmployeeID
        and EmployeesAndShippers.EmployeeID = emp.EmployeeID
inner join Shippers as s
    on s.ShipperID = EmployeesAndShippers.ShipVia
where ShipperCount = MaxShipper
    and emp.EmployeeID in (
        select
            boss.EmployeeID
        --     , emp.EmployeeID
        --     , emp.ReportsTo
        from Employees as emp
        right join Employees as boss
            on emp.ReportsTo = boss.EmployeeID
        where emp.ReportsTo is null
    )

-- 4. Wybierz tytuły książek, gdzie ilość wypożyczeń książki jest większa od średniej ilości
-- wypożyczeń książek tego samego autora.

with BooksLoanhistCount as (
    select
        author
        , t1.title_no
        , count(*) as BooksCount
    from loanhist as lh1
    inner join title as t1
        on lh1.title_no = t1.title_no
    group by t1.title_no, author
), BooksLoanCount as (
    select
        author
        , t2.title_no
        , count(*) as BooksCount
    from loan as l1
    inner join title as t2
        on l1.title_no = t2.title_no
    group by author, t2.title_no
), BooksTotalCount as (
    select
        t3.author
        , t3.title_no
        , t3.title
        , b1.BooksCount as LBookCnt
        , b2.BooksCount as LHBookCnt
        , isnull(b1.BooksCount, 0) + isnull(b2.BooksCount, 0) as BooksSum
    from title as t3
    left join BooksLoanCount as b1
        on t3.title_no = b1.title_no
    left join BooksLoanhistCount as b2
        on t3.title_no = b2.title_no
)
select
    title_no
    , title
    , BTC1.BooksSum
from BooksTotalCount as BTC1
where BooksSum > (
    select
        avg(BooksSum)
    from BooksTotalCount as BTC2
    where BTC1.author = BTC2.author
)
