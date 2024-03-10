:!UTF-8
select distinct 0 as LP, B_ELE.SYMBOL as "Czynność", B_ACTION.NAME as "Nazwa czynności",
            B_DOMAIN.SYMBOL as "Obszar", B_ACTION.ICON as "Ikona"
from @B_ACTION join B_ELE using (B_ACTION.B_ELE, B_ELE.REFERENCE)
          join  B_DOMAIN using (B_ACTION.B_DOMAIN, B_DOMAIN.REFERENCE)
          join  B_PORT using ( B_PORT.B_ELE, B_ELE.REFERENCE)	
where B_ACTION.PROC='T' and B_ACTION.ICON=''
           and B_ELE.REFERENCE  not in (select distinct B_ELE  from @B_PORT where KIND='IN' and REQUIRED='T' )
order by "Czynność"
