$PBExportHeader$w_info_personalequipos.srw
forward
global type w_info_personalequipos from w_para_informes
end type
type gb_3 from groupbox within w_info_personalequipos
end type
type em_desde from editmask within w_info_personalequipos
end type
type st_1 from statictext within w_info_personalequipos
end type
type st_2 from statictext within w_info_personalequipos
end type
type uo_selempresa from uo_seleccion_empresa within w_info_personalequipos
end type
type em_hasta from editmask within w_info_personalequipos
end type
type st_3 from statictext within w_info_personalequipos
end type
type st_4 from statictext within w_info_personalequipos
end type
type st_5 from statictext within w_info_personalequipos
end type
type st_8 from statictext within w_info_personalequipos
end type
type st_6 from statictext within w_info_personalequipos
end type
type uo_selsucursal from uo_seleccion_sucursal within w_info_personalequipos
end type
type uo_selcolaborador from uo_seleccion_colaborador within w_info_personalequipos
end type
type ddlb_estado from dropdownlistbox within w_info_personalequipos
end type
type st_7 from statictext within w_info_personalequipos
end type
type cbx_estado from checkbox within w_info_personalequipos
end type
type cbx_historia from checkbox within w_info_personalequipos
end type
end forward

global type w_info_personalequipos from w_para_informes
integer width = 3621
integer height = 1416
string title = "Informe Personal / Equipos"
gb_3 gb_3
em_desde em_desde
st_1 st_1
st_2 st_2
uo_selempresa uo_selempresa
em_hasta em_hasta
st_3 st_3
st_4 st_4
st_5 st_5
st_8 st_8
st_6 st_6
uo_selsucursal uo_selsucursal
uo_selcolaborador uo_selcolaborador
ddlb_estado ddlb_estado
st_7 st_7
cbx_estado cbx_estado
cbx_historia cbx_historia
end type
global w_info_personalequipos w_info_personalequipos

type variables
Integer	ii_Estado = -1
end variables

on w_info_personalequipos.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.em_desde=create em_desde
this.st_1=create st_1
this.st_2=create st_2
this.uo_selempresa=create uo_selempresa
this.em_hasta=create em_hasta
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_8=create st_8
this.st_6=create st_6
this.uo_selsucursal=create uo_selsucursal
this.uo_selcolaborador=create uo_selcolaborador
this.ddlb_estado=create ddlb_estado
this.st_7=create st_7
this.cbx_estado=create cbx_estado
this.cbx_historia=create cbx_historia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.em_desde
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_selempresa
this.Control[iCurrent+6]=this.em_hasta
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_8
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.uo_selsucursal
this.Control[iCurrent+13]=this.uo_selcolaborador
this.Control[iCurrent+14]=this.ddlb_estado
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.cbx_estado
this.Control[iCurrent+17]=this.cbx_historia
end on

on w_info_personalequipos.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.uo_selempresa)
destroy(this.em_hasta)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_8)
destroy(this.st_6)
destroy(this.uo_selsucursal)
destroy(this.uo_selcolaborador)
destroy(this.ddlb_estado)
destroy(this.st_7)
destroy(this.cbx_estado)
destroy(this.cbx_historia)
end on

event open;call super::open;Boolean lb_Cerrar = False

If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelSucursal.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelColaborador.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	em_Desde.Text = '01/01/2010'
	em_Hasta.Text = String(Today(), 'dd/mm/yyyy')
End If
end event

type pb_excel from w_para_informes`pb_excel within w_info_personalequipos
integer x = 3163
integer y = 180
end type

type st_computador from w_para_informes`st_computador within w_info_personalequipos
end type

type st_usuario from w_para_informes`st_usuario within w_info_personalequipos
end type

type st_temporada from w_para_informes`st_temporada within w_info_personalequipos
end type

type p_logo from w_para_informes`p_logo within w_info_personalequipos
integer height = 292
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_personalequipos
integer width = 2866
string text = "Detalle de Equipos"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_personalequipos
integer x = 3250
integer y = 480
end type

event pb_acepta::clicked;Long		Fila, li_Historia

istr_info.titulo	= "PERSONAL / EQUIPOS"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_personalequipo"
vinf.dw_1.SetTransObject(sqlca)

If cbx_estado.Checked Then ii_Estado = -1
If cbx_Historia.Checked Then 
	li_Historia = -1
Else
	li_Historia = 1
End If

Fila = vinf.dw_1.Retrieve(uo_SelColaborador.Codigo, uo_SelEmpresa.Codigo, uo_SelSucursal.Codigo, &
										DateTime(em_Desde.Text), DateTime(em_Hasta.Text), ii_Estado, li_Historia)
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

type pb_salir from w_para_informes`pb_salir within w_info_personalequipos
integer x = 3250
integer y = 844
end type

type gb_3 from groupbox within w_info_personalequipos
integer x = 1719
integer y = 904
integer width = 1362
integer height = 244
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = " Fecha Adquisicion "
end type

type em_desde from editmask within w_info_personalequipos
integer x = 2011
integer y = 992
integer width = 407
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_info_personalequipos
integer x = 1778
integer y = 1012
integer width = 206
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
string text = "Desde"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_info_personalequipos
integer x = 251
integer y = 472
integer width = 1431
integer height = 760
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

type uo_selempresa from uo_seleccion_empresa within w_info_personalequipos
integer x = 677
integer y = 524
integer taborder = 20
boolean bringtotop = true
end type

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

type em_hasta from editmask within w_info_personalequipos
integer x = 2642
integer y = 992
integer width = 407
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_3 from statictext within w_info_personalequipos
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

type st_4 from statictext within w_info_personalequipos
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

type st_5 from statictext within w_info_personalequipos
integer x = 302
integer y = 1084
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
string text = "Colaborador"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_8 from statictext within w_info_personalequipos
integer x = 2441
integer y = 1012
integer width = 187
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
string text = "Hasta"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_6 from statictext within w_info_personalequipos
integer x = 1682
integer y = 472
integer width = 1431
integer height = 760
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

type uo_selsucursal from uo_seleccion_sucursal within w_info_personalequipos
integer x = 677
integer y = 764
integer taborder = 40
boolean bringtotop = true
end type

on uo_selsucursal.destroy
call uo_seleccion_sucursal::destroy
end on

type uo_selcolaborador from uo_seleccion_colaborador within w_info_personalequipos
integer x = 677
integer y = 1004
integer taborder = 30
boolean bringtotop = true
end type

on uo_selcolaborador.destroy
call uo_seleccion_colaborador::destroy
end on

type ddlb_estado from dropdownlistbox within w_info_personalequipos
integer x = 2025
integer y = 604
integer width = 896
integer height = 400
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
boolean vscrollbar = true
string item[] = {"Activo","Asignado","Mantencion","de Baja","Robo","Venta","Traslado","Devolucion Proveedor"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_Estado = Index - 1
end event

type st_7 from statictext within w_info_personalequipos
integer x = 1728
integer y = 620
integer width = 247
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
string text = "Estado"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_estado from checkbox within w_info_personalequipos
integer x = 2025
integer y = 496
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Todos"
boolean checked = true
end type

event clicked;If This.Checked Then
	ddlb_estado.Enabled = False
Else
	ddlb_estado.Enabled = True
End If
end event

type cbx_historia from checkbox within w_info_personalequipos
integer x = 1728
integer y = 748
integer width = 357
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Historico"
boolean checked = true
boolean lefttext = true
end type

