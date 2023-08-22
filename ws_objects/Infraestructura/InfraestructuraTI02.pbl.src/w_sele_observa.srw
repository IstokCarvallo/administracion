$PBExportHeader$w_sele_observa.srw
$PBExportComments$Informe Existencia Sitio Revisión
forward
global type w_sele_observa from w_para_informes
end type
type mle_observacion from multilineedit within w_sele_observa
end type
end forward

global type w_sele_observa from w_para_informes
integer x = 14
integer y = 32
integer width = 3337
integer height = 1052
string title = "Observacion Guias Nulas"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string icon = "AppIcon!"
boolean toolbarvisible = false
mle_observacion mle_observacion
end type
global w_sele_observa w_sele_observa

type variables
str_mant istr_mant
end variables

on w_sele_observa.create
int iCurrent
call super::create
this.mle_observacion=create mle_observacion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_observacion
end on

on w_sele_observa.destroy
call super::destroy
destroy(this.mle_observacion)
end on

type pb_excel from w_para_informes`pb_excel within w_sele_observa
integer x = 2958
integer y = 132
end type

type st_computador from w_para_informes`st_computador within w_sele_observa
end type

type st_usuario from w_para_informes`st_usuario within w_sele_observa
end type

type st_temporada from w_para_informes`st_temporada within w_sele_observa
end type

type p_logo from w_para_informes`p_logo within w_sele_observa
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_sele_observa
integer width = 2638
string text = "Obervaciones"
end type

type pb_acepta from w_para_informes`pb_acepta within w_sele_observa
boolean visible = false
integer x = 2981
integer y = 400
integer taborder = 130
boolean enabled = false
boolean default = false
end type

type pb_salir from w_para_informes`pb_salir within w_sele_observa
integer x = 2985
integer y = 664
integer taborder = 140
boolean cancel = false
boolean default = true
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
end type

event pb_salir::clicked;If IsNull(mle_observacion.Text) Or mle_observacion.Text = '' Then Return
istr_Mant.Argumento[1] = mle_observacion.Text

CloseWithReturn (Parent, istr_Mant)
end event

type mle_observacion from multilineedit within w_sele_observa
integer x = 256
integer y = 420
integer width = 2629
integer height = 492
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean vscrollbar = true
textcase textcase = upper!
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

