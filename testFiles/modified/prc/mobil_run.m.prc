:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: mobil_run.prc [18.22]
# Utworzony: 23.02.2018
# Autor: [rr]
# Systemy: Merit-LMG
#=======================================================================================================================
# Zawartosc: Procedury obsługi wymiany danych z urzadzeniami mobilnymi - ONLINE VERSION
#=======================================================================================================================


proc stan

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę aktualnych stanów magazynowych
::       Podany kod kreskowy może być kodem indeksu materiałowego lub lokalizacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  kodk:=''   String[128], Kod kreskowy
  idlok:=''  String[31],  IDADD lokalizacji
  ideann:='' String[31],  IDADD EANN do pominięcia
end params

formula

'NUCO - zamaiana odczytanego kodu na duze litery';
{? (+:kodk)<>48 || :kodk:=~-:kodk ?};
'NUCO - przeczytanie kodu bez kresek - obsluga';
{? +:kodk=12 & :kodk*'-'=0
|| :kodk:=(2+:kodk)+'-'+(4+(2-:kodk))+'-'+(:kodk+6)
?}

end formula


sql

select
  SPACE(31) as ID_MAT,
  SPACE(31) as ID_LOK,
  SPACE(8) as MAG,
  SPACE(50) as KTM,
  SPACE(100) as NAZ,
  SPACE(10) as JM,
  SPACE(128) as KOD,
  SPACE(120) as OPIS,
  SPACE(10) as TW,
  CAST (0 as REAL_TYPE) as IL,
  SPACE(50) as KODK,
  SPACE(1) as RESTYP,
  SPACE(255) as DOSTAWA,
  CAST (0 as REAL_TYPE) as ILW,
  CAST (0 as REAL_TYPE) as ILP,
  CAST (0 as REAL_TYPE) as ILD,
  SPACE(1) as STAN,
  SPACE(10) as J2,
  CAST (0 as REAL_TYPE) as IL2,
  CAST (0 as REAL_TYPE) as WS2,
  SPACE(31) as ID_PAL,
  SPACE(255) as DOSTAWA2,
  SPACE(48) as IDSTAN
from FIRMA
where 1=2
order by 3,4,9

end sql

formula
  _log:=0;
  _res:=0;
  _typ:='';
  _idstan:='';
  {? (+:ideanc)<>31
  || exec('addKO','magazyn_mob',:RS,'ERR','Niepoprawny ID urządzenia')
  |? form(:kodk)=''
  || exec('addKO','magazyn_mob',:RS,'ERR','Nie podano kodu kreskowego')
  || _log:=1;
     _oddz:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     {? _oddz=''
     || exec('addKO','magazyn_mob',:RS,'ERR','Nie przypisano do oddziału')
     || exec('stan_open','open_tab',_oddz,form((date()~1)-2000));
        exec('openean','open_tab',_oddz+'__');
        _mat:=exec('FindInSet','#table','MKODK','KK',:kodk,:kodk,"MKODK.M",,,null());
        _sld:=0;
        _lok:=null();
        _pal:=null();
        {? _mat=null()
        || _lok:=exec('FindInSet','#table','EANL','EAN',:kodk,:kodk,,,,null());
           {? _lok=null()
           || _pal:=exec('FindInSet','#table','PAL','PAL',:kodk,:kodk,,,,null())
           ?}
        || _typ:=exec('FindInSet','#table','MKODK','KK',:kodk,:kodk,"MKODK.IDMOB",,,'N');
           _sld:=(';DAPZ'*_typ)>1
        ?};
        _domtw:='0000/00/00';
        _buf:=ref_tab(:kodk);
        _ref_sl:={? type_of(_buf)>117 & _buf=SL || exec('FindAndGet','#table',SL,:kodk,,,null()) || null() ?};
        {? _ref_sl<>null()
        || SLD.index('SL');
           SLD.prefix(_ref_sl);
           {? SLD.first()
           || _idstan:='';
              _res:=SLD.size();
              {!
              |? _kodk:=SLD.SCEAN;
                 _tw:={? SLD.SL().TW=date(0,0,0) || _domtw || $SLD.SL().TW ?};
                 _opis:=exec('FindInSet','#table','MKODK','KK',SLD.SCEAN,SLD.SCEAN,"MKODK.OPMOB",,,'');
                 _opis2:=exec('FindInSet','#table','MKODK','KK',SLD.SCEAN,SLD.SCEAN,"MKODK.OPMOB2",,,'');
                 _ilw:=exec('oblmeanp','magazyn_stan',SLD.SL().MG,SLD.SL().M,SLD.SL().EANL,SLD.SL().TW
                        ,,,1,_kodk,1,:ideann);
                 _ilp:=exec('oblmeanpReo','magazyn_stan',SLD.SL().MG,SLD.SL().M,SLD.SL().EANL,SLD.SL().TW
                        ,_kodk,:ideann);
                 _ild:=SLD.IL-_ilw+_ilp;
                 _wsm:=exec('oblWSP','jm',SLD.SL().M);
                 _il2:={? _wsm<>0 || SLD.IL/_wsm || 0 ?};
                 exec('addKO','magazyn_mob',:RS
                  ,SLD.SL().M().IDADD,SLD.SL().EANL().IDADD,SLD.SL().MG().SYM
                  ,SLD.SL().M().KTM,SLD.SL().M().N,SLD.SL().M().J().KOD
                  ,SLD.SL().EANL().KOD,SLD.SL().EANL().OP
                  ,_tw,SLD.IL,SLD.SCEAN,'D',_opis,_ilw,_ilp,_ild,'T',SLD.SL().M().J2().KOD,_il2,_wsm
                  ,SLD.SL().PAL().IDADD,_opis2,_idstan);
                 SLD.next()
              !}
           ?}
        |? _mat<>null()
        || _wsm:=exec('oblWSP','jm',_mat);
           'znaleziono materiał';
           {? ~_sld
           || _typ:='M';
              'wg materiału';
              SL.index('M');
              SL.prefix(_mat);
              {? SL.first()
              || _res:=SL.size();
                 {!
                 |? {? :idlok='' | :idlok=SL.EANL().IDADD
                    || SLD.index('SL');
                       SLD.prefix(SL.ref());
                       _idstan:={? SLD.first() || SL.uidref() || '' ?};
                       _tw:={? SL.TW=date(0,0,0) || _domtw || $SL.TW ?};
                       _ilw:=exec('oblmeanp','magazyn_stan',SL.EANL().MG,_mat,SL.EANL,SL.TW,,,1,,1,:ideann);
                       _ilp:=exec('oblmeanpReo','magazyn_stan',SL.EANL().MG,_mat,SL.EANL,SL.TW,,:ideann);
                       _ild:=SL.IL-_ilw+_ilp;
                       _ws2:={? SL.IL>0 & SL.IL2>0 || SL.IL/SL.IL2
                             |? SL.M().J2<>null()  || _wsm
                             || 0
                             ?};
                       exec('addKO','magazyn_mob',:RS
                        ,SL.M().IDADD,SL.EANL().IDADD,SL.EANL().MG().SYM
                        ,SL.M().KTM,SL.M().N,SL.M().J().KOD
                        ,SL.EANL().KOD,SL.EANL().OP
                        ,_tw,SL.IL,SL.EANL().EAN,'M','',_ilw,_ilp,_ild,'T',SL.M().J2().KOD
                        ,SL.IL2,_ws2,SL.PAL().IDADD,'',_idstan)
                    ?};
                    SL.next()
                 !}
              || _idadd:=exec('FindAndGet','#table',M,_mat,,"IDADD",'');
                 _ktm:=exec('FindAndGet','#table',M,_mat,,"KTM",'');
                 _naz:=exec('FindAndGet','#table',M,_mat,,"N",'');
                 _jm:=exec('FindAndGet','#table',M,_mat,,"J().KOD",'');
                 _j2:=exec('FindAndGet','#table',M,_mat,,"{? J2<>null() || J2().KOD || '' ?}",'');
                 exec('addKO','magazyn_mob',:RS,_idadd,'','',_ktm,_naz,_jm,'','',_domtw,0,'','M','',0,0,0,'N'
                  ,_j2,0,_wsm,'','')
              ?}
           || _typ:='D';
              'wg atrybutów dostawy';
              _idstan:='';
              SLD.index('SCEAN');
              SLD.prefix(:kodk,:kodk);
              {? SLD.first()
              || _res:=SLD.size();
                 {!
                 |? {? :idlok='' | :idlok=SLD.SL().EANL().IDADD
                    || _tw:={? SLD.SL().TW=date(0,0,0) || _domtw || $SLD.SL().TW ?};
                       _opis:=exec('FindInSet','#table','MKODK','KK',:kodk,:kodk,"MKODK.OPMOB",,,'');
                       _opis2:=exec('FindInSet','#table','MKODK','KK',:kodk,:kodk,"MKODK.OPMOB2",,,'');
                       _ilw:=exec('oblmeanp','magazyn_stan',SL.EANL().MG,_mat,SL.EANL,SL.TW,,,1,:kodk,1,:ideann);
                       _ilp:=exec('oblmeanpReo','magazyn_stan',SL.EANL().MG,_mat,SL.EANL,SL.TW,:kodk,:ideann);
                       _ild:=SLD.IL-_ilw+_ilp;
                       _il2:={? _wsm<>0 || SLD.IL/_wsm || 0 ?};
                       exec('addKO','magazyn_mob',:RS
                        ,SLD.SL().M().IDADD,SLD.SL().EANL().IDADD,SLD.SL().EANL().MG().SYM
                        ,SLD.SL().M().KTM,SLD.SL().M().N,SLD.SL().M().J().KOD
                        ,SLD.SL().EANL().KOD,SLD.SL().EANL().OP
                        ,_tw,SLD.IL,SLD.SCEAN,'D',_opis,_ilw,_ilp,_ild,'T',SLD.SL().M().J2().KOD,_il2,_wsm
                        ,SLD.SL().PAL().IDADD,_opis2,_idstan)
                    ?};
                    SLD.next()
                 !}
              || _idadd:=exec('FindAndGet','#table',M,_mat,,"IDADD",'');
                 _ktm:=exec('FindAndGet','#table',M,_mat,,"KTM",'');
                 _naz:=exec('FindAndGet','#table',M,_mat,,"N",'');
                 _jm:=exec('FindAndGet','#table',M,_mat,,"J().KOD",'');
                 _j2:=exec('FindAndGet','#table',M,_mat,,"{? J2<>null() || J2().KOD || '' ?}",'');
                 exec('addKO','magazyn_mob',:RS,_idadd,'','',_ktm,_naz,_jm,'','',_domtw,0,'','D','',0,0,0,'N'
                  ,_j2,0,_wsm,'','',_idstan)
              ?}
           ?}
        |? _lok<>null()
        || _typ:='L';
           'znaleziono lokalizację';
           SL.index('S1');
           SL.prefix(_lok);
           {? SL.first()
           || _res:=SL.size();
              {!
              |? SLD.index('SL');
                 SLD.prefix(SL.ref());
                 _idstan:={? SLD.first() || SL.uidref() || '' ?};
                 _wsm:=exec('oblWSP','jm',SL.M);
                 _tw:={? SL.TW=date(0,0,0) || _domtw || $SL.TW ?};
                 _ilw:=exec('oblmeanp','magazyn_stan',SL.EANL().MG,SL.M,_lok,SL.TW,,,1,,1,:ideann);
                 _ilp:=exec('oblmeanpReo','magazyn_stan',SL.EANL().MG,SL.M,_lok,SL.TW,,:ideann);
                 _ild:=SL.IL-_ilw+_ilp;
                 _ws2:={? SL.IL>0 & SL.IL2>0 || SL.IL/SL.IL2
                       |? SL.M().J2<>null()  || _wsm
                       || 0
                       ?};
                 exec('addKO','magazyn_mob',:RS
                  ,SL.M().IDADD,SL.EANL().IDADD,SL.EANL().MG().SYM
                  ,SL.M().KTM,SL.M().N,SL.M().J().KOD
                  ,SL.EANL().KOD,SL.EANL().OP
                  ,_tw,SL.IL,SL.M().KODK,'L','',_ilw,_ilp,_ild,'T',SL.M().J2().KOD,SL.IL2,_ws2,SL.PAL().IDADD,''
                  ,_idstan);
                 SL.next()
              !}
           || _idadd:=exec('FindAndGet','#table',EANL,_lok,,"IDADD",'');
              _mgsym:=exec('FindAndGet','#table',EANL,_lok,,"MG().SYM",'');
              _kod:=exec('FindAndGet','#table',EANL,_lok,,"KOD",'');
              _op:=exec('FindAndGet','#table',EANL,_lok,,"OP",'');
              exec('addKO','magazyn_mob',:RS,'',_idadd,_mgsym,'','','',_kod,_op,_domtw,0,'','L','',0,0,0
               ,'N','',0,0,'','',_idstan)
           ?}
        |? _pal<>null()
        || _typ:='P';
           _idstan:='';
           PAL.cntx_psh();
           PAL.prefix();
           {? PAL.seek(_pal)
           || _slidadd:='';
              _slmgsym:='';
              _slkod:='';
              _slopis:='';
              _slean:='';
              SL.cntx_psh();
              SL.use('stl__%1zb'[_oddz]);
              SL.index('PALALL');
              SL.prefix(PAL.ref());
              {? SL.last()
              || _break:=0;
                 {!
                 |? {? SL.IL>0 & SL.EANL<>null()
                    || _il_pal:=0;
                       SL.cntx_psh();
                       SL.index('PALM');
                       SL.prefix(SL.MG,SL.M,SL.PAL);
                       {? SL.first()
                       || {!
                          |? _il_pal+=SL.IL;
                             SL.next()
                          !}
                       ?};
                       SL.cntx_pop();
                       _break:=_il_pal>0
                    ?};
                    {? _break
                    || _slidadd:=SL.EANL().IDADD;
                       _slmgsym:=SL.EANL().MG().SYM;
                       _slkod:=SL.EANL().KOD;
                       _slopis:=SL.EANL().OP;
                       _slean:=SL.EANL().EAN;
                       0
                    || SL.prev()
                    ?}
                 !}
              ?};
              SL.cntx_pop();
              {? PAL.AKT='N'
              || PAL_POZ.use('palet'+form(PAL.AR-2000,-2,0,'99'))
              || PAL_POZ.use('paletyp')
              ?};
              PAL_POZ.index('PAL');
              PAL_POZ.prefix(PAL.ref());
              {? PAL_POZ.first()
              || {!
                 |? _ile:=exec('zwrippal','magdok_palety');
                    {? _ile>0 & PAL_POZ.AKT<>'N'
                    || _tw:={? PAL_POZ.TW=date(0,0,0) || _domtw || $PAL_POZ.TW ?};
                       exec('addKO','magazyn_mob',:RS
                        ,PAL_POZ.M().IDADD,_slidadd,_slmgsym
                        ,PAL_POZ.M().KTM,PAL_POZ.M().N,PAL_POZ.M().J().KOD
                        ,_slkod,_slopis,_tw,_ile,_slean,'P','',0,0,_ile,'T','',0,0,PAL_POZ.PAL().IDADD,'',_idstan)
                    ?};
                    PAL_POZ.next()
                 !}
              ?}
           ?};
           PAL.cntx_pop()
        ?}
     ?}
  ?};
  {? _log
  || _txt:='Przesłano: '+form(_res,0,,'99')+' typu: '+_typ+{? :ideann<>'' || ' eann: '+:ideann || '' ?};
     exec('rejLOG','magazyn_mob'
      ,:ideanc,:idusr,'ANS',:kodk,:idlok,'','','',date(0,0,0),0,'stan@mobil_run',_txt)
  ?}
end formula

end proc


proc eann

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: pobranie nagłówków operacji wg identyfikatora urządzenia
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  typop:=''  String[1],   Typ operacji
  rodzaj:='' String[1],   Rodzaj

  mask:=''   String[8],   Maska
end params

formula
  _oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || '_'
         ?};
  :mask:='eann'+_oddz+'__';
  :rodzaj:={? (';RLO'*:typop)>1 || :typop || '' ?};
  {? (';LO'*:typop)>1 || :typop:='R' ?}
end formula

sql
select /* +MASK_FILTER(EANN,:mask) */
  EANN.IDADD as IDADD,
  EANN.IDEANC as IDEANC,
  EANN.IDUSR as IDUSR,
  SPACE(31) as IDKH,
  SPACE(31) as IDODB,
  SPACE(31) as IDEANL,
  SPACE(31) as IDMG,
  EANN.UNIK as UNIK,
  case
   when (substr(EANN.SYM,1,3)='ret') then '*** PRZYWRÓCONO ***'
   else EANN.SYM
  end as SYM,
  EANN.NRC as NRC,
  EANN.AKT as AKT,
  case
   when (EANN.TYP='R' and EANN.PALEAN<>'') then 'O'
   when (EANN.TYP='R' and not (EANN.EANL is null)) then 'L'
   else EANN.TYP
  end as TYP,
  EANN.STAN as STAN,
  case
   when (EANN.TYP='R' and substr(EANN.REFSQL,1,5)='dokln' and EANN.EANL is null) then 'S'
   when (EANN.TYP='R' and substr(EANN.REFSQL,1,5)='dokln') then 'I'
   else ''
  end as STATUS,
  EANN.RODZ as RODZ,
  to_string(EANN.DATA) as DATA,
  to_string(EANN.TIMER) as CZAS,
  EANN.ILP as ILP,
  SPACE(120) as ADR_DST,
  SPACE(120) as KH,
  SPACE(20) as EANL,
  SPACE(10) as MAG,
  EANN.TXT1 as TXT1,
  EANN.IDREA as REF_REAL,
  SPACE(30) as LOK_INW,
  to_string(EANN.TIMEZ) as TIME_END,
  EANN.ILODCZYT as ILODCZYT,
  to_string(EANN.DATA_SRV) as DATA_SRV,
  EANN.IDZAM as REF_ZAM,
  SPACE(1) as ZN_REO,
  cast (0 AS REAL_TYPE) as IL_OP,
  EANN.ZLEAN as ZLEAN,
  SPACE(8) as KODKH,
  SPACE(20) as SYMZAM,
  EANN.IDZAM as IDZAM,
  SPACE(20) as SYMZL,
  EANN.PALEAN as PALEAN,
  SPACE(100) as HLP_1,
  SPACE(100) as HLP_2,
  SPACE(100) as HLP_3,
  SPACE(100) as HLP_4,
  SPACE(100) as HLP_5
from EANN
where EANN.STAN in ('Z','O','R')
  and EANN.AKT='T'
  and EANN.ZLEC='N'
  and substr(EANN.STAN || EANN.UNIK,1,4)<>'Zret'
  and (EANN.IDEANC=:ideanc or EANN.IDEANC='')
  and (:typop='' or EANN.TYP=:typop)
  and (:rodzaj=''
    or (:rodzaj='L' and not (EANN.EANL is null))
    or (:rodzaj='O' and EANN.PALEAN<>'')
    or (:rodzaj='R' and EANN.EANL is null and EANN.PALEAN=''))
order by STAN,SYM

end sql

formula
   _res:=0;
   :RS.clear;
   {? :RS.first
   || _res:=:RS.size();
      exec('openean','open_tab',:mask+3);
      {!
      |? EANN.index('IDADD');
         EANN.prefix(:RS.IDADD);
         {? EANN.first() & exec('okEANN','magazyn_mobi',EANN.ref(),:ideanc)
         || :RS.IDKH:={? EANN.KH<>null() || EANN.KH().IDADD || '' ?};
            :RS.IDODB:={? EANN.ODB<>null() || EANN.ODB().IDADD || '' ?};
            :RS.IDEANL:={? EANN.EANL<>null() || EANN.EANL().IDADD || '' ?};
            :RS.IDMG:={? EANN.MG<>null() || EANN.MG().IDADD || '' ?};
            :RS.ADR_DST:={? EANN.ODB<>null() || EANN.ODB().MIASTO+' - '+EANN.ODB().UL || '' ?};
            :RS.ADR_DST:=STR.gsub(:RS.ADR_DST,'\'',' ');
            :RS.KH:={? EANN.KH<>null() || EANN.KH().NAZ || EANN.NKH ?};
            :RS.KH:=STR.gsub(:RS.KH,'\'',' ');
            :RS.DATA:=(10+:RS.IDADD);
            :RS.CZAS:=8+(11-:RS.IDADD);
            {? form(:RS.DATA)='' || :RS.DATA:='0000/00/00' ?};
            :RS.ZN_REO:='';
            :RS.IL_OP:=0;
            :RS.DATA_SRV:={? form(:RS.DATA_SRV)='' || '0000/00/00' || :RS.DATA_SRV ?};
            :RS.KODKH:={? EANN.KH<>null() || EANN.KH().KOD || '' ?};
            :RS.MAG:={? EANN.MG<>null() || EANN.MG().SYM || '' ?};
            :RS.SYMZL:={? EANN.ZLEAN<>''
                       || exec('FindInSet','#table','ZL','ZLEAN',EANN.ZLEAN,EANN.ZLEAN,"ZL.SYM",,,'')
                       |? (+EANN.IDZAM)=31
                       || exec('FindAndGet','#table',ZL,EANN.IDZAM,,"SYM",'')
                       || ''
                       ?};
            :RS.SYMZAM:={? EANN.TYP='P' & (+EANN.IDZAM)=31
                        || _symzam:=exec('FindAndGet','#table',ZD_NAG,EANN.IDZAM,,"SYM",'');
                           {? _symzam<>'' || _symzam || exec('FindAndGet','#table',ZDP_NAG,EANN.IDZAM,,"SYM",'') ?}
                        |? (';WZ'*EANN.TYP)>1 & (+EANN.IDZAM)=31
                        || exec('FindAndGet','#table',ZK_N,EANN.IDZAM,,"SYM",'')
                        || ''
                        ?};
            :RS.LOK_INW:={? EANN.TYP='R' & EANN.EANL<>null() || EANN.EANL().EAN || '' ?};
#PeKa - obsluga dodatkowych etykiet na naglowku kompletacji (z procedury def_info)
            :RS.HLP_1:={? (';WZ'*EANN.TYP)>1 & (+EANN.IDZAM)=31 & EANN.KH=null
                       || $exec('FindAndGet','#table',ZK_N,EANN.IDZAM,,"DT",'')
                       || ''
                       ?};
            :RS.HLP_2:={? (';WZ'*EANN.TYP)>1 & (+EANN.IDZAM)=31 & EANN.KH=null
                       || {? exec('FindAndGet','#table',ZK_N,EANN.IDZAM,,"MD<>null",0)
                          || exec('FindAndGet','#table',ZK_N,EANN.IDZAM,
                             ,"'wew. z '+MG().SYM+' do '+MD().SYM+' ,zarejestrował: '+US().DANE",'')
                          || exec('FindAndGet','#table',ZK_N,EANN.IDZAM,
                             ,"T().NAZ+{? MG<>null || ' z mag '+MG().SYM || '' ?}+', zarejestrował: '+US().DANE",'')
                          ?}
                       || 'do kontrahenta: '+EANN.KH().SKR
                       ?};
            :RS.HLP_3:={? (';WZ'*EANN.TYP)>1 & (+EANN.IDZAM)=31 & EANN.KH=null
                       || exec('FindAndGet','#table',ZK_N,EANN.IDZAM,,"OP",'')
                       || ''
                       ?};
            :RS.put(1);
            :RS.next()
         || _res-=1;
            :RS.del()
         ?}
      !}
   ?};
   exec('rejLOG','magazyn_mob'
    ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'eann@mobil_run:'+:typop,'Przesłano: '+form(_res,0,,'99'))
end formula

end proc


proc mat

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca informacje o materiale wg idadd lub kodu kreskowego
::  MOD: PK - parametr kodk pozostal archiwalnie dla aplikacji WIndows CE - procedura wrocila do standardowego wygladu
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idmat:=''  String[31],  Identyfikator materiału (Merit) lub kod kreskowy materiału
  kodk:='__' String[50],  Odczytany kod kreskowy
end params

sql

select
  M.IDADD as IDADD,
  M.KTM as KTM,
  M.N as N,
  M.KODK as KODK,
  JM.KOD as JM,
  M.DOKL as PREC,
  M.A as AKT,
  M.CZY_TW as CZY_TW,
  M.IDMOB as IDMOB,
  M.GOMOB as GOMOB,
  J2.KOD as J2,
  M.WS2 as WS2,
    SPACE(20) as ATR01,
  SPACE(20) as ATR02,
  SPACE(20) as ATR03,
  SPACE(20) as ATR04,
  SPACE(20) as ATR05,
  SPACE(20) as ATR06,
  SPACE(20) as ATR07,
  SPACE(20) as ATR08,
  SPACE(20) as ATR09,
  SPACE(20) as ATR10
from M
  join JM using(M.J,JM.REFERENCE)
  left join JM J2 using (M.J2,J2.reference)
where (M.IDADD=:idmat or M.KODK=:idmat)
order by 2,3

end sql

formula
  {? :RS.size()
  || _txt:='Znaleziono';
     _mat:=exec('FindAndGet','#table',M,:RS.IDADD,,,null());
     M.cntx_psh();
     MJM.cntx_psh();
     M.prefix();
     {? _mat<>null() & M.seek(_mat)
     || {? M.J2=null()
        || MJM.index('JM');
           MJM.prefix(M.ref());
           {? MJM.first() & MJM.find_tab('first','MOD',,'=','T')
           || :RS.J2:=MJM.JM().KOD;
              :RS.WS2:=MJM.PRZ;
              :RS.put(1)
           |? MJM.first() & MJM.find_tab('first','MOB',,'=','T')
           || :RS.J2:=form(:RS.J2);
              :RS.WS2:=-1;
              :RS.put(1)
           ?}
        || :RS.J2:=form(:RS.J2);
           :RS.put(1)
        ?}
     ?};
     MJM.cntx_pop();
     M.cntx_pop()
  || _txt:='Brak'
  ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:idmat,'','','','',date(0,0,0),0,'mat@mobil_run',_txt)
end formula

end proc


proc lok

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca informacje o lokalizacji wg idadd lub kodu kreskowego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idlok:=''  String[31],  Identyfikator lokalizacji (Merit) lub kod kreskowy
  idmag:=''  String[31],  Identyfikator magazynu
  typop:=''  String[1],   Identyfikator operacji
  oddz:=''   String[1],   Oddział
end params

formula
  :oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || '_'
         ?};
'NUCO - zmiana';
   {? (+:idlok)<>31
   || 'Sytuacja kiedy mamy kod który jest napisany małymi literami';
      :idlok:=~-:idlok
   ?}
end formula

sql

select
  EANL.KOD as KOD,
  EANL.OP as OP,
  EANL.IDADD as IDADD,
  EANL.EAN as KODK,
  EANL.BLOK as BLOK,
  EANL.AKT as AKT,
  EANL.DOK as DOK,
  MG.IDADD as IDMAG,
  MG.SYM as MG,
  MG.PAL as CZY_PAL,
  case
   when (MG.PAL='N' and substr(MG.TYP,1,1)='D') then 'T'
   else 'N'
  end as IDMOB
from EANL
join MG using(EANL.MG,MG.REFERENCE)
where (EANL.IDADD=:idlok or EANL.EAN=:idlok) and MG.ODDZ=:oddz
order by 1,4

end sql

formula
  _opis:='';
  {? :RS.first()
  || {? (+:ideanc)<>31
     || _opis:='Nieprawidłowy identyfikator urządzenia'
     |? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
     || _opis:='Nie znaleziono urządzenia'
     |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
     || _opis:='Urządzenie nie jest aktywne w systemie'
     |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
     || _opis:='Brak przypisania oddziału dla urządzenia'
     || _oddz:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
        {? (:typop='P' & exec('FindAndGet','#table',MG,:RS.IDMAG,,"MWS='T' & P_ALL",0))
         | ((';WZ'*:typop)>1 & exec('FindAndGet','#table',MG,:RS.IDMAG,,"MWS='T' & W_ALL",0))
        || _dok:=1;
           :RS.DOK:='T';
           :RS.put(1)
        || _dok:=:RS.DOK='T'
        ?};
        {? _oddz<>exec('FindAndGet','#table',MG,:RS.IDMAG,,"ODDZ",'')
        || _opis:='Lokalizacja pochodzi z innego oddziału'
        ?};
        {? _opis='' & (+:idmag)=31 & :RS.IDMAG<>:idmag
        || _opis:='Lokalizacja pochodzi z innego magazynu'
        ?};
        {? _opis='' & (';PWZ'*:typop)>1 & ~_dok
        || _opis:='Lokalizacja nie jest dostępna dla '
                 +{? :typop='P' || 'przyjęć'
                  |? :typop='W' || 'wydań'
                  |? :typop='Z' || 'kompletacji wysyłki'
                  || ''
                  ?}
        ?};
        {? _opis='' & :RS.BLOK='T'
        || _opis:='Aktualnie lokalizacja %1 jest zablokowana'@[:RS.KOD]
        ?}
     ?};
     {? _opis<>''
     || {! |? :RS.del() !};
        exec('addKO','magazyn_mob',:RS,'ERR',_opis)
     ?}
  ?};
  _txt:={? _opis<>'' || 'Błąd' |? :RS.size() || 'Znaleziono' || 'Brak' ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS','',:idlok,'','','',date(0,0,0),0,'lok@mobil_run',_txt)
end formula

end proc


proc kodk

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca informacje na temat materiału na podstawie podanego kodu kreskowego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  kodk:=''   String[128], Kod kreskowy
  ideann:='' String[31],  IDEANN - idadd nagłówka operacji
end params

formula
  {? (3+:kodk)='GS1'
  || _kodk:=exec('idwgGS1','magazyn_mobi',:kodk);
     {? _kodk<>'' || :kodk:=_kodk ?}
  ||
'NUCO - zamaiana odczytanego kodu na duze litery';
     :kodk:=~-:kodk;
'NUCO - przeczytanie kodu bez kresek - obsluga';
     {? +:kodk=12 & :kodk*'-'=0
     || :kodk:=(2+:kodk)+'-'+(4+(2-:kodk))+'-'+(:kodk+6)
     ?}
  ?}
end formula

sql

select
  MKODK.KODK as EAN,
  case
    when (MKODK.N<>'') then MKODK.N
    else nvl(M.N,'')
  end as OPI,
  MKODK.IL as IL,
  nvl(M.KTM,'') as KOD,
  case
    when (MKODK.M is null) then 'B'
    when (MKODK.D='T') then 'N'
    else MKODK.IDMOB
  end as TYP_EAN,
  MKODK.AKT as AKT,
  MKODK.OPMOB as OPIS,
  MKODK.OPMOB2 as OPIS2,
  MKODK.IDADD as IDADD,
  nvl(M.IDADD,'') as IDMAT,
  nvl(M.CZY_TW,'N') as CZY_TW,
  1 as CZY_ETW,
  '0000/00/00' as TW,
  nvl(JM.KOD,'') as JM,
  nvl(J2.KOD,space(10)) as J2,
  nvl(M.WS2,0) as WS2,
  MKODK.KODK as NEWEAN,
  0 as ROZPAL,
  0 as MANYEAN,
  MKODK.IDADD as IDEANL,
  SPACE(10) as EANL,
  SPACE(50) as SLDIL
from MKODK
  left join M using(MKODK.M,M.REFERENCE)
  left join JM using(M.J,JM.REFERENCE)
  left join JM J2 using (M.J2,J2.reference)
where MKODK.KODK<>'' and MKODK.KODK=:kodk and MKODK.IDMOB<>'O'
order by 1,3

end sql

formula
  {? :RS.size() & :RS.first()
  || _mat:=exec('FindAndGet','#table',M,:RS.IDMAT,,,null());
     _oddz:={? :ideanc<>'' || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'c') || 'c' ?};
     M.cntx_psh();
     MJM.cntx_psh();
     M.prefix();
     {? _mat<>null() & M.seek(_mat)
     || _put:=0;
        _rozpal:=exec('isROZPAL','magazyn_mobi',_mat,:ideann);
        {? M.KODK<>:RS.EAN & _oddz<>''
        || _new:=exec('oldSCEAN','magdok_wspolne',:RS.EAN,_oddz);
           _new.clear();
           {? _new.first()
           || {? _new.size()=1
              || {? _new.KODK<>:RS.EAN
                 || :RS.NEWEAN:=_new.KODK;
                    :RS.MANYEAN:=1;
                    _put:=1
                 ?}
              |? _new.size()=2
              || {!
                 |? {? _new.KODK<>:RS.EAN
                    || :RS.NEWEAN:=_new.KODK;
                       :RS.MANYEAN:=1;
                       _put:=1;
                       0
                    || _new.next()
                    ?}
                 !}
              || :RS.NEWEAN:='<kilka>';
                 :RS.MANYEAN:=2;
                 _put:=1
              ?}
           ?};
           obj_del(_new)
        ?};
        {? M.J2=null()
        || MJM.index('JM');
           MJM.prefix(M.ref());
           {? MJM.first() & MJM.find_tab('first','MOD',,'=','T')
           || :RS.J2:=MJM.JM().KOD;
              :RS.WS2:=MJM.PRZ;
              _put:=1
           |? MJM.first() & MJM.find_tab('first','MOB',,'=','T')
           || :RS.J2:=form(:RS.J2);
              :RS.WS2:=-1;
              _put:=1
           ?}
        || :RS.J2:=form(:RS.J2);
           _put:=1
        ?};
        {? _rozpal>0 || :RS.ROZPAL:=_rozpal; _put:=1 ?};
        {? _put || :RS.put(1) ?}
     ?};
     MJM.cntx_pop();
     M.cntx_pop();
     {? exec('FindAndGet','#table',M,:RS.IDMAT,,"IDMOB='D'",0)
     || _scsql:=exec('FindAndGet','#table',MKODK,:RS.IDADD,,"RSQL",'');
        {? _scsql<>''
        || :RS.TW:=exec('FindAndGet','#table',DK,_scsql,,"$TW",'');
           :RS.put(1)
        ?};
        :RS.CZY_ETW:=exec('FindAndGet','#table',M,:RS.IDMAT,,"SETW<>'P'",1);
        :RS.put(1);
        {? :RS.TW='0000/00/00'
        || :RS.TW:='';
           :RS.put(1)
        ?}
     ?};
     :RS.IDEANL:=exec('oneEANL','magazyn_mobi',:kodk,_oddz);
     :RS.put(1);
'NUCO - zmiana konieczna dla Windows CE';
     _lok:=sql('select distinct EANL.EAN, SLD.IL as IL from @SLD join @SL join EANL where SLD.SCEAN=\':_a\'',:kodk);
     {? _lok.size()=1
     || :RS.EANL:=_lok.EAN;
        :RS.SLDIL:='Stan:'+$_lok.IL;
        :RS.put(1)
     ?};
     _txt:='Znaleziono'
  || _oddz:={? (+:ideanc)=31
            || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
            || '_'
            ?};

     _txt:='Brak';
     EANL.cntx_psh();
     EANL.index('EAN');
     EANL.prefix(:kodk,);
     {? :kodk<>'' & EANL.first()
     || {? EANL.MG().ODDZ<>_oddz
        || _txt:='Inny oddział'
        || :RS.blank();
           :RS.EAN:=EANL.EAN;
           :RS.IL:=0;
           :RS.OPI:=EANL.OP;
           :RS.KOD:=EANL.KOD;
           :RS.TYP_EAN:='L';
           :RS.AKT:={? EANL.AKT='T' || {? EANL.BLOK='T' || 'B' || 'T' ?} || 'N' ?};
           :RS.OPIS:=EANL.OP;
           :RS.OPIS2:='';
           :RS.IDADD:=EANL.IDADD;
           :RS.JM:='';
           :RS.J2:='';
           :RS.WS2:=0;
           :RS.IDEANL:=EANL.IDADD;
           :RS.add(1);
           _txt:='Znaleziono'
        ?}
     ?};
     EANL.cntx_pop();
     {? :kodk<>'' & _txt='Brak'
     || PAL.cntx_psh();
        PAL.use('palety');
        PAL.index('PAL');
        PAL.prefix(:kodk,);
        {? PAL.first()
        || {? PAL.ODD<>_oddz
           || _txt:='Inny oddział'
           || :RS.blank();
              :RS.EAN:=PAL.KODK;
              :RS.IL:=0;
              :RS.OPI:=PAL.TPAL().TYP;
              :RS.KOD:=PAL.STAN;
              :RS.TYP_EAN:='X';
              :RS.AKT:=PAL.AKT;
              :RS.OPIS:='Paleta typu %1'@[PAL.TPAL().TYP];
              :RS.IDADD:=PAL.IDADD;
              :RS.JM:='';
              :RS.J2:='';
              :RS.WS2:=0;
              :RS.IDEANL:='';
              :RS.add(1);
              _txt:='Znaleziono'
           ?}
        ?};
        PAL.cntx_pop()
     ?};
     {? _txt='Brak'
     || {? :kodk=''
        || exec('addKO','magazyn_mob',:RS,'ERR','Nie podano kodu kreskowego')
        || exec('addKO','magazyn_mob',:RS,'ERR','Podany kod %1 nie jest wykorzystywany w systemie'@[:kodk])
        ?}
     |? _txt='Inny oddział'
     || exec('addKO','magazyn_mob',:RS,'ERR','Podany kod %1 dotyczy magazynu innego oddziału'@[:kodk])
     ?}
  ?};

  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:kodk,'','','','',date(0,0,0),0,'kodk@mobil_run',_txt)
end formula

end proc


proc p_cud

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: dodanie/poprawa/usunięcie pozycji operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[50],  Identyfikator operatora urządzenia
  oper_cud:='' String[1],   Operacja Create Update Delete

  idadd:=''    String[31],  IDADD - idadd pozycji operacji
  ideann:=''   String[31],  IDEANN - idadd nagłówka operacji
  idlokz:=''   String[31],  IDLOKZ - idadd lokalizacji Z
  idlokdo:=''  String[31],  IDLOKDO - idadd lokalizacji DO
  idmat:=''    String[31],  IDMAT - idadd materiału
  idpal:=''    String[31],  IDPAL - idadd palety
  idpaldo:=''  String[31],  IDPALDO - idadd palety DO
  eann:=''     String[31],  EANN - Unikalny kod nagłówka operacji
  lokz:=''     String[20],  LOKZ - Kod lokalizacji Z
  lokdo:=''    String[20],  LOKDO - Kod lokalizacji DO
  ean:=''      String[128], EAN - Kod kreskowy
  il:=0        Real,        IL - Ilość
  ils:=0       Real,        ILS - Ilość odczytana
  nrc:=0       Integer,     NRC - Numer czytnika
  lp:=0        Integer,     LP - Liczba porządkowa
  t:=''        String[50],  T - Indeks materiałowy
  tnaz:=''     String[120], TNAZ - Nazwa indeksu materiałowego
  unik:=''     String[20],  UNIK - Unikalny kod pozycji
  tw:=''       String[10],  TW - Termin ważności
  czy_d:=''    String[1],   CZY_D - Pomocnicze
  pal:=''      String[30],  PAL - Kod palety
  akt:=''      String[1],   AKT - Czy aktywny
  zpalet:=0    Integer,     ZPALET - Znacznik wskazania czy operacja paletowa
  palean:=''   String[30],  PALEAN - Kod kreskowy palety Z
  paldoean:='' String[30],  PALDOEAN - Kod kreskowy palety DO
  bezozn:='N'  String[2],   BEZOZN - Pomocnicze
  tymczas:=''  String[30],  TYMCZAS - Pomocnicze
  scean:=''    String[128], SCEAN - Kod kreskowy dostawy
  zlean:=''    String[128], ZLEAN - Kod kreskowy zlecenia
  ilp:=0       Real,        ILP - Ilość pobrana
  gs1:=''      String[12],  GS1 - pole pomocnicze do obsługi GS1
  il2:=0       Real,        IL2 - ilość w drugiej jednostce ewidencyjnej
  ils2:=0      Real,        ILS2 - ilość odczytana w drugiej jednostce ewidencyjnej
  jmp:=''      String[10],  JMP - jednostka miary do przeliczenia
  tpal:=''     String[20],  TPAL - symbol typu palety
  war01:=''    String[25],  WAR01 - wartość atrybutu 01
  war02:=''    String[25],  WAR02 - wartość atrybutu 02
  war03:=''    String[25],  WAR03 - wartość atrybutu 03
  war04:=''    String[25],  WAR04 - wartość atrybutu 04
  war05:=''    String[25],  WAR05 - wartość atrybutu 05
  war06:=''    String[25],  WAR06 - wartość atrybutu 06
  war07:=''    String[25],  WAR07 - wartość atrybutu 07
  war08:=''    String[25],  WAR08 - wartość atrybutu 08
  war09:=''    String[25],  WAR09 - wartość atrybutu 09
  war10:=''    String[25],  WAR10 - wartość atrybutu 10
end params

sql
select
  SPACE(10) as KOD,
  SPACE(100) as OPIS,
  SPACE(50) as UNIK
from FIRMA
where 1=2

end sql

formula
  _result:='ERR';
  _opis:='';

  :oper_cud:=(~-:oper_cud);
  _autoref:=0;
  _ok:=0;
  {? :ideanc=''
  || {? (+:ideann)=31
     || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindInSet','#table','EANN','IDADD',:ideann,,"(1+(4-($EANN.ref())))",,,'');
        _ok:=ST.ODDZ<>''
     ?};
     {? _ok
     || exec('openean','open_tab',ST.ODDZ+'__');
        EANN.index('IDADD');
        EANN.prefix(:ideann);
        {? EANN.first()
        || EANN.IDEANC:=:ideanc;
           EANN.NRC:=exec('FindInSet','#table','EANC','IDADD',:ideanc,,"EANC.NRC",,,0);
           EANN.put(1)
        ?}
     ?}
  ?};
  {? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
  || _opis:='(Merit) Nie znaleziono urządzenia'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
  || _opis:='(Merit) Urządzenie nie jest aktywne w systemie'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
  || _opis:='(Merit) Brak przypisania oddziału dla urządzenia'
  |? :oper_cud<>'D' & form(:ean)=''
  || _opis:='Nie podano kodu kreskowego materiału lub palety'
  |? :oper_cud<>'D' & form(:lokz)=''
  || _opis:='Nie podano lokalizacji'
  || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     _ok:=ST.ODDZ<>''
  ?};
  {? _ok & (+:ideann)=31
   & (_eanc:=exec('FindInSet','#table','EANN','IDADD',:ideann,,"EANN.IDEANC",,,'');
      _eanc<>'' & _eanc<>:ideanc)
  || _opis:='Dana operacja została przekierowana na inne urządzenie. Zapis niemożliwy.';
     _ok:=0
  ?};
  {? _ok
  ||
     exec('openean','open_tab',ST.ODDZ+'__');
     _buf:='';
     _lok:={? (+:idlokz)=31 || exec('FindAndGet','#table',EANL,:idlokz,,,null()) || null() ?};
     _mag:={? :zpalet=2 & _lok<>null() || exec('FindAndGet','#table',EANL,_lok,,"MG",null()) || null() ?};
     _rozpal:=0;
     {? :pal<>'' || _buf:=exec('ctrlKodPal','kody_kresk',:pal) ?};
     {? _buf='' & :palean<>'' || _buf:=exec('ctrlKodPal','kody_kresk',:palean) ?};
     {? _buf='' & :paldoean<>'' || _buf:=exec('ctrlKodPal','kody_kresk',:paldoean) ?};
     {? _buf='' & :ideann<>'' & (:t<>'' | :pal<>'') || _buf:=exec('ctrlEANPcud','magazyn_mob',:ideann,:t,:pal,_mag) ?};
     {? _buf<>'' & _buf='#rozpal' || _rozpal:=1; _buf:='' ?};

     {? _buf<>''
     || _opis:=_buf
     |? :ideann<>'' & :oper_cud<>'D'
     || EANN.index('IDADD');
        EANN.prefix(:ideann);
        {? EANN.first() & EANN.AKT='T'
        || _endeann:=EANN.TYP<>'R' & EANN.STAN='Z' & exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT);
           {? EANN.TIMER=time(0,0,0)
           || EANN.TIMER:=time();
              EANN.put()
           ?};
           _find:=0;
           {? (+:idadd)=31 || _find:=exec('findEANP','magazyn_mobi',EANN.ref(),:idadd,:t) ?};
           {? ~_find
           || EANP.prefix();
              _rozn:=:ils;
              EANP.blank();
              EANP.EANN:=EANN.ref;
              EANP.NRC:=EANN.NRC;
              EANP.M:={? (:t='' | (EANN.RODZ+1)='P') & :zpalet<2
                      || null
                      || exec('FindInSet','#table','M','MATKTM',:t,:t)
                      ?};
              EANP.LP:=exec('nr_pozy','magazyn_mob',EANN.ref());
              EANP.IL:=:il;
              EANP.ILS:=:ils;
              EANP.ILP:=:ilp;
              EANP.IL2:=:il2;
              EANP.ILS2:=:ils2;
              EANP.EAN:=:ean;
              EANP.LOKZ:=_lok;
              EANP.LOKDO:={? (+:idlokdo)=31
                          || exec('FindAndGet','#table',EANL,:idlokdo,,,null())
                          || null
                          ?};
              EANP.UNIK:=:unik;
              _data_tw:=exec('str2date','#convert',:tw);
              EANP.TW:=_data_tw;
              _spis:=EANP.EANN().EANL<>null() & EANP.EANN().TYP='R';
              {? EANP.LOKZ().MG().PAL='T'
              || EANP.PALEAN:={? +(:idpal)
                              || exec('FindAndGet','#table',PAL,:idpal,,"KODK",'')
                              |? :palean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
                              || form(:palean)
                              |? :ean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
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
              _paldoean:={? EANP.EANN().TYP='R' & EANP.EANN().PALEAN<>'' || EANP.EANN().PALEAN || '' ?};
              {? _paldoean<>''
              || EANP.ZPALET:=2;
                 EANP.PALDOEAN:=_paldoean;
                 EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',_paldoean,_paldoean);
                 {? EANP.EANN().EANL<>null() || EANP.LOKDO:=EANP.EANN().EANL ?}
              ?};
              EANP.SCEAN:=:scean;
              EANP.ZLEAN:=:zlean;
              EANP.GS1:=:gs1;
              EANP.JMP:=:jmp;
              EANP.TPAL:=exec('typpal','magazyn_mobi',EANP.EANN,EANP.PALEAN,EANP.EAN,:tpal,null());
#  UTW: [PeKa]
# OPIS: Zablokowanie przesuniecia magazynowego - przy mieszanej reorganizacji magazyn. przesuniecie dziala zle
              EANP.IS_RM:={? EANP.LOKDO<>null() & EANP.LOKZ().MG<>EANP.LOKDO().MG || 'R' || 'R' ?};
              {? EANP.M<>null() & EANP.M().M_ATR<>null()
              || EANP.WAR01:=:war01; EANP.WAR02:=:war02;
                 EANP.WAR03:=:war03; EANP.WAR04:=:war04;
                 EANP.WAR05:=:war05; EANP.WAR06:=:war06;
                 EANP.WAR07:=:war07; EANP.WAR08:=:war08;
                 EANP.WAR09:=:war09; EANP.WAR10:=:war10
              ?};
              exec('aktzwmkodk','kody_kresk',EANP.M,:scean,1);
              exec('aktzwmkodk','kody_kresk',EANP.M,:zlean,1);
              exec('uzupIDkod','magdok_palety',EANP);
              EANP.ROZPAL:=_rozpal;
              {? EANP.add()
              || _result:='ADD';
                 _opis:='Dodano pozycje operacji';
                 :idadd:=EANP.IDADD;
                 exec('uzupdane','magazyn_mob');
                 exec('aktstmag','magazyn_stan',,,,,_rozn);
                 {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?};
#  UTW: NUCO [PeKa]
# OPIS: Wydruk etykiety po poprawie ilosci na urządzeniu (ograniczenie do operacji wydania
# wewnętrznego oraz kompletacji wewnętrznej)
                 _drukuj:='ZW'*EANP.EANN().TYP | 'WW'*EANP.EANN().TYP;
                 {? _drukuj
                 || _user:=exec('FindAndGet','#table',USERS,:idusr,,,null());
                    _drukarka:=exec('get_w','#params',9992,2,_user);
                    _etykieta:=exec('get_w','#params',9993,2,_user);
                    _nawsucha:=exec('get_w','#params',9994,2,_user);
                    {? _drukarka<>'' & _etykieta<>'' & _nawsucha='T' & _rozn
                    || exec('autodruk','qmom',$EANP.ref,_etykieta,_drukarka);
                       _txt:='Wydruk nowej pozycji kompletacji';
                       exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',$EANP.ref
                       ,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
                    || _txt:='Brak parametrów do drukowania';
                        exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',$EANP.ref
                        ,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
                    ?}
                 ?}
# koniec zmiany
              || _opis:='Nie dodano pozycji operacji'
              ?};
              _txt:=form(:idadd)+','
                   +'oper.: '+form(:ideann)+','
                   +'lok.Z: '+form(:lokz)+','
                   +'lok.DO: '+form(:lokdo)+','
                   +'termin: '+form(:tw)+','
                   +'paleta: '+form(:pal)+','
                   +'ilość: '+form(:ils,0,,'99')+','
                   +'dost.: '+form(:scean)+','
                   +'zlec.: '+form(:zlean);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'ADD'
               ,:ean,:idlokz,:idlokdo,:idpal,:idpaldo,EANP.TW,:ils,'p_cud@mobil_run:'+_txt,_opis)
           |? ~_endeann
           || _rozn:=:ils-EANP.ILS;
              EANP.EAN:=:ean;
              EANP.NRC:=EANN.NRC;
              EANP.M:={? (:t='' | (EANN.RODZ+1)='P') & :zpalet<2
                      || null
                      || exec('FindInSet','#table','M','MATKTM',:t,:t)
                      ?};
              EANP.IL:=:il;
              EANP.ILS:=:ils;
              EANP.ILP:=:ilp;
              EANP.IL2:=:il2;
              EANP.ILS2:=:ils2;
              EANP.LOKZ:=exec('FindInSet','#table','EANL','KOD',:lokz,:lokz);
              EANP.LOKDO:={? (+:idlokdo)=31
                          || exec('FindAndGet','#table',EANL,:idlokdo,,,null())
                          || null
                          ?};
              _data_tw:=exec('str2date','#convert',:tw);
              EANP.TW:=_data_tw;
              _spis:=EANP.EANN().EANL<>null() & EANP.EANN().TYP='R';
              {? EANP.LOKZ().MG().PAL='T'
              || EANP.PALEAN:={? +(:idpal)
                              || exec('FindAndGet','#table',PAL,:idpal,,"KODK",'')
                              |? :palean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
                              || form(:palean)
                              |? :ean<>'' & (_spis | (EANP.EANN().RODZ+1)='P') & :zpalet<>2
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
              _paldoean:={? EANP.EANN().TYP='R' & EANP.EANN().PALEAN<>'' || EANP.EANN().PALEAN || '' ?};
              {? _paldoean<>''
              || EANP.ZPALET:=2;
                 EANP.PALDOEAN:=_paldoean;
                 EANP.PALDO:=exec('FindInSet','#table','PAL','PAL',_paldoean,_paldoean);
                 {? EANP.EANN().EANL<>null() || EANP.LOKDO:=EANP.EANN().EANL ?}
              ?};
              EANP.SCEAN:=:scean;
              EANP.ZLEAN:=:zlean;
              EANP.GS1:=:gs1;
              EANP.JMP:=:jmp;
              EANP.TPAL:=exec('typpal','magazyn_mobi',EANP.EANN,EANP.PALEAN,EANP.EAN,:tpal,EANP.ref());
              exec('aktzwmkodk','kody_kresk',EANP.M,:scean,1);
              exec('aktzwmkodk','kody_kresk',EANP.M,:zlean,1);
#  UTW: NUCO [PeKa]
# OPIS: Zablokowanie przesuniecia magazynowego - przy mieszanej reorganizacji magazyn. przesuniecie dziala zle
              EANP.IS_RM:={? EANP.LOKDO<>null() & EANP.LOKZ().MG<>EANP.LOKDO().MG || 'R' || 'R' ?};
              {? EANP.M<>null() & EANP.M().M_ATR<>null()
              || EANP.WAR01:=:war01; EANP.WAR02:=:war02;
                 EANP.WAR03:=:war03; EANP.WAR04:=:war04;
                 EANP.WAR05:=:war05; EANP.WAR06:=:war06;
                 EANP.WAR07:=:war07; EANP.WAR08:=:war08;
                 EANP.WAR09:=:war09; EANP.WAR10:=:war10
              ?};
              {? EANP.put()
              || _result:='PUT';
                 _opis:='Zaktualizowano pozycje operacji';
                 :idadd:=EANP.IDADD;
                 exec('uzupdane','magazyn_mob');
                 exec('aktstmag','magazyn_stan',,,,,_rozn);
                 {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?};
                 {? EANP.PAL<>null & EANP.PAL().AKT='N' || exec('aktywpal','magdok_palety',EANP.PAL) ?};
                 {? EANP.KPLREO<>'' || exec('reo2KPL','magazyn_mobi',EANP.KPLREO,EANP.PAL,EANP.PALDO) ?};
                 {? EANP.EANN().TYP='I' & EANP.PAL<>null() & EANP.M=null() & EANP.IL=0
                 || exec('delEANPinw','magazyn_mobi',EANP.EANN,EANP.PAL)
                 ?};
#  UTW: [PeKa]
# OPIS: Wydruk etykiety po poprawie ilosci na urządzeniu
# (ograniczenie do operacji wydania wewnętrznego oraz kompletacji wewnętrznej)
                 _drukuj:='ZW'*EANP.EANN().TYP | 'WW'*EANP.EANN().TYP;
                 {? _drukuj
                 || _user:=exec('FindAndGet','#table',USERS,:idusr,,,null());
                    _drukarka:=exec('get_w','#params',9992,2,_user);
                    _etykieta:=exec('get_w','#params',9993,2,_user);
                    _nawsucha:=exec('get_w','#params',9994,2,_user);
                    {? _drukarka<>'' & _etykieta<>'' & _nawsucha='T' & _rozn
                    || exec('autodruk','qmom',$EANP.ref,_etykieta,_drukarka);
                       _txt:='Wydruk poprawionej pozycji kompletacji';
                       exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',$EANP.ref
                       ,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
                    || _txt:='Brak parametrów do drukowania';
                        exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',$EANP.ref
                        ,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
                 ?}
                 ?}
# koniec zmiany
              || _opis:='Nie zaktualizowano pozycji operacji'
              ?};
              _txt:=form(:idadd)+','
                   +'oper.: '+form(:ideann)+','
                   +'lok.Z: '+form(:lokz)+','
                   +'lok.DO: '+form(:lokdo)+','
                   +'termin: '+form(:tw)+','
                   +'paleta: '+form(:pal)+','
                   +'ilość: '+form(:ils,0,,'99')+','
                   +'il.pobrana: '+form(:ilp,0,,'99')+','
                   +'dost.: '+form(:scean)+','
                   +'zlec.: '+form(:zlean);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'PUT'
               ,:ean,:idlokz,:idlokdo,:idpal,:idpaldo,EANP.TW,:ils,'p_cud@mobil_run:'+_txt,_opis)
           ?};
           {? ~_endeann & EANN.TYP<>'R' & EANN.STAN='Z'
           || _endeann:=exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT)
           ?};
           {? _endeann || _autoref:=EANN.ref() ?}
        || _result:='ERR';
           _opis:='Nie znaleziono operacji. Operacja zrealizowana lub anulowana.';
           _txt:=form(:idadd)+','
                   +'oper.: '+form(:ideann)+','
                   +'lok.Z: '+form(:lokz)+','
                   +'lok.DO: '+form(:lokdo)+','
                   +'termin: '+form(:tw)+','
                   +'paleta: '+form(:pal)+','
                   +'ilość: '+form(:ils,0,,'99')+','
                   +'il.pobrana: '+form(:ilp,0,,'99')+','
                   +'dost.: '+form(:scean)+','
                   +'zlec.: '+form(:zlean);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'PUT'
               ,:ean,:idlokz,:idlokdo,:idpal,:idpaldo,EANP.TW,:ils,'p_cud@mobil_run:'+_txt,_opis)
        ?}
     || EANP.index('IDADD');
        EANP.prefix(:idadd);
        {? EANP.first()
        || _aktst:=EANP.LOKZ<>null() & (';WZ'*EANP.EANN().TYP)>1;
           _eann:=EANP.EANN;
           _deli:=EANP.EANN().TYP='I' & EANP.PAL<>null() & EANP.M=null() & EANP.IL=0;
           _pali:=EANP.PAL;
           {? _aktst
           || _mat:=EANP.M;
              _mag:=EANP.LOKZ().MG;
              _pal:=EANP.PAL;
              _msk:=form((EANP.EANN().DATA~1)-2000,-2,0,'99');
              _rozn:=-EANP.ILS
           ?};
           EANW.index('EANP'); EANW.prefix(EANP.ref()); {? EANW.first() || {! |? EANW.del() !} ?};
           _res:=EANP.del(1,1);
           {? _res>0
           || exec('akt_R_M','magazyn_mobi',_eann);
              {? _deli || exec('delEANPinw','magazyn_mobi',_eann,_pali) ?};
              _result:='DEL';
              _opis:='Usunięto pozycję operacji';
              {? _aktst || exec('aktstmag','magazyn_stan',_mat,_mag,_pal,_msk,_rozn) ?};
              _res:=1
           || _opis:='Nie udało się usunąć pozycji operacji'
           ?}
        || _result:='DEL';
           _opis:='Nie znaleziono pozycji operacji'
        ?};
        _txt:=form(:idadd)+','
             +'oper.: '+form(:ideann)+','
             +'lok.Z: '+form(:lokz)+','
             +'lok.DO: '+form(:lokdo)+','
             +'termin: '+form(:tw)+','
             +'paleta: '+form(:pal)+','
             +'ilość: '+form(:ils,0,,'99')+','
             +'il.pobrana: '+form(:ilp,0,,'99')+','
             +'dost.: '+form(:scean)+','
             +'zlec.: '+form(:zlean);
        exec('rejLOG','magazyn_mob'
         ,:ideanc,:idusr,'DEL'
         ,:ean,:idlokz,:idlokdo,:idpal,:idpaldo,date(0,0,0),:ils,'p_cud@mobil_run:'+_txt,_opis)
     ?}
  ?};
  exec('addKO','magazyn_mob',:RS,_result,_opis,:idadd)
end formula

end proc


proc etykieta

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: wydruk lub pobranie definicji etykiety wg identyfikatora urządzenia
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''  String[31],  Identyfikator czytnika (Merit)
  idusr:=''   String[31],  Identyfikator operatora urządzenia
  idope:=''   String[31],  Identyfikator nagłówka, pozycji operacji, materiału, lokalizacji (Merit)
  kodk:=''    String[128], Kod kreskowy - wydruk
  rodzaj:='P' String[1],   Rodzaj

  mask:=''    String[8],  Maska
end params


sql

select
  cast (0 AS REAL_TYPE) as WYN,
  SPACE(100)  as OPIS
from FIRMA
where 1=2
order by 1

end sql

formula

'NUCO';
# log z informacja o uruchomionej procedurze
   _logmom:=form('proc_exe(\'etykieta@mobil_run')+'\',\''
         +form(:ideanc)+'\',\''
         +form(:idusr)+'\',\''
         +form(:idope)+'\',\''
         +form(:kodk)+'\',\''
         +form(:rodzaj)+'\',\''
         +form(:mask)+'\'\)';

   _out:=fopen('etykieta.txt','a',1);
   {? _out
   || fwrite(_out,_logmom);
      fclose(_out)
   ?};

_user:=exec('FindAndGet','#table',USERS,:idusr,,,null());
_drukarka:=exec('get_w','#params',9992,2,_user);
_etykieta:=exec('get_w','#params',9993,2,_user);
'w parametrze idope przychodzi albo kod SCEAN albo kod pozycji EANP i z niej szukam SCEAN';
_kodk:={? :idope<>'' & (+:idope)=31 || exec('FindAndGet','#table',EANP,:idope,,'SCEAN','') || :idope ?};

{? _kodk<>''
|| {? _drukarka<>'' & _etykieta<>''
   || {? var_press('tabp')>100 || obj_del(tabp) ?};
      tabp:=sql('select
               M.KTM,
               M.N,
               DK.DOST as D,
               DK.TW as TW,
               DK.IL as IL,
               DK.IL as ILOSC,
               JM.KOD JMIAR,
               KH.KOD,
               KH.SKR,
               DK.SCEAN,
               DK_C.WAR02 as BC,
               DK_C.WAR01 as QKJ,
               SPACE(100) as NCD,
               SPACE(1) as PARTIA,
               TYPYDOK.T as TYP,
               M_OPAKOW.POJ as POJOPK,
               M.DOKL as DOKLIL,
               DK.REFERENCE as REF
                from @DK
                 left join DK_C using (DK.DK_C,DK_C.REFERENCE)
                 left join M using (DK.M,M.REFERENCE)
                 left join M_OPAKOW using (M_OPAKOW.M,M.REFERENCE)
                 left join JM using (DK.JM,JM.REFERENCE)
                 left join @ND using (DK.N,ND.REFERENCE)
                 left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
                 left join KH using (ND.KH,KH.REFERENCE)
                where DK.SCEAN=\':_a\' and DK.PLUS=''T'' and DK.SRDK=DK.PRDK',_kodk);
      {? tabp.first()
      || tabp.for_each("tabp.IL:=1;tabp.put");
         _dl:=45;
         {? tabp.first || {! |? STR.split(tabp.N); tabp.N:=STR.line(_dl); tabp.NCD:=STR.line(_dl); tabp.put; tabp.next !} ?};
         exec('druk','qprodukcja',_etykieta,_drukarka);
         :RS.WYN:=1;
         :RS.OPIS:='Wydrukowano na drukarce etykiet.';
         :RS.add();
         _txt:='Wydrukowane na drukarce etykiet';
         exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',_kodk,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
      || :RS.WYN:=0;
         :RS.OPIS:='Brak danych do wydrukowania. Wydruk niemożliwy';
         :RS.add();
         _txt:='Brak danych do drukowania';
         exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',_kodk,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
      ?}
   ||
      :RS.WYN:=0;
      :RS.OPIS:='Brak parametrów do drukowania. Wydruk niemożliwy';
      :RS.add();
      _txt:='Brak parametrów do drukowania';
      exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',_kodk,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
   ?}
|| :RS.WYN:=0;
   :RS.OPIS:='Brak identyfikatora dostawy. Wydruk niemożliwy';
   :RS.add();
   _txt:='Brak identyfikatora do drukowania';
   exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',_kodk,'','','','',date(0,0,0),0,'etykieta@mobil_run',_txt)
?}

end formula

end proc


proc def_info

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [A.W.] [18.22]
:: OPIS: definicja danych jakie mają być wyświetlane na urządzeniu
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
end params

sql

select
  SPACE(10) as TABELA,
  SPACE(2)  as TYP,
  SPACE(10) as POLE,
  SPACE(20) as LABEL
from FIRMA
where 1=2
order by 1

end sql

formula
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','TNAZ','Nazwa:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','LOKZ','Lok.:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','HLP_1','Do wyd.:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','ILS','Pobrano:');
#  exec('addKO','magazyn_mob',:RS,'EANP','Z','TW','T.ważn.:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','SCEAN','Ident.:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','EAN','EAN:');
#   exec('addKO','magazyn_mob',:RS,'EANP','Z','T','KTM:');

#   exec('addKO','magazyn_mob',:RS,'EANN','P','SYM','Symbol:');
#   exec('addKO','magazyn_mob',:RS,'EANN','P','KH','Termin realizacji:');
#   exec('addKO','magazyn_mob',:RS,'EANN','P','DATA_SRV','Wydanie:');

   exec('addKO','magazyn_mob',:RS,'STANY','Z','KTM','KTM:');
   exec('addKO','magazyn_mob',:RS,'STANY','Z','TW','T.ważn.:');
   exec('addKO','magazyn_mob',:RS,'STANY','Z','NAZ','Nazwa:');
#   exec('addKO','magazyn_mob',:RS,'STANY','Z','HLP_3','Kontr.:');


   exec('addKO','magazyn_mob',:RS,'EANN','Z','SYMZAM','Symbol:');
   exec('addKO','magazyn_mob',:RS,'EANN','Z','HLP_1','Termin realizacji:');
   exec('addKO','magazyn_mob',:RS,'EANN','Z','HLP_2','Wydanie:');
   exec('addKO','magazyn_mob',:RS,'EANN','Z','HLP_3','Uwagi:');


   exec('addKO','magazyn_mob',:RS,'EANP','GZ','5;5;40;35','');
   exec('addKO','magazyn_mob',:RS,'EANN','GZ','5;40;50','');
   exec('addKO','magazyn_mob',:RS,'STANY','GZ','0;50;20;-1;50','D');
   exec('addKO','magazyn_mob',:RS,'STANY','GZ','0;50;20;-1;50','M');
   exec('addKO','magazyn_mob',:RS,'STANY','GZ','50;0;20;-1;50','P');

 1
end formula

end proc


proc drukuj

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [PeKa]
:: OPIS: Drukuje etykiete z urzadzenia na drukarce etykiet (wersja na Windows CE)
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  scean:=''  String[30], Identyfikator dostawy
end params

sql

select
  cast (0 AS REAL_TYPE) as WYN,
  SPACE(100)  as OPIS
from FIRMA
where 1=2
order by 1

end sql

formula

_user:=exec('FindAndGet','#table',USERS,:idusr,,,null());
_drukarka:=exec('get_w','#params',9992,2,_user);
_etykieta:=exec('get_w','#params',9993,2,_user);

{? :scean<>''
|| {? _drukarka<>'' & _etykieta<>''
   || {? var_press('tabp')>100 || obj_del(tabp) ?};
      tabp:=sql('select
               M.KTM,
               M.N,
               DK.DOST as D,
               DK.TW as TW,
               DK.IL as IL,
               DK.IL as ILOSC,
               JM.KOD JMIAR,
               KH.KOD,
               KH.SKR,
               DK.SCEAN,
               DK_C.WAR02 as BC,
               DK_C.WAR01 as QKJ,
               SPACE(100) as NCD,
               SPACE(1) as PARTIA,
               TYPYDOK.T as TYP,
               M_OPAKOW.POJ as POJOPK,
               M.DOKL as DOKLIL,
               DK.REFERENCE as REF
                from @DK
                 left join DK_C using (DK.DK_C,DK_C.REFERENCE)
                 left join M using (DK.M,M.REFERENCE)
                 left join M_OPAKOW using (M_OPAKOW.M,M.REFERENCE)
                 left join JM using (DK.JM,JM.REFERENCE)
                 left join @ND using (DK.N,ND.REFERENCE)
                 left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
                 left join KH using (ND.KH,KH.REFERENCE)
                where DK.SCEAN=\':_a\' and DK.PLUS=''T'' and DK.SRDK=DK.PRDK',:scean);
      {? tabp.first()
      || tabp.for_each("tabp.IL:=1;tabp.put");
         _dl:=45;
         {? tabp.first || {! |? STR.split(tabp.N); tabp.N:=STR.line(_dl); tabp.NCD:=STR.line(_dl); tabp.put; tabp.next !} ?};
         exec('druk','qprodukcja',_etykieta,_drukarka);
         :RS.WYN:=1;
         :RS.OPIS:='Wydrukowano na drukarce etykiet.';
         :RS.add();
         _txt:='Wydrukowane na drukarce etykiet';
         exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',:scean,'','','','',date(0,0,0),0,'drukuj@mobil_run',_txt)
      || :RS.WYN:=0;
         :RS.OPIS:='Brak danych do wydrukowania. Wydruk niemożliwy';
         :RS.add();
         _txt:='Brak danych do drukowania';
         exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',:scean,'','','','',date(0,0,0),0,'drukuj@mobil_run',_txt)
      ?}
   ||
      :RS.WYN:=0;
      :RS.OPIS:='Brak parametrów do drukowania. Wydruk niemożliwy';
      :RS.add();
      _txt:='Brak parametrów do drukowania';
      exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',:scean,'','','','',date(0,0,0),0,'drukuj@mobil_run',_txt)
   ?}
|| :RS.WYN:=0;
   :RS.OPIS:='Brak identyfikatora dostawy. Wydruk niemożliwy';
   :RS.add();
   _txt:='Brak identyfikatora do drukowania';
   exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS',:scean,'','','','',date(0,0,0),0,'drukuj@mobil_run',_txt)
?}

end formula

end proc

