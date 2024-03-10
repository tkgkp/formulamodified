:!UTF-8
00001@1@Jednostka księgowa@S@8@
00001@1@@
00001@1@OPERATOR.DEPT().OD@
00001@1@@
00001@1@OPERATOR.DEPT=null@
00001@1@exec('sel_dept','sql')@
00001@1@exec('chk_dept','sql')@
00001@2@Rok@F@0@
00001@2@@
00001@2@exec('dok_br','!fks_dks_zzsl')@
00001@2@@
00001@2@@
00001@2@@
00001@2@@
00001@3@Rejestr@S@20@
00001@3@@
00001@3@'PK'@
00001@3@@
00001@3@@
00001@3@exec('f3_rejks','sql')@
00001@3@exec('ae_rejks','sql')@
00001@4@Od daty@D@0@
00001@4@@
00001@4@exec('get_date','okresy',SSTALE.AR,0)@
00001@4@@
00001@4@@
00001@4@@
00001@4@@
00001@5@Do daty@D@0@
00001@5@@
00001@5@exec('get_date','okresy',SSTALE.AR,1)@
00001@5@@
00001@5@@
00001@5@@
00001@5@@
00002@1@Jednostka księgowa@S@8@
00002@1@@
00002@1@OPERATOR.DEPT().OD@
00002@1@@
00002@1@OPERATOR.DEPT=null@
00002@1@exec('sel_dept','sql')@
00002@1@exec('chk_dept','sql')@
00002@2@Od konta@S@35@
00002@2@exec('wz_konto','edkonto','PAR_SQL','PAR2S')@
00002@2@@
00002@2@@
00002@2@exec('be_konto','edkonto','PAR_SQL','PAR2S')@
00002@2@exec('f3_konto','edkonto','PAR_SQL','PAR2S')@
00002@2@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR2S')@
00002@3@Do konta@S@35@
00002@3@exec('wz_konto','edkonto','PAR_SQL','PAR3S')@
00002@3@@
00002@3@@
00002@3@exec('be_konto','edkonto','PAR_SQL','PAR3S')@
00002@3@exec('f3_konto','edkonto','PAR_SQL','PAR3S')@
00002@3@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR3S')@
00003@1@Jednostka księgowa@S@8@
00003@1@@
00003@1@OPERATOR.DEPT().OD@
00003@1@@
00003@1@OPERATOR.DEPT=null@
00003@1@exec('sel_dept','sql')@
00003@1@exec('chk_dept','sql')@
00003@2@Rok@F@0@
00003@2@@
00003@2@exec('poz_br','!fks_dks_zzsl')@
00003@2@@
00003@2@@
00003@2@@
00003@2@@
00003@3@Rok@F@0@
00003@3@@
00003@3@exec('dok_br','!fks_dks_zzsl')@
00003@3@@
00003@3@@
00003@3@@
00003@3@@
00003@4@Od konta@S@35@
00003@4@exec('wz_konto','edkonto','PAR_SQL','PAR4S')@
00003@4@@
00003@4@@
00003@4@exec('be_konto','edkonto','PAR_SQL','PAR4S')@
00003@4@exec('f3_konto','edkonto','PAR_SQL','PAR4S')@
00003@4@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR4S')@
00003@5@Do konta@S@35@
00003@5@exec('wz_konto','edkonto','PAR_SQL','PAR5S')@
00003@5@@
00003@5@@
00003@5@exec('be_konto','edkonto','PAR_SQL','PAR5S')@
00003@5@exec('f3_konto','edkonto','PAR_SQL','PAR5S')@
00003@5@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR5S')@
00004@1@Jednostka księgowa@S@8@
00004@1@@
00004@1@OPERATOR.DEPT().OD@
00004@1@@
00004@1@OPERATOR.DEPT=null@
00004@1@exec('sel_dept','sql')@
00004@1@exec('chk_dept','sql')@
00004@2@Maska konta@S@35@
00004@2@exec('wz_konto','edkonto','PAR_SQL','PAR2S')@
00004@2@'%'@
00004@2@@
00004@2@exec('be_konto','edkonto','PAR_SQL','PAR2S')@
00004@2@exec('f3_konto','edkonto','PAR_SQL','PAR2S')@
00004@2@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR2S')@
00005@1@Rok@F@0@
00005@1@@
00005@1@exec('rok_spr','sql')@
00005@1@@
00005@1@@
00005@1@@
00005@1@@
00005@2@Maska konta@S@35@
00005@2@exec('wz_konto','edkonto','PAR_SQL','PAR2S')@
00005@2@@
00005@2@@
00005@2@exec('be_konto','edkonto','PAR_SQL','PAR2S')@
00005@2@exec('f3_konto','edkonto','PAR_SQL','PAR2S')@
00005@2@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR2S')@
00006@1@Jednostka księgowa@S@8@
00006@1@@
00006@1@OPERATOR.DEPT().OD@
00006@1@@
00006@1@OPERATOR.DEPT=null@
00006@1@exec('sel_dept','sql')@
00006@1@exec('chk_dept','sql')@
00006@2@Maska konta@S@35@
00006@2@exec('wz_konto','edkonto','PAR_SQL','PAR2S')@
00006@2@@
00006@2@@
00006@2@exec('be_konto','edkonto','PAR_SQL','PAR2S')@
00006@2@exec('f3_konto','edkonto','PAR_SQL','PAR2S')@
00006@2@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR2S')@
00006@3@Waluta@F@0@
00006@3@@
00006@3@exec('b_wal','sql')@
00006@3@@
00006@3@@
00006@3@@
00006@3@@
00007@1@Jednostka księgowa@S@8@
00007@1@@
00007@1@OPERATOR.DEPT().OD@
00007@1@@
00007@1@OPERATOR.DEPT=null@
00007@1@exec('sel_dept','sql')@
00007@1@exec('chk_dept','sql')@
00007@2@Maska konta@S@35@
00007@2@exec('wz_konto','edkonto','PAR_SQL','PAR2S')@
00007@2@'%'@
00007@2@@
00007@2@exec('be_konto','edkonto','PAR_SQL','PAR2S')@
00007@2@exec('f3_konto','edkonto','PAR_SQL','PAR2S')@
00007@2@exec('ae_konto','edkonto',_a,'PAR_SQL','PAR2S')@
00007@3@Waluta@F@0@
00007@3@@
00007@3@exec('b_wal','sql')@
00007@3@@
00007@3@@
00007@3@@
00007@3@@
00008@1@Jednostka księgowa@S@8@
00008@1@@
00008@1@OPERATOR.DEPT().OD@
00008@1@@
00008@1@OPERATOR.DEPT=null@
00008@1@exec('sel_dept','sql')@
00008@1@exec('chk_dept','sql')@
00008@2@NIP@S@20@
00008@2@@
00008@2@@
00008@2@@
00008@2@@
00008@2@@
00008@2@@
00009@1@Jednostka księgowa@S@8@
00009@1@@
00009@1@OPERATOR.DEPT().OD@
00009@1@@
00009@1@OPERATOR.DEPT=null@
00009@1@exec('sel_dept','sql')@
00009@1@exec('chk_dept','sql')@
00009@2@Rok@F@0@
00009@2@@
00009@2@exec('dok_br','!fks_dks_zzsl')@
00009@2@@
00009@2@@
00009@2@@
00009@2@@
00009@3@Rejestr@S@20@
00009@3@@
00009@3@'PK'@
00009@3@@
00009@3@@
00009@3@exec('f3_rejks','sql')@
00009@3@exec('ae_rejks','sql')@
00009@4@Od daty@D@0@
00009@4@@
00009@4@exec('get_date','okresy',SSTALE.AR,0)@
00009@4@@
00009@4@@
00009@4@@
00009@4@@
00009@5@Do daty@D@0@
00009@5@@
00009@5@exec('get_date','okresy',SSTALE.AR,1)@
00009@5@@
00009@5@@
00009@5@@
00009@5@@
00010@1@Jednostka księgowa@S@8@
00010@1@@
00010@1@OPERATOR.DEPT().OD@
00010@1@@
00010@1@OPERATOR.DEPT=null@
00010@1@exec('sel_dept','sql')@
00010@1@exec('chk_dept','sql')@
00010@2@Kraj opodatkowania@S@20@
00010@2@@
00010@2@'PL'@
00010@2@@
00010@2@@
00010@2@@
00010@2@@
00010@3@Waluta opodatkowania@S@20@
00010@3@@
00010@3@'PLN'@
00010@3@@
00010@3@@
00010@3@@
00010@3@@
00011@1@Jednostka księgowa@S@8@
00011@1@@
00011@1@OPERATOR.DEPT().OD@
00011@1@@
00011@1@OPERATOR.DEPT=null@
00011@1@exec('sel_dept','sql')@
00011@1@exec('chk_dept','sql')@
00011@2@Kraj opodatkowania@S@20@
00011@2@@
00011@2@'PL'@
00011@2@@
00011@2@@
00011@2@@
00011@2@@
00011@3@Waluta opodatkowania@S@20@
00011@3@@
00011@3@'PLN'@
00011@3@@
00011@3@@
00011@3@@
00011@3@@
00011@4@Prefix grupy podatk.@S@20@
00011@4@@
00011@4@@
00011@4@@
00011@4@@
00011@4@@
00011@4@@
00011@5@Prefix skrótu kontr.@S@20@
00011@5@@
00011@5@@
00011@5@@
00011@5@@
00011@5@@
00011@5@@
00011@6@Prefix nazwy kontr.@S@20@
00011@6@@
00011@6@@
00011@6@@
00011@6@@
00011@6@@
00011@6@@
00012@1@Jednostka księgowa@F@0@
00012@1@@
00012@1@{? OPERATOR.DEPT || OPERATOR.DEPT().OD || 'wszystkie' ?}@
00012@1@@
00012@1@@
00012@1@@
00012@1@@
00012@2@Od okresu@F@0@
00012@2@@
00012@2@exec('od_okr','!fks_vat_zsql')@
00012@2@@
00012@2@@
00012@2@@
00012@2@@
00012@3@Do okresu@F@0@
00012@3@@
00012@3@SSTALE.AO().NR@
00012@3@@
00012@3@@
00012@3@@
00012@3@@
00013@1@Jednostka księgowa@S@8@
00013@1@@
00013@1@OPERATOR.DEPT().OD@
00013@1@@
00013@1@OPERATOR.DEPT=null@
00013@1@exec('sel_dept','sql')@
00013@1@exec('chk_dept','sql')@
00013@2@Rok@F@0@
00013@2@@
00013@2@exec('dok_br','!fks_dks_zzsl')@
00013@2@@
00013@2@@
00013@2@@
00013@2@@
00013@3@Od daty@D@0@
00013@3@@
00013@3@SSTALE.AO().POCZ@
00013@3@@
00013@3@@
00013@3@@
00013@3@@
00013@4@Do daty@D@0@
00013@4@@
00013@4@SSTALE.AO().KON@
00013@4@@
00013@4@@
00013@4@@
00013@4@@
rej_dok1@1@tab_tmp@F@0@
rej_dok1@1@@
rej_dok1@1@exec('rej_dok_sch','!fks_dks_zzsl')@
rej_dok1@1@@
rej_dok1@1@@
rej_dok1@1@@
rej_dok1@1@@
