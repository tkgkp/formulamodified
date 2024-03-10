:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_utils.prc [2010]
# Utworzony: 28.05.2009
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury do funkcji planowania w javie, rozne funkcje pomocnicze
#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------

proc dept_unlock

desc
   Odblokowanie wydzialu
end desc

params
   REF String[16], UD_SKL.ref() - ref wydzialu
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   UD_SKL.cntx_psh();
   UD_SKL.clear();
   {? UD_SKL.seek(:REF)
   || :RS.blank();
      exec('unlock','po_plan',UD_SKL.ref());
      :RS.RESULT:=1;
      :RS.add()
   ?};
   UD_SKL.cntx_pop()
end formula
end proc


#-----------------------------------------------------------------------------------------------------------------------

proc check_ses

desc
   Sprawdza czy sesja o podanym identyfikatorze jest jeszcze aktywna
end desc

params
   SES_ID String[255], identyfikator sesji
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   _session:=exec('ascii_to_string','#string',:SES_ID);
   {? KAL_UD.ses_info(_session,'exist')
   || :RS.RESULT:=1
   || :RS.RESULT:=0
   ?};
   :RS.add()
end formula
end proc

#-----------------------------------------------------------------------------------------------------------------------

proc getevents

desc
   Zwraca zdarzenia (wysylki, remonty itp)
end desc

params
   WYDZIAL:='' String[16], Kod wydziału
end params

sql
   select
      '1234567890123456' as REFZKN,
      '1234567890123456' as REFZKP,
      '1234567890123456' as REFZL,
      TO_DATE('2000/1/1') as DATA,
      TO_TIME('0:0:0') as TIME,
      TO_DATE('2000/1/1') as STARTD,
      TO_DATE('2000/1/1') as ENDD,
      '                                                  ' as KH,
      '                                                                                       ' as OPIS,
      '                                        ' as KOLOR,
      '    ' as TYP
   from SYSLOG
   where 1=0
   order by TYP,TIME
end sql

formula
   _wyd:=exec('szukaj_ud_skl','schemat','PODZORG',:WYDZIAL);
   ZK_N.cntx_psh();
   ZK_P.cntx_psh();
   ZL.cntx_psh();
   ZLZAM.cntx_psh();
#########################################################################zamowienia
   ZK_N.index('DP');
   ZK_N.prefix('A');
   {? ZK_N.first()
   || {!
      |?
         {? ZK_N.AKC='T'
         ||
# -----------------------------------------------------------------------powolanie
            :RS.blank();
            :RS.DATA:=ZK_N.DP;
            :RS.REFZKN:=$ZK_N.ref();
            :RS.KH:=ZK_N.KH().SKR;
            {? ZK_N.ZAM_KL<>''
            || :RS.OPIS:=:RS.KH+' - '+ZK_N.ZAM_KL
            || :RS.OPIS:=:RS.KH+' - '+ZK_N.SYM
            ?};
            :RS.KOLOR:=ZK_N.KOLOR;
            :RS.TYP:='ZK_P';
            :RS.add();
# -----------------------------------------------------------------------termin realizacji
            :RS.DATA:=ZK_N.DT;
            :RS.TYP:='ZK_T';
            :RS.add()
         ?};
         ZK_N.next()
      !}
   ?};
#########################################################################zlecenia
   ZL.index('DATAO');
   ZLZAM.index('ZLZM');
   {? ZL.first()
   || {!
      |?
# -----------------------------------------------------------------------otwarcie
         :RS.blank();
         :RS.DATA:=ZL.OD;
         ZLZAM.prefix(ZL.ref());
         :RS.KH:=ZL.KH().SKR;
         :RS.KOLOR:=ZL.KH().KOLOR;
         {? ZLZAM.first()
         || ZK_P.clear();
            {? ZK_P.seek(ZLZAM.ZAMPOZ,ZK_P.name())
            || :RS.REFZKN:=$ZK_P.N().ref();
               :RS.REFZKP:=$ZK_P.ref();
               :RS.KOLOR:=ZK_P.N().KOLOR;
               {? ZL.KH=null()
               || :RS.KH:=ZK_P.N().KH().SKR
               ?}
            ?}
         ?};
         :RS.REFZL:=$ZL.ref();
         {? ZL.KH<>null()
         || :RS.OPIS:=ZL.KH().SKR+' - '+ZL.SYM
         || :RS.OPIS:=ZL.SYM
         ?};
         :RS.TYP:='ZL_P';
         :RS.add();
# -----------------------------------------------------------------------zamkniecie
         :RS.DATA:=ZL.DO;
         :RS.TYP:='ZL_T';
         :RS.add();
         ZL.next()
      !}
   ?};
   ZLZAM.cntx_pop();
   ZL.cntx_pop();
   ZK_P.cntx_pop();
   ZK_N.cntx_pop()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc getdepts

desc
   Zwraca wydzialy na ktorych mozliwe jest planowanie (potrzebne do pracy na dwoch wydzialach)
end desc

sql
   select
/*----------------PlanContainer.java*/
/*1*/ '                 ' as SYM,
/*2*/ '                                                                                    ' as NAZ,
/*3*/ '                 ' as KAL_NAZ,
/*4*/ '                 ' as PL_WZOR,
/*5*/ '          ' as JM_KOD,
/*6*/ '          ' as JM_SYM,
/*7*/ '                                                            ' as FINPOWER,
/*8*/ '1234567890123456' as REF_UD,
/*9*/ '1234567890123456' as REF_KALU,
/*10*/ '  ' as PL_RODZ,
/*11*/ 0 as PARALLEL,
/*12*/ '1234567890123456' as KAL_REF,
/*13*/ ' ' as KAL_FROM,
/*14*/ ' ' as LAYERS
   from SYSLOG
   where 1=0
end sql

formula
   KAL_UD.cntx_psh();
   KAL_UD.index('RORWYD');
   KAL_UD.clear();
   KAL_UD.prefix('W');
   {? KAL_UD.first()
   || {!
      |? {? KAL_UD.PL_WZOR<>null
         || :RS.blank();
            :RS.SYM:=KAL_UD.UD_SKL().SYMBOL;
            :RS.NAZ:=KAL_UD.UD_SKL().OPIS;
            :RS.KAL_NAZ:=KAL_UD.KAL().NAZWA;
            :RS.PL_WZOR:=KAL_UD.PL_WZOR().NAZWA;
            :RS.JM_KOD:=KAL_UD.JM().KOD;
            :RS.JM_SYM:=KAL_UD.JM().NAZ;
            :RS.FINPOWER:=KAL_UD.FINPOWER;
            :RS.REF_UD:=$KAL_UD.UD_SKL;
            :RS.REF_KALU:=$KAL_UD.ref();
            :RS.PL_RODZ:=KAL_UD.PL_RODZ;
            :RS.KAL_FROM:='P';
            :RS.add()
         ?};
         KAL_UD.next()
      !}
   ?};
   KAL_UD.cntx_pop()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc trans_do

desc
   Rozpoczyna transakcje, lub nie
end desc

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
#---------nie bylo transakcji wiec ja rozpoczynam
   {? do_state()=0
   || do();
      :RS.RESULT:=1
#---------transakcja juz rozpoczeta
   |? do_state()=1
   || :RS.RESULT:=1
#---------transakcja zerwana
   |? do_state()=2
   || :RS.RESULT:=0
   ?};
   :RS.add()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc trans_undo

desc
   Anuluje transakcje
end desc

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   undo();
   :RS.RESULT:=1;
   :RS.add()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc trans_end

desc
   Konczy transakcje
end desc

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=end();
   :RS.add()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc time

desc
   Zwraca czas na serwerze w formacie STRING 'YYYY/MM/DD HH:MM:SS'
end desc


sql
   select
/*1*/   '1234567890123456789' as TIME_STR
   from SYSLOG
   where 1=0
end sql

formula
   :RS.blank();
   :RS.TIME_STR:=exec('to_string','#tm_stamp',PL_OPER.tm_stamp());
   :RS.add();
   ~~
end formula

end proc


#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 26a8be82fbaad1976f1d29954c81a9963ca451fecbe97452b1ff126a4ded5c1d4808ac72762472905a0fefd1523309a43a17b2d42b9f2546ae5061c865991cf05e6e5b8f8c55313f12639f74b2c20e61af908b66b99630e86a46da71b53a9f54c74acf6461a79150d037b887ba7ae0987210fa2e572972b75b6343419d1f123a
