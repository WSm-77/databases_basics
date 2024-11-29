use Northwind

-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek

select
    Prod.ProductName,
    max(OD.Quantity) as max_qunatity_ordered
from [Order Details] as OD
inner join Products as Prod
    on OD.ProductID = Prod.ProductID
group by OD.ProductID, Prod.ProductName
order by 2 desc;

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu

select
    ProductName,
    UnitPrice
from Products
where UnitPrice < (
    select
        avg(UnitPrice)
    from Products
);

-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- danej kategorii

select
    ProductName,
    Prod.UnitPrice,
    avg_unit_price
from Products as Prod
inner join (
    select
        CategoryID,
        avg(UnitPrice) as avg_unit_price
    from Products
    group by CategoryID
) as CategoriesAvgPrices
    on CategoriesAvgPrices.CategoryID = Prod.CategoryID
where Prod.UnitPrice < CategoriesAvgPrices.avg_unit_price;
