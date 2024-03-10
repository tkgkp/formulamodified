:!UTF-8
proc cr_konta

desc
   Procedura dla zestawienia obrotow kont (CR)
end desc

params
   ROK STRING[20], Nazwa roku
   SEP STRING[1], Separator konta
   SYNT INTEGER, Długość syntetyki
   WAL STRING[3], Kod waluty
   ODD STRING[8], Jednostka księgowa
   MASKA STRING[35], Maska
   OKR_OD INTEGER, Od okresu
   OKR_DO INTEGER, Do okresu
   ROKR_ODD STRING[8], REFERENCE okresu od dla tabeli DOK
   ROKR_DOD STRING[8], REFERENCE okresu do dla tabeli DOK
   ROKR_ODP STRING[8], REFERENCE okresu od dla tabeli POZ
   ROKR_DOP STRING[8], REFERENCE okresu do dla tabeli POZ
   TYT STRING[50], Tytuł zestawienia
end params

formula
   exec('czytaj','#stalesys',,FINFO);
   ROK_F.cntx_psh(); ROK_F.index('NAZWA'); ROK_F.prefix(REF.FIRMA,:ROK);
   {? ROK_F.first() & ROK_F.NAZ=:ROK
   || OKRO_F.cntx_psh();
      OKRO_F.index('ROK'); OKRO_F.prefix(ROK_F.ref());
      {? OKRO_F.find_key(:OKR_OD)
      || :ROKR_ODD:='doku'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2);
         :ROKR_ODP:='pozy'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)
      ?};
      {? OKRO_F.find_key(:OKR_DO)
      || :ROKR_DOD:='doku'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)+'z';
         :ROKR_DOP:='pozy'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)+'z'
      ?};
      OKRO_F.cntx_pop();
      {? :ODD='' || :ODD:='%' ?};
      {? :WAL=FINFO.NAROD().KOD || :WAL:='' ?};
      {! |? (:MASKA+1)='?' |! :MASKA:=:MASKA-1 !};
      :MASKA:=STR.gsub(:MASKA,'?','_');
      :MASKA+='%'
   ?};
   ROK_F.cntx_pop()
end formula

sql
select DOK.DTW, REJ.KOD, DOK.NR, DOK.TR, POZ.POZ, POZ.KON, ODD.OD,
   case POZ.STR when 'Wn' then POZ.SUM end as WN,
   case POZ.STR when 'Wn' then POZ.SUMW end as WWN,
   case POZ.STR when 'Ma' then POZ.SUM end as MA,
   case POZ.STR when 'Ma' then POZ.SUMW end as WMA,
   '                                                            ' as OPIS0,
   '                                                            ' as OPIS1,
   '                                                            ' as OPIS2,
   '                                                            ' as OPIS3,
   '                                                            ' as OPIS4,
   '                                                            ' as OPIS5,
   '                                                            ' as OPIS6,
   '                                                            ' as OPIS7,
   '                                                            ' as OPIS8,
   '                                                            ' as OPIS9,
   '                                                            ' as OPIS10
   from @POZ join @DOK using (POZ.DOK,DOK.REFERENCE) join REJ using(DOK.REJ,REJ.REFERENCE) join ODD using (DOK.ODD,ODD.REFERENCE) left join SLO using (POZ.WAL,SLO.REFERENCE)
   where DOK.ZP='T' and
      DOK.REFERENCE between :ROKR_ODD and :ROKR_DOD and
      POZ.REFERENCE between :ROKR_ODP and :ROKR_DOP and ODD.OD like :ODD
      and POZ.KON like :MASKA
      and case when :WAL='' then :WAL else SLO.KOD end =:WAL
end sql

formula
   ROK_F.cntx_psh(); ROK_F.index('NAZWA'); ROK_F.prefix(REF.FIRMA,:ROK);
   _ar:=SSTALE.AR; _ao:=SSTALE.AO; _arok:=BILANSP.AROK; _asep:=BILANSP.ASEP; _asynt:=BILANSP.ASYNT;
   {? :RS.first() & ROK_F.first() & ROK_F.NAZ=:ROK
   || AN.cntx_psh(); AN.use('koan__'+ROK_F.KOD); AN.prefix();
      OKRO_F.cntx_psh(); OKRO_F.index('ROK'); OKRO_F.prefix(ROK_F.ref());
      {? OKRO_F.first()
      || SSTALE.AR:=ROK_F.ref(); SSTALE.AO:=OKRO_F.ref();
         BILANSP.AROK:=ROK_F.ref();
         BILANSP.ASEP:=ROK_F.SEP;
         BILANSP.ASYNT:=ROK_F.SYNT;
         {! |?
            {? :WAL<>'' || :RS.WN:=:RS.WWN; :RS.MA:=:RS.WMA ?};
            :RS.OPIS0:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),-1,1);
            :RS.OPIS1:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),1,1);
            :RS.OPIS2:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),2,1);
            :RS.OPIS3:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),3,1);
            :RS.OPIS4:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),4,1);
            :RS.OPIS5:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),5,1);
            :RS.OPIS6:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),6,1);
            :RS.OPIS7:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),7,1);
            :RS.OPIS8:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),8,1);
            :RS.OPIS9:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),9,1);
            :RS.OPIS10:=exec('op_konta','dok_fks_zest',:RS.KON,ROK_F.ref(),10,1);
            :RS.put(); :RS.next()
         !}
      ?};
      OKRO_F.cntx_pop(); AN.cntx_pop()
   ?};
   SSTALE.AR:=_ar; SSTALE.AO:=_ao; BILANSP.AROK:=_arok; BILANSP.ASEP:=_asep; BILANSP.ASYNT:=_asynt;
   ROK_F.cntx_pop()
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:36 ddadcd94d8e3a76dad7e4da6e0e2903f22254b00b24a2b66d89210e81d02e81c5dad3e463f97c3a01ded5f4cc4eb07a8f66c2bc2101b94f6d8e27ef5b8984a151c4f6119a4d75f16a92efa8a00cd7a5fd46c7305c104bd6f6fb56a8ad266fd32d840fee5ddd694e29822e2d1faaa328e9e9709c1872a9f2ec7542701afdd6ca0
