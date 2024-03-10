:!UTF-8
select distinct 0 as LP, B_PROC.SYMBOL as "Proces", B_PROC.VER as "Wersja", B_PROC.NAME as "Nazwa",
            B_PROC.ACTIVE as "Aktywny", B_PROC.ACCEPTED as "Zaakceptowany",
            B_PREL.ICONFILE as "Ikona elementu startowego", FIRMA.SYMBOL as "Firma"	
from @B_PREL join  B_PROC using (B_PREL.B_PROC, B_PROC.REFERENCE)
         join B_ELE using (B_PREL.B_ELE, B_ELE.REFERENCE)
         join FIRMA using (B_PROC.FIRMA, FIRMA.REFERENCE)
where B_PREL.START='T' and B_PROC.MICRO='N'
            and B_ELE.SYMBOL='Zdarzenie startowe - nieokreślone'
            and B_PREL.ICONFILE not in
                (SELECT B_ACTION.ICON FROM @B_ACTION WHERE B_ACTION.PROC='T' and B_ACTION.ICON<>'')
            and (':_a'='W' or B_PROC.FIRMA=:_b) and (':_c'='W' or B_PROC.ACTIVE='T')
order by "Proces", "Wersja", "Firma"