use library

-- 1. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996

select
    distinct
    parent.member_no,
    parent.street,
    parent.city,
    parent.zip
--     child.birth_date,
--     child.member_no
from adult as parent
inner join juvenile as child
    on parent.member_no = child.adult_member_no
where child.birth_date < '1996-01-01';

-- 2. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urdodzone przed 1 stycznaia 1996. Interesuje nas tylko adresy takich członków biblioteki,
-- którzy aktualnie nie przetrzymują książek.

select
    distinct
    parent.member_no,
    m.firstname,
    m.lastname,
    l.title_no
from adult as parent
inner join dbo.juvenile as child
    on parent.member_no = child.adult_member_no
inner join member as m
    on parent.member_no = m.member_no
left join loan as l
    on m.member_no = l.member_no
where child.birth_date < '1996-01-01'
    and (l.title_no is null or l.due_date > getdate());
