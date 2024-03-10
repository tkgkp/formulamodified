:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_tie.prc [12.30]
# Utworzony: 19.06.2012
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury do obslugi powiazania: plan strategiczny <-> plan operacyjny
#=======================================================================================================================

proc get_mps_new

desc
   Zwraca elementy kolejki (zlecenia\zamowienia) planu strategicznego ktore mozna zaplanowac w planie operacyjnym
end desc

params
   FILTER:='' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '     ' as TYP,
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
/*--------------MpsTreeNode.java*/
/*29*/ 0 as ZLECENIA,
/*30*/ CAST (0 AS REAL_TYPE) as IL_QUE,
/*31*/ 'N' as INTERZL,
/*32*/ CAST (0 AS REAL_TYPE) as ILW
   from SYSLOG
   where 1=0
end sql

formula
   PX_GRP.cntx_psh();
   M.cntx_psh();
   ZL.cntx_psh();
   ZK_P.cntx_psh();
   ZK_N.cntx_psh();
   PX_OBJ.cntx_psh();
   PX_GRP.cntx_psh();
   PX_CONN.cntx_psh();
   _mainver:=exec('get_mainversion','px_ver');
   _ndx_ref:=:RS.ndx_tmp(,,'REF',,);
   _ndx_id:=:RS.ndx_tmp(,,'ID',,);
   PX_CONN.index('PX_GRP');
   PX_GRP.index('LP');
   PX_GRP.prefix(_mainver);
   {? PX_GRP.first()
   || _id:=1;
      {!
      |? PX_CONN.prefix(PX_GRP.ref());
         {? PX_CONN.first()
         || {!
            |?
               _zkp:=PX_CONN.PX_OBJ().ZK_P;
               _zl:=PX_CONN.PX_OBJ().ZL;
               _grop:=PX_CONN.PX_OBJ().GROP;
               exec('conn_to_rs','px_tie' ,:RS
                                          ,:FILTER
                                          ,PX_CONN.ref()
                                          ,_zkp
                                          ,_zl
                                          ,_grop
                                          ,'N'
                                          ,_ndx_ref
                                          ,_ndx_id
                                          );
               PX_CONN.next()
            !}
         ?};
         PX_GRP.next()
      !}
   ?};
   PX_CONN.cntx_pop();
   PX_GRP.cntx_pop();
   PX_OBJ.cntx_pop();
   ZL.cntx_pop();
   ZK_P.cntx_pop();
   ZK_N.cntx_pop();
   M.cntx_pop();
   PX_GRP.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc get_mps_planned

desc
   Zwraca elementy kolejki (zlecenia\zamowienia) planu strategicznego ktore mozna zaplanowac w planie operacyjnym
end desc

params
   FILTER:='' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '     ' as TYP,
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
/*--------------MpsTreeNode.java*/
/*29*/ 0 as ZLECENIA,
/*30*/ CAST (0 AS REAL_TYPE) as IL_QUE,
/*31*/ 'N' as INTERZL,
/*32*/ CAST (0 AS REAL_TYPE) as ILW
   from SYSLOG
   where 1=0
end sql

formula
   M.cntx_psh();
   ZL.cntx_psh();
   ZK_P.cntx_psh();
   ZK_N.cntx_psh();
   PX_OBJ.cntx_psh();
   PX_GRP.cntx_psh();
   PX_CONN.cntx_psh();
   PX_GRP.cntx_psh();
   _mainver:=exec('get_mainversion','px_ver');
   _ndx_ref:=:RS.ndx_tmp(,,'REF',,);
   _ndx_id:=:RS.ndx_tmp(,,'ID',,);
   PX_CONN.index('PX_GRP');
   PX_GRP.index('LP');
   PX_GRP.prefix(_mainver);
   {? PX_GRP.first()
   || _id:=1;
      {!
      |? PX_CONN.prefix(PX_GRP.ref());
         {? PX_CONN.first()
         || {!
            |?
               _zkp:=PX_CONN.PX_OBJ().ZK_P;
               _zl:=PX_CONN.PX_OBJ().ZL;
               _grop:=PX_CONN.PX_OBJ().GROP;
               exec('conn_to_rs','px_tie' ,:RS
                                          ,:FILTER
                                          ,PX_CONN.ref()
                                          ,_zkp
                                          ,_zl
                                          ,_grop
                                          ,'P'
                                          ,_ndx_ref
                                          ,_ndx_id);
               PX_CONN.next()
            !}
         ?};
         PX_GRP.next()
      !}
   ?};
   PX_CONN.cntx_pop();
   PX_GRP.cntx_pop();
   PX_OBJ.cntx_pop();
   ZL.cntx_pop();
   ZK_P.cntx_pop();
   ZK_N.cntx_pop();
   M.cntx_pop();
   PX_GRP.cntx_pop();
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 0631d36ca4b307815e57f5b0b37869fdab4517423c80bc96ca60a7f0a82c055f3c2739bb1bc65f4dd2ceff860b60029b73794767083c8b99a0d5b10745b39148f65ab5128aa7127520d7ea826dd6aef9bfa780f0b3979207249a400a6da1eb9f3b9e31af3c90389d6cd5f43a18905fe62962aa0c3e501b890298d5539712bb12
