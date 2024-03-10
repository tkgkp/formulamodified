:!UTF-8
select
   OS_N.OSOBA, R.RN, ZC_N.OD, ZC_N.DO, ZC_N.NK,
   KSW.KOD as SW, KCH.KOD as CH, ZC_N.KW,
   TTUB.KOD TTUB, PREM.KOD PREM, STNP.KOD STNP, 0 as DK

from
   ZC_N join
   RH using (ZC_N.RH, RH.REFERENCE) join
   R using (ZC_N.R, R.REFERENCE) join
   OS_N using (ZC_N.OS_N, OS_N.REFERENCE) join
   ZC using (RH.ZLE, ZC.REFERENCE) join
   S_ZUS TTUB using (ZC.TTUB,TTUB.REFERENCE) join
   S_ZUS PREM using (ZC.PREM,PREM.REFERENCE) join
   S_ZUS STNP using (ZC.STNP,STNP.REFERENCE) join
   S_ZUS as KSW using(ZC_N.KDSW,KSW.REFERENCE) left join
   S_ZUS as KCH using(OS_N.KDCH,KCH.REFERENCE)

where
   OS_N.FIRMA=:_c and RH.DWY<=to_date(:_b) and to_date(:_a)<=RH.DWY