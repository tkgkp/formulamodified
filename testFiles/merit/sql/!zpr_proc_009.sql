:!UTF-8
select 0 as LP, B_ROLE.NAME as "Rola", USERS.KOD as "Użytkownik", FIRMA.SYMBOL as "Firma",
            B_ELE.SYMBOL as "Czynność",  B_ACTION.NAME as "Nazwa czynności",
            B_DOMAIN.SYMBOL as "Obszar", B_ACTION.PROC as "Procesowa"
from @B_ACTROL join @B_ACTION using (B_ACTROL.B_ACTION, B_ACTION.REFERENCE)
           join B_ELE using (B_ACTION.B_ELE, B_ELE.REFERENCE)
           join B_DOMAIN using (B_ACTION.B_DOMAIN, B_DOMAIN.REFERENCE) 
           join B_ROLE using (B_ACTROL.B_ROLE, B_ROLE.REFERENCE)
           join B_USRROL using (B_USRROL.B_ROLE, B_ROLE.REFERENCE)
           join USERS using (B_USRROL.USERS, USERS.REFERENCE)
           join FIRMA using (B_ROLE.FIRMA, FIRMA.REFERENCE)
where ':_a'='W' or B_ROLE.FIRMA=:_b
order by "Rola", "Firma", "Użytkownik", "Czynność"
