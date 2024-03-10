:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_ogr.prc []
# Utworzony: 26.06.2012
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury do obslugi grup operacji
#=======================================================================================================================


proc get_grops

desc
   Zwraca grupy operacji do zaplanowania
end desc

params
   FILTER:='' STRING[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   PLAN:=0    INTEGER, 0 - pobierac tylko niezaplanowane, 1 - pobierac tylko zaplanowane
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '                           ' as TYP,
/*3*/    '                                                                                                              ' as NAZWA,
/*4*/    '255:255:255' as KOLOR_B,
/*5*/    '0:0:0      ' as KOLOR_T,
/*6*/    0 as LEVEL,
/*7*/    0 as ID,
/*8*/    0 as PAR,
/*9*/    ' ' as BLK,
/*10*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*--------------PlannedTreeNode.java*/
/*11*/ '1234567890123456' as REF,
/*12*/ 0 as MPS,
/*13*/ '1234567890123456789' as MPSSTART,
/*14*/ '1234567890123456789' as MPSEND,
/*15*/ 0 as DIR,
/*16*/ '1234567890123456789' as PL_START,
/*17*/ '1234567890123456789' as PL_END,
/*18*/ '                                         ' as KH,
/*19*/ '1234567890123456' as REF_M,
/*20*/ 0 as PLPARTS,
/*21*/ ' ' as PL_GROP,
/*22*/ 0 as SAVE_B,
/*23*/ '1234567890123456789' as TERMIN,
/*24*/ 0 as GROP_OK,
/*25*/ CAST (0 AS REAL_TYPE) as ILOSC_PL,
/*26*/ 0 as GROP_OK2,
/*27*/ 0 as DOKL,
/*28*/ '                                                   ' as KTM,
/*29*/ '          ' as JM,
/*30*/ ' ' as SINGLE,
/*--------------GropNode.java*/
/*11*/ '1234567890123456' as REF,
/*15*/ '1234567890123456' as TTOPER,
/*16*/ CAST (0 AS REAL_TYPE) as DUR_MIN,
/*18*/ ' ' as AKC,
/*21*/ '                                                                                                         ' as PLRESSYM,
/*22*/ '                                                                                                         ' as PLRESNAZ,
/*23*/ '255:255:255' as KOLOR_TO,
/*24*/ CAST (0 AS REAL_TYPE) as ILW
   from SYSLOG
   where 1=0
end sql

formula
   ZL.cntx_psh();
   ZGH.cntx_psh();
   M.cntx_psh();
   PL_RES.cntx_psh();
   GROPP.cntx_psh();
   GROPP.index('GROP');
   GROP.cntx_psh();
   GROP.index('KOD');
#  Pobieram grupy tylko otwarte
   GROP.prefix('O');

   GROPS.cntx_psh();
   GROPS.index('GROP');

   PL_OGR.cntx_psh();
   PL_OGR.index('GROP');
   {? GROP.first()
   || _id:=0;
      {!
      |? _filter1:=0;
         _filter2:=1;
         {? :PLAN=0
         || _filter1:={? GROP.ILP<GROP.IL & GROP.ILW=0 || 1 || 0 ?}
         |? :PLAN=1
         || _filter1:={? GROP.ILP>0 || 1 || 0 ?}
         ?};
         {? :FILTER<>''
         || _fil_lower:=-(:FILTER);
            {? (-GROP.KOD)*_fil_lower>0 | (-GROP.OPIS)*_fil_lower>0
            || _filter2:=1
            || _filter2:=0
            ?}
         ?};
         {? _filter1>0 & _filter2>0 & GROP.AKC='T'
         ||
            _id+=1;
#           PIERWSZY POZIOM - NAGLOWKI GRUP - (GROP)
            :RS.blank();
            :RS.SYM:=GROP.KOD;
            :RS.TYP:='GROP';
            :RS.NAZWA:=GROP.OPIS;
            :RS.KOLOR_B:='255:255:255';
            :RS.LEVEL:=0;
            :RS.ID:=_id;
            :RS.BLK:='N';
            :RS.ILOSC:=GROP.IL;
            :RS.REF:=$GROP.ref();
            :RS.TTOPER:=$GROP.TTOPER;
            :RS.KOLOR_TO:=GROP.TTOPER().KOLOR;
            :RS.ILOSC_PL:=GROP.ILP;
            :RS.AKC:=GROP.AKC;
            :RS.ILW:=GROP.ILW;

            {? GROP.ILP>0
            ||
               _tm_start:=exec('grop_tm_start','po_ogr',GROP.ref());
               {? _tm_start>0
               || :RS.PL_START:=exec('to_string','#tm_stamp',_tm_start)
               ?};
               _tm_end:=exec('grop_tm_end','po_ogr',GROP.ref());
               {? _tm_end>0
               || :RS.PL_END:=exec('to_string','#tm_stamp',_tm_end)
               ?}
            ?};
            :RS.add();
            _parent:=:RS.ID;
            _par_first:=:RS.ID;

            {? GROP.ILP=0
            ||
#              DRUGI POZIOM - HEADER DLA ZASOBOW
               _id+=1;
               :RS.blank();
               :RS.TYP:='HEADER';
               :RS.SYM:='Zasoby';
               :RS.NAZWA:='Zasoby na których można zaplanować grupę';
               :RS.PAR:=_parent;
               :RS.ID:=_id;
               :RS.LEVEL:=1;
               :RS.add();

               _parent:=_id;

#              TRZECI POZIOM - ZASOBY NA KTORYCH MOZNA ZAPLANOWAC GRUPY - (GROPS)
               GROPS.prefix(GROP.ref());
               {? GROPS.first()
               || {!
                  |? _id+=1;
                     :RS.blank();
                     :RS.SYM:=GROPS.KOD;
                     :RS.TYP:='GROPS';
                     :RS.NAZWA:=GROPS.PL_RES().SYM+' '+PL_RES.NAZ;
                     :RS.KOLOR_B:='255:255:255';
                     :RS.LEVEL:=2;
                     :RS.ID:=_id;
                     :RS.PAR:=_parent;
                     :RS.BLK:='N';
                     :RS.ILOSC:=0;
                     :RS.REF:=$GROPS.ref();
                     :RS.DUR_MIN:=*GROPS.CZAS;
                     :RS.AKC:=GROPS.AKC;
                     :RS.add();
                     GROPS.next()
                  !}
               ?}
            ?};
            {? GROP.ILP>0
            ||
#              DRUGI POZIOM - HEADER DLA PLOGROW
               _id+=1;
               :RS.blank();
               :RS.TYP:='HEADER_PLOGR';
               :RS.SYM:='Pozycje planu';
               :RS.NAZWA:='Pozycje planu w których znajduje się grupa';
               :RS.PAR:=_par_first;
               :RS.ID:=_id;
               :RS.LEVEL:=1;
               :RS.add();

               _parent:=_id;

#              TRZECI POZIOM - PLANY GRUP (PL_OGR)
               PL_OGR.prefix(GROP.ref());
               {? PL_OGR.first()
               || {!
                  |? _id+=1;
                     :RS.blank();
                     :RS.SYM:=PL_OGR.SYMBOL;
                     :RS.TYP:='PLOGR';
                     :RS.NAZWA:=PL_OGR.OPIS;
                     :RS.KOLOR_B:='255:255:255';
                     :RS.LEVEL:=2;
                     :RS.ID:=_id;
                     :RS.PAR:=_parent;
                     :RS.BLK:='N';
                     :RS.ILOSC:=PL_OGR.ILOSC;
                     :RS.ILOSC_PL:=PL_OGR.ILOSC;
                     :RS.REF:=$PL_OGR.ref();
                     :RS.DUR_MIN:=PL_OGR.DURATION;
                     :RS.AKC:='T';
                     {? PL_OGR.TM_START>0
                     || :RS.PL_START:=exec('to_string','#tm_stamp',PL_OGR.TM_START)
                     ?};
                     {? PL_OGR.TM_END>0
                     || :RS.PL_END:=exec('to_string','#tm_stamp',PL_OGR.TM_END)
                     ?};
                     :RS.PLRESSYM:=PL_OGR.PL_RES().SYM;
                     :RS.PLRESNAZ:=PL_OGR.PL_RES().NAZ;
                     :RS.add();
                     PL_OGR.next()
                  !}
               ?}
            ?};
#           DRUGI POZIOM - HEADER DLA SKLADNIKOW GRUPY
            _id+=1;
            :RS.blank();
            :RS.TYP:='HEADER_GROPP';
            :RS.SYM:='Składniki';
            :RS.NAZWA:='Pozycje przewodników wchodzące w skład grupy';
            :RS.PAR:=_par_first;
            :RS.ID:=_id;
            :RS.LEVEL:=1;
            :RS.add();

            _parent:=_id;

#           TRZECI POZIOM - SKLADNIKI GRUP (GROPP)
            GROPP.prefix(GROP.ref());
            {? GROPP.first()
            || {!
               |? _id+=1;
                  :RS.blank();
                  :RS.TYP:='GROPP';
                  :RS.SYM:=GROPP.ZL().SYM+' ('+GROPP.M().KTM+')';
                  :RS.NAZWA:=GROPP.ZGP().NRPRZ().NRPRZ+' ('+GROPP.ZGP().OPIS+')';
                  :RS.ID:=_id;
                  :RS.PAR:=_parent;
                  :RS.ILOSC:=GROPP.IL;
                  :RS.add();
                  GROPP.next()
               !}
            ?}
         ?};
         GROP.next()
      !}
   ?};
   GROPP.cntx_pop();
   GROP.cntx_pop();
   PL_RES.cntx_pop();
   GROPS.cntx_pop();
   PL_OGR.cntx_pop();
   ZL.cntx_pop();
   M.cntx_pop();
   ZGH.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_max_ilosc

desc
   Zwraca maksymalna ilosc jaka mozna zaplanowac dla grupy operacji
end desc

params
   REF:='' STRING[16], Ref tabeli GROP
end params

sql
   select
/*1*/   CAST (0 AS REAL_TYPE) as MAX_IL
   from SYSLOG
   where 1=0
end sql

formula
   GROP.cntx_psh();
   GROP.index('KOD');
   GROP.clear();
   {? GROP.seek(:REF)
   ||
      :RS.blank();
      :RS.MAX_IL:=GROP.IL-GROP.ILP;
      {? :RS.MAX_IL<0
      || :RS.MAX_IL:=0
      ?};
      :RS.add()
   ?};
   GROP.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_plan_resy

desc
   Zwraca informacje na jakich zasobach moze byc zaplanowana dana grupa
end desc

params
   GROP:=''  STRING[16], Ref tabeli GROP
end params

sql
   select
/*1*/    '1234567890123456' as PL_RES,
/*2*/    ' ' as DEFAULT
   from SYSLOG
   where 1=0
end sql

formula
   GROP.cntx_psh();
   GROP.index('KOD');
   GROP.clear();
   GROPS.cntx_psh();
   GROPS.index('GROP');
   {? GROP.seek(:GROP)
   || GROPS.prefix(GROP.ref());
      {? GROPS.first()
      || {!
         |? {? GROPS.AKC='T'
            ||
               :RS.blank();
               :RS.PL_RES:=$GROPS.PL_RES;
               :RS.DEFAULT:=GROPS.DEFAULT;
               :RS.add()
            ?};
            GROPS.next()
         !}
      ?}
   ?};
   GROPS.cntx_pop();
   GROP.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_plan_data

desc
   Zwraca informacje w jakis sposob zaplanowac dana grupe na danym zasobie
end desc

params
   GROP:=''    STRING[16], Ref tabeli GROP
   PL_RES:=''  STRING[16], Ref tabeli PL_RES
   ILOSC:=0    REAL, Ilosc jaka ma zostac zaplanowana
end params

sql
   select
/*1*/   '                                         ' as SYM,
/*2*/   '                                                              ' as OPIS,
/*3*/   CAST (0 AS REAL_TYPE) as DURATION,
/*4*/   '1234567890123456789' as TM_MIN,
/*5*/   '1234567890123456789' as TM_MAX,
/*6*/   '                                             ' as SYM_MIN,
/*7*/   '                                             ' as SYM_MAX
   from SYSLOG
   where 1=0
end sql

formula
   GROP.cntx_psh();
   GROP.index('KOD');
   GROP.clear();
   GROPS.cntx_psh();
   GROPS.index('GROPRES');
   PL_RES.cntx_psh();PL_RES.clear();


   {? GROP.seek(:GROP) & PL_RES.seek(:PL_RES)
   ||
#     Obsluga kooperacji - pobieranie min i max czasow
      _tm_min:=exec('get_min_start','po_ogr',GROP.ref());
      _tm_max:=exec('get_max_end','po_ogr',GROP.ref());

      GROPS.prefix(GROP.ref(),PL_RES.ref());
      {? GROPS.first()
      || :RS.blank();
         _time:=*GROPS.CZAS;
         :RS.SYM:=GROPS.GROP().KOD;
         :RS.OPIS:=GROPS.GROP().OPIS;
         :RS.DURATION:=_time*:ILOSC;

#        Obsluga kooperacji
         {? _tm_min>0
         || :RS.TM_MIN:=exec('to_string','#tm_stamp',_tm_min);
            :RS.SYM_MIN:='Kooperacja'
         ?};
         {? _tm_max>0
         || :RS.TM_MAX:=exec('to_string','#tm_stamp',_tm_max);
            :RS.SYM_MAX:='Kooperacja'
         ?};

         :RS.add()
      ?}
   ?};
   PL_RES.cntx_pop();
   GROPS.cntx_pop();
   GROP.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_plogrs

desc
   Zwraca PL_OGRy w podanym przedziale czasu
end desc

params
   START   STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END    STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*--------------Ploz.java*/
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLRES,
/*4*/    '                                                                       ' as PLRESSYM,
/*5*/    '                                                                       ' as PLRESNAZ,
/*6*/    '1234567890123456' as PLPART,
/*7*/    ' ' as WYKFORCE,
/*8*/    SPACE(255) as KONFPLUG,
/*--------------Plogr.java*/
/*9*/    '1234567890123456' as GROP,
/*10*/    CAST (0 AS REAL_TYPE) as DURATION,
/*11*/    CAST (0 AS REAL_TYPE) as ILOSC,
/*12*/    '1234567890123456789' as PL_START,
/*13*/   '1234567890123456789' as PL_END,
/*14*/   '                                                                                                          ' as SYMBOL,
/*15*/   '                                                                                                          ' as OPIS,
/*16*/   '255:255:255' as KOLOR,
/*17*/   CAST (0 AS REAL_TYPE) as IL_WYK,
/*18*/   CAST (0 AS REAL_TYPE) as GROP_IL,
/*19*/   0 as PREVS,
/*20*/   0 as NEXTS,
/*21*/   '1234567890123456789' as TM_MIN,
/*22*/   '1234567890123456789' as TM_MAX,
/*23*/   '                                             ' as SYM_MIN,
/*24*/   '                                             ' as SYM_MAX,
/*25*/   '255:255:255' as KOLOR_T,
/*26*/   '255:255:255' as KOLOR_M,
/*27*/   '255:255:255' as KOLOR_G
   from SYSLOG
   where 1=0
end sql

formula
   GROP.cntx_psh();
   PL_RES.cntx_psh();
   PL_OGR.cntx_psh();
   PL_OGR.index('TM_END');
   PL_OGR.clear();

   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;

   {? PL_OGR.find_ge(_tm_start)
   ||
      {? PL_OGR.TM_START<_tm_end
      || _int_rec:=exec('interval','#interval');
         {!
         |? _int_rec.START:=PL_OGR.TM_START;
            _int_rec.END:=PL_OGR.TM_END;
            {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
            ||
               :RS.blank();
               exec('plogr2rs','po_ogr',:RS);
               :RS.add()
            ?};
            PL_OGR.next()
         !}
      ?}
   ?};
   PL_OGR.cntx_pop();
   PL_RES.cntx_pop();
   GROP.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc plogrs4zgp

desc
   Zwraca refy plogrow dla podanego zgpa
end desc

params
   ZGP:=''     STRING[16], REF SQL pozycji przewodnika
end params

sql
   select
/*1*/   '1234567890123456' as PLOGR,
/*2*/    '                                                                                                          ' as SYMBOL,
/*3*/    '                                                                                                          ' as OPIS
   from SYSLOG
   where 1=0
end sql

formula
   PL_OGR.cntx_psh();
   PL_OGR.index('GROP');
   GROPP.cntx_psh();
   GROPP.index('ZGP');
   GROP.cntx_psh();
   ZGP.cntx_psh();
   ZGP.clear();
   {? ZGP.seek(:ZGP)
   || GROPP.prefix(ZGP.ref());
      {? GROPP.first()
      || {!
         |? PL_OGR.prefix(GROPP.GROP);
            {? PL_OGR.first()
            || {!
               |? :RS.blank();
                  :RS.PLOGR:=$PL_OGR.ref();
                  :RS.SYMBOL:=PL_OGR.SYMBOL;
                  :RS.OPIS:=PL_OGR.OPIS;
                  :RS.add();
                  PL_OGR.next()
               !}
            ?};
            GROPP.next()
         !}
      ?}
   ?};
   ZGP.cntx_pop();
   PL_OGR.cntx_pop();
   GROPP.cntx_pop();
   GROP.cntx_pop();
   ~~
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc plogr_move

desc
   Przesuwa podanego plogra
end desc

params
   REF:=''    STRING[16], Ref SQL przesuwanego PL_OGRa
   STARTD         DATE,       Data startu
   STARTT         TIME,       Czas startu
   ENDD           DATE,       Data konca
   ENDT           TIME,       Czas konca
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_OGR.cntx_psh();
   PL_OGR.clear();
   _result:=0;
   {? PL_OGR.seek(:REF)
   ||
      _can_move:=exec('can_move_plogr','px_tie',PL_OGR.ref());
      {? _can_move>0
      ||
         PL_OGR.STARTD:=:STARTD;
         PL_OGR.STARTT:=:STARTT;
         PL_OGR.ENDD:=:ENDD;
         PL_OGR.ENDT:=:ENDT;
         PL_OGR.TM_START:=exec('create','#tm_stamp',PL_OPER.STARTD,PL_OPER.STARTT);
         PL_OGR.TM_END:=exec('create','#tm_stamp' ,PL_OPER.ENDD  ,PL_OPER.ENDD  );
         _result:=PL_OGR.put();
         {? _result>0
         ||
            exec('next_tm_ogr','po_plan',PL_OGR.ref());
#           Aktualizacja planu strategicznego
            _mainver:=exec('get_mainversion','px_ver');
            exec('plogr2pxpoz','px_tie',PL_OGR.ref(),_mainver);
            ~~
         ?}
      || _result:=_can_move
      ?}
   ?};
   :RS.RESULT:=_result;
   :RS.add();
   PL_OGR.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc can_plan

desc
   Sprawdza czy można zaplanować zlecenie - ze względu na zaplanowanie gropów
end desc

params
   REF:=''    STRING[16], Ref SQL zlecenia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   _result:=0;
   ZL.cntx_psh(); ZL.prefix();
   _tab:=ref_tab(:REF);
   {? type_of(_tab)>0 & _tab=ZL
   || {? ZL.seek(:REF)
      || _result:=exec('can_plan','po_ogr',ZL.ref())
      ?}
   ?};
   ZL.cntx_pop();
   :RS.blank();
   :RS.RESULT:=_result;
   :RS.add();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc can_plan2

desc
   Sprawdza czy można zaplanować zlecenie - ze względu na zgrupowanie zgpów w gropy
end desc

params
   REF:=''    STRING[16], Ref SQL zlecenia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   _result:=0;
   ZL.cntx_psh(); ZL.prefix();
   _tab:=ref_tab(:REF);
   {? type_of(_tab)>0 & _tab=ZL
   || {? ZL.seek(:REF)
      || _result:=exec('can_plan2','po_ogr',ZL.ref)
      ?}
   ?};
   ZL.cntx_pop();
   :RS.blank();
   :RS.RESULT:=_result;
   :RS.add();
   ~~
end formula

end proc


#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 c28aa64116e0e3681bb63dcaa064cf84bb2107a32c9ddb0854255ece9a216534757345fd6524b01581062266123b170ef98d223d0e2ac6274a6af24cc9fc6874532b380ea361c9d8c8e87bc4744fbc12aa75b81496fee242cbccab6ab551fe9881d628431ce73029f7fe3c651d6298f31e6bb7b1b2801de5f969d46eefbf2fa2
