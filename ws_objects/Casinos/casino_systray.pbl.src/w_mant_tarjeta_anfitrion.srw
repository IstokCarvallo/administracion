$PBExportHeader$w_mant_tarjeta_anfitrion.srw
forward
global type w_mant_tarjeta_anfitrion from window
end type
type st_2 from statictext within w_mant_tarjeta_anfitrion
end type
type st_1 from statictext within w_mant_tarjeta_anfitrion
end type
type pb_cancela from picturebutton within w_mant_tarjeta_anfitrion
end type
type pb_acepta from picturebutton within w_mant_tarjeta_anfitrion
end type
type dw_1 from datawindow within w_mant_tarjeta_anfitrion
end type
type sle_1 from singlelineedit within w_mant_tarjeta_anfitrion
end type
end forward

global type w_mant_tarjeta_anfitrion from window
string tag = "16126461-k"
integer width = 3566
integer height = 1172
boolean titlebar = true
string title = "INGRESO TARJETA ANFITRION"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean righttoleft = true
boolean center = true
st_2 st_2
st_1 st_1
pb_cancela pb_cancela
pb_acepta pb_acepta
dw_1 dw_1
sle_1 sle_1
end type
global w_mant_tarjeta_anfitrion w_mant_tarjeta_anfitrion

type variables
String		ls_pers_codigo, ls_pers_apepat, ls_pers_apemat, ls_pers_nombre
Long		ll_pers_nrotar
Integer	li_cape_invita, li_cape_topein, li_zona_codigo, li_caar_codigo, ii_zona, ii_area
end variables

forward prototypes
public function boolean existetarjeta (string as_tarjeta)
end prototypes

public function boolean existetarjeta (string as_tarjeta);Integer	li_zona, li_colacion, li_invitados

SELECT  pers_codigo, 	 pers_apepat, 		pers_apemat, 	  
		  pers_nombre, 	 pers_nrotar
  INTO :ls_pers_codigo, :ls_pers_apepat, :ls_pers_apemat, 
  		 :ls_pers_nombre, :ll_pers_nrotar
  FROM dbo.remupersonal
 WHERE :as_tarjeta = pers_codigo
 USING sqlca;
 
If sqlca.SQLCode = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla RemuPersonal")
	Return False
ElseIf sqlca.SQLCode = 100 Then
	istr_Mant.Argumento[98] = "Error"
	istr_Mant.Argumento[99] = "La tarjeta ingresada no pertenece a Personal Rio Blanco."
	Return False
Else
	SELECT IsNull(cape_invita, 0), IsNull(cape_topein, 0), zona_codigo, caar_codigo
	  INTO :li_cape_invita, :li_cape_topein, :ii_zona, :ii_area
	  FROM dbo.Casino_PersonaColacion
	 WHERE cape_codigo = :ls_pers_codigo;
	
	If sqlca.SQLCode = -1 Then
		F_ErrorBaseDatos(sqlca, "Lectura de Tabla Casino PersonaColacion")
		Return False
	ElseIf sqlca.SQLCode = 100 OR li_cape_invita = 0 Then
		istr_Mant.Argumento[98] = "Error"
		istr_Mant.Argumento[99] = "La persona no puede realizar invitaciones de almuerzo."
		Return False
	Else
		li_zona			=	Integer(istr_mant.Argumento[1])
		li_colacion		=	Integer(istr_mant.Argumento[2])
		li_invitados	=	0
		
		SELECT Sum(camv_invcur)
			INTO :li_invitados
		  	FROM dbo.Casino_MovtoColaciones
		 WHERE zona_codigo = :ii_zona
		 	And DatedIff(dd, GetDate(), camv_fechac) = 0
			 And cape_codigo = :ls_pers_codigo
              And camv_tipope = 1;

		If sqlca.SQLCode = -1 Then
			F_ErrorBaseDatos(sqlca, "Lectura de Tabla RemuPersonal")
			Return False
		ElseIf li_invitados >= li_cape_topein Then
			istr_Mant.Argumento[98] = "Error"
			istr_Mant.Argumento[99] = "El anfitrión ha alcanzado el tope de invitaciones para esta colación"
			Return False
		End If
	End If
End If

Return True
end function

on w_mant_tarjeta_anfitrion.create
this.st_2=create st_2
this.st_1=create st_1
this.pb_cancela=create pb_cancela
this.pb_acepta=create pb_acepta
this.dw_1=create dw_1
this.sle_1=create sle_1
this.Control[]={this.st_2,&
this.st_1,&
this.pb_cancela,&
this.pb_acepta,&
this.dw_1,&
this.sle_1}
end on

on w_mant_tarjeta_anfitrion.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_cancela)
destroy(this.pb_acepta)
destroy(this.dw_1)
destroy(this.sle_1)
end on

event open;dw_1.InsertRow(0)
dw_1.SetFocus()

istr_mant	=	Message.PowerObjectParm
end event

type st_2 from statictext within w_mant_tarjeta_anfitrion
integer x = 59
integer y = 64
integer width = 3424
integer height = 112
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Ingrese Tarjeta Anfitrion para realizar ingreso a Casino."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_mant_tarjeta_anfitrion
integer x = 55
integer y = 44
integer width = 3433
integer height = 148
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 16777215
long backcolor = 16711680
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_cancela from picturebutton within w_mant_tarjeta_anfitrion
string tag = "Cancela Ingreso"
integer x = 2377
integer y = 772
integer width = 357
integer height = 268
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
string picturename = "\Desarrollo 17\Imagenes\Botones\Cancelar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Cancelar-bn.png"
alignment htextalign = left!
end type

event clicked;istr_mant.Argumento[04]	=	""
istr_mant.Argumento[05]	=	""
istr_mant.Argumento[06]	=	""
istr_mant.Argumento[07]	=	""
istr_mant.Argumento[08]	=	""
istr_mant.Argumento[09]	=	""
istr_mant.Argumento[10]	=	""

CloseWithReturn(Parent, istr_mant)
end event

type pb_acepta from picturebutton within w_mant_tarjeta_anfitrion
string tag = "Acepta Tarjeta"
integer x = 923
integer y = 776
integer width = 357
integer height = 268
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
alignment htextalign = left!
end type

event clicked;String	ls_tarjeta

dw_1.AcceptText()

ls_tarjeta	=	dw_1.Object.cape_codigo[1]

IF Left(ls_tarjeta, 1) = 'E' OR Left(ls_tarjeta, 1) = 'I' THEN
	ls_tarjeta	=	Right(ls_tarjeta, Len(ls_tarjeta) - 3)
END IF

IF NOT IsNull(ls_tarjeta) THEN
	IF ExisteTarjeta(ls_tarjeta) THEN
		istr_mant.Argumento[04]	=	ls_pers_codigo
		istr_mant.Argumento[05]	=	ls_pers_apepat
		istr_mant.Argumento[06]	=	ls_pers_apemat
		istr_mant.Argumento[07]	=	ls_pers_nombre
		istr_mant.Argumento[08]	=	String(ll_pers_nrotar)
		istr_mant.Argumento[09]	=	String(li_cape_invita)
		istr_mant.Argumento[10]	=	String(li_cape_topein)
		istr_mant.Argumento[11]	=	String(ii_zona)
		istr_mant.Argumento[12]	=	String(ii_area)
		
		CloseWithReturn(Parent, istr_mant)
	ELSE
		pb_cancela.TriggerEvent(Clicked!)
	END IF
END IF
end event

type dw_1 from datawindow within w_mant_tarjeta_anfitrion
integer x = 133
integer y = 260
integer width = 3278
integer height = 404
integer taborder = 20
string dataobject = "dw_tarjeta_anfitrion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;pb_acepta.PostEvent(Clicked!)
end event

type sle_1 from singlelineedit within w_mant_tarjeta_anfitrion
integer x = 55
integer y = 192
integer width = 3433
integer height = 540
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 16777215
long backcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

