:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_zam.prc [2010]
# Utworzony: 03.03.2009
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury do wyciagania informacji o zamowieniach klientow w module planowania okresowego java
#=======================================================================================================================


#-----------------------------------------------------------------------------------------------------------------------

proc getzams

desc
   Zwraca tabele z zamowieniami sprzedazy
end desc

params
   FILTER:='%' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   KOLOR:=1 Integer, Skad brac kolor? 1  - z kontrahenta, 2 - z zamowienia, 3 - z grupy materialowej
   PLANNED:='A' String[1], Filtr zaplanowane/niezaplanowane: 'A' - Wszystkie, 'P' - Zaplanowane, 'N' niezaplanowane
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                                                  ' as SYM,
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
/*19*/   '1234567890123456' as REF_M,
/*21*/   0 as PLPARTS,
/*20*/   ' ' as PL_GROP,
/*22*/ 0 as SAVE_B,
/*23*/ '1234567890123456789' as TERMIN,
/*24*/ 0 as GROP_OK,
/*25*/ CAST (0 AS REAL_TYPE) as ILOSC_PL,
/*26*/ 0 as GROP_OK2,
/*27*/ 0 as DOKL,
/*28*/   '                                                   ' as KTM,
/*29*/ '          ' as JM,
/*30*/ ' ' as SINGLE,
/*---------------ZamTreeNode.java*/
/*29*/   '                                                  ' as ZAM_KL,
/*30*/   TO_DATE('2000/1/1') as DTERMIN,
/*31*/   CAST (0 AS REAL_TYPE) as PROCENT,
/*32*/   '                                         ' as HAN,
/*33*/   ' ' as AKC,
/*34*/   '                                         ' as ZAM_SYM,
/*35*/   0 as ZKP_POZ,
/*36*/   '                                         ' as ZKP_KTM,
/*37*/   0 as ZLECENIA
   from SYSLOG
   where 1=0
   order by DTERMIN DESC
end sql

formula
   ZK_N.cntx_psh();
   ZK_N.index('ATLZW');
   ZK_N.clear();

   ZK_P.cntx_psh();
   ZK_P.index('NAG');

   KH.cntx_psh();
   M.cntx_psh();
   MGR.cntx_psh();
   TYPYZAM.cntx_psh(); TYPYZAM.clear();

   _old_ndx:=:RS.index('?');
   _ndx:=:RS.ndx_tmp(,,'REF',,);
   :RS.index(_ndx);

   _zam:=exec('get','#params',500213)+exec('get','#params',500215);
   {? TYPYZAM.first()
   || {!
      |? {? _zam*TYPYZAM.T>0
         ||
            ZK_N.prefix('A',TYPYZAM.ref());
            {? ZK_N.first()
            || {!
               |?
#                 Probuje dodac do RSa naglowek zamowienia
                  _id_nag:=exec('zkn2rs','po_plan',:RS,:FILTER,:KOLOR,:PLANNED);
                  _has_poz:=0;
                  {? _id_nag>0
                  ||
#                    Dodalem naglowek wiec dodaje wszystkie jego pozycje
                     ZK_P.prefix(ZK_N.ref());
                     {? ZK_P.first()
                     || {!
                        |? {? exec('zkp2rs','po_plan',:RS,:FILTER,:KOLOR,:PLANNED,_id_nag)>0
                           || _has_poz:=1
                           ?};
                           ZK_P.next()
                        !}
                     ?}
                  ?};
                  {? _has_poz=0
                  ||
#                    Naglowek nie ma zadnych pozycji wiec go usuwam z RSa
                     :RS.prefix($ZK_N.ref());
                     {? :RS.first()
                     || :RS.del()
                     ?}
                  ?};
                  ZK_N.next()
               !}
            ?}
         ?};
         TYPYZAM.next()
      !}
   ?};
   TYPYZAM.cntx_pop();
   ZK_N.cntx_pop();
   KH.cntx_pop();
   M.cntx_pop();
   MGR.cntx_pop();
   ZK_P.cntx_pop();

# Przywracam oryginalny indeks
   :RS.index(_old_ndx);
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc getpozycje

desc
   Zwraca refy pozycji zamowienia
end desc

params
   ZK_N   String[16], Ref sql naglowka zamowienia - $ZK_N.ref()
end params
sql
  select
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   ZK_N.cntx_psh();
   ZK_P.cntx_psh();
   ZK_P.index('TYPN');
   ZK_P.clear();
   ZK_N.clear();
   {? ZK_N.seek(:ZK_N)
   || ZK_P.prefix('A','Z',ZK_N.ref());
      {? ZK_P.first()
      || {!
         |? :RS.REF:=$ZK_P.ref();
            :RS.add();
            ZK_P.next()
         !}
      ?}
   ?};
   ZK_P.cntx_pop();
   ZK_N.cntx_pop()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc update

desc
   Ustawia zamowieniu nowy kolor
end desc

params
   ZK_N   String[16], Ref sql naglowka zamowienia - $ZK_N.ref()
   KOLOR String[20], Kolor zamowienia
end params

formula
   ZK_N.cntx_psh();
   {? ZK_N.seek(:ZK_N)
   || ZK_N.KOLOR:=:KOLOR;
      ZK_N.put()
   ?};
   ZK_N.cntx_pop()
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 74222e35ec39ea814ff1b5bbfad36f5cdf324b69727eabcd274d7d89f579c7438852c7dd53ee4e59caf9d696adc36ac5374305694682f043ef5196f7a862b4aec0cf8b9e99a5ff76da7992a703f4dabd5c32d303d5a5eda243484c5b79106c3781a9786334b6c82d3e6f75fef477de6682173cb2485d09c6ffc4474cbcfe53dc
