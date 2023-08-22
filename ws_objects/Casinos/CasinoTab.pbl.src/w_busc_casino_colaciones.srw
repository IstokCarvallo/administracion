$PBExportHeader$w_busc_casino_colaciones.srw
forward
global type w_busc_casino_colaciones from w_busqueda
end type
end forward

global type w_busc_casino_colaciones from w_busqueda
end type
global w_busc_casino_colaciones w_busc_casino_colaciones

type variables
Integer	ii_zona, ii_tipo
end variables

event open;call super::open;istr_busq	=	Message.PowerobjectParm

ii_zona		=	Integer(istr_busq.argum[1])
ii_tipo		=	Integer(istr_busq.argum[2])

istr_busq.argum[4]	=	''

IF dw_1.Retrieve(ii_zona, ii_tipo) > 0 THEN
	dw_1.SetFocus()
	dw_1.SelectRow(1,True)
ELSE
	MessageBox("Atención","No hay información para mostrar",Exclamation!,Ok!)
	CloseWithReturn(This,istr_busq)
END IF

is_ordena 	= 'Código Colación:caco_codigo,Nombre Colación:'+&
				  'caco_nombre,Abreviación Nombre:caco_abrevi'
end event

on w_busc_casino_colaciones.create
call super::create
end on

on w_busc_casino_colaciones.destroy
call super::destroy
end on

event ue_asignacion;istr_busq.argum[4]	=	String(dw_1.Object.caco_codigo[dw_1.GetRow()])
istr_busq.argum[5]	=	dw_1.Object.caco_abrevi[dw_1.GetRow()]

CloseWithReturn(This, istr_busq)
end event

type pb_insertar from w_busqueda`pb_insertar within w_busc_casino_colaciones
end type

type dw_1 from w_busqueda`dw_1 within w_busc_casino_colaciones
string dataobject = "dw_mues_casino_colaciones_bloqueado"
end type

event dw_1::doubleclicked;IF row > 0 THEN
	Parent.PostEvent("ue_asignacion")
	This.SetRow(Row)
END IF
end event

type pb_salir from w_busqueda`pb_salir within w_busc_casino_colaciones
end type

type tab_1 from w_busqueda`tab_1 within w_busc_casino_colaciones
end type

type tabpage_1 from w_busqueda`tabpage_1 within tab_1
end type

type pb_filtrar from w_busqueda`pb_filtrar within tabpage_1
end type

type tabpage_2 from w_busqueda`tabpage_2 within tab_1
end type

type pb_acepta from w_busqueda`pb_acepta within tabpage_2
end type

type dw_3 from w_busqueda`dw_3 within tabpage_2
end type

type dw_2 from w_busqueda`dw_2 within tabpage_2
end type

type tabpage_3 from w_busqueda`tabpage_3 within tab_1
end type

type sle_argumento2 from w_busqueda`sle_argumento2 within tabpage_3
end type

type st_argum2 from w_busqueda`st_argum2 within tabpage_3
end type

type sle_argumento1 from w_busqueda`sle_argumento1 within tabpage_3
end type

type st_argum1 from w_busqueda`st_argum1 within tabpage_3
end type

type pb_buscar from w_busqueda`pb_buscar within tabpage_3
end type

