:!UTF-8
select 0 as LP,  B_ELE.SYMBOL as "Czynność", B_ACTION.NAME as "Nazwa", B_DOMAIN.SYMBOL as "Obszar"
from @B_ACTION join B_ELE using (B_ACTION.B_ELE, B_ELE.REFERENCE)
         join B_DOMAIN using (B_ACTION.B_DOMAIN, B_DOMAIN.REFERENCE)
where B_ACTION.PROC='N' and B_ACTION.REFERENCE not in (select distinct B_ACTION from @B_ACTROL)
order by "Czynność"

