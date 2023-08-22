$PBExportHeader$w_info_valorcuota_det.srw
forward
global type w_info_valorcuota_det from w_para_informes
end type
type st_3 from statictext within w_info_valorcuota_det
end type
type st_4 from statictext within w_info_valorcuota_det
end type
type st_5 from statictext within w_info_valorcuota_det
end type
type st_2 from statictext within w_info_valorcuota_det
end type
type uo_selempresa from uo_seleccion_empresa within w_info_valorcuota_det
end type
type uo_selsucursal from uo_seleccion_sucursal within w_info_valorcuota_det
end type
type uo_selseccion from uo_seleccion_seccion within w_info_valorcuota_det
end type
type uo_selnroaca from uo_seleccion_nroaca within w_info_valorcuota_det
end type
type st_1 from statictext within w_info_valorcuota_det
end type
end forward

global type w_info_valorcuota_det from w_para_informes
integer width = 2437
integer height = 1656
string title = "Informe Cuotas Equipos"
st_3 st_3
st_4 st_4
st_5 st_5
st_2 st_2
uo_selempresa uo_selempresa
uo_selsucursal uo_selsucursal
uo_selseccion uo_selseccion
uo_selnroaca uo_selnroaca
st_1 st_1
end type
global w_info_valorcuota_det w_info_valorcuota_det

type variables

end variables

on w_info_valorcuota_det.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_2=create st_2
this.uo_selempresa=create uo_selempresa
this.uo_selsucursal=create uo_selsucursal
this.uo_selseccion=create uo_selseccion
this.uo_selnroaca=create uo_selnroaca
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_selempresa
this.Control[iCurrent+6]=this.uo_selsucursal
this.Control[iCurrent+7]=this.uo_selseccion
this.Control[iCurrent+8]=this.uo_selnroaca
this.Control[iCurrent+9]=this.st_1
end on

on w_info_valorcuota_det.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.uo_selempresa)
destroy(this.uo_selsucursal)
destroy(this.uo_selseccion)
destroy(this.uo_selnroaca)
destroy(this.st_1)
end on

event open;call super::open;Boolean lb_Cerrar = False

If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelSucursal.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelSeccion.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelNroACA.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	uo_SelEmpresa.Seleccion(True, True)
	uo_SelSucursal.Seleccion(True, True)
	uo_SelSeccion.Seleccion(True, True)
	uo_SelNroACA.Seleccion(True, False)
End If
end event

type pb_excel from w_para_informes`pb_excel within w_info_valorcuota_det
integer x = 1856
integer y = 256
end type

type st_computador from w_para_informes`st_computador within w_info_valorcuota_det
end type

type st_usuario from w_para_informes`st_usuario within w_info_valorcuota_det
end type

type st_temporada from w_para_informes`st_temporada within w_info_valorcuota_det
end type

type p_logo from w_para_informes`p_logo within w_info_valorcuota_det
integer height = 292
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_valorcuota_det
integer width = 1431
string text = "Valor Cuota Equipos"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_valorcuota_det
integer x = 1943
integer y = 556
end type

event pb_acepta::clicked;Long		Fila, li_Historia

istr_info.titulo	= "VALOR CUOTA EQUIPOS DETALLE"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_valorcuotaequipo_det"
vinf.dw_1.SetTransObject(sqlca)

Fila = vinf.dw_1.Retrieve(uo_SelEmpresa.Codigo, uo_SelSucursal.Codigo, uo_SelSeccion.Codigo, uo_SelNroACA.Codigo)
If Fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf Fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.",  StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Zoom = 92')
	If Not gs_Ambiente = 'Windows' Then F_ImprimeInformePdf(vinf.dw_1,istr_info.titulo)
End If
end event

type pb_salir from w_para_informes`pb_salir within w_info_valorcuota_det
integer x = 1943
integer y = 920
end type

type st_3 from statictext within w_info_valorcuota_det
integer x = 302
integer y = 612
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Empresa"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_info_valorcuota_det
integer x = 302
integer y = 860
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Sucursal"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_info_valorcuota_det
integer x = 302
integer y = 1108
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Seccion"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_info_valorcuota_det
integer x = 251
integer y = 472
integer width = 1431
integer height = 1004
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16711680
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_selempresa from uo_seleccion_empresa within w_info_valorcuota_det
integer x = 649
integer y = 516
integer taborder = 20
boolean bringtotop = true
end type

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		uo_SelSeccion.Filtra(-1)
		uo_SelSeccion.Todos(True)
		uo_SelSeccion.LimpiarDatos()
		uo_SelSeccion.Bloquear(True)
		
	Case Else
		uo_SelSeccion.Bloquear(False)
		uo_SelSeccion.Filtra(This.Codigo)
		
End Choose
end event

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

type uo_selsucursal from uo_seleccion_sucursal within w_info_valorcuota_det
integer x = 649
integer y = 764
integer taborder = 20
boolean bringtotop = true
end type

on uo_selsucursal.destroy
call uo_seleccion_sucursal::destroy
end on

type uo_selseccion from uo_seleccion_seccion within w_info_valorcuota_det
integer x = 649
integer y = 1012
integer taborder = 40
boolean bringtotop = true
end type

on uo_selseccion.destroy
call uo_seleccion_seccion::destroy
end on

type uo_selnroaca from uo_seleccion_nroaca within w_info_valorcuota_det
integer x = 649
integer y = 1260
integer taborder = 50
boolean bringtotop = true
end type

on uo_selnroaca.destroy
call uo_seleccion_nroaca::destroy
end on

type st_1 from statictext within w_info_valorcuota_det
integer x = 302
integer y = 1364
integer width = 343
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Nro. ACA"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

