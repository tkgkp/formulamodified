:!UTF-8
proc umpr
desc
   Dane dla wydruku "Umowa o pracę"
   Część 2 w procedurze umpr2
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWUMPR') ?}
end formula

sql
# UWAGA bufor tabeli wykorzystany prawie w calosci ze wzgledu na pola UZAS1, UZAS2
# W przyszłości można popracować nad długością pola F_LOGO
   select substr(WARTOSC,1,16)  H_UM_REF,
          substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1, 20) MIEJSCE,
          substr(WARTOSC,1, 10) DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1, 37) F_POCZTA,
          substr(WARTOSC,1, 20) F_REGON,
          substr(WARTOSC,1, 13) F_NIP,
          substr(WARTOSC,1, 30) F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1, 20) DATA_ZAW,
          substr(WARTOSC,1,150) F_OSREP,
          substr(WARTOSC,1,255) OSOBA,
          substr(WARTOSC,1, 11) PESEL,
          substr(WARTOSC,1,150) NACZAS,
          substr(WARTOSC,1,100) STANOW,
          substr(WARTOSC,1,255) WYDZIAL,
          substr(WARTOSC,1,100) WYMIAR,
          substr(WARTOSC,1,240) INNEWAR,
          substr(WARTOSC,1,150) GODZNADL,
          substr(WARTOSC,1, 25) ROZPRAC,
          substr(WARTOSC,1,  1) CZY_ZAP,
          substr(WARTOSC,1, 20) NR_UM,
          substr(WARTOSC,1,100) SW1,
          substr(WARTOSC,1,100) SW2,
          substr(WARTOSC,1,100) SW3,
          substr(WARTOSC,1,255) SW4,
          substr(WARTOSC,1,100) SW5,
          substr(WARTOSC,1,  1) PAT,
          substr(WARTOSC,1, 20) PAW,
          substr(WARTOSC,1,  1) OKR_NEW,
          substr(WARTOSC,1,255) UZAS1,
          substr(WARTOSC,1,255) UZAS2,
          substr(WARTOSC,1,100) KW_SL1,
          substr(WARTOSC,1,100) KW_SL2,
          substr(WARTOSC,1,100) KW_SL3,
          substr(WARTOSC,1,100) KW_SL4,
          substr(WARTOSC,1, 16) PRACA_ZD,
          substr(WARTOSC,1,  8) PRACA_ZW,
          substr(WARTOSC,1, 20) PRACA_DT,
          substr(WARTOSC,1, 1)  INNEW3
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWUMPR')
end formula

end proc


proc umpr2
desc
   Dane dla wydruku "Umowa o pracę cz. 2"
   Część 1 w procedurze umpr
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWUMPR') ?}
end formula

sql
   select substr(WARTOSC,1,16)  H_UM_REF,
          substr(WARTOSC,1,255) ZAM_OKR,
          substr(WARTOSC,1, 1)  PRZ_USPR,
          substr(WARTOSC,1, 20) PRACA_DO
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWUMPR')
end formula

end proc


proc uman
desc
   Dane dla wydruku "Aneks do umowy o pracę"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWUMAN') ?}
end formula

sql
   select substr(WARTOSC,1,16)  H_REF,
          substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1, 20) MIEJSCE,
          substr(WARTOSC,1, 10) DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1, 37) F_POCZTA,
          substr(WARTOSC,1, 20) F_REGON,
          substr(WARTOSC,1, 13) F_NIP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1, 23) DATA_ZAW,
          substr(WARTOSC,1, 13) DATA_UM,
          substr(WARTOSC,1, 20) NR_UM,
          substr(WARTOSC,1,150) F_OSREP,
          substr(WARTOSC,1,255) OSOBA,
          substr(WARTOSC,1, 11) PESEL,
          substr(WARTOSC,1,150) PPKT,
          substr(WARTOSC,1,100) STANOW,
          substr(WARTOSC,1,100) WYDZIAL,
          substr(WARTOSC,1,100) WYMIAR,
          substr(WARTOSC,1,240) INNEWAR,
          substr(WARTOSC,1,150) GODZNADL,
          substr(WARTOSC,1, 13) ROZPRAC,
          substr(WARTOSC,1, 13) ZAKPRAC,
          substr(WARTOSC,1,  1) CZY_ZAP,
          substr(WARTOSC,1,255) SW1,
          substr(WARTOSC,1,255) SW2,
          substr(WARTOSC,1,255) SW3,
          substr(WARTOSC,1,255) SW4,
          substr(WARTOSC,1,255) SW5,
          substr(WARTOSC,1,  1) PAT,
          substr(WARTOSC,1, 20) PAW,
          substr(WARTOSC,1,100) KW_SL1,
          substr(WARTOSC,1,100) KW_SL2,
          substr(WARTOSC,1,100) KW_SL3,
          substr(WARTOSC,1,100) KW_SL4,
          substr(WARTOSC,1, 16) PRACA_ZD,
          substr(WARTOSC,1,  8) PRACA_ZW,
          substr(WARTOSC,1, 20) PRACA_OD,
          substr(WARTOSC,1, 20) PRACA_DO
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWUMAN')
end formula

end proc


proc umzc
desc
   Dane dla wydruku "Umowa - zlecenie"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_UZ') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1, 20) MIEJSCE,
          substr(WARTOSC,1, 10) DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1, 37) F_POCZTA,
          substr(WARTOSC,1, 20) F_REGON,
          substr(WARTOSC,1, 13) F_NIP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,150) KTO,
          substr(WARTOSC,1,240) CO,
          substr(WARTOSC,1,240) CO_1,
          substr(WARTOSC,1,240) CO_2,
          substr(WARTOSC,1,240) CO_3,
          substr(WARTOSC,1,240) CO_4,
          substr(WARTOSC,1, 10) GODZ,
          substr(WARTOSC,1,  5) DNI,
          substr(WARTOSC,1,  1) TYP,
          substr(WARTOSC,1, 10) WDNIU,
          substr(WARTOSC,1, 70) OSOBA,
          substr(WARTOSC,1,  1) PLEC,
          substr(WARTOSC,1,130) ADRES,
          substr(WARTOSC,1, 10) ODDNIA,
          substr(WARTOSC,1, 10) DODNIA,
          substr(WARTOSC,1, 20) KWOTA,
          substr(WARTOSC,1, 10) NUMER,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_UZ')
end formula

end proc


proc umdz
desc
   Dane dla wydruku "Umowa o dzieło"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_UD') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1, 20) MIEJSCE,
          substr(WARTOSC,1, 10) DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1, 37) F_POCZTA,
          substr(WARTOSC,1, 20) F_REGON,
          substr(WARTOSC,1, 13) F_NIP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,150) KTO,
          substr(WARTOSC,1,240) CO,
          substr(WARTOSC,1,240) CO_1,
          substr(WARTOSC,1,240) CO_2,
          substr(WARTOSC,1,240) CO_3,
          substr(WARTOSC,1,240) CO_4,
          substr(WARTOSC,1, 10) GODZ,
          substr(WARTOSC,1,  5) DNI,
          substr(WARTOSC,1,  1) TYP,
          substr(WARTOSC,1, 10) WDNIU,
          substr(WARTOSC,1, 70) OSOBA,
          substr(WARTOSC,1,  1) PLEC,
          substr(WARTOSC,1,130) ADRES,
          substr(WARTOSC,1, 10) ODDNIA,
          substr(WARTOSC,1, 10) DODNIA,
          substr(WARTOSC,1, 20) KWOTA,
          substr(WARTOSC,1, 10) NUMER,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_UD')
end formula

end proc


proc zatr
desc
   Dane dla wydruku "Zaświadczenie o zatrudnienu"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWZATR') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,25)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NIP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          substr(WARTOSC,1,250) ADRES,
          substr(WARTOSC,1,30)  IDENT,
          ' '                   PLEC,
          ' '                   ZATRUDN,
          substr(WARTOSC,1,25)  D_ZATR,
          substr(WARTOSC,1,1)   RODZ_UM,
          substr(WARTOSC,1,60)  UMOWA,
          substr(WARTOSC,1,25)  D_ZWOL,
          substr(WARTOSC,1,150) ZWOL,
          '              '      RODZAJ,
          substr(WARTOSC,1,20)  SREDNIA,
          substr(WARTOSC,1,20)  SRED_BR,
          substr(WARTOSC,1,25)  MSC_OD,
          substr(WARTOSC,1,25)  MSC_DO,
          substr(WARTOSC,1,150) CEL,
          substr(WARTOSC,1,200) SLOW_SR,
          substr(WARTOSC,1,200) SLOW_SRB,
          substr(WARTOSC,1,41)  SLOW_UZ,
          ' '                   OBC_TYP,
          substr(WARTOSC,1,20)  OBC_KW,
          substr(WARTOSC,1,200) OBC_SL,
          substr(WARTOSC,1,  1) CZY_ZAP,
          substr(WARTOSC,1,120) STATUS
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWZATR')
end formula

end proc


proc wysl
desc
   Dane dla wydruku "Zmiana wysługi"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWWYSL') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NKP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,40)  NAZWISKO,
          substr(WARTOSC,1,40)  IMIE,
          ' '                   PLEC,
          substr(WARTOSC,1,20)  OD_DNIA,
          0                     LATA,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWWYSL')
end formula

end proc


proc plac
desc
   Dane dla wydruku "Zawiadomienie o przeszeregowaniu"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWPLAC') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          ' '                   PLEC,
          substr(WARTOSC,1,80)  STANOWIS,
          substr(WARTOSC,1,80)  STANNEW,
          ' '                   CHARPRAC,
          substr(WARTOSC,1,10)  TECZKA,
          substr(WARTOSC,1,20)  DATADEC,
          substr(WARTOSC,1,20)  OD_DNIA,
          substr(WARTOSC,1,5)   WALUTA,
          substr(WARTOSC,1,5)   WALUTA2,
          substr(WARTOSC,1,5)   WALUTA3,
          substr(WARTOSC,1,5)   WALUTA4,
          substr(WARTOSC,1,20)  S1,
          ' '                   Z1,
          substr(WARTOSC,1,20)  S2,
          ' '                   Z2,
          substr(WARTOSC,1,20)  S3,
          ' '                   Z3,
          substr(WARTOSC,1,20)  S4,
          ' '                   Z4,
          ' '                   S2T,
          substr(WARTOSC,1,60)  S2P,
          ' '                   S3T,
          substr(WARTOSC,1,60)  S3P
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWPLAC')
end formula

end proc


proc swpr
desc
   Dane dla wydruku "Świadectwo pracy"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWSW') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NIP,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,30)  F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,10)  DO_DATY,
          substr(WARTOSC,1,16)  PRACOWN,
          substr(WARTOSC,1,16)  OSOBA,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          substr(WARTOSC,1,20)  UR_DATA,
          ' '                   PLEC,
          ' '                   RUM,
          substr(WARTOSC,1,100) OPIS_ROZ,
          substr(WARTOSC,1, 50) OPIS_RO2,
          substr(WARTOSC,1,100) PP_ROZ,
          substr(WARTOSC,1,100) PP_RO2,

          substr(WARTOSC,1,20) URLOP,
          '        ' URLOPG,
          substr(WARTOSC,1,20) URLOPNZ,
          '        ' URLOPNZG,
          substr(WARTOSC,1,20) URLNSP,
          '        ' URLNSPG,
          substr(WARTOSC,1,20) URLREH,
          '        ' URLREHG,
          substr(WARTOSC,1,70) URLOPDOD,
          '        ' URLOPB,
          '        ' URLOPBW,
          '        ' URLOPW,
          substr(WARTOSC,1,20) OPIEKA,
          substr(WARTOSC,1,10) ZDALNA,
          substr(WARTOSC,1,20) CHOROBA,
          '        ' WOJSKO,
          substr(WARTOSC,1,100) INFO_WO1,
          substr(WARTOSC,1,100) INFO_WO2,
          substr(WARTOSC,1,20) OKR_NSKL,
          '        ' ART92P1,

          substr(WARTOSC,1,10)  SKRWYPOD,
          substr(WARTOSC,1,10)  SKRWYPDO,
          substr(WARTOSC,1,250) SZCZ_WAR,
          substr(WARTOSC,1,120) KOMORNIK,
          substr(WARTOSC,1,120) NRSPRAWY,
          0.00-0.00             POTRKW,
          substr(WARTOSC,1,70)  INFUZUP1,
          substr(WARTOSC,1,70)  INFUZUP2,
          substr(WARTOSC,1,70)  INFUZUP3,
          substr(WARTOSC,1,70)  INFUZUP4,
          substr(WARTOSC,1,150) SADPRACY,
          substr(WARTOSC,1,10)  D_ZATR,
          substr(WARTOSC,1,10)  OD_DATY,
          substr(WARTOSC,1,1)   CZY_ZAP,
          0                     OJCIEC_W,
          0                     OJCIEC_C,
          substr(WARTOSC,1,150) WYCH_P,
          substr(WARTOSC,1,150) RODZIC_P,
          0                     RODZIC_W,
          0                     RODZIC_C,
          0                     RODZIC_A,
          substr(WARTOSC,1,150) OCHRONA,
          0                     ALL_UM,
          substr(WARTOSC,1,3)   ODWOL,
          substr(WARTOSC,1,20)  USW,
          substr(WARTOSC,1,20)  UOP

   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWSW')
end formula

end proc


proc spwy
desc
   Wymiar zatrudnienia dla wydruku "Świadectwo pracy"
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
   OD:='0' STRING[10]
end params

sql
   select ' ' C1, WARTOSC OPIS
   from XR_PAR where 0=1
end sql

formula
   {? :OD='0'
   || _Q:=sql('
         select   H.RWY WY, H.OD, H.DO
         from     H
         where    H.P=\':_a\' and H.OD<=to_date(\':_b\')
         order by 2
      ',:P,:DO)
   || _Q:=sql('
         select   H.RWY WY, H.OD, H.DO
         from     H
         where    H.P=\':_a\' and H.OD<=to_date(\':_b\') and H.DO>=to_date(\':_c\')
         order by 2
      ',:P,:DO,:OD)
   ?};
   {? _Q.first
   || _do:=_Q.DO;
      _wy:=_Q.WY;
      {!
      |? {? _Q.next()
         || {? _do+1=_Q.OD & _wy=_Q.WY
            || _do:=_Q.DO;
               {? _Q.del(,1)=2 || _Q.prev() ?};
               _Q.DO:=_do;
               _Q.put()
            || _do:=_Q.DO;
               _wy:=_Q.WY;
               1
            ?}
         ?}
      !};
      _Q.first();
      {!
      |? :RS.OPIS:=
            'w okresie od %1 do %2' [_Q.OD$4,_Q.DO$4]+
            {? _Q.WY=1
            || ' w pełnym wymiarze czasu pracy'
            || ' w wymiarze '+$_Q.WY+' etatu '
            ?};
            :RS.add();
            _Q.next()
      !}
   ?};
   obj_del(_Q)
end formula

end proc

proc spstod
desc
   Lista stanowisk dla wydruku "Świadectwo pracy", zawierajaca sie w okrsie OD-DO
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
   OD:='2004-12-31' STRING[10]
end params

sql
   select /* +MASK_FILTER(H,'_hist') */ distinct ' ' C1, STN.ST
   from H join STN
   where H.P=:P and H.OD<=to_date(:DO) and H.DO>=to_date(:OD)
   order by 1
end sql

end proc


proc spst
desc
   Lista stanowisk dla wydruku "Świadectwo pracy"
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
end params

sql
   select /* +MASK_FILTER(H,'_hist') */ distinct ' ' C1, STN.ST
   from H join STN
   where H.P=:P and H.OD<=to_date(:DO)
   order by 1
end sql

end proc


proc spur
desc
   Dane o urlopach dla wydruku "Świadectwo pracy"
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
   KZ:='' STRING[1]
   RN:=0 INTEGER
   OD:='0' STRING[10]
   ZM:=0 INTEGER
end params

sql
   select ' ' C1, ' ' C2, substr(WARTOSC,1,60) TEKST
   from   XR_PAR
   where  0=1
end sql

formula
exec('__RUB','object');
   _rn:={? :KZ='B' || __RUB.sys_sql(112)
        |? :KZ='W' || __RUB.sys_sql(114)
        |? :KZ='O' || __RUB.sys_sql(1323)
        ?};
   _rnb:={? :KZ='B' || __RUB.sys_sql(1122) || '0' ?};
   {? _rnb='' || _rnb:='0' ?};
   {? _rn='' || _rn:='0' ?};
   {? :OD='0'
   || {? :KZ='B'
      || _q:=sql('select   N.OD, N.DO, case when R.RN in (:_d) then 1 else 0 end FIR
                  from     N join R
                  where    N.KOR=\'N\' and N.P=:_a and R.RN in (:_c) and N.OD<=to_date(:_b)
                  order by 1
                  ','\''+:P+'\'','\''+:DO+'\'',_rn,_rnb)
      || _q:=sql('select   N.OD, N.DO, 0 FIR
                  from     N join R
                  where    N.KOR=\'N\' and N.P=:_a and R.RN in (:_c) and N.OD<=to_date(:_b)
                  order by 1
                  ','\''+:P+'\'','\''+:DO+'\'',_rn)
      ?}
   |? :KZ='B'
   || _q:=sql('select   N.OD, N.DO, case when R.RN in (:_e) then 1 else 0 end FIR
               from     N join R
               where    N.KOR=\'N\' and N.P=:_a and R.RN in (:_c) and N.OD<=to_date(:_b) and N.DO>=to_date(:_d)
               order by 1
              ','\''+:P+'\'','\''+:DO+'\'',_rn,'\''+:OD+'\'',_rnb)
   || _q:=sql('select   N.OD, N.DO, 0 FIR
               from     N join R
               where    N.KOR=\'N\' and N.P=:_a and R.RN in (:_c) and N.OD<=to_date(:_b) and N.DO>=to_date(:_d)
               order by 1
              ','\''+:P+'\'','\''+:DO+'\'',_rn,'\''+:OD+'\'')
   ?};
   _od_data:=date(0,0,0);
   _rok:=4+:DO;
   _tmp:=5-:DO;
   _tmp2:=_tmp*'-';
   _mies:=(_tmp2-1)+_tmp;
   _tmp:=(_tmp2)-_tmp;
   _dzien:=_tmp;
   _do_data:=date(#_rok,#_mies,#_dzien);
   {? :OD<>'0'
   || _rok:=4+:OD;
      _tmp:=5-:OD;
      _tmp2:=_tmp*'-';
      _mies:=(_tmp2-1)+_tmp;
      _tmp:=(_tmp2)-_tmp;
      _dzien:=_tmp;
      _od_data:=date(#_rok,#_mies,#_dzien)
   ?};
   {? _q.first()
   || {? _q.OD<_od_data || _q.OD:=_od_data; _q.put() ?};
      _do:=_q.DO;
      {!
      |? _fir:=_q.FIR;
         {? _q.next()
         || {? _do+1=_q.OD & _q.FIR=_fir
            || _do:=_q.DO;
               {? _q.del(,1)=2 || _q.prev() ?};
               _q.DO:=_do;
               _q.put()
            || _do:=_q.DO; 1
            ?}
         ?}
      !};
      {? _do_data<>date(0,0,0) & _q.DO>_do_data || _q.DO:=_do_data; _q.put() ?};
      _q.first();
      {! |?
         {? :KZ='O' & :ZM
         || {? (:ZM=1 & _q.OD<date(2022,4,23)) | (:ZM=2 & _q.OD>=date(2022,4,23))
            || :RS.TEKST:='od %1 do %2 ' [_q.OD$4,_q.DO$4];
               :RS.add()
            ?}
         || :RS.TEKST:='od %1 do %2 ' [_q.OD$4,_q.DO$4]+
               {? :KZ='B' || {? _q.FIR || ' (art. 174 (1) Kodeksu pracy)' || ' (art. 174 Kodeksu pracy)' ?} || '' ?};
            :RS.add()
         ?};
         _q.next()
      !}
   ?};
   obj_del(_q)
end formula

end proc


proc spns
desc
   Informacje o okresach nieskładkowych dla wydruku "Świadectwo pracy"
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
   OD:='0' STRING[10]
end params

sql
   select ' ' C1, ' ' C2, substr(WARTOSC,1,50) TEKST
   from   XR_PAR
   where  0=1
end sql

formula
exec('__RUB','object');
   {? :OD='0'
   || _q:=sql('select   N.OD, N.DO, R.RN, RA_DEF.SYMBOL
               from     N join R join RA_USE join RA_DEF
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and
                        RA_DEF.SYMBOL=196
               order by 1
            ','\''+:P+'\'','\''+:DO+'\'')
   || _q:=sql('select   N.OD, N.DO, R.RN, RA_DEF.SYMBOL
               from     N join R join RA_USE join RA_DEF
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and N.DO>=to_date(:_c) and
                        RA_DEF.SYMBOL=196
               order by 1
            ','\''+:P+'\'','\''+:DO+'\'','\''+:OD+'\'')
   ?};
   'algorytm sprawdza czy w okresie nieobecnosci rubryka w atrybucie byla aktywna';
   {? _q.first()
   || {!
      |? _del:=0;
         {? ~__RUB.sys_attr(_q.RN,_q.SYMBOL,_q.OD) || _del:=_q.del(,1) ?};
         {? _del=1
         || 0
         |? _del=0
         || _q.next()
         || 1
         ?}
      !}
   ?};
   _od_data:=date(0,0,0);
   _lim_data:=date(1991,11,14);
   _rok:=4+:DO;
   _tmp:=5-:DO;
   _tmp2:=_tmp*'-';
   _mies:=(_tmp2-1)+_tmp;
   _tmp:=(_tmp2)-_tmp;
   _dzien:=_tmp;
   _do_data:=date(#_rok,#_mies,#_dzien);
   {? :OD<>'0'
   || _rok:=4+:OD;
      _tmp:=5-:OD;
      _tmp2:=_tmp*'-';
      _mies:=(_tmp2-1)+_tmp;
      _tmp:=(_tmp2)-_tmp;
      _dzien:=_tmp;
      _od_data:=date(#_rok,#_mies,#_dzien)
   ?};
   {? _q.first()
   || {? _q.OD<_od_data || _q.OD:=_od_data; _q.put() ?};
      _do:=_q.DO;
      {!
      |? {? _q.next()
         || {? _do+1=_q.OD
            || _do:=_q.DO;
               {? _q.del(,1)=2 || _q.prev() ?};
               _q.DO:=_do;
               _q.put()
            || _do:=_q.DO; 1
            ?}
         ?}
      !};
      {? _q.DO>_do_data || _q.DO:=_do_data; _q.put() ?};
      _q.cntx_psh();
      _q.index(_q.ndx_tmp('Do daty',,'DO',,));
      {? _q.first() & _q.DO<=_lim_data
      || {!
         |? {? _q.DO<=_lim_data || _q.del() ?}
         !}
      ?};
      _q.ndx_drop(_q.index('?'));
      _q.cntx_pop();
      {? _q.first() & _q.OD<=_lim_data
      || {!
         |? {? _q.OD<=_lim_data
            || _q.OD:=_lim_data+1;
               _q.put();
               _q.first()
            ?}
         !}
      ?};
      {? _q.first()
      || {!
         |? _dn:=(_q.DO-_q.OD)+1;
            :RS.TEKST:='od %1 do %2 za %3' [_q.OD$4,_q.DO$4,$_dn]+{? _dn=1 || ' dzień' || ' dni' ?};
            :RS.add();
            _q.next()
         !}
      ?}
   ?};
   obj_del(_q)
end formula

end proc


proc sp92p1
desc
   Informacje o dniach, o których mowa w art.92 par.1
end desc

params
   P:='' STRING[16]
   DO:='2004-12-31' STRING[10]
   OD:='0' STRING[10]
end params

sql
   select ' ' C1, ' ' C2, substr(WARTOSC,1,50) TEKST
   from   XR_PAR
   where  0=1
end sql

formula
   {? :OD='0'
   || _q:=sql('select   N.OD, N.DO, N.DK, 0 DN
               from     N
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and N.DK<>0
               union all
               select   N.OD, N.DO, 0 DK, N.DN
               from     N left join S_ZUS using(N.KDCH,S_ZUS.REFERENCE) join RA_USE using (N.NB, RA_USE.R) join RA_DEF
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and to_date(\'2003-1-1\')<=N.OD and
                        N.OD<=to_date(\'2003-12-31\') and
                        RA_DEF.SYMBOL=12111 and N.DN>=1 and (N.KDCH is null or S_ZUS.KOD<>\'C\')
               order by 1
            ','\''+:P+'\'','\''+:DO+'\'')
   || _q:=sql('select   N.OD, N.DO, N.DK, 0 DN
               from     N
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and N.DO>=to_date(:_c) and N.DK<>0
               union all
               select   N.OD, N.DO, 0 DK, N.DN
               from     N left join S_ZUS using(N.KDCH,S_ZUS.REFERENCE) join RA_USE using (N.NB, RA_USE.R) join RA_DEF
               where    N.KOR=\'N\' and N.P=:_a and N.OD<=to_date(:_b) and N.DO>=to_date(:_c) and
                        to_date(\'2003-1-1\')<=N.OD and N.OD<=to_date(\'2003-12-31\') and
                        RA_DEF.SYMBOL=12111 and N.DN>=1 and (N.KDCH is null or S_ZUS.KOD<>\'C\')
               order by 1
            ','\''+:P+'\'','\''+:DO+'\'','\''+:OD+'\'')
   ?};
   {? _q.first()
   || {!
      |? :RS.TEKST:=_q.OD$4;
         {? _q.DK>0
         || _do:=_q.DO;
            {? {? _q.next()
               || _do:={? (_do-_q.OD)=1 || _q.DK>=0 ?};
                  _q.prev();
                  _do
               || 1
               ?}
            || :RS.add()
            ?}
         |? _q.DN & _q.DO-_q.OD+1<=6
         || :RS.add()
         ?};
         _q.next()
      !}
   ?};
   obj_del(_q)
end formula

end proc


proc rodz
desc
   Dane dla wydruku "Zaświadczenie do zasiłku rodzinnego"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PXX_ZASWRODZ') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,13)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NIP,
          substr(WARTOSC,1,127) F_LOGO,
          0                     ROK,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          substr(WARTOSC,1,20)  OJCIEC,
          substr(WARTOSC,1,23)  UR_DATA,
          ' '                   PLEC,
          substr(WARTOSC,1,250) ADRES,
          ' '                   JESTZATR,
          substr(WARTOSC,1,23)  DATAZATR,
          substr(WARTOSC,1,60)  UMOWA,
          substr(WARTOSC,1,23)  ZWOLDATA,
          substr(WARTOSC,1,150) ZWOLTRYB,
          substr(WARTOSC,1,20)  KWOTA,
          substr(WARTOSC,1,100) SLOWNIE,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PXX_ZASWRODZ')
end formula

end proc


proc zmum
desc
   Dane dla wydruku "Wypowiedzenie warunków umowy o pracę"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWZMUM') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,30)  F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          ' '                   PLEC,
          substr(WARTOSC,1,20)  DATAUM,
          substr(WARTOSC,1,20)  DATAWYP,
          substr(WARTOSC,1,20)  DATAZM,
          substr(WARTOSC,1,20)  OKRWYP,
          substr(WARTOSC,1,150) POWOD,
          substr(WARTOSC,1,120) ZMIANA,
          substr(WARTOSC,1,120) NOWAWAR,
          substr(WARTOSC,1,72)  SAD,
          substr(WARTOSC,1,120) KOMISJA,
          ' '                   UMTYP,
          substr(WARTOSC,1,20)  DATAPOLW,
          substr(WARTOSC,1,  1)  CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWZMUM')
end formula

end proc


proc zwyp
desc
   Dane dla wydruku "Rozwiązanie umowy o pracę za wypowiedzeniem"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWZWYP') ?}
end formula

sql
   select substr(WARTOSC,1,16)  H_UM_REF,
          substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,13)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,30)  F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          ' '                   PLEC,
          substr(WARTOSC,1,23)  DATAUM,
          substr(WARTOSC,1,23)  DATAWYP,
          substr(WARTOSC,1,20)  OKRES,
          substr(WARTOSC,1,150) POWOD,
          substr(WARTOSC,1,72)  SAD,
          substr(WARTOSC,1,120) KOMISJA,
          ' '                   UMTYP,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWZWYP')
end formula

end proc


proc swyp
desc
   Dane dla wydruku "Rozwiązanie umowy o pracę ze skróconym okresem wypowiedzenia"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWSWYP') ?}
end formula

sql
   select substr(WARTOSC,1,16)  H_UM_REF,
          substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,13)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,30)  F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          ' '                   PLEC,
          substr(WARTOSC,1,23)  DATAUM,
          substr(WARTOSC,1,23)  DATAWYP,
          substr(WARTOSC,1,80)  OKRES,
          substr(WARTOSC,1,150) POWOD,
          substr(WARTOSC,1,72)  SAD,
          substr(WARTOSC,1,120) KOMISJA,
          ' '                   UMTYP,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWSWYP')
end formula

end proc


proc bwyp
desc
   Dane dla wydruku "Rozwiązanie umowy o pracę bez wypowiedzenia"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWBWYP') ?}
end formula

sql
   select substr(WARTOSC,1,16)  H_UM_REF,
          substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,30)  F_PKD,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,20)  IMIE,
          substr(WARTOSC,1,20)  DRUGIEIM,
          ' '                   PLEC,
          substr(WARTOSC,1,20)  DATAUM,
          substr(WARTOSC,1,20)  DATAWYP,
          substr(WARTOSC,1,150) POWOD,
          substr(WARTOSC,1,72)  SAD,
          substr(WARTOSC,1,120) KOMISJA,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWBWYP')
end formula

end proc


proc warp
desc
   Dane dla wydruku "Informacja o warunkach pracy"
   Część 2 w procedurze warp2
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWWARP') ?}
end formula

sql
   select substr(WARTOSC,1, 16)  P_REF,
          substr(WARTOSC,1,150)  F_NAZWA,
          substr(WARTOSC,1, 20)  MIEJSCE,
          substr(WARTOSC,1, 10)  DATA,
          substr(WARTOSC,1,100)  F_ULICA,
          substr(WARTOSC,1, 37)  F_POCZTA,
          substr(WARTOSC,1, 20)  F_REGON,
          substr(WARTOSC,1, 13)  F_NIP,
          substr(WARTOSC,1, 13)  F_NKP,
          substr(WARTOSC,1,127)  F_LOGO,

          substr(WARTOSC,1, 30)  NAZWISKO,
          substr(WARTOSC,1, 20)  IMIE,
          substr(WARTOSC,1, 20)  DRUGIEIM,
          ' '                    PLEC,
          substr(WARTOSC,1,100)  STANOWIS,

          substr(WARTOSC,1,127)  NCP_SYSP,
          substr(WARTOSC,1,127)  NCP_NDOB,
          substr(WARTOSC,1,127)  NCP_NTYG,
          substr(WARTOSC,1,127)  NCP_MIES,
          substr(WARTOSC,1,127)  NCP_GODZ,

          substr(WARTOSC,1,127)  WW_ZASAD,
          substr(WARTOSC,1,127)  WW_DODAT,
          substr(WARTOSC,1,127)  WW_WOLNE,
          substr(WARTOSC,1,127)  WW_PRZEL,

          substr(WARTOSC,1,127)  WYPOKRES,
          substr(WARTOSC,1,127)  WYPDZIEN,

          substr(WARTOSC,1,127)  UW_1,
          substr(WARTOSC,1,127)  UW_2,
          substr(WARTOSC,1,127)  UW_3,
          substr(WARTOSC,1,127)  UW_4,
          substr(WARTOSC,1,  1)  CZY_ZAP,
          substr(WARTOSC,1,127)  KOT,
          substr(WARTOSC,1, 16)  PRACA_ZD,
          substr(WARTOSC,1,  8)  PRACA_ZW

   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWWARP')
end formula

end proc


proc warp2
desc
   Dane dla wydruku "Informacja o warunkach pracy cz.2"
   Część 1 w procedurze umpr
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWWARP') ?}
end formula

sql
   select substr(WARTOSC,1, 16)  P_REF,
          substr(WARTOSC,1,127)  NCP_WDOB,
          substr(WARTOSC,1,127)  NCP_WTYG,
          substr(WARTOSC,1,127)  NCP_WDOW,
          substr(WARTOSC,1,127)  NCP_WTYW,
          substr(WARTOSC,1,127)  NCP_PPRA,
          substr(WARTOSC,1,127)  NCP_ZPGN,
          substr(WARTOSC,1,127)  NCP_RPGN,
          substr(WARTOSC,1,127)  NCP_PZNZ,
          substr(WARTOSC,1,127)  NCP_PMMP,

          substr(WARTOSC,1,127)  WW_INNE,
          substr(WARTOSC,1,127)  WW_SPRZ,

          substr(WARTOSC,1,127)  IN_SZKOL,
          substr(WARTOSC,1,127)  IN_UZBIO,
          substr(WARTOSC,1,127)  IN_ZIUSP,
          substr(WARTOSC,1,127)  WYPINNE,
          substr(WARTOSC,1,127)  WYPSAD

   from   XR_PAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWWARP')
end formula

end proc


proc komornik
desc
   Informacje o komornikach dla wydruku "Świadectwo pracy"
end desc

params
   OSOBA:='' STRING[16]
   PRAC:='' STRING[16]
   OD:='2004-12-31' STRING[10]
   DO:='2004-12-31' STRING[10]
end params

sql
   select ' ' C1, substr(WARTOSC,1,130) TEKST
   from   XR_PAR
   where  0=1
end sql

formula
   _date:="_rok:=((_a*'-')-1)+_a;_a:=(_a*'-')-_a;
      _mc:=((_a*'-')-1)+_a;_a:=(_a*'-')-_a;
      _dn:=_a;
      date(#_rok,#_mc,#_dn)";
   _od:=_date(:OD);
   _do:=_date(:DO);
   _firma:=exec('ref_firma','ustawienia');

   _kom1:=sql('
      select    KOM_OS.SYG, KOM_OS.WART, KOM_OS.REFERENCE as REF, sum(KOM_SP.KW) as KW
      from      KOM_OS join KOM_SP join  OSOBA
                left join P using (KOM_SP.P,P.REFERENCE)
                left join RH using (KOM_SP.RH,RH.REFERENCE)
      where     OSOBA.REFERENCE=\':_a\' and KOM_OS.OD<=to_date(:_b) and
                (KOM_OS.DO is null or to_date(:_b)<=KOM_OS.DO) and
                KOM_OS.SYG<>\'\' and
                ((KOM_SP.P is not null and P.REFERENCE=\':_g\') or
                 (KOM_SP.RH is not null and RH.DWY<=to_date(:_b) and RH.DWY>=to_date(:_h)) or
                 (KOM_SP.O is null and KOM_SP.RH is null and
                  (KOM_SP.R<:_c or (KOM_SP.R=:_c and KOM_SP.M<=:_d)) and
                  (KOM_SP.R>:_e or (KOM_SP.R=:_e and KOM_SP.M>=:_f)))) and
                KOM_OS.FIRMA=:_i
      group by  KOM_OS.SYG, KOM_OS.WART, KOM_OS.REFERENCE
      union all
      select    KOM_OS.SYG, KOM_OS.WART, KOM_OS.REFERENCE as REF, 0 as KW
      from      KOM_OS left join KOM_SP join  OSOBA
      where     OSOBA.REFERENCE=\':_a\' and KOM_OS.OD<=to_date(:_b) and
                (KOM_OS.DO is null or to_date(:_b)<=KOM_OS.DO) and
                KOM_OS.SYG<>\'\' and
                KOM_OS.FIRMA=:_i',
      :OSOBA, _do, _do~1, _do~2, _od~1, _od~2, :PRAC, _od, _firma
   );
   _kom:=sql(' select SYG, WART, REF, sum(KW) as KW from :_a group by SYG, WART, REF',_kom1);

   _kom2:=sql('
      select    KOM_OS.REFERENCE REF, KOM_OS.WART, sum(KOM_SP.KW) as KW
      from      KOM_OS join KOM_SP
      where     KOM_OS.OSOBA=\':_a\' and KOM_OS.OD<=to_date(:_b) and
                (KOM_OS.DO is null or to_date(:_b)<=KOM_OS.DO) and
                KOM_OS.SYG<>\'\' and
                KOM_OS.FIRMA=:_c
      group by  KOM_OS.REFERENCE, KOM_OS.WART
      order by 1',
      :OSOBA, _do, _firma
   );
   {? _kom.first
   || {!
      |? {? _kom2.find_key(_kom.REF) & _kom2.WART=_kom2.KW
         || _kom.del(,1)=2
         || _kom.next
         ?}
      !}
   ?};

   _kom_naz:=_kom_syg:='';
   _kom_kw:=0.0;
   _jest_k:=0;
   {? type_of(_kom)=type_of(SYSLOG) & _kom.first()
   || KOM_OS.prefix();
      {!
      |? {? _kom.WART=0 | _kom.WART>_kom.KW
         || _kom_fl:=0;
            {? KOM_OS.seek(_kom.REF)
            || {? KOM_OS.KOM<>null()
               || :RS.TEKST:='Oznaczenie komornika: '+KOM_OS.KOM().NAZWA; :RS.add();
                  _jest_k:=1;
                  _kom_fl:=1
               |? KOM_OS.WIE<>null()
               || :RS.TEKST:='Oznaczenie wierzyciela: '+KOM_OS.WIE().NAZWA; :RS.add();
                  _jest_k:=1;
                  _kom_fl:=1
               ?}
            ?};
            {? _kom_fl
            || :RS.TEKST:='Numer sprawy egzekucyjnej: '+_kom.SYG; :RS.add();
               :RS.TEKST:='Wysokość potrąconych kwot: '+$_kom.KW; :RS.add()
            ?}
         ?};
         _kom.next()
      !};
      {? ~_jest_k
      || :RS.TEKST:='Oznaczenie komornika: brak'; :RS.add();
         :RS.TEKST:='Numer sprawy egzekucyjnej: brak'; :RS.add();
         :RS.TEKST:='Wysokość potrąconych kwot: brak'; :RS.add()
      ?}
   || :RS.TEKST:='Oznaczenie komornika: brak'; :RS.add();
      :RS.TEKST:='Numer sprawy egzekucyjnej: brak'; :RS.add();
      :RS.TEKST:='Wysokość potrąconych kwot: brak'; :RS.add()
   ?}

end formula

end proc


proc url_rodz
desc
   Urlopy rodzicielskie dla wydruku "Świadectwo pracy"
end desc

params
   P:='' STRING[16]
   DO:='' STRING[10]
   ATR:=0 INTEGER
   PKT:=0 INTEGER
   OD:='' STRING[10]
end params

sql
   select ' ' C1, WARTOSC OPIS
   from XR_PAR where 0=1
end sql

formula
   P.seek(:P,);
   _plec:=P.OSOBA().PLEC='K';
   _date:=
      "  _rok:=((_a*'-')-1)+_a;
         _a:=(_a*'-')-_a;
         _mc:=((_a*'-')-1)+_a;
         _a:=(_a*'-')-_a;
         _dn:=_a;
         date(#_rok,#_mc,#_dn)
      ";
   _UDO:=_date(:DO);
   {? :ATR=1154
   || :ATR:=11541;
      _ATR:=11542
   || _ATR:=0
   ?};
   _where:='';
   {? (:ATR=1153 | :ATR=11541 | :ATR=114) & +:OD>1
   || _where:=' and (RD_OKR.OD<=to_date(\'%2\') and RD_OKR.DO>=to_date(\'%1\'))'[:OD,:DO]
   ?};
   _Q:=sql('
      select RD_PPRAW.ARTYKUL, RD_PPRAW.ART_NDX, RD_PPRAW.PARAGRAF, RD_PPRAW.PUNKT, RD_PPRAW.TRESC, RD_OKR.DZIEN,
         RD_OKR.MIESIAC,
         \'                                                                                             \' as DZIECKO,
         RD.IM, RD.NA, RD_OKR.CZESC, RD_OKR.TYDZIEN, RD_OKR.OD, RD_OKR.DO, RD.DA, RD.DTPRZYSP, RD.ODROS,
         RD_OKR.REFERENCE as REF
      from RD_DZ join RD_OKR using(RD_DZ.RD_OKR,RD_OKR.REFERENCE) join RD using(RD_DZ.RD,RD.REFERENCE) join
         RD_NB using(RD_NB.REFERENCE,RD_OKR.RD_NB) join RD_PPRAW using(RD_OKR.RD_PPRAW,RD_PPRAW.REFERENCE)
      where  RD_OKR.P=\':_a\' and RD_OKR.ZAT=\'T\' and (RD_NB.ATR=:_b or RD_NB.ATR=:_c) %1
      order by RD_PPRAW.TRESC,RD_OKR.OD,RD.NA,RD.IM'[_where],
      :P,:ATR,_ATR
   );
   {? :ATR=1153
   || 'ojcowski';
      {? _Q.first()
      || {!
         |? {? _Q.DTPRZYSP>#0
            || {? {? _Q.ODROS='T'
                  || _Q.DA<date(_UDO~1-10,_UDO~2,{? _UDO=date(_UDO~1,_UDO~2,0) || 0 || _UDO~3 ?})
                  || _Q.DA<date(_UDO~1-7,_UDO~2,{? _UDO=date(_UDO~1,_UDO~2,0) || 0 || _UDO~3 ?})
                  ?}
               || _wiek:=0
               || _wiek:=_Q.DTPRZYSP>=date(_UDO~1-2,_UDO~2,{? _UDO=date(_UDO~1,_UDO~2,0) || 0 || _UDO~3 ?})
               ?}
            || _wiek:=_Q.DA>=date(_UDO~1-2,_UDO~2,{? _UDO=date(_UDO~1,_UDO~2,0) || 0 || _UDO~3 ?})
            ?};
            {? ~_wiek || _Q.del(,1)=2 || _Q.next() ?}
         !};
         {? _Q.first()
         || _im:=_Q.IM;
            _na:=_Q.NA;
            _ref:='';
            _ile:=0;
            {!
            |? {? _im<>_Q.IM | _na<>_Q.NA || _ile:=1 ?};
               _Q.next()
            !};
            _Q.first();
            {!
            |? {? _ref=_Q.REF
               || _dziecko+=', '+_Q.IM+' '+_Q.NA;
                  _Q.prev();
                  _Q.del(,1)=2;
                  _Q.DZIECKO:=_dziecko
               || _dziecko:=_Q.IM+' '+_Q.NA;
                  _Q.DZIECKO:=_dziecko;
                  _ref:=_Q.REF
               ?};
               _Q.put();
               _Q.next()
            !};

            {? _Q.first()
            || _Q_group:=sql('
                  select TRESC, DZIECKO, max(CZESC) as CZESC, sum(TYDZIEN) as TYDZIEN
                  from :_a
                  group by TRESC, DZIECKO
                  order by 1,2',_Q
               );
               {? _Q_group.first()
               || {!
                  |? :RS.OPIS:=
                        $_Q_group.TYDZIEN+{? _Q_group.TYDZIEN=1 || ' tydzień ' || ' tygodni ' ?}+
                        'w '+$_Q_group.CZESC+{? _Q_group.CZESC=1 || ' części ' || ' częściach ' ?}+
                        {? _ile || {? _Q_group.DZIECKO*',' || ' dzieci: ' || ' dziecko: ' ?}+_Q_group.DZIECKO || '' ?};
                     :RS.add();
                     _Q_group.next()
                  !}
               ?}
            ?}
         ?}
      ?}
   |? :ATR=114
   || 'wychowawczy';
      {? _Q.first()
      || _im:=_Q.IM;
         _na:=_Q.NA;
         _ref:='';
         _ile:=0;
         {!
         |? {? _im<>_Q.IM | _na<>_Q.NA || _ile:=1 ?};
            _Q.next()
         !};
         _Q.first();
         {!
         |? {? _ref=_Q.REF
            || _dziecko+=', '+_Q.IM+' '+_Q.NA;
               _Q.prev();
               _Q.del(,1)=2;
               _Q.DZIECKO:=_dziecko
            || _dziecko:=_Q.IM+' '+_Q.NA;
               _Q.DZIECKO:=_dziecko;
               _ref:=_Q.REF
            ?};
            _Q.put();
            _Q.next()
         !};
         _Q.first();
         _Q_group:=sql('
            select TRESC, DZIECKO, max(CZESC) as CZESC, sum(MIESIAC) as MIESIAC
            from :_a
            group by TRESC, DZIECKO
            order by 1,2',_Q
         );
         _Q.index(_Q.ndx_tmp(,1,'TRESC',,,'DZIECKO',,,'OD',,));
         {? _Q_group.first()
         || exec('__KAL','object');
            __KAL.set_cal(P.KAL);
            _p330:=__KAL.par330;
            __KAL.set330(1);
            {!
            |? _dni:=0;
               _mcy:=0;
               _okres:='';
               _ile_okr:=-1;
               _Q.prefix(_Q_group.TRESC,_Q_group.DZIECKO);
               {? _Q.first()
               || {!
                  |? {? _ile_okr>=0 || _okres+='; ' ?};
                     _okres+=$_Q.OD+' - '+$_Q.DO;
                     __KAL.rdat(_Q.OD,_Q.DO);
                     _mcy+=__KAL.year*12;
                    _mcy+=__KAL.month;
                    _dni+=__KAL.day;
                     _ile_okr+=1;
                     _Q.next()
                  !}
               ?};
               :RS.OPIS:=_Q_group.TRESC+{? _ile_okr || ' w okresach ' || ' w okresie ' ?}+_okres;
               :RS.add;
               _mc:={? _dni>30 || _dni%30 ?};
               _mcy+=_mc;
               _dni-=_mc*30;
               _txt:={? _dni>0 || ' i %1 %2 '[$_dni,{? _dni=1 || 'dzień ' || 'dni ' ?}] || '' ?};
               :RS.OPIS:='w wymiarze %1%2%3w %4%5%6'
                  [$_mcy,
                  {? _mcy=1 || ' miesiąc ' || ' miesięcy ' ?},
                  _txt,
                  $_Q_group.CZESC,
                  {? _Q_group.CZESC=1 || ' części ' || ' częściach ' ?},
                  {? _ile || {? _Q_group.DZIECKO*',' || ' dzieci: ' || ' dziecko: ' ?}+_Q_group.DZIECKO || '' ?}
                  ];
               :RS.add();
               _Q_group.next()
            !};
            __KAL.set330(_p330)
         ?}
      ?}
   |? :ATR=11541
   || 'rodzicielski';
      {? _Q.first()
      || {!
         |? _wiek:=date(_Q.DA~1,12,0)>=date(_UDO~1-6,12,0);
            {? ~_wiek || _Q.del(,1)=2 || _Q.next() ?}
         !};
         {? _Q.first()
         || _im:=_Q.IM;
            _na:=_Q.NA;
            _ref:='';
            _ile:=0;
            {!
            |? {? _im<>_Q.IM | _na<>_Q.NA || _ile:=1 ?};
               _Q.next()
            !};
            _Q.first();
            {!
            |? {? _ref=_Q.REF
               || _dziecko+=', '+_Q.IM+' '+_Q.NA;
                  _Q.prev();
                  _Q.del(,1)=2;
                  _Q.DZIECKO:=_dziecko
               || _dziecko:=_Q.IM+' '+_Q.NA;
                  _Q.DZIECKO:=_dziecko;
                  _ref:=_Q.REF
               ?};
               _Q.put();
               _Q.next()
            !};
            _Q_group:=sql('
               select TRESC, DZIECKO, ARTYKUL, ART_NDX, PARAGRAF, max(CZESC) as CZESC, sum(TYDZIEN) as TYDZIEN,
                  sum(DZIEN) as DZIEN
               from :_a
               group by TRESC, DZIECKO, ARTYKUL, ART_NDX, PARAGRAF
               order by 2,3,4,5',_Q
            );
            {? _Q_group.first()
            || _Q_rodz:=sql('
                  select DZIECKO, sum(CZESC) as CZESC, sum(TYDZIEN) as TYDZIEN, sum(DZIEN) as DZIEN
                  from :_a
                  group by DZIECKO
                  order by 1',_Q_group
               );
               _Q_w_tym:=sql('
                  select DZIECKO, max(CZESC) as CZESC, sum(DZIEN) as DZIEN
                  from :_a
                  where ARTYKUL=\'182\' and ART_NDX=\'1c\' and PARAGRAF=\'3\'
                  group by DZIECKO
                  order by 1',_Q_group
               );

               {? _Q_rodz.first()
               || {!
                  |? _Q_group.prefix(_Q_rodz.DZIECKO);
                     _czesc:=_wymiar:=0;
                     _yes:=1;
                     {? _Q_group.first()
                     || _Q_w_tym.prefix(_Q_rodz.DZIECKO);
                        {!
                        |? {? _Q_w_tym.first()
                           || {?  _Q_group.size()=_Q_w_tym.size()
                              || _yes:=0
                              || _czesc:=_Q_w_tym.CZESC;
                                 _wymiar:=_Q_w_tym.DZIEN
                              ?}
                           ?};
                           {?  ~(_Q_group.size()<>_Q_w_tym.size()
                               &
                               _Q_group.ARTYKUL='182' & _Q_group.ART_NDX='1c' & _Q_group.PARAGRAF='3')
                           || _tyg:=_Q_group.DZIEN%7;
                              _dz:=_Q_group.DZIEN%*7;
                              _op:=
                                 {? _tyg
                                 || $_tyg+ {? _tyg=1 || ' tydzień ' || ' tygodni ' ?}
                                 || ''
                                 ?};
                              {? _dz
                              || _op+={? _tyg || 'oraz ' || '' ?}+$_dz+ {? _dz=1 || ' dzień ' || ' dni ' ?}
                              ?};
                              :RS.OPIS:=
                                 ' w wymiarze '+_op+
                                 'w '+$(_Q_group.CZESC)+{? _Q_group.CZESC=1 || ' części' || ' częściach' ?}+
                                 {? _ile || {? _dziecko*',' || ' dzieci: ' || ' dziecko: ' ?}+_Q_rodz.DZIECKO || '' ?}+
                                 {? _Q_w_tym.first();0 || ', ' || '' ?};
                              :RS.add()
                           ?};
                           _Q_group.next()
                        !}
                     ?};
                     {? _yes;0
                     || {? _czesc>0
                        || _tyg:=_wymiar%7;
                           _dz:=_wymiar%*7;
                           _op:=
                              {? _tyg
                              || $_tyg+ {? _tyg=1 || ' tydzień ' || ' tygodni ' ?}
                              || ''
                              ?};
                           {? _dz
                           || _op+={? _tyg || 'oraz ' || '' ?}+$_dz+ {? _dz=1 || ' dzień ' || ' dni ' ?}
                           ?};
                           :RS.OPIS:=
                              'oraz na podstawie art. 182(1c) § 3 Kodeksu pracy w wymiarze '+_op+'w '+
                              $_czesc+{? _czesc=1 || ' części' || ' częściach' ?}+
                              {? _ile || {? _dziecko*',' || ' dzieci: ' || ' dziecko: ' ?}+_Q_rodz.DZIECKO || '' ?}+
                              {? _Q_w_tym.first() || ', ' || '' ?};
                           :RS.add
                        || :RS.OPIS:='w tym na podstawie art. 182(1c) § 3 Kodeksu pracy nie '+
                              {? _plec || 'korzystała.' || 'korzystał.' ?};
                           :RS.add()
                        ?}
                     ?};
                     _Q_rodz.next()
                  !}
               ?}
            ?}
         ?}
      ?}
   ?};
   obj_del(_Q)
end formula

end proc


proc pouc
desc
   Dane dla wydruku "Informacja o okresie przechowywania akt pracowniczych"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWPRZAKT') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NKP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,41)  IMIE,
          ' '                   PLEC,
          0                     RIA,
          substr(WARTOSC,1,10)  DZ,
          substr(WARTOSC,1,10)  ODBIOR,
          substr(WARTOSC,1,10)  ZAPOMNIJ,
          0                     LATA,
          substr(WARTOSC,1,171) P_ULICA,
          substr(WARTOSC,1,30)  P_MIASTO,
          substr(WARTOSC,1,40)  P_POCZTA,
          substr(WARTOSC,1,20)  P_KRAJ,
          substr(WARTOSC,1,  1)  CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWPRZAKT')
end formula

end proc


proc wypl
desc
   Dane dla wydruku "Informacja o sposobie wypłaty wynagrodzenia"
end desc

params
   INST:=0 INTEGER
end params

formula
   {? ~:INST || :INST:=#exec('rep_ins','rap_zew','PKD_ZASWSPOSOBWYPL') ?}
end formula

sql
   select substr(WARTOSC,1,150) F_NAZWA,
          substr(WARTOSC,1,20)  MIEJSCE,
          substr(WARTOSC,1,10)  DATA,
          substr(WARTOSC,1,100) F_ULICA,
          substr(WARTOSC,1,37)  F_POCZTA,
          substr(WARTOSC,1,20)  F_REGON,
          substr(WARTOSC,1,13)  F_NKP,
          substr(WARTOSC,1,127) F_LOGO,
          substr(WARTOSC,1,30)  NAZWISKO,
          substr(WARTOSC,1,41)  IMIE,
          ' '                   PLEC,
          substr(WARTOSC,1,  1) CZY_ZAP
   from   SD_UPAR
   where  0=1
end sql

formula
   exec('merge','rap_zew',:RS,:INST,'PKD_ZASWSPOSOBWYPL')
end formula

end proc

proc praca_zd
desc
   Informacja o warunkach pracy zdalnej dla A1) informacja o warunkach pracy
end desc

params
   XR:='' STRING[16]
   XW:='' STRING[8]
end params

sql
   select ' ' C1, WARTOSC as TEKST
   from   XR_PAR
   where  RAPORT=:XR and WIERSZ=cast(:XW as INTEGER_TYPE) and NAZWA like 'PR_ZD_%'
end sql

formula
   {? :RS.first()
   || {!
      |? :RS.TEKST:=exec('str2val','#convert',:RS.TEKST);
         :RS.put();
         :RS.next()
      !}
   ?}
end formula

end proc


proc praca_zd_sd
desc
   Informacja o warunkach pracy zdalnej dla Aneksów do umowy o pracę
end desc

params
   XR:='' STRING[16]
   XW:='' STRING[8]
end params

sql
   select ' ' C1, WARTOSC as TEKST
   from   SD_UPAR
   where  SD_UINS=:XR and WIERSZ=cast(:XW as INTEGER_TYPE) and NAZWA like 'PR_ZD_%'
end sql

formula
   {? :RS.first()
   || {!
      |? :RS.TEKST:=exec('str2val','#convert',:RS.TEKST);
         {? +form(:RS.TEKST)
         || :RS.put();
            :RS.next()
         || :RS.del()
         ?}
      !}
   ?}
end formula

end proc

#Sign Version 2.0 jowisz:1045 2024/01/30 10:33:28 3c089757f8022aca3d7954aa657bc1ac97902dc71c0eb22ada38b3a8c59fdf49da109e32ec38a41b771c19b9998759d84cb2c25c68ab08cf3f2524d823c224d235dd87fa7f2e8cd7eb53a55c76f18bc8989e5d324d8ff8acf51a12529a082887534e7c1ae083153555d69e70b79e55f4820db3f297d352a535fe978def056c77
