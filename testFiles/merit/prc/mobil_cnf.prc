:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: mobil_cnf.prc [18.22]
# Utworzony: 21.02.2018
# Autor: [rr]
# Systemy: Merit-LMG
#=======================================================================================================================
# Zawartosc: Procedury konfiguracyjne do wymiany danych z urzadzeniami mobilnymi - ONLINE VERSION
#=======================================================================================================================


proc users

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę użytkowników urządzeń mobilnych - tylko aktywnych
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql

select
  USERS.IDADD as IDADD,
  USERS.KOD as KOD,
  USERS.DANE as DANE,
  USERS.IP as IDUSER,
  USERS.PASS as PASS
from USERS
where USERS.AKT='T'
  and USERS.MOBIL='T'
  and USERS.PASS<>''
order by 1

end sql

end proc


proc perm

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę uprawnień podanego użytkownika urządzeń mobilnych wg podanego IDADD-a
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  idadd:='' String[31], unikalny identyfikator użytkownika
end params

sql
  select
    SPACE(3) as KOD,
    SPACE(255) as OPIS
  from FIRMA
  where 2=1
end sql

formula
  {? (+:idadd)<>31
  || exec('addKO','magazyn_mob',:RS,'ERR','Niepoprawny unikalny identyfikator użytkownika - 31 znaków')
  || _user:=OPERATOR.USER;
     OPERATOR.USER:=exec('FindAndGet','#table',USERS,:idadd,,,null());
     {? OPERATOR.USER=null()
     || exec('addKO','magazyn_mob',:RS,'ERR','Użytkownik wg podanego identyfikatora nie został znaleziony')
     |? OPERATOR.USER().AKT<>'T'
     || exec('addKO','magazyn_mob',:RS,'ERR','Użytkownik wg podanego identyfikatora nie jest aktywny')
     |? OPERATOR.USER().MOBIL<>'T'
     || exec('addKO','magazyn_mob',:RS,'ERR'
         ,'Użytkownik wg podanego identyfikatora nie ma uprawnień do urządzeń mobilnych')
     || B_ACTION.cntx_psh();
        B_ACTION.index('UNIK');
        B_ACTION.prefix('LMO_MOM_');
        {? B_ACTION.first()
        || {!
           |? {? exec('chk_role','#b__box',OPERATOR.USER,B_ACTION.UID)
              || exec('addKO','magazyn_mob',:RS,B_ACTION.UID+3,B_ACTION.NAME)
              ?};
              B_ACTION.next()
           !}
        ?};
        B_ACTION.cntx_pop();
        _eanl:=exec('get','#params',4021,2,OPERATOR.USER);
        {? (+_eanl)=31
        || exec('addKO','magazyn_mob',:RS,'DUL',_eanl)
        || exec('addKO','magazyn_mob',:RS,'DUL','')
        ?}
     ?};
     OPERATOR.USER:=_user
  ?}
end formula

end proc


proc term

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: obsługa konfiguracji teminala - urządzenia mobilnego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  idterm:='' String[40], unikalny identyfikator urządzenia (Hardware)
end params

sql
  select
    SPACE(10) as KOD,
    SPACE(120) as OPIS,
    SPACE(120) as NAZ
  from FIRMA
  where 2=1
end sql

formula
  {? form(:idterm)=''
  || exec('addKO','magazyn_mob',:RS,'ERR','Nie podano identyfikatora urządzenia')
  || EANC.cntx_psh();
     EANC.index('IDTERM');
     EANC.prefix(:idterm,);
     {? EANC.first()
     || {? EANC.AKT<>'T'
        || exec('addKO','magazyn_mob',:RS,'ERR','Urządzenie nie jest aktywne')
        || exec('addKO','magazyn_mob',:RS,'NR',$EANC.NRC);
           exec('addKO','magazyn_mob',:RS,'OPIS',EANC.OPI);
           exec('addKO','magazyn_mob',:RS,'IDADD',EANC.IDADD);
           exec('addKO','magazyn_mob',:RS,'IDTERM',EANC.IDTERM);
           exec('addKO','magazyn_mob',:RS,'ODDZ',EANC.ODDZ().KOD);
           exec('addKO','magazyn_mob',:RS,'INTERVAL',$10);
           exec('addKO','magazyn_mob',:RS,'SYSTEM',EANC.SYSTEM);
           exec('addKO','magazyn_mob',:RS,'VERSYS',$EANC.VERSYS);
           exec('addKO','magazyn_mob',:RS,'ERP','Merit');
           exec('addKO','magazyn_mob',:RS,'MG',{? exec('FindInSet','#table','EANCMG','EANC',EANC.ref(),,,,,null())=null()
                                               || ''
                                               || 'Przypisano magazyny'
                                               ?});
           exec('addKO','magazyn_mob',:RS,'PRN',exec('eanc2PRN','magazyn_mobi',EANC.uidref()));
           exec('addKO','magazyn_mob',:RS,'MERITVER',exec('verINFiles','#upgrade');'23.11','Aktualna wersja Merit');
           FO_DEF.cntx_psh();
           FO_DEF.index('TAB');
           FO_DEF.prefix('A','Urządzenia mobilne',);
           {? FO_DEF.first()
           || {!
              |? exec('addKO','magazyn_mob',:RS,$FO_DEF.NR,FO_DEF.VALUE,FO_DEF.NAME);
                 FO_DEF.next()
              !}
           ?};
           FO_DEF.cntx_pop()
        ?}
     || EANC.index('NRC');
        _blnrc:={? EANC.first() & EANC.NRC<=0 || EANC.NRC-1 || 0 ?};
        EANC.blank();
        EANC.NRC:=_blnrc;
        EANC.AKT:='N';
        EANC.OPI:='Nowe urządzenie';
        EANC.IDTERM:=:idterm;
        {? EANC.add(1)
        || exec('addKO','magazyn_mob',:RS,'ERR','Merit');
           exec('addKO','magazyn_mob',:RS,'ERR','Zarejestrowano urządzenie (wymagana konfiguracja w systemie Merit)')
        || exec('addKO','magazyn_mob',:RS,'ERR','Nie podano identyfikatora urządzenia')
        ?}
     ?};
     EANC.cntx_pop()
  ?}
end formula

end proc


proc system

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę obsługiwanych systemów na urządzeniach mobilnych
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql
  select
    SPACE(20) as SYSTEM,
    0 as VERSYS
  from FIRMA
  where 2=1
  order by 1,2
end sql

formula
  {! _ii:=5..7
  |! :RS.blank();
     :RS.SYSTEM:='Windows CE';
     :RS.VERSYS:=_ii;
     :RS.add(1)
  !};
  {! _ii:=6..7
  |! :RS.blank();
     :RS.SYSTEM:='Windows Mobile';
     :RS.VERSYS:=_ii;
     :RS.add(1)
  !};
  :RS.blank();
  :RS.SYSTEM:='Android';
  :RS.VERSYS:=6;
  :RS.add(1)
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 51a4bf3e30e15bb2e2b8e7d2dfed4b799d83b6b58f550c64ce67507281846681cc2641e33c53cf0a5a5176bb37f45cc89fe228c01bb56468d7f4f640d48dc8d5c93e019ebc59228876e3e6c92a3d215b1e0c49910c994da02e9f4a237b9730820aa8c66f00d76364a4e8aed9f584e99d94897896d20d15f169cc3278373480e0
