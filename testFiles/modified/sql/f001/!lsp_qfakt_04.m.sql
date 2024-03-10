:!UTF-8
select 0 as LP, TYPYSP.T Typ,FAKS.DW Data_wyst,FAKS.D Data_sprz,KH.KOD Kontr,KH.NAZ,SLO.KOD Waluta,FAKS.NETW Netto_wal,FAKS.BRTW Brutto_wal,FAKS.NETTO Netto_pln,FAKS.BRUTTO Brutt_pln
from @FAKS
   left join TYPYSP using (FAKS.T,TYPYSP.REFERENCE)
   left join KH using (FAKS.KH,KH.REFERENCE)
   left join SLO using (FAKS.WAL,SLO.REFERENCE)
   left join STS using (FAKS.STS,STS.REFERENCE)
where FAKS.DW between to_date(:_a) and to_date(:_b) and FAKS.SZ='S' and STS.KOD=':_c' and (TYPYSP.T=':_e' or ':_e'='') and ( SLO.KOD=':_d' or ':_d'='') 
order by 2,3,4
