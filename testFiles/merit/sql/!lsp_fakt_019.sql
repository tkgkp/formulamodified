:!UTF-8
select
   0 as LP,
   :_d.TAXS KodOplaty,
   :_d.DATA DataWyst,
   :_d.MKTM Indeks,
   :_d.NKTM Nazwa,
   :_d.MGSP Stanowisko,
   :_d.NOPL WarOpl,
   :_d.WOPL WarWal,
   :_d.W01 Wyroznik_1,
   :_d.W02 Wyroznik_2,
   :_d.W03 Wyroznik_3,
   :_d.W04 Wyroznik_4,
   :_d.W05 Wyroznik_5,
   :_d.W06 Wyroznik_6
from
   :_d
order by
   2, 3, 4