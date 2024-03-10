:!UTF-8
select 0 as 
 LP,
 USERS.DANE as Operator,
 ND.D as Data, 
 MG.SYM as Magazyn,
 TYPYDOK.T as Typ,
 count(DISTINCT ND.REFERENCE) Dokumentów,
 count(DISTINCT DK.REFERENCE) Pozycji,
 KH.SKR as Kontrahent,
 ND.O as Opis,
case when position('@' IN to_string(ND.O))>0 then substr(to_string(ND.O), position('@' IN to_string(ND.O))+1, CHARACTER_LENGTH(to_string(ND.O))-position('@' IN to_string(ND.O)) ) else '' end Ilosc_palet,
KK.SYM as Symbol_Konta,
KK.NAZWA as Nazwa_Konta,
ND.WAR as Wartosc_dokumentu,
SLO.TR as Magazynier
from @DK
   left join @ND using (DK.N,ND.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join USERS using (ND.US,USERS.REFERENCE) 
   left join KH using (ND.KH, KH.REFERENCE)
   left join KK using (ND.KK, KK.REFERENCE)
   left join SLO using (ND.QMAGAZ,SLO.reference)
where ND.D>to_date(:_a) and ND.D<=to_date(:_b) and ND.Z='T' and ( USERS.DANE like '%:_c%' or ':_c'='') and (ND.KH is not null)
group by USERS.DANE,ND.D, MG.SYM,TYPYDOK.T,KH.SKR,ND.O,KK.SYM,KK.NAZWA,ND.WAR,SLO.TR
order by 2,3,4,5

union all
select 0 as 
 LP,
 USERS.DANE as Operator,
 ND.D as Data, 
 MG.SYM as Magazyn,
 TYPYDOK.T as Typ,
 count(DISTINCT ND.REFERENCE) Dokumentów,
 count(DISTINCT DK.REFERENCE) Pozycji,
 cast(null as STRING_TYPE) as Kontrahent,
 ND.O as Opis,
case when position('@' IN to_string(ND.O))>0 then substr(to_string(ND.O), position('@' IN to_string(ND.O))+1, CHARACTER_LENGTH(to_string(ND.O))-position('@' IN to_string(ND.O)) ) else '' end Ilosc_palet,
KK.SYM as Symbol_Konta,
KK.NAZWA as Nazwa_Konta,
ND.WAR as Wartosc_dokumentu,
SLO.TR as Magazynier
from @DK
   left join @ND using (DK.N,ND.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join USERS using (ND.US,USERS.REFERENCE) 
   left join KH using (ND.KH, KH.REFERENCE)
   left join KK using (ND.KK, KK.REFERENCE)
  left join SLO using (ND.QMAGAZ,SLO.reference)
where ND.D>to_date(:_a) and ND.D<=to_date(:_b) and ND.Z='T' and ( USERS.DANE like '%:_c%' or ':_c'='') and (ND.KH is null)
group by USERS.DANE,ND.D, MG.SYM,TYPYDOK.T,ND.O,KK.SYM,KK.NAZWA,ND.WAR,SLO.TR
order by 2,3,4,5
