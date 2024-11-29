use Northwind;

-- 1. Napisz polecenie które dla każdego dostawcy pokaże pojedynczą kolumnę zawierającą nr telefonu i nr faksu w formacie (numer telefonu i faksu mają być oddzielone przecinkiem)
select ISNULL(Phone, 'no phone number') + ', ' + ISNULL(Fax, 'no fax') as Contact from Suppliers;
