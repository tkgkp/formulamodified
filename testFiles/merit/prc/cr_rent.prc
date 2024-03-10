:!UTF-8
proc cr_rent

desc
   Procedura dla zestawienia rentownosci na podstawie wyroznikow (CR)
end desc

params
   ROK STRING[20], Nazwa roku
   OKR_OD INTEGER, Od okresu
   OKR_DO INTEGER, Do okresu
   WYR STRING[20], Nazwa słownika
   TYT STRING[50], Tytuł wydruku
   ODD STRING[8], Jednostka księgowa
   PSCH INTEGER, Schemat kont przychodowych
   KSCH INTEGER, Schemat kont kosztowych
   ROKR_ODD STRING[8], REFERENCE okresu od dla tabeli DOK
   ROKR_DOD STRING[8], REFERENCE okresu do dla tabeli DOK
   ROKR_ODP STRING[8], REFERENCE okresu od dla tabeli POZ
   ROKR_DOP STRING[8], REFERENCE okresu do dla tabeli POZ
   ROKR_ODW STRING[8], REFERENCE okresu od dla tabeli POW
   ROKR_DOW STRING[8], REFERENCE okresu do dla tabeli POW
   ILE INTEGER, Ile najlepszych
   SORT INTEGER, Sortowanie
   PSCHN STRING[8], Kod schematu kont przychodowych
   KSCHN STRING[8], Kod schematu kont kosztowych
   SORTO INTEGER, Porządek sortowania
end params

formula
   ROK_F.cntx_psh(); ROK_F.index('NAZWA'); ROK_F.prefix(REF.FIRMA,:ROK);
   {? ROK_F.first() & ROK_F.NAZ=:ROK
   || OKRO_F.cntx_psh(); OKRO_F.index('ROK'); OKRO_F.prefix(ROK_F.ref());
      {? OKRO_F.find_key(:OKR_OD)
      || :ROKR_ODD:='doku'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2);
         :ROKR_ODP:='pozy'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2);
         :ROKR_ODW:='pow_'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)
      ?};
      {? OKRO_F.find_key(:OKR_DO)
      || :ROKR_DOD:='doku'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)+'z';
         :ROKR_DOP:='pozy'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)+'z';
         :ROKR_DOW:='pow_'+OKRO_F.ROK().KOD+form(OKRO_F.NR,-2)+'z'
      ?};
      OKRO_F.cntx_pop();
      {? :ODD='' || :ODD:='%' ?}
   ?};
   ROK_F.cntx_pop()
end formula

sql
   select POW.KW, SLO.KOD, SLO.TR, SLU.NAZ as SLUNAZ, ODD.OD || ' / ' || REJ.KOD as REJNAZ,
      DOK_REJ.NAZ as DREJNAZ, DOK.NK, POZ.POZ, POZ.KON, POZ.STR, DOK.DTW, DOK.ZP, DOK.NR,
      cast(0 as real_type) as P, cast(0 as real_type) as K, cast(0 as real_type) as Z,
      cast(0 as real_type) as R, cast(0 as real_type) as S
   from POW
      join SLO using (POW.SLO,SLO.REFERENCE)
      join SLU using (SLO.SLU,SLU.REFERENCE)
      join POZ using (POW.POZ,POZ.REFERENCE)
      join DOK using (POZ.DOK,DOK.REFERENCE)
      join DOK_REJ using (DOK.DOK_REJ,DOK_REJ.REFERENCE)
      join REJ using (DOK_REJ.REJ,REJ.REFERENCE)
      join ODD using (DOK.ODD,ODD.REFERENCE)
   where DOK.REFERENCE between :ROKR_ODD and :ROKR_DOD
      and POZ.REFERENCE between :ROKR_ODP and :ROKR_DOP
      and POW.REFERENCE between :ROKR_ODW and :ROKR_DOW
      and SLU.NAZ=:WYR
      and ODD.OD like :ODD
      and DOK.ZP='T'
end sql

formula
   ROK_F.cntx_psh(); ROK_F.index('NAZWA'); ROK_F.prefix(REF.FIRMA,:ROK);
   exec('czytaj','#stalesys',,FINFO);
   {? :RS.first() & ROK_F.first() & ROK_F.NAZ=:ROK
   || KON_WYDR.prefix(); KON_SCH.index('IND_SCH');
      {? KON_WYDR.seek(:PSCH,KON_WYDR.name())
      || KON_SCH.prefix(KON_WYDR.ref());
         {? KON_SCH.first()
         || _ssqlb:='select AN.SYM,\'P\' as RODZ from @AN join SLO using(AN.WAL,SLO.REFERENCE) where SLO.KOD=\':_a\' '
               +'and AN.REFERENCE like \':_b%\' and ';
            _ssql:='';
            {! |?
               _ssql+='union all '+_ssqlb+
                  {? KON_SCH.MZ='M'
                  || 'AN.SYM like \''+STR.gsub(KON_SCH.MASKA,'?','_')+'\''
                  || 'AN.SYM between \''+STR.gsub(KON_SCH.ZOD,'?','_')+'\' and \'' +STR.gsub(KON_SCH.ZDO+'z','?','_')+'\''
                  ?};
               KON_SCH.next()
            !}
         ?};
         _ssql:=10-_ssql
      ?};
      {? KON_WYDR.seek(:KSCH,KON_WYDR.name())
      || KON_SCH.prefix(KON_WYDR.ref());
         {? KON_SCH.first()
         || _ssqlb:='select AN.SYM,\'K\' as RODZ from @AN join SLO using(AN.WAL,SLO.REFERENCE) where SLO.KOD=\':_a\' '
               +'and AN.REFERENCE like \':_b%\' and ';
            {! |?
               _ssql+='union all '+_ssqlb+
                  {? KON_SCH.MZ='M'
                  || 'AN.SYM like \''+STR.gsub(KON_SCH.MASKA,'?','_')+'\''
                  || 'AN.SYM between \''+STR.gsub(KON_SCH.ZOD,'?','_')+'\' and \'' +STR.gsub(KON_SCH.ZDO+'z','?','_')+'\''
                  ?};
               KON_SCH.next()
            !}
         ?}
      ?};
      TT_AN:=sql(_ssql+' order by 1',FINFO.NAROD().KOD,'koan__'+ROK_F.KOD);
      {! |?
         {? TT_AN.find_key(:RS.KON)
         || {? TT_AN.RODZ='P'
            || :RS.P:={? :RS.STR='Ma' || :RS.KW || -:RS.KW ?}
            || :RS.K:={? :RS.STR='Wn' || :RS.KW || -:RS.KW ?}
            ?};
            :RS.Z:=:RS.P-:RS.K; :RS.R:={? :RS.K || :RS.Z/:RS.K || 0 ?}; :RS.put(); :RS.next()
         || :RS.del()
         ?}
      !};
      obj_del(TT_AN);
      {? :SORT<>1
      || TT_RS:=tab_tmp(1,'KOD','STRING[8]',,'W','REAL',,'K','INTEGER',);
         _vf:={? :SORT=2 || 'P' |? :SORT=3 || 'K' |? :SORT=4 || 'Z' || 'R' ?};
         _ind:=:RS.ndx_tmp(,1,'KOD',,,_vf,,); :RS.index(_ind);
         SLU.index('NAZ'); SLO.index('SL'); SLU.prefix(:WYR);
         {? SLU.first()
         || {! |?
               {? SLU.NAZ=:WYR
               || SLO.prefix(SLU.ref());
                  {? SLO.first()
                  || _vs:=SLO.size();
                     {! |?
                        :RS.prefix(SLO.KOD);
                        {? :RS.first()
                        || TT_RS.KOD:=SLO.KOD;
                           TT_RS.K:=0;
                           _w:=_p:=_k:=0;
                           {! |?
                              _w+={? :SORT=2 || :RS.P |? :SORT=3 || :RS.K |? :SORT=4 || :RS.Z || :RS.R ?};
                              {? :SORT=5 || _p+=:RS.P; _k+=:RS.K ?};
                              :RS.next()
                           !};
                           {? :SORT=5 || _w:={? _k || (_p-_k)/_k || 0 ?} ?};
                           TT_RS.W:=_w;
                           TT_RS.add()
                        ?};
                        SLO.next()
                     !}
                  ?}
               ?};
               SLU.next()
            !};
            _ind1:=TT_RS.index('?');
            _ind2:=TT_RS.ndx_tmp(,1,'W',,{? :SORTO=1 || 1 || 0 ?}); TT_RS.index(_ind2); TT_RS.prefix();
            {? TT_RS.first()
            || _i:=_w:=0;
               {! |? (~:ILE | _i<:ILE | (:ILE & TT_RS.W=_w)) & _i<TT_RS.size() |!
                  _i+=1; {? _i=:ILE || _w:=TT_RS.W ?};
                  TT_RS.K:=_i; TT_RS.put();
                  TT_RS.next()
               !}
            ?};
            :RS.prefix(); TT_RS.index(_ind1); TT_RS.prefix();
            {? :RS.first()
            || {! |?
                  TT_RS.prefix(:RS.KOD);
                  {? TT_RS.first() & ~TT_RS.K || :RS.del() || :RS.next() ?}
               !}
            ?}
         ?};
         {? :RS.first()
         || {! |?
               TT_RS.prefix(:RS.KOD);
               {? TT_RS.first() || :RS.S:=TT_RS.K; :RS.put() ?}; :RS.next()
            !}
         ?};
         VAR_DEL.delete('TT_RS')
      ?}
   ?};
   ROK_F.cntx_pop()
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 5766cfe7c2fd483662d0730729ef619f1c2190546dd18e029e69f7075b28dd02ae5a970e3c89328b0f58392cefc37cbd7977c5a5c18384866ba35aa06bd1d074f99fb865d8339e3d71fa98ac5b422876b99516fdf9c5173514f0b57477622b034e267e73e114f1122e09c88eb5db6404353b59c641a86bdeefe6e6fe901514e2
