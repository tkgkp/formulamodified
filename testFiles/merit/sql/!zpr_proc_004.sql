:!UTF-8
select distinct 0 as LP, B_PROC.SYMBOL as "Proces", B_PROC.VER as "Wersja", B_PROC.NAME as "Nazwa",
            B_PROC.ACTIVE as "Aktywny", B_PROC.ACCEPTED as "Zaakceptowany",
            B_ACTION.UID as "Czynność", B_ACTION.NAME as "Nazwa czynności",
            FIRMA.SYMBOL as "Firma"
from @B_PREL join  B_PROC using (B_PREL.B_PROC, B_PROC.REFERENCE)
         join B_ELE  using (B_PREL.B_ELE, B_ELE.REFERENCE)
         join B_ACTION using (B_ELE.REFERENCE, B_ACTION.B_ELE)
         join FIRMA using (B_PROC.FIRMA, FIRMA.REFERENCE)
where B_PROC.MICRO='N' and B_ELE.CLASS='B_ACTION' and (':_a'='W' or B_PROC.FIRMA=:_b)
            and (':_c'='W' or B_PROC.ACTIVE='T')
order by "Proces", "Wersja", "Firma", "Czynność"
