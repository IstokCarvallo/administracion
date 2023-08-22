$PBExportHeader$w_mant_areacontacto.srw
forward
global type w_mant_areacontacto from w_mant_directo
end type
type dw_2 from datawindow within w_mant_areacontacto
end type
type st_1 from statictext within w_mant_areacontacto
end type
type dw_3 from datawindow within w_mant_areacontacto
end type
type dw_4 from datawindow within w_mant_areacontacto
end type
end forward

global type w_mant_areacontacto from w_mant_directo
integer width = 3744
integer height = 2212
string title = "DISTRIBUCION DE PERSONAL POR AREA"
dw_2 dw_2
st_1 st_1
dw_3 dw_3
dw_4 dw_4
end type
global w_mant_areacontacto w_mant_areacontacto

on w_mant_areacontacto.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.st_1=create st_1
this.dw_3=create dw_3
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.dw_4
end on

on w_mant_areacontacto.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.dw_4)
end on

type st_encabe from w_mant_directo`st_encabe within w_mant_areacontacto
integer x = 64
integer width = 3218
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_areacontacto
integer x = 3442
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_areacontacto
integer x = 3442
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_areacontacto
boolean visible = false
integer x = 3442
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_areacontacto
boolean visible = false
integer x = 3442
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_areacontacto
integer x = 3442
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_areacontacto
integer x = 3442
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_areacontacto
integer x = 3442
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_areacontacto
integer x = 1509
integer y = 984
integer width = 1810
integer height = 1076
boolean titlebar = true
string title = "Personal de Contacto para el Area"
string dataobject = "dw_mues_areacontacto"
end type

type dw_2 from datawindow within w_mant_areacontacto
integer x = 64
integer y = 984
integer width = 1445
integer height = 1076
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Personal Empresa"
string dataobject = "dw_mues_personacolacion_corto"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_mant_areacontacto
integer x = 974
integer y = 120
integer width = 402
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Zona"
long bordercolor = 16777215
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_mant_areacontacto
integer x = 1362
integer y = 116
integer width = 987
integer height = 84
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dddw_zonas"
boolean border = false
boolean livescroll = true
end type

type dw_4 from datawindow within w_mant_areacontacto
integer x = 69
integer y = 284
integer width = 3246
integer height = 692
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "Areas Creadas para la Zona"
string dataobject = "dw_mues_areas_zonas"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

