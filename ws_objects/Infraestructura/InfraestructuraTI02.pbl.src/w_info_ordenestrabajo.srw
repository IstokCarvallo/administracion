$PBExportHeader$w_info_ordenestrabajo.srw
forward
global type w_info_ordenestrabajo from w_para_informes
end type
type gb_3 from groupbox within w_info_ordenestrabajo
end type
type em_desde from editmask within w_info_ordenestrabajo
end type
type st_1 from statictext within w_info_ordenestrabajo
end type
type st_2 from statictext within w_info_ordenestrabajo
end type
type uo_selproveedor from uo_seleccion_proveedor within w_info_ordenestrabajo
end type
type em_hasta from editmask within w_info_ordenestrabajo
end type
type st_4 from statictext within w_info_ordenestrabajo
end type
type st_5 from statictext within w_info_ordenestrabajo
end type
type st_8 from statictext within w_info_ordenestrabajo
end type
type rb_propio from radiobutton within w_info_ordenestrabajo
end type
type rb_arriendo from radiobutton within w_info_ordenestrabajo
end type
type rb_ambos from radiobutton within w_info_ordenestrabajo
end type
type uo_selmoneda from uo_seleccion_monedas within w_info_ordenestrabajo
end type
type gb_4 from groupbox within w_info_ordenestrabajo
end type
type st_6 from statictext within w_info_ordenestrabajo
end type
end forward

global type w_info_ordenestrabajo from w_para_informes
integer width = 3621
integer height = 1420
string title = "Informe Ordenes Trabajo"
gb_3 gb_3
em_desde em_desde
st_1 st_1
st_2 st_2
uo_selproveedor uo_selproveedor
em_hasta em_hasta
st_4 st_4
st_5 st_5
st_8 st_8
rb_propio rb_propio
rb_arriendo rb_arriendo
rb_ambos rb_ambos
uo_selmoneda uo_selmoneda
gb_4 gb_4
st_6 st_6
end type
global w_info_ordenestrabajo w_info_ordenestrabajo

on w_info_ordenestrabajo.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.em_desde=create em_desde
this.st_1=create st_1
this.st_2=create st_2
this.uo_selproveedor=create uo_selproveedor
this.em_hasta=create em_hasta
this.st_4=create st_4
this.st_5=create st_5
this.st_8=create st_8
this.rb_propio=create rb_propio
this.rb_arriendo=create rb_arriendo
this.rb_ambos=create rb_ambos
this.uo_selmoneda=create uo_selmoneda
this.gb_4=create gb_4
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.em_desde
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_selproveedor
this.Control[iCurrent+6]=this.em_hasta
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.rb_propio
this.Control[iCurrent+11]=this.rb_arriendo
this.Control[iCurrent+12]=this.rb_ambos
this.Control[iCurrent+13]=this.uo_selmoneda
this.Control[iCurrent+14]=this.gb_4
this.Control[iCurrent+15]=this.st_6
end on

on w_info_ordenestrabajo.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.uo_selproveedor)
destroy(this.em_hasta)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_8)
destroy(this.rb_propio)
destroy(this.rb_arriendo)
destroy(this.rb_ambos)
destroy(this.uo_selmoneda)
destroy(this.gb_4)
destroy(this.st_6)
end on

event open;call super::open;Boolean lb_Cerrar = False

If IsNull(uo_SelProveedor.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelMoneda.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	em_Desde.Text = '01/01/2010'
	em_Hasta.Text = String(Today(), 'dd/mm/yyyy')
End If
end event

type pb_excel from w_para_informes`pb_excel within w_info_ordenestrabajo
integer x = 3259
integer y = 208
end type

type st_computador from w_para_informes`st_computador within w_info_ordenestrabajo
end type

type st_usuario from w_para_informes`st_usuario within w_info_ordenestrabajo
end type

type st_temporada from w_para_informes`st_temporada within w_info_ordenestrabajo
end type

type p_logo from w_para_informes`p_logo within w_info_ordenestrabajo
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_ordenestrabajo
integer width = 2866
string text = "Ordenes de Trabajo"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_ordenestrabajo
integer x = 3264
integer y = 560
integer height = 204
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

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_ordentrabajo"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(-1, uo_SelMoneda.Codigo, uo_SelProveedor.Codigo, ll_Propiedad, DateTime(em_Desde.Text), &
							DateTime(em_Hasta.Text))

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.",  StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	If Not gs_Ambiente = 'Windows' Then F_ImprimeInformePdf(vinf.dw_1,istr_info.titulo)
End If
end event

type pb_salir from w_para_informes`pb_salir within w_info_ordenestrabajo
integer x = 3264
integer y = 924
end type

type gb_3 from groupbox within w_info_ordenestrabajo
integer x = 1719
integer y = 852
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
string text = " Fecha Orden Trabajo"
end type

type em_desde from editmask within w_info_ordenestrabajo
integer x = 2011
integer y = 956
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

type st_1 from statictext within w_info_ordenestrabajo
integer x = 1778
integer y = 976
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

type st_2 from statictext within w_info_ordenestrabajo
integer x = 251
integer y = 472
integer width = 1431
integer height = 644
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

type uo_selproveedor from uo_seleccion_proveedor within w_info_ordenestrabajo
integer x = 677
integer y = 864
integer taborder = 30
boolean bringtotop = true
end type

on uo_selproveedor.destroy
call uo_seleccion_proveedor::destroy
end on

type em_hasta from editmask within w_info_ordenestrabajo
integer x = 2642
integer y = 956
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

type st_4 from statictext within w_info_ordenestrabajo
integer x = 329
integer y = 664
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
string text = "Moneda"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_info_ordenestrabajo
integer x = 334
integer y = 960
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

type st_8 from statictext within w_info_ordenestrabajo
integer x = 2441
integer y = 976
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

type rb_propio from radiobutton within w_info_ordenestrabajo
integer x = 1778
integer y = 656
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

type rb_arriendo from radiobutton within w_info_ordenestrabajo
integer x = 2167
integer y = 656
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
string text = "Tercero"
end type

type rb_ambos from radiobutton within w_info_ordenestrabajo
integer x = 2638
integer y = 656
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

type uo_selmoneda from uo_seleccion_monedas within w_info_ordenestrabajo
integer x = 677
integer y = 564
integer taborder = 20
boolean bringtotop = true
end type

on uo_selmoneda.destroy
call uo_seleccion_monedas::destroy
end on

type gb_4 from groupbox within w_info_ordenestrabajo
integer x = 1719
integer y = 564
integer width = 1362
integer height = 232
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = " Tipo Orden Trabajo"
end type

type st_6 from statictext within w_info_ordenestrabajo
integer x = 1682
integer y = 472
integer width = 1431
integer height = 644
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

