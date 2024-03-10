:!UTF-8
select ZC_INFO.OSOBA OSOBA,
       ZC_INFO.DW INFODW,
       RH.DWY RHDWY,
       TTUB.KOD TTUB,
       PREM.KOD PREM,
       STNP.KOD STNP,
       CASE WHEN R.RN=753 THEN LS.KW ELSE 0 END POD_ER,
       CASE WHEN R.RN=754 THEN LS.KW ELSE 0 END POD_CW,
       CASE WHEN R.RN=756 THEN LS.KW ELSE 0 END POD_CHOR,
       CASE WHEN R.RN=791 THEN LS.KW ELSE 0 END POD_KC,
       CASE WHEN R.RN=765 THEN LS.KW ELSE 0 END FEP,
       CASE WHEN R.RN=766 THEN LS.KW ELSE 0 END FRP,
       CASE WHEN R.RN=767 THEN LS.KW ELSE 0 END FC,
       CASE WHEN R.RN=792 THEN LS.KW ELSE 0 END KC,
       CASE WHEN R.RN=958 THEN LS.KW ELSE 0 END FEZ,
       CASE WHEN R.RN=959 THEN LS.KW ELSE 0 END FRZ,
       CASE WHEN R.RN=960 THEN LS.KW ELSE 0 END FW,
       CASE WHEN R.RN=7088 OR R.RN=7089 THEN LS.KW ELSE 0 END PPK,
       CASE WHEN ZC_INFO.DW<to_date(:_c) THEN ZC_INFO.DW ELSE to_date(:_c) END ZCDW

from   @LS join R using(LS.RB,R.REFERENCE) join RH join O using (O.REFERENCE,RH.O) join
       ZC_INFO using(RH.ZC_INFO,ZC_INFO.REFERENCE) join
       S_ZUS TTUB using (ZC_INFO.TTUB,TTUB.REFERENCE) join
       S_ZUS PREM using (ZC_INFO.PREM,PREM.REFERENCE) join
       S_ZUS STNP using (ZC_INFO.STNP,STNP.REFERENCE)

where  LS.REFERENCE like ':_f%' and O.FIRMA=:_g and O.F_ZATR=':_e' and
       RH.R=:_a and RH.M=:_b and
       (ZC_INFO.ZUS='T' or ZC_INFO.FC='T' or ZC_INFO.FW='T') and
       R.RN in (753,754,756,791,765,766,767,792,958,959,960,7088,7089)

union all

select ZC_INFO.OSOBA OSOBA,
       ZC_INFO.DW INFODW,
       ZC_INFO.DW RHDWY,
       TTUB.KOD TTUB,
       PREM.KOD PREM,
       STNP.KOD STNP,
       0 POD_ER,
       0 POD_CW,
       0 POD_CHOR,
       0 POD_KC,
       0 FEP,
       0 FRP,
       0 FC,
       0 KC,
       0 FEZ,
       0 FRZ,
       0 FW,
       0 PPK,
       to_date(:_c) ZCDW

from   ZC_INFO join
       ZC using(ZC_INFO.ZC,ZC.REFERENCE) join
       P using(ZC.P,P.REFERENCE) join
       S_ZUS TTUB using (ZC_INFO.TTUB,TTUB.REFERENCE) join
       S_ZUS PREM using (ZC_INFO.PREM,PREM.REFERENCE) join
       S_ZUS STNP using (ZC_INFO.STNP,STNP.REFERENCE)

where  P.FIRMA=:_g and
       to_date(:_c)<=ZC_INFO.DW and ZC_INFO.DU<=to_date(:_d) and
       (ZC_INFO.ZUS='T' or ZC_INFO.FC='T' or ZC_INFO.FW='T')