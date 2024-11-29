-- 1. Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001

select
    top 1
    author
--     , t.title_no
    , count(*) as BooksCount
from loanhist as lh
inner join title as t
    on lh.title_no = t.title_no
where year(lh.out_date) = 2001
    and lh.member_no in (
        select
            distinct
            j.member_no
        --     , state
        from juvenile as j
        inner join adult as a
            on j.adult_member_no = a.member_no
        where state = 'Az'
    )
group by author
order by BooksCount desc

-- select
--     distinct
--     j.member_no
-- --     , state
-- from juvenile as j
-- inner join adult as a
--     on j.adult_member_no = a.member_no
-- where state = 'Az'

-- 2. Dla każdego dziecka wybierz jego imię nazwisko, adres, imię i nazwisko rodzica i
-- ilość książek, które oboje przeczytali w 2001

-- first solution

with ParentsBookCount as (
    select
        a1.member_no
--         , year(lh1.out_date) as OutYear
        , count(lh1.title_no) as BookCount
    from adult as a1
    inner join loanhist as lh1
        on a1.member_no = lh1.member_no
    where year(lh1.out_date) = 2001
    group by a1.member_no
--            , lh1.out_date
), ChildBookCount as (
    select
        j1.member_no
--         , year(lh1.out_date) as OutYear
        , j1.adult_member_no
        , count(lh1.title_no) as BookCount
    from juvenile as j1
    inner join loanhist as lh1
        on j1.member_no = lh1.member_no
    where year(lh1.out_date) = 2001
    group by j1.member_no
        , adult_member_no
--            , lh1.out_date
)
select
    m.firstname
    , m.lastname
--     , m.member_no
--     , j2.member_no
--     , ChildBookCount.BookCount
--     , ParentsBookCount.BookCount
    , (
        select
            firstname
        from adult as a2
        inner join member as m
            on a2.member_no = m.member_no
        where j2.adult_member_no = a2.member_no
    ) as ParentFirstName
    , (
        select
            m.lastname
        from adult as a2
        inner join member as m
            on a2.member_no = m.member_no
        where j2.adult_member_no = a2.member_no
    ) as ParentLastName
    , isnull(ChildBookCount.BookCount, 0) + isnull(ParentsBookCount.BookCount, 0) as BooksSum
    , (select state from adult as a2 where j2.adult_member_no = a2.member_no) as State
    , (select street from adult as a2 where j2.adult_member_no = a2.member_no) as Street
    , (select city from adult as a2 where j2.adult_member_no = a2.member_no) as City
    , (select zip from adult as a2 where j2.adult_member_no = a2.member_no) as Zip
from juvenile as j2
inner join member as m
    on j2.member_no = m.member_no
left join ChildBookCount
    on j2.member_no = ChildBookCount.member_no
left join ParentsBookCount
    on ChildBookCount.adult_member_no = ParentsBookCount.member_no
order by BooksSum desc;

-- second solution

with ParentsBookCount as (
    select
        a1.member_no
--         , year(lh1.out_date) as OutYear
        , count(lh1.title_no) as BookCount
    from adult as a1
    inner join loanhist as lh1
        on a1.member_no = lh1.member_no
    where year(lh1.out_date) = 2001
    group by a1.member_no
--            , lh1.out_date
), ChildBookCount as (
    select
        j1.member_no
--         , year(lh1.out_date) as OutYear
        , j1.adult_member_no
        , count(lh1.title_no) as BookCount
    from juvenile as j1
    inner join loanhist as lh1
        on j1.member_no = lh1.member_no
    where year(lh1.out_date) = 2001
    group by j1.member_no
        , adult_member_no
--            , lh1.out_date
)
select
    m.firstname
    , m.lastname
--     , m.member_no
--     , j2.member_no
--     , ChildBookCount.BookCount
--     , ParentsBookCount.BookCount
    , Parents.firstname
    , Parents.lastname
    , Parents.state
    , Parents.city
    , Parents.street
    , Parents.zip
    , isnull(ChildBookCount.BookCount, 0) + isnull(ParentsBookCount.BookCount, 0) as BooksSum
from juvenile as j2
inner join member as m
    on j2.member_no = m.member_no
inner join (
    select
        a2.member_no
        , firstname
        , lastname
        , state
        , city
        , street
        , zip
    from adult as a2
    inner join member
        on a2.member_no = member.member_no
) as Parents
    on Parents.member_no = j2.adult_member_no
left join ChildBookCount
    on j2.member_no = ChildBookCount.member_no
left join ParentsBookCount
    on j2.adult_member_no = ParentsBookCount.member_no
order by BooksSum desc;

-- third solution

select
    jm.firstname
    , j1.member_no
    , jm.lastname
    , am.firstname
    , am.lastname
    , (
        select
            count(*)
        from loanhist as lh1
        where lh1.member_no in (j1.member_no, j1.adult_member_no)
            and year(lh1.out_date) = 2001
    ) as BooksSum
    , a1.state
    , a1.city
    , a1.street
    , a1.zip
from juvenile as j1
inner join member as jm
    on j1.member_no = jm.member_no
inner join adult as a1
    on j1.adult_member_no = a1.member_no
inner join member as am
    on a1.member_no = am.member_no
order by BooksSum desc


-- select
--     distinct
--     member_no
--     , title_no
--     , isbn
--     , out_date
--     , year(out_date)
-- from loanhist
-- where year(out_date) = 2001
--     and member_no in (388, 387)

-- 3. Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United
-- Package’

select
    distinct
    CategoryName
--     , Sh1.CompanyName
--     , year(ShippedDate)
--     , month(ShippedDate)
from Categories as Cat1
inner join Products as Prod1
    on Cat1.CategoryID = Prod1.CategoryID
inner join [Order Details] as OD1
    on Prod1.ProductID = OD1.ProductID
inner join Orders as O1
    on OD1.OrderID = O1.OrderID
inner join Shippers as Sh1
    on O1.ShipVia = Sh1.ShipperID
where Sh1.CompanyName = 'United Package'
    and year(ShippedDate) = 1997
    and month(ShippedDate) = 12
except
select
    distinct
    CategoryName
--     , Sh1.CompanyName
--     , year(ShippedDate)
--     , month(ShippedDate)
from Categories as Cat1
inner join Products as Prod1
    on Cat1.CategoryID = Prod1.CategoryID
inner join [Order Details] as OD1
    on Prod1.ProductID = OD1.ProductID
inner join Orders as O1
    on OD1.OrderID = O1.OrderID
inner join Shippers as Sh1
    on O1.ShipVia = Sh1.ShipperID
where Sh1.CompanyName != 'United Package'
    and year(ShippedDate) = 1997
    and month(ShippedDate) = 12;

-- 4. Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu
-- 1997 i wypisz nazwę tej kategorii

select
    distinct
    CustomerID
    , CategoryName
from Products as Prod1
inner join Categories
    on Prod1.CategoryID = Categories.CategoryID
inner join [Order Details] as OD1
    on Prod1.ProductID = OD1.ProductID
inner join Orders as O1
    on OD1.OrderID = O1.OrderID
where
    year(OrderDate) = 1997
    and month(OrderDate) = 3
    and CustomerID in (
        select
            O2.CustomerID
        --     , count(distinct Prod1.CategoryID) as DifferentCategoriesCount
        from Products as Prod2
        inner join [Order Details] as OD2
            on Prod2.ProductID = OD2.ProductID
        inner join Orders as O2
            on OD2.OrderID = O2.OrderID
        where
            year(OrderDate) = 1997
            and month(OrderDate) = 3
        group by O2.CustomerID
        having
            count(distinct Prod2.CategoryID) = 1
    )
