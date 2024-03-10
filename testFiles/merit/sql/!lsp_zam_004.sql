:!UTF-8
select
 0 as LP,
 KH.KOD as KontrKod,
 KH.SKR as KontrSkr,
 ZK_N.SYM as ZamSym,
 ZK_N.DP as ZamDataPrzyjecia,
 ZK_P.DT as PlanDataReal,
 M.KTM as MatIndeks,
 M.N as MatNaz,
 ZK_P.ILZ as IlZam,
 ZK_P.ILRB as IlZarez,
 ZK_P.ILP as IlPoz,
 Jedn_m.KOD as Jedn_m,
 Jedn_sp.KOD as Jedn_sp,
 SLO.KOD as Wal,
 ZK_P.CENA as Cena,
 ZK_P.CWAL as Cena_Wal,
 ZK_P.NETTO as Wartosc,
 ZK_P.NETTOW as War_Wal,
 M.KTM as MatUslIndeks,
 M.N as MatUslNaz,
 HAN.NAZ as Handlowiec,
 TYPYZAM.T as TypZam,
 ZK_N.STAT_REJ as StatRej
from
 @ZK_P
 join @ZK_N using (ZK_P.N,ZK_N.reference)
 join KH using (ZK_N.KH,KH.reference)
 left join GRKH using(KH.GRKH,GRKH.reference)
 join M using (ZK_P.M,M.reference)
 left join MGR using(M.MGR, MGR.REFERENCE) 
 left join JM as Jedn_m using (ZK_P.JM,Jedn_m.reference)
 left join JM as Jedn_sp using (ZK_P.J2,Jedn_sp.reference)
 left join SLO using (ZK_P.WAL,SLO.reference)
 left join HAN using (ZK_N.HAN,HAN.reference)
 join TYPYZAM using(ZK_N.T, TYPYZAM.reference)
where
 ((ZK_N.DP between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null ))
 and :_c
 and :_d
 and :_e
 and :_f
 and :_g
 and :_h
 and :_i
 and (ZK_P.A='A' or ZK_P.A='Z') and ZK_P.T='Z'
 and ZK_P.TOP = 1
order by
 KontrKod,ZamSym,ZamDataPrzyjecia,PlanDataReal

