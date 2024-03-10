:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: ean.prc [2010]
# Utworzony: 01.01.2009
# Autor: RR, Mario
# Systemy: EMAG
#=======================================================================================================================
# Zawartosc: Procedury do wymiany danych z urzadzeniami mobilnymi
#=======================================================================================================================


proc eann

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: naglowki operacji na czytnikach kodow
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql

select
  EANN.UNIK,
  substr(to_string(EANN.DATA),1,4)||'-'||substr(to_string(EANN.DATA),6,2)||'-'||substr(to_string(EANN.DATA),9,2) as DATA,
  case when (EANN.TYP='R' and substr(EANN.REFSQL,1,5)<>'dokln') then 'L'
       else EANN.TYP end as TYP,
  EANN.UNIK,
  EANN.SYM,
  KH.NAZ,
  EANN.NRC,
  EANN.TIMER as TIME,
  EANN.STAN,
  EANN.REFERENCE,
  KH_ODB.MIASTO||' - '||KH_ODB.UL as ADR_DST,
  EANL.KOD as EANL,
  MG.SYM as MAG,
  case when (EANN.TYP='R' and substr(EANN.REFSQL,1,5)='dokln' and EANN.EANL is not null ) then 'I'
       when (EANN.TYP='R' and substr(EANN.REFSQL,1,5)='dokln' and EANN.EANL is null ) then 'S'
       else '' end as STATUS,
  EANN.RODZ as RODZ,
  EANN.AKT as AKT,
  EANN.ILP as ILP
from EANN
 left join KH using(EANN.KH,KH.REFERENCE)
 left join KH_ODB using(EANN.ODB,KH_ODB.REFERENCE)
 left join MG using(EANN.MG,MG.REFERENCE)
 left join EANL using(EANN.EANL,EANL.REFERENCE)
where EANN.REFERENCE like 'eann_\_\_%' escape '\'
  and EANN.STAN<>'!'
  and EANN.DATA_SRV>=CAST(CAST(current_date as INTEGER_TYPE) -10 as DATE_TYPE)
  and substr(EANN.UNIK,1,3)<>'ret'

end sql

formula
   :RS.clear;
   {? :RS.first
   || {!
      |? :RS.NAZ:=STR.gsub(:RS.NAZ,'\'',' ');
         :RS.ADR_DST:=STR.gsub(:RS.ADR_DST,'\'',' ');
         :RS.put;
         :RS.next
      !}
   ?}
end formula

end proc


proc eanp

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: pozycje operacji na czytnikach kodow
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql

select
   EANP.UNIK,
   EANP.EANN,
   EANL_Z.KOD,
   EANL_DO.KOD,
   case
    when (EANP.M is null) then PAL.KODK
    else M.KODK end as EAN,
   cast(EANP.IL as string_type),
   EANN.NRC,
   EANP.LP,
   case
    when (EANP.M is null) then PAL.KODK
    else M.KTM end as KOD,
   M.N as NAZ,
   '1753-01-01' as TW,
   EANP.ZPALET as ZPALET,
   EANP.PALEAN as PALEAN,
   EANP.PALDOEAN as PALDOEAN,
   EANP.BEZOZN as BEZOZN,
   EANP.SCEAN as SCEAN,
   EANP.ZLEAN as ZLEAN

from EANP
   join EANN using(EANP.EANN,EANN.REFERENCE)
   left join M using(EANP.M,M.REFERENCE)
   left join EANL as EANL_Z using(EANP.LOKZ,EANL_Z.REFERENCE)
   left join EANL as EANL_DO using(EANP.LOKDO,EANL_DO.REFERENCE)
   left join PAL using(EANP.PAL,PAL.REFERENCE)
where EANP.REFERENCE like 'eanp_\_\_%' escape '\' and EANN.STAN<>'!'
   and EANN.DATA_SRV>=CAST(CAST(current_date as INTEGER_TYPE) -10 as DATE_TYPE)
   and EANN.TYP<>'I' and EANN.TYP<>'P' and not (EANN.TYP='R' and substr(EANN.REFSQL,1,5)<>'dokln')
   and substr(EANN.UNIK,1,3)<>'ret'

end sql

formula
   :RS.clear;
   {? :RS.first
   || {!
      |? :RS.NAZ:=STR.gsub(:RS.NAZ,'\'',' ');
         :RS.put;
         :RS.next
      !}
   ?}
end formula

end proc


proc zm_status

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: zmiana statusu na naglowku
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   REFX:='' STRING[20]
   STANX:='' STRING[2]
   NUSER:='' STRING[20]
   UWAGI:='' STRING[255]
   ILP:=0 INTEGER
   TIME:='' STRING[10]
   TIME_END:='' STRING[10]
   ILODCZYT:=0 REAL
end params

formula
   ODDZ.index('KOD');
   {? ODDZ.first()
   || {!
      |?
         PAL.use('palety');
         EANN.use('eann'+ODDZ.KOD+'__');
         EANP.use('eanp'+ODDZ.KOD+'__');
         EANW.use('eanw'+ODDZ.KOD+'__');
         EANN.index('UNIK');
         EANN.prefix(:REFX,:REFX);
         _put:=0;
         {? EANN.first
         || _timez:=EANN.TIMEZ;
            {? (4+:REFX)<>'eann' & :STANX='A'
            || EANN.STAN:='A';
               EANN.AKT:='N';
               _put:=1
            |? EANN.STAN<>'A' & EANN.STAN<>'Z'
            || EANN.USER:=exec('find_usr','users',:NUSER);
               {? EANN.STAN<>'+' & EANN.STAN<>'A' & EANN.STAN<>'Z'  & EANN.STAN<>'X' ||  EANN.STAN:=:STANX ?};
               EANN.TXT1:=:UWAGI;
               EANN.ILP:=:ILP;
               EANN.ILODCZYT:=:ILODCZYT;
               _put:=1
            ?};
            {? :TIME_END<>'' & _timez=time(0,0,0)
            || EANN.TIMEZ:=($('time('+STR.gsub(:TIME_END,':',',')+')'))();
               _put:=1
            ?};
            {? :TIME<>'' & (4+:REFX)<>'eann'
            || _my_time:=($('time('+STR.gsub(:TIME,':',',')+')'))();
               {? _my_time<>EANN.TIMER
               ||  EANN.TIMER:=_my_time;
                  _put:=1
               ?}
            ?};
            {? _put=1 || EANN.put() ?};
            {? EANN.STAN='Z'
            || EANN.cntx_psh();
               exec('open','open_tab',ODDZ.KOD,form((EANN.DATA~1)-2000,-2,0,'99'));
               exec('openean','open_tab',ODDZ.KOD+'__');
               EANN.cntx_pop();
               _buf:=tab_tmp(2,'MAT','STRING[16]','','MAG','STRING[16]','');
               EANP.index('EANN');
               EANP.prefix(EANN.ref());
               {? EANP.first
               || {!
                  |? {? EANP.LOKZ<>null() & (';WZ'*EANP.EANN().TYP)>1
                     || {? EANP.M<>null()
                        || _buf.clear();
                           {? ~_buf.find_key($EANP.M,$EANP.LOKZ().MG)
                           || exec('obl_stan','magazyn_stan',EANP.M,1,EANP.LOKZ().MG);
                              _buf.blank();
                              _buf.MAT:=$EANP.M;
                              _buf.MAG:=$EANP.LOKZ().MG;
                              _buf.add(1)
                           ?}
                        |? EANP.PAL<>null()
                        || PAL_POZ.use('paletyp');
                           PAL_POZ.index('PAL');
                           PAL_POZ.prefix(EANP.PAL);
                           {? PAL_POZ.first()
                           || {!
                              |? _buf.clear();
                                 {? ~_buf.find_key($PAL_POZ.M,$EANP.LOKZ().MG)
                                 || exec('obl_stan','magazyn_stan',PAL_POZ.M,1,EANP.LOKZ().MG);
                                    _buf.blank();
                                    _buf.MAT:=$PAL_POZ.M;
                                    _buf.MAG:=$EANP.LOKZ().MG;
                                    _buf.add(1)
                                 ?};
                                 PAL_POZ.next()
                              !}
                           ?}
                        ?}
                     ?};
                     EANP.next()
                  !}
               ?};
               obj_del(_buf)
            ?};
            0
         || ODDZ.next()
         ?}
      !}
   ?}
end formula

sql
   select * from FIRMA where 1=0
end sql

formula

end formula

end proc


proc zm_il_poz

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: zmiana ilosci na pozycjach
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   REFX :=''   STRING[20]
   ILS  :=0    REAL
   KODLOK :='' STRING[20]
   REFE :=''   STRING[16]
   LOKZ :=''   STRING[20]

end params

formula
   {? :KODLOK<>'' | :LOKZ<>''
   ||
      EANL.index('KOD');
      {? :LOKZ<>'' || EANL.prefix(:LOKZ,:LOKZ) || EANL.prefix( :KODLOK, :KODLOK) ?};
      {? EANL.first
      || EANP.use('eanp'+EANL.MG().ODDZ+'__');
         EANN.use('eann'+EANL.MG().ODDZ+'__');
         EANW.use('eanw'+EANL.MG().ODDZ+'__');
         ST.ODDZ:=ST.ODDZ_KOD:=EANL.MG().ODDZ;
         EANP.prefix()
      || _dom:='c';
         ST.ODDZ:=ST.ODDZ_KOD:={? _dom<>'' || _dom || 'c' ?};
         EANN.use('eann'+ST.ODDZ+'__');
         EANP.use('eanp'+ST.ODDZ+'__');
         EANW.use('eanw'+ST.ODDZ+'__');
         EANP.prefix()
      ?}
   || _dom:='c';
      ST.ODDZ:=ST.ODDZ_KOD:={? _dom<>'' || _dom || 'c' ?};
      EANN.use('eann'+ST.ODDZ+'__');
      EANP.use('eanp'+ST.ODDZ+'__');
      EANW.use('eanw'+ST.ODDZ+'__');
      EANP.prefix()
   ?};
   {? (2+(9-:REFX))='__'
   || {? EANP.seek(BB.sqlint('eanp'+(3+(8-:REFX))+' '+(:REFX+8)),'eanp'+(3+(8-:REFX))) & $EANP.EANN=:REFE
      || EANN.use('eann'+(3+(8-:REFX)));
         EANL.cntx_psh();
         EANL.index('KOD');
         EANL.prefix(:KODLOK,:KODLOK);
         _eanl:={? EANL.first() || EANL.ref() || null ?};
         EANL.cntx_pop();
         EANP.LOKDO:=_eanl;
         EANP.ILS:=:ILS;
         EANP.put();
         {? EANP.EANN().TYP='W' & EANP.M<>null & EANP.LOKZ<>null
         || _mat:=EANP.M;
            _mag:=EANP.LOKZ().MG;
            EANN.cntx_psh();
            EANP.cntx_psh();
            exec('open','open_tab',ODDZ.KOD,form((EANP.EANN().DATA~1)-2000,-2,0,'99'));
            exec('obl_stan','magazyn_stan',_mat,1,_mag);
            EANN.cntx_pop();
            EANP.cntx_pop()
         ?}
      ?}
   || EANP.index('UNIK');
      EANP.prefix(:REFX,:REFX);
      {? EANP.first
      || {!
         |? {? $EANP.EANN=:REFE
            || EANP.ILS:=:ILS;
               EANP.put();
               {? EANP.EANN().TYP='W' & EANP.M<>null & EANP.LOKZ<>null
               || _mat:=EANP.M;
                  _mag:=EANP.LOKZ().MG;
                  EANN.cntx_psh();
                  EANP.cntx_psh();
                  exec('open','open_tab',ODDZ.KOD,form((EANP.EANN().DATA~1)-2000,-2,0,'99'));
                  exec('obl_stan','magazyn_stan',_mat,1,_mag);
                  EANN.cntx_pop();
                  EANP.cntx_pop()
               ?};
               0
            || EANP.next()
            ?}
         !}
      ?}
   ?}
end formula

sql
   select * from FIRMA where 1=0
end sql

formula

end formula

end proc


proc pz

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: generacja dokumentu przychodowego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   ndate1 Integer, data rok
   ndate2 Integer, data miesiac
   ndate3 Integer, data dzien
   nunik  String[20], unikalny kod operacji
   ntyp   String[1], typ operacji
   nkh    String[20], kod lub nazwa KH
   nrc    Integer, Numer czytnika
   pean   String[30], EAN do towaru
   pils:=0 Real, ilosc szczytana
   pil:=0 Real, ilosc
   pt     String[50], Kod towaru
   plokz  String[20],Kod lokalizacji
   plp:=0 Real, pozycja pozycji
   punik  String[20], unikalny kod pozycji
   nstan  String[1], Stan EANN
   nuser  String[20], user
   plokdo String[20],lokalizacja do
   uwagi:='' String[255], uwagi
   tw1    Integer, termin waznosci rok
   tw2    Integer, termin waznosci miesiac
   tw3    Integer, termin waznosci dzien
   ILP:=0 INTEGER, ilosc pozycji
   LOK_INW:='' String[20], kod lokalizacji
   pal String[30], kod palety
   ILODCZYT:=0 Real, ilosc odczytana
   rodz:='Z' String[2], rodzaj operacji
   sdate1 Integer, data z servera rok
   sdate2 Integer, data z servera miesiac
   sdate3 Integer, data z servera dzien
   tymczas:='' String[30], tymczas
   zpalet:=0 Integer, z palet
   paldoean String[30], kod palety do
   refsql String[16], ref zamowienia
   scean:='' String[30], kod kreskowy identyfikacji
   zlean:='' String[30], kod kreskowy zlecenia
end params

formula
  {? :ntyp='L' || _spis:=1; :ntyp:='R' || _spis:=0 ?};
  EANL.index('KOD');
  EANL.prefix(:plokz,:plokz);
  {? EANL.first()
  || ST.ODDZ:=ST.ODDZ_KOD:=EANL.MG().ODDZ;
     EANN.use('eann'+EANL.MG().ODDZ+'__');
     EANP.use('eanp'+EANL.MG().ODDZ+'__');
     EANW.use('eanw'+EANL.MG().ODDZ+'__');
     _lok:=EANL.ref
  || _dom:='c';
     ST.ODDZ:=ST.ODDZ_KOD:={? _dom<>'' || _dom || 'c' ?};
     EANN.use('eann'+ST.ODDZ+'__');
     EANP.use('eanp'+ST.ODDZ+'__');
     EANW.use('eanw'+ST.ODDZ+'__');
     _lok:=null
  ?};
  _lok_inw:=null;
  {? :LOK_INW<>''
  || EANL.index('KOD');
     EANL.prefix(:LOK_INW,:LOK_INW);
     {? EANL.first
     || _lok_inw:=EANL.ref;
        {? _spis || _lok:=_lok_inw ?}
     ?}
  ?};
  {? :nunik<>''
  || EANN.index('UNIK');
     EANN.prefix(:nunik,:nunik);
     {? EANN.first()
     || {? EANN.TIMER=time(0,0,0)
        || EANN.TIMER:=time();
           EANN.put()
        ?};
        {? :punik<>''
        || EANP.index('UNIK');
           EANP.prefix(:punik,:punik);
           {? ~EANP.first()
           || EANN.STAN:=:nstan;
              EANP.blank();
              EANP.EANN:=EANN.ref;
              EANP.NRC:=EANN.NRC;
              EANP.M:={? :pt='' | (EANN.RODZ+1)='P' || null || exec('FindInSet','#table','M','MATKTM',:pt,:pt) ?};
              EANP.LP:=exec('nr_pozy','magazyn_mob',EANN.ref());
              EANP.IL:=:pil;
              EANP.ILS:=:pils;
              {? EANP.EAN='' | EANP.EANN().STAN<>'Z' || EANP.EAN:=:pean ?};
              EANP.LOKZ:=_lok;
              EANP.LOKDO:={? form(:plokdo)<>'' || exec('FindInSet','#table','EANL','KOD',:plokdo,:plokdo) || null ?};
              EANP.UNIK:=:punik;
              {? date(:tw1,:tw2,:tw3)=date(1753,1,1)
              || EANP.TW:= date(0,0,0)
              || EANP.TW:= date(:tw1,:tw2,:tw3)
              ?};
              EANP.PALEAN:={? :pean<>'' & ((EANP.EANN().RODZ+1)='P') & :zpalet<>2 || form(:pean) || form(:pal) ?};
              EANP.PAL:={? EANP.LOKZ().MG().PAL='T'
                        || exec('FindInSet','#table','PAL','PAL',EANP.PALEAN,EANP.PALEAN)
                        || null
                        ?};
              EANP.TYMCZAS:=:tymczas;
              EANP.ZPALET:=:zpalet;
              {? EANP.ZPALET=2 & :paldoean<>''
              || EANP.PALDOEAN:=:paldoean;
                 EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',:paldoean,:paldoean)
              ?};
              {? EANP.SCEAN='' | EANP.EANN().STAN<>'Z' || EANP.SCEAN:=:scean ?};
              EANP.ZLEAN:=:zlean;
              exec('uzupIDkod','magdok_palety',EANP);
              EANP.add();
              {? EANP.EANN().TYP='W' & EANP.M<>null & EANP.LOKZ<>null
              || exec('obl_stan','magazyn_stan',EANP.M,1,EANP.LOKZ().MG)
              ?};
              {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?}
           || EANP.IL:=:pil;
              EANP.ILS:=:pils;
              EANP.LOKZ:=exec('FindInSet','#table','EANL','KOD',:plokz,:plokz);
              EANP.LOKDO:={? form(:plokdo)<>'' || exec('FindInSet','#table','EANL','KOD',:plokdo,:plokdo) || null ?};
              EANP.PALEAN:={? :pean<>'' & (EANP.EANN().RODZ+1)='P' & :zpalet<>2 || form(:pean) || form(:pal) ?};
              EANP.PAL:={? EANP.LOKZ().MG().PAL='T'
                        || exec('FindInSet','#table','PAL','PAL',EANP.PALEAN,EANP.PALEAN)
                        || null
                        ?};
              EANP.TYMCZAS:=:tymczas;
              {? EANP.ZPALET=2 & :paldoean<>''
              || EANP.PALDOEAN:=:paldoean;
                 EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',:paldoean,:paldoean)
              ?};
              {? EANP.SCEAN='' | EANP.EANN().STAN<>'Z' || EANP.SCEAN:=:scean ?};
              EANP.ZLEAN:=:zlean;
              EANP.put();
              {? EANP.EANN().TYP='W' & EANP.M<>null & EANP.LOKZ<>null
              || exec('obl_stan','magazyn_stan',EANP.M,1,EANP.LOKZ().MG)
              ?};
              {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?};
              {? EANP.PAL<>null & EANP.PAL().AKT='N' || exec('aktywpal','magdok_palety',EANP.PAL) ?}
           ?}
        ?}
     || EANN.clear();
        EANN.blank();
        EANN.UNIK:=:nunik;
        EANN.SYM:=:nunik;
        EANN.TYP:=:ntyp;
        EANN.DATA:=date(:ndate1,:ndate2,:ndate3);
        EANN.DATA_SRV:=date(:sdate1,:sdate2,:sdate3);
        EANN.NKH:=:nkh;
        EANN.KH:={? form(:nkh)<>'' || exec('FindInSet','#table','KH','KOD',:nkh,2) || null ?};
        EANN.NRC:=:nrc;
        EANN.USER:=exec('find_usr','users',:nuser);
        EANN.STAN:=:nstan;
        EANN.TXT1:=:uwagi;
        EANN.TIME:=time();
        EANN.ILP:=:ILP;
        EANN.ILODCZYT:=:ILODCZYT;
        EANN.EANL:=_lok_inw;
        EANN.RODZ:=:rodz;
        EANN.REFSQL:=:refsql;
        EANN.TIMER:=time();
        {? EANN.add() & :punik<>''
        || EANP.index('UNIK');
           EANP.prefix(:punik,:punik);
           {? ~EANP.first()
           || EANP.blank();
              EANP.LP:=exec('nr_pozy','magazyn_mob',EANN.ref());
              EANP.IL:=:pil;
              EANP.ILS:=:pils;
              {? EANP.EAN='' | EANP.EANN().STAN<>'Z' || EANP.EAN:=:pean ?};
              EANP.M:={? :pt='' | (EANP.EANN().RODZ+1)='P' || null || exec('FindInSet','#table','M','MATKTM',:pt,:pt) ?};
              EANP.LOKZ:=exec('FindInSet','#table','EANL','KOD',:plokz,:plokz);
              EANP.LOKDO:={? form(:plokdo)<>'' || exec('FindInSet','#table','EANL','KOD',:plokdo,:plokdo) || null ?};
              EANP.EANN:=EANN.ref;
              EANP.NRC:=EANN.NRC;
              EANP.UNIK:=:punik;
              {? date(:tw1,:tw2,:tw3)=date(1753,1,1)
              || EANP.TW:= date(0,0,0)
              || EANP.TW:= date(:tw1,:tw2,:tw3)
              ?};
              EANP.PALEAN:={? :pean<>'' & (EANP.EANN().RODZ+1)='P' & :zpalet<>2 || form(:pean) || form(:pal) ?};
              EANP.PAL:={? EANP.LOKZ().MG().PAL='T'
                        || exec('FindInSet','#table','PAL','PAL',EANP.PALEAN,EANP.PALEAN)
                        || null
                        ?};
              EANP.TYMCZAS:=:tymczas;
              EANP.ZPALET:=:zpalet;
              {? EANP.ZPALET=2 & :paldoean<>''
              || EANP.PALDOEAN:=:paldoean;
                 EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',:paldoean,:paldoean)
              ?};
              {? EANP.SCEAN='' | EANP.EANN().STAN<>'Z' || EANP.SCEAN:=:scean ?};
              EANP.ZLEAN:=:zlean;
              exec('uzupIDkod','magdok_palety',EANP);
              EANP.add();
              {? EANP.EANN().TYP='W' & EANP.M<>null & EANP.LOKZ<>null
              || exec('obl_stan','magazyn_stan',EANP.M,1,EANP.LOKZ().MG)
              ?};
              {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?};
              {? EANP.PAL<>null & EANP.PAL().AKT='N' || exec('aktywpal','magdok_palety',EANP.PAL) ?}
           ?}
        ?}
     ?}
  ?}
end formula

sql
  select
    count(*)
  from EANN
  where 1=2
end sql

formula

end formula

end proc


proc usun_poz

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2009]
:: OPIS: usuniecie pozycji operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  nunik String[20], unik
  nstan Real, stan
end params

formula
  {? :nstan=0
  || EANP.index('UNIK');
     EANP.prefix(:nunik,:nunik);
     {? EANP.first || EANP.del ?}
  || 1
  ?}
end formula

sql
  select
    count(*)
  from EANN
  where 2=1
end sql

formula

end formula

end proc


proc akt_czyt

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [2011]
:: OPIS: aktualizuje informacje o aktywnosci czytnika
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   NRC:=0 INTEGER
   DTA:='' STRING[20]
   DOPE:='' STRING[255]
   USER:='' STRING[20]
end params

formula
  EANC.index('NRC');
  EANC.prefix(:NRC);
  {? EANC.first()
  || EANC.DTA:=:DTA;
     EANC.DOPE:=:DOPE;
     EANC.USER:=:USER;
     EANC.put()
  ?}
end formula

sql
 select
   count(*)
 from EANL
end sql

formula

end formula

end proc


proc list_zam

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [12.30]
:: OPIS: lista zamowien wg typow powiazanych z urzadzeniami mobilnymi
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql

select
  ZK_N.REFERENCE REFZAM,
  ZK_N.SYM SYM,
  ZK_N.DP DATA,
  KH.KOD KODKH,
  KH.NAZ NAZKH,
  KH.SKR SKRKH,
  ZL.SYM ZLECENIE,
  SLO.KOD WYDZIAL,
  TYPYZAM.R TYP
from ZK_N
 join TYPYZAM using(ZK_N.T,TYPYZAM.REFERENCE)
 left join KH using(ZK_N.KH,KH.REFERENCE)
 left join ZL using(ZK_N.ZL,ZL.REFERENCE)
 left join SLO using(ZK_N.WYD,SLO.REFERENCE)
where ZK_N.REFERENCE like 'zknag_\_\_%' escape '\'
  and ZK_N.STAN like '%REA%'
  and TYPYZAM.MOB='T'

union all

select
  ZD_NAG.REFERENCE REFZAM,
  ZD_NAG.SYM SYM,
  ZD_NAG.DATA DATA,
  KH.KOD KODKH,
  KH.NAZ NAZKH,
  KH.SKR SKRKH,
  '' ZLECENIE,
  '' WYDZIAL,
  TYPYZAM.R TYP
from ZD_NAG
 join TYPYZAM using(ZD_NAG.T,TYPYZAM.REFERENCE)
 join KH using(ZD_NAG.KH,KH.REFERENCE)
where ZD_NAG.REFERENCE like 'zdnag_\_\_%' escape '\'
  and (ZD_NAG.STAN='A' or ZD_NAG.STAN='C')
  and TYPYZAM.MOB='T'

end sql

formula

end formula

end proc


proc eann_adu

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [1410]
:: OPIS: dodawanie poprawianie usuwanie rekodru z tabeli EANN
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   oper_adu  String[1], Operacja Add Del Update
   unik      String[20], unikalny kod operacji
   typ       String[1], typ operacji
   nrc       Integer, Numer czytnika
   kh        String[20], kod lub nazwa KH
   data      String[10], Data dokumentu
   usr       String[20], Uzytkownik
   stan      String[1], Stan EANN
   ref_zam   String[16], ref zamowienia
   txt1:=''  String[255], uwagi
   ilp:=0    INTEGER, ilosc pozycji
   ilodczyt:=0 Real, ilosc odczytana
   lok_inw:='' String[20], kod lokalizacji
   rodz:='Z' String[2], rodzaj operacji
   zlean:='' String[30], kod identyfikujacy zlecenie
   kodkh:='' String[10], kod kontrahenta
end params

formula
  :oper_adu:=(~-:oper_adu);
  _autoref:=0;
  exec('usun_trigger','synchro');
  __wyn:=0;
  EANC.index('NRC');
  EANC.prefix(:nrc);
  {? EANC.first()
  ||
     ST.ODDZ:=ST.ODDZ_KOD:=EANC.ODDZ().KOD;
     EANN.use('eann'+ST.ODDZ+'__');
     EANP.use('eanp'+ST.ODDZ+'__');
     EANW.use('eanw'+ST.ODDZ+'__');

     _lok_inw:=null;
     {? :lok_inw<>''
     || EANL.index('EAN');
        EANL.prefix(:lok_inw,:lok_inw);
        {? EANL.first
        || _lok_inw:=EANL.ref
        ?}
     ?};

     {? :unik<>'' & :oper_adu<>'D'
     || EANN.index('UNIK');
        EANN.prefix(:unik,:unik);
        {? EANN.first()
        || {? EANN.TIMER=time(0,0,0)
           || EANN.TIMER:=time()
           ?};
           EANN.UNIK:=:unik;
           EANN.TYP:={? :typ='L' || 'R' || :typ ?};
           EANN.DATA:=exec('str2date','#convert',:data);
           EANN.NKH:=:kh;
           EANN.KH:={? form(:kodkh)<>'' || exec('FindInSet','#table','KH','KOD',:kodkh,2) || null ?};
           EANN.NRC:=:nrc;
           EANN.USER:=exec('find_usr','users',:usr);
           EANN.STAN:=:stan;
           EANN.TXT1:=:txt1;
           EANN.TIME:=time();
           EANN.ILP:=:ilp;
           EANN.ILODCZYT:=:ilodczyt;
           EANN.EANL:=_lok_inw;
           EANN.RODZ:=:rodz;
           EANN.REFSQL:=:ref_zam;
           EANN.ZLEAN:=:zlean;
           {? EANN.STAN='Z' & EANN.TIMEZ=time(0,0,0) || EANN.TIMEZ:=time() ?};
           __wyn:=EANN.put()
        || EANN.clear();
           EANN.blank();
           EANN.UNIK:=:unik;
           EANN.SYM:={? :typ='L' || 'Zmiana lokalizacji'
                     |? :typ='P' || 'Przyjęcie dostawy'
                     |? :typ='W' || 'Wydanie magazynowe'
                     |? :typ='I' || 'Inwentaryzacja'
                     || :unik
                     ?};
           EANN.TYP:={? :typ='L' || 'R' || :typ ?};
           EANN.DATA:=exec('str2date','#convert',:data);
           EANN.NKH:=:kh;
           EANN.KH:={? form(:kodkh)<>'' || exec('FindInSet','#table','KH','KOD',:kodkh,2) || null ?};
           EANN.NRC:=:nrc;
           EANN.USER:=exec('find_usr','users',:usr);
           EANN.STAN:=:stan;
           EANN.TXT1:=:txt1;
           EANN.TIME:=time();
           EANN.ILP:=:ilp;
           EANN.ILODCZYT:=:ilodczyt;
           EANN.EANL:=_lok_inw;
           EANN.RODZ:=:rodz;
           EANN.REFSQL:=:ref_zam;
           EANN.ZLEAN:=:zlean;
           EANN.TIMER:=time();
           {? EANN.STAN='Z' || EANN.TIMEZ:=time() || EANN.TIMEZ=time(0,0,0) ?};
           __wyn:=EANN.add()
        ?};
        {? __wyn & EANN.STAN='Z' & exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT)
        || _autoref:=EANN.ref()
        ?}
     || EANN.index('UNIK');
        EANN.prefix(:unik,:unik);
        {? EANN.first() & EANN.count()=0
        || exec('ustaw_trigger','synchro');
           __wyn:=EANN.del(1,1);
           {? __wyn>0 || __wyn:=1 ?}
        ?}
     ?}
  ?};
  {? :oper_adu<>'D' || exec('ustaw_trigger','synchro') ?}
end formula

sql
  select
    '                    ' as unik,
    0 as wyn
  from OKR
  where 1=2
end sql

formula
:RS.blank();
:RS.UNIK:=:unik;
:RS.WYN:=__wyn;
:RS.add()
end formula

end proc


proc eanp_adu

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [1410]
:: OPIS: dodawanie poprawianie usuwanie rekodru z tabeli EANP
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   oper_adu  String[1], Operacja Add Del Update
   eann      String[20], unikalny kod operacji EANN-UNIK
   unik      String[20], unikalny kod pozycji
   nrc       Integer, Numer czytnika
   pt        String[50], Kod towaru
   ean       String[30], EAN do towaru
   lokz      String[20],Kod lokalizacji
   lokdo     String[20],lokalizacja do
   tw        String[10], termin waznosci
   pal       String[30], kod palety
   paldoean  String[30], kod palety do

   ils:=0    Real, ilosc szczytana
   il:=0     Real, ilosc
   zpalet:=0 Integer, z palet
   tymczas:='' String[30], tymczas
   scean:='' String[30], kod identyfikujacy
   zlean:='' String[30], kod identyfikujacy zlecenie

end params

formula
  :oper_adu:=(~-:oper_adu);
  _autoref:=null();
  exec('usun_trigger','synchro');
  __wyn:=0;
  EANC.index('NRC');
  EANC.prefix(:nrc);
  {? EANC.first()
  ||
     ST.ODDZ:=ST.ODDZ_KOD:=EANC.ODDZ().KOD;
     EANN.use('eann'+ST.ODDZ+'__');
     EANP.use('eanp'+ST.ODDZ+'__');
     EANW.use('eanw'+ST.ODDZ+'__');

     EANL.index('KOD');
     EANL.prefix(:lokz,:lokz);
     {? EANL.first()
     ||
        _lok:=EANL.ref
     ||
        _lok:=null
     ?};

     {? :eann<>''& :unik<>'' & :oper_adu<>'D'
     || EANN.index('UNIK');
        EANN.prefix(:eann,:eann);
        {? EANN.first()
        || _endeann:=EANN.TYP<>'R' & EANN.STAN='Z' & exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT);
           {? EANN.TIMER=time(0,0,0)
           || EANN.TIMER:=time();
              EANN.put()
           ?};
           {? :unik<>''
           || EANP.index('UNIK');
              EANP.prefix(:unik,:unik);
              {? ~EANP.first()
              || _rozn:=:ils;
                 EANP.blank();
                 EANP.EANN:=EANN.ref;
                 EANP.NRC:=EANN.NRC;
                 EANP.M:={? :pt='' | (EANN.RODZ+1)='P' || null || exec('FindInSet','#table','M','MATKTM',:pt,:pt) ?};
                 EANP.LP:=exec('nr_pozy','magazyn_mob',EANN.ref());
                 EANP.IL:=:il;
                 EANP.ILS:=:ils;
                 EANP.EAN:=:ean;
                 EANP.LOKZ:=_lok;
                 EANP.LOKDO:={? form(:lokdo)<>'' || exec('FindInSet','#table','EANL','KOD',:lokdo,:lokdo) || null ?};
                 EANP.UNIK:=:unik;
                 _data_tw:=exec('str2date','#convert',:tw);
                 {? _data_tw=date(1753,1,1)
                 || EANP.TW:=date(0,0,0)
                 || EANP.TW:=_data_tw
                 ?};
                 _spis:=EANP.EANN().EANL<>null() & EANP.EANN().TYP='R';
                 {? EANP.LOKZ().MG().PAL='T'
                 || EANP.PALEAN:={? :ean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
                                 || form(:ean)
                                 || form(:pal)
                                 ?};
                    EANP.PAL:={? EANP.LOKZ().MG().PAL='T' | EANP.EANN().EANL().MG().PAL='T'
                              || exec('FindInSet','#table','PAL','PAL',EANP.PALEAN,EANP.PALEAN)
                              || null
                              ?}
                 || EANP.PALEAN:='';
                    EANP.PAL:=null()
                 ?};
                 EANP.TYMCZAS:=:tymczas;
                 EANP.ZPALET:=:zpalet;
                 {? EANP.ZPALET=2 & :paldoean<>''
                 || EANP.PALDOEAN:=:paldoean;
                    EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',:paldoean,:paldoean)
                 ?};
                 EANP.SCEAN:=:scean;
                 EANP.ZLEAN:=:zlean;
                 exec('aktzwmkodk','kody_kresk',EANP.M,:scean,1);
                 exec('aktzwmkodk','kody_kresk',EANP.M,:zlean,1);
                 exec('uzupIDkod','magdok_palety',EANP);
                 __wyn:=EANP.add();
                 exec('aktstmag','magazyn_stan',,,,,_rozn);
                 {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?}
              |? ~_endeann
              || _rozn:=:ils-EANP.ILS;
                 EANP.NRC:=EANN.NRC;
                 EANP.IL:=:il;
                 EANP.ILS:=:ils;
                 EANP.LOKZ:=exec('FindInSet','#table','EANL','KOD',:lokz,:lokz);
                 EANP.LOKDO:={? form(:lokdo)<>'' || exec('FindInSet','#table','EANL','KOD',:lokdo,:lokdo) || null ?};
                 _spis:=EANP.EANN().EANL<>null() & EANP.EANN().TYP='R';
                 {? EANP.LOKZ().MG().PAL='T'
                 || EANP.PALEAN:={? :ean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
                                 || form(:ean)
                                 || form(:pal)
                                 ?};
                    EANP.PAL:={? EANP.LOKZ().MG().PAL='T' | EANP.EANN().EANL().MG().PAL='T'
                              || exec('FindInSet','#table','PAL','PAL',EANP.PALEAN,EANP.PALEAN)
                              || null
                              ?}
                 || EANP.PALEAN:='';
                    EANP.PAL:=null()
                 ?};
                 EANP.TYMCZAS:=:tymczas;
                 {? EANP.ZPALET=2 & :paldoean<>''
                 || EANP.PALDOEAN:=:paldoean;
                    EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',:paldoean,:paldoean)
                 ?};
                 EANP.SCEAN:=:scean;
                 EANP.ZLEAN:=:zlean;
                 exec('aktzwmkodk','kody_kresk',EANP.M,:scean,1);
                 exec('aktzwmkodk','kody_kresk',EANP.M,:zlean,1);
                 __wyn:=EANP.put();
                 exec('aktstmag','magazyn_stan',,,,,_rozn);
                 {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?};
                 {? EANP.PAL<>null & EANP.PAL().AKT='N' || exec('aktywpal','magdok_palety',EANP.PAL) ?}
              ?};
              {? ~_endeann & EANN.TYP<>'R' & EANN.STAN='Z'
              || _endeann:=exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT)
              ?};
              {? _endeann || _autoref:=EANN.ref() ?}
           ?}
        ?}
     || EANP.index('UNIK');
        EANP.prefix(:unik,:unik);
        {? EANP.first()
        || _aktst:=EANP.LOKZ<>null() & (';WZ'*EANP.EANN().TYP)>1;
           {? _aktst
           || _mat:=EANP.M;
              _mag:=EANP.LOKZ().MG;
              _pal:=EANP.PAL;
              _msk:=form((EANP.EANN().DATA~1)-2000,-2,0,'99');
              _rozn:=-EANP.ILS
           ?};
           __wyn:=EANP.del(1,1);
           {? __wyn>0
           || {? _aktst || exec('aktstmag','magazyn_stan',_mat,_mag,_pal,_msk,_rozn) ?};
              __wyn:=1
           ?}
        ?}
     ?}
  ?};
  exec('ustaw_trigger','synchro')

end formula

sql
  select
    '                    ' as unik,
    0 as wyn
  from OKR
  where 1=2
end sql

formula
:RS.blank();
:RS.UNIK:=:unik;
:RS.WYN:=__wyn;
:RS.add()
end formula

end proc


proc eanc_adu

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [17.00]
:: OPIS: aktualizuje informacje o aktywnosci czytnika
::       obecnie obslugiwana tylko opcja - Update
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   oper_adu  String[1], Operacja Add Del Update
   NRC:=0 INTEGER
   DTA:='' STRING[20]
   DOPE:='' STRING[20]
   USER:='' STRING[20]
end params

formula
  exec('usun_trigger','synchro');
   __wyn:=0;
   {? (~-:oper_adu)='U'
   ||
     EANC.index('NRC');
     EANC.prefix(:NRC);
     {? EANC.first()
     || EANC.DTA:=:DTA;
        EANC.DOPE:=:DOPE;
        EANC.USER:=:USER;
        __wyn:=EANC.put()
     ?}
   ?};
   exec('ustaw_trigger','synchro')
end formula

sql
  select
    '                    ' as unik,
    0 as wyn
  from OKR
  where 1=2
end sql

formula
:RS.blank();
:RS.UNIK:=$:NRC;
:RS.WYN:=__wyn;
:RS.add()
end formula

end proc


proc serverDTTM

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [17.42]
:: OPIS: zwraca datę i czas z serwera
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

sql

  select top 1
    CURRENT_DATE as DT,
    CURRENT_TIME as TM
  from FIRMA

end sql

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 97826a1154f1cc96e9aa21d51ecd60f4396150842db739dd30947c7df68e3537db76e011d9ea928999b4b6b7779216d26533f70d08327bc96460f252c483528497cd3bc21e4f924d4b7d3d7b79c6886fa94ec02e976de8e9ba047b1900219ad5c57fe7c1e904254f036f142a59f67155b7037d52f59e9a94fc434aa595b87ebf
