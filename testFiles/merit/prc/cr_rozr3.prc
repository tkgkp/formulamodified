:!UTF-8
proc cr_rozr3

desc
   Procedura dla Crystal Reports 'Naleznosci wedlug handlowcow od dnia do dnia'
end desc

params
   DAYOD      DATE, Od dnia
   DAYDO      DATE, do dnia
   TYT:=''    STRING[50],Tytuł zestawienia
   WAL:='PLN' STRING[3], Kod waluty
   ODD:=''    STRING[8], Jednostka księgowa
   MASKA:=''  STRING[35],Maska
end params

formula
 exec('F','object');
 VAR_DEL.delete('TABK','tabtmp','data1','data2');
 kod:='';
 OKRO_F.index('FIRMA_NR'); OKRO_F.prefix(REF.FIRMA);
 {? OKRO_F.first()
 || {!
    |? {? :DAYDO>=OKRO_F.POCZ & :DAYDO<=OKRO_F.KON || kod:=OKRO_F.ROK().KOD ?};
       kod='' & OKRO_F.next()
    !}
 ?};
 :MASKA:=form(:MASKA+'?'*35,35);
 {? kod<>''
 || {? (SLU.index('NAZ');SLU.prefix();SLU.find_key('WALUTY'))
       & (SLO.index('SL');SLO.prefix();SLO.find_key(SLU.ref,:WAL))
    || exec('konta','dok_fks_zest',kod,SLO.ref,3,'A',2,:MASKA,'', 0, '')
    ?};
    {? var_pres('TABK')>100 & TABK.first()
    || tabtmp:=sql('select /*+MASK_FILTER(OP,\'operac'+kod+'\') '+
                   'MASK_FILTER(ZAP_OP,\'rozzap'+kod+'\')*/ '+
                   'ODD.OD, KH.KOD as KOD, KH.SKR as SKR, KH.NAZ, OP.AN, OP.SYM, OP.TZ, OP.DO,'+
                   'cast(null as real_type) as NALPOW,'+
                   'cast(null as real_type) as SPLPRZ,'+
                   'OP.REFERENCE as REF, KH.REFERENCE as KHREF, HAN.KOD as HKOD, HAN.NAZ as HNAZ,'+
                   'HAN.ADR as ADR, HAN.TEL, HAN.EMAIL, '+
                   'cast(null as real_type) as NALPO,'+
                   'HAN1.KOD as H1KOD, HAN1.NAZ as H1NAZ, HAN1.ADR as H1ADR, HAN1.TEL as H1TEL, HAN1.EMAIL as H1EMAIL '+
                   'from @OP '+{? :ODD='' || 'left ' || '' ?}+'join ODD '+
                                'join :_a using (:_a.ANSYM,OP.AN) '+
                                'join KH join SLO as SWAL using (OP.WAL,SWAL.REFERENCE) '+
                                'left join KH_DOD using (KH_DOD.KH,KH.REFERENCE) '+
                                'left join HAN using (OP.HAN, HAN.REFERENCE) '+
                                'left join HAN as HAN1 using (KH_DOD.HAN, HAN1.REFERENCE) '+
                   'where OP.TYP=''NAL'' and OP.DO<=to_date(:_c) '+
                   'and SWAL.KOD='':_d'''+
                   {?:ODD<>'' || ' and ODD.OD='':_e''' || '' ?},TABK,:DAYOD, :DAYDO,:WAL,:ODD);
       {? var_pres('tabtmp')>100
       || OP.cntx_psh(); ZAP_OP.cntx_psh();
          OP.use('operac'+kod); ZAP_OP.use('rozzap'+kod); OP.clear(); ZAP_OP.clear();
          data1:=:DAYOD; data2:=:DAYDO;
          tabtmp.for_each("{? OP.seek(BB.sqlint(tabtmp.REF),OP.name())
                           || F.RObr4(OP.ref, kod, data1, data2);
                              tabtmp.NALPOW:=F.rwn; tabtmp.SPLPRZ:=F.rma;
                              tabtmp.NALPO:={? F.rtwn-F.rtma>0 & OP.TZ<data2 || F.rtwn - F.rtma || 0 ?};
                              {? tabtmp.NALPOW=0 & tabtmp.SPLPRZ=0 & tabtmp.NALPO=0
                              || tabtmp.del()
                              || tabtmp.put()
                              ?}
                           || tabtmp.del()
                           ?}",1);
         OP.cntx_pop(); ZAP_OP.cntx_pop()
       ?}
    ?}
 ?}
end formula

sql
select ODD.OD, KH.KOD, KH.SKR, KH.NAZ, OP.AN, OP.SYM, OP.TZ, OP.DO, OP.WN as NALPOW, OP.MA as SPLPRZ,
       OP.REFERENCE as REF, KH.REFERENCE as KHREF, HAN.KOD as HKOD, HAN.NAZ as HNAZ, HAN.ADR as ADR,
       HAN.TEL, HAN.EMAIL, cast(null as real_type) as NALPO,
       HAN1.KOD as H1KOD, HAN1.NAZ as H1NAZ, HAN1.ADR as H1ADR, HAN1.TEL as H1TEL, HAN1.EMAIL as H1EMAIL
from OP
join KH
left join KH_DOD using (KH_DOD.KH, KH.REFERENCE)
left join ODD
left join HAN using (OP.HAN, HAN.REFERENCE)
left join HAN as HAN1 using (KH_DOD.HAN, HAN1.REFERENCE)
where OP.REFERENCE is null
end sql

formula
 {? var_pres('tabtmp')>100 & tabtmp.first()
 || {!|? {! _i:=1..24 |! :RS[_i]:=tabtmp[_i] !};
         {? :RS[13]='' & :RS[19]<>''
         || :RS[13]:=:RS[19];
            :RS[14]:=:RS[20];
            :RS[15]:=:RS[21];
            :RS[16]:=:RS[22];
            :RS[17]:=:RS[23]
         ?};
         :RS.add(); tabtmp.next() !}
 ?};
 VAR_DEL.delete('tabtmp','tabtmpkh','TABK','data1','data2')
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 58bf49f71f1cec790bd42a9c83cc40e6c933c0789741b4898c31df6615322e6942605832493adfc657d429f8fa2e08b5e87afd8efb83d40dd942a5151f1cec7a02cb209681f5d08fcddbdd9b93d70e8a6285a27611e7382aa8a83a9ed5f115a4f8267569be5baef3e41299ff1654cd15dd24cc48ae2611af3ee7a55d198b35a2
