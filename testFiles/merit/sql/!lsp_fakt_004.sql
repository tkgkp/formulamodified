:!UTF-8
select
   0 as LP,
   KH.KOD KontrKod,
   KH.NAZ KontrNaz,
   KH.MIASTO KontrMiasto,
   KH.UL KontrUlica,
   M.KTM MatUslIndeks,
   sum(FAP.IL) Ilosc,
   sum(FAP.WWAL_P) Netto,
   sum(FAP.BWAL_P) Brutto,
   JM.KOD Jm
from
   @FAP
   join @FAKS using (FAP.FAKS, FAKS.REFERENCE)
   join KH using (FAKS.KH, KH.REFERENCE)
   join M using (FAP.M, M.REFERENCE)
   left join JM using (FAP.JM,JM.REFERENCE)
where
   (upper(KH.KOD) like upper('%:_a%') or ':_a'='')
   and (upper(KH.NAZ) like upper('%:_b%') or ':_b'='')
   and (upper(KH.MIASTO) like upper('%:_c%')  or ':_c'='')
   and (upper(KH.UL) like upper('%:_d%')  or ':_d'='')
   and (upper(KH.NIP) like upper('%:_e%') or  ':_e'='')
   and FAKS.ODDZ = ':_f'
   and (FAKS.DW>= to_date(:_g) or to_date(:_g) is null)
   and (FAKS.DW<= to_date(:_h) or to_date(:_h) is null)
   and :_i
   and FAKS.SZ='S'
   and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
   and :_j
group by
   KH.KOD, KH.NAZ, KH.MIASTO, KH.UL, M.KTM, JM.KOD
order by
   2

--Sign Version 2.0 jowisz:1045 2023/08/23 14:35:05 8f5da48544083bb65d64acd64666014e5fdc6340b27a6bb79fc2579e6ae0f63b2bc426ba6304a8b5171a207fedc36938795bf85666491572b58a252c8d18324bc71c45d8371c6c5c26dca319c563d59228605c91928296b82379bb039b89bf8f9907c9de76da51f5bd4aade772c901ffb8a4bf9f4f9c65198a3a46ba820c684a
