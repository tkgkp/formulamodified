:!UTF-8
Dokumenty źródłowe@Dekrety bieżącego okresu dla maski kont@00004@@@@T@JEDN_KSIĘGOWA,REJESTR,KONTO,SYMBOL@T@
Dokumenty źródłowe@Dekrety bieżącego okresu dla zakresu kont@00002@@exec('sqlr_sum','#sql')@exec('rb_sqlrs','#sql')@N@@T@
Dokumenty źródłowe@Dekrety bieżącego roku dla zakresu kont@00003@@exec('sqlr_sum','#sql')@exec('rb_sqlrs','#sql')@N@@T@
Dokumenty źródłowe@Dokumenty źródłowe bieżącego roku wg rejestru i zakresu dat operacji@00009@@@@N@@T@
Dokumenty źródłowe@Dokumenty źródłowe bieżącego roku wg rejestru i zakresu dat zapisu@00001@@@@N@@T@
Dokumenty źródłowe@Rejestry z typami dokumentów i schematami dekretacji@rej_dok1@@VAR_DEL.delete('X_Xcie')@@N@@T@
Dokumenty źródłowe@Zestawienie korekt nagłówkowych w bieżącym okresie@00013@@@@N@@T@
Księgi rachunkowe@Księgowania dla maski kont@00006@@exec('sqlr_sum','#sql')@exec('rb_sqlrs','#sql')@N@@T@
Księgi rachunkowe@Wykaz kont używanych w sprawozdaniach finansowych@00005@@@@N@@T@
Rejestry VAT@Dokumenty w rejestrach sprzedaży z maską NIP-u kontrahenta@00008@@@@N@@T@
Rejestry VAT@Obliczenie % struktury czynności opodatkowanych@00012@exec('przed_proc','!fks_vat_zsql')@exec('proc_sql','!fks_vat_zsql')@{? _=1 || 'Czynności opodatkowane' || exec('rek_spr','!fks_vat_zsql') ?}@N@@T@
Rejestry VAT@Roczne zestawienie wg klas, grup i stawek VAT@00010@@@@N@@T@
Rejestry VAT@Roczne zestawienie wg kontrahentów, grup, stawek@00011@@exec('sqlr_sum','#sql')@exec('rb_sqlrs','#sql')@N@@T@
Rozrachunki@Rozrachunki dla maski kont@00007@@@@T@KONTRAH,KONTO,SYMBOL@T@
Rozrachunki@Sprawozdanie o stosowanych terminach zapłaty w transakcjach han. (2023)@rwtermp2@exec('start','optermpl2')@@@N@@T@
Rozrachunki@Sprawozdanie o stosowanych terminach zapłaty w transakcjach han. (UOKiK)@rwuokik@exec('start','opuokik')@@@N@@T@
Rozrachunki@Sprawozdanie o stosowanych terminach zapłaty w transakcjach handlowych@rwtermpl@exec('start','optermpl')@@@N@@T@
