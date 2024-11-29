use joindb

select * from Buyers
select * from Produce
select * from Sales

-------- STARA SKŁADNIA --------

select buyer_name,
       Sales.buyer_id,
       qty
from Sales,
     Buyers
where Sales.buyer_id = Buyers.buyer_id

-------- NOWA SKŁADNIA --------

select buyer_name,
       Sales.buyer_id,
       qty
from Buyers inner join Sales
on Sales.buyer_id = Buyers.buyer_id
