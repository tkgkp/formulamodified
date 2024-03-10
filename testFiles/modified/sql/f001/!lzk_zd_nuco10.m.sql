:!UTF-8
select
0 as LP,
ND.D as Data,
ND.SYM as Symbol,
TYPYDOK.T as Typ,
KH.KOD as KodK,
KH.NAZ as NazwaK,
M.KTM as Indeks,
M.N as Nazwa,
DK.IL as Ilosc,
JM.KOD as JM,
DK.SCEAN as IdentyfikatorDostawy
from
@DK
join @ND using (DK.N,ND.reference)
join TYPYDOK using (ND.TYP,TYPYDOK.reference)
join KH using (ND.KH,KH.reference)
join M using (DK.M,M.reference)
join JM using (M.J,JM.reference)
where
TYPYDOK.T IN VALUES ('MBO'),('PZ'),('IMP'),('WNT')
and ND.D between to_date(:_a) and to_date(:_b)
and ( M.KTM like '04%' or M.KTM like '07%' )

UNION ALL

select
0 as LP,
ND.D as Data,
ND.SYM as Symbol,
TYPYDOK.T as Typ,
MG.SYM as KodK,
MG.NAZ as NazwaK,
M.KTM as Indeks,
M.N as Nazwa,
DK.IL as Ilosc,
JM.KOD as JM,
DK.SCEAN as IdentyfikatorDostawy
from
@DK
join @ND using (DK.N,ND.reference)
join TYPYDOK using (ND.TYP,TYPYDOK.reference)
join MG using (ND.MAG,MG.reference)
join M using (DK.M,M.reference)
join JM using (M.J,JM.reference)
where
TYPYDOK.T IN VALUES ('MP'),('RWZL')
AND ND.D >= to_date(:_a)
AND DK.SCEAN IN (
SELECT DK.SCEAN
FROM
@DK
join @ND using (DK.N,ND.reference)
join TYPYDOK using (ND.TYP,TYPYDOK.reference)
join M using (DK.M,M.reference)
WHERE
ND.D between to_date(:_a) and to_date(:_b)
and TYPYDOK.T IN VALUES ('MBO'),('PZ'),('IMP'),('WNT')
and (KTM like '04%' or M.KTM like '07%')
group by DK.SCEAN
order by DK.SCEAN
)
order by
Indeks,Nazwa,IdentyfikatorDostawy,Data


