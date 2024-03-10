:!UTF-8
select 
0 as LP,
:_a.KTM as KTM,
:_a.NAZWA as Nazwa,
:_a.JM as jm,
sum(:_a.STAN) Stan,
sum(:_a.REZ) as Rezerwacje,
sum(:_a.STAN-:_a.REZ) as Dostępne,
:_a.PARTIA as  Partia,
:_a.KJX as KJx,
:_a.TW as TW
from  :_a
group by KTM,NAZWA,JM,PARTIA,KJX,TW 
order by 2