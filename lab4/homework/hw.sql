use library

-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.

select firstname,
       lastname,
       birth_date
from juvenile
inner join member
on juvenile.member_no = member.member_no;

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek

select distinct title
from title
inner join loan
on title.title_no = loan.title_no;

-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono karę

select title,
       in_date,
       due_date,
       datediff(d, loanhist.due_date, in_date) as DaysBookWasKept,
       fine_paid
from loanhist
inner join title
on title.title_no = loanhist.title_no
where due_date < loanhist.in_date and title = 'Tao Teh King'
order by DaysBookWasKept desc;

select title,
       in_date,
       due_date,
       datediff(d, loanhist.due_date, in_date) as DaysBookWasKept,
       fine_paid
from loanhist
inner join title
on title.title_no = loanhist.title_no and title = 'Tao Teh King'
where
      datediff(d, loanhist.due_date, in_date) >= 0
order by DaysBookWasKept desc;

-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
-- przez osobę o nazwisku: Stephen A. Graff

select isbn,
       lastname,
       middleinitial,
       firstname
from reservation
inner join member
on reservation.member_no = member.member_no
where firstname like '%stephen%' and lastname = 'graff' and member.middleinitial = 'A';
