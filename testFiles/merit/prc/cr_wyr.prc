:!UTF-8
proc cr_wyr
desc
  Tabela dla potrzeb wydruku obroty wyroznikow (CR)
end desc

params
  OD_DATY      DATE,   Od daty
  DO_DATY      DATE,   Do daty
  ODD     STRING[8],  Jednostka księgowa
end params

sql
    
 select POW.KW POW_KW, SLO.KOD SLO_KOD, SLO.TR SLO_TR, SLU.NAZ SLU_NAZ, POZ.STR POZ_STR, REJ.NAZ REJ_NAZ,
  DOK_REJ.NAZ DREJ_NAZ, DOK.NK DOK_NK, POZ.POZ POZ_POZ, DOK.DTW DOK_DTW
  from  POW
    join SLO using(POW.SLO, SLO.REFERENCE)
    join SLUAPPL using(POW.SLU, SLUAPPL.REFERENCE)
    join POZ using(POW.POZ, POZ.REFERENCE)
    join SLU using(SLUAPPL.SLU, SLU.REFERENCE)
    join DOK using(POZ.DOK, DOK.REFERENCE)
    join ODD using(DOK.ODD, ODD.REFERENCE)
    join DOK_REJ using(DOK.DOK_REJ, DOK_REJ.REFERENCE)
    join REJ using(DOK_REJ.REJ, REJ.REFERENCE)
  where 
    DOK.DTW between :OD_DATY and :DO_DATY
    and (:ODD='' or ODD.OD=:ODD)
 order by SLU.NAZ

end sql

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 2a88d6e3c94541c49c56446309be4abca242847d6d57b7fa39c2c532e0ea10efb8f93f5185c801fbc47f3e9656d098190447107e5c10718ae37bb0f1222bb6af2b4d7862afdccf24f8440306e0a639082ab4081bc93e74694f21d5f13eb78b1db191feb42d1c29ea8331448562525faf59218bed55e7ae2bd630182ccdfcc7ce
