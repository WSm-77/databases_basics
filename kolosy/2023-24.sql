use Northwind

-- ZAD 1 Podaj nazwe produktu dla którego osiągnieto minimalny, ale niezerowy zysk z produktu w 1996

-- my

with ProfitTable as (
    select
        Prod.ProductName,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as Profit
    from [Order Details] as OD
    inner join Products as Prod
        on OD.ProductID = Prod.ProductID
    inner join Orders
        on OD.OrderID = Orders.OrderID
    where year(OrderDate) = 1996
    group by Prod.ProductName
)
select
    top 1
    ProfitTable.ProductName
    , ProfitTable.Profit
from ProfitTable
where ProfitTable.Profit > 0
order by ProfitTable.Profit

-- wiki

WITH T1 AS (
    SELECT ProductName
         , ROUND(SUM((Quantity * Products.UnitPrice * (1 - discount))),2) AS Dochod
    FROM Orders
    INNER JOIN [Order Details]
        ON Orders.OrderID = [Order Details].OrderID
    INNER JOIN Products
        ON [Order Details].ProductID = Products.ProductID
    WHERE YEAR(OrderDate) = 1996
    GROUP BY ProductName
)
SELECT
    TOP 1
    ProductName
    , Dochod
FROM T1
WHERE Dochod > 0
order by Dochod

-- ZAD 2, Podaj imiona, nazwiska i tytuły książek poozyczone przez wiecej niz 1 czytelnika, ktorzy mają dzieci.

use library

-- my

with books_loaned_by_parents as (
    select
        distinct
        member.firstname
        , member.lastname
        , title
        , member.member_no
    from title
    inner join loanhist
        on title.title_no = loanhist.title_no
    inner join member
        on loanhist.member_no = member.member_no
    where member.member_no in (select
            distinct
            parent.member_no
        from adult as parent
        inner join juvenile as child
            on parent.member_no = child.adult_member_no)
)
select
    distinct
    books_loaned_by_parents.firstname
    , books_loaned_by_parents.lastname
    , books_loaned_by_parents.title
from books_loaned_by_parents
where (select count(books_loaned_by_parents.member_no) from books_loaned_by_parents) > 1
order by books_loaned_by_parents.title

with books_loaned_by_parents as (
    select
        distinct
        member.firstname
        , member.lastname
        , title
        , member.member_no
    from title
    inner join loanhist
        on title.title_no = loanhist.title_no
    inner join member
        on loanhist.member_no = member.member_no
    where member.member_no in (select
            child.adult_member_no
        from juvenile as child)
), books_count as (
    select
        title
        , count(member_no) as BooksCount
    from books_loaned_by_parents
    group by title
    having count(member_no) > 1
)
select
    distinct
    books_loaned_by_parents.firstname
    , books_loaned_by_parents.lastname
    , books_loaned_by_parents.title
from books_count
inner join books_loaned_by_parents
    on books_loaned_by_parents.title = books_count.title
where books_count.BooksCount > 1

-- wiki

WITH T1 AS
(
    SELECT title, member_no
    FROM loanhist
    INNER JOIN title ON loanhist.title_no = title.title_no
), T2 AS (
    SELECT member_no
    FROM T1
    WHERE member_no IN (SELECT adult_member_no FROM juvenile)
)
SELECT lastname, firstname, title
FROM T1
INNER JOIN T2 ON T1.member_no = T2.member_no
INNER JOIN member ON member.member_no = T1.member_no
GROUP BY lastname, firstname, title
HAVING COUNT(T1.member_no) > 1
ORDER BY title

-- ZAD 3, Podaj wszystkie zamówienia dla których opłata za przesyłke > od sredniej w danym roku

use Northwind

-- my

with year_avg as (
    select
        year(OrderDate) as order_year,
        avg(Freight) as AvgFreight
    from Orders
    group by year(OrderDate)
)
select
    OrderID
--     , Freight
--     , year_avg.AvgFreight
from Orders
inner join year_avg
    on year_avg.order_year = year(OrderDate)
where Freight > year_avg.AvgFreight

-- wiki

SELECT OrderID
FROM Orders as Oouter
WHERE Freight >
      (
        SELECT AVG(Freight)
        FROM Orders as Oinner
        WHERE YEAR(Oouter.OrderDate) = YEAR(Oinner.OrderDate)
      )
