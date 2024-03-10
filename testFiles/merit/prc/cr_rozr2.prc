:!UTF-8
proc cr_rozr2

desc
   Najwieksi dluznicy/wierzyciele na dzien (Crystal Reports)
end desc

params
   DAY        DATE, Stan na dzień
   TYP:='N' STRING[3], (N)ależność/(Z)obowiązanie
   TYT:=''    STRING[50],Tytuł zestawienia
   WAL:='PLN' STRING[3], Kod waluty
   ODD:=''    STRING[8], Jednostka księgowa
   ZK:=2      INTEGER,   (2)Maska,(4)Zakres
   MASKA:=''  STRING[35],Maska
   KS_OD:=''  STRING[6], (Zakres) Od konta
   KS_DO:=''  STRING[6], (Zakres) Do konta
   SCH:=''    STRING[8], Zestaw kont
   RSCH:=0    INTEGER,   Ref zestawu kont
   STAMP:=''  STRING[29],USER tm_stamp
   ILKH:=0    INTEGER,  Ilość prezentowanych kontrahentów
end params

formula
 exec('F','object');
 _kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAY>=OKRO_F.POCZ & :DAY<=OKRO_F.KON || _kod:=OKRO_F.ROK().KOD ?};
       _kod='' & OKRO_F.next()
    !}
 ?};
 {? _kod<>''
 || VAR_DEL.delete('TABK');
    {? (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY'))
       & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',_kod,SLO.ref,3,'A',:ZK,{? :ZK=2 || :MASKA
                                                       |? :ZK=4 || :KS_OD
                                                       || '' ?},
                            {? :ZK=4 || :KS_DO || '' ?},
                            {? :ZK=5 & :RSCH>0
                            || {? KON_WYDR.clear(); KON_WYDR.seek(:RSCH,KON_WYDR.name())
                               || KON_WYDR.ref
                               || 0
                               ?}
                            || 0
                            ?}, :STAMP)
    ?};
    {? var_pres('TABK')>100 & TABK.first()
    || VAR_DEL.delete('tabtmp');
       tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+_kod+'\')*/ '+
                   'ODD.OD, KH.SKR as SKR, KH.NAZ, OP.AN, OP.SYM, OP.TZ,'+
                   '(select /*+MASK_FILTER(ZAP_OP,\'rozzap'+_kod+'\')*/ min(DATA) '+
                   'from @ZAP_OP where OP=OP.REFERENCE) as ZOPD,'+
                   'cast(0 as real_type) as ZWN, '+
                   'cast(0 as real_type) as ZMA, '+
                   'cast(0 as real_type) as SALDO, '+
                   'cast(0 as real_type) as SALDO1,'+
                   'OP.REFERENCE as REF,0 as ILD, cast(0 as real_type) as ODS,'+
                   'KH.REFERENCE as KHREF '+
                   'from @OP join ODD join :_a using (:_a.ANSYM,OP.AN) '+
                   'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                   'where OP.TYP like '':_c%'' and SWAL.KOD='':_d'' '+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                   ' group by ODD.OD, KH.SKR, KH.NAZ, OP.TYP, OP.AN, OP.SYM, OP.TZ, '+
                   'OP.REFERENCE, KH.REFERENCE',TABK,:DAY,:TYP,:WAL,:ODD);
       {? var_pres('tabtmp')>100
       || {? tabtmp.first()
          || OP.cntx_psh(); ZAP_OP.cntx_psh();
             OP.use('operac'+_kod);
             OP.clear(); KH.clear();
             ZAP_OP.use('rozzap'+_kod); ZAP_OP.index('OP');
             SER_KOR.DATA:=:DAY;
             {!
             |? {? OP.seek(BB.sqlint(tabtmp.REF),OP.name())
                   & KH.seek(BB.sqlint(tabtmp.KHREF),KH.name())
                || ZAP_OP.prefix(OP.ref());
                   {? ZAP_OP.first()
                   || _wn:=_ma:=0;
                      {!
                      |? {? ZAP_OP.DATA<=:DAY
                         || _wn+=ZAP_OP.WN;
                            _ma+=ZAP_OP.MA; 1
                         ?} & ZAP_OP.next()
                      !};
                      tabtmp.ZWN:=_wn;
                      tabtmp.ZMA:=_ma;
                      {? :DAY<=OP.TZ
                      || tabtmp.SALDO:={? 1+OP.TYP='N' || _wn-_ma || _ma-_wn ?}
                      || tabtmp.SALDO1:={? 1+OP.TYP='N' || _wn-_ma || _ma-_wn ?}
                      ?};
                      {? PAR_SKID.get(47)='N'
                      || {? 1+OP.TYP='N' & _wn<_ma | 1+OP.TYP='Z' & _wn>_ma
                         || tabtmp.SALDO:=tabtmp.SALDO1; tabtmp.SALDO1:=0
                         ?}
                      ?};
                      {? OP.TYP*'OD'=0 & (tabtmp.SALDO<>0 | tabtmp.SALDO1)
                      || exec('jakisch','rozrach');
                         SER_KOR.TAB_ODS:={? SER_KOR.SER_SCH().ODS<>null
                                          || SER_SCH.ODS
                                          || FINFO.TODS_DOM
                                          ?};
                         tabtmp.ODS:=exec('odsetki','rozrach_ods',OP.ref(),:DAY,1)
                      ?}
                   ?}
                ?};
                tabtmp.ILD:=:DAY-tabtmp.TZ;
                {? tabtmp.SALDO=0 & tabtmp.SALDO1=0
                || tabtmp.del()
                || tabtmp.put(); tabtmp.next()
                ?}
             !};
             OP.cntx_pop(); ZAP_OP.cntx_pop()
          ?};
          VAR_DEL.delete('tabtmpkh');
          tabtmpkh:=sql('select SKR, sum(SALDO1)+sum(ODS) as SALDOKH,'''+({? :ILKH<=0
                                                                         || +$(KH.prefix(); KH.size())
                                                                         || 10
                                                                         ?}*' ')+
                        ''' as PRZ from :_a group by :_a.SKR order by SALDOKH DESC, SKR',tabtmp)
       ?}
    ?}
 ?}
end formula

sql
select ODD.OD, KH.SKR, KH.NAZ, OP.AN, OP.SYM, OP.TZ, OP.DO, OP.WN, OP.MA,
       cast(null as real_type) as SALDO, cast(null as real_type) as SALDO1,
       OP.REFERENCE as REF, 0 as ILD, cast(0 as real_type) as ODS,
       '                    ' as PRZ
from OP join KH left join ODD where OP.REFERENCE is null
end sql

formula
 {? var_pres('tabtmp')>100 & tabtmp.first() & var_pres('tabtmpkh')>100 & tabtmpkh.first()
 || _licz:=0; _size:=+$(KH.prefix();+KH.size());
    {! |? _licz+=1; tabtmpkh.PRZ:={? :ILKH<=0 | _licz<=:ILKH
                                  || form(_size*' '+$_licz,-_size)
                                  || 'Pozostali'
                                  ?};
         tabtmpkh.put(); tabtmpkh.next()!};
    tabtmpkh.index(tabtmpkh.ndx_tmp('',0,'SKR',,0,'SKR',,0));
    {!|? {! _i:=1..14 |! :RS[_i]:=tabtmp[_i] !};
         :RS.PRZ:={? tabtmpkh.find_key(tabtmp.SKR, tabtmp.SKR) || tabtmpkh.PRZ || '' ?};
         :RS.add(); tabtmp.next() !}
 ?};
 {? :STAMP<>''
 || TMPSIK.index('TEXT1'); TMPSIK.prefix('K',:STAMP);
    {? TMPSIK.first() || {!|? TMPSIK.del()!} ?}
 ?};
 VAR_DEL.delete('tabtmp','tabtmpkh','TABK')
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 985f0fb9a6bcefc55fd794b6b893bd0806969a55fb6d4c087c08895b8612f9c0c21beb0dc659486e7fecbd98a7ea53ff06436c756a93b73c9522fcea7389c2c45628e8e77a92d2f19892eb7917f987ccb147e677d6412b3341c4db2364013a7a92cb2b4a8f33c965c8d2688bdaf1e63a8438801db5c7607881e33f36d5b1a3d6
