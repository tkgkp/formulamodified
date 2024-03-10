:!UTF-8
proc rozl
desc
   Dane dla wydruku "Rozliczenie okresu"
end desc

params
   INST:=0 INTEGER
   SYSTEM:='RCP' STRING[8]
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','okrrozl',:SYSTEM) ?}
end formula

sql
   select
      substr(WARTOSC,1, 150)  F_NAZWA,
      substr(WARTOSC,1, 20)   MIEJSCE,
      substr(WARTOSC,1, 10)   DATA,
      substr(WARTOSC,1, 60)   F_ULICA,
      substr(WARTOSC,1, 37)   F_POCZTA,
      substr(WARTOSC,1, 16)   PRACOWN,
      substr(WARTOSC,1,30)    NAZWISKO,
      substr(WARTOSC,1,20)    IMIE,
      substr(WARTOSC,1,20)    DRUGIEIM,
      ' '                     PLEC,
      ' '                     ZATRUDN,
      substr(WARTOSC,1,20)    D_ZATR,
      substr(WARTOSC,1,9)     TEC,

      substr(WARTOSC,1,20)    OKR_NAZ,
      substr(WARTOSC,1,30)    OKR_OD,
      substr(WARTOSC,1,30)    OKR_DO,
      substr(WARTOSC,1,10)    OKR_OD1,
      substr(WARTOSC,1,10)    OKR_DO1,
      substr(WARTOSC,1,6)     OKR_WYM,

      substr(WARTOSC,1,6)     ROZ_NORM,
      substr(WARTOSC,1,6)     ROZ_PRZE,
      substr(WARTOSC,1,6)     ROZ_NIED,
      substr(WARTOSC,1,6)     ROZ_NADM,
      substr(WARTOSC,1,6)     ROZ_NIEO,
      ' '                     ROZ_NN,

      substr(WARTOSC,1,6)     SZ_PRACA,
      substr(WARTOSC,1,6)     SZ_NADM,
      substr(WARTOSC,1,6)     SZ_NIEO,
      substr(WARTOSC,1,6)     SZ_50,
      substr(WARTOSC,1,6)     SZ_100,
      substr(WARTOSC,1,6)     SZ_ODB,
      ' '                     SZ_JOD
   from   XR_PAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST)
end formula

end proc

proc rozodb
desc
   Odbiory godzin dla "Rozliczenie okresu"
end desc

params
   P:='' STRING[16]
   OD:='2005-05-01' STRING[10]
   DO:='2005-06-30' STRING[10]
end params

sql
   select
      ' ' C1,
      substr(WARTOSC,1,15) DATA,
      substr(WARTOSC,1,15) GODZINY,
      substr(WARTOSC,1,20) RODZ,
      substr(WARTOSC,1,15) DATAO,
      substr(WARTOSC,1,30) W
   from XR_PAR where 0=1
end sql

formula
   _Q:=sql('
      select   R_WYK.DN DN, R_WYK.G G, R_WYK.DO DO, R_WYK.W W, R.RT RT
      from     R_WYK join R
      where    R_WYK.P=\':_a\' and R_WYK.DN between to_date(\':_b\') and to_date(\':_c\')
      order by 3, 1
   ',:P,:OD, :DO);
   {? _Q.first ||
      :RS.DATA:='Data_nadgodzin';
      :RS.GODZINY:='Ilość_godzin';
      :RS.RODZ:='Typ_godzin';
      :RS.DATAO:='Data_odbioru';
      :RS.W:='Odbiór_godzin_na_wniosek';
      :RS.add();
      {!|?
         :RS.DATA:=_Q.DN$1;
         :RS.GODZINY:=_Q.G$1;
         :RS.DATAO:=_Q.DO$1;
         :RS.W:={? _Q.W='F' || 'pracodawcy' || 'pracownika' ?};
         :RS.RODZ:=_Q.RT;
         :RS.add();
         _Q.next()
      !}
   ?};
   obj_del(_Q)
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 3c8d8727b37d033958da8d607421da81ced38b92533e00d7b554683d04db2b1263327361e0b8934286d7fba6b593f88c3faf6ce5aaecb645d7267d0ccee2194928cae178e3cf24a318bf8ecda9532fd7931156ab3d0f1e98db1c31b6f88d9bfadc13d74e3b39c32eac28647a5f30da65a51589460e605bdeda9d37898eff1349
