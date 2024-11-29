use library;

------------------ EXERCISE 1 ------------------

-- 1. Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książki
select title, title_no from title;

-- 2. Napisz polecenie, które wybiera tytuł o numerze 10
select title from title where title_no = 10;
;
-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i autora z tablicy title dla
--    wszystkich książek, których autorem jest CharlesDickens lub Jane Austen
select title_no, author from title where author in ('Charles Dickens', 'Jane Austen');

------------------ EXERCISE 2 ------------------

-- 1. Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek,
-- których tytuły zawierających słowo „adventure”
select title, title_no from title where title like '%adventure%';

-- 2. Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę
select member_no, fine_paid from loanhist where fine_paid is not NULL order by fine_paid;

-- 3. Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy adult.
select distinct city, state from adult;

-- 4. Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w
-- porządku alfabetycznym.
select  title from title order by title;

------------------ EXERCISE 3 ------------------

-- 1. Napisz polecenie, które:
-- – wybiera numer członka biblioteki (member_no), isbn książki (isbn) i watrość
--   naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń
--   dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
select member_no, isbn, fine_assessed from loanhist where fine_assessed is not null;

-- – stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny
--   fine_assessed
select 2 * fine_assessed from loanhist where fine_assessed is not null;

-- - stwórz alias ‘double fine’ dla tej kolumny
select 2 * fine_assessed as double_fine from loanhist where fine_assessed is not null;

-- połączone komendy
select member_no, isbn, fine_assessed, 2 * fine_assessed as double_fine from loanhist where fine_assessed is not null;

------------------ EXERCISE 4 ------------------

-- 1. Napisz polecenie, które
-- – generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię członka biblioteki),
--   middleinitial (inicjał drugiego imienia) i lastname (nazwisko) z tablicy member dla wszystkich
--   członków biblioteki, którzy nazywają się Anderson
select firstname + ' ' + middleinitial + ' ' + lastname from member where lastname = 'Anderson';

--   – nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla kolumny)
select firstname + middleinitial + lastname as email_name from member where lastname = 'Anderson';

--   – zmodyfikuj polecenie, tak by zwróciło „listę proponowanych loginów e-mail” utworzonych przez
--     połączenie imienia członka biblioteki, z inicjałem drugiego imienia i pierwszymi dwoma literami
--     nazwiska (wszystko małymi małymi literami).
--     - Wykorzystaj funkcję SUBSTRING do uzyskania części kolumny znakowej oraz LOWER do zwrócenia wyniku małymi literami.
--       Wykorzystaj operator (+) do połączenia stringów.
select lower(concat(firstname, middleinitial, substring(lastname, 1, 2))) + '@library.com' as email_name from member;

------------------ EXERCISE 5 ------------------

-- 1. Napisz polecenie, które wybiera title i title_no z tablicy title.
--    - Wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie poniżej:
--          The title is: Poems, title number 7
--    - Czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o wyrażenie, które łączy 4 elementy:
--          - stała znakowa ‘The title is:’
--          - wartość kolumny title
--          - stała znakowa ‘title number’
--          - wartość kolumny title_no

-------- sposób 1 --------
select concat('The title is: ', title, ', title number ', title_no) from title;

-------- sposób 2 --------
select 'The title is: ' + title + ', title number ' +  replace(str(title_no, 10, 0), ' ', '') from title;

-------- sposób 3 --------
select 'The title is: ' + title + ', title number ' +  cast(title_no as varchar) from title;
