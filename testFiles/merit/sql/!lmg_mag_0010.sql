:!UTF-8
select 
   0 lp,
   '- Dokumenty z okresu ' || popokr || ' -' Typ,
   0 Przychod,
   0 Rozchod
from
   :_c
group by popokr

union all

/* bieżące sumy przychodów i rozchodów */
select
   0 lp,
   typ Typ,
   sum(przychod) Przychod,
   sum(rozchod) Rozchod
from 
   :_c
group by typ
having sum(przychod)>0 or sum(rozchod)>0

union all

select
   0 lp,
   'BILANS do ' || max(popokr) Typ,
   sum(war_pocz) Przychod,
   0 Rozchod
from
   :_c
group by przychod
having sum(war_pocz)>0

union all

select
   0 lp,
   'BILANS do ' || max(popokr) Typ,
   0 Przychod,
   sum(-war_pocz) Rozchod
from
   :_c
group by przychod
having sum(war_pocz)<0

union all

select
   0 lp,
   'SUMA przychodów w ' || max(popokr) Typ, 
   sum(przychod) Przychod,
   0 Rozchod
from
   :_c
group by war_pocz
having sum(przychod)<>0

union all

select
   0 lp,
   'SUMA rozchodów w ' || max(popokr) Typ,
   0 Przychod,
   sum(rozchod) Rozchod
from
   :_c
group by war_pocz
having sum(rozchod)<>0

union all

select
   0 lp,
   'SALDO w ' || max(popokr) Typ,
   sum(war_pocz)+sum(przychod)-sum(rozchod) Przychod,
   0 Rozchod
from
   :_c
group by popokr
having sum(war_pocz)+sum(przychod)-sum(rozchod)>0

union all

select
   0 lp,
   'SALDO w ' || max(popokr) Typ,
   0 Przychod,
   sum(-war_pocz)+sum(-przychod)-sum(-rozchod) Rozchod
from
   :_c
group by popokr
having sum(war_pocz)+sum(przychod)-sum(rozchod)<0

