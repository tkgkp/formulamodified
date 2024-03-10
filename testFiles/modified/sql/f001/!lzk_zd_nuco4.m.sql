:!UTF-8
select
	0 as LP,
	POTW as "Potwierdzenie",
	PDR as "Potwierdzona data realizacji",
	FDR as "Faktyczna data realizacji",
	ZDR as "Planowana data realizacji",
	ZKON as "Oznaczenie importu",
	KOD as "Kod Kontrahenta",
	NAZWA as "Nazwa skrócona",
	TYPZAM as "Typ zamówienia",
	ZAM as "Zamówienie",
	D_ZAM as "Data zamówienia",
	KTM as "Indeks",
	M_NAZWA as "Nazwa towaru",
	IL_DNI as "Dni płatności",
	T_PLAT as "Termin płatności",
	ILOSC as "Ilość",
	WAR_PLN as "Wartość w PLN",
	WAR_WAL as "Wartość w walucie",
	WAL as "Waluta"
from
        :_c
where
	T_PLAT between to_date(:_a) and to_date(:_b) 
order by
	"Termin płatności","Typ zamówienia","Kod Kontrahenta","Zamówienie","Indeks"
