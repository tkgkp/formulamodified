:!UTF-8

select
   0 as LP,
   STU.KOD Stat,
   UM.SYM Symbol,
   FAS.NAZ SposobFakt,
   to_string(UM.OD) Od_daty,
   to_string(UM.DO) Do_daty,
   KH.KOD Kod_KH,
   KH.SKR Kontrahent,
   MIA.NAZ Miasto,
   UL.UL Ulica,
   POS.NR Numer,
   TAR.KOD Cennik,
   USL.KOD R_usl,
   UPSYS.KOD S_usl,
   WAL.KOD Wal,
   UP.F wg_h,
   UP.TFAK wg_r,
   HN.KOD Harmonog,
   MJ.KTM Usl_harm,
   MJ.N Naz_harm,
   UP.IL Il_harm,
   JM_MJ.KOD Jm_harm,
   M_D.KTM Usl_dod,
   M_D.N Naz_dod,
   UP.ILD Il_dod,
   JM_M_D.KOD Jm_dod,
   to_string(UP.PRD) Proc_usl,
   M.KTM Usl_rycz,
   M.N Naz_rycz,
   UP.ILM Il_rycz,
   JM_M.KOD Jm_rycz,
   to_string(UP.WSP) Wsp_rycz,
   DM.KTM Usl_dodRycz,
   DM.N Naz_dodRycz,
   UP.DILM Il_dodRycz,
   JM_DM.KOD Jm_dodRycz,
   to_string(UP.DPR) Wsp_dodRycz
from
   UP
   left join UM using (UP.UM, UM.REFERENCE)
   left join STU using (UM.STU, STU.REFERENCE)
   left join FAS using (UM.FAS, FAS.REFERENCE)
   left join KH using (UM.KH, KH.REFERENCE)
   left join USL using (UP.USL, USL.REFERENCE)
   left join TAR using (UP.TAR, TAR.REFERENCE)
   left join SLO as WAL using (UP.WAL, WAL.REFERENCE)
   left join HN using (UP.H, HN.REFERENCE)
   left join M as MJ using (UP.MJ, MJ.REFERENCE)
   left join M as M_D using (UP.M_D, M_D.REFERENCE)
   left join M using (UP.M, M.REFERENCE)
   left join M as DM using (UP.DM, DM.REFERENCE)
   left join JM as JM_MJ using (MJ.J, JM_MJ.REFERENCE)
   left join JM as JM_M_D using (M_D.J, JM_M_D.REFERENCE)
   left join JM as JM_M using (M.J, JM_M.REFERENCE)
   left join JM as JM_DM using (DM.J, JM_DM.REFERENCE)
   left join UPSYS using (UP.UPSYS, UPSYS.REFERENCE)
   left join POS using (UP.POS, POS.REFERENCE)
   left join MIA using (POS.MIA, MIA.REFERENCE)
   left join UL using (POS.UL, UL.REFERENCE)
where
   UM.A='N'
order by
   2,3