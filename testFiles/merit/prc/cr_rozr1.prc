:!UTF-8
proc cr_rozr1

desc
   Procedura dla Crystal Reports - Struktura wieku rozrachunkow
end desc

params
   DAY        DATE, Stan na dzień
   PTYP:='N' STRING[3], (N)ależność/(Z)obowiązanie
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
   P1:=7      INTEGER,   Przedzial1
   P2:=14     INTEGER,   Przedzial2
   P3:=30     INTEGER,   Przedzial3
   P4:=60     INTEGER,   Przedzial4
   P5:=90     INTEGER,   Przedzial5
   P6:=180    INTEGER,   Przedzial6
   KH         STRING[8], Kod kontrahenta
end params

formula
 kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAY>=OKRO_F.POCZ & :DAY<=OKRO_F.KON || kod:=OKRO_F.ROK().KOD ?};
       kod='' & OKRO_F.next()
    !}
 ?};
 {? kod<>''
 || VAR_DEL.delete('TABK');
    _rtabk:=1;
    {? (:ZK=2 & (form(:MASKA)='' | 6+:MASKA='%KHKOD')) | (:ZK=4 & form(:KS_OD)='' & form(:KS_DO)='')
    || _rtabk:=0
    ?};
    {? _rtabk & (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY'))
       & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',kod,SLO.ref,3,'A',:ZK,{? :ZK=2 || :MASKA |? :ZK=4 || :KS_OD || '' ?},
                            {? :ZK=4 || :KS_DO || '' ?},
                            {? :ZK=5 & :RSCH>0
                            || KON_WYDR.clear(); {? KON_WYDR.seek(:RSCH,KON_WYDR.name())
                                                 || KON_WYDR.ref
                                                 || 0
                                                 ?}
                            || 0
                            ?}, :STAMP)
    ?};
    {? _rtabk=0 | (var_pres('TABK')>100 & TABK.first())
    || VAR_DEL.delete('tabtmp');
       tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') MASK_FILTER(ZAP_OP,\'rozzap'+
                   kod+'\')*/ ODD.OD, KH.SKR, KH.NAZ, KH.KOD, OP.AN, OP.SYM,'+
                   '(select /*+MASK_FILTER(ZAP_OP,\'rozzap'+kod+
                   '\')*/ min(DATA) from @ZAP_OP where OP=OP.REFERENCE) as ZOPD, OP.TZ,'+
                   'sum(ZAP_OP.WN) as ZWN, sum(ZAP_OP.MA) as ZMA,'+
                   '(case when '+{? 1+:PTYP='A'
                                 || {? (1-:PTYP)<>''
                                    || '\''+(1-:PTYP)+'\''
                                    || 'substr(OP.TYP,1,1)'
                                    ?}
                                 || '\''+1+:PTYP+'\''
                                 ?}+'=''N'''+
                   ' then sum(ZAP_OP.WN)-sum(ZAP_OP.MA) else sum(ZAP_OP.MA)-sum(ZAP_OP.WN) end) as SALDO,'+
                   'OP.REFERENCE as REF, KH.REFERENCE as KHREF '+
                   'from @ZAP_OP '+{? :ODD='' || 'left ' || '' ?}+
                                'join ODD '+
                                'join @OP using (ZAP_OP.OP, OP.REFERENCE) '+
                                {? _rtabk
                                || 'join :_a using (:_a.ANSYM,OP.AN)'
                                || ''
                                ?}+
                                'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                   'where '+{? 1+:PTYP='A'
                            || {? :PTYP='A'
                               || '(OP.TYP like ''N%'' or OP.TYP like ''Z%'')'
                               || 'OP.TYP like '''+(1-:PTYP)+'%'''
                               ?}
                            || 'OP.TYP like '':_c%'''
                            ?}+' and ZAP_OP.DATA<=to_date(:_b) and SWAL.KOD='':_d'''+
                   {? 6+:MASKA='%KHKOD' || ' and KH.KOD='''+(6-:MASKA)+''''
                   |? form(:KH)<>''     || ' and KH.KOD='''+:KH+''''
                   || ''
                   ?}+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                   {? 1+:PTYP='A'
                   || ' and OP.TZ>=case substr(OP.TYP,1,1) when \'N\' then to_date(:_f) else to_date(:_h) end'+
                      ' and OP.TZ<=case substr(OP.TYP,1,1) when \'N\' then to_date(:_g) else to_date(:_i) end'
                   || ' and OP.TZ<to_date(:_b)'
                   ?}+
                   ' group by ODD.OD, KH.SKR, KH.NAZ, KH.KOD, OP.TYP, OP.AN,'+
                   'OP.SYM, OP.TZ, OP.REFERENCE, KH.REFERENCE',
                   {? var_pres('TABK')>100 || TABK || null ?},:DAY,:PTYP,:WAL,:ODD,
                   {?1+:PTYP='A'||#(#:KS_OD-:P1)|| date() ?},
                   {?1+:PTYP='A'||#(#:KS_DO-:P1)||date()?},
                   {?1+:PTYP='A'||#(#:KS_OD-:P2)|| date() ?},
                   {?1+:PTYP='A'||#(#:KS_DO-:P2)||date()?});
       {? var_pres('tabtmp')>100
       || tabtmp.for_each("{? tabtmp.SALDO=0 | (PAR_SKID.get(47)='N' & tabtmp.SALDO<0) || tabtmp.del() ?}")
       ?};
       {? tabtmp.first()
       || VAR_DEL.delete('DRB');
          {? var_pres('DRB',@.CLASS)<0 || exec('obj_drbt','raty') ?};
          DRB:=obj_new(@.CLASS.DRB);
          D_RB.use('dr__fk'+((8+tabtmp.REF)+2)); D_RB.index('OP'); D_RB.prefix();
          OP.use(8+tabtmp.REF); OP.prefix();
          {!
          |? _ref:=BB.sqlint(tabtmp.REF);
             {? OP.seek(_ref,) & DRB.set_tab(_ref,,:DAY)
             || _tt_ref:=tabtmp.ref();
                _i:=1;
                {!
                |? tabtmp.TZ:=t_drb[_i][3];
                   tabtmp.ZWN:=t_drb[_i][2];
                   tabtmp.ZMA:=t_drb[_i][1];
                   tabtmp.SALDO:={? 1+OP.TYP='N' || t_drb[_i][1]-t_drb[_i][2] || t_drb[_i][2]-t_drb[_i][1] ?};
                   {? tabtmp.SALDO<>0 || tabtmp.add() ?};
                   _i+=1;
                   _i<=DRB.LRAT
                !};
                tabtmp.cntx_psh();
                tabtmp.seek(_tt_ref); tabtmp.del();
                tabtmp.cntx_pop()
             ?};
             tabtmp.next()
          !};
          VAR_DEL.delete('DRB')
       ?}
    ?}
 ?}
end formula

sql
select ODD.OD, KH.SKR, KH.NAZ, KH.KOD, OP.AN, OP.SYM, OP.DO, OP.TZ, OP.WN, OP.MA, cast(null as real_type) as SALDO,
       OP.REFERENCE as REF,0 as ILD,'                    ' as PRZ, OP.TYP, cast (null as date_type) as KTZ
from OP join KH left join ODD where OP.REFERENCE is null
end sql

formula
 {? var_pres('tabtmp')>100 & tabtmp.first()
 || OP.cntx_psh(); ZAP_OP.cntx_psh();
    OP.use('operac' + kod); ZAP_OP.use('rozzap'+ kod);
    OP.clear(); KH.clear();
    SER_KOR.DATA:=:DAY;
    {!|? {? OP.seek(BB.sqlint(tabtmp.REF),OP.name())
            & KH.seek(BB.sqlint(tabtmp.KHREF),KH.name())
         || :RS.blank();
            {! _i:=1..12 |! :RS[_i]:=tabtmp[_i] !};
            :RS.TYP:=OP.TYP;
            {? 1+:PTYP='A' || :RS.KTZ:=:RS.TZ+{? 1+OP.TYP='N' || :P1 || :P2 ?} ?};
            {? 1+:PTYP<>'A'
            ||:RS.ILD:=:DAY-:RS.TZ;
              {? :RS.ILD>=0
              || :RS.PRZ:={? :RS.ILD>:P6 || 'powyżej '+form($:P6,-3)
                          |? :RS.ILD>:P5 & :RS.ILD<=:P6 || 'od '+form('  '+$:P5,-3)+' do '+form('  '+$:P6,-3)+' wł.'
                          |? :RS.ILD>:P4 & :RS.ILD<=:P5 || 'od '+form('  '+$:P4,-3)+' do '+form('  '+$:P5,-3)+' wł.'
                          |? :RS.ILD>:P3 & :RS.ILD<=:P4 || 'od '+form('  '+$:P3,-3)+' do '+form('  '+$:P4,-3)+' wł.'
                          |? :RS.ILD>:P2 & :RS.ILD<=:P3 || 'od '+form('  '+$:P2,-3)+' do '+form('  '+$:P3,-3)+' wł.'
                          |? :RS.ILD>:P1 & :RS.ILD<=:P2 || 'od '+form('  '+$:P1,-3)+' do '+form('  '+$:P2,-3)+' wł.'
                          || 'od   0 do '+form('  '+$:P1,-3)+' wł.'
                          ?};
                 :RS.add()
              ?}
            || :RS.add()
            ?}
         ?}; tabtmp.next()
    !};
    OP.cntx_pop(); ZAP_OP.cntx_pop()
 ?};
 {? :STAMP<>''
 || TMPSIK.index('TEXT1'); TMPSIK.prefix('K',:STAMP); {? TMPSIK.first() || {!|? TMPSIK.del()!} ?}
 ?};
 VAR_DEL.delete('tabtmp','TABK')
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 8704dbff0994dd488ccd6377a59bf1278a2330863f376848ced536e30ac7d09a144c63b1ca9f014e8fb3aa1bf7ae3eae9a7f2d214899591cba42bfdedcd008dbe52aca03a694801d83a3971eee695de9b221fb8dfccbe071f9fe1b8e76d72f5e8058eba79f9add0ac586c40d0e773b209872e6daca8554a1c792d5031b4686b6
