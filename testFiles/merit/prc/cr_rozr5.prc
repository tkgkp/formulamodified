:!UTF-8
proc cr_rozr5

desc
   Procedura dla Crystal Reports 'Sredni czas regulowania splat powstalych w okresie od .. do'
end desc

params
   DAYOD      DATE, Od dnia
   DAYDO      DATE, Do dnia
   TYT:=''    STRING[50],Tytuł zestawienia
   WAL:='PLN' STRING[3], Kod waluty
   ODD:=''    STRING[8], Jednostka księgowa
   MASKA:=''  STRING[35],Maska
   KH         STRING[8], Kod kontrahenta
   TYP        STRING[1], Typ rozrachunku (N/Z)
end params

formula
 VAR_DEL.delete('TABK','tabtmp','tabtmpcz');
 kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAYDO>=OKRO_F.POCZ & :DAYDO<=OKRO_F.KON || kod:=OKRO_F.ROK().KOD ?};
       kod='' & OKRO_F.next()
    !}
 ?};
 :MASKA:=form(:MASKA+'?'*35,35); _m:=STR.gsub(:MASKA,'?','');
 {? kod<>''
 || {? _m<>'' & (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY')) & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',kod,SLO.ref,3,'A',2,:MASKA,'', 0, '')
    ?};
    {? _m='' | (var_pres('TABK')>100 & TABK.first())
    || tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') MASK_FILTER(ZAP_OP,\'rozzap'+kod+'\')*/ '+
                   'KH.KOD, KH.SKR, KH.NAZ, case when OP.TYP like \'N%\' then sum(ZAP_OP.WN) else sum(ZAP_OP.MA) end as WPL,'+
                   'case when OP.TYP like \'N%\' then sum(ZAP_OP.MA) else sum(ZAP_OP.WN) end as URG,PLAT.TR as WARPL '+
                   'from @ZAP_OP '+{? :ODD='' || 'left ' || '' ?}+'join ODD join @OP using (ZAP_OP.OP, OP.REFERENCE) '+
                   {? _m<>'' || 'join :_a using (:_a.ANSYM,OP.AN) ' || '' ?}+'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                   'left join SLO as PLAT using (KH.PLATNOSC, PLAT.REFERENCE) '+
                   'where OP.TYP like \':_f%\' and ZAP_OP.DATA>=to_date(:_b) and ZAP_OP.DATA<=to_date(:_c) and SWAL.KOD='':_d'''+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                   {?:KH<>'' || 'and KH.KOD='''+:KH+'''' || '' ?}+
                   'group by KH.KOD,KH.SKR, KH.NAZ,OP.TYP,PLAT.TR',{? var_pres('TABK')>100 || TABK || null ?}, :DAYOD, :DAYDO,:WAL,:ODD,:TYP);
       tabtmpcz:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') MASK_FILTER(ZAP_OP,\'rozzap'+kod+'\')*/ '+
                     'KH.KOD as KHK,KH.SKR as KHS, OP.TYP,cast(max(ZAP_OP.DATA) as integer_type)-cast(OP.TZ as integer_type) as CZAS,'+
                     'sum(ZAP_OP.WN) as WN, sum(ZAP_OP.MA) as MA, OP.REFERENCE as OPR, OP.DO as OPDO, OP.TZ as OPTZ '+
                     'from @ZAP_OP '+{? :ODD='' || 'left ' || '' ?}+'join ODD join @OP using (ZAP_OP.OP, OP.REFERENCE) '+
                     {? _m<>'' || 'join :_a using (:_a.ANSYM,OP.AN) ' || '' ?}+'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                     'where OP.TYP like \''+:TYP+'%\' and ZAP_OP.DATA<=to_date(:_c) and OP.DO<=OP.TZ and SWAL.KOD='':_d'''+
                     {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                     {?:KH<>'' || 'and KH.KOD='''+:KH+'''' || '' ?}+
                     'group by KH.KOD,KH.SKR,OP.TYP,OP.REFERENCE,OP.DO,OP.TZ order by KHK,CZAS',{? var_pres('TABK')>100 || TABK || null ?}, :DAYOD, :DAYDO,:WAL,:ODD);
       {? var_pres('tabtmpcz')>100
       || tabtmpcz.for_each("{? {? 1+tabtmpcz[3]='N'
                                || tabtmpcz[6]=0 | tabtmpcz[6]>tabtmpcz[5]
                                || tabtmpcz[5]=0 | tabtmpcz[5]>tabtmpcz[6]
                                ?}
                             || tabtmpcz.del()
                             ?}");
          {? tabtmpcz.first()
          || OP.cntx_psh(); ZAP_OP.cntx_psh();
             OP.use('operac'+kod); ZAP_OP.use('rozzap'+kod);
             OP.clear(); ZAP_OP.clear(); ZAP_OP.index('OP');
             {! |?
                {? OP.seek(BB.sqlint(tabtmpcz[7]),OP.name()) & (ZAP_OP.prefix(OP.ref()); ZAP_OP.size>1)
                || _p:=tabtmpcz[4];
                   _dt:=exec('dat_spl','rozrach',:DAYDO);
                   {? _dt>date(0,0,0)
                   || tabtmpcz[4]:=_dt-OP.TZ
                   || tabtmpcz[4]:=0
                   ?};
                   {? _p<>tabtmpcz[4] | 1 || tabtmpcz.put() ?}
                ?};
                tabtmpcz.next()
             !};
             OP.cntx_pop(); ZAP_OP.cntx_pop()
          ?}
       ?}
    ?}
 ?}
end formula

sql
select KH.KOD,KH.SKR, KH.NAZ, cast(0 as real_type) as WPL, cast(0 as real_type) as URG, SLO.TR as WARPL, cast(0 as integer_type) as SCZS
from KH left join SLO using (SLO.REFERENCE, KH.PLATNOSC) where KH.KOD=''
end sql

formula
 {? var_pres('tabtmp')>100 & tabtmp.first() & var_pres('tabtmpcz')>100
 || tabtmpcz.index(tabtmpcz.ndx_tmp('',1,'KHK',,0));
    {!|? :RS.blank(); _s:=_sz:=0;
         {! _i:=1..6 |! :RS[_i]:=tabtmp[_i] !};
         :RS[7]:={? tabtmpcz.prefix(tabtmp[1]); tabtmpcz.first()
                 || {! |? _s+=tabtmpcz.CZAS; _sz+=1; tabtmpcz.next() !};
                    {? _s<>0 || (_s/_sz)$0 ?}
                 ?};
         :RS.add();
         tabtmp.next()
    !}
 ?};
 VAR_DEL.delete('tabtmp','tabtmpcz','TABK','tmp')
end formula

end proc

proc crrozr5a

desc
   Podprocedura dla Crystal Reports 'Sredni czas regulowania splat powstalych w okresie od .. do' dla naleznosci
end desc

params
   DAYOD      DATE, Od dnia
   DAYDO      DATE, Do dnia
   WAL        STRING[3], Kod waluty
   ODD        STRING[8], Jednostka księgowa
   MASKA      STRING[35],Maska
   KH         STRING[8], Kod kontrahenta
   TYP        STRING[1], Typ rozrachunku (N/Z)
end params

formula
 VAR_DEL.delete('TABK','tabtmp');
 kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAYDO>=OKRO_F.POCZ & :DAYDO<=OKRO_F.KON || kod:=OKRO_F.ROK().KOD ?};
       kod='' & OKRO_F.next()
    !}
 ?};
 :MASKA:=form(:MASKA+'?'*35,35); _m:=STR.gsub(:MASKA,'?','');
 {? var_pres('tmp')>100 & tmp.last() & kod<>''
 || {? _m<>'' & (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY')) & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',kod,SLO.ref,3,'A',2,:MASKA,'', 0, '')
    ?};
    {? _m='' | (var_pres('TABK')>100 & TABK.first())
    || tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') MASK_FILTER(ZAP_OP,\'rozzap'+kod+'\')*/ '+
                   'OP.SYM, ODD.OD, OP.DO, OP.TZ, case when OP.TYP like \'N%\' then sum(ZAP_OP.WN) else sum(ZAP_OP.MA) end as WPL,'+
                   'case when OP.TYP like \'N%\' then sum(ZAP_OP.MA) else sum(ZAP_OP.WN) end as URG,'+
                   'cast(max(ZAP_OP.DATA) as integer_type)-cast(OP.TZ as integer_type) as CZAS, SWAL.KOD as KWAL, OP.REFERENCE as OPR '+
                   'from @ZAP_OP '+{? :ODD='' || 'left ' || '' ?}+'join ODD join @OP using (ZAP_OP.OP, OP.REFERENCE) '+
                   {? _m<>'' || 'join :_a using (:_a.ANSYM,OP.AN) ' || '' ?}+'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                   'where OP.TYP like \':_f%\' and ZAP_OP.DATA>=to_date(:_b) and ZAP_OP.DATA<=to_date(:_c) and SWAL.KOD='':_d'''+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                   {?:KH<>'' || 'and KH.KOD='''+:KH+'''' || '' ?}+
                   'group by OP.SYM,OP.TYP,ODD.OD,OP.DO,OP.TZ,SWAL.KOD,OP.REFERENCE',{? var_pres('TABK')>100 || TABK || null ?}, :DAYOD, :DAYDO,:WAL,:ODD,:TYP)
    ?}
 ?}
end formula

sql
select OP.SYM,ODD.OD,OP.DO,OP.TZ, cast(0 as real_type) as WPL, cast(0 as real_type) as URG,  cast(0 as integer_type) as CZAS, SWAL.KOD as KWAL,
cast(null as date_type) as DURG
from OP join ODD join SLO as SWAL using (SWAL.REFERENCE, OP.WAL) where OP.SYM=''
end sql

formula
 OP.cntx_psh(); ZAP_OP.cntx_psh();
 OP.use('operac'+kod); ZAP_OP.use('rozzap'+kod);
 OP.clear(); ZAP_OP.clear(); ZAP_OP.index('OP');
 {? var_pres('tabtmp')>100 & tabtmp.first()
 || {!|? :RS.blank();
         {! _i:=1..8 |! :RS[_i]:=tabtmp[_i] !};
         {? OP.seek(BB.sqlint(tabtmp[9]),OP.name())
         || {? (ZAP_OP.prefix(OP.ref());ZAP_OP.size>1)
            || _dt:=exec('dat_spl','rozrach',:DAYDO);
               {? _dt>date(0,0,0)
               || :RS[7]:=_dt-OP.TZ;
                  :RS[9]:=:RS[4]+:RS[7]
               || :RS[7]:=0;
                  :RS[9]:=date(0,0,0);
                  :RS[10]:=pow(2,8)
               ?}
            || {? :RS.URG>0
               || :RS[9]:=:RS[4]+:RS[7]
               || :RS[9]:=date(0,0,0); :RS[10]:=pow(2,8)
               ?}
            ?}
         ?};
         :RS.add(); tabtmp.next() !}
 ?};
 OP.cntx_pop(); ZAP_OP.cntx_pop();
 VAR_DEL.delete('tabtmp','TABK','tmp')
end formula

end proc

proc crrozr5b

desc
   Podprocedura dla Crystal Reports 'Sredni czas regulowania splat powstalych w okresie od .. do' dla sredni czas splaty
end desc

params
   DAYOD      DATE, Od dnia
   DAYDO      DATE, Do dnia
   WAL        STRING[3], Kod waluty
   ODD        STRING[8], Jednostka księgowa
   MASKA      STRING[35],Maska
   KH         STRING[8], Kod kontrahenta
   TYP        STRING[1], Typ rozrachunku (N/Z)
end params

formula
 VAR_DEL.delete('tmp','TABK','tabtmp');
 kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAYDO>=OKRO_F.POCZ & :DAYDO<=OKRO_F.KON || kod:=OKRO_F.ROK().KOD ?};
       kod='' & OKRO_F.next()
    !}
 ?};
 :MASKA:=form(:MASKA+'?'*35,35); _m:=STR.gsub(:MASKA,'?','');
 {? var_pres('tmp')>100 & tmp.last() & kod<>''
 || {? _m<>'' & (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY')) & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',kod,SLO.ref,3,'A',2,:MASKA,'', 0, '')
    ?};
    {? _m='' | (var_pres('TABK')>100 & TABK.first())
    || tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') MASK_FILTER(ZAP_OP,\'rozzap'+kod+'\')*/ '+
                   'OP.SYM, ODD.OD, OP.DO, OP.TZ, OP.AN, case when OP.TYP like \'N%\' then sum(ZAP_OP.WN) else sum(ZAP_OP.MA) end as WPL,'+
                   'case when OP.TYP like \'N%\' then sum(ZAP_OP.MA) else sum(ZAP_OP.WN) end as URG,'+
                   'cast(max(ZAP_OP.DATA) as integer_type) - cast(OP.TZ as integer_type) as CZAS,'+
                   'SWAL.KOD as KWAL,OP.REFERENCE as OPR '+
                   'from @ZAP_OP '+{? :ODD='' || 'left ' || '' ?}+'join ODD join @OP using (ZAP_OP.OP, OP.REFERENCE) '+
                   {? _m<>'' || 'join :_a using (:_a.ANSYM,OP.AN) ' || '' ?}+'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                   'where OP.TYP like \':_f%\' and ZAP_OP.DATA<=to_date(:_c) and SWAL.KOD='':_d'''+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?}+
                   {?:KH<>'' || 'and KH.KOD='''+:KH+'''' || '' ?}+
                   'group by OP.SYM,ODD.OD,OP.DO,OP.TZ,OP.AN,OP.TYP,SWAL.KOD,OP.REFERENCE',
                   {? var_pres('TABK')>100 || TABK || null ?}, :DAYOD, :DAYDO,:WAL,:ODD,:TYP);
       {? var_pres('tabtmp')>100 || tabtmp.for_each("{? tabtmp.WPL=0 | tabtmp.WPL>tabtmp.URG | tabtmp.DO>tabtmp.TZ || tabtmp.del() ?}") ?}
    ?}
 ?}
end formula

sql
select OP.SYM,ODD.OD,OP.DO,OP.TZ,OP.AN,
cast(0 as real_type) as WPL,
cast(0 as real_type) as URG,
cast(0 as integer_type) as CZAS,
SWAL.KOD as KWAL,
cast(null as date_type) as DURG
from OP join ODD join SLO as SWAL using (SWAL.REFERENCE, OP.WAL) where OP.SYM=''
end sql

formula
 OP.cntx_psh(); ZAP_OP.cntx_psh();
 OP.use('operac'+kod); ZAP_OP.use('rozzap'+kod);
 OP.clear(); ZAP_OP.clear(); ZAP_OP.index('OP');
 {? var_pres('tabtmp')>100 & tabtmp.first()
 || {!|? :RS.blank(); {! _i:=1..9 |! :RS[_i]:=tabtmp[_i] !};
         {? OP.seek(BB.sqlint(tabtmp[10]),OP.name()) & (ZAP_OP.prefix(OP.ref());ZAP_OP.size>1)
         || _dt:=exec('dat_spl','rozrach',:DAYDO);
            {? _dt>date(0,0,0)
            || :RS[8]:=_dt - OP.TZ;
               :RS[10]:=_dt
            || :RS[8]:=0;
               :RS[10]:=date(0,0,0);
               :RS[11]:=pow(2,9)
            ?}
         ?};
         :RS.add(); tabtmp.next() !}
 ?};
 OP.cntx_pop(); ZAP_OP.cntx_pop();
 VAR_DEL.delete('tabtmp','TABK','tmp')
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 dc324bd8a1fe1cbbf0c6e3d0a77dbe9f8833b08f7a0810973016494323f5a2e6f6ec42494d0fe8289fc8b02861c11d9a46484f91a2adc095a9bfe2cd7b0d48a03083dc88dad78904f9e1430cca56a3fa8b92f872d26fa63df6ec6538a77317ebe305e633f9085fe33526c6e6b8d622a50beb6b1ff1cb474d07a77753bb302b00
