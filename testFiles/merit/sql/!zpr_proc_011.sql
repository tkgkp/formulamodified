:!UTF-8
select 0 as LP, B_ROLE.NAME as "Rola", FIRMA.SYMBOL as "Firma"
from B_ROLE  join FIRMA using (B_ROLE.FIRMA, FIRMA.REFERENCE)
where (':_a'='W' or B_ROLE.FIRMA=:_b)
            and B_ROLE.REFERENCE not in (select distinct B_ROLE from @B_USRROL )
order by "Rola", "Firma"
