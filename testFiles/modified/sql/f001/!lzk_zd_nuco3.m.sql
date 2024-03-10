:!UTF-8
select
	0 as LP,
	POTW as "Potwierdzenie",
	REA as "Potwierdz. real.",
	KOD,
	NAZWA as "Nazwa skrócona",
                     ZAM as "Zamówienie",
                     D_ZAM as "Data zam.",
	KTM,
	M_NAZWA as "Nazwa",
	D_REA as "Data realizacji",
	IL_DNI as "Dni płat.",
	T_PLAT as "Termin płat.",
	IL_POT as "Ilość potwierdzona",
	IL_ZRE as "Ilość zrealizowana",
                     WAR_PLN as "Wartość w PLN",
                     WAR_WAL as "Wartość w wal.",
                     WAL
from
        :_c
where
	D_REA between to_date(:_a) and to_date(:_b)  
order by
	"Potwierdzenie","Potwierdz. real.",KOD,"Nazwa skrócona","Zamówienie",KTM,"Nazwa"
