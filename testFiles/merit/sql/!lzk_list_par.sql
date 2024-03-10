:!UTF-8
zaku_001@1@Kod kontrahenta@S@8@
zaku_001@1@@
zaku_001@1@@
zaku_001@1@@
zaku_001@1@@
zaku_001@1@_akt:=fld();KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.KOD || _akt ?}@
zaku_001@1@@
zaku_001@2@Bieżący oddział@F@0@
zaku_001@2@@
zaku_001@2@ST.ODDZ@
zaku_001@2@@
zaku_001@2@@
zaku_001@2@@
zaku_001@2@@
zaku_001@3@Od daty@D@0@
zaku_001@3@@
zaku_001@3@date(ST.AR,ST.AM,1)@
zaku_001@3@@
zaku_001@3@@
zaku_001@3@@
zaku_001@3@@
zaku_001@4@Do daty@D@0@
zaku_001@4@@
zaku_001@4@date(ST.AR,ST.AM,0)@
zaku_001@4@@
zaku_001@4@@
zaku_001@4@@
zaku_001@4@@
zaku_001@5@Uprawinone STZ@F@0@
zaku_001@5@@
zaku_001@5@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_001@5@@
zaku_001@5@@
zaku_001@5@@
zaku_001@5@@
zaku_002@1@Symbol@S@20@
zaku_002@1@@
zaku_002@1@@
zaku_002@1@@
zaku_002@1@@
zaku_002@1@@
zaku_002@1@@
zaku_002@2@Bieżący oddział@F@0@
zaku_002@2@@
zaku_002@2@ST.ODDZ@
zaku_002@2@@
zaku_002@2@@
zaku_002@2@@
zaku_002@2@@
zaku_002@3@Od daty@D@0@
zaku_002@3@@
zaku_002@3@date(ST.AR,ST.AM,1)@
zaku_002@3@@
zaku_002@3@@
zaku_002@3@@
zaku_002@3@@
zaku_002@4@Do daty@D@0@
zaku_002@4@@
zaku_002@4@date(ST.AR,ST.AM,0)@
zaku_002@4@@
zaku_002@4@@
zaku_002@4@@
zaku_002@4@@
zaku_002@5@Uprawnione STZ@F@0@
zaku_002@5@@
zaku_002@5@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_002@5@@
zaku_002@5@@
zaku_002@5@@
zaku_002@5@@
zaku_003@1@PKWiU@S@20@
zaku_003@1@@
zaku_003@1@@
zaku_003@1@@
zaku_003@1@@
zaku_003@1@@
zaku_003@1@@
zaku_003@2@Bieżący oddział@F@0@
zaku_003@2@@
zaku_003@2@ST.ODDZ@
zaku_003@2@@
zaku_003@2@@
zaku_003@2@@
zaku_003@2@@
zaku_003@3@Od daty@D@0@
zaku_003@3@@
zaku_003@3@date(ST.AR,ST.AM,1)@
zaku_003@3@@
zaku_003@3@@
zaku_003@3@@
zaku_003@3@@
zaku_003@4@Do daty@D@0@
zaku_003@4@@
zaku_003@4@date(ST.AR,ST.AM,0)@
zaku_003@4@@
zaku_003@4@@
zaku_003@4@@
zaku_003@4@@
zaku_003@5@Uprawnione STZ@F@0@
zaku_003@5@@
zaku_003@5@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_003@5@@
zaku_003@5@@
zaku_003@5@@
zaku_003@5@@
zaku_003@6@Materiał@F@0@
zaku_003@6@@
zaku_003@6@exec('m_pkwiu','sql')@
zaku_003@6@@
zaku_003@6@@
zaku_003@6@@
zaku_003@6@@
zaku_003@7@_fo300201@F@0@
zaku_003@7@@
zaku_003@7@exec('get','#params',300201,2)@
zaku_003@7@@
zaku_003@7@@
zaku_003@7@@
zaku_003@7@@
zaku_004@1@Kod kontrahenta@S@20@
zaku_004@1@@
zaku_004@1@@
zaku_004@1@@
zaku_004@1@@
zaku_004@1@KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.KOD || '' ?}@
zaku_004@1@@
zaku_004@2@Bieżący oddział@F@0@
zaku_004@2@@
zaku_004@2@ST.ODDZ@
zaku_004@2@@
zaku_004@2@@
zaku_004@2@@
zaku_004@2@@
zaku_004@3@Od daty@D@0@
zaku_004@3@@
zaku_004@3@date(ST.AR,ST.AM,1)@
zaku_004@3@@
zaku_004@3@@
zaku_004@3@@
zaku_004@3@@
zaku_004@4@Do daty@D@0@
zaku_004@4@@
zaku_004@4@date(ST.AR,ST.AM,0)@
zaku_004@4@@
zaku_004@4@@
zaku_004@4@@
zaku_004@4@@
zaku_004@5@Uprawnione STZ@F@0@
zaku_004@5@@
zaku_004@5@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_004@5@@
zaku_004@5@@
zaku_004@5@@
zaku_004@5@@
zaku_005@1@Kod kontrahenta@S@20@
zaku_005@1@@
zaku_005@1@@
zaku_005@1@@
zaku_005@1@@
zaku_005@1@KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.KOD || '' ?}@
zaku_005@1@@
zaku_005@2@Nazwa kontrahenta@S@20@
zaku_005@2@@
zaku_005@2@@
zaku_005@2@@
zaku_005@2@@
zaku_005@2@@
zaku_005@2@@
zaku_005@3@Miasto kontrahenta@S@20@
zaku_005@3@@
zaku_005@3@@
zaku_005@3@@
zaku_005@3@@
zaku_005@3@@
zaku_005@3@@
zaku_005@4@Ulica kontrahenta@S@20@
zaku_005@4@@
zaku_005@4@@
zaku_005@4@@
zaku_005@4@@
zaku_005@4@@
zaku_005@4@@
zaku_005@5@NIP kontrahenta@S@20@
zaku_005@5@@
zaku_005@5@@
zaku_005@5@@
zaku_005@5@@
zaku_005@5@@
zaku_005@5@@
zaku_005@6@Oddział@F@0@
zaku_005@6@@
zaku_005@6@ST.ODDZ@
zaku_005@6@@
zaku_005@6@@
zaku_005@6@@
zaku_005@6@@
zaku_005@7@Od daty@D@0@
zaku_005@7@@
zaku_005@7@@
zaku_005@7@@
zaku_005@7@@
zaku_005@7@@
zaku_005@7@@
zaku_005@8@Do daty@D@0@
zaku_005@8@@
zaku_005@8@@
zaku_005@8@@
zaku_005@8@@
zaku_005@8@@
zaku_005@8@@
zaku_005@9@Dla Indeksu@S@20@
zaku_005@9@@
zaku_005@9@@
zaku_005@9@@
zaku_005@9@@
zaku_005@9@M.index('NAZ'); M.prefix(''); M.win_sel('NL_WER'); {? M.select() || M.KTM || '' ?}@
zaku_005@9@@
zaku_005@10@Uprawnione STZ@F@0@
zaku_005@10@@
zaku_005@10@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_005@10@@
zaku_005@10@@
zaku_005@10@@
zaku_005@10@@
zaku_006@1@Oddział@F@0@
zaku_006@1@@
zaku_006@1@ST.ODDZ@
zaku_006@1@@
zaku_006@1@@
zaku_006@1@@
zaku_006@1@@
zaku_006@2@Od daty wystawienia@D@0@
zaku_006@2@@
zaku_006@2@date(ST.AR,ST.AM,1)@
zaku_006@2@@
zaku_006@2@@
zaku_006@2@@
zaku_006@2@@
zaku_006@3@Do daty wystawienia@D@0@
zaku_006@3@@
zaku_006@3@date(ST.AR,ST.AM,0)@
zaku_006@3@@
zaku_006@3@@
zaku_006@3@@
zaku_006@3@@
zaku_006@4@Uprawnione STZ@F@0@
zaku_006@4@@
zaku_006@4@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_006@4@@
zaku_006@4@@
zaku_006@4@@
zaku_006@4@@
zaku_007@1@Oddział@F@0@
zaku_007@1@@
zaku_007@1@ST.ODDZ@
zaku_007@1@@
zaku_007@1@@
zaku_007@1@@
zaku_007@1@@
zaku_007@2@Od daty wystawienia@D@0@
zaku_007@2@@
zaku_007@2@date(ST.AR,ST.AM,1)@
zaku_007@2@@
zaku_007@2@@
zaku_007@2@@
zaku_007@2@@
zaku_007@3@Do daty wystawienia@D@0@
zaku_007@3@@
zaku_007@3@date(ST.AR,ST.AM,0)@
zaku_007@3@@
zaku_007@3@@
zaku_007@3@@
zaku_007@3@@
zaku_007@4@Uprawnione STZ@F@0@
zaku_007@4@@
zaku_007@4@exec('stss','users',OPERATOR.USER,'STZ')@
zaku_007@4@@
zaku_007@4@@
zaku_007@4@@
zaku_007@4@@
zaku_008@1@Oddział@F@0@
zaku_008@1@@
zaku_008@1@ST.ODDZ@
zaku_008@1@@
zaku_008@1@@
zaku_008@1@@
zaku_008@1@@
zaku_008@2@Od daty wystawienia@D@0@
zaku_008@2@@
zaku_008@2@date(ST.AR,ST.AM,1)@
zaku_008@2@@
zaku_008@2@@
zaku_008@2@@
zaku_008@2@@
zaku_008@3@Do daty wystawienia@D@0@
zaku_008@3@@
zaku_008@3@date(ST.AR,ST.AM,0)@
zaku_008@3@@
zaku_008@3@@
zaku_008@3@@
zaku_008@3@@
zaku_008@4@SQL@F@0@
zaku_008@4@@
zaku_008@4@exec('pob_dane','oplaty_zest',ST.ODDZ,'Z',PAR_SQL.PAR2D,PAR_SQL.PAR3D)@
zaku_008@4@@
zaku_008@4@@
zaku_008@4@@
zaku_008@4@@
zam_002@1@Od dnia@D@0@
zam_002@1@@
zam_002@1@date(ST.AR,ST.AM,1)@
zam_002@1@@
zam_002@1@@
zam_002@1@@
zam_002@1@@
zam_002@2@Do dnia@D@0@
zam_002@2@@
zam_002@2@date(ST.AR,ST.AM,0)@
zam_002@2@@
zam_002@2@@
zam_002@2@@
zam_002@2@@
zam_005@1@Od daty zamówienia@D@0@
zam_005@1@@
zam_005@1@date(ST.AR,ST.AM,1)@
zam_005@1@@
zam_005@1@@
zam_005@1@@
zam_005@1@@
zam_005@2@Do daty zamówienia@D@0@
zam_005@2@@
zam_005@2@date(ST.AR,ST.AM,0)@
zam_005@2@@
zam_005@2@@
zam_005@2@@
zam_005@2@@
zam_005@3@Oddział@S@50@
zam_005@3@@
zam_005@3@exec('no_limit','sql')@
zam_005@3@@
zam_005@3@@
zam_005@3@exec('oddz','sql','ZD_NAG.ODDZ')@
zam_005@3@exec('f3_only','sql')@
zam_005@4@Typ zamówienia@S@50@
zam_005@4@@
zam_005@4@exec('no_limit','sql')@
zam_005@4@@
zam_005@4@@
zam_005@4@exec('typyzam','sql','D')@
zam_005@4@exec('f3_only','sql')@
zam_005@5@Grupa kontrahentów@S@50@
zam_005@5@@
zam_005@5@exec('no_limit','sql')@
zam_005@5@@
zam_005@5@@
zam_005@5@exec('grkh','sql')@
zam_005@5@exec('f3_only','sql')@
zam_005@6@Kontrahent@S@50@
zam_005@6@@
zam_005@6@exec('no_limit','sql')@
zam_005@6@@
zam_005@6@@
zam_005@6@exec('kh','sql')@
zam_005@6@exec('f3_only','sql')@
zam_005@7@Grupa towar./usług.@S@50@
zam_005@7@@
zam_005@7@exec('no_limit','sql')@
zam_005@7@@
zam_005@7@@
zam_005@7@exec('mgr','sql')@
zam_005@7@exec('f3_only','sql')@
zam_005@8@Towar/Usługa@S@50@
zam_005@8@@
zam_005@8@exec('no_limit','sql')@
zam_005@8@@
zam_005@8@@
zam_005@8@exec('tow','sql')@
zam_005@8@exec('f3_only','sql')@
zam_006@1@Od dnia@D@0@
zam_006@1@@
zam_006@1@date(ST.AR,ST.AM,1)@
zam_006@1@@
zam_006@1@@
zam_006@1@@
zam_006@1@@
zam_006@2@Do dnia@D@0@
zam_006@2@@
zam_006@2@date(ST.AR,ST.AM,0)@
zam_006@2@@
zam_006@2@@
zam_006@2@@
zam_006@2@@
