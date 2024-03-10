:!UTF-8
select 0 as LP, B_ACTION.UID as "Czynność", B_ACTION.NAME as "Nazwa czynności",
            B_DOMAIN.SYMBOL as "Obszar"
from @B_ACTION join B_ELE using (B_ACTION.B_ELE, B_ELE.REFERENCE)
         join B_DOMAIN using (B_ACTION.B_DOMAIN, B_DOMAIN.REFERENCE)
where B_ACTION.PROC='T'
            and B_ACTION.B_ELE not in
             (select distinct B_PREL.B_ELE
              from @B_PREL join B_PROC using (B_PREL.B_PROC, B_PROC.REFERENCE)
              where B_PROC.MICRO='N')
order by "Czynność"

