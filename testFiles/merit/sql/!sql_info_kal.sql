:!UTF-8
select
   0 lp,
   to_string(max(kal_def.poczatek)) a,
   to_string(max(kal_def.koniec)) b,
   max(kal_def.typ) c
from
   kal_def join kal_rok join kal_nazw
where
   kal_nazw.nazwa=':_b'
   and
   kal_rok.rok=:_a
group by
   kal_def.poczatek, kal_def.koniec, kal_def.typ