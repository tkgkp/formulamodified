:!UTF-8
/*
  Kalkulacje technologii

  Parametry: _a - kod produktu
             _b - stan karty technologicznej (N,P,T,* - wszystkie stany)
             _c,_d,_e,_f - numery rubryk (muszą być wypełnione)
             _g,_h,_i,_j - nazwy rubryk
*/

select
   0 as LP,
   M.KTM as KTM,
   M.N as Nazwa,
   TKTL.NRK as Technologia,
   TKTL.WER as Wersja,
   KKTL.KNR as "Nr kalk.",
   KPOZK1.WART as ":_g",
   KPOZK2.WART as ":_h",
   KPOZK3.WART as ":_i",
   KPOZK4.WART as ":_j"

from @KKTL
   join @TKTLW using(KKTL.TKTLW, TKTLW.REFERENCE)
   join M using(TKTLW.KTM, M.REFERENCE)
   join @TKTL using(KKTL.NRK, TKTL.REFERENCE)
   join @KPOZK as KPOZK1 using(KKTL.REFERENCE, KPOZK1.KALK)
   join KRUB as KRUB1 using(KPOZK1.RUBR, KRUB1.REFERENCE)
   left join @KPOZK as KPOZK2 using(KKTL.REFERENCE, KPOZK2.KALK)
   join KRUB as KRUB2 using(KPOZK2.RUBR, KRUB2.REFERENCE)
   left join @KPOZK as KPOZK3 using(KKTL.REFERENCE, KPOZK3.KALK)
   join KRUB as KRUB3 using(KPOZK3.RUBR, KRUB3.REFERENCE)
   left join @KPOZK as KPOZK4 using(KKTL.REFERENCE, KPOZK4.KALK)
   join KRUB as KRUB4 using(KPOZK4.RUBR, KRUB4.REFERENCE)

where
   (TKTL.STAN like UPPER(':_b'))
   and (M.KTM like ':_a%')
   and KRUB1.NR=:_c
   and KRUB2.NR=:_d
   and KRUB3.NR=:_e
   and KRUB4.NR=:_f

order by KTM, Technologia, Wersja

