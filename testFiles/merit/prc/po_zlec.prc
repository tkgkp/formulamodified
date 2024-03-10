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

#           Zlecenia w przygotowaniu
            ZL.prefix(_typzl,'T','N');
            {? ZL.first()
            || {!
               |? exec('zlec2rs','po_plan',:RS,:FILTER,:KOLOR,:PLANNED,_ndx_un,_ndx_id,:SCOPE);
                  ZL.next()
               !}
            ?};

#           Zlecenia otwarte
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

proc getzgh

desc
   Zwraca przewodniki zlecenia
end desc

params
   ZL:=''   STRING[16], Ref SQL zlecenia
end params

sql
  select
      '1234567890123456' as REF,
      '                                                                                                      ' as NAZWA,
      CAST (0 AS REAL_TYPE) as ILOSC,
      CAST (0 AS REAL_TYPE) as IL_PLAN,
      '                                                                                                      ' as SYM_ZL,
      '                                                                                                      ' as SYM_TOP,
      '1234567890123456' as REF_TKTL,
      '1234567890123456' as REF_ZKTL,
      '1234567890123456' as REF_ZL,
      '1234567890123456' as REF_TOP,
      '1234567890123456' as REF_KTM,
      '1234567890123456789' as MPSSTART,
      '1234567890123456789' as MPSEND,
      ' ' as HAS_WYK
   from SYSLOG
   where 0=1
end sql

formula
   ZGH.cntx_psh();
   ZL.cntx_psh();
   ZL.clear();
   {? ZL.seek(:ZL)
   ||
#     Jezeli zlecenie jest zlozone to zwracam ZGHy wszystkich podzlen
      {? ZL.RODZAJ<>'P'
      ||
         _main:=exec('main_podzlec','zl_link',ZL.ref());
         {? _main<>null()
         ||
#           Rekurencja
            _rs:=proc_exe('getzgh@po_zlec',$_main);
            {? _rs.first()
            || {!
               |?
#                 Przepisuje RSa
                  :RS.blank();
                  :RS.REF:=_rs.REF;
                  :RS.NAZWA:=_rs.NAZWA;
                  :RS.ILOSC:=_rs.ILOSC;
                  :RS.SYM_ZL:=_rs.SYM_ZL;
                  :RS.REF_TKTL:=_rs.REF_TKTL;
                  :RS.REF_ZKTL:=_rs.REF_ZKTL;
                  :RS.IL_PLAN:=_rs.IL_PLAN;
                  :RS.REF_ZL:=_rs.REF_ZL;
                  :RS.REF_TOP:=_rs.REF_TOP;
                  :RS.SYM_TOP:=_rs.SYM_TOP;
                  :RS.REF_KTM:=_rs.REF_KTM;
                  :RS.MPSSTART:=_rs.MPSSTART;
                  :RS.MPSEND:=_rs.MPSEND;
                  :RS.HAS_WYK:=_rs.HAS_WYK;
                  :RS.add();
                  _rs.next()
               !}
            ?}
         ?}
      ||
         ZGH.index('ZLNR');
         ZGH.prefix(ZL.ref());
         {? ZGH.first()
         || {!
            |? :RS.blank();
               :RS.REF:=$ZGH.ref();
               :RS.NAZWA:=ZGH.NRPRZ;
               :RS.ILOSC:=ZGH.ILNPRZ;
               :RS.SYM_ZL:=ZL.SYM;
               :RS.REF_TKTL:=$ZL.KTL;
               :RS.REF_ZKTL:=$ZL.KTLZ;
               :RS.REF_ZL:=$ZL.ref();
               _top:=exec('top_level','zl_link',ZL.ref());
               :RS.REF_TOP:=$_top;
               :RS.SYM_TOP:=exec('FindAndGet','#table',ZL,_top,,"SYM",'');
               :RS.IL_PLAN:=exec('zgh_planned','po_plan',ZGH.ref());
               :RS.REF_KTM:=$ZL.KTM;

               _tm_start:=exec('zlec_start','px_tie',ZL.ref());
               _tm_end:=exec('zlec_end','px_tie',ZL.ref());
               {? _tm_start>0
               || :RS.MPSSTART:=exec('to_string','#tm_stamp',_tm_start)
               ?};
               {? _tm_end>0
               || :RS.MPSEND:=exec('to_string','#tm_stamp',_tm_end)
               ?};
               {? exec('has_wyk_zgh','zl_guide',ZGH.ref())>0
               || :RS.HAS_WYK:='T'
               || :RS.HAS_WYK:='N'
               ?};
               :RS.add();
               ZGH.next()
            !}
         ?}
      ?}
   ?};
   ZGH.cntx_pop();
   ZL.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc getzghdata

desc
   Zwraca dane o przewodniku zlecenia
end desc

params
   ZGH:=''   STRING[16], Ref SQL przewodnika
end params

sql
  select
      '1234567890123456' as REF,
      '                                                                                                      ' as NAZWA,
      CAST (0 AS REAL_TYPE) as ILOSC,
      CAST (0 AS REAL_TYPE) as IL_PLAN,
      '                                                                                                      ' as SYM_ZL,
      '                                                                                                      ' as SYM_TOP,
      '1234567890123456' as REF_TKTL,
      '1234567890123456' as REF_ZKTL,
      '1234567890123456' as REF_ZL,
      '1234567890123456' as REF_TOP,
      '1234567890123456' as REF_KTM,
      '1234567890123456789' as MPSSTART,
      '1234567890123456789' as MPSEND,
      ' ' as HAS_WYK
   from SYSLOG
   where 0=1
end sql

formula
   ZGH.cntx_psh(); ZGH.clear();
   ZL.cntx_psh();
   {? ZGH.seek(:ZGH)
   || :RS.blank();
      :RS.REF:=$ZGH.ref();
      :RS.NAZWA:=ZGH.NRPRZ;
      :RS.ILOSC:=ZGH.ILNPRZ;
      :RS.IL_PLAN:=exec('zgh_planned','po_plan',ZGH.ref());

#     Podczytanie zlecenia
      ZGH.ZLEC();
      :RS.SYM_ZL:=ZL.SYM;
      :RS.REF_TKTL:=$ZL.KTL;
      :RS.REF_ZKTL:=$ZL.KTLZ;
      :RS.REF_ZL:=$ZL.ref();
      _top:=exec('top_level','zl_link',ZL.ref());
      :RS.REF_TOP:=$_top;
      :RS.SYM_TOP:=exec('FindAndGet','#table',ZL,_top,,"SYM",'');
      :RS.REF_KTM:=$ZL.KTM;

      _tm_start:=exec('zlec_start','px_tie',ZL.ref());
      _tm_end:=exec('zlec_end','px_tie',ZL.ref());
      {? _tm_start>0
      || :RS.MPSSTART:=exec('to_string','#tm_stamp',_tm_start)
      ?};
      {? _tm_end>0
      || :RS.MPSEND:=exec('to_string','#tm_stamp',_tm_end)
      ?};
      {? exec('has_wyk_zgh','zl_guide',ZGH.ref())>0
      || :RS.HAS_WYK:='T'
      || :RS.HAS_WYK:='N'
      ?};

      :RS.add()
   ?};
   ZGH.cntx_pop();
   ZL.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc getzgp

desc
   Zwraca tabele zlecen produkcyjnych
end desc

params
   FILTER:='%' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   PLANNED:='A' String[1], Filtr zaplanowane/niezaplanowane: 'A' - Wszystkie, 'P' - Zaplanowane, 'N' niezaplanowane
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
/*--------------ZgpTreeNode.java*/
/*29*/ '                                                                                                    ' as ZLECSYM,
/*30*/ '1234567890123456' as ZL,
/*31*/ '                                                                                                    ' as ZGHSYM,
/*32*/ '1234567890123456' as ZGH,
/*33*/ '                                                                                                    ' as OPER,
/*34*/ CAST (0 AS REAL_TYPE) as DUR_MIN,
/*35*/ CAST (0 AS REAL_TYPE) as OFFSET_O,
/*36*/ ' ' as GENPRZEW,
/*37*/ 0 as ZGHCOUNT,
/*38*/ 'N' as INTERZL,
/*39*/ CAST (0 AS REAL_TYPE) as PART_IL,
/*40*/ '1234567890123456' as REF_TOP,
/*41*/ '                                                                                 ' as SYM_TOP,
/*42*/ '                                                                                 ' as PRODUKT,
/*43*/ CAST (0 AS REAL_TYPE) as TP,
/*44*/ CAST (0 AS REAL_TYPE) as TZ,
/*45*/ 0 as NRP,
/*46*/ 0 as PREVIL
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
   _ndx_un:=:RS.ndx_tmp(,,'REF',,);
   _ndx_id:=:RS.ndx_tmp(,,'ID',,);
   :RS.index(_ndx_un);

   ZL.index('TSSA');

   {? _typy.first()
   || {!
      |? _typzl:=exec('FindAndGet','#table',ZTP,_typy.REF,,,null());

#        Zlecenia w przygotowaniu
         ZL.prefix(_typzl,'T','N');
         {? ZL.first()
         || {!
            |? exec('zgp2rs','po_plan',:RS,:FILTER,:PLANNED,_ndx_un,_ndx_id);
               ZL.next()
            !}
         ?};

#        Zlecenia otwarte
         ZL.prefix(_typzl,'N','O');
         {? ZL.first()
         || {!
            |? exec('zgp2rs','po_plan',:RS,:FILTER,:PLANNED,_ndx_un,_ndx_id);
               ZL.next()
            !}
         ?};
         _typy.next()
      !}
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


proc get_zgp_resy

desc
   Zwraca informacje na jakich zasobach moze byc zaplanowana dana pozycja przewodnika
end desc

params
   ZGP:=''  STRING[16], Ref tabeli ZGP
end params

sql
   select
/*1*/    '1234567890123456' as PL_RES,
/*2*/    CAST (0 AS REAL_TYPE) as DURATION,
/*3*/    CAST (0 AS REAL_TYPE) as OFFSET_O
   from SYSLOG
   where 1=0
end sql

formula
   ZGP.cntx_psh();
   ZGP.clear();
   {? ZGP.seek(:ZGP)
   ||
      {? ZGP.WEW='T' & ZGP.PL_GRP<>'T'
      ||
         _resources:=exec('get_resources','po_plan',$ZGP.ref(),ZGP.ILOSC,,'ZGP');
         _resources.prefix();
         {? _resources.first()
         || {!
            |?
               :RS.cntx_psh();
               :RS.clear();
               :RS.blank();
               :RS.PL_RES:=_resources.REF_RES;
               :RS.DURATION:=_resources.DURATION;
               :RS.OFFSET_O:=_resources.OFFSET_O;
               :RS.add();
               :RS.cntx_pop();
               _resources.next()
            !}
         ?};
         obj_del(_resources)
      ?}
   ?};
   ZGP.cntx_pop();
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 0e8b8f83ab24d07965898c5e540d15c77d554d123e1476b90fb4b8e411df4aa1128acd51c192f85fffa9a47696326114494aeb67e5fa8665c8c5c70715ca2b09d9648410ad7fa692c9990bf9c98277792ad5395235e6fbd6c9b87eb836cdb6548a22c04b5c2cc78adc3c07c0e2b7a021fdf6f68ad4467cd505a5e1b227de93ac
