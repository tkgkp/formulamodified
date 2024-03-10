:!UTF-8
proc prac_nad

desc
   Procedura zwracająca tabelę z listą ref pracowników i ref ich przełożonych
#---------------------------------------------------------------------------------------
#  UTW: mafilo [22.26]
# OPIS: Procedura zwracająca tabelę z listą ref pracowników i ref ich przełożonych.
#   WE:
#   WY: tabela z listą ref pracowników i ref ich przełożonych
#---------------------------------------------------------------------------------------

end desc

sql
   select
      space(16) as 'PRAC_REF',
      space(16) as 'PRZE_REF'
   from
      syslog
   where
      1=2
end sql

formula
   P.cntx_psh();
   P.index('OSOBA');
   P.prefix();
   {? P.first()
   || {!
      |? _SZEF:=exec('prac_nad','stanprac',P.ref(),
            'dodatkowe=0,zastępstwa=0,nieobecni=1'
         );
         _SZEF.prefix(1);
         _loop:=_SZEF.first();
         {!
         |? _loop
         |! :RS.blank();
            :RS.PRAC_REF:=$P.ref;
            :RS.PRZE_REF:=_SZEF.P_SQL;
            :RS.add();
            _loop:=_SZEF.next()
         !};
         obj_del(_SZEF);
         &_SZEF;
         P.next()
      !}
   ?};
   P.cntx_pop()
end formula

end proc


proc dni_zasilkowe
desc
   Procedura zwracająca tabelę z listą sqlref pracowników, liczbę wykorzystanych dni zasiłkowych
   oraz liczbę dni zasiłkowych do limitu.
#-----------------------------------------------------------------------------------------------------------------------
#  UTW: igptasze
# OPIS: Procedura zwracająca tabelę z listą sqlref pracowników, liczbą wykorzystanych dni zasiłkowych
#       oraz liczbą dni zasiłkowych do limitu.
#   WE:
#   WY: tabela z listą sqlref pracowników, liczbą wykorzystanych dni zasiłkowych i liczbą dni do osiągnięcia limitu
#-----------------------------------------------------------------------------------------------------------------------

end desc

sql
   select
      space(16) as 'PRAC_REF',
      0 as 'ZASILKOWE',
      0 as 'DO_LIMITU'
   from
      syslog
   where
      1=2
end sql

formula
exec('__RUB','object');
exec('czytaj','#stalesys',,KST_PAR,'WALORYZ');
_data:=date();
_ile_dni:=60;
P.cntx_psh();
P.prefix();
N.cntx_psh();
N.index('NIEOBECN');
{? P.first()
|| {! |? {? P.ZA='T'
      || N.prefix('N',P.ref());
         _pref:=P.ref();
         _dni_zasil:=0;
         _RetVal:=date(0,0,0);
         _limit:=KST_PAR.WALORYZ;
            {? N.last() & N.DO+_ile_dni>=_data
            || _RetVal:=N.OD;
               _nref:=N.ref();
               {? __RUB.sys_attr(N.NB,126,N.OD)
               || _dni_zasil:=N.NK
               || _dni_zasil:=0
               ?};
               _kodch:=N.KDCH().KOD;
               {!
               |? {? N.prev() & N.DO+_ile_dni>=_RetVal
                  || _curKod:=N.KDCH().KOD;

                     {? __RUB.sys_attr(N.NB,126,N.OD)
                        &
                        (_ile_dni=1 | {? exec('sprawdz_2022','nieobecnosc',_nref)
                                      || _RetVal-1=N.DO | _kodch*'A'
                                      || ~(_kodch*'B' & _curKod<>_kodch)
                                      ?}
                        )
                     || _dni_zasil+=N.NK;
                        _kodch:=_curKod;
                        _RetVal:=N.OD;
                        1
                     || _ile_dni>1
                     ?}
                  ?}
               !};
               _limit:= {? (_kodch*'B' & N.OD~1>=2009) | _kodch*'D' || 270 || KST_PAR.WALORYZ ?}
            ?};
         :RS.PRAC_REF:=$_pref;
         :RS.ZASILKOWE:=_dni_zasil;
         :RS.DO_LIMITU:=(_limit-_dni_zasil);
         :RS.add()
         ?};
      P.next()
   !}
?};
N.cntx_pop();
N.get();
P.cntx_pop();
obj_del(__RUB);
&__RUB
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 5f95dcec91ce3f422e3811c21c6fea5d8f253096a832aab263f799dc542d0755416bb82e836437743aaf591031719b7c67ee9db8281cedaf5975eadc2b56c3073e9a0044452765d4b21e8a4a26863d9ffca3408d6b3e9dd8a069c8afe5369acedf4c6567380344d6f6ca37541134af3e02acba39906039791ee11ceabd249953
