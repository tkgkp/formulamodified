:!UTF-8
qzaku_005@1@Kod kontrahenta@S@20@
qzaku_005@1@@
qzaku_005@1@@
qzaku_005@1@@
qzaku_005@1@@
qzaku_005@1@KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.KOD || '' ?}@
qzaku_005@1@@
qzaku_005@2@Nazwa kontrahenta@S@20@
qzaku_005@2@@
qzaku_005@2@@
qzaku_005@2@@
qzaku_005@2@@
qzaku_005@2@@
qzaku_005@2@@
qzaku_005@3@Miasto kontrahenta@S@20@
qzaku_005@3@@
qzaku_005@3@@
qzaku_005@3@@
qzaku_005@3@@
qzaku_005@3@@
qzaku_005@3@@
qzaku_005@4@Ulica kontrahenta@S@20@
qzaku_005@4@@
qzaku_005@4@@
qzaku_005@4@@
qzaku_005@4@@
qzaku_005@4@@
qzaku_005@4@@
qzaku_005@5@NIP kontrahenta@S@20@
qzaku_005@5@@
qzaku_005@5@@
qzaku_005@5@@
qzaku_005@5@@
qzaku_005@5@@
qzaku_005@5@@
qzaku_005@6@Oddział@F@0@
qzaku_005@6@@
qzaku_005@6@ST.ODDZ@
qzaku_005@6@@
qzaku_005@6@@
qzaku_005@6@@
qzaku_005@6@@
qzaku_005@7@Od daty@D@0@
qzaku_005@7@@
qzaku_005@7@@
qzaku_005@7@@
qzaku_005@7@@
qzaku_005@7@@
qzaku_005@7@@
qzaku_005@8@Do daty@D@0@
qzaku_005@8@@
qzaku_005@8@@
qzaku_005@8@@
qzaku_005@8@@
qzaku_005@8@@
qzaku_005@8@@
qzaku_005@9@Dla Indeksu@S@20@
qzaku_005@9@@
qzaku_005@9@@
qzaku_005@9@@
qzaku_005@9@@
qzaku_005@9@M.index('NAZ'); M.prefix(''); M.win_sel('NL_WER'); {? M.select() || M.KTM || '' ?}@
qzaku_005@9@@
qzaku_005@10@Uprawnione STZ@F@0@
qzaku_005@10@@
qzaku_005@10@exec('stss','users',OPERATOR.USER,'STZ')@
qzaku_005@10@@
qzaku_005@10@@
qzaku_005@10@@
qzaku_005@10@@
zd_nuco10@1@Od dnia@D@0@
zd_nuco10@1@@
zd_nuco10@1@date()-5@
zd_nuco10@1@@
zd_nuco10@1@@
zd_nuco10@1@@
zd_nuco10@1@@
zd_nuco10@2@Do dnia@D@0@
zd_nuco10@2@@
zd_nuco10@2@date()+5@
zd_nuco10@2@@
zd_nuco10@2@@
zd_nuco10@2@@
zd_nuco10@2@@
zd_nuco2@1@Od dnia@D@0@
zd_nuco2@1@@
zd_nuco2@1@date()-5@
zd_nuco2@1@@
zd_nuco2@1@@
zd_nuco2@1@@
zd_nuco2@1@@
zd_nuco2@2@Do dnia@D@0@
zd_nuco2@2@@
zd_nuco2@2@date()+5@
zd_nuco2@2@@
zd_nuco2@2@@
zd_nuco2@2@@
zd_nuco2@2@@
zd_nuco3@1@Od dnia@D@0@
zd_nuco3@1@@
zd_nuco3@1@date()-5@
zd_nuco3@1@@
zd_nuco3@1@@
zd_nuco3@1@@
zd_nuco3@1@{? fld()<>date(0,0,0) || od_daty:=fld();1 ?}@
zd_nuco3@2@Do dnia@D@0@
zd_nuco3@2@@
zd_nuco3@2@do_daty:=date()+5@
zd_nuco3@2@@
zd_nuco3@2@@
zd_nuco3@2@@
zd_nuco3@2@{? fld()<>date(0,0,0) || do_daty:=fld();1 ?}@
zd_nuco3@3@tabelka@F@0@
zd_nuco3@3@@
zd_nuco3@3@exec('zd_nuco3','qsql',od_daty,do_daty)@
zd_nuco3@3@@
zd_nuco3@3@@
zd_nuco3@3@@
zd_nuco3@3@@
zd_nuco4@1@Od dnia@D@0@
zd_nuco4@1@@
zd_nuco4@1@date()-5@
zd_nuco4@1@@
zd_nuco4@1@@
zd_nuco4@1@@
zd_nuco4@1@{? fld()<>date(0,0,0) || od_daty:=fld();1 ?}@
zd_nuco4@2@Do dnia@D@0@
zd_nuco4@2@@
zd_nuco4@2@do_daty:=date()+5@
zd_nuco4@2@@
zd_nuco4@2@@
zd_nuco4@2@@
zd_nuco4@2@{? fld()<>date(0,0,0) || do_daty:=fld();1 ?}@
zd_nuco4@3@tabelka@F@0@
zd_nuco4@3@@
zd_nuco4@3@exec('zd_nuco4','qsql',od_daty,do_daty)@
zd_nuco4@3@@
zd_nuco4@3@@
zd_nuco4@3@@
zd_nuco4@3@@
zd_nuco6@1@KTM@S@20@
zd_nuco6@1@@
zd_nuco6@1@''@
zd_nuco6@1@@
zd_nuco6@1@@
zd_nuco6@1@@
zd_nuco6@1@@
zd_nuco7@1@KTM@S@20@
zd_nuco7@1@@
zd_nuco7@1@@
zd_nuco7@1@@
zd_nuco7@1@@
zd_nuco7@1@@
zd_nuco7@1@@
zd_nuco7@2@STAN@S@1@
zd_nuco7@2@@
zd_nuco7@2@'*'@
zd_nuco7@2@@
zd_nuco7@2@@
zd_nuco7@2@@
zd_nuco7@2@@
zd_nuco8@1@Data zamówienia od@D@0@
zd_nuco8@1@@
zd_nuco8@1@date(ST.AR, ST.AM,1)@
zd_nuco8@1@@
zd_nuco8@1@@
zd_nuco8@1@@
zd_nuco8@1@@
zd_nuco8@2@Data zamówienia do@D@0@
zd_nuco8@2@@
zd_nuco8@2@date(ST.AR, ST.AM, 0)@
zd_nuco8@2@@
zd_nuco8@2@@
zd_nuco8@2@@
zd_nuco8@2@@
zd_nuco8@3@Dostawca (kontrahent)@S@0@
zd_nuco8@3@@
zd_nuco8@3@exec('no_limit','sql')@
zd_nuco8@3@@
zd_nuco8@3@@
zd_nuco8@3@exec('kh','sql')@
zd_nuco8@3@exec('f3_only','sql')@
zd_nuco9@1@Od daty@D@0@
zd_nuco9@1@@
zd_nuco9@1@date()@
zd_nuco9@1@@
zd_nuco9@1@@
zd_nuco9@1@@
zd_nuco9@1@@
zd_nuco9@2@Do daty@D@0@
zd_nuco9@2@@
zd_nuco9@2@date()+30@
zd_nuco9@2@@
zd_nuco9@2@@
zd_nuco9@2@@
zd_nuco9@2@@
zd_nuco9@3@Symbol zamóienia@S@20@
zd_nuco9@3@@
zd_nuco9@3@''@
zd_nuco9@3@@
zd_nuco9@3@@
zd_nuco9@3@@
zd_nuco9@3@@
