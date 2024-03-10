:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: po_rem.prc
# Utworzony: 25.11.2019
# Autor: WH
#========================================================================================================================
# Zawartosc: Procedury do obsługi zgłoszeń remontowych w planie
#========================================================================================================================


proc get_all

desc
   Zwraca zdarzenia ktore mozna zaplanowac w planie operacyjnym
end desc

params
   FILTER:='' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   SCOPE:=''  String[20] ,Zakres
   KIND:=''  String[1]  ,Rodzaj
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '                                         ' as TYP,
/*3*/    '                                                                  ' as NAZWA,
/*4*/    '255:255:255' as KOLOR_B,
/*5*/    '0:0:0      ' as KOLOR_T,
/*6*/    0 as LEVEL,
/*7*/    0 as ID,
/*8*/    0 as PAR,
/*9*/    ' ' as BLK,
/*10*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*--------------PlannedTreeNode.java*/
/*11*/   '1234567890123456' as REF,
/*12*/   CAST (0 AS REAL_TYPE) as MPS,
/*13*/   '1234567890123456789' as MPSSTART,
/*14*/   '1234567890123456789' as MPSEND,
/*15*/ 0 as DIR,
/*16*/ '1234567890123456789' as PL_START,
/*17*/ '1234567890123456789' as PL_END,
/*18*/   '                                         ' as KH,
/*19*/ '1234567890123456' as REF_M,
/*20*/ 0 as PLPARTS,
/*21*/ ' ' PL_GROP,
/*22*/ 0 as SAVE_B,
/*23*/ '1234567890123456789' as TERMIN,
/*24*/ 0 as GROP_OK,
/*25*/ CAST (0 AS REAL_TYPE) as ILOSC_PL,
/*26*/ 0 as GROP_OK2,
/*27*/ 0 as DOKL,
/*28*/   '                                                   ' as KTM,
/*29*/ '          ' as JM,
/*30*/ ' ' as SINGLE,
/*--------------EventTreeNode.java*/
/*29*/ '12345678' as TAB,
/*30*/ '                                                                  ' as UID_REF,
/*31*/ CAST (0 AS REAL_TYPE) as DURATION,
/*32*/ '                                         ' as PL_TRYB,
/*33*/ '                                         ' as KIND,
/*34*/ ' ' as PLANED,
/*35*/ ' ' as WYK,
/*36*/ ' ' as MLT
   from SYSLOG
   where 1=0
   order by SYM DESC
end sql

formula
   PL_EVENT.cntx_psh();
   exec('update','po_event');

   {? :SCOPE='ALL'
   || {? :KIND='W'
      || PL_EVENT.index('SYMBOL');
         PL_EVENT.prefix()
      || PL_EVENT.index('PL_TRYB');
         PL_EVENT.prefix(:KIND,)
      ?}
   |? :SCOPE='NEW'
   || {? :KIND='W'
      || PL_EVENT.index('PLANNED');
         PL_EVENT.prefix('N')
      || PL_EVENT.index('PLANTRYB');
         PL_EVENT.prefix('N',:KIND,)
      ?}
   |? :SCOPE='PLANNED'
   || {? :KIND='W'
      || PL_EVENT.index('PLANNED');
         PL_EVENT.prefix('T')
      || PL_EVENT.index('PLANTRYB');
         PL_EVENT.prefix('T',:KIND,)
      ?}
   ?};
   {? PL_EVENT.first()
   || {!
      |? exec('event_tree2rs','po_event',:RS,:FILTER,'A');
         PL_EVENT.next()
      !}
   ?};
   PL_EVENT.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_plan_resy

desc
   Zwraca informacje na jakich zasobach moze byc zaplanowana dane zdarzenie
end desc

params
   PL_EVENT:=''  STRING[16], Ref tabeli PL_EVENT
end params

sql
   select
/*1*/    '1234567890123456' as PL_RES,
/*2*/    '1234567890123456' as PL_EVENR
   from SYSLOG
   where 1=0
end sql

formula
   PL_EVENR.cntx_psh();
   PL_EVENR.index('PL_EVENT');
   PL_EVENT.cntx_psh(); PL_EVENT.prefix();
   {? PL_EVENT.seek(:PL_EVENT)
   || PL_EVENR.prefix(PL_EVENT.ref());
      {? PL_EVENR.first()
      || {!
         |? {? PL_EVENR.PL_RES<>null()
            || :RS.blank();
               :RS.PL_RES:=$PL_EVENR.PL_RES;
               :RS.PL_EVENR:=$PL_EVENR.ref();
               :RS.add()
            ?};
            PL_EVENR.next()
         !}
      ?}
   ?};
   PL_EVENT.cntx_pop();
   PL_EVENR.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_auto

desc
   Zwraca zdarzenia planowane automatycznie, niezaplanowane
end desc

params
   START       STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END         STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
   WIDOK:=''   String[16], Kod widoku
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    cast (0 as REAL_TYPE) as DURATION,
/*3*/    TO_DATE('2007/04/25') as STARTD,
/*4*/    TO_DATE('2007/04/25') as ENDD,
/*5*/    TO_TIME('0:0:0') as STARTT,
/*6*/    TO_TIME('0:0:0') as ENDT,
/*7*/   '                                                                                          ' as SYMBOL,
/*8*/   '                                                                                          ' as OPIS,
/*9*/   '255:255:255' as KOLOR,
/*10*/   '                                                                                          ' as WHO_ADD,
/*11*/   '                                                                                          ' as WHO_MOD,
/*12*/   ' ' as PLANNED,
/*13*/   '1234567890123456789' as PL_START,
/*14*/   '1234567890123456789' as PL_END,
/*15*/   '1234567890123456' as PLRES,
/*16*/   ' ' as EAT_CAL,
/*17*/    cast (0 as REAL_TYPE) as USABLE,
/*18*/   ' ' as PL_DOST,
/*19*/   '1234567890123456' as PL_EVENR,
/*20*/   '1234567890123456' as PL_EVENT,
/*21*/   '1234567890123456' as RES_SYM
   from SYSLOG
   where 0=1

end sql

formula
   exec('update','po_event');
   PL_EVENT.cntx_psh();
   PL_EVENR.cntx_psh();
   PL_EVENR.index('PLANNED');
   PL_RES.cntx_psh();
   PL_RES.clear();

   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _startd:=exec('tm_stamp2date','#tm_stamp',_tm_start);
   _endd:=exec('tm_stamp2date','#tm_stamp',_tm_end);

   PL_OPIS.cntx_psh();
   PL_WZOR.cntx_psh();
   PL_WZOR.index('NAZWA');
   PL_WZOR.prefix(:WIDOK,);
   {? PL_WZOR.first()
   || PL_OPIS.index('PL_OPIS');
      PL_OPIS.prefix(PL_WZOR.ref());
      {? PL_OPIS.first()
      || {!
         |? PL_OPIS.PL_RES();
#           Zdarzenia z określonym czasem zakończenia
            PL_EVENR.prefix(PL_RES.ref(),'N');
            {? PL_EVENR.find_ge(_tm_start)
            || {!
               |?
                  {? PL_EVENR.PL_EVENT<>null()
                  || PL_EVENR.PL_EVENT();
                     _list:=exec('status_planned','remonty_plan');
                     {? PL_EVENT.PL_TRYB<>'R' & _list*PL_EVENT.STAT_REJ>0
                     ||
                        exec('event_auto2rs','po_event',:RS);
                        :RS.REF:=$PL_EVENR.ref();
                        :RS.PLRES:=$PL_RES.ref();
                        {? PL_EVENT.PL_DOST='C'
                        || :RS.USABLE:=0
                        |? PL_EVENT.PL_DOST='P'
                        || :RS.USABLE:=PL_EVENR.USABLE
                        ?};
                        :RS.PL_EVENR:=$PL_EVENR.ref();
                        :RS.RES_SYM:=PL_EVENR.PL_RES().SYM;
                        :RS.add()
                     ?}
                  ?};
                  PL_EVENR.next()
               !}
            ?};

#           Zdarzenia z czasem bezterminowym
            PL_EVENR.prefix(PL_RES.ref(),'N',0);
            {? PL_EVENR.first()
            || {!
               |?
                  {? PL_EVENR.PL_EVENT<>null()
                  || PL_EVENR.PL_EVENT();
                     _list:=exec('status_planned','remonty_plan');
                     {? PL_EVENT.PL_TRYB<>'R' & _list*PL_EVENT.STAT_REJ>0
                     ||
                        exec('event_auto2rs','po_event',:RS);
                        :RS.REF:=$PL_EVENR.ref();
                        :RS.PLRES:=$PL_RES.ref();
                        {? PL_EVENT.PL_DOST='C'
                        || :RS.USABLE:=0
                        |? PL_EVENT.PL_DOST='P'
                        || :RS.USABLE:=PL_EVENR.USABLE
                        ?};
                        :RS.PL_EVENR:=$PL_EVENR.ref();
                        :RS.RES_SYM:=PL_EVENR.PL_RES().SYM;
                        :RS.add()
                     ?}
                  ?};
                  PL_EVENR.next()
               !}
            ?};
#           Remonty z czasem bezterminowym, z częściową dostępnością pobieram zawsze
#           zeby doplanowac brakujace czesci
            PL_OPER.cntx_psh();
            PL_OPER.index('PL_EVE1');
            PL_EVENR.prefix(PL_RES.ref(),'T',0);
            {? PL_EVENR.first()
            || {!
               |?
                  _can_add:=0;
                  PL_OPER.prefix(PL_EVENR.ref());
                  {? PL_OPER.last()>0
                  || {? PL_OPER.ENDD<(_endd-1)
                     || _can_add:=1
                     ?}
                  ?};

                  {? _can_add>0 & PL_EVENR.USABLE>0 & PL_EVENR.USABLE<100
                  ||
                     {? PL_EVENR.PL_EVENT<>null()
                     || PL_EVENR.PL_EVENT();
                        _list:=exec('status_planned','remonty_plan');
                        {? PL_EVENT.PL_TRYB<>'R' & _list*PL_EVENT.STAT_REJ>0
                        ||
                           exec('event_auto2rs','po_event',:RS);
                           :RS.REF:=$PL_EVENR.ref();
                           :RS.PLRES:=$PL_RES.ref();
                           {? PL_EVENT.PL_DOST='C'
                           || :RS.USABLE:=0
                           |? PL_EVENT.PL_DOST='P'
                           || :RS.USABLE:=PL_EVENR.USABLE
                           ?};
                           :RS.PL_EVENR:=$PL_EVENR.ref();
                           :RS.RES_SYM:=PL_EVENR.PL_RES().SYM;
                           :RS.add()
                        ?}
                     ?}
                  ?};
                  PL_EVENR.next()
               !}
            ?};
            PL_OPER.cntx_pop();
            PL_OPIS.next()
         !}
      ?}
   ?};
   PL_WZOR.cntx_pop();
   PL_OPIS.cntx_pop();
   PL_RES.cntx_pop();
   PL_EVENR.cntx_pop();
   PL_EVENT.cntx_pop();
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1048 2021/04/09 15:28:40 7ad98bc17d783dc661d6612505ca9d53cde1877f7bbbfb5ed61eae48833baf55d9498ea17d92c6de0c1a34e4aa717a4c881be9e9f2afd6f79b75e12f3293fb03b85daded5b380b9eeb522ade51d4ae233c56604b0499b48433f739bdfa5e4aa9865589c4657230614cc54ec8b373541ef62ade365b0231aa0ee0dd44852522c5
