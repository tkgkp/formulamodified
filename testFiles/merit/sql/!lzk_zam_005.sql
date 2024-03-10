:!UTF-8
select 
 0 as LP, 
 KH.KOD as Kontr_Kod, 
 KH.SKR as Kontr_Skr, 
 KH.NAZ as Kontr_Naz, 
 KH.MIASTO as Kontr_Mia, 
 KH.KRAJ as Kontr_Kraj, 
 OBS.NAZ as Oszar_Sp, 
 ZD_NAG.SYM as Symbol, 
 ZD_NAG.DATA as Data_Zam, 
 ZD_NAG.DTPREAL as Plan_Tr,
 ZD_NAG.STAN as Stan, 
 M.KTM as Indeks, 
 M.N as Nazwa_Tow, 
 MGR.KOD as Gr_tow, 
 JM.KOD as Jm, 
 MG.SYM as Magazyn, 
 ZD_POZ.CENA as Cena, 
 ZD_POZ.IL_ZAM+ZD_POZ.IL_KOR as Il_Zam, 
 ZD_POZ.IL_ZRE as Il_Zre, 
 ZD_POZ.IL_POZ as Il_Poz,
 ZD_NAG.STAT_REJ as StatRej

from 
 @ZD_POZ 
 join @ZD_NAG using (ZD_POZ.ZD_NAG,ZD_NAG.reference) 
 left join KH using (ZD_NAG.KH,KH.reference) 
 left join GRKH using (KH.GRKH,GRKH.REFERENCE)
 left join OBS using (KH.OBS, OBS.REFERENCE) 
 left join M using (ZD_POZ.M,M.reference) 
 left join MGR using(M.MGR, MGR.REFERENCE) 
 left join JM using (ZD_POZ.JM,JM.reference) 
 left join MG using (ZD_NAG.MG, MG.REFERENCE)
 join TYPYZAM using(ZD_NAG.T, TYPYZAM.reference)


where
 ((ZD_NAG.DATA between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null ))
 and :_c
 and :_d
 and :_e
 and :_f
 and :_g
 and :_h
order by 
 Kontr_kod

