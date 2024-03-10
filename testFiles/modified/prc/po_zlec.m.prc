:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: po_zlec.prc [2010]
# Utworzony: 27.04.2009
# Autor: WH
# Systemy: PROD
#========================================================================================================================
# Zawartosc: Procedury do wyciagania informacji o zleceniach w module planowania okresowego java
#========================================================================================================================


#----------------------------------------------------------------------------------------------------------------------

proc getzlec

desc
   Zwraca tabele zlecen produkcyjnych
end desc

params
   FILTER:='%' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   KOLOR:=1 Integer, Skad brac kolor? 1 1 - z kontrahenta, 2 - z zamowienia, 3 - z grupy materialowej
   PLANNED:='A' String[1], Filtr zaplanowane/niezaplanowane: 'A' - Wszystkie, 'P' - Zaplanowane, 'N' niezaplanowane
   SCOPE:='ALL' String[10], Filtr wszystkie, wymagające doplanowania: 'ALL' - Wszystkie, 'REPLAN' - do doplanowania
   GROUPING:='G_NONE' String[10], Grupowanie: brak, wg NPU: 'G_NONE' - Brak, 'G_NPU' - wg npu
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '     ' as TYP,
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
/*12*/ CAST (0 AS REAL_TYPE) as MPS,
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
/*--------------ZlecTreeNode.java*/
/*29*/ CAST (0 AS REAL_TYPE) as UN_ZL,
/*30*/ TO_DATE('2000/1/1') as DZATW,
/*31*/ CAST (0 AS REAL_TYPE) as PROCENT,
/*32*/ ' ' as STAN,
/*33*/ '                                         ' as ZATWOSOB,
/*34*/ ' ' as GENPRZEW,
/*35*/ 0 as ZGHCOUNT,
/*36*/ 'N' as INTERZL,
/*37*/ CAST (0 AS REAL_TYPE) as PART_IL,
/*38*/ '1234567890123456' as REF_TOP,
/*39*/ '                                                                                 ' as PRODUKT,
/*40*/ 0 as REPLAN


   from SYSLOG
   where 1=0
   order by SYM DESC
end sql

formula
   ZL.cntx_psh();
   ZL.clear();
   ZGH.cntx_psh();
   ZGH.clear();
   M.cntx_psh();
   USERS.cntx_psh();
   KH.cntx_psh();
   MGR.cntx_psh();
   _typy:=exec('typy_zlecen','zl_head');

#  zapamietuje utworzony w sekcji sql indeks
   _old_ndx:=:RS.index('?');

   _ndx_id:=:RS.ndx_tmp(,,'ID',,);

   ZL.index('TSSA');

   {? :GROUPING='G_NONE'
   ||
      _ndx_un:=:RS.ndx_tmp(,,'UN_ZL',,);
      :RS.index(_ndx_un);

   {? _typy.first()
   || {!
      |? _typzl:=exec('FindAndGet','#table',ZTP,_typy.REF,,,null());

#        Zlecenia w przygotowaniu
         ZL.prefix(_typzl,'T','N');
# NUCO - pracuje w planie tylko na zleceniach otwartych
         {? ZL.first() & :PLANNED<>'N'
         || {!
            |? exec('zlec2rs','po_plan',:RS,:FILTER,:KOLOR,:PLANNED,_ndx_un,_ndx_id,:SCOPE);
               ZL.next()
            !}
         ?};

#        Zlecenia otwarte
         ZL.prefix(_typzl,'N','O');
         {? ZL.first()
         || {!
            |? exec('zlec2rs','po_plan',:RS,:FILTER,:KOLOR,:PLANNED,_ndx_un,_ndx_id,:SCOPE);
               ZL.next()
            !}
         ?};
         _typy.next()
      !}
      ?}
   |? :GROUPING='G_NPU'
   ||
      _ndx_un:=:RS.ndx_tmp(,,'PAR',,,'UN_ZL',,);
      :RS.index(_ndx_un);

      _tact_tab:=tab_tmp(1,
         'M_REF','STRING[16]','Nazwa pola 1',
         'ID','INTEGER','Id'
      );
      _filter1:=:FILTER;
      _filter2:='';
      {? _filter1*','>0
      || _split:=spli_str(_filter1,',');
         _filter1:=form(_split[1]);
         _filter2:=form(_split[2])
      ?};

#     Dodaję wszystkie NPU do RSa
      TACTTLS.cntx_psh();
      TACTTLS.index('UNIQ');
      TACTTLS.prefix();
      {? TACTTLS.first()
      || {!
         |? _id:=exec('tacttls2rs','po_plan',:RS,_filter1);
            {? _id>0
            || _tact_tab.blank();
               _tact_tab.M_REF:=$TACTTLS.M;
               _tact_tab.ID:=_id;
               _tact_tab.add()
            ?};
            TACTTLS.next()
         !}
      ?};
      TACTTLS.cntx_pop();
      _tact_tab.prefix();

      {? _typy.first()
      || {!
         |? _typzl:=exec('FindAndGet','#table',ZTP,_typy.REF,,,null());

#           Zlecenia w przygotowaniu
            ZL.prefix(_typzl,'T','N');
            {? ZL.first()
            || {!
               |?
                  {? var_pres('_tact_zl')>100
                  || obj_del(_tact_zl)
                  ?};
                  _tact_zl:=exec('tacttls4zlec','po_plan').tab;
                  _tact_zl.prefix();
                  {? _tact_zl.first()
                  || {!
                     |? _tact_tab.prefix(_tact_zl.SQL,);
                        {? _tact_tab.first()
                        || {!
                           |? exec('zlec2rs','po_plan',:RS,_filter2,:KOLOR,:PLANNED,_ndx_un,_ndx_id,:SCOPE,_tact_tab.ID);
                              _tact_tab.next()
                           !}
                        ?};
                        _tact_zl.next()
                     !}
                  ?};
                  ZL.next()
               !}
            ?};

#           Zlecenia otwarte
            ZL.prefix(_typzl,'N','O');
            {? ZL.first()
            || {!
               |?
                  {? var_pres('_tact_zl')>100
                  || obj_del(_tact_zl)
                  ?};
                  _tact_zl:=exec('tacttls4zlec','po_plan').tab;
                  _tact_zl.prefix();
                  {? _tact_zl.first()
                  || {!
                     |? _tact_tab.prefix(_tact_zl.SQL,);
                        {? _tact_tab.first()
                        || {!
                           |? exec('zlec2rs','po_plan',:RS,_filter2,:KOLOR,:PLANNED,_ndx_un,_ndx_id,:SCOPE,_tact_tab.ID);
                              _tact_tab.next()
                           !}
                        ?};
                        _tact_zl.next()
                     !}
                  ?};
                  ZL.next()
               !}
            ?};
            _typy.next()
         !}
      ?};
#     Usuwam puste gałęzie NPU
      _ndx1:=:RS.ndx_tmp(,,'TYP',,);
      _ndx2:=:RS.ndx_tmp(,,'PAR',,);

      _can_continue:=1;
      :RS.cntx_psh();
      :RS.index(_ndx1);
      :RS.prefix('GRP',);
      {? :RS.first()
      || {!
         |? _next:=0;
            _ref_nxt:=null();
            :RS.cntx_psh();
            {? :RS.next()
            || _ref_nxt:=:RS.ref()
            ?};
            :RS.cntx_pop();

            _can_del:=0;
            :RS.cntx_psh();
            :RS.index(_ndx2);
            :RS.prefix(:RS.ID);
            {? :RS.first()=0
            || _can_del:=1
            ?};
            :RS.cntx_pop();
            {? _can_del>0
            || _can_continue:=:RS.del(,1)
            ?};

            {? _ref_nxt<>null()
            || _next:=:RS.seek(_ref_nxt)
            ?};
            _next>0 & _can_continue>0
         !}
      ?};
      :RS.cntx_pop();
      ~~
   ?};
# przywracam zapamietany index
   :RS.index(_old_ndx);
   ZL.cntx_pop();
   ZGH.cntx_pop();
   M.cntx_pop();
   USERS.cntx_pop();
   KH.cntx_pop();
   MGR.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


