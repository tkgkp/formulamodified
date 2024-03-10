:!UTF-8

select 
 0 as LP,
 f_zatr.kod, 
 p.za, 
 cp.cp, 
 p.t, 
 osoba.nazwisko, 
 osoba.pierwsze,
 osoba 
from 
 p join 
 osoba join 
 cp  join 
 f_zatr 
where 
 osoba in ( select osoba from users where osoba is not null) and 
 p.za='T' and 
 f_zatr.kod='P'