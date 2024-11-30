-- Ćw 1. Dla każdego roku oraz miesiąca wybierz najaktywniejszego dostawcę
-- (tego, który obsłużył najwięcej zamówień)

with ShipCount as (
    select
        ShipVia
        , year(OrderDate) as OrderYear
        , month(OrderDate) as OrderMonth
        , count(*) as OrdersCount
    from Orders
    group by ShipVia, year(OrderDate), month(OrderDate)
), RankedShipCount as (
    select
        ShipVia
        , OrderYear
        , OrderMonth
        , OrdersCount
        , rank() over (partition by OrderYear, OrderMonth order by OrdersCount desc) as OrdersCountRank
    from ShipCount
)
select
    CompanyName
    , OrderYear
    , OrderMonth
    , OrdersCount
    , OrdersCountRank
from RankedShipCount
inner join Shippers
    on ShipVia = Shippers.ShipperID
where
    OrdersCountRank = 1
order by OrderYear, OrderMonth
