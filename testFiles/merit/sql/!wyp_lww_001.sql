:!UTF-8

select
   0  as LP,
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE,
   OSOBA.DRUGIE,
   P.T,
   KARO.DATA,
   KARO.DATAZ,
   KARO.ZWROT,
   KARO.TYP,
   M.KTM,
   KARO.IL
from KARO join P join OSOBA join M
where KARO.TYP like ':_a'
   and KARO.ZWROT like ':_b'

