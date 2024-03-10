:!UTF-8
proc kdr_o
desc
   Opisy skladnikow KZ,KP,KU
end desc

params
end params

formula
_kztmpc:=KZ.fld_num;
_kptmpc:=KP.fld_num;
_kutmpc:=KU.fld_num;
_tmpcsum:=_kztmpc+_kptmpc+_kutmpc;

_ZLEPEK:=tab_tmp(1,'TABELA','STRING[5]','Tabela','NAZWA_P','STRING[10]','Nazwa pola','OPIS','STRING[255]','Opis');

{! _ala :=1 .. _tmpcsum |!
  {? _ala <= KZ.fld_num ||
   _ZLEPEK.TABELA:='KZ';
   _ZLEPEK.NAZWA_P:=KZ.fld_acr(_ala);
   _ZLEPEK.OPIS:=KZ.fld_comm(_ala);
   _ZLEPEK.add
  ?};
  {? _ala > KZ.fld_num & _ala <= (KZ.fld_num+KP.fld_num) ||
   _ZLEPEK.TABELA:='KP';
   _ZLEPEK.NAZWA_P:=KP.fld_acr(_ala-KZ.fld_num);
   _ZLEPEK.OPIS:=KP.fld_comm(_ala-KZ.fld_num);
   _ZLEPEK.add
  ?};
  {? _ala > KZ.fld_num+KP.fld_num & _ala <= (KZ.fld_num+KP.fld_num+KU.fld_num) ||
   _ZLEPEK.TABELA:='KU';
   _ZLEPEK.NAZWA_P:=KU.fld_acr(_ala-(KZ.fld_num+KP.fld_num));
   _ZLEPEK.OPIS:=KU.fld_comm(_ala-(KZ.fld_num+KP.fld_num));
   _ZLEPEK.add
  ?}
!}
end formula

sql
select
'     ' TABELA,
'          ' NAZWA_P,
'                                                                                                                                                                                                                                                        ' OPIS
from syslog where 2 = 1
end sql

formula
{? _ZLEPEK.first()
|| {!
   |? :RS.TABELA:=_ZLEPEK.TABELA;
      :RS.NAZWA_P:=_ZLEPEK.NAZWA_P;
      :RS.OPIS:=_ZLEPEK.OPIS;
      :RS.add();
      _ZLEPEK.next()
   !}
?};
obj_del(_ZLEPEK)
end formula

end proc


proc kdr_kz
desc
   Dane KZ i KU
end desc

params
end params

formula
end formula

sql
select
   OSOBA.NAZWISKO || ' ' || OSOBA.PIERWSZE as 'NAZWISKO I IMIE',
   UD_SKL.SYMBOL as 'WYDZIAL',
   STN.ST as 'STANOWISKO',
   CASE WHEN KZ.M<10  THEN '0' || to_string(KZ.M)  ELSE to_string(KZ.M)  END as 'MIESIAC',
   KZ.R as 'ROK',
   P.ZA as 'ZATRUDNIONY',
   OSOBA.REFERENCE OSOBA,
   KZ.*
from KZ
   join P using (KZ.P,P.REFERENCE)
   join OSOBA
   left join UD_SKL using (P.WYDZIAL,UD_SKL.REFERENCE)
   left join KU using (KU.OSOBA,OSOBA.REFERENCE)
   left join STN using (P.ST,STN.REFERENCE)
where
   KZ.R>=2018 and KU.R>=2019 and
   KZ.R = KU.R and
   KZ.M = KU.M
order by 
   5,4,1,3,2
end sql

formula
end formula

end proc


proc kdr_ku
desc
   Dane KU
end desc

params
end params

formula
end formula

sql
select
   KU.OSOBA,
   CASE WHEN KU.M<10  THEN '0' || to_string(KU.M)  ELSE to_string(KU.M)  END as 'MIESIAC',
   KU.R as 'ROK',
   KU.*
from KU
left join OSOBA using (KU.OSOBA,OSOBA.REFERENCE)
where
   KU.R>=2019
order by 
   3,2,1
end sql

formula
end formula

end proc


proc kdr_kp
desc
   Dane KP
end desc

params
end params

formula
end formula

sql
select
   CASE WHEN KP.M<10  THEN '0' || to_string(KP.M)  ELSE to_string(KP.M)  END as 'MIESIAC',
   KP.R as 'ROK',
   KP.*
from KP
where
   KP.R>=2019
order by 
   3,2,1
end sql

formula
end formula

end proc


proc kdr_ls
desc
   Dane LS
end desc

params
end params

formula
end formula

sql
select
   CASE WHEN O.M<10  THEN '0' || to_string(O.M)  ELSE to_string(O.M)  END as 'MIESIAC',
   O.R as ROK,
   O.M,
   O.LT as LISTA,
   R.RN,
   R.RT,
   LS.P,
   sum(LS.KW) as KW
from @LS
   left join @O using (LS.O,O.REFERENCE)
   left join R using (LS.RB,R.REFERENCE)
where
   O.R>=2019
group by
  O.LT,LS.P,O.R,O.M,R.RN,R.RT
order by 
   6,2,1
end sql

formula
end formula

end proc