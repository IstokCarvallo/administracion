$PBExportHeader$w_errorbasedatos.srw
forward
global type w_errorbasedatos from window
end type
type dw_1 from datawindow within w_errorbasedatos
end type
type pb_imprime from picturebutton within w_errorbasedatos
end type
type pb_acepta from picturebutton within w_errorbasedatos
end type
type mle_mensaje from multilineedit within w_errorbasedatos
end type
end forward

global type w_errorbasedatos from window
integer x = 649
integer y = 300
integer width = 1943
integer height = 1080
boolean titlebar = true
string title = "CONTROL DE ERROR"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "StopSign!"
dw_1 dw_1
pb_imprime pb_imprime
pb_acepta pb_acepta
mle_mensaje mle_mensaje
end type
global w_errorbasedatos w_errorbasedatos

type variables
Str_ErrorBaseDatos	istr_ErrBD
end variables

event open;istr_ErrBD			=	Message.PowerObjectParm
mle_mensaje.text	=	istr_ErrBD.MensajePantalla
end event

on w_errorbasedatos.create
this.dw_1=create dw_1
this.pb_imprime=create pb_imprime
this.pb_acepta=create pb_acepta
this.mle_mensaje=create mle_mensaje
this.Control[]={this.dw_1,&
this.pb_imprime,&
this.pb_acepta,&
this.mle_mensaje}
end on

on w_errorbasedatos.destroy
destroy(this.dw_1)
destroy(this.pb_imprime)
destroy(this.pb_acepta)
destroy(this.mle_mensaje)
end on

type dw_1 from datawindow within w_errorbasedatos
boolean visible = false
integer x = 1641
integer y = 816
integer width = 494
integer height = 360
integer taborder = 40
string dataobject = "dw_errorbasedatos"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_imprime from picturebutton within w_errorbasedatos
event mousemove pbm_mousemove
integer x = 1586
integer y = 460
integer width = 300
integer height = 245
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "\Desarrollo 17\Imagenes\Botones\Imprimir.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Imprimir-bn.png"
alignment htextalign = left!
long backcolor = 553648127
end type

event clicked;dw_1.InsertRow(0)

dw_1.SetItem(1, "titulo", istr_ErrBD.Titulo)
dw_1.SetItem(1, "error", istr_ErrBD.Numero)
dw_1.SetItem(1, "texto", istr_ErrBD.Texto)

dw_1.Modify("usuario.text = '" + gstr_us.Nombre + "'")
dw_1.Modify("estacion.text = '" + gstr_us.Computador + "'")

dw_1.Print()

Close(Parent)
end event

type pb_acepta from picturebutton within w_errorbasedatos
event mousemove pbm_mousemove
integer x = 1600
integer y = 132
integer width = 300
integer height = 245
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
alignment htextalign = left!
long backcolor = 553648127
end type

event clicked;Close(Parent)
end event

type mle_mensaje from multilineedit within w_errorbasedatos
integer x = 46
integer y = 32
integer width = 1490
integer height = 908
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = script!
string facename = "Comic Sans MS"
string pointer = "arrow!"
long textcolor = 8388608
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

