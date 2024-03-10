:!UTF-8
select
 0 as LP,
      :_a.ZLECENIE,
      sum(:_a.WAR_RW) as War_RW,
      sum(:_a.WAR_RP) as War_RP
from :_a
group by :_a.ZLECENIE
order by 2

