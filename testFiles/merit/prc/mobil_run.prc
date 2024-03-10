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
order by 3,4,7

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
  EANN.PALEAN as PALEAN
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


proc eanp

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: pobranie pozycji operacji wg podanego nagłówka
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  ideann:='' String[31],  Identyfikator nagłówka operacji (Merit)

  mask:=''   String[8],  Maska
end params

formula
  _oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || '_'
         ?};
  :mask:='eanp'+_oddz+'__'
end formula

sql

select /* MASK_FILTER(EANP,:mask) */
  EANP.IDADD as IDADD,
  EANN.IDADD as IDEANN,
  SPACE(31) as IDLOKZ,
  SPACE(31) as IDLOKDO,
  SPACE(31) as IDMAT,
  SPACE(31) as IDPAL,
  SPACE(31) as IDPALDO,
  EANN.UNIK as EANN,
  SPACE(20) as LOKZ,
  SPACE(20) as LOKDO,
  SPACE(128) as EAN,
  EANP.IL as IL,
  EANP.ILS as ILS,
  EANN.NRC as NRC,
  EANP.LP as LP,
  SPACE(50) as T,
  SPACE(120) as TNAZ,
  EANP.UNIK as UNIK,
  to_string(EANP.TW) as TW,
  SPACE(1) as CZY_D,
  SPACE(30) as PAL,
  SPACE(1) as AKT,
  EANP.ZPALET as ZPALET,
  EANP.PALEAN as PALEAN,
  EANP.PALDOEAN as PALDOEAN,
  EANP.BEZOZN as BEZOZN,
  SPACE(30) as TYMCZAS,
  EANP.SCEAN as SCEAN,
  EANP.ZLEAN as ZLEAN,
  SPACE(10) as JM,
  SPACE(30) as LOKEANZ,
  SPACE(30) as LOKEANDO,
  EANP.ILP as ILP,
  EANP.GS1 as GS1,
  EANP.IL2 as IL2,
  EANP.ILS2 as ILS2,
  SPACE(10) as J2,
  CAST (0 as REAL_TYPE) as WS2,
  SPACE(8) as MAG_Z,
  SPACE(8) as MAG_DO,
  EANP.JMP as JMP,
  EANP.TPAL as TPAL,
  EANP.ROZPAL as ROZPAL,
  SPACE(250) as TXT1,
  SPACE(250) as TXT2,
  0 as CZY_ATR
from EANP
 join EANN using(EANP.EANN,EANN.REFERENCE)
where EANN.IDADD=:ideann
  and EANN.ZLEC='N'
order by 15

end sql

formula
   _res:=0;
   :RS.clear;
   {? :RS.first
   || _res:=:RS.size();
      exec('openean','open_tab',:mask+3);
      {!
      |? :RS.TXT1:='';
         :RS.TXT2:='';
         EANP.index('IDADD');
         EANP.prefix(:RS.IDADD);
         {? EANP.first()
         || {? (EANP.M<>null() & EANP.M().RODZ='U')
             | (EANP.EANN().TYP='I' & EANP.IDPAL<>'' & EANP.M<>null() & EANP.ILS>0)
            || :RS.del()
            || :RS.IDLOKZ:={? EANP.LOKZ<>null() || EANP.LOKZ().IDADD || '' ?};
               :RS.IDLOKDO:={? EANP.LOKDO<>null() || EANP.LOKDO().IDADD || '' ?};
               :RS.LOKZ:={? EANP.LOKZ<>null() || EANP.LOKZ().KOD || '' ?};
               :RS.LOKDO:={? EANP.EANN().TYP='R' & EANP.LOKDO<>null() || EANP.LOKDO().KOD || '' ?};
               :RS.LOKEANZ:={? EANP.LOKZ<>null() || EANP.LOKZ().EAN || '' ?};
               :RS.LOKEANDO:={? EANP.EANN().TYP='R' & EANP.LOKDO<>null() || EANP.LOKDO().EAN || '' ?};
               :RS.IDPAL:={? EANP.PAL<>null() || EANP.PAL().IDADD || '' ?};
               :RS.IDPALDO:={? EANP.PALDO<>null() || EANP.PAL().IDADD || '' ?};
               :RS.MAG_Z:={? EANP.LOKZ<>null() || EANP.LOKZ().MG().SYM || '' ?};
               :RS.MAG_DO:={? EANP.LOKDO<>null() || EANP.LOKDO().MG().SYM || '' ?};
               {? EANP.M<>null()
               || :RS.IDMAT:=EANP.M().IDADD;
                  :RS.EAN:=EANP.M().KODK;
                  :RS.T:=EANP.M().KTM;
                  :RS.TNAZ:=EANP.M().N;
                  :RS.JM:=EANP.M().J().KOD;
                  :RS.J2:={? EANP.M().J2<>null() || EANP.M().J2().KOD || '' ?};
                  :RS.WS2:={? EANP.ILS>0 & EANP.ILS2>0 || EANP.ILS/EANP.ILS2
                           |? EANP.IL>0 & EANP.IL2>0   || EANP.IL/EANP.IL2
                           |? EANP.M().J2<>null() || exec('oblWSP','jm',EANP.M)
                           || 0
                           ?}
               |? EANP.PAL<>null()
               || :RS.IDMAT:='';
                  :RS.EAN:=EANP.PAL().KODK;
                  :RS.T:=EANP.PAL().KODK;
                  :RS.TNAZ:='';
                  :RS.JM:='';
                  :RS.J2:='';
                  :RS.WS2:=0
               || :RS.EAN:=EANP.EAN;
                  :RS.T:='<Nowy kod>';
                  :RS.TNAZ:='Brak w systemie'
               ?};
               _txt:=exec('infoEANP','magazyn_mobi',EANP.EANN().IDADD,EANP.M().IDADD,EANP.LOKZ().IDADD
                      ,EANP.SCEAN,EANP.PAL().IDADD);
               :RS.TXT1:=_txt[1];
               :RS.TXT2:=_txt[2];
               obj_del(_txt);
               {? form(:RS.TW)='' || :RS.TW:='0000/00/00' ?};
               :RS.CZY_ATR:=EANP.M<>null() & EANP.M().M_ATR<>null();
               :RS.put;
               :RS.next()
            ?}
         || :RS.next()
         ?}
      !}
   ?};
   exec('rejLOG','magazyn_mob'
    ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'eanp@mobil_run:'+:ideann,'Przesłano: '+form(_res,0,,'99'))
end formula

end proc


proc mat

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca informacje o materiale wg idadd lub kodu kreskowego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idmat:=''  String[31],  Identyfikator materiału (Merit) lub kod kreskowy materiału
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


proc oper

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca informacje o ilości operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
end params

sql

select
  SPACE(31) as IDADD,
  SPACE(1) as TYP,
  0 as ILOPER,
  0 as ILEND
from FIRMA
where 1=2
order by 1,2

end sql

formula
  _oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || ''
         ?};
  {? _oddz<>''
  || _res:=0;
     exec('openean','open_tab',_oddz+'__');
     EANN.index('DATA');
     EANN.prefix('T','N');
     {? EANN.first()
     || {!
        |? {? EANN.STAN<>'!' & (4+(EANN.STAN+EANN.UNIK))<>'Zret' & exec('okEANN','magazyn_mobi',EANN.ref(),:ideanc)
           || _typ:={? EANN.TYP<>'R'
                    || EANN.TYP
                    |? EANN.PALEAN<>''
                    || 'O'
                    |? EANN.EANL<>null()
                    || 'L'
                    || EANN.TYP
                    ?};
              :RS.clear();
              {? :RS.find_key(:ideanc,_typ,)
              || :RS.ILOPER+=1;
                 :RS.ILEND+=EANN.STAN='Z';
                 :RS.put(1)
              || exec('addKO','magazyn_mob',:RS,:ideanc,_typ,1,EANN.STAN='Z')
              ?};
              _res+=1
           ?};
           EANN.next()
        !}
     ?};
     {? 0
     || exec('rejLOG','magazyn_mob'
         ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'oper@mobil_run','Ilość operacji: '+form(_res,0,,'99'))
     ?}
  ?}
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
  MKODK.IDADD as IDEANL
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


proc n_cud

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: dodanie/poprawa/usunięcie nagłówka operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[50],  Identyfikator operatora urządzenia
  oper_cud:='' String[1],   Operacja Create Update Delete

  idadd:=''    String[31],  IDADD - idadd Nagłówka operacji
  idkh:=''     String[31],  IDKH - idadd Kontrahenta
  idodb:=''    String[31],  IDODB - idadd Odbiorcy
  ideanl:=''   String[31],  IDEANL - idadd Lokalizacji
  idmg:=''     String[31],  IDMG - idadd Magazynu
  unik:=''     String[20],  UNIK - Unikalny kod operacji
  sym:=''      String[20],  SYM - Symbol operacji
  nrc:=0       Integer,     NRC - Numer czytnika
  akt:=''      String[1],   AKT - Czy operacja jest aktywna
  typ:=''      String[1],   TYP - Rodzaj operacji
  stan:=''     String[1],   STAN - Stan operacji
  status:=''   String[1],   STATUS - Status operacji
  rodz:=''     String[2],   RODZ - Rodzaj operacji zewnętrzna/wewnętrzna/paletowa
  data:=''     String[10],  DATA - data operacji
  czas:=''     String[8],   CZAS - czas operacji
  ilp:=0       Integer,     ILP - Ilość pozycji na operacji
  adr_dst:=''  String[120], ADR_OST - Adres dostawy
  kh:=''       String[120], KH - Kontrahent - opis
  eanl:=''     String[20],  EANL - Lokalizacja - kod
  mag:=''      String[10],  MAG - Symbol magazynu
  txt1:=''     String[255], TXT1 - Dodatkowe uwagi
  ref_real:='' String[16],  REF_REAL - Wskazanie SQL na realizację
  lok_inw:=''  String[30],  LOK_INW - Lokalizacja do inwentaryzacji
  time_end:='' String[8],   TIME_END - Czas zakończenia
  ilodczyt:=0  Real,        ILODCZYT - Sumaryczna ilość odczytana na pozycjach operacji
  data_srv:='' String[10],  DATA_SRV - Data z serwera
  ref_zam:=''  String[31],  REF_ZAM - Wskazanie SQL na zamówienie/potwierdzenie
  zn_reo:=''   String[1],   ZN_REO - Znacznik reorganizacji (pomijane)
  il_op:=0     Real,        IL_OP - Ilość operacji (pomijane)
  zlean:=''    String[128], ZLEAN - Kod kreskowy zlecenia
  kodkh:=''    String[10],  KODKH - Kod kontrahenta
  symzam:=''   String[20],  SYMZAM - Symbol zamówienia/potwierdzenia
  symzl:=''    String[20],  SYMZL - Symbol zlecenia
  palean:=''   String[30],  PALEAN - paleta do rozpakowania
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
  || {? (+:idadd)=31
     || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindInSet','#table','EANN','IDADD',:idadd,,"(1+(4-($EANN.ref())))",,,'');
        _ok:=ST.ODDZ<>''
     ?}
  |? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
  || _opis:='(Merit) Nie znaleziono urządzenia'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
  || _opis:='(Merit) Urządzenie nie jest aktywne w systemie'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
  || _opis:='(Merit) Brak przypisania oddziału dla urządzenia'
  || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     _ok:=ST.ODDZ<>''
  ?};
  {? _ok & (+:idadd)=31
   & (_eanc:=exec('FindInSet','#table','EANN','IDADD',:idadd,,"EANN.IDEANC",,,'');
      _eanc<>'' & _eanc<>:ideanc)
  || _opis:='Dana operacja została przekierowana na inne urządzenie. Zapis niemożliwy.';
     _ok:=0
  ?};
  {? _ok & (';LO'*:typ)>1
  || _opis:=exec('ctrlEANNcud','magazyn_mob',:typ,:lok_inw,:palean,ST.ODDZ);
     _ok:=_opis=''
  ?};
  {? _ok
  ||
     exec('openean','open_tab',ST.ODDZ+'__');

     _lok_inw:=null;
     {? :lok_inw<>''
     || EANL.index('EAN');
        EANL.prefix(:lok_inw,:lok_inw);
        {? EANL.first
        || _lok_inw:=EANL.ref
        ?}
     ?};

     {? :oper_cud<>'D'
     || _noakt:=0;
        EANN.index('IDADD');
        EANN.prefix(:idadd);
        {? EANN.first() & (_noakt:=EANN.AKT='N'; ~_noakt)
        || {? EANN.TIMER=time(0,0,0)
           || EANN.TIMER:=time()
           ?};
           EANN.IDEANC:=:ideanc;
           EANN.IDUSR:=:idusr;
           EANN.USERS:={? (+(:idusr))=31 || exec('FindAndGet','#table',USERS,:idusr,,,null()) ?};
           EANN.UNIK:=:unik;
           EANN.TYP:={? (';LO'*:typ)>1 || 'R' || :typ ?};
           EANN.DATA:=exec('str2date','#convert',:data);
           EANN.NKH:=:kh;
           EANN.KH:={? (+form(:idkh))=31 || exec('FindInSet','#table','KH','IDADD',:idkh) || null ?};
           EANN.NRC:=exec('FindInSet','#table','EANC','IDADD',:ideanc,,"EANC.NRC",,,0);
           EANN.STAN:=:stan;
           EANN.TXT1:=:txt1;
           EANN.ILP:=:ilp;
           EANN.ILODCZYT:=:ilodczyt;
           EANN.EANL:=_lok_inw;
           EANN.IDZAM:=:ref_zam;
           {? (';PW'*EANN.TYP)>1 & (5+EANN.REFSQL)='nagdo'
           || :ref_zam:=EANN.REFSQL
           |? EANN.TYP='P'
           || EANN.REFSQL:={? (+:ref_zam)=31
                           || _rsql:=$exec('FindAndGet','#table',ZD_NAG,:ref_zam,,"ref()",null());
                              {? _rsql='' || _rsql:=$exec('FindAndGet','#table',ZDP_NAG,:ref_zam,,"ref()",null()) ?};
                              {? _rsql='' || _rsql:=$exec('FindAndGet','#table',TR_NZL,:ref_zam,,"ref()",null()) ?};
                              _rsql
                           || :ref_zam
                           ?}
           |? EANN.TYP<>'Z'
           || EANN.REFSQL:={? (+:ref_zam)=31
                           || $exec('FindAndGet','#table',
                                {? EANN.TYP='R' || DK_LN
                                |? (1+EANN.RODZ)='W' & EANN.TYP<>'W' || ZL
                                || ZK_N
                                ?},:ref_zam,,"ref()",null())
                           || :ref_zam
                           ?}
           ?};
           EANN.ZLEAN:=:zlean;
           EANN.PALEAN:={? :typ='O' || :palean || '' ?};
           EANN.RODZ:={? EANN.PALEAN<>''
                      || 'W'
                      |? EANN.EANL<>null()
                      || 'W'+{? EANN.EANL().MG().PAL='T' || 'P' || '' ?}
                      || :rodz
                      ?};
           {? EANN.STAN='Z' & EANN.TIMEZ=time(0,0,0) || EANN.TIMEZ:=time() ?};
           EANN.SYM:=exec('eannSYM','magazyn_mob',:typ,:sym,:unik);
           {? EANN.put()
           || EANP.index('EANN');
              EANP.prefix(EANN.ref());
              {? ~EANP.first() & (';PW'*EANN.TYP)>1 & (1+EANN.RODZ)='Z' & (+EANN.IDZAM)=31
              || {? (5+EANN.REFSQL='zdnag' | 5+EANN.REFSQL='zdptn' | 4+EANN.REFSQL='trnl')
                  & exec('get','#params',600909,2)='T'
                 || exec('genWgZAM','magazyn_mob','P',EANN.ref(),EANN.IDZAM)
                 ?}
              ?};
              exec('akt_R_M','magazyn_mobi',EANN.ref());
              _result:='PUT';
              _opis:='Zaktualizowano nagłówek operacji';
              {? EANN.STAN='Z'
              || EANP.index('EANN');
                 EANP.prefix(EANN.ref());
                 {? EANP.first() || {! |? exec('aktstmag','magazyn_stan',,,,,1); EANP.next() !} ?}
              ?}
           || _opis:='Nie zaktualizowano nagłówka operacji'
           ?};
           _txt:=form(:idadd)+','
                +'symb.: '+form(:sym)+','
                +'typ: '+form(:typ)+','
                +'stan: '+form(:stan)+','
                +'rodz.: '+form(:rodz)+','
                +'il.poz.: '+form(:ilp,0,,'99')+','
                +'il.sum.: '+form(:ilodczyt,0,,'99')+','
                +'kontr.: '+form(:kodkh)+','
                +'zamów.: '+form(:ref_zam)+','
                +'zlec.: '+form(:zlean)+','
                +'uw.: '+form(:txt1+',');
           exec('rejLOG','magazyn_mob'
            ,:ideanc,:idusr,'PUT','','','','','',date(0,0,0),0,'n_cud@mobil_run:'+_txt,_opis)
        |? _noakt
        || _opis:='Nagłówek operacji nie jest aktywny (anulowany lub zrealizowany).';
           _txt:=form(:idadd)+','
                +'symb.: '+form(:sym)+','
                +'typ: '+form(:typ)+','
                +'stan: '+form(:stan)+','
                +'rodz.: '+form(:rodz)+','
                +'il.poz.: '+form(:ilp,0,,'99')+','
                +'il.sum.: '+form(:ilodczyt,0,,'99')+','
                +'kontr.: '+form(:kodkh)+','
                +'zamów.: '+form(:ref_zam)+','
                +'zlec.: '+form(:zlean)+','
                +'uw.: '+form(:txt1+',');
           exec('rejLOG','magazyn_mob'
            ,:ideanc,:idusr,_result,'','','','','',date(0,0,0),0,'n_cud@mobil_run:'+_txt,_opis)
        || EANN.clear();
           EANN.blank();
           EANN.IDEANC:=:ideanc;
           EANN.IDUSR:=:idusr;
           EANN.USERS:={? (+(:idusr))=31 || exec('FindAndGet','#table',USERS,:idusr,,,null()) ?};
           EANN.UNIK:=:unik;
           EANN.TYP:={? (';LO'*:typ)>1 || 'R' || :typ ?};
           EANN.NKH:=:kh;
           EANN.KH:={? (+form(:idkh))=31 || exec('FindInSet','#table','KH','IDADD',:idkh) || null ?};
           EANN.NRC:=exec('FindInSet','#table','EANC','IDADD',:ideanc,,"EANC.NRC",,,0);
           EANN.STAN:=:stan;
           EANN.TXT1:=:txt1;
           EANN.ILP:=:ilp;
           EANN.ILODCZYT:=:ilodczyt;
           EANN.EANL:=_lok_inw;
           EANN.IDZAM:=:ref_zam;
           {? EANN.TYP='P'
           || EANN.REFSQL:={? (+:ref_zam)=31
                           || _rsql:=$exec('FindAndGet','#table',ZD_NAG,:ref_zam,,"ref()",null());
                              {? _rsql='' || _rsql:=$exec('FindAndGet','#table',ZDP_NAG,:ref_zam,,"ref()",null()) ?};
                              {? _rsql='' || _rsql:=$exec('FindAndGet','#table',TR_NZL,:ref_zam,,"ref()",null()) ?};
                              _rsql
                           || :ref_zam
                           ?}
           |? EANN.TYP<>'Z'
           || EANN.REFSQL:={? (+:ref_zam)=31
                           || $exec('FindAndGet','#table',
                                {? EANN.TYP='R' || DK_LN
                                |? (1+EANN.RODZ)='W' & EANN.TYP<>'W' || ZL
                                || ZK_N
                                ?},:ref_zam,,"ref()",null())
                           || :ref_zam
                           ?}
           ?};
           EANN.ZLEAN:=:zlean;
           EANN.PALEAN:={? :typ='O' || :palean || '' ?};
           EANN.RODZ:={? EANN.PALEAN<>''
                      || 'W'
                      |? EANN.EANL<>null()
                      || 'W'+{? EANN.EANL().MG().PAL='T' || 'P' || '' ?}
                      || :rodz
                      ?};
           EANN.TIMER:=time();
           {? EANN.STAN='Z' || EANN.TIMEZ:=time() || EANN.TIMEZ=time(0,0,0) ?};
           {? EANN.add()
           || _result:='ADD';
              _opis:='Dodano nagłówek operacji';
              :idadd:=EANN.IDADD;
              EANN.SYM:=exec('eannSYM','magazyn_mob',:typ,:sym,:unik);
              EANN.DATA:=exec('str2date','#convert',(10+EANN.IDADD));
              EANN.TIME:=exec('str2time','#convert',8+(11-EANN.IDADD));
              EANN.put(1);
              {? (';PW'*EANN.TYP)>1 & (1+EANN.RODZ)='Z' & (+EANN.IDZAM)=31
              || {? (5+EANN.REFSQL='zdnag' | 5+EANN.REFSQL='zdptn' | 4+EANN.REFSQL='trnl')
                  & exec('get','#params',600909,2)='T'
                 || exec('genWgZAM','magazyn_mob','P',EANN.ref(),EANN.IDZAM)
                 ?}
              ?};
              exec('akt_R_M','magazyn_mobi',EANN.ref());
              {? EANN.STAN='Z'
              || EANP.index('EANN');
                 EANP.prefix(EANN.ref());
                 {? EANP.first() || {! |? exec('aktstmag','magazyn_stan',,,,,1); EANP.next() !} ?}
              ?}
           || _opis:='Nie dodano nagłówka operacji'
           ?};
           _txt:=form(:idadd)+','
                +'symb.: '+form(:sym)+','
                +'typ: '+form(:typ)+','
                +'stan: '+form(:stan)+','
                +'rodz.: '+form(:rodz)+','
                +'il.poz.: '+form(:ilp,0,,'99')+','
                +'il.sum.: '+form(:ilodczyt,0,,'99')+','
                +'kontr.: '+form(:kodkh)+','
                +'zamów.: '+form(:ref_zam)+','
                +'zlec.: '+form(:zlean)+','
                +'uw.: '+form(:txt1+',');
           exec('rejLOG','magazyn_mob'
            ,:ideanc,:idusr,'ADD','','','','','',date(0,0,0),0,'n_cud@mobil_run:'+_txt,_opis)
        ?};
        {? _result<>'ERR' & EANN.STAN='Z'
         & exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT)
        || _autoref:=EANN.ref()
        ?}
     || _res:=0;
        EANN.index('IDADD');
        EANN.prefix(:idadd);
        {? EANN.first()
        || EANP.index('EANN');
           EANP.prefix(EANN.ref());
           {? EANP.first()
           || {!
              |? EANW.index('EANP');
                 EANW.prefix(EANP.ref());
                 {? EANW.first() || {! |? EANW.del() !} ?};
                 EANP.del()
              !}
           ?};
           {? EANN.count()=0
           || _res:=EANN.del(1,1);
              {? _res>0 || _res:=1 ?}
           ?}
        || _res:=-1
        ?};
        {? _res<0
        || _result:='DEL';
           _opis:='Nagłówek operacji nie istnieje'
        |? _res
        || _result:='DEL';
           _opis:='Usunięto nagłówek operacji'
        || _opis:='Nie usunięto nagłówka operacji'
        ?};
        _txt:=form(:idadd)+','
             +'symb.: '+form(:sym)+','
             +'typ: '+form(:typ)+','
             +'stan: '+form(:stan)+','
             +'rodz.: '+form(:rodz)+','
             +'il.poz.: '+form(:ilp,0,,'99')+','
             +'il.sum.: '+form(:ilodczyt,0,,'99')+','
             +'kontr.: '+form(:kodkh)+','
             +'zamów.: '+form(:ref_zam)+','
             +'zlec.: '+form(:zlean)+','
             +'uw.: '+form(:txt1+',');
        exec('rejLOG','magazyn_mob'
         ,:ideanc,:idusr,'DEL','','','','','',date(0,0,0),0,'n_cud@mobil_run:'+_txt,_opis)
     ?}
  ?};
  exec('addKO','magazyn_mob',:RS,_result,_opis,:idadd)
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
              EANP.IS_RM:={? EANP.LOKDO<>null() & EANP.LOKZ().MG<>EANP.LOKDO().MG || 'M' || 'R' ?};
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
                 {? EANP.PAL<>null & 'ZW'*EANP.EANN().TYP || exec('znacznik','magdok_palety',EANP.PAL) ?}
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
              EANP.IS_RM:={? EANP.LOKDO<>null() & EANP.LOKZ().MG<>EANP.LOKDO().MG || 'M' || 'R' ?};
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
                 ?}
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


proc sldod

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę zamówień dostaw/zamówień wewnętrznych/zleceń
::       w zależności od podanego parametru
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  typsl:=''  String[1],  Typ wyniku D-zamówienia dostaw, W-zamówienia wewnętrzne, S-zamówienia przedaży, Z-zlecenia
  idkh:=''   String[31], Identyfikator kontrahenta (obsługiwane dla typu D i S)
end params

sql

select
  SPACE(31) as IDADD,
  SPACE(31) as IDKH,
  SPACE(20) as SYM,
  SPACE(8) as KOD,
  SPACE(10) as SKR,
  SPACE(60) as NAZ,
  SPACE(1) as RODZ,
  SPACE(10) as DATA,
  SPACE(31) as IDZLEC,
  SPACE(3) as WYD,
  SPACE(1) as PAL,
  SPACE(128) as EAN
from FIRMA
where 1=2
order by 3,7,4

end sql

formula
  _log:=0;
  _res:=0;
  :typsl:=(~-:typsl);
  _kh:={? (+:idkh)=31 || exec('FindInSet','#table','KH','IDADD',:idkh,,,,,null()) || null() ?};
  {? (+:ideanc)<>31
  || exec('addKO','magazyn_mob',:RS,'ERR','Niepoprawny ID urządzenia')
  |? form(:typsl)='' | ~((';DWSZ'*:typsl)>1)
  || exec('addKO','magazyn_mob',:RS,'ERR','Brak lub niepoprawny typu wyniku')
  || _oddz:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     {? _oddz=''
     || exec('addKO','magazyn_mob',:RS,'ERR','Nie przypisano do oddziału')
     || _log:=1;
        {? :typsl='D'
        || ST.ODDZ:=_oddz;
           exec('openzd','open_tab',_oddz+'__');
           {? (';ZR'*exec('get','#params',600803,2))>1
           || ZD_NAG.index('MOB');
              ZD_NAG.prefix('T');
              {? ZD_NAG.first() & (_kh=null() | ZD_NAG.find_tab('first','KH',,'=',_kh))
              || _res:=ZD_NAG.size();
                 {!
                 |? _data:=$ZD_NAG.DATA;
                    exec('addKO','magazyn_mob',:RS
                        ,ZD_NAG.IDADD,ZD_NAG.KH().IDADD
                        ,ZD_NAG.SYM,ZD_NAG.KH().KOD,ZD_NAG.KH().SKR,ZD_NAG.KH().NAZ
                        ,'D',_data,'','','','');
                    {? _kh=null() || ZD_NAG.next() || ZD_NAG.find_tab('next','KH',,'=',_kh) ?}
                 !}
              ?}
           || ZD_NAG.index('MOB');
              {? _kh<>null() || ZD_NAG.prefix('T','A',_kh) || ZD_NAG.prefix('T','A') ?};
              {? ZD_NAG.first()
              || _res:=ZD_NAG.size();
                 {!
                 |? _data:=$ZD_NAG.DATA;
                    exec('addKO','magazyn_mob',:RS
                        ,ZD_NAG.IDADD,ZD_NAG.KH().IDADD
                        ,ZD_NAG.SYM,ZD_NAG.KH().KOD,ZD_NAG.KH().SKR,ZD_NAG.KH().NAZ
                        ,'D',_data,'','','','');
                    ZD_NAG.next()
                 !}
              ?};
              ZD_NAG.index('MOB');
              {? _kh<>null() || ZD_NAG.prefix('T','C',_kh) || ZD_NAG.prefix('T','C') ?};
              {? ZD_NAG.first()
              || _res:=ZD_NAG.size();
                 {!
                 |? _data:=$ZD_NAG.DATA;
                    exec('addKO','magazyn_mob',:RS
                        ,ZD_NAG.IDADD,ZD_NAG.KH().IDADD
                        ,ZD_NAG.SYM,ZD_NAG.KH().KOD,ZD_NAG.KH().SKR,ZD_NAG.KH().NAZ
                        ,'D',_data,'','','','');
                    ZD_NAG.next()
                 !}
              ?}
           ?};
           ZDP_NAG.index('STAT_REJ');
           {? _kh<>null() || ZDP_NAG.prefix('T',_kh) || ZDP_NAG.prefix('T') ?};
           {? ZDP_NAG.first()
           || _res:=ZDP_NAG.size();
              {!
              |? {? exec('ctrlREA','zamdst_ptw',1)
                 || _data:=$ZDP_NAG.D_WYS;
                    exec('addKO','magazyn_mob',:RS
                        ,ZDP_NAG.IDADD,ZDP_NAG.KH().IDADD
                        ,ZDP_NAG.SYM,ZDP_NAG.KH().KOD,ZDP_NAG.KH().SKR,ZDP_NAG.KH().NAZ
                        ,'D',_data,'','','','')
                 ?};
                 ZDP_NAG.next()
              !}
           ?};
           TR_NZL.index('MOB');
           TR_NZL.prefix('TR_NZL','Z','R','A');
           {? TR_NZL.first()
           || _res:=TR_NZL.size();
              {!
              |? {? _kh=null() | _kh=TR_NZL.KH
                 || _data:=$TR_NZL.DW;
                    exec('addKO','magazyn_mob',:RS
                        ,TR_NZL.IDADD,TR_NZL.KH().IDADD
                        ,TR_NZL.SYM,TR_NZL.KH().KOD,TR_NZL.KH().SKR,TR_NZL.KH().NAZ
                        ,'D',_data,'','','','')
                 ?};
                 TR_NZL.next()
              !}
           ?}
        |? :typsl='W'
        || ZK_N.use('zknag'+_oddz+'__');
           ZK_N.index('MOB');
           ZK_N.prefix('T','W');
           {? ZK_N.first()
           || {!
              |? {? ZK_N.ZBB='T' | ZK_N.ZBB='T'
                 || _res+=1;
                    _data:=$ZK_N.DP;
                    _pal:={? ZK_N.MG<>null() & ZK_N.MG().PAL='T' || 'T' || 'N' ?};
                    exec('addKO','magazyn_mob',:RS
                        ,ZK_N.IDADD,''
                        ,ZK_N.SYM,'','',''
                        ,'W',_data,ZK_N.ZL().SYM,ZK_N.WYD().KOD,_pal,'')
                 ?};
                 ZK_N.next()
              !}
           ?}
        |? :typsl='S'
        || ZK_N.use('zknag'+_oddz+'__');
           ZK_N.index('MOB');
           {? _kh<>null() || ZK_N.prefix('T','Z',_kh) || ZK_N.prefix('T','Z') ?};
           {? ZK_N.first()
           || {!
              |? {? ZK_N.ZBB='T' | ZK_N.ZBB='T'
                 || _res+=1;
                    _data:=$ZK_N.DP;
                    _pal:={? ZK_N.MG<>null() & ZK_N.MG().PAL='T' || 'T' || 'N' ?};
                    exec('addKO','magazyn_mob',:RS
                        ,ZK_N.IDADD,ZK_N.KH().IDADD
                        ,ZK_N.SYM,ZK_N.KH().KOD,ZK_N.KH().SKR,ZK_N.KH().NAZ
                        ,'S',_data,'','',_pal,'')
                 ?};
                 ZK_N.next()
              !}
           ?}
        |? :typsl='Z'
        || ZL.index('SMPROD');
           ZL.prefix('O',_oddz,'Z','P');
           {? ZL.first()
           || _res:=ZL.size();
              {!
              |? {? ~(ZL.RODZAJ='N' | ZL.RP<>'T'
)
                 || _data:=$ZL.OD;
                    exec('addKO','magazyn_mob',:RS
                        ,ZL.IDADD,''
                        ,ZL.SYM,'','',''
                        ,'Z',_data,ZL.SYM,ZL.JORG().KOD,'',ZL.ZLEAN)
                 ?};
                 ZL.next()
              !}
           ?}
        ?}
     ?}
  ?};
  {? _log
  || _txt:='Przesłano: '+form(_res,0,,'99')+' typu: '+:typsl;
     exec('rejLOG','magazyn_mob'
      ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'sldod@mobil_run:'+:typsl+','+:idkh,_txt)
  ?}
end formula

end proc


proc kh

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę kontrahentów
::       możliwość wyszukiwania wg: kodu, skrótu, nazwy pełnej oraz NIP-u
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  find:=''   String[150], (Wyszukiwanie) treść do przeszukania
end params

formula
  {? :find<>'' || :find:='%'+(~-:find)+'%' ?}
end formula

sql

select top 5000
  KH.IDADD as IDADD,
  KH.KOD as KOD,
  KH.SKR as SKR,
  KH.NAZ_P as NAZ,
  KH.NIP as NIP,
  KH.SNIP as SNIP
from KH
where KH.P=2
  and (:find='' or upper(KH.KOD || KH.SKR || KH.NAZ || KH.SNIP) like :find)
order by 2,3

end sql

formula
  _txt:={? :RS.size() || 'Znaleziono: '+form(:RS.size(),0,,'99') || 'Brak' ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'kh@mobil_run:'+:find,_txt)
end formula

end proc

proc paln

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę nagłówków palet lub dane palety
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idadd:=''  String[31],  Identyfikator palety lub kod kreskowy palety
end params

sql

select /* +MASK_FILTER(PAL,'palety') */
  PAL.IDADD as IDADD,
  TPAL.TYP as TPAL,
  PAL.KODK as KODK,
  PAL.AKT as AKT,
  PAL.STAN as STAN,
  SPACE(31) as IDEANL
from PAL
join
  TPAL
where (:idadd='' or PAL.IDADD=:idadd or PAL.KODK=:idadd)
order by 1,2

end sql

formula
  {? :RS.size() & (:RS.clear(); :RS.first())
  || _txt:='Znaleziono: '+form(:RS.size(),0,,'99');
     {? (+:ideanc)=31
     || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
        {? ST.ODDZ<>'' & (_pal:=exec('FindAndGet','#table',PAL,:RS.IDADD,,,null()))<>null()
        || SL.use('stl__%1zb'[ST.ODDZ]);
           SL.index('PALALL');
           SL.prefix(_pal);
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
                 || :RS.IDEANL:=SL.EANL().IDADD;
                    :RS.put(1);
                    0
                 || SL.prev()
                 ?}
              !}
           ?}
        ?}
     ?}
  || _txt:='Brak'
  ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS','','','',:idadd,'',date(0,0,0),0,'paln@mobil_run',_txt)
end formula

end proc


proc palp

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zwraca listę pozycji palety (tylko aktywne z ilościami)
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idpal:=''  String[31], Identyfikator nagłowka palety
  ideann:='' String[31],  Identyfikator operacji mobilnej
end params

sql

select
  SPACE(31) as IDPAL,
  SPACE(31) as IDMAT,
  cast (0 AS REAL_TYPE) as IL,
  SPACE(50) as KTM,
  SPACE(128) as KODK,
  SPACE(100) as NAZ,
  '0000/00/00' as TW,
  0 as ISTW
from FIRMA
where 1=2
order by 4,3

end sql

formula
  _ok:=0;
  {? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
  || _opis:='(Merit) Nie znaleziono urządzenia'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
  || _opis:='(Merit) Urządzenie nie jest aktywne w systemie'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
  || _opis:='(Merit) Brak przypisania oddziału dla urządzenia'
  || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     _ok:=ST.ODDZ<>''
  ?};

  {? _ok
  || {? (+:idpal)=31
     || _ispal:=0;
        _res:=0;
        {? (+:ideann)=31
        || exec('openean','open_tab',ST.ODDZ+'__');
           _refeann:=exec('FindInSet','#table','EANN','IDADD',:ideann,,,,,null());
           {? _refeann<>null()
           || EANP.index('EANN');
              EANP.prefix(_refeann);
              {? EANP.first() & EANP.find_tab('first','IDPAL',,'=',:idpal,'M',,'<>',null(),'ILS',,'>',0)
              || {!
                 |? _res+=1;
                    :RS.blank();
                    :RS.IDPAL:=EANP.IDPAL;
                    :RS.IDMAT:=EANP.M().IDADD;
                    :RS.IL:=EANP.ILS;
                    :RS.KODK:=EANP.M().KODK;
                    :RS.KTM:=EANP.M().KTM;
                    :RS.NAZ:=EANP.M().N;
                    {? EANP.M().SETW='P'
                    || :RS.TW:=$EANP.TW;
                       :RS.ISTW:=1
                    || :RS.TW:=$date(0,0,0);
                       :RS.ISTW:=0
                    ?};
                    {? :RS.add(1) || _ispal:=1 ?};
                    EANP.find_tab('next','IDPAL',,'=',:idpal,'M',,'<>',null(),'ILS',,'>',0)
                 !}
              ?}
           ?}
        ?};
        {? ~_ispal
        || PAL.use('palety');
           _pal:=exec('FindAndGet','#table',PAL,:idpal,,,null());
           {? _pal=null() | (PAL.clear(); ~PAL.seek(_pal))
           || exec('addKO','magazyn_mob',:RS,'ERR','Nieznaleziono wskazanej palety')
           || exec('openean','open_tab',ST.ODDZ+'__');
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
                    || _res+=1;
                       :RS.blank();
                       :RS.IDPAL:=PAL_POZ.PAL().IDADD;
                       :RS.IDMAT:=PAL_POZ.M().IDADD;
                       :RS.IL:=_ile;
                       :RS.KODK:=PAL_POZ.M().KODK;
                       :RS.KTM:=PAL_POZ.M().KTM;
                       :RS.NAZ:=PAL_POZ.M().N;
                       {? PAL_POZ.M().SETW='P'
                       || :RS.TW:=$PAL_POZ.TW;
                          :RS.ISTW:=1
                       || :RS.TW:=$date(0,0,0);
                          :RS.ISTW:=0
                       ?};
                       :RS.add(1)
                    ?};
                    PAL_POZ.next()
                 !}
              ?}
           ?}
        ?};
        _txt:='Przesłano: %1 pozycji palety %2'[form(:RS.size(),0,,'99')
                                               ,{? :ideann<>'' || ' (operacja: %1)'[:ideann] || '' ?}];
        exec('rejLOG','magazyn_mob',:ideanc,:idusr,'ANS','','','',:idpal,'',date(0,0,0),0,'palp@mobil_run',_txt)
     || exec('addKO','magazyn_mob',:RS,'ERR','Niepoprawny identyfikator palety')
     ?}
  ?}
end formula

end proc


proc log


desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [18.22]
:: OPIS: zapisuję informację przekazaną z urządzenia
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  type:=-1   Integer,     Typ informacji 0-Login 1-Logout 2-Nagłówek 3-Pozycje 4-AkcjaMenu 5-Błąd 6-Info
  desc:=''   String[255], Opis informacji
  ver:=''    String[30],  Wersja
end params

sql

select
  SPACE(3) as RES
from FIRMA
where 1=2
order by 1

end sql

formula
  {? :type>=0
  || _typ:={? :type=0 || {? :desc='' || :desc:='Zalogowanie na urządzeniu' ?}; 'LIN'
           |? :type=1 || {? :desc='' || :desc:='Wylogowanie z urządzenia' ?}; 'OUT'
           |? :type=2 || {? :desc='' || :desc:='Nagłówek operacji' ?}; 'NAG'
           |? :type=3 || {? :desc='' || :desc:='Pozycja operacji' ?}; 'POZ'
           |? :type=4 || {? :desc='' || :desc:='Akcja menu' ?}; 'ACT'
           |? :type=5 || {? :desc='' || :desc:='Błąd' ?}; 'ERR'
           |? :type=6 || {? :desc='' || :desc:='Informacja' ?}; 'INF'
           || 'NNA'
           ?};
     _opis:={? _typ='ERR' || 'Błąd' || :desc ?};
     _long:={? _typ='ERR' || :desc || 'log@mobil_run' ?};
     exec('rejLOG','magazyn_mob'
      ,:ideanc,:idusr,_typ,'','','','','',date(0,0,0),0,_long,_opis,:ver)
  ?}
end formula

end proc


proc eanw

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [21.14]
:: OPIS: pobranie pozycji operacji wg podanej pozycji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  ideanp:='' String[31],  Identyfikator nagłówka operacji (Merit)

  mask:=''   String[8],  Maska
end params

formula
  _oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || '_'
         ?};
  :mask:='eanw'+_oddz+'__'
end formula

sql

select /* MASK_FILTER(EANW,:mask) */
  EANW.IDADD as IDADD,
  EANN.IDADD as IDEANP,
  EANW.KOD as KOD,
  EANW.WAR as WAR,
  SPACE(120) as OPIS
from EANW
 join EANP using(EANW.EANP,EANP.REFERENCE)
 join EANN using(EANP.EANN,EANN.REFERENCE)
where EANP.IDADD=:ideanp
  and EANN.ZLEC='N'
order by 3

end sql

formula
   :RS.clear();
   _res:=:RS.size();
   {? :RS.first()
   || {!
      |? _kod:=exec('kodGS1','magazyn_mob',:RS.KOD);
         _eand:=exec('FindInSet','#table','EAND','KOD',_kod,,,1,,null());
         _opis:={? _eand<>null()
                || exec('FindAndGet','#table',EAND,_eand,,"OPIS",'<brak kodu w definicji>')
                || '<brak kodu w definicji>'
                ?};
         :RS.OPIS:=_opis;
         :RS.put(1);
         :RS.next()
      !}
   ?};
   exec('rejLOG','magazyn_mob'
    ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'eanw@mobil_run:'+:ideanp,'Przesłano: '+form(_res,0,,'99'))
end formula

end proc


proc w_cud

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [21.14]
:: OPIS: dodanie/poprawa/usunięcie pozycji kodów GS1
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[50],  Identyfikator operatora urządzenia
  oper_cud:='' String[1],   Operacja Create Update Delete

  idadd:=''    String[31],  IDADD - idadd pozycji kodu GS1
  ideanp:=''   String[31],  IDEANP - idadd pozycji operacji
  kod:=''      String[10],  KOD - Kod GS1
  war:=''      String[30],  WAR - Wartość dla kodu GS1
end params

sql
select
  SPACE(10) as KOD,
  SPACE(50) as OPIS,
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
  {? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
  || _opis:='(Merit) Nie znaleziono urządzenia'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
  || _opis:='(Merit) Urządzenie nie jest aktywne w systemie'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
  || _opis:='(Merit) Brak przypisania oddziału dla urządzenia'
  |? :oper_cud<>'D' & form(:kod)=''
  || _opis:='Nie podano kodu GS1'
  |? :oper_cud<>'D' & form(:war)=''
  || _opis:='Nie podano wartości kodu GS1'
  || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     _ok:=ST.ODDZ<>''
  ?};
  {? _ok & (+:ideanp)=31
   & (_eann:=exec('FindInSet','#table','EANP','IDADD',:ideanp,,"EANP.EANN().IDADD",,,'');
      _eanc:=exec('FindInSet','#table','EANN','IDADD',_eann,,"EANN.IDEANC",,,'');
      _eanc<>'' & _eanc<>:ideanc)
  || _opis:='Dana operacja została przekierowana na inne urządzenie. Zapis niemożliwy.';
     _ok:=0
  ?};
  {? _ok
  || _txt:=exec('ctrlEANWcud','magazyn_mob');
     _ok:=_txt=''
  ?};
  {? _ok
  ||
     exec('openean','open_tab',ST.ODDZ+'__');

     {? :ideanp<>'' & :oper_cud<>'D'
     || EANP.index('IDADD');
        EANP.prefix(:ideanp);
        {? EANP.first() & EANP.EANN().AKT='T'
        || _endeann:=EANN.STAN='Z' & exec('czyzgilp','magazyn_mob',EANN.ref(),EANN.ILP,EANN.ILODCZYT);
           _find:=0;
           {? (+:idadd)=31
           || EANW.index('IDADD');
              EANW.prefix(:idadd);
              _find:=EANW.first()
           ?};
           {? ~_find
           || EANW.prefix();
              EANW.blank();
              EANW.EANP:=EANP.ref();
              EANW.KOD:=:kod;
              EANW.WAR:=:war;
              {? EANW.add()
              || _result:='ADD';
                 _opis:='Dodano kod GS1 dal pozycji operacji';
                 :idadd:=EANW.IDADD
              || _opis:='Nie dodano pozycji operacji'
              ?};
              _txt:=form(:idadd)+','
                   +'pozycja oper.: '+form(:ideanp)+','
                   +'kod: '+form(:kod)+','
                   +'wartość: '+form(:war);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'ADD'
               ,:kod,:war,'','','',date(0,0,0),0,'w_cud@mobil_run:'+_txt,_opis)
           |? ~_endeann
           || EANW.KOD:=:kod;
              EANW.WAR:=:war;
              {? EANW.put()
              || _result:='PUT';
                 _opis:='Zaktualizowano kod GS1 dla pozycji operacji';
                 :idadd:=EANW.IDADD
              || _opis:='Nie zaktualizowano pozycji operacji'
              ?};
              _txt:=form(:idadd)+','
                   +'pozycja oper.: '+form(:ideanp)+','
                   +'kod: '+form(:kod)+','
                   +'wartość: '+form(:war);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'PUT'
               ,:kod,:war,'','','',date(0,0,0),0,'w_cud@mobil_run:'+_txt,_opis)
           ?}
        || _result:='ERR';
           _opis:='Nie znaleziono pozycji operacji. Operacja zrealizowana lub anulowana.';
           _txt:=form(:idadd)+','
                   +'pozycja oper.: '+form(:ideanp)+','
                   +'kod: '+form(:kod)+','
                   +'wartość: '+form(:war);
              exec('rejLOG','magazyn_mob'
               ,:ideanc,:idusr,'PUT'
               ,:kod,:war,'','','',date(0,0,0),0,'w_cud@mobil_run:'+_txt,_opis)
        ?}
     || {? :idadd<>''
        || EANW.index('IDADD');
           EANW.prefix(:idadd);
           {? EANW.first()
           || _res:=EANW.del(1,1);
              {? _res>0
              || _result:='DEL';
                 _opis:='Usunięto kod GS1 dla pozycji operacji';
                 _res:=1
              || _result:='DEL';
                 _opis:='Nie udało się usunąć kodu GS1 dla pozycji operacji'
              ?}
           || _result:='DEL';
              _opis:='Nie znaleziono kodu GS1 dla pozycji operacji'
           ?};
           _txt:=form(:idadd)+','
                +'pozycja oper.: '+form(:ideanp)+','
                +'kod: '+form(:kod)+','
                +'wartość: '+form(:war);
           exec('rejLOG','magazyn_mob'
            ,:ideanc,:idusr,'DEL'
            ,:kod,:war,'','','',date(0,0,0),0,'w_cud@mobil_run:'+_txt,_opis)
        |? :ideanp<>''
        || EANP.index('IDADD');
           EANP.prefix(:ideanp);
           {? EANP.first()
           || EANW.index('EANP');
              EANW.prefix(EANP.ref());
              {? EANW.first()
              || {!
                 |? _res:=EANW.del(1,1);
                    {? _res>0
                    || _result:='DEL';
                       _opis:='Usunięto kody GS1 dla pozycji operacji'
                    || _result:='DEL';
                       _opis:='Nie udało się usunąć kodów GS1 dla pozycji operacji'
                    ?};
                    _res
                 !}
              || _result:='DEL';
                 _opis:='Nie znaleziono kodów GS1 dla pozycji operacji'
              ?}
           || _result:='DEL';
              _opis:='Nie znaleziono pozycji operacji dla kodów GS1'
           ?};
           _txt:='usunięcie wszystkich,'
                +'pozycja oper.: '+form(:ideanp);
           exec('rejLOG','magazyn_mob'
            ,:ideanc,:idusr,'DEL'
            ,'all','del','','','',date(0,0,0),0,'w_cud@mobil_run:'+_txt,_opis)
        ?}
     ?}
  ?};
  exec('addKO','magazyn_mob',:RS,_result,_opis,:idadd)
end formula

end proc


proc gs1

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [21.14]
:: OPIS: zwraca informacje o definicjach kodów GS1
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idgs1:=''  String[31],  Identyfikator kodu GS1 (Merit) lub kod GS1 lub brak kodu wówczas zwraca listę aktywnych kodów
end params

sql

select
  EAND.IDADD as IDADD,
  EAND.KOD as KOD,
  EAND.OPIS as OPIS,
  EAND.OENG as OENG,
  EAND.FORMAT as FORMAT,
  EAND.FNC1 as FNC1,
  EAND.RODZ as RODZ,
  EAND.A as AKT,
  EAND.R as TYP
from EAND
where (EAND.IDADD=:idgs1 or EAND.KOD=:idgs1 or (:idgs1='' and EAND.A='T'))
order by 2,3

end sql

formula
  _txt:={? :RS.size() || 'Znaleziono' || 'Brak' ?};
  _lst:={? :idgs1='' || 'lista aktywnych' || :idgs1 ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',_lst,'','','','',date(0,0,0),0,'gs1@mobil_run',_txt)
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

formula
  _oddz:={? (+:ideanc)=31
         || exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'_')
         || '_'
         ?};
  :mask:='eann'+_oddz+'__'
end formula

sql
  select
    SPACE(3) as KOD,
    SPACE(255) as OPIS
  from FIRMA
  where 2=1
end sql

formula
   exec('openean','open_tab',:mask+3);
   _txt:='';
   _oper:=null();
   {? :idope<>'' & (+:idope)=31 || _oper:=exec('FindAndGet','#table',EANP,:idope,,,null()) ?};
   {? _oper=null() & :idope<>'' & (+:idope)=31 || _oper:=exec('FindAndGet','#table',EANN,:idope,,,null()) ?};
   {? _oper=null() & :idope<>'' & (+:idope)=31 || _oper:=exec('FindAndGet','#table',M,:idope,,,null()) ?};
   {? _oper=null() & :idope<>'' & (+:idope)=31 || _oper:=exec('FindAndGet','#table',EANL,:idope,,,null()) ?};
   {? _oper=null() & :idope<>'' & (+:idope)=31 || _oper:=exec('FindAndGet','#table',PAL,:idope,,,null()) ?};
   {? _oper=null() & :idope<>''
   || _oper:=exec('FindInSet','#table','MKODK','KK',:idope,:idope,"MKODK.M",,,null());
      {? _oper<>null() || :kodk:=:idope ?}
   ?};
   {? _oper=null() & :kodk<>'' || _oper:=exec('FindInSet','#table','MKODK','KK',:kodk,:kodk,"MKODK.M",,,null()) ?};
   {? _oper=null() & :kodk=''
   || _res:='ERR:Nie znaleziono nagłówka, pozycji operacji lub materiału, lokalizacji'
   || _res:=exec('eanc2ETYK','magazyn_mobi',:ideanc,_oper,:rodzaj='P',:kodk)
   ?};
   {? (4+_res)='ERR:'
   || _txt:=_res;
      exec('addKO','magazyn_mob',:RS,'ERR',4-_res)
   |? :rodzaj='P'
   || _txt:='Wysłano na drukarkę';
      exec('addKO','magazyn_mob',:RS,'OK',_txt)
   || _txt:='Pobrano definicję etykiety';
      exec('addKO','magazyn_mob',:RS,'OK',_txt)
   ?};
   exec('rejLOG','magazyn_mob',:ideanc,:idusr,'PRN','','','','','',date(0,0,0),0,'etykieta@mobil_run:'+:rodzaj,_txt)
end formula

end proc


proc inwpal

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: kontroluję czy dana paleta została już odczytana na innych operacjach dotyczących inwentaryzacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idmg:=''   String[31],  IDMG - idadd Magazynu
  ideann:='' String[31],  IDEANN - idadd nagłówka operacji
  kodk:=''   String[30],  Kod kreskowy palety
end params

sql
  select
    SPACE(3) as KOD,
    SPACE(120) as OPIS
  from FIRMA
  where 2=1
end sql

formula
  _result:='ERR';
  _opis:='';

  _ok:=0;
  {? :idmg=''
  || _opis:='Nie podano identyfikatora magazynu'
  |? :ideann=''
  || _opis:='Nie podano identyfikatora operacji'
  |? :kodk=''
  || _opis:='Nie podano kodu kreskowego palety'
  |? :ideanc=''
  || {? (+:ideann)=31
     || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindInSet','#table','EANN','IDADD',:ideann,,"(1+(4-($EANN.ref())))",,,'');
        _ok:=ST.ODDZ<>''
     ?}
  |? exec('FindAndGet','#table',EANC,:ideanc,,,null())=null()
  || _opis:='(Merit) Nie znaleziono urządzenia'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"AKT",'')<>'T'
  || _opis:='(Merit) Urządzenie nie jest aktywne w systemie'
  |? exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ",null())=null()
  || _opis:='(Merit) Brak przypisania oddziału dla urządzenia'
  || ST.ODDZ:=ST.ODDZ_KOD:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",'');
     _ok:=ST.ODDZ<>''
  ?};
  {? _ok
  || _res:=exec('ctrlPALINW','magazyn_mobi',exec('FindAndGet','#table',MG,:idmg,,,null()),:kodk,:ideann,1);
     {? _res=0 || _result:='OK'; _opis:=''
     |? _res=1 || _opis:='Paleta odczytana na innej operacji mobilnej'
     |? _res=2 || _opis:='Paleta odczytana na danej operacji mobilnej'
     |? _res=3 || _opis:='(Merit) Paleta została już zarejestowana na otwartym arkuszu inwentaryzacyjnym'
     ?}
  ?};
  exec('addKO','magazyn_mob',:RS,_result,_opis);
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:kodk,:idmg,:ideann,'','',date(0,0,0),0,'inwpal@mobil_run',_opis)

end formula

end proc


proc jp

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca informacje o jednostkach i przelicznikach dla materialu wg idadd lub kodu kreskowego
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
  idmat:=''  String[31],  Identyfikator materiału (Merit) lub kod kreskowy materiału
end params

sql

select
  MJM.IDADD as IDADD,
  case
   when (MJM.JMG='T') then 'T'
   else MJM.MOD
  end as DOM,
  JM.KOD as JM,
  MJM.PRZ as PRZ,
  MJM.DOKL as PREC
from MJM
  join JM using(MJM.JM,JM.REFERENCE)
  join M using (MJM.M,M.REFERENCE)
where ((not (M.J2 is null) and MJM.JMG='T') or ((M.J2 is null) and MJM.MOB='T'))
  and (M.IDADD=:idmat or M.KODK=:idmat)
  and M.KODK<>''
order by 2 desc,3

end sql

formula
  {? :RS.size()
  || _txt:='Znaleziono';
     :RS.clear();
     :RS.prefix('T');
     {? ~:RS.first() & (_mat:=exec('FindAndGet','#table',MJM,:RS.IDADD,,"M",null()); _mat<>null())
     || :RS.prefix();
        :RS.IDADD:=exec('FindAndGet','#table',M,_mat,,"J().IDADD",'');
        :RS.DOM:='T';
        :RS.JM:=exec('FindAndGet','#table',M,_mat,,"J().KOD",0);
        :RS.PRZ:=1;
        :RS.PREC:=exec('FindAndGet','#table',M,_mat,,"DOKL",0);
        :RS.add(1)
     ?};
     :RS.prefix()
  || _txt:='Brak'
  ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:idmat,'','','','',date(0,0,0),0,'jp@mobil_run',_txt)
end formula

end proc


proc typpal

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca informacje o typach palety
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:='' String[31],  Identyfikator czytnika (Merit)
  idusr:=''  String[31],  Identyfikator operatora urządzenia
end params

sql

select
  TPAL.IDADD as IDADD,
  TPAL.TYP as TYP,
  'N' as DOM
from TPAL
order by 2

end sql

formula
  _txt:={? :RS.size() || 'Znaleziono' || 'Brak' ?};
  :RS.prefix();
  :RS.blank();
  :RS.IDADD:='';
  :RS.TYP:='[domyślna]';
  :RS.DOM:='T';
  :RS.add(1);
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS','','','','','',date(0,0,0),0,'typpal@mobil_run',_txt)
end formula

end proc


proc atr_dst

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca informacje o atrybutach materialu wg idadd lub kodu kreskowego lub pozycji operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[31],  Identyfikator operatora urządzenia
  idmeanp:=''  String[31],  Identyfikator materiału (Merit) lub kod kreskowy materiału lub EANP
end params

sql

select
  0 as LP,
  SPACE(20) as NAZ,
  SPACE(50) as WAR,
  'T' as TYP,
  'N' as AKT,
  SPACE(10) as GS1
from FIRMA
  where 2=1

order by 1

end sql

formula
  _txt:='';
  _eanp:=null();
  _mat:=exec('FindAndGet','#table',M,:idmeanp,,,null());
  {? var_pres('_mat')=type_of(~~) || _mat:=null() ?};
  {? _mat=null() || _mat:=exec('FindInSet','#table','M','KODK',:idmeanp,,,1,,,null()) ?};
  {? var_pres('_mat')=type_of(~~) || _mat:=null() ?};
  {? _mat<>null()
  || M.cntx_psh();
     M.prefix();
     {? M.seek(_mat) & M.M_ATR<>null()
     || _txt:='Atrybuty-struktura';
        {! _ii:=1..10
        |! :RS.prefix();
           :RS.blank();
           :RS.LP:=_ii;
           :RS.NAZ:=($('M.M_ATR().SL_%1().NA'[form(_ii,-2,0,'99')]))();
           :RS.TYP:=($('M.M_ATR().SL_%1().TYP'[form(_ii,-2,0,'99')]))();
           :RS.WAR:='';
           :RS.AKT:={? ($('M.M_ATR().MOB%1'[form(_ii,-2,0,'99')]))() || 'T' || 'N' ?};
           :RS.GS1:=($('M.M_ATR().GS1%1'[form(_ii,-2,0,'99')]))();
           :RS.add(1)
        !}
     || _txt:='Brak obsługi';
        :RS.prefix();
        :RS.blank();
        :RS.LP:=0;
        :RS.NAZ:='ERR';
        :RS.TYP:='T';
        :RS.WAR:='Brak obsługi';
        :RS.AKT:='N';
        :RS.add(1)
     ?};
     M.cntx_pop()
  |? (_oddz:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",''); _oddz<>'')
  || exec('openean','open_tab',_oddz+'__');
     EANP.index('IDADD');
     EANP.prefix(:idmeanp);
     {? EANP.first() & EANP.M<>null() & EANP.M().M_ATR<>null()
     || _txt:='Atrybuty-pozycja';
        {! _ii:=1..10
        |! :RS.prefix();
           :RS.blank();
           :RS.LP:=_ii;
           :RS.NAZ:=($('EANP.M().M_ATR().SL_%1().NA'[form(_ii,-2,0,'99')]))();
           :RS.TYP:=($('EANP.M().M_ATR().SL_%1().TYP'[form(_ii,-2,0,'99')]))();
           :RS.WAR:=($('EANP.WAR%1'[form(_ii,-2,0,'99')]))();
           :RS.AKT:={? ($('EANP.M().M_ATR().MOB%1'[form(_ii,-2,0,'99')]))() || 'T' || 'N' ?};
           :RS.GS1:=($('EANP.M().M_ATR().GS1%1'[form(_ii,-2,0,'99')]))();
           :RS.add(1)
        !}
     || _txt:='Brak obsługi';
        :RS.prefix();
        :RS.blank();
        :RS.LP:=0;
        :RS.NAZ:='ERR';
        :RS.TYP:='T';
        :RS.WAR:='Brak obsługi';
        :RS.AKT:='N';
        :RS.add(1)
     ?}
  || _txt:='Nie znaleziono';
     :RS.prefix();
     :RS.blank();
     :RS.LP:=0;
     :RS.NAZ:='ERR';
     :RS.TYP:='T';
     :RS.WAR:='Nie znaleziono materiału lub pozycji operacji';
     :RS.AKT:='N';
     :RS.add(1)
  ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:idmeanp,'','','','',date(0,0,0),0,'atr_dst@mobil_run',_txt)
end formula

end proc


proc atr_slo

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca zawartość słownika dla atrybutu
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[31],  Identyfikator operatora urządzenia
  idmat:=''    String[31],  Identyfikator materiału lub pozycji operacji (Merit)
  lpatr:=0     Integer,     Numer atrybutu
  slu:='xxx'   String[16],  Słownik
end params

formula
  _mat:=exec('FindAndGet','#table',M,:idmat,,,null());
  {? var_pres('_mat')=type_of(~~) || _mat:=null() ?};
  {? _mat=null() & (_oddz:=exec('FindAndGet','#table',EANC,:ideanc,,"ODDZ().KOD",''); _oddz<>'')
  || exec('openean','open_tab',_oddz+'__');
     EANP.index('IDADD');
     EANP.prefix(:idmeanp);
     _mat:={? EANP.first() || EANP.M || null() ?}
  ?};
  {? _mat<>null()
  || M.cntx_psh();
     M.prefix();
     {? M.seek(_mat) & M.M_ATR<>null()
     || {? :lpatr>0 & :lpatr<11 & ($('M.M_ATR().SL_%1().TYP'[form(:lpatr,-2,0,'99')]))()='S'
        || :slu:=$($('M.M_ATR().SL_%1().SLU'[form(:lpatr,-2,0,'99')]))()
        ?}
     ?};
     M.cntx_pop()
  ?}
end formula

sql

select
  SLO.KOD as KOD,
  SLO.TR as TR
from SLO
  where SLO.SLU=:slu

order by 1

end sql

formula
  {? :RS.size()
  || _txt:='Znaleziono'
  |? :slu='xxx'
  || _txt:='Atrybut nie jest słownikiem';
     :RS.prefix();
     :RS.blank();
     :RS.KOD:='ERR';
     :RS.TR:='Atrybut nie jest typu SŁOWNIK';
     :RS.add(1)
  || _txt:='Brak';
     :RS.prefix();
     :RS.blank();
     :RS.KOD:='NULL';
     :RS.TR:='Brak pozycji w słowniku';
     :RS.add(1)
  ?};
  exec('rejLOG','magazyn_mob'
   ,:ideanc,:idusr,'ANS',:idmat,$:lpatr,'','','',date(0,0,0),0,'atr_slo@mobil_run',_txt)
end formula

end proc


proc atr_ctrl

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca zawartość słownika dla atrybutu
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''   String[31],  Identyfikator czytnika (Merit)
  idusr:=''    String[31],  Identyfikator operatora urządzenia
  idmat:=''    String[31],  Identyfikator materiału (Merit)
  lpatr:=0     Integer,     Numer atrybutu
  war:=''      String[25],  Wartość do kontroli
end params

sql

select
  SPACE(3) as RES,
  SPACE(50) as INF
from FIRMA
  where 2=1

order by 1

end sql

formula
  _res:='Niepoprawne parametry';
  _mat:=exec('FindAndGet','#table',M,:idmat,,,null());
  {? var_pres('_mat')=type_of(~~) || _mat:=null() ?};
  {? _mat<>null()
  || M.cntx_psh();
     M.prefix();
     {? M.seek(_mat) & M.M_ATR<>null()
      & :lpatr>0 & :lpatr<11 & ($('M.M_ATR().SL_%1'[form(:lpatr,-2,0,'99')]))()<>null()
     || M.M_ATR().NAZ;
        _res:=exec('ae_atr_war','mat_atr',:lpatr,:war)
     ?};
     M.cntx_pop()
  ?};
  :RS.blank();
  :RS.RES:={? _res<>'' || 'ERR' || 'OK' ?};
  :RS.INF:=_res;
  :RS.add(1);
  {? _res<>''
  || exec('rejLOG','magazyn_mob'
      ,:ideanc,:idusr,'ANS',:idmat,$:lpatr,:war,'','',date(0,0,0),0,'atr_ctrl@mobil_run',_res)
  ?}
end formula

end proc


proc infdod

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [23.25]
:: OPIS: zwraca informację dodatkową dla pozycji operacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  ideanc:=''  String[31],  Identyfikator czytnika (Merit)
  idusr:=''   String[31],  Identyfikator operatora urządzenia
  ideann:=''  String[31],  unikalny identyfikator operacji
  idmat:=''   String[31],  unikalny identyfikator materiału
  ideanl:=''  String[31],  unikalny identyfikator lokalizacji
  scean:=''   String[128], unikalny identyfikator dostawy
  idpal:=''   String[31],  unikalny identyfikator palety
end params

sql
  select
    SPACE(250) as TXT1,
    SPACE(250) as TXT2
  from FIRMA
  where 2=1
end sql

formula
  {? (+:ideann)=31
  || _txt:=exec('infoEANP','magazyn_mobi',:ideann,:idmat,:ideanl,:scean,:idpal);
     {? +_txt[1]
     || :RS.clear();
        :RS.blank();
        :RS.TXT1:=_txt[1];
        :RS.TXT2:=_txt[2];
        :RS.add(1)
     ?};
     obj_del(_txt)
  ?}
end formula

end proc

#Sign Version 2.0 jowisz:1045 2024/02/28 10:29:51 14f883dd762ba68018650035ddb4009185efd88a894f41512c78978b5dc45b51a5f05a724acd85b96b93618ff33b7b94999fb8b97d14a0a9fec1d3ec0edf838230178812f290853158e431de727765e550b2dab9aae38ecc036ed9d86b539066a7e104b1d6f299225e63f7ccab3f11aaa5ce736ef8286afbd551aa612dc47604
