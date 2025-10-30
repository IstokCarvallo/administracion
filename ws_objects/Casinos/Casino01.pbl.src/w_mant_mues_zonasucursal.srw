$PBExportHeader$w_mant_mues_zonasucursal.srw
$PBExportComments$Mantención de Registro Precios de Venta.
forward
global type w_mant_mues_zonasucursal from w_mant_directo
end type
type uo_selzonas from uo_seleccion_zonas within w_mant_mues_zonasucursal
end type
type uo_selempresa from uo_seleccion_empresa within w_mant_mues_zonasucursal
end type
type st_1 from statictext within w_mant_mues_zonasucursal
end type
type st_2 from statictext within w_mant_mues_zonasucursal
end type
end forward

global type w_mant_mues_zonasucursal from w_mant_directo
integer width = 2478
string title = "Zona Sucursales"
uo_selzonas uo_selzonas
uo_selempresa uo_selempresa
st_1 st_1
st_2 st_2
end type
global w_mant_mues_zonasucursal w_mant_mues_zonasucursal

type variables
DatawindowCHild idwc_Sucursal
end variables

event ue_imprimir;Long		ll_Fila
str_info	lstr_info

lstr_info.titulo	= "INFORME TURNOS"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "w_info_turno"
vinf.dw_1.SetTransObject(sqlca)

ll_Fila	=	vinf.dw_1.Retrieve()

If ll_Fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf ll_Fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	If gs_Ambiente <> 'Windows' Then F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo	)
End If

SetPointer(Arrow!)

end event

event ue_recuperadatos;Long		ll_Filas

ll_Filas	=	dw_1.Retrieve(uo_SelZonas.Codigo, uo_SelEmpresa.Codigo)

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")
	dw_1.SetRedraw(True)
	Return
Else
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
		
	If ll_Filas > 0 Then
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
	Else
		pb_insertar.SetFocus()
	End If
End If
end event

on w_mant_mues_zonasucursal.create
int iCurrent
call super::create
this.uo_selzonas=create uo_selzonas
this.uo_selempresa=create uo_selempresa
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_selzonas
this.Control[iCurrent+2]=this.uo_selempresa
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
end on

on w_mant_mues_zonasucursal.destroy
call super::destroy
destroy(this.uo_selzonas)
destroy(this.uo_selempresa)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;call super::open;Boolean lb_Cerrar

If IsNull(uo_SelZonas.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	uo_SelZonas.Seleccion(False, False)
	uo_SelEmpresa.Seleccion(False, False)
	
	dw_1.GetChild("sucu_codigo", idwc_Sucursal)
	idwc_Sucursal.SetTransObject(Sqlca)
	idwc_Sucursal.Retrieve("*")
	
End If
end event

event ue_antesguardar;call super::ue_antesguardar;Long	ll_Fila

For ll_Fila = 1 To dw_1.RowCount()
	dw_1.Object.empr_codigo[ll_Fila] = uo_SelEmpresa.Codigo
	dw_1.Object.zona_codigo[ll_Fila] = uo_SelZonas.Codigo
Next

end event

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_zonasucursal
boolean visible = false
integer x = 73
integer y = 64
integer width = 1609
integer height = 352
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_zonasucursal
integer x = 1902
integer y = 448
integer taborder = 50
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_zonasucursal
integer x = 1902
integer y = 224
integer taborder = 30
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_zonasucursal
integer x = 1975
integer y = 640
integer taborder = 70
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_zonasucursal
integer x = 2011
integer y = 896
integer taborder = 60
boolean enabled = true
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_zonasucursal
integer x = 1829
integer y = 1792
integer taborder = 100
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_zonasucursal
boolean visible = false
integer x = 1938
integer y = 1408
integer taborder = 90
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_zonasucursal
integer x = 1938
integer y = 1184
integer taborder = 80
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_zonasucursal
integer x = 73
integer y = 448
integer width = 1609
integer height = 1664
integer taborder = 40
string title = "Valores de Colaciones"
string dataobject = "dw_mant_mues_zonasucursal"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type uo_selzonas from uo_seleccion_zonas within w_mant_mues_zonasucursal
integer x = 549
integer y = 128
integer width = 878
integer height = 96
integer taborder = 40
boolean bringtotop = true
end type

on uo_selzonas.destroy
call uo_seleccion_zonas::destroy
end on

type uo_selempresa from uo_seleccion_empresa within w_mant_mues_zonasucursal
integer x = 549
integer y = 256
integer width = 878
integer height = 96
integer taborder = 40
boolean bringtotop = true
end type

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return 

idwc_Sucursal.Retrieve(This.Codigo)
end event

type st_1 from statictext within w_mant_mues_zonasucursal
integer x = 183
integer y = 160
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Zona"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mant_mues_zonasucursal
integer x = 183
integer y = 288
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Empresa"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

