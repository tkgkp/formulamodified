:!UTF-8
/* Wykaz kont uzywanych w sprawozdaniach finansowych */

select distinct
0 as LP,
ALG_PAR.P1 as KONTO,
GR_SIK.SKROT as GRUPA,
DEFW.KOD as WIERSZ,
GR_KOL.LP as KOLUMNA
from ALG_PAR
join GR_KOL using (ALG_PAR.GR_KOL,GR_KOL.REFERENCE)
join DEFW using (ALG_PAR.DEFW,DEFW.REFERENCE)
join GR_SIK using (DEFW.GRUPA,GR_SIK.REFERENCE)
join FORMULA using (ALG_PAR.FORMULA,FORMULA.REFERENCE)
join ROK_F using (ALG_PAR.ROK,ROK_F.REFERENCE)
where
ALG_PAR.P1<>'' and
(FORMULA.SKROT like '%SAL%' or FORMULA.SKROT like '%OBRO%' or
FORMULA.SKROT like '%BO%' or FORMULA.SKROT like '%ROZNI%' or
FORMULA.SKROT like '%ZM_STA%') and
ROK_F.KOD=:_a and
ALG_PAR.P1 like ':_b%'
order by
KONTO,GRUPA,WIERSZ,KOLUMNA

