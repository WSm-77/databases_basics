use library

-- 1. Napisz polecenie, które wyświetli listę dzieci będących członkami biblioteki. Interesuje nas imię,
-- nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.

select
    firstname,
    lastname
from member as m
inner join juvenile as j
    on m.member_no = j.member_no;

select
    firstname,
    lastname,
    street,
    city,
    state
from member as m
inner join juvenile as j
    on m.member_no = j.member_no
inner join adult as a
    on j.adult_member_no = a.member_no;

-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki. Intereseuje nas imię,
-- nazwisko, datra urodzenia dziecka, adres zamieszkania dziecka oraz mię i nazwisko rodzica.

select
    m.firstname,
    m.lastname,
    m2.firstname,
    m2.lastname,
    street,
    city,
    state
from member as m
inner join juvenile as j
    on m.member_no = j.member_no
inner join adult as a
    on j.adult_member_no = a.member_no
inner join member as m2
    on a.member_no = m2.member_no;
