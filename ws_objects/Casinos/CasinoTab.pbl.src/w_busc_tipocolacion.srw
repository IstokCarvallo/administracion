$PBExportHeader$w_busc_tipocolacion.srw
forward
global type w_busc_tipocolacion from w_busqueda
end type
end forward

global type w_busc_tipocolacion from w_busqueda
integer x = 123
integer y = 304
string title = "Búsqueda de Especies"
end type
global w_busc_tipocolacion w_busc_tipocolacion

type variables

end variables

on w_busc_tipocolacion.create
call super::create
end on

on w_busc_tipocolacion.destroy
call super::destroy
end on

event open;call super::open;
istr_Busq		=	Message.PowerObjectParm

IF dw_1.Retrieve(Integer(istr_Busq.Argum[1])) > 0 THEN
	dw_1.Object.tico_codigo.Protect				=	1
	dw_1.Object.tico_codigo.Border				=	0
	dw_1.Object.tico_codigo.Background.Mode	=	1
	
	dw_1.Object.tico_nombre.Protect	=	1
	dw_1.Object.tico_nombre.Border				=	0
	dw_1.Object.tico_nombre.Background.Mode	=	1
	
	dw_1.Object.tico_abrevi.Protect	=	1
	dw_1.Object.tico_abrevi.Border				=	0
	dw_1.Object.tico_abrevi.Background.Mode	=	1
	
	
	dw_1.SetFocus()
	dw_1.SelectRow(1,True)
ELSE
	MessageBox("Atención","No hay información para mostrar",Exclamation!,Ok!)
	CloseWithReturn(This,istr_busq)
END IF
end event

event ue_asignacion;istr_busq.argum[1]	= String(dw_1.GetItemNumber(dw_1.GetRow(),"tico_codigo"))
istr_busq.argum[2]	= dw_1.GetItemString(dw_1.GetRow(),"tico_nombre")
istr_busq.argum[3]	= dw_1.GetItemString(dw_1.GetRow(),"tico_abrevi")

CloseWithReturn(This,istr_busq)
end event

type pb_insertar from w_busqueda`pb_insertar within w_busc_tipocolacion
integer x = 2290
end type

type dw_1 from w_busqueda`dw_1 within w_busc_tipocolacion
integer x = 73
integer y = 732
integer width = 2085
string dataobject = "dw_mues_tipocolacion"
end type

type pb_salir from w_busqueda`pb_salir within w_busc_tipocolacion
integer x = 2290
integer y = 1372
alignment htextalign = center!
end type

event pb_salir::clicked;CloseWithReturn(Parent,istr_busq)
end event

type tab_1 from w_busqueda`tab_1 within w_busc_tipocolacion
integer x = 73
integer y = 64
integer width = 2085
integer selectedtab = 2
end type

type tabpage_1 from w_busqueda`tabpage_1 within tab_1
boolean visible = false
integer width = 2048
boolean enabled = false
string text = "Filtros              "
end type

type pb_filtrar from w_busqueda`pb_filtrar within tabpage_1
boolean visible = false
integer x = 1280
boolean enabled = false
boolean default = false
end type

event pb_filtrar::clicked;call super::clicked;IF dw_1.Retrieve(Integer(istr_busq.argum[1])) > 0 THEN
	dw_1.SetFocus()
	dw_1.SelectRow(1,True)
ELSE
	MessageBox("Atención","No hay información para mostrar",Exclamation!,Ok!)
END IF
end event

type tabpage_2 from w_busqueda`tabpage_2 within tab_1
integer width = 2048
string text = "Ordenamiento  "
end type

type pb_acepta from w_busqueda`pb_acepta within tabpage_2
end type

type dw_3 from w_busqueda`dw_3 within tabpage_2
end type

type dw_2 from w_busqueda`dw_2 within tabpage_2
end type

type tabpage_3 from w_busqueda`tabpage_3 within tab_1
integer width = 2048
string text = "Búsqueda          "
end type

type sle_argumento2 from w_busqueda`sle_argumento2 within tabpage_3
integer x = 393
end type

type st_argum2 from w_busqueda`st_argum2 within tabpage_3
string text = "Nombre"
end type

type sle_argumento1 from w_busqueda`sle_argumento1 within tabpage_3
integer x = 393
integer width = 197
end type

type st_argum1 from w_busqueda`st_argum1 within tabpage_3
string text = "Còdigo"
end type

type pb_buscar from w_busqueda`pb_buscar within tabpage_3
integer x = 1861
integer y = 316
end type

