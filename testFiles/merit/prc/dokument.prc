:!UTF-8
proc dekrety
desc
dekrety dla maski kont i w zakresie dat aktywnego roku dla waluty narodowej
end desc

params
maskakon:= '' STRING[35], Maska konta
oddzial:='%' STRING[8], Jednostka księgowa
dataod DATE, Od daty
datado DATE, Do daty
zaksieg:= '%' STRING[1], Zaksięgowany
ROKR_ODP:='%' STRING[8], REFERENCE okresu od dla tabeli POZ
ROKR_DOP:='%' STRING[9], REFERENCE okresu do dla tabeli POZ
ROKR_ODD:='%' STRING[8], REFERENCE okresu od dla tabeli DOK
ROKR_DOD:='%' STRING[9], REFERENCE okresu do dla tabeli DOK
KURS:=1.0     REAL     , Kurs waluty kwot
end params

sql
select
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
POZ.POZ as POZYCJA,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.DTO as D_DOKUM,
POZ.KON as KONTO,
case POZ.STR when 'Wn' then POZ.SUM end as WN,
case POZ.STR when 'Ma' then POZ.SUM end as MA,
POZ.KURS as KURS,
SLO.KOD as WALUTA,
case POZ.STR when 'Wn' then POZ.SUMW end as WWN,
case POZ.STR when 'Ma' then POZ.SUMW end as WMA,
POZ.OP as TR,
DOK.NK as SYMBOL,
SLO.KOD as WALUTA,
POZ.SUMW as KWOTA_W,
POZ.KURS as KURS,
POZ.A as AKC,
POZ.ZP as ZP,
POZ.ID as ID,
POZ.TID as TID,
POZ.DO as DO,
POZ.TP as TP,
POZ.reference as POZ_REF,
ODD.OD as ODDZIAL
from @POZ
join @DOK using (POZ.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (DOK.ODD,ODD.REFERENCE)
left join SLO using (POZ.WAL,SLO.REFERENCE)
where
POZ.reference between :ROKR_ODP AND :ROKR_DOP AND
DOK.reference between :ROKR_ODD AND :ROKR_DOD AND
POZ.ZP like :zaksieg AND
POZ.KON like :maskakon AND
DOK.DTW between :dataod and :datado AND
ODD.OD like :oddzial

order by
KONTO, D_ZAPKS, REJESTR, NR_W_REJ
end sql

formula
{? :KURS<>1 & :KURS<>0
|| :RS.prefix();
   {? :RS.first()
   || {! |?
         :RS.WN:=:RS.WN/:KURS;
         :RS.MA:=:RS.MA/:KURS;
         :RS.put();
         :RS.next()
      !}
   ?}
?}
end formula
end proc

proc dekretyw
desc
dekrety dla maski kont i w zakresie dat aktywnego roku dla waluty innej niż narodowa
end desc

params
maskakon:='' STRING[35], Maska konta
oddzial:='%' STRING[8], Jednostka księgowa
dataod DATE, Od daty
datado DATE, Do daty
zaksieg:='%' STRING[1], Zaksięgowany
swal STRING[8], Waluta bieżąca
ROKR_ODP:='%' STRING[8], REFERENCE okresu od dla tabeli POZ
ROKR_DOP:='%' STRING[9], REFERENCE okresu do dla tabeli POZ
ROKR_ODD:='%' STRING[8], REFERENCE okresu od dla tabeli DOK
ROKR_DOD:='%' STRING[9], REFERENCE okresu do dla tabeli DOK
KURS:=1.0     REAL     , Kurs waluty kwot
end params

sql
select
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
POZ.POZ as POZYCJA,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.DTO as D_DOKUM,
POZ.KON as KONTO,
case POZ.STR when 'Wn' then POZ.SUMW end as WN,
case POZ.STR when 'Ma' then POZ.SUMW end as MA,
POZ.KURS as KURS,
SLO.KOD as WALUTA,
case POZ.STR when 'Wn' then POZ.SUM end as WWN,
case POZ.STR when 'Ma' then POZ.SUM end as WMA,
POZ.OP as TR,
DOK.NK as SYMBOL,
SLO.KOD as WALUTA,
POZ.SUMW as KWOTA_W,
POZ.KURS as KURS,
POZ.A as AKC,
POZ.ZP as ZP,
POZ.ID as ID,
POZ.TID as TID,
POZ.DO as DO,
POZ.TP as TP,
POZ.reference as POZ_REF,
ODD.OD as ODDZIAL
from @POZ
join @DOK using (POZ.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (DOK.ODD,ODD.REFERENCE)
join SLO using (POZ.WAL,SLO.REFERENCE)
where
POZ.reference between :ROKR_ODP AND :ROKR_DOP AND
DOK.reference between :ROKR_ODD AND :ROKR_DOD AND
POZ.ZP like :zaksieg AND
POZ.KON like :maskakon AND
DOK.DTW between :dataod and :datado AND
SLO.KOD like :swal AND
ODD.OD like :oddzial

order by
KONTO, D_ZAPKS, REJESTR, NR_W_REJ
end sql

formula
{? :KURS<>1 & :KURS<>0
|| :RS.prefix();
   {? :RS.first()
   || {! |?
         :RS.WN:=:RS.WN/:KURS;
         :RS.MA:=:RS.MA/:KURS;
         :RS.put();
         :RS.next()
      !}
   ?}
?}
end formula
end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 45afd931229cde2de49bde29fbede85f387666f99d25747d5feb30a1915a86ab1366e613bcb9016bb9eba8699d2f6b541b579b31944ae89b24f3cf24ce67acd5c12811248fda01f500f1f2ab514435eb6a9aa01a4fb8a32ea1918ef60bd3ca390c3a007ba26e7af3079d654cf2f49e81186ea7da853c81735fdd849494b06d50
