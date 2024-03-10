:!UTF-8
select   OSOBA, TTUB, min(PREM) PREM, min(STNP) STNP,
         sum(POD_ER) POD_ER,
         sum(POD_CW) POD_CW,
         sum(POD_CHOR) POD_CHOR,
         sum(POD_KC) POD_KC,
         sum(FEP) FEP,
         sum(FRP) FRP,
         sum(FC) FC,
         sum(KC) KC,
         sum(FEZ) FEZ,
         sum(FRZ) FRZ,
         sum(FW) FW,
         sum(PPK) PPK

from     :_a

group by OSOBA, TTUB