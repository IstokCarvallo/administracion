$PBExportHeader$w_carga_regularizacion.srw
forward
global type w_carga_regularizacion from w_para_informes
end type
type mle_msg from multilineedit within w_carga_regularizacion
end type
type st_1 from statictext within w_carga_regularizacion
end type
type uo_selzona from uo_seleccion_zonas within w_carga_regularizacion
end type
type uo_seltipo from uo_seleccion_tipocolacion within w_carga_regularizacion
end type
type st_2 from statictext within w_carga_regularizacion
end type
type uo_selcolacion from uo_seleccion_colacion within w_carga_regularizacion
end type
type st_3 from statictext within w_carga_regularizacion
end type
type sle_usuario from singlelineedit within w_carga_regularizacion
end type
type st_4 from statictext within w_carga_regularizacion
end type
type st_5 from statictext within w_carga_regularizacion
end type
type st_6 from statictext within w_carga_regularizacion
end type
type st_7 from statictext within w_carga_regularizacion
end type
type uo_selempresa from uo_seleccion_empresa within w_carga_regularizacion
end type
type uo_selareas from uo_seleccion_areas within w_carga_regularizacion
end type
type uo_selccosto from uo_seleccion_centrocosto within w_carga_regularizacion
end type
type st_8 from statictext within w_carga_regularizacion
end type
type em_cantidad from editmask within w_carga_regularizacion
end type
type em_fecha from editmask within w_carga_regularizacion
end type
type st_9 from statictext within w_carga_regularizacion
end type
end forward

global type w_carga_regularizacion from w_para_informes
integer width = 3383
integer height = 2156
string title = "INFORME DE CONSUMOS DIARIOS"
mle_msg mle_msg
st_1 st_1
uo_selzona uo_selzona
uo_seltipo uo_seltipo
st_2 st_2
uo_selcolacion uo_selcolacion
st_3 st_3
sle_usuario sle_usuario
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
uo_selempresa uo_selempresa
uo_selareas uo_selareas
uo_selccosto uo_selccosto
st_8 st_8
em_cantidad em_cantidad
em_fecha em_fecha
st_9 st_9
end type
global w_carga_regularizacion w_carga_regularizacion

type variables
uo_personacasino	iuo_Personal
end variables

forward prototypes
public subroutine wf_msg (string msg)
public subroutine wf_crearegulariza ()
public function integer wf_secuencia (date fecha, transaction at_transaccion)
public function time wf_horainicio (date fecha, integer tipo)
end prototypes

public subroutine wf_msg (string msg);If IsNull(MSG) Then MSG = ''

mle_MSG.Text += String(Today(), 'dd/mm/yyyy hh:mm:ss') + ' - ' + MSG + '~r~n'
mle_MSG.Scroll(mle_MSG.LineCount())

end subroutine

public subroutine wf_crearegulariza ();Time		lt_Now, lt_Inicio
Date		ad_Fecha
Datetime	ad_FechaProc
Integer	li_Secuencia
	
lt_Now = Now()
ad_Fecha		=	Date(em_Fecha.Text)
ad_FechaProc	=	Datetime(Today(), Now())

li_Secuencia = wf_Secuencia(ad_Fecha, SQLCA)
lt_Inicio = wf_HoraInicio(ad_Fecha, uo_SelTipo.Codigo)

Insert Into dbo.casino_movtocolaciones( zona_codigo,  caar_codigo,  camv_fechac,  camv_secuen, camv_horaco,  cape_codigo,  
														tico_codigo,  caco_codigo, camv_tipope, camv_tdieta, camv_appain, camv_apmain, 
														camv_hormvt,  camv_nominv,  camv_estado,  camv_rutinv,  camv_invcur,clpr_rut,
														camv_nroval, ccos_codigo, usua_codigo, camv_fecham) 
Values (:uo_SelZona.Codigo, :uo_SelAreas.Codigo, :ad_fecha, :li_Secuencia, :lt_Inicio, :iuo_Personal.Rut,
			:uo_SelTipo.Codigo, :uo_SelColacion.Codigo, 1, Null, 'Regularizacion','', 
			:lt_Now, '', 9, '0000000019', 1, :uo_SelEmpresa.Codigo, 
			Null, :uo_SelCCosto.Codigo, :gstr_Us.Nombre, :ad_FechaProc) 
Using SQLCA;
	
If SQLCA.SQLCode = -1 Then
	wf_Msg("No se pudo agregar movimiento de regularizacion: " + SQLCA.SQLErrText)
Else
	wf_Msg("Movimineto de regularizacion Generado:")
End If

end subroutine

public function integer wf_secuencia (date fecha, transaction at_transaccion);Integer	li_secuencia

Select Max(IsNull(camv_secuen, 0))
  Into :li_secuencia 
  From dbo.casino_movtocolaciones
 Where Datediff(dd, camv_fechac, :fecha) = 0
Using at_transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Movimientos de Colación")
	Return 0
Else
	IF IsNull(li_secuencia) Then li_secuencia = 0
	Return li_secuencia + 1
End If
end function

public function time wf_horainicio (date fecha, integer tipo);Time	lt_Retorno

SELECT Min(cahc_horini)
	Into :lt_Retorno
  FROM dbo.casino_horariocolaciones
 WHERE tico_codigo = :Tipo
	AND :Fecha between cahc_fecini and cahc_fecter
    AND datepart(dw, :Fecha) = cahc_nrodia;
	
If SQLCA.SQLCode = -1 Then 
	wf_Msg("Lectura de Tabla Horario de Colación")
	SetNull(lt_Retorno)
End If

Return lt_Retorno
end function

on w_carga_regularizacion.create
int iCurrent
call super::create
this.mle_msg=create mle_msg
this.st_1=create st_1
this.uo_selzona=create uo_selzona
this.uo_seltipo=create uo_seltipo
this.st_2=create st_2
this.uo_selcolacion=create uo_selcolacion
this.st_3=create st_3
this.sle_usuario=create sle_usuario
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.uo_selempresa=create uo_selempresa
this.uo_selareas=create uo_selareas
this.uo_selccosto=create uo_selccosto
this.st_8=create st_8
this.em_cantidad=create em_cantidad
this.em_fecha=create em_fecha
this.st_9=create st_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_msg
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_selzona
this.Control[iCurrent+4]=this.uo_seltipo
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_selcolacion
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_usuario
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.uo_selempresa
this.Control[iCurrent+14]=this.uo_selareas
this.Control[iCurrent+15]=this.uo_selccosto
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.em_cantidad
this.Control[iCurrent+18]=this.em_fecha
this.Control[iCurrent+19]=this.st_9
end on

on w_carga_regularizacion.destroy
call super::destroy
destroy(this.mle_msg)
destroy(this.st_1)
destroy(this.uo_selzona)
destroy(this.uo_seltipo)
destroy(this.st_2)
destroy(this.uo_selcolacion)
destroy(this.st_3)
destroy(this.sle_usuario)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.uo_selempresa)
destroy(this.uo_selareas)
destroy(this.uo_selccosto)
destroy(this.st_8)
destroy(this.em_cantidad)
destroy(this.em_fecha)
destroy(this.st_9)
end on

event open;call super::open;Boolean	lb_Cerrar

If IsNull(uo_SelZona.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelTipo.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelColacion.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelAreas.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelCCosto.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else	
	iuo_Personal	=	Create uo_personacasino
	
	If Not iuo_Personal.of_Existe(gstr_Us.Nombre, True, SQLCA) Then
		Close(This)
		Return
	End If
	
	IF iuo_Personal.Invita <> 1 Then
		MessageBox('Error', 'Usuario no esta registrado para regularizar.')
		Close(This)
		Return
	End If
	
	sle_Usuario.Text	=	gstr_Us.Nombre
	em_Fecha.Text		=	String(Today(), 'dd/mm/yyyy')
	
	uo_SelZona.Seleccion(False, False)
	uo_SelTipo.Seleccion(False, False)
	uo_SelColacion.Seleccion(False, False)
	uo_SelEmpresa.Seleccion(False, False)
	uo_SelAreas.Seleccion(False, False)
	uo_SelCCosto.Seleccion(False, False)
	
	uo_SelZona.Inicia(iuo_Personal.Zona)
	uo_SelTipo.Filtra(iuo_Personal.Zona)
End If
end event

type pb_excel from w_para_informes`pb_excel within w_carga_regularizacion
integer x = 2921
integer y = 440
integer taborder = 40
integer weight = 400
fontcharset fontcharset = ansi!
string picturename = ""
string disabledname = ""
end type

type st_computador from w_para_informes`st_computador within w_carga_regularizacion
integer x = 1102
end type

type st_usuario from w_para_informes`st_usuario within w_carga_regularizacion
integer x = 1102
end type

type st_temporada from w_para_informes`st_temporada within w_carga_regularizacion
integer x = 1102
end type

type p_logo from w_para_informes`p_logo within w_carga_regularizacion
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_carga_regularizacion
integer x = 242
integer width = 2560
integer height = 96
string text = "Carga Regularizacion Alimentacion"
end type

type pb_acepta from w_para_informes`pb_acepta within w_carga_regularizacion
integer x = 2967
integer y = 780
integer height = 240
integer taborder = 50
string picturename = "\Desarrollo 17\Imagenes\Botones\Guardar Todo.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Guardar Todo-bn.png"
end type

event pb_acepta::clicked;call super::clicked;Long	ll_Fila

If IsNull(uo_SelTipo.Codigo) Or uo_SelTipo.Codigo < 0 Then
	MessageBox('Atencion', 'Debe seleccionar un Tipo Colacion')
	Return
End If

If IsNull(uo_SelColacion.Codigo) Or uo_SelColacion.Codigo < 0 Then
	MessageBox('Atencion', 'Debe seleccionar una Colacion')
	Return
End If

If IsNull(uo_SelEmpresa.Codigo) Or uo_SelEmpresa.Codigo = '*' Then
	MessageBox('Atencion', 'Debe seleccionar una Empresa')
	Return
End If

If IsNull(uo_SelAreas.Codigo) Or uo_SelAreas.Codigo < 0 Then
	MessageBox('Atencion', 'Debe seleccionar una Area')
	Return
End If

If IsNull(uo_SelCCosto.Codigo) Or uo_SelCCosto.Codigo < 0 Then
	MessageBox('Atencion', 'Debe seleccionar un Centro de Costo')
	Return
End If

If IsNull(em_Cantidad.Text) Or Integer(em_Cantidad.Text) < 1 Then
	MessageBox('Atencion', 'Debe una cantidad de personas a regularizar.')
	Return
End If

SetPointer(HourGlass!)

uo_SelZona.Habilita(False)
uo_SelTipo.Habilita(False)
uo_SelColacion.Habilita(False)
uo_SelEmpresa.Habilita(False)
uo_SelAreas.Habilita(False)
uo_SelCCosto.Habilita(False)
em_cantidad.Enabled = False

wf_Msg('Comienza proceso de regularizacion de colaciones')

For ll_Fila = 1 To Integer(em_Cantidad.Text)
	wf_CreaRegulariza()
Next

wf_Msg('Termino proceso de regularizacion de colaciones')

SetPointer(Arrow!)
	
end event

type pb_salir from w_para_informes`pb_salir within w_carga_regularizacion
integer x = 2962
integer y = 1088
integer taborder = 60
end type

type mle_msg from multilineedit within w_carga_regularizacion
integer x = 219
integer y = 1112
integer width = 2560
integer height = 872
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean italic = true
long textcolor = 16711680
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_carga_regularizacion
integer x = 256
integer y = 720
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Empresa"
boolean focusrectangle = false
end type

type uo_selzona from uo_seleccion_zonas within w_carga_regularizacion
integer x = 658
integer y = 448
integer width = 878
integer height = 96
integer taborder = 10
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		
	Case Else
		uo_SelTipo.Filtra(This.Codigo)
		
End Choose
end event

type uo_seltipo from uo_seleccion_tipocolacion within w_carga_regularizacion
integer x = 658
integer y = 576
integer width = 878
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_seltipo.destroy
call uo_seleccion_tipocolacion::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		
	Case Else
		uo_SelColacion.Filtra(uo_SelZona.Codigo, This.Codigo)
		
End Choose
end event

type st_2 from statictext within w_carga_regularizacion
integer x = 256
integer y = 848
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Area"
boolean focusrectangle = false
end type

type uo_selcolacion from uo_seleccion_colacion within w_carga_regularizacion
integer x = 1902
integer y = 576
integer width = 878
integer height = 96
integer taborder = 30
boolean bringtotop = true
end type

on uo_selcolacion.destroy
call uo_seleccion_colacion::destroy
end on

type st_3 from statictext within w_carga_regularizacion
integer x = 1573
integer y = 848
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "C. Costo"
boolean focusrectangle = false
end type

type sle_usuario from singlelineedit within w_carga_regularizacion
integer x = 1902
integer y = 448
integer width = 878
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_carga_regularizacion
integer x = 1573
integer y = 464
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Usuario"
boolean focusrectangle = false
end type

type st_5 from statictext within w_carga_regularizacion
integer x = 256
integer y = 464
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Zona"
boolean focusrectangle = false
end type

type st_6 from statictext within w_carga_regularizacion
integer x = 256
integer y = 592
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Tipo Colacion"
boolean focusrectangle = false
end type

type st_7 from statictext within w_carga_regularizacion
integer x = 1573
integer y = 592
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = " Colacion"
boolean focusrectangle = false
end type

type uo_selempresa from uo_seleccion_empresa within w_carga_regularizacion
integer x = 658
integer y = 704
integer width = 878
integer height = 96
integer taborder = 60
boolean bringtotop = true
end type

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case '+', '**'
		
	Case Else
		uo_SelAreas.Filtra(uo_SelZona.Codigo, This.Codigo)
		uo_SelCCosto.Filtra(This.Codigo)
		
End Choose
end event

type uo_selareas from uo_seleccion_areas within w_carga_regularizacion
integer x = 658
integer y = 832
integer width = 878
integer height = 96
integer taborder = 60
boolean bringtotop = true
end type

on uo_selareas.destroy
call uo_seleccion_areas::destroy
end on

type uo_selccosto from uo_seleccion_centrocosto within w_carga_regularizacion
integer x = 1902
integer y = 832
integer width = 878
integer height = 96
integer taborder = 60
boolean bringtotop = true
end type

on uo_selccosto.destroy
call uo_seleccion_centrocosto::destroy
end on

type st_8 from statictext within w_carga_regularizacion
integer x = 1573
integer y = 720
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Cantidad"
boolean focusrectangle = false
end type

type em_cantidad from editmask within w_carga_regularizacion
integer x = 1902
integer y = 696
integer width = 457
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
end type

type em_fecha from editmask within w_carga_regularizacion
integer x = 658
integer y = 960
integer width = 457
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "###"
end type

type st_9 from statictext within w_carga_regularizacion
integer x = 256
integer y = 984
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Fecha"
boolean focusrectangle = false
end type

