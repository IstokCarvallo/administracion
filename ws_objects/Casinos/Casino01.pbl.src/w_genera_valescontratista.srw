$PBExportHeader$w_genera_valescontratista.srw
forward
global type w_genera_valescontratista from w_para_informes
end type
type st_3 from statictext within w_genera_valescontratista
end type
type uo_selzona from uo_seleccion_zonas within w_genera_valescontratista
end type
type uo_selproveedor from uo_seleccion_clienprove within w_genera_valescontratista
end type
type ddlb_ubicacion from dropdownlistbox within w_genera_valescontratista
end type
type st_1 from statictext within w_genera_valescontratista
end type
type st_2 from statictext within w_genera_valescontratista
end type
type st_4 from statictext within w_genera_valescontratista
end type
type st_5 from statictext within w_genera_valescontratista
end type
type em_cantidad from editmask within w_genera_valescontratista
end type
type dw_1 from uo_dw within w_genera_valescontratista
end type
type em_ultimo from editmask within w_genera_valescontratista
end type
type st_6 from statictext within w_genera_valescontratista
end type
end forward

global type w_genera_valescontratista from w_para_informes
integer width = 2290
integer height = 1224
string title = "EMISION VALES CONTRATISTA"
st_3 st_3
uo_selzona uo_selzona
uo_selproveedor uo_selproveedor
ddlb_ubicacion ddlb_ubicacion
st_1 st_1
st_2 st_2
st_4 st_4
st_5 st_5
em_cantidad em_cantidad
dw_1 dw_1
em_ultimo em_ultimo
st_6 st_6
end type
global w_genera_valescontratista w_genera_valescontratista

type variables
uo_valescontratista	iuo_Vales
end variables

on w_genera_valescontratista.create
int iCurrent
call super::create
this.st_3=create st_3
this.uo_selzona=create uo_selzona
this.uo_selproveedor=create uo_selproveedor
this.ddlb_ubicacion=create ddlb_ubicacion
this.st_1=create st_1
this.st_2=create st_2
this.st_4=create st_4
this.st_5=create st_5
this.em_cantidad=create em_cantidad
this.dw_1=create dw_1
this.em_ultimo=create em_ultimo
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.uo_selzona
this.Control[iCurrent+3]=this.uo_selproveedor
this.Control[iCurrent+4]=this.ddlb_ubicacion
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.em_cantidad
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.em_ultimo
this.Control[iCurrent+12]=this.st_6
end on

on w_genera_valescontratista.destroy
call super::destroy
destroy(this.st_3)
destroy(this.uo_selzona)
destroy(this.uo_selproveedor)
destroy(this.ddlb_ubicacion)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.em_cantidad)
destroy(this.dw_1)
destroy(this.em_ultimo)
destroy(this.st_6)
end on

event open;call super::open;Boolean	lb_Cerrar

IF IsNull(uo_SelZona.Codigo) THEN lb_Cerrar	=	True
IF IsNull(uo_SelProveedor.Codigo) THEN lb_Cerrar	=	True

IF lb_Cerrar THEN
	Close(This)
ELSE
	uo_SelZona.Seleccion(False,False)
	uo_SelProveedor.Seleccion(False,False)
	uo_SelZona.Inicia(100)
	ddlb_ubicacion.SelectItem(1)
	
	iuo_Vales = Create uo_valescontratista
	dw_1.SetTransObject(Sqlca)
	
END IF
end event

type pb_excel from w_para_informes`pb_excel within w_genera_valescontratista
end type

type st_computador from w_para_informes`st_computador within w_genera_valescontratista
end type

type st_usuario from w_para_informes`st_usuario within w_genera_valescontratista
end type

type st_temporada from w_para_informes`st_temporada within w_genera_valescontratista
end type

type p_logo from w_para_informes`p_logo within w_genera_valescontratista
integer width = 791
integer height = 216
end type

type st_titulo from w_para_informes`st_titulo within w_genera_valescontratista
integer width = 1458
string text = "Emisión Vales Contratista"
end type

type pb_acepta from w_para_informes`pb_acepta within w_genera_valescontratista
string tag = "Emite Vales"
integer x = 1870
integer y = 552
integer taborder = 40
string picturename = "\Desarrollo 17\Imagenes\Botones\Guardar Como.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Guardar Como-bn.png"
end type

event pb_acepta::clicked;Long		ll_Cantidad
String	ls_sufijo

If IsNull(uo_SelZona.Codigo) Then 
	MessageBox('Alerta', 'Debe ingresar una zona.')
	Return
End If

If IsNull(uo_SelProveedor.Codigo) Then 
	MessageBox('Alerta', 'Debe ingresar una Proveedor.')
	Return
End If

ll_Cantidad	=	Long(em_cantidad.Text)

If dw_1.Retrieve(uo_SelZona.Codigo, uo_SelProveedor.Codigo, ll_Cantidad) = -1 Then
	F_ErrorBaseDatos(sqlca, "Generación de Vales.")
	Return
Else
	
	dw_1.SetSort("vact_numero asc")
	dw_1.Sort()
	
	DO WHILE dw_1.RowCount() > 0
		
		IF dw_1.RowCount() < 16 THEN
			ll_cantidad	=	dw_1.RowCount()
		ELSE
			ll_cantidad	=	16
		END IF
		
		dw_1.SetFilter("vact_numero <= " + String(dw_1.Object.vact_numero[ll_cantidad]))
		dw_1.Filter()
		
		FOR ll_cantidad = 1 TO dw_1.RowCount()
			CHOOSE CASE ll_cantidad
				CASE 1
					dw_1.Object.barras_01.Visible 		= 1
					dw_1.Object.barras_01.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 2
					dw_1.Object.barras_02.Visible 		= 1
					dw_1.Object.barras_02.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 3
					dw_1.Object.barras_03.Visible 		= 1
					dw_1.Object.barras_03.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 4
					dw_1.Object.barras_04.Visible 		= 1
					dw_1.Object.barras_04.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 5
					dw_1.Object.barras_05.Visible 		= 1
					dw_1.Object.barras_05.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 6
					dw_1.Object.barras_06.Visible 		= 1
					dw_1.Object.barras_06.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 7
					dw_1.Object.barras_07.Visible 		= 1
					dw_1.Object.barras_07.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 8
					dw_1.Object.barras_08.Visible 		= 1
					dw_1.Object.barras_08.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 9
					dw_1.Object.barras_09.Visible 		= 1
					dw_1.Object.barras_09.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 10
					dw_1.Object.barras_10.Visible 		= 1
					dw_1.Object.barras_10.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 11
					dw_1.Object.barras_11.Visible 		= 1
					dw_1.Object.barras_11.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 12
					dw_1.Object.barras_12.Visible 		= 1
					dw_1.Object.barras_12.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 13
					dw_1.Object.barras_13.Visible 		= 1
					dw_1.Object.barras_13.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 14
					dw_1.Object.barras_14.Visible 		= 1
					dw_1.Object.barras_14.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 15
					dw_1.Object.barras_15.Visible 		= 1
					dw_1.Object.barras_15.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
				CASE 16
					dw_1.Object.barras_16.Visible 		= 1
					dw_1.Object.barras_16.Object.Text 	= "CTT"+ dw_1.Object.Codigo[ll_Cantidad]
					
			END CHOOSE
		NEXT
		
		dw_1.Object.DataWindow.Zoom = 90
		
		IF dw_1.Print() = -1 THEN
			MessageBox('Error', 'Error en la impresión.', StopSign!, OK!)
			dw_1.Reset()
			Return 
		END IF
		
		FOR ll_cantidad = dw_1.RowCount() TO 1 Step -1
			dw_1.DeleteRow(ll_cantidad)
			
		NEXT
		
		dw_1.Object.barras_01.Visible = 0
		dw_1.Object.barras_02.Visible = 0
		dw_1.Object.barras_03.Visible = 0
		dw_1.Object.barras_04.Visible = 0
		dw_1.Object.barras_05.Visible = 0
		dw_1.Object.barras_06.Visible = 0
		dw_1.Object.barras_07.Visible = 0
		dw_1.Object.barras_08.Visible = 0
		dw_1.Object.barras_09.Visible = 0
		dw_1.Object.barras_10.Visible = 0
		dw_1.Object.barras_11.Visible = 0
		dw_1.Object.barras_12.Visible = 0
		dw_1.Object.barras_13.Visible = 0
		dw_1.Object.barras_14.Visible = 0
		dw_1.Object.barras_15.Visible = 0
		dw_1.Object.barras_16.Visible = 0
		
		dw_1.SetFilter("")
		dw_1.Filter()
	LOOP
	
	If iuo_vales.UltimoVale(uo_SelZona.Codigo, uo_SelProveedor.Codigo, Sqlca) Then
		em_ultimo.Text = string(iuo_vales.Ultimo)
	End If
End If

end event

type pb_salir from w_para_informes`pb_salir within w_genera_valescontratista
string tag = "Cierra Ventana"
integer x = 1870
integer y = 836
integer taborder = 50
string disabledname = "\desarrollo\bmp\exitd.bmp"
end type

type st_3 from statictext within w_genera_valescontratista
integer x = 247
integer y = 420
integer width = 1458
integer height = 556
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16711680
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_selzona from uo_seleccion_zonas within w_genera_valescontratista
integer x = 681
integer y = 468
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

If Not iuo_vales.UltimoVale(This.Codigo, uo_SelProveedor.Codigo, Sqlca) Then
	MessageBox('Alerta', 'No se ha generado ningun vale.', StopSign!, OK!)
	em_ultimo.Text = ''
	Return
Else
	em_ultimo.Text = string(iuo_vales.Ultimo)
End If
end event

type uo_selproveedor from uo_seleccion_clienprove within w_genera_valescontratista
integer x = 681
integer y = 592
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

on uo_selproveedor.destroy
call uo_seleccion_clienprove::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

If Not iuo_vales.UltimoVale(uo_SelZona.Codigo, This.Codigo, Sqlca) Then
	MessageBox('Alerta', 'No se ha generado ningun vale.', StopSign!, OK!)
	em_ultimo.Text = ''
	Return
Else
	em_ultimo.Text = string(iuo_vales.Ultimo)
End If
end event

type ddlb_ubicacion from dropdownlistbox within w_genera_valescontratista
integer x = 677
integer y = 820
integer width = 933
integer height = 400
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
boolean sorted = false
string item[] = {"Administración","Contratista","Casino","Extraviado"}
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_genera_valescontratista
integer x = 325
integer y = 476
integer width = 329
integer height = 64
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
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_genera_valescontratista
integer x = 325
integer y = 604
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Contratista"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_genera_valescontratista
integer x = 923
integer y = 712
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Ult. emitido"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_genera_valescontratista
integer x = 325
integer y = 836
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Ubicación"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type em_cantidad from editmask within w_genera_valescontratista
integer x = 681
integer y = 700
integer width = 224
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type dw_1 from uo_dw within w_genera_valescontratista
boolean visible = false
integer x = 1897
integer y = 284
integer width = 210
integer height = 180
integer taborder = 20
boolean bringtotop = true
string title = "dw_genera_valescontratista"
string dataobject = "dw_valescontratistas_a4"
end type

type em_ultimo from editmask within w_genera_valescontratista
integer x = 1280
integer y = 700
integer width = 334
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type st_6 from statictext within w_genera_valescontratista
integer x = 320
integer y = 712
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Cantidad"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

