:!UTF-8
proc stan_new
desc
   Stany magazynowe
end desc

params
end params

formula
end formula

sql
select
 M.A AKTYWNY,
 M.RODZ TYP,
 M.KTM KTM,
 M.N NAZWA,
 cast(NULL as REAL_TYPE) STAN,
 cast(NULL as REAL_TYPE) W_DRODZE,
 cast(NULL as REAL_TYPE) W_DRODZP,
 cast(NULL as REAL_TYPE) ZAMOWION,
 cast(NULL as REAL_TYPE) W_WYDAN,
 cast(NULL as REAL_TYPE) W_PRZYJ,
 cast(NULL as REAL_TYPE) NIEZGODNE,
 cast(NULL as REAL_TYPE) ZAM_SPZ,
 JM.KOD JM,
 KH.NAZ PROD
from M
 left join JM using(M.J, JM.REFERENCE)
 left join MDOST using(MDOST.M, M.REFERENCE)
 left join KH using(MDOST.KH, KH.REFERENCE)
where M.A='T'
order by 3
end sql

formula
ST.ODDZ:='w';
exec('prc_new','qjoko_prc',:RS)
end formula

end proc
