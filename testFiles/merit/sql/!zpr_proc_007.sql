:!UTF-8
select 0 as LP, B_PROC.SYMBOL as "Proces", B_PROC.VER as "Wersja", B_PROC.NAME as "Nazwa",
            B_PROC.ACTIVE as "Aktywny", B_PROC.ACCEPTED as "Zaakceptowany",
            FIRMA.SYMBOL as "Firma",  count(*) as "Instancje"
from @BI_PREL join @BI_PROC using(BI_PREL.BI_PROC, BI_PROC.REFERENCE) 
         join @B_PROC using(BI_PROC.B_PROC, B_PROC.REFERENCE)
         join @FIRMA using(B_PROC.FIRMA, FIRMA.reference)
where (':_a'='W' or B_PROC.FIRMA=:_b) and (':_c'='W' or B_PROC.ACTIVE='T')
group by B_PROC.SYMBOL, B_PROC.VER, B_PROC.NAME, B_PROC.ACTIVE, B_PROC.ACCEPTED,
                 FIRMA.SYMBOL
order by "Instancje" desc, "Proces", "Wersja", "Firma"
