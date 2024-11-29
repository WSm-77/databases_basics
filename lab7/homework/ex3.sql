use Northwind

-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich
-- produktów oraz różnicę między ceną produktu a średnią ceną wszystkich
-- produktów

select
    Prod.ProductName,
    Prod.UnitPrice,
    (
        select
            avg(UnitPrice) as avg_product_price
        from Products
    ) as avg_product_price,
    abs(Prod.UnitPrice -
        (select
            avg(UnitPrice) as avg_product_price
        from Products)
    ) as difference
from Products as Prod;

select
    avg(UnitPrice) as avg_product_price
from Products;

-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią
-- cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a
-- średnią ceną wszystkich produktów danej kategorii

select
    Cat.CategoryName,
    Prod.ProductName,
    Prod.UnitPrice,
    avg_category_price,
    abs(Prod.UnitPrice - avg_category_price) as prices_difference
from Products as Prod
inner join (
    select
        CategoryID,
        avg(UnitPrice) as avg_category_price
    from Products
    group by CategoryID
) as AvgCategoryPricew
    on AvgCategoryPricew.CategoryID = Prod.CategoryID
inner join Categories as Cat
    on Prod.CategoryID = Cat.CategoryID;
