:!UTF-8

select
   0 as LP,
   ZLE.CZUM Czy_z_UM,
   ZLE.SYM Symbol,
   KH.KOD Kod_KH,
   KH.SKR Kontrahent,
   MIA.NAZ Miasto,
   UL.UL Ulica,
   POS.NR Numer,
   TAR.KOD Cennik,
   USL.KOD R_usl,
   ZLP.RODZ Rodzaj,
   WAL.KOD Wal,
   to_string(ZLP.DZP) Zgl_podst,
   to_string(ZLP.DP) Data_podst,
   to_string(ZLP.DZ) Zgl_wykon,
   to_string(ZLP.DW) Data_wykon,
   ZLE.TFAK wg_r,
   MJ.KTM Usl_podst,
   MJ.N Naz_podst,
   ZLP.IL Il_podst,
   JM_MJ.KOD Jm_podst,
   M_D.KTM Usl_dod,
   M_D.N Naz_dod,
   ZLP.ILD Il_dod,
   JM_M_D.KOD Jm_dod,
   to_string(ZLP.PRD) Proc_usl
from
   ZLP
   join ZLE using (ZLP.ZLE, ZLE.REFERENCE)
   left join KH using (ZLE.KH, KH.REFERENCE)
   left join USL using (ZLE.USL, USL.REFERENCE)
   left join TAR using (ZLE.TAR, TAR.REFERENCE)
   left join SLO as WAL using (ZLP.WAL, WAL.REFERENCE)
   left join M as MJ using (ZLP.MJ, MJ.REFERENCE)
   left join M as M_D using (ZLP.M_D, M_D.REFERENCE)
   left join JM as JM_MJ using (MJ.J, JM_MJ.REFERENCE)
   left join JM as JM_M_D using (M_D.J, JM_M_D.REFERENCE)
   left join POS using (ZLE.POS, POS.REFERENCE)
   left join MIA using (POS.MIA, MIA.REFERENCE)
   left join UL using (POS.UL, UL.REFERENCE)
order by
   2,3