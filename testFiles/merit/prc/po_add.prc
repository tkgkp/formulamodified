:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_add.prc [2011]
# Utworzony: 13.05.2010
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury dodajace pozycje planu
#=======================================================================================================================

proc plpart_add

desc
   Dodaje do tabeli PL_PART 1 rekord
end desc

params
   ZKP_REF:=''    STRING[16], Ref SQL pozycji zamowienia klienta
   ZL_REF:=''     STRING[16], Ref SQL zlecenia
   ILOSC:=0       REAL,       Ilosc na jaka jest przewodnik
   TKTL_REF:=''   STRING[16], Ref SQL karty technologicznej
   ZKTL_REF:=''   STRING[16], Ref SQL technologii zlecenia
   NAZWA:=''      STRING[60], Nazwa przewodnika,
   REF_ZGH:=''    STRING[16], Ref SQL przewodnika zlecenia
   M_REF:=''      STRING[16], Ref SQL materialu przewodnika
end params

sql
    select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_PART.cntx_psh();
   PL_PART.clear();
   ZK_P.cntx_psh();
   ZL.cntx_psh();
   ZGH.cntx_psh();
   TKTL.cntx_psh();
   ZKTL.cntx_psh();
   M.cntx_psh();
   PL_PART.blank();
#-----------ZK_P
   {? :ZKP_REF<>''
   || ZK_P.clear();
      {? ZK_P.seek(:ZKP_REF)
      || PL_PART.ZK_P:=ZK_P.ref();
         PL_PART.SQL_ZKP:=$ZK_P.ref();
         ~~
      ?}
   ?};
#-----------ZL
   {? :ZL_REF<>''
   || ZL.clear();
      {? ZL.seek(:ZL_REF)
      || PL_PART.ZL:=ZL.ref()
      ?}
   ?};
#-----------ILOSC
   _dokl:=exec('FindAndGet','#table',M,:M_REF,,"DOKL",0);
   PL_PART.ILOSC:=:ILOSC$_dokl;
#-----------TKTL
   {? :TKTL_REF<>''
   || TKTL.clear();
      {? TKTL.seek(:TKTL_REF)
      || PL_PART.TKTL:=TKTL.ref()
      ?}
   ?};
#-----------ZKTL
   {? :ZKTL_REF<>''
   || TKTL.clear();
      {? TKTL.seek(:ZKTL_REF)
      || PL_PART.TKTL:=TKTL.ref()
      ?}
   ?};
#-----------ZGH
   {? :REF_ZGH<>''
   || ZGH.clear();
      {? ZGH.seek(:REF_ZGH)
      || PL_PART.ZGH:=ZGH.ref()
      ?}
   ?};
#-----------M
   {? :M_REF<>''
   || M.clear();
      {? M.seek(:M_REF)
      || PL_PART.M:=M.ref()
      ?}
   ?};

#  Przyporzadkowanie PL_PARTa do PX_OBJ
   {? :ZKP_REF<>''
   || _obj:=null();
      ZK_P.cntx_psh();
      ZK_P.clear();
      {? ZK_P.seek(:ZKP_REF)
      || _obj:=exec('get_zkp_object','px_obj',ZK_P.ref());
         {? _obj=null()
         || exec('zkp2obj','px_obj');
            _obj:=exec('get_zkp_object','px_obj',ZK_P.ref())
         ?}
      ?};
      ZK_P.cntx_pop();
      PL_PART.PX_OBJ:=_obj
   ?};
   {? :ZL_REF<>''
   || _obj:=null();
      ZL.cntx_psh();
      ZL.clear();
      {? ZL.seek(:ZL_REF)
      || _obj:=exec('get_zl_object','px_obj',ZL.ref());
         {? _obj=null()
         || exec('zl2obj','px_obj');
            _obj:=exec('get_zl_object','px_obj',ZL.ref())
         ?}
      ?};
      ZL.cntx_pop();
      PL_PART.PX_OBJ:=_obj
   ?};
   PL_PART.NAZWA:=:NAZWA;
#-----------nie dodaje plparta ktory nie ma zlaczenia ani do zlecenia ani zamowienia
   {? (PL_PART.ZK_P<>null() | PL_PART.ZL<>null()) & PL_PART.ILOSC<>0
   || :RS.RESULT:=PL_PART.add();
      {? :RS.RESULT>0
      || :RS.REF:=$PL_PART.ref();
         {? PL_PART.ZL<>null()
         || PL_PART.ZL();
            ZL.PLAN_PO:='T';
            ZL.put();
            ZL.cntx_psh();
            _top:=exec('top_level','zl_link',PL_PART.ZL);
            {? _top<>PL_PART.ZL
            || ZL.prefix();
               {? ZL.seek(_top)
               || ZL.PLAN_PO:='T';
                  ZL.put()
               ?}
            ?};
            ZL.cntx_pop()
         ?}
      ?}
   |? PL_PART.ZK_P=null() | PL_PART.ZL=null()
   || :RS.RESULT:=-1
   |? PL_PART.ILOSC=0
   || :RS.RESULT:=-2
   ?};
   :RS.add();
   ZK_P.cntx_pop();
   ZL.cntx_pop();
   TKTL.cntx_pop();
   ZKTL.cntx_pop();
   ZGH.cntx_pop();
   M.cntx_pop();
   PL_PART.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc ploper_add

desc
   Dodaje do tabeli PL_OPER 1 rekord
end desc

params
   PL_PART:=''                STRING[16], Ref SQL PL_PARTa do ktorego nalezy ten PL_OPER
   DURATION:=0                REAL,       Czas trwania w minutach
   START:=''                  STRING[19], Czas rozpoczecia w planie
   END:=''                    STRING[19], Czas zakonczenia w planie
   TP:=0                      REAL,       Czas TP w minutach
   TZ:=0                      REAL,       Czas TZ w minutach
   SYMBOL:=''                 STRING[100],Symbol plopera
   OPIS:=''                   STRING[255],Opis plopera
   KOLOR:=''                  STRING[11], Kolor plopera
   OFFSET_P:=0                REAL,       Czas startu od punktu zero
   OFFSET_O:=0                REAL,       Czas startu wzgledem ostatniej operacji
   TOPER:=''                  STRING[16], Ref SQL operacji na technologii z ktorej pochodzi (TOPER)
   ZOPER:=''                  STRING[16], Ref SQL operacji na technologii z ktorej pochodzi (ZOPER)
   PLANNED:=''                STRING[1],  Czy operacja zostala poprawnie zaplanowana [T/N]
   ZGP:=''                    STRING[16], Ref SQL pozycji przewodnika z ktorej pochodzi
   GROUPKEY:=''               STRING[20], Klucz grupujacy operacje na tym samym poziomie
   TM_MIN:=''                 STRING[19], Minimalny poczatek  - string w formacie 'YYYY/MM/DD HH:MM:SS'
   TM_MAX:=''                 STRING[19], Maksymalny koniec - string w formacie 'YYYY/MM/DD HH:MM:SS'
   SYM_MIN:=''                STRING[30], Minimalny poczatek - symbol granicy
   SYM_MAX:=''                STRING[30], Maksymalny koniec - symbol granicy
   NUM:=0                     INTEGER,    Numer operacji w procesie
   TYP:=''                    STRING[1],  Rodzaj dodawanej operacji
   SINGLE:=''                 STRING[1],  Czy operacja zaplanowana pojedynczo
   ILOSC:=0                   REAL,       Ilosc w planie
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_PART.cntx_psh();
   PL_OPER.cntx_psh();
   TOPER.cntx_psh();
   ZOPER.cntx_psh();
   ZGP.cntx_psh();

   _can_continue:=0;
   _plpart:=null();
   PL_OPER.blank();
#-----------PL_PART
   {? :PL_PART<>''
   || PL_PART.clear();
      {? PL_PART.seek(:PL_PART)
      || PL_OPER.PL_PART:=PL_PART.ref();
         {? :ILOSC>0
         || PL_OPER.ILOSC:=:ILOSC
         || PL_OPER.ILOSC:=PL_PART.ILOSC
         ?};
         _plpart:=PL_PART.ref()
      ?}
   ?};
   PL_OPER.DURATION:=:DURATION;
   PL_OPER.UID:=exec('uid','#blank');
   PL_OPER.SINGLE:=:SINGLE;
   {? :START<>''
   || _tm_start:=exec('str2tm_stamp','libfml',:START);
      {? _tm_start>0
      || PL_OPER.STARTD:=exec('tm_stamp2date','#tm_stamp',_tm_start);
         PL_OPER.STARTT:=exec('tm_stamp2time','#tm_stamp',_tm_start);
         PL_OPER.TM_START:=_tm_start
      ?}
   ?};
   {? :END<>''
   || _tm_end:=exec('str2tm_stamp','libfml',:END);
      {? _tm_end>0
      || PL_OPER.ENDD:=exec('tm_stamp2date','#tm_stamp',_tm_end);
         PL_OPER.ENDT:=exec('tm_stamp2time','#tm_stamp',_tm_end);
         PL_OPER.TM_END:=_tm_end
      ?}
   ?};

   _tm_min:=exec('str2tm_stamp','libfml',:TM_MIN);
   _tm_max:=exec('str2tm_stamp','libfml',:TM_MAX);
   {? _tm_min>0
   || PL_OPER.MINDATE:=exec('tm_stamp2date','#tm_stamp',_tm_min);
      PL_OPER.MINTIME:=exec('tm_stamp2time','#tm_stamp',_tm_min)
   ?};
   {? _tm_max>0
   || PL_OPER.MAXDATE:=exec('tm_stamp2date','#tm_stamp',_tm_max);
      PL_OPER.MAXTIME:=exec('tm_stamp2time','#tm_stamp',_tm_max)
   ?};
   PL_OPER.SYM_MIN:=:SYM_MIN;
   PL_OPER.SYM_MAX:=:SYM_MAX;
   PL_OPER.TP:=:TP;
   PL_OPER.TZ:=:TZ;
   PL_OPER.SYMBOL:=:SYMBOL;
   PL_OPER.OPIS:=:OPIS;
   PL_OPER.KOLOR:=:KOLOR;
   PL_OPER.OFFSET_P:=:OFFSET_P;
   PL_OPER.OFFSET_O:=:OFFSET_O;
   PL_OPER.OFFSET_U:=:OFFSET_O;
   PL_OPER.NUM:=:NUM;
   PL_OPER.TYP:=:TYP;
#-----------TOPER
   {? :TOPER<>''
   || TOPER.clear();
      {? TOPER.seek(:TOPER)
      || PL_OPER.TOPER:=TOPER.ref()
      ?}
   ?};
#-----------ZGP
   {? :ZGP<>''
   || _zgp:=exec('FindAndGet','#table',ZGP,:ZGP,,,null());
      {? _zgp<>null()
      || PL_OPER.ZGP:=_zgp
      || :RS.RESULT:=-4
      ?}
   ?};
   PL_OPER.PLANNED:=:PLANNED;
   PL_OPER.GROUPKEY:=:GROUPKEY;
#-----------Dodawanie
   {? :RS.RESULT>=0
   || :RS.RESULT:=PL_OPER.add()
   ?};
   {? :RS.RESULT>0
   || :RS.REF:=$PL_OPER.ref()
   ?};
   {? PL_OPER.PL_PART=null()
   || :RS.RESULT:=-1
   ?};
   {? PL_OPER.DURATION<=0
   || :RS.RESULT:=-2
   ?};
   :RS.add();
   {? :RS.RESULT>0
   || exec('plpart_date_upd','po_plan',PL_OPER.PL_PART);
      exec('zgp_dates_upd','po_plan',PL_OPER.ref())
   ?};
   PL_PART.cntx_pop();
   PL_OPER.cntx_pop();
   TOPER.cntx_pop();
   ZOPER.cntx_pop();
   ZGP.cntx_pop()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc ploper_spe_add

desc
   Dodaje do tabeli PL_OPER rezerwacje, bufory, remonty
end desc

params
   DURATION:=0    REAL,       Czas trwania w minutach
   STARTD         DATE,       Data startu
   STARTT         TIME,       Czas startu
   ENDD           DATE,       Data konca
   ENDT           TIME,       Czas konca
   SYMBOL:=''     STRING[30], Symbol plopera
   OPIS:=''       STRING[40], Opis plopera
   KOLOR:=''      STRING[11], Kolor plopera
   TYP:=''        STRING[20], Typ operacji 'T' - 'TechDay', 'R' - 'Reservation', 'B' - 'Buffer'
   PL_EVENR:=''   STRING[16], Wskazanie na zdarzenie w planie
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OPER.blank();
   PL_OPER.DURATION:=:DURATION;
   PL_OPER.STARTD:=:STARTD;
   PL_OPER.STARTT:=:STARTT;
   PL_OPER.ENDD:=:ENDD;
   PL_OPER.ENDT:=:ENDT;
   PL_OPER.TM_START:=exec('create','#tm_stamp',PL_OPER.STARTD,PL_OPER.STARTT);
   PL_OPER.TM_END:=exec('create','#tm_stamp' ,PL_OPER.ENDD  ,PL_OPER.ENDT  );
   PL_OPER.SYMBOL:=:SYMBOL;
   PL_OPER.OPIS:=:OPIS;
   PL_OPER.KOLOR:=:KOLOR;
   PL_OPER.PLANNED:='T';
   PL_OPER.TYP:=:TYP;
   _pl_evenr:=exec('FindAndGet','#table',PL_EVENR,:PL_EVENR,,,null());
   PL_OPER.PL_EVENR:=_pl_evenr;
#-----------Dodawanie
   :RS.RESULT:=PL_OPER.add();
   {? :RS.RESULT>0
   || :RS.REF:=$PL_OPER.ref()
   ?};
   {? PL_OPER.DURATION<=0
   || :RS.RESULT:=-1
   ?};
   :RS.add();
   PL_OPER.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------


proc ploz_add

desc
   Dodaje do tabeli PL_OZ 1 rekord
end desc

params
   PL_OPER:=''    STRING[16], Ref SQL planowanej operacji   [PL_OPER]
   PL_RES:=''     STRING[16], Ref SQL zasobu planistycznego [PL_RES]
   ZAM:=0      REAL, Czy Ploper zmienił czas trwania w wyniku przeciągnięcia go na zamiennik
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF,
      SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   _can_continue:=1;
   PL_OZ.cntx_psh();
   PL_OZ.clear();
   PL_OPER.cntx_psh();
   PL_RES.cntx_psh();
   PL_OZ.blank();
#-----------PL_OPER
   {? :PL_OPER<>''
   || PL_OPER.clear();
      {? PL_OPER.seek(:PL_OPER)
      || PL_OZ.PL_OPER:=PL_OPER.ref()
      ?}
   ?};
#-----------PL_RES
   {? :PL_RES<>''
   || PL_RES.clear();
      {? PL_RES.seek(:PL_RES)
      || PL_OZ.PL_RES:=PL_RES.ref()
      ?}
   ?};
   {? PL_OZ.PL_OPER=null()
   || _can_continue:=-1
   ?};
   {? PL_OZ.PL_RES=null()
   || _can_continue:=-2
   ?};
   {? _can_continue>0
   || PL_OZ.TM_START:=PL_OZ.PL_OPER().TM_START;
      PL_OZ.TM_END:=PL_OZ.PL_OPER().TM_END;
      _can_continue:=PL_OZ.add();
      :RS.REF:=$PL_OZ.ref()
   ?};

   PL_OPER.cntx_psh();
   {? _can_continue>0 & PL_OZ.PL_OPER().PL_EVENR<>null()
   || _can_continue:=exec('plan_add','po_event',PL_OZ.PL_OPER().PL_EVENR,PL_OZ.ref())
   ?};
   PL_OPER.cntx_pop();

   {? _can_continue>0
   ||
#     Dodaje PL_OPERa do planu strategicznego
      _mainver:=exec('get_mainversion','px_ver');
      {? exec('ploper2pxpoz','px_tie',PL_OZ.PL_OPER,_mainver)>0
      ||
#        Oznaczam kolejke ze trzeba przeliczyc
         exec('mod_stamp_queue','px_ver',_mainver)
      ?};

      {? :ZAM>0 & PL_OZ.PL_OPER().ZGP<>null()
      ||
#        Obsługa zamienników
         _can_continue:=exec('update4ploz','zl_guide',PL_OPER.ZGP,PL_OZ.ref())
      ?};
      ~~
   ?};

   {? _can_continue>0
   || :RS.KONFPLUG:=exec('konfplug_update','po_plan',,'ADD')
   ?};

   :RS.RESULT:=_can_continue;
   :RS.add();
   PL_OPER.cntx_pop();
   PL_RES.cntx_pop();
   PL_OZ.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc plnext_add

desc
   Dodaje do tabeli PL_NEXT 1 rekord
end desc

params
   PL_OPER:=''    STRING[16], Ref SQL planowanej operacji         [PL_OPER]
   NEXT:=''       STRING[16], Ref SQL nastepnej operacji          [PL_OPER]
   PL_OGR:=''     STRING[16], Ref SQL planowanej grupy operacji   [PL_OGR]
   NEXT_OGR:=''   STRING[16], Ref SQL nastepnej grupy operacji    [PL_OGR]
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_NEXT.cntx_psh();
   PL_OPER.cntx_psh();
   _ploper:=null();
   _ploperNext:=null();
   _plogr:=null();
   _plogrNext:=null();
   :RS.blank();
   :RS.RESULT:=1;
   {? :PL_OPER<>''
   || _ploper:=exec('FindAndGet','#table',PL_OPER,:PL_OPER,,,null())
   ?};
   {? :NEXT<>''
   || _ploperNext:=exec('FindAndGet','#table',PL_OPER,:NEXT,,,null())
   ?};
   {? :PL_OGR<>''
   || _plogr:=exec('FindAndGet','#table',PL_OGR,:PL_OGR,,,null())
   ?};
   {? :NEXT_OGR<>''
   || _plogrNext:=exec('FindAndGet','#table',PL_OGR,:NEXT_OGR,,,null())
   ?};

#  Sprawdzam czy nie ma przypadkiem juz takiego
   PL_NEXT.index('OPER_OGR');
   PL_NEXT.prefix(_ploper,_ploperNext,_plogr,_plogrNext);
   {? PL_NEXT.size()=0
   ||
      PL_NEXT.blank();
      PL_NEXT.PL_OPER:=_ploper;
      PL_NEXT.NEXT:=_ploperNext;
      PL_NEXT.PL_OGR:=_plogr;
      PL_NEXT.NEXT_OGR:=_plogrNext;
      :RS.RESULT:=PL_NEXT.add(1)
   ?};
   {? :RS.RESULT>0
   ||
#     Aktualizacja tm_stamp na PL_NEXT
      {? PL_NEXT.PL_OPER<>null()
      || exec('next_tm_oper','po_plan',PL_NEXT.PL_OPER)
      ?};
      {? PL_NEXT.PL_OGR<>null()
      || exec('next_tm_ogr','po_plan',PL_NEXT.PL_OGR)
      ?};
      :RS.REF:=$PL_NEXT.ref()
   ?};
   :RS.add();
   PL_OPER.cntx_pop();
   PL_NEXT.cntx_pop()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc plogr_add

desc
   Dodaje do tabeli PL_OGR 1 rekord
end desc

params
   GROP:=''    STRING[16], Ref SQL grupy operacji
   PL_RES:=''  STRING[16], Ref SQL zasobu planistycznego
   DURATION:=0 REAL, czas trwania w minutach
   ILOSC:=0    REAL, ilosc
   SYMBOL:=''  STRING[100], Symbol grupy
   OPIS:=''    STRING[100], Opis grupy
   STARTD      DATE, Data startu
   STARTT      TIME, Czas startu
   ENDD        DATE, Data konca
   ENDT        TIME, Czas konca
   KOLOR       STRING[11], Kolor grupy
   TM_MIN:=''     STRING[19], Minimalny poczatek  - string w formacie 'YYYY/MM/DD HH:MM:SS'
   TM_MAX:=''     STRING[19], Maksymalny koniec - string w formacie 'YYYY/MM/DD HH:MM:SS'
   SYM_MIN:=''    STRING[30], Minimalny poczatek - symbol granicy
   SYM_MAX:=''    STRING[30], Maksymalny koniec - symbol granicy
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 1=0
end sql

formula
   PL_OGR.cntx_psh(); PL_OGR.clear();
   PL_OGR.blank();
   PL_OGR.GROP:=exec('FindAndGet','#table',GROP,:GROP,,,null());
   PL_OGR.PL_RES:=exec('FindAndGet','#table',PL_RES,:PL_RES,,,null());
   PL_OGR.DURATION:=:DURATION;
   PL_OGR.ILOSC:=:ILOSC;
   PL_OGR.SYMBOL:=:SYMBOL;
   PL_OGR.OPIS:=:OPIS;
   PL_OGR.STARTD:=:STARTD;
   PL_OGR.STARTT:=:STARTT;
   PL_OGR.ENDD:=:ENDD;
   PL_OGR.ENDT:=:ENDT;
   PL_OGR.KOLOR:=:KOLOR;

   _tm_min:=exec('str2tm_stamp','libfml',:TM_MIN);
   _tm_max:=exec('str2tm_stamp','libfml',:TM_MAX);

   {? _tm_min>0
   || PL_OGR.TM_MIN:=_tm_min
   ?};
   {? _tm_max>0
   || PL_OGR.TM_MAX:=_tm_max
   ?};
   PL_OGR.SYM_MIN:=:SYM_MIN;
   PL_OGR.SYM_MAX:=:SYM_MAX;

   :RS.blank();
   {? PL_OGR.GROP=null()
   || :RS.RESULT:=-2
   |? PL_OGR.PL_RES=null()
   || :RS.RESULT:=-1
   || :RS.RESULT:=PL_OGR.add()
   ?};
   {? :RS.RESULT>0
   || :RS.REF:=$PL_OGR.ref();
#     Aktualizacja ilosci zaplanowanej na GROP
      exec('update_grop_ilp','po_ogr',PL_OGR.GROP);

#     Dodaje PL_OGRa do planu strategicznego
      _mainver:=exec('get_mainversion','px_ver');
      exec('plogr2pxpoz','px_tie',PL_OGR.ref(),_mainver);
      ~~
   ?};
   :RS.add();
   PL_OGR.cntx_pop();
   ~~
end formula

end proc


#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 3e6a9a3847f0a4f5657aeebc2eaf0804d885c1025e3beb70774fd2e5694bd843f3f34b46138da47991c05d06d694d4e19d06e17aab2ae5c175a9042ff6a8c79b2586521899275d258cbcc5047f8c3f9961d871c0b16109a257cfc8b5d1d69336b5effbc1578f64cd3d3b0ad7fcb7215264db9ef773a587cab4ce0f9e89b48b07
