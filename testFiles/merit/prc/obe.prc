:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: obe.prc
# Utworzony: 06.07.2016
# Autor: PJ
#========================================================================================================================
# Zawartosc: Procedury pomocniczne do wydruków delegacji
#========================================================================================================================

proc edk_atr_sel
desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: WW [12.30]
:: OPIS: Zwraca liste atrybutow EDOKUM lub DOKUM
::   WY: tabela tymczasowa z zawartoscia atrybutow danego dokumentu w obiegu
::----------------------------------------------------------------------------------------------------------------------
end desc
params
   edokum:='' String[16], wskazanie na dokument w obiegu lub kontakt
   rodz:=0 Integer, rodzaj dokumentu (w obiegu- 1, kontaktu-2)
   ed_msk:='' String[8],
   ed_msk1:='' String[8]
end params
formula
:ed_msk:=8+:edokum;
:ed_msk1:='edokat'+(:ed_msk+2)
end formula

sql
   select
      /*+MASK_FILTER(EDOKUM,:ed_msk)  MASK_FILTER(EDOK_ATR,:ed_msk1)  */
      EDOK_ATR.REKORD as REKORD,
      EDOK_ATR.KOL as KOLUMNA,
      TAT.NR as TAT_NR,
      TAT.NA as TAT_NA,
      TAT.OPIS as TAT_OPIS,
      TAT.REFERENCE as TAT_REF,
      TAT.SLU as TAT_SLU,
      TAT.UD_SCH as TATUDSCH,
      TAT.TYP as TYP,
      EDOK_ATR.WAR as WARTOSC,
      SLO.KOD as SIL_KOD,
      SLO.TR as SLO_TR,
      CASE WHEN TAT.TYP='X' THEN EDOK_ATR.REF_SQL ELSE SLO.REFERENCE END as SLO_REF,
      UD_SKL.SYMBOL as UD_SYMBOL,
      UD_SKL.OPIS as UD_OPIS,
      UD_SKL.REFERENCE as UD_REF,
      EDOKUM.TYP as ETYP_REF,
      DOKUM.DOT as ZDARZ_REF,
      'N' as WYMAGANE,
      'D' as CZY_ZERO,
      'K' as SLOPOLE,
      EDOK_ATR.REFERENCE as REF,
      'T' as EDITABLE,
      'N' as F_AE,
      '                ' as TATR_REF,
      0 PREC,
      'T' TSEP
   from
      EDOK_ATR
      left join TAT using (EDOK_ATR.TAT, TAT.REFERENCE)
      left join SLO using (EDOK_ATR.SLO ,SLO.REFERENCE)
      left join UD_SKL using (EDOK_ATR.UD_SKL, UD_SKL.REFERENCE)
      left join EDOKUM using (EDOK_ATR.EDOKUM, EDOKUM.REFERENCE)
      left join DOKUM using (EDOK_ATR.DOKUM, DOKUM.REFERENCE)
   where
      EDOK_ATR.EDOKUM=:edokum or EDOK_ATR.DOKUM=:edokum
   order by 1,2
end sql
formula
   {? :RS.first()
   ||
      {? (5+:edokum)='dokum'
      || OBIEGI.TYP_ID:='K';
         _tab:=ZDARZT
      || OBIEGI.TYP_ID:='T';
         _tab:=ETYPY
      ?};
      _tab.cntx_psh();  _tab.prefix();
      _ref:={? OBIEGI.TYP_ID='K' || BB.sqlint(:RS.ZDARZ_REF) || BB.sqlint(:RS.ETYP_REF) ?};
      {? (_ref>0) & _tab.seek(_ref,)
      ||
         {!
         |?
            _kolum:=:RS.KOLUMNA;
            {? _kolum<>0
            ||
               :RS.WYMAGANE:={? exec('get_atr_wym','obiegi2',_tab.ref(),_kolum) || 'T' || 'N' ?};
               :RS.SLOPOLE:=exec('get_atr_slopol','obiegi',_tab.ref(),_kolum);
               :RS.put()
            ?};
            {? :RS.TYP='O'
            || :RS.WARTOSC:=exec('get_atr_opis','obiegi',_tab.ref(),_kolum)
            |? :RS.TYP='L' ||
               :RS.WARTOSC:=STR.gsub(STR.gsub(:RS.WARTOSC,' ',''),',','.');
               :RS.CZY_ZERO:={? exec('get_atr_cz','obiegi',_tab.ref(),_kolum) || 'D' || 'P' ?};
               :RS.PREC:=exec('get_atr_prec','obiegi',_tab.ref(),_kolum);
               :RS.TSEP:=form(exec('get_atr_tsep','obiegi',_tab.ref(),_kolum))
            ?};
            :RS.EDITABLE:=exec('get_atr_edit','obiegi',_tab.ref(),_kolum);
            :RS.F_AE:={? |exec('get_atr_form','obiegi',_tab.ref(),_kolum,'AE')<>'' || 'T' || 'N' ?};
            :RS.TATR_REF:=$exec('get_atr_ref','obiegi',_tab.ref(),_kolum);
            :RS.put;
            :RS.next()
         !}
      ?};
      _tab.cntx_pop()
   ?}
end formula
end proc

#Sign Version 2.0 jowisz:1045 2023/10/13 12:52:45 92e9dd47f621c418ba837b5b344314ef4a5088c221e9dde5920a56958bb68c33e334cd1b709a52b4ac21d736bd3d004a5aa053681d058ffdf40e7bead5a2082b6fba5b65849dcb4492d05c14354cf8b680e1e9b5ff9dcfb34769219712450b9bc779a5e6b9705470ee262d213e728b5e1e060458cc1c8ddc4114726889c4ded7
