:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: fks_ksp_deat.prc
# Utworzony: 18.10.2022
# Autor: AFI
#========================================================================================================================
# Zawartosc: Procedury pomocniczne do aktualizacji sprawozdania
#========================================================================================================================

proc akt_adm_prc
desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: AFI [23.25]
:: OPIS: Aktualizacja sprawozdań z okna administracja formuła lub źródła ODBC
::----------------------------------------------------------------------------------------------------------------------
end desc
params
   w_sch:='' String[16], Ref W_SCH Wielofirmowość - konsolidacja - schemat grupy kapitałowej
   gr_sik:='' String[10], Kod nagłówka sprawozdania
   powiazan:='' String[1], Aktualizacja powiązanych 'T'
   dataod DATE, Data od
   datado DATE, Data do
   zapisywa:='' String[1], Czy wartości param? 'T'
   tylko_mc:=0 Integer, Aktualizować inne niż miesięczne
   zamykac:=0 Integer, Zamykać okresy
   wart_jed:='' String[1], Jednostkowe - Znacznik, czy aktualizować sprawozdanie jednostkowe
   wart_wyl:='' String[1], Wyłączenia - Znacznik, czy aktualizować wyłączenia
   wart_sko:='' String[1], Konsolidacja - Znacznik, czy aktualizować sprawozdanie konsolidacyjne
end params
sql
  select
    FORMULA.FORMULA as WYNIK
  from
    FORMULA
  where 1=0
end sql
formula
   :RS.blank(1); :RS.WYNIK:='';
   SIK.GR_SIK:=null;
   {? :RS.WYNIK='' & ~exec('hasAction','users','FKS_KSP_DEAT',OPERATOR.USER)
   || :RS.WYNIK:='Brak uprawnień do czynności FKS_KSP_DEAT.'
   ?};
   {? :RS.WYNIK='' & :gr_sik<>''
   || GR_SIK.cntx_psh(); GR_SIK.index('SKROT'); GR_SIK.prefix(REF.FIRMA,:gr_sik,);
      {? GR_SIK.first()
      || SIK.GR_SIK:=GR_SIK.ref()
      || :RS.WYNIK:='Nie znaleziono sprawozdania o skrócie %1'@[:gr_sik]
      ?};
      GR_SIK.cntx_pop()
   ?};
   {? :RS.WYNIK=''
   || {? :dataod=date(0,0,0) || :dataod:=date() ?};
      {? :datado=date(0,0,0) || :datado:=date() ?};
      {? :dataod>:datado || :RS.WYNIK:='Błędny zakres dat.' ?}
   ?};
   {? :RS.WYNIK=''
   || _rokod:=_okrod:=_rokdo:=_okrdo:=null;
      exec('szuk_okr','okresy',:dataod);
      {? ROZNE.UT_OKROD || _rokod:=ROZNE.UT_OKROD().ROK; _okrod:=ROZNE.UT_OKROD ?};
      exec('szuk_okr','okresy',:datado);
      {? ROZNE.UT_OKROD || _rokdo:=ROZNE.UT_OKROD().ROK; _okrdo:=ROZNE.UT_OKROD ?};
      ROZNE.UT_ROKOD:=_rokod; ROZNE.UT_ROKDO:=_rokdo;
      OKRESY.CZY_PAR:=:zapisywa;
      OKRESY.AKT_POW:=:powiazan;
      OKRESY.ZAM:=:zamykac;
      OKRESY.AKT_INNE:=:tylko_mc;
      OKRESY.KONS1:=:wart_jed;
      OKRESY.KONS2:=:wart_wyl;
      OKRESY.KONS3:=:wart_sko;
      exec('czytaj','#stalesys',,XINFO);
      exec('czytaj','#stalesys',,FINFO);
      _ar:=SSTALE.AR; _ao:=SSTALE.AO;
      OKRO_F.cntx_psh(); OKRO_F.index('ROK');
      ROK_F.cntx_psh(); ROK_F.index('ROKPOCZ'); ROK_F.prefix(REF.FIRMA);
      {? ROK_F.seek(ROZNE.UT_ROKOD)
      || {! |?
            OKRO_F.prefix(ROK_F.ref());
            {? OKRO_F.first()
            || OKRESY.OKRES_OD:=OKRESY.OKRES_DO:=null;
               {? ROK_F.ref()=ROZNE.UT_ROKOD || OKRESY.OKRES_OD:=_okrod ?};
               {? ROK_F.ref()=ROZNE.UT_ROKDO || OKRESY.OKRES_DO:=_okrdo ?};
               {? ~OKRESY.OKRES_OD & OKRO_F.first() & OKRO_F.next() || OKRESY.OKRES_OD:=OKRO_F.ref() ?};
               {? ~OKRESY.OKRES_DO & OKRO_F.last() & OKRO_F.prev() || OKRESY.OKRES_DO:=OKRO_F.ref() ?};
               {? OKRESY.OKRES_OD & OKRESY.OKRES_DO
               || SSTALE.AR:=OKRESY.ROK1:=ROK_F.ref; SSTALE.AO:=OKRESY.OKRES_OD;
                  exec('open_tabele','open_tab');
                  exec('dod_okr','!fks_ksp_deat');
                  _params:=exec('mp_run_a','#b__box');
                  _params.ACT_UID:='FKS_KSP_DEAT';
                  _params.AKCJA:='Procedura';
                  _params.UIDREF:=exec('get_key','sprfin');
                  _params.CONTEXT:=obj_new('WYNIK');
                  _params.CONTEXT.WYNIK:='';
                  _params.PORTS_IN:=exec('portsIn','#b__box',_params.ACT_UID);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'FIRMA',exec('firma_ref','#firma',app_info('app_ident')));
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'W_SCH',exec('FindAndGet','#table',W_SCH,:w_sch,,,null()));
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'GR_SIK',SIK.GR_SIK);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'POWIAZANE',OKRESY.AKT_POW='T');
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'OKRES_OD',OKRESY.OKRES_OD);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'OKRES_DO',OKRESY.OKRES_DO);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'ZAPISYWAC',OKRESY.CZY_PAR='T');
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'TYLKO_MC',OKRESY.AKT_INNE);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'ZAMYKAC',OKRESY.ZAM);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'WART_JEDN',OKRESY.KONS1);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'WART_WYL',OKRESY.KONS2);
                  exec('portsInSet','#b__box',_params.PORTS_IN,_params.ACT_UID,'WART_SKONS',OKRESY.KONS3);
                  exec('mp_run','#b__box',_params);
                  obj_del(_params);
                  :RS.WYNIK:='Aktualizacja danych zakończona.'
               ?}
            ?};
            ROK_F.ref()<>ROZNE.UT_ROKDO & ROK_F.next()
         !}
      ?};
      {? SSTALE.AR<>_ar | SSTALE.AO<>_ao
      || SSTALE.AR:=_ar; SSTALE.AO:=_ao;
         exec('open_tabele','open_tab')
      ?};
      ROK_F.cntx_pop(); OKRO_F.cntx_pop()
   ?};
   {? :RS.WYNIK<>'' || :RS.add() ?}
end formula
end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 9eed6fbacbeddfb2d8f6a41198602c838c95938990d7c38cd830b87f299512218816cdf6ab6671ff62afd6422ff6cd0296723b994c480181a9dec8ac91a8d49d336f9bf612cf0f7b84b87f971d853abcc890b58a022b4b450b701918fc563ee663dabbe7cad80d22224cb31029238ab6a98a0663f3691383b1294c1afcbe71d7
