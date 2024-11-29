-- 1. Podział na company, year month i suma freight

select
    CompanyName
    , year(OrderDate) as OrderYear
    , datename(month, OrderDate) as OrderMonth
    , sum(Freight) as FreightSum
from Orders as O
inner join Customers
    on O.CustomerID = Customers.CustomerID
group by CompanyName, year(OrderDate), datename(month, OrderDate);

-- 2. Wypisać wszystkich czytelników, którzy nigdy nie wypożyczyli książki dane
-- adresowe i podział czy ta osoba jest dzieckiem (joiny, in, exists)

TODO

-- 3. Najczęściej wybierana kategoria w 1997 dla każdego klienta

with CategoryCount as (
    select
        CategoryName
        , CustomerID
        , count(*) Cnt
    from Orders as O
    inner join [Order Details] as OD
        on O.OrderID = OD.OrderID and year(OrderDate) = 1997
    inner join Products
        on OD.ProductID = Products.ProductID
    inner join Categories as Cat
        on Products.CategoryID = Cat.CategoryID
    group by CustomerID, CategoryName
), MaxCategoryCount as (
    select
        CustomerID
        , max(Cnt) as MaxCnt
    from CategoryCount
    group by CustomerID
)
select
    distinct
    CategoryCount.CustomerID
    , CategoryCount.CategoryName
    , CategoryCount.Cnt
from MaxCategoryCount
inner join CategoryCount
    on CategoryCount.CustomerID = MaxCategoryCount.CustomerID
where CategoryCount.Cnt = MaxCnt
order by 1;

-- 4. Dla każdego czytelnika imię nazwisko, suma książek wypożyczony przez tą osobę i
-- jej dzieci, który żyje w Arizona ma mieć więcej niż 2 dzieci lub kto żyje w Kalifornii
-- ma mieć więcej niż 3 dzieci

with ParentsWithChildCount as (
    select
        Parent.member_no
        , firstname
        , lastname
        , state
        , count(Child.member_no) as ChildCount
        , (
            select
                count(*)
            from loan as l
            where l.member_no in (
                select
                    member_no
                from juvenile
                where juvenile.adult_member_no = Parent.member_no
                )
                or l.member_no = Parent.member_no
        ) as LoanedBooksSum
    from juvenile as Child
    right join adult as Parent
        on Child.adult_member_no = Parent.member_no
    inner join member as m
        on Parent.member_no = m.member_no
    group by Parent.member_no, firstname, lastname, state
)
select
    firstname
    , lastname
    , state
    , ChildCount
    , LoanedBooksSum
from ParentsWithChildCount
where state = 'CA' and ChildCount > 3
union
select
    firstname
    , lastname
    , state
    , ChildCount
    , LoanedBooksSum
from ParentsWithChildCount
where state = 'AZ' and ChildCount > 2
order by LoanedBooksSum desc
;

-- select
--     distinct
--     state
-- from adult
-- order by 1
--
-- select
--     *
-- from loan
-- where member_no in (181, 182, 7306, 8704, 9686)
--
-- select
--     member_no
-- from juvenile
-- where adult_member_no = 181
