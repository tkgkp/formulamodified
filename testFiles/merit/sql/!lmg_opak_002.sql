:!UTF-8
select
	LP,
	MG_OPAK MagSymbol,
	D StanNaDzien,
	KTM MatIndeks,
	N MatNaz,
	S Stan,
	ILW Wwydaniu,
	SD StanDostepny,
	JM Jm
from
	 :_c
where
	:_b
order by
	2,3,4

