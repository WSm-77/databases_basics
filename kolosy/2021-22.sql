use Northwind

-- Zad.1. Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku

with ProfitTable as (
    select
        OD.ProductID,
        round(sum(OD.Quantity * OD.UnitPrice * (1 - Discount)), 2) as Profit
    from [Order Details] as OD
    inner join Orders as O
        on OD.OrderID = O.OrderID
    where year(OrderDate) = 1996
    group by OD.ProductID
)
select
    top 1
--     ProfitTable.ProductID,
    Prod.ProductName
--     , Profit
from ProfitTable
inner join Products as Prod
    on ProfitTable.ProductID = Prod.ProductID
where Profit > 0
order by Profit

-- Zad.2. Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres)
-- rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
-- którzy nigdy nie wypożyczyli książki

use library

select
    distinct
    Mem.member_no
    , Mem.firstname
    , Mem.lastname
    , ChildCount.ChildCountCol
from member as Mem
left join adult as Parent
    on Mem.member_no = Parent.member_no
left join juvenile as Child
    on Mem.member_no = Child.member_no
left join (
    select
        adult.member_no
        , count(juvenile.member_no) as ChildCountCol
    from adult
    left join juvenile
        on adult.member_no = juvenile.adult_member_no
    group by adult.member_no
) ChildCount
    on Parent.member_no = ChildCount.member_no
left join loanhist
    on loanhist.member_no = Mem.member_no
where loanhist.member_no is null

-- Zad.3. Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych
-- przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma
-- wyniosła 0.

select
    O2.OrderID
    , isnull(OrderPrice, 0)
--     , (OrderPrice)
from
(
    select
        O.OrderID
--         , year(OrderDate) as OrderYear
--         , month(OrderDate) as OrderMonth
        , round(sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) + O.Freight, 2) as OrderPrice
    from  [Order Details] as OD
    inner join Orders as O
        on OD.OrderID = O.OrderID
    where year(OrderDate) = 1997 and month(OrderDate) = 2
    group by O.OrderID, O.Freight

) as Orders_in_february_1997
right join Orders as O2
    on Orders_in_february_1997.OrderID = O2.OrderID
