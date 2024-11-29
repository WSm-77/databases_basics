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

-- 3. Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United
-- Package’



-- 4. Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu
-- 1997 i wypisz nazwę tej kategorii
