:!UTF-8
select
0 as LP,
:_a.ODD as Oddzial,
:_a.KOD as Kod,
:_a.NAZ as Nazwa,
:_a.WAL as Czy_walutowy,
:_a.RODZ as Rodzaj_dokumentu,
:_a.NAZ_DOK as Nazwa_dokumentu,
:_a.VAT_KOD as Kod_schematu,
:_a.VAT_NAZ as Nazwa_schematu
from :_a

