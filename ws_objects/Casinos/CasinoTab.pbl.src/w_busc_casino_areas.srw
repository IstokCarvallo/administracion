$PBExportHeader$w_busc_casino_areas.srw
forward
global type w_busc_casino_areas from w_busqueda
end type
end forward

global type w_busc_casino_areas from w_busqueda
integer width = 2967
end type
global w_busc_casino_areas w_busc_casino_areas

type variables
Integer	ii_zona, ii_tipo
end variables

event open;call super::open;istr_busq	=	Message.PowerobjectParm

ii_zona		=	Integer(istr_busq.argum[1])

IF dw_1.Retrieve(ii_zona) > 0 THEN
	dw_1.SetFocus()
	dw_1.SelectRow(1,True)
	is_ordena 	= 'Código Área:caar_codigo,Nombre Área:'+&
				  'caar_nombre,Abreviación Área:caar_abrevi'
				  
	tab_1.SelectedTab			=	2
	tab_1.Tabpage_1.Visible	=	False
	tab_1.Tabpage_3.Visible	=	False
ELSE
	MessageBox("Atención","No hay información para mostrar",Exclamation!,Ok!)
	CloseWithReturn(This,istr_busq)
END IF
end event

on w_busc_casino_areas.create
call super::create
end on

on w_busc_casino_areas.destroy
call super::destroy
end on

event ue_asignacion;istr_busq.argum[4]	=	String(dw_1.Object.caar_codigo[dw_1.GetRow()])
istr_busq.argum[5]	=	dw_1.Object.caar_nombre[dw_1.GetRow()]

CloseWithReturn(This, istr_busq)
end event

type pb_insertar from w_busqueda`pb_insertar within w_busc_casino_areas
integer x = 2651
integer y = 1100
end type

type dw_1 from w_busqueda`dw_1 within w_busc_casino_areas
integer width = 2455
string dataobject = "dw_mues_areas_zonas_busq"
end type

event dw_1::doubleclicked;IF row > 0 THEN
	Parent.PostEvent("ue_asignacion")
	This.SetRow(Row)
END IF
end event

type pb_salir from w_busqueda`pb_salir within w_busc_casino_areas
integer x = 2651
integer y = 1404
end type

type tab_1 from w_busqueda`tab_1 within w_busc_casino_areas
integer width = 2450
boolean fixedwidth = true
end type

on tab_1.create
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
call super::destroy
end on

type tabpage_1 from w_busqueda`tabpage_1 within tab_1
integer y = 116
integer width = 2414
integer height = 504
end type

type pb_filtrar from w_busqueda`pb_filtrar within tabpage_1
end type

type tabpage_2 from w_busqueda`tabpage_2 within tab_1
integer y = 116
integer width = 2414
integer height = 504
end type

type pb_acepta from w_busqueda`pb_acepta within tabpage_2
end type

type dw_3 from w_busqueda`dw_3 within tabpage_2
end type

type dw_2 from w_busqueda`dw_2 within tabpage_2
end type

type tabpage_3 from w_busqueda`tabpage_3 within tab_1
integer y = 116
integer width = 2414
integer height = 504
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

