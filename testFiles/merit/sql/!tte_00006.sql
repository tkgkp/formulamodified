:!UTF-8
/*
  Grupowanie kalkulacji technologii wg Towarów

  Parametry: _a - Stan karty technologicznej (N,P,T,* - wszystkie stany)
             _b - archiwalna (T,N,* - wszystkie)
             _c,_d,_e,_f - numery rubryk (muszą być wypełnione)
*/

select
   0 as LP,
   M.KTM as Towar,
   M.N as Nazwa,
   KRUB.NR as Rubryka,
   KRUB.OPIS as Opis,
   max(KPOZK.WART) as Maksimum,
   min(KPOZK.WART) as Minimum,
   avg(KPOZK.WART) as Średnia
from @KPOZK
   join @KRUB using (KPOZK.RUBR, KRUB.REFERENCE)
   join @KKTL using (KPOZK.KALK, KKTL.REFERENCE)
   join @TKTL using (KKTL.NRK, TKTL.REFERENCE)
   join M using (TKTL.KTM, M.REFERENCE)
   join KWAR using(KKTL.OPC, KWAR.REFERENCE)
where
   (TKTL.STAN like UPPER(':_a'))
   and (TKTL.ARCH like ':_b')
   and (KRUB.NR=:_c or KRUB.NR=:_d or KRUB.NR=:_e or KRUB.NR=:_f)
   and (TKTL.DEF_OPCK=KWAR.REFERENCE)
group by M.KTM, M.N, KRUB.NR, KRUB.OPIS
order by Towar, Rubryka

