$PBExportHeader$w_busc_licencias.srw
forward
global type w_busc_licencias from w_busqueda
end type
end forward

global type w_busc_licencias from w_busqueda
integer x = 78
integer y = 176
integer width = 3634
integer height = 1808
string title = "Búsqueda de Licencias"
end type
global w_busc_licencias w_busc_licencias

type variables

end variables

event open;call super::open;
is_ordena = 'Usuario:lice_codigo,KEY:lice_serie'

istr_busq	=	Message.PowerObjectParm

IF dw_1.Retrieve() > 0 THEN
	dw_1.SetFocus()
	dw_1.SelectRow(1,True)
ELSE
	MessageBox("Atención","No hay información para mostrar",Exclamation!,Ok!)
	CloseWithReturn(This,istr_busq)
END IF
end event

on w_busc_licencias.create
call super::create
end on

on w_busc_licencias.destroy
call super::destroy
end on

event ue_asignacion;istr_busq.argum[1]	= String(dw_1.GetItemNumber(dw_1.GetRow(),"lice_codigo"))

CloseWithReturn(This,istr_busq)
end event

type pb_insertar from w_busqueda`pb_insertar within w_busc_licencias
boolean visible = false
integer x = 3237
integer y = 1008
integer taborder = 30
end type

type dw_1 from w_busqueda`dw_1 within w_busc_licencias
integer x = 82
integer y = 708
integer width = 3086
integer taborder = 20
string dataobject = "dw_mues_licencias"
end type

type pb_salir from w_busqueda`pb_salir within w_busc_licencias
integer x = 3227
integer y = 1300
integer taborder = 40
end type

event pb_salir::clicked;CloseWithReturn(Parent,istr_busq)
end event

type tab_1 from w_busqueda`tab_1 within w_busc_licencias
integer y = 76
integer width = 2094
integer height = 608
boolean fixedwidth = true
integer selectedtab = 2
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
boolean visible = false
integer width = 2057
integer height = 480
boolean enabled = false
string text = "Filtros  "
end type

type pb_filtrar from w_busqueda`pb_filtrar within tabpage_1
boolean visible = false
integer x = 1842
integer y = 300
boolean enabled = false
string picturename = "F:\Desarrollo 17\Imagenes\Botones\Filtrar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Filtrar-bn.png"
end type

type tabpage_2 from w_busqueda`tabpage_2 within tab_1
integer width = 2057
integer height = 480
string text = "Ordenamiento      "
end type

type pb_acepta from w_busqueda`pb_acepta within tabpage_2
end type

type dw_3 from w_busqueda`dw_3 within tabpage_2
end type

type dw_2 from w_busqueda`dw_2 within tabpage_2
end type

type tabpage_3 from w_busqueda`tabpage_3 within tab_1
integer width = 2057
integer height = 480
string text = "Búsqueda  "
end type

type sle_argumento2 from w_busqueda`sle_argumento2 within tabpage_3
integer x = 466
end type

event sle_argumento2::getfocus;This.SelectText(1, Len(This.Text))

This.Text						= ""
This.BackColor					= RGB(255,255,255)
This.TabOrder					= 10
sle_argumento1.Text			= ""
sle_argumento1.BackColor	= RGB(192,192,192)
sle_argumento1.TabOrder		= 0
es_numero						= False
is_busca							= "ciud_nombre"
end event

type st_argum2 from w_busqueda`st_argum2 within tabpage_3
integer width = 357
string text = "Nro. Interno"
end type

type sle_argumento1 from w_busqueda`sle_argumento1 within tabpage_3
integer width = 256
end type

event sle_argumento1::getfocus;This.SelectText(1, Len(This.Text))

This.BackColor					= RGB(255,255,255)
This.TabOrder					= 10
sle_argumento2.Text			= ""
sle_argumento2.BackColor	= RGB(192,192,192)
sle_argumento2.TabOrder		= 0
es_numero						= True
is_busca							= "tpde_codigo"
end event

type st_argum1 from w_busqueda`st_argum1 within tabpage_3
integer width = 261
string text = "Código"
end type

type pb_buscar from w_busqueda`pb_buscar within tabpage_3
integer x = 1819
integer y = 280
end type

