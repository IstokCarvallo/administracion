$PBExportHeader$w_info_detalleequipos.srw
forward
global type w_info_detalleequipos from w_para_informes
end type
type gb_3 from groupbox within w_info_detalleequipos
end type
type em_desde from editmask within w_info_detalleequipos
end type
type st_1 from statictext within w_info_detalleequipos
end type
type st_2 from statictext within w_info_detalleequipos
end type
type uo_selempresa from uo_seleccion_empresa within w_info_detalleequipos
end type
type uo_selmarca from uo_seleccion_marca within w_info_detalleequipos
end type
type uo_selproveedor from uo_seleccion_proveedor within w_info_detalleequipos
end type
type uo_seltipo from uo_seleccion_tipoequipos within w_info_detalleequipos
end type
type em_hasta from editmask within w_info_detalleequipos
end type
type st_3 from statictext within w_info_detalleequipos
end type
type st_4 from statictext within w_info_detalleequipos
end type
type st_5 from statictext within w_info_detalleequipos
end type
type st_7 from statictext within w_info_detalleequipos
end type
type st_8 from statictext within w_info_detalleequipos
end type
type rb_propio from radiobutton within w_info_detalleequipos
end type
type rb_arriendo from radiobutton within w_info_detalleequipos
end type
type st_6 from statictext within w_info_detalleequipos
end type
type rb_ambos from radiobutton within w_info_detalleequipos
end type
type st_9 from statictext within w_info_detalleequipos
end type
type cbx_estado from checkbox within w_info_detalleequipos
end type
type ddlb_estado from dropdownlistbox within w_info_detalleequipos
end type
end forward

global type w_info_detalleequipos from w_para_informes
integer width = 3680
integer height = 1540
string title = "Informe Detalle Equipos"
gb_3 gb_3
em_desde em_desde
st_1 st_1
st_2 st_2
uo_selempresa uo_selempresa
uo_selmarca uo_selmarca
uo_selproveedor uo_selproveedor
uo_seltipo uo_seltipo
em_hasta em_hasta
st_3 st_3
st_4 st_4
st_5 st_5
st_7 st_7
st_8 st_8
rb_propio rb_propio
rb_arriendo rb_arriendo
st_6 st_6
rb_ambos rb_ambos
st_9 st_9
cbx_estado cbx_estado
ddlb_estado ddlb_estado
end type
global w_info_detalleequipos w_info_detalleequipos

type variables
Integer ii_Estado
end variables

on w_info_detalleequipos.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.em_desde=create em_desde
this.st_1=create st_1
this.st_2=create st_2
this.uo_selempresa=create uo_selempresa
this.uo_selmarca=create uo_selmarca
this.uo_selproveedor=create uo_selproveedor
this.uo_seltipo=create uo_seltipo
this.em_hasta=create em_hasta
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_7=create st_7
this.st_8=create st_8
this.rb_propio=create rb_propio
this.rb_arriendo=create rb_arriendo
this.st_6=create st_6
this.rb_ambos=create rb_ambos
this.st_9=create st_9
this.cbx_estado=create cbx_estado
this.ddlb_estado=create ddlb_estado
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.em_desde
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_selempresa
this.Control[iCurrent+6]=this.uo_selmarca
this.Control[iCurrent+7]=this.uo_selproveedor
this.Control[iCurrent+8]=this.uo_seltipo
this.Control[iCurrent+9]=this.em_hasta
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.st_8
this.Control[iCurrent+15]=this.rb_propio
this.Control[iCurrent+16]=this.rb_arriendo
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.rb_ambos
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.cbx_estado
this.Control[iCurrent+21]=this.ddlb_estado
end on

on w_info_detalleequipos.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.uo_selempresa)
destroy(this.uo_selmarca)
destroy(this.uo_selproveedor)
destroy(this.uo_seltipo)
destroy(this.em_hasta)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.rb_propio)
destroy(this.rb_arriendo)
destroy(this.st_6)
destroy(this.rb_ambos)
destroy(this.st_9)
destroy(this.cbx_estado)
destroy(this.ddlb_estado)
end on

event open;call super::open;Boolean lb_Cerrar = False

If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelMarca.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelProveedor.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelTipo.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	em_Desde.Text ='01/01/2010'
	em_Hasta.Text = String(Today(), 'dd/mm/yyyy')
End If
end event

type pb_excel from w_para_informes`pb_excel within w_info_detalleequipos
integer x = 3168
integer y = 224
end type

type st_computador from w_para_informes`st_computador within w_info_detalleequipos
end type

type st_usuario from w_para_informes`st_usuario within w_info_detalleequipos
end type

type st_temporada from w_para_informes`st_temporada within w_info_detalleequipos
end type

type p_logo from w_para_informes`p_logo within w_info_detalleequipos
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_detalleequipos
integer width = 2866
string text = "Detalle de Equipos"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_detalleequipos
integer x = 3264
integer y = 560
end type

event pb_acepta::clicked;Long		fila, ll_Propiedad

istr_info.titulo	= "DETALLE DE EQUIPOS"
istr_info.copias	= 1

If rb_Ambos.Checked Then
	ll_Propiedad = -1
ElseIf rb_Propio.Checked Then
	ll_Propiedad = 0
Else
	ll_Propiedad = 1
End If

If cbx_estado.Checked Then
	ii_Estado = -1
End If

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_equipodetalle"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(uo_SelEmpresa.Codigo, uo_SelMarca.Codigo, uo_SelProveedor.Codigo, DateTime(em_Desde.Text), &
							DateTime(em_Hasta.Text), ll_Propiedad, uo_SelTipo.Codigo, ii_Estado)

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.",  StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')
	vinf.dw_1.Modify('DataWindow.Zoom = 93')
	
	If Not gs_Ambiente = 'Windows' Then F_ImprimeInformePdf(vinf.dw_1,istr_info.titulo)
End If
end event

type pb_salir from w_para_informes`pb_salir within w_info_detalleequipos
integer x = 3264
integer y = 924
end type

type gb_3 from groupbox within w_info_detalleequipos
integer x = 1719
integer y = 1072
integer width = 1362
integer height = 204
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

type em_desde from editmask within w_info_detalleequipos
integer x = 2011
integer y = 1140
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

type st_1 from statictext within w_info_detalleequipos
integer x = 1778
integer y = 1160
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

type st_2 from statictext within w_info_detalleequipos
integer x = 251
integer y = 472
integer width = 1431
integer height = 832
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

type uo_selempresa from uo_seleccion_empresa within w_info_detalleequipos
integer x = 677
integer y = 524
integer taborder = 20
boolean bringtotop = true
end type

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

type uo_selmarca from uo_seleccion_marca within w_info_detalleequipos
integer x = 677
integer y = 764
integer taborder = 30
boolean bringtotop = true
end type

on uo_selmarca.destroy
call uo_seleccion_marca::destroy
end on

type uo_selproveedor from uo_seleccion_proveedor within w_info_detalleequipos
integer x = 677
integer y = 1012
integer taborder = 30
boolean bringtotop = true
end type

on uo_selproveedor.destroy
call uo_seleccion_proveedor::destroy
end on

type uo_seltipo from uo_seleccion_tipoequipos within w_info_detalleequipos
integer x = 2149
integer y = 524
integer taborder = 40
boolean bringtotop = true
end type

on uo_seltipo.destroy
call uo_seleccion_tipoequipos::destroy
end on

type em_hasta from editmask within w_info_detalleequipos
integer x = 2642
integer y = 1140
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

type st_3 from statictext within w_info_detalleequipos
integer x = 334
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

type st_4 from statictext within w_info_detalleequipos
integer x = 329
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
string text = "Marca"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_info_detalleequipos
integer x = 334
integer y = 1108
integer width = 357
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
string text = "Proveedor"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_7 from statictext within w_info_detalleequipos
integer x = 1755
integer y = 608
integer width = 361
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
string text = "Tipo Equipo"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_8 from statictext within w_info_detalleequipos
integer x = 2441
integer y = 1160
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

type rb_propio from radiobutton within w_info_detalleequipos
integer x = 1755
integer y = 956
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Propio"
end type

type rb_arriendo from radiobutton within w_info_detalleequipos
integer x = 2144
integer y = 956
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Arriendo"
end type

type st_6 from statictext within w_info_detalleequipos
integer x = 1682
integer y = 472
integer width = 1431
integer height = 832
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

type rb_ambos from radiobutton within w_info_detalleequipos
integer x = 2615
integer y = 956
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Ambos"
boolean checked = true
end type

type st_9 from statictext within w_info_detalleequipos
integer x = 1755
integer y = 840
integer width = 315
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
string text = "Estado Eq."
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_estado from checkbox within w_info_detalleequipos
integer x = 2158
integer y = 716
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

type ddlb_estado from dropdownlistbox within w_info_detalleequipos
integer x = 2158
integer y = 824
integer width = 896
integer height = 400
integer taborder = 50
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

