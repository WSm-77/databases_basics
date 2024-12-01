-- 1. Wypisz te produkty które kupiło conajmniej 2 klientów
-- a) podzapytaniem

select
    distinct
    ProductName
from Orders as O
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
where (
    select
        count(distinct CustomerID)
    from Orders as O2
    inner join [Order Details] as OD2
        on O2.OrderID = OD2.OrderID
    inner join Products as Prod2
        on OD2.ProductID = Prod2.ProductID
    where Prod.ProductName = Prod2.ProductName
    ) > 2

-- b) bez podzapytań

select
    ProductName
from Orders as O
inner join [Order Details] as OD
    on O.OrderID = OD.OrderID
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
group by ProductName
having count(distinct CustomerID) > 2

select
    ProductID
    , count(distinct CustomerID)
from [Order Details] as OD
inner join Orders as O
    on OD.OrderID = O.OrderID
group by ProductID
order by 2;

-- 2. Znajdź produkt (podaj jego nazwę), który przyniósł najmniejszy dochód (większy od zera) w 1996 roku

-- rozwiązanie nr 1

with ProductsProfit as (
    select
        ProductID
        , year(OrderDate) as OrderYear
        , round(sum(OD1.Quantity * OD1.UnitPrice * (1 - OD1.Discount)), 2) as ProductProfit
    from [Order Details] as OD1
    inner join Orders as O1
        on OD1.OrderID = O1.OrderID
    group by ProductID, year(OrderDate)
), ProductsProfitRank as (
    select
        ProductID
        , ProductsProfit.ProductProfit
        , rank() over (order by ProductsProfit.ProductProfit) as ProfitRank
    from ProductsProfit
    where ProductProfit > 0 and OrderYear = 1996
)
select
    ProductName
--     , ProductsProfitRank.ProductProfit
--     , ProfitRank
from ProductsProfitRank
inner join Products
    on ProductsProfitRank.ProductID = Products.ProductID
where ProductsProfitRank.ProfitRank = 1;

-- rozwiązanie nr 2

with ProductsProfit as (
    select
        ProductID
        , round(sum(OD1.Quantity * OD1.UnitPrice * (1 - OD1.Discount)), 2) as ProductProfit
    from [Order Details] as OD1
    where OrderID in (
        select
            OrderID
        from Orders as O2
        where year(OrderDate) = 1996
        )
    group by ProductID
)
select
    (
        select
            ProductName
        from Products
        where Products.ProductID = ProductsProfit.ProductID
    ) as ProductName
--     , ProductsProfit.ProductProfit
from ProductsProfit
where ProductsProfit.ProductProfit = (
        select
            min(ProductsProfit.ProductProfit)
        from ProductsProfit
    );
