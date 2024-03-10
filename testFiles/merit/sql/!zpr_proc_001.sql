:!UTF-8
select distinct 0 as LP, B_PROC.SYMBOL as "Proces", B_PROC.VER as "Wersja", B_PROC.NAME as "Nazwa",
            B_PROC.ACTIVE as "Aktywny", B_PROC.ACCEPTED as "Zaakceptowany", FIRMA.SYMBOL as "Firma"
from B_PREL join B_ELE using (B_PREL.B_ELE, B_ELE.REFERENCE)
         join B_PROC using (B_PREL.B_PROC, B_PROC.REFERENCE)
         join FIRMA using (B_PROC.FIRMA, FIRMA.REFERENCE)
where B_PROC.MICRO='N' and (':_d'='W' or B_PROC.ACTIVE='T') and B_ELE.SYMBOL=':_a' 
            and (':_b'='W' or B_PROC.FIRMA=:_c)
order by "Proces", "Wersja", "Firma"
