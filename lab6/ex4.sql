use library

-- 1. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
-- niż dwoje dzieci zapisanych do biblioteki.

select
    parent.member_no,
    parent.state,
    count(child.member_no)
from adult as parent
inner join juvenile as child
    on parent.member_no = child.adult_member_no
where state = 'AZ'
group by parent.member_no, parent.state
having count(child.member_no) > 2;

-- 2. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
-- niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni
-- (CA) i mają więcej niż troje dzieci zapisanych do biblioteki

-- pomocniczy select

select count(*)
from (
    select
        m.firstname,
        m.lastname,
        a.member_no,
        count(j.member_no) as child_count
    from adult as a
    left join juvenile j
        on a.member_no = j.adult_member_no
    inner join member as m
        on a.member_no = m.member_no
    group by m.firstname, m.lastname, a.member_no
    -- having count(j.member_no) > 1
) as children;

select m.firstname
    , m.lastname
    , a.member_no
    , a.state
    , count(j.member_no) as child_count
from adult as a
left join juvenile j
    on a.member_no = j.adult_member_no
inner join member as m
    on a.member_no = m.member_no
where state = 'AZ'
group by m.firstname, m.lastname, a.member_no, a.state
having count(j.member_no) > 2
union
select
    m.firstname
    , m.lastname
    , a.member_no
    , a.state
    , count(j.member_no) as child_count
from adult as a
left join juvenile j
    on a.member_no = j.adult_member_no
inner join member as m
    on a.member_no = m.member_no
where state = 'CA'
group by m.firstname, m.lastname, a.member_no, a.state
having count(j.member_no) > 3;
