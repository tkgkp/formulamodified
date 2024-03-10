:!UTF-8
select 
0 as LP,
SC.D as "Data dostawy",
SC.SCEAN as "Identyfikator dostawy",
ND.D as "Data dokumentu",
CAST(ND.D as REAL_TYPE)-CAST(SC.D as REAL_TYPE) as "Dni po dostawie",
TYPYDOK.T as "Typ dokumentu",
M.KTM Kod,
M.N Nazwa,
DK.IL as "Ilosc na dokumencie",
DK.WAR "Wartosc na dokumencie",
JM.KOD Jm
from @SC
   left join @DK using (SC.SCEAN,DK.SCEAN)
   left join M using (DK.M,M.REFERENCE)
   left join JM using (M.J,JM.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where 
MG.SYM IN VALUES ('SUR'), ('SUR2'), ('XSUR1'), ('XSUR2') and SC.A='T' and SC.D between to_date(:_b) and to_date(:_c) and ND.Z='T'
and TYPYDOK.T IN VALUES ('PZ'), ('IMP'), ('WNT')
and ND.D >= SC.D
Group by SC.SCEAN, TYPYDOK.T, SC.D, M.KTM, M.N, JM.KOD, DK.IL, DK.WAR, CAST(ND.D as REAL_TYPE)-CAST(SC.D as REAL_TYPE),ND.D
UNION
select 
0 as LP,
TO_DATE('0000/00/00') as "Data dostawy",
SC.SCEAN as "Identyfikator dostawy",
MIN(ND.D) as "Data dokumentu",
CAST(ND.D as REAL_TYPE)-CAST(SC.D as REAL_TYPE) as "Dni po dostawie",
TYPYDOK.T as "Typ dokumentu",
M.KTM Kod,
M.N Nazwa,
DK.IL as "Ilosc na dokumencie",
DK.WAR "Wartosc na dokumencie",
JM.KOD Jm
from @SC
   left join @DK using (SC.SCEAN,DK.SCEAN)
   left join M using (DK.M,M.REFERENCE)
   left join JM using (M.J,JM.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where 
MG.SYM IN VALUES ('MSU'), ('MMO') and SC.A='T' and ND.D between to_date(:_b) and to_date(:_c) and ND.Z='T'
and TYPYDOK.T IN VALUES ('RWZL')
and ND.D >= SC.D
Group by SC.SCEAN, TYPYDOK.T, SC.D, M.KTM, M.N, JM.KOD, DK.IL, DK.WAR, CAST(ND.D as REAL_TYPE)-CAST(SC.D as REAL_TYPE),ND.D

Order by Kod, Nazwa, "Data dokumentu", "Data dostawy"
