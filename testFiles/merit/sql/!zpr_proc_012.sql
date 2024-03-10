:!UTF-8
select 0 as LP, B_ROLE.NAME as "Rola", FIRMA.SYMBOL as "Firma",
            B_ELE.SYMBOL as "Czynność",  B_ACTION.NAME as "Nazwa czynności",
            B_DOMAIN.SYMBOL as "Obszar"
from @B_ACTROL join @B_ACTION using (B_ACTROL.B_ACTION, B_ACTION.REFERENCE)
           join B_ELE using (B_ACTION.B_ELE, B_ELE.REFERENCE)
           join B_DOMAIN using (B_ACTION.B_DOMAIN, B_DOMAIN.REFERENCE) 
           join B_ROLE using (B_ACTROL.B_ROLE, B_ROLE.REFERENCE)
           join FIRMA using (B_ROLE.FIRMA, FIRMA.REFERENCE)
where (':_a'='W' or B_ROLE.FIRMA=:_b) and B_ACTION.PROC = 'T' and B_ACTROL.PROCES <> 'T'
order by "Rola", "Firma", "Czynność"
