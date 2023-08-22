$PBExportHeader$w_maed_movimiento_colaciones.srw
forward
global type w_maed_movimiento_colaciones from w_mant_directo
end type
type tab_2 from tab within w_maed_movimiento_colaciones
end type
type tabpage_1 from vuo_tab_movtocasino within tab_2
end type
type tabpage_1 from vuo_tab_movtocasino within tab_2
end type
type tab_2 from tab within w_maed_movimiento_colaciones
tabpage_1 tabpage_1
end type
type st_1 from statictext within w_maed_movimiento_colaciones
end type
type sle_usuario from singlelineedit within w_maed_movimiento_colaciones
end type
type em_fecha from editmask within w_maed_movimiento_colaciones
end type
type st_2 from statictext within w_maed_movimiento_colaciones
end type
type tab_1 from tab within w_maed_movimiento_colaciones
end type
type tab_1 from tab within w_maed_movimiento_colaciones
end type
type dw_2 from datawindow within w_maed_movimiento_colaciones
end type
type dw_3 from datawindow within w_maed_movimiento_colaciones
end type
type dw_4 from datawindow within w_maed_movimiento_colaciones
end type
end forward

global type w_maed_movimiento_colaciones from w_mant_directo
integer width = 3941
integer height = 2052
string title = "MOVIMIENTO COLACIONES"
windowstate windowstate = maximized!
tab_2 tab_2
st_1 st_1
sle_usuario sle_usuario
em_fecha em_fecha
st_2 st_2
tab_1 tab_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
end type
global w_maed_movimiento_colaciones w_maed_movimiento_colaciones

type variables
Integer								ii_zona, ii_area, ii_tipoco
Date									id_fecha
Long									il_tabs

DataWindowChild					idwc_colaciones, idwc_horarios, idwc_colacionesimp, idwc_horariosimp

uo_personacasino					iuo_percasino
vuo_tab_movtocasino				iuo_tab[]
end variables

forward prototypes
public function boolean cargatabs ()
public function integer cargasecuencia ()
end prototypes

public function boolean cargatabs ();Boolean 	lb_retorno = True
Integer	li_filas, li_fila

FOR li_filas =	1 TO dw_2.RowCount()
	il_tabs ++
	iuo_tab[il_tabs]					=	Create vuo_tab_movtocasino
	tab_1.OpenTab(iuo_tab[il_tabs], 0)
	Tab_1.Control[il_tabs].Text	=	"Nombre"
	Tab_1.SelectTab(il_tabs)
	iuo_tab[il_tabs].Referencias(This, gstr_us.Nombre, dw_2.Object.tico_codigo[li_filas],Date(em_fecha.Text))
	
	IF NOT iuo_tab[il_tabs].Filtra() THEN 
		lb_retorno	=	False
		EXIT
	END IF
	
	Tab_1.Control[il_tabs].Text	=	dw_2.Object.tico_abrevi[li_filas]
	
NEXT

Return lb_retorno
end function

public function integer cargasecuencia ();Integer	li_secuencia, li_zona, li_area
Date		ld_fecha

li_zona	=	iuo_percasino.zona_codigo
li_area	=	iuo_percasino.caar_codigo
ld_fecha	=	Date(em_fecha.Text)

select max(IsNull(camv_secuen, 0))
  into :li_secuencia
  from dbo.casino_movtocolaciones
 where zona_codigo = :li_zona
	and camv_fechac = :ld_fecha;
  
  
IF sqlca.SqlCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de Tabla Movimiento de Colaciones")
	RETURN -1
END IF

Return li_secuencia + 1
end function

on w_maed_movimiento_colaciones.create
int iCurrent
call super::create
this.tab_2=create tab_2
this.st_1=create st_1
this.sle_usuario=create sle_usuario
this.em_fecha=create em_fecha
this.st_2=create st_2
this.tab_1=create tab_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_usuario
this.Control[iCurrent+4]=this.em_fecha
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.dw_4
end on

on w_maed_movimiento_colaciones.destroy
call super::destroy
destroy(this.tab_2)
destroy(this.st_1)
destroy(this.sle_usuario)
destroy(this.em_fecha)
destroy(this.st_2)
destroy(this.tab_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
end on

event open;call super::open;iuo_percasino			=	Create uo_personacasino

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)

dw_1.GetChild("caco_codigo", idwc_colaciones)
idwc_colaciones.SetTransObject(sqlca)

dw_1.GetChild("camv_horaco", idwc_horarios)
idwc_horarios.SetTransObject(sqlca)

dw_1.InsertRow(0)

sle_usuario.Text	=	gstr_us.Nombre
em_fecha.Text		=	String(Today(), 'dd/mm/yyyy')

buscar			= "Estado:Ncamv_estado,Rut:Scape_codigo,Ape.Pat.:Scape_apepat,Ape.Mat.:Scape_apemat,Nombre:Scape_nombre"
ordenar			= "Estado:camv_estado,Rut:cape_codigo,Ape.Pat.:cape_apepat,Ape.Mat.:cape_apemat,Nombre:cape_nombre"

IF NOT iuo_percasino.Existe(gstr_us.Nombre, True, sqlca) THEN Close(This)

end event

event ue_recuperadatos;Date		ld_Fecha
Long		ll_Filas

w_main.SetMicroHelp("Recuperando Datos...")
SetPointer(HourGlass!)
PostEvent("ue_listo")

GarbageCollect()

pb_imprimir.Enabled	=	False
pb_grabar.Enabled		=	False

ld_Fecha	=	Date(em_fecha.Text)

ll_Filas	=	dw_1.Retrieve(gstr_us.Nombre, ld_Fecha)

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Movimiento Casino")
	dw_1.SetRedraw(True)
	RETURN
Else
	pb_Grabar.Enabled			=	True
	ll_Filas	=	dw_2.Retrieve(iuo_percasino.zona_codigo, ld_Fecha)

	If ll_Filas = -1 Then
		F_ErrorBaseDatos(sqlca, "Lectura de Tabla Horarios de Colaciones")
		RETURN
	Else
		If ll_filas < 1 Then
			Messagebox("Error", "No Existen eventos para el dia ingresado", Exclamation!)
			Return
		Else
			ll_Filas	=	dw_3.Retrieve(gstr_us.Nombre)		
			If ll_Filas = -1 Then
				F_ErrorBaseDatos(sqlca, "Lectura de Tabla de Personal Colación")
				RETURN
			Else
				If ll_filas < 1 Then
					Messagebox("Error", "No Existe Personal asociado al usuario ingresado", Exclamation!)
					Return
				Else
					If NOT CargaTabs() Then
						Close(This)
					Else
						pb_lectura.Enabled	=	False
						pb_imprimir.Enabled	=	True
					End If
				End If
			End If
		End If
	End If
End If
end event

event resize;Integer		li_posic_x, li_posic_y, &
				li_Ancho = 300, li_Alto = 245, li_Siguiente = 255
				
dw_1.Resize (This.WorkSpaceWidth() - 510,This.WorkSpaceHeight() - dw_1.y - 75)
tab_1.Resize(This.WorkSpaceWidth() - 510,This.WorkSpaceHeight() - dw_1.y - 75)
tab_2.Resize(This.WorkSpaceWidth() - 510,This.WorkSpaceHeight() - dw_1.y - 75)


dw_1.x					=	78
tab_1.x					=	dw_1.x
tab_2.x					=	dw_1.x
st_encabe.x				=	dw_1.x
st_encabe.width		=	dw_1.width

li_posic_x				=	This.WorkSpaceWidth() - 370
li_posic_y				=	30

pb_lectura.x				=	li_posic_x
pb_lectura.y				=	li_posic_y
pb_lectura.width		=	li_Ancho
pb_lectura.height		=	li_Alto

li_posic_y 				+= li_Siguiente * 1.25

IF pb_nuevo.Visible THEN
	pb_nuevo.x			=	li_posic_x
	pb_nuevo.y			=	li_posic_y
	pb_nuevo.width	=	li_Ancho
	pb_nuevo.height	=	li_Alto
	li_posic_y 			+= li_Siguiente
END IF

IF pb_insertar.Visible THEN
	pb_insertar.x		=	li_posic_x
	pb_insertar.y		=	li_posic_y
	pb_insertar.width	=	li_Ancho
	pb_insertar.height	=	li_Alto
	li_posic_y += li_Siguiente
END IF

IF pb_eliminar.Visible THEN
	pb_eliminar.x			=	li_posic_x
	pb_eliminar.y			=	li_posic_y
	pb_eliminar.width		=	li_Ancho
	pb_eliminar.height	=	li_Alto
	li_posic_y += li_Siguiente
END IF

IF pb_grabar.Visible THEN
	pb_grabar.x				=	li_posic_x
	pb_grabar.y				=	li_posic_y
	pb_grabar.width		=	li_Ancho
	pb_grabar.height		=	li_Alto
	li_posic_y += li_Siguiente
END IF

IF pb_imprimir.Visible THEN
	pb_imprimir.x			=	li_posic_x
	pb_imprimir.y			=	li_posic_y
	pb_imprimir.width		=	li_Ancho
	pb_imprimir.height	=	li_Alto
	li_posic_y += li_Siguiente
END IF

pb_salir.x				=	li_posic_x
pb_salir.y				=	dw_1.y + dw_1.Height - li_Siguiente
pb_salir.width			=	li_Ancho
pb_salir.height			=	li_Alto
end event

event ue_antesguardar;Integer	li_secuencia, li_filas = 1, li_area, li_invitados

tab_1.SelectedTab = 1

dw_1.SetFilter("")
dw_1.Filter()

DO WHILE li_filas <= dw_1.RowCount()
	IF dw_1.GetItemStatus(li_filas, 0, Primary!) = New! THEN
		dw_1.DeleteRow(li_filas)
	ELSE
		li_filas ++
	END IF
	dw_1.ScrollToRow(li_filas)
	dw_1.SelectRow(0, False)
	dw_1.SelectRow(li_filas, True)
LOOP

li_secuencia	=	CargaSecuencia()

IF IsNull(li_secuencia) OR li_secuencia < 1 THEN li_secuencia = 1

FOR li_filas = 1 TO dw_1.RowCount()
	
	IF dw_1.Object.camv_secuen[li_filas] < 1 OR IsNull(dw_1.Object.camv_secuen[li_filas]) THEN
		dw_1.Object.camv_secuen[li_filas]	=	li_secuencia
		li_secuencia ++
	END IF

	IF dw_1.Object.camv_estado[li_filas] = 1 THEN
		IF IsNull(dw_1.Object.caco_codigo[li_filas]) THEN
			MessageBox("Protección de datos",&
						  "Existe un personal que no posee elección de menu y "+&
						  "se encuentra en estado confirmado. Favor verificar datos", Exclamation!)
			Message.DoubleParm = -1
			Exit
			
		END IF
	END IF
	
	IF dw_1.Object.camv_invcur[li_filas] = 1 THEN
		IF IsNull(dw_1.Object.camv_rutinv[li_filas]) OR &
			IsNull(dw_1.Object.camv_appain[li_filas]) OR &
			IsNull(dw_1.Object.camv_apmain[li_filas]) OR &
			IsNull(dw_1.Object.camv_nominv[li_filas]) THEN
			MessageBox("Protección de datos", &
						  "Se genero una invitación a 3ro, y no se han ingresado "+&
						  "datos de la persona. Favor verificar datos", Exclamation!)
			Message.DoubleParm = -1
			
			Exit
			
		ELSE
			li_invitados									=	dw_4.InsertRow(0)
			dw_4.Object.clpr_nombre[li_invitados]	=	dw_1.Object.camv_nominv[li_filas] + ' ' + &
																	dw_1.Object.camv_appain[li_filas] + ' ' + &
																	dw_1.Object.camv_apmain[li_filas] + ' '
			dw_4.Object.vact_numero[li_invitados]	=	dw_1.Object.camv_rutinv[li_filas]
			dw_4.Object.ole_barra.Object.Text		=	'INV' + Right('000000', 6 - Len(String(dw_1.Object.camv_rutinv[li_filas]))) + &
																	String(dw_1.Object.camv_rutinv[li_filas])
			dw_4.Object.codigo[li_invitados]			=	dw_1.Object.cape_codigo[li_filas]
			
		END IF
	END IF
	
NEXT

IF dw_4.RowCount() > 0 THEN
	IF MessageBox("Impresion Vales", "Se imprimiran los vales de todos los invitados.~r~n"+&
		  			  "¿Desea continuar con la impresión?", Question!, YesNo!, 1) = 1 THEN
		dw_4.Print(False, True)
	END IF
	
	dw_4.Reset()
END IF

dw_1.SetFilter("tico_codigo = " + String(dw_2.Object.tico_codigo[1]))
dw_1.Filter()
end event

event ue_guardar;IF dw_1.AcceptText() = -1 THEN RETURN

SetPointer(HourGlass!)

w_main.SetMicroHelp("Grabando información...")

TriggerEvent("ue_antesguardar")

IF Message.DoubleParm = -1 THEN Return

IF wf_actualiza_db() THEN
	w_main.SetMicroHelp("Información Grabada.")
	pb_imprimir.Enabled	= True
ELSE
	w_main.SetMicroHelp("No se puede Grabar información.")
	Message.DoubleParm = -1
	RETURN
END IF
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
Date		ld_Fecha

str_info	lstr_info

lstr_info.titulo	= "INFORME DE MOVIMIENTOS DE COLACIONES"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)

vinf.dw_1.DataObject = "dw_info_movtocolaciones"
vinf.dw_1.SetTransObject(sqlca)

ld_Fecha	=	Date(em_fecha.Text)

fila = vinf.dw_1.Retrieve(gstr_us.Nombre, ld_Fecha)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", &
					StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')

	vinf.Visible	= True
	vinf.Enabled	= True
END IF

SetPointer(Arrow!)
end event

type st_encabe from w_mant_directo`st_encabe within w_maed_movimiento_colaciones
integer x = 55
integer y = 40
integer width = 3264
integer height = 212
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_maed_movimiento_colaciones
boolean visible = false
integer x = 3493
integer y = 1456
end type

event pb_nuevo::clicked;dw_1.Reset()
dw_2.Reset()
dw_3.Reset()
Pb_Lectura. Enabled = True



end event

type pb_lectura from w_mant_directo`pb_lectura within w_maed_movimiento_colaciones
integer x = 3497
integer y = 60
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_maed_movimiento_colaciones
boolean visible = false
integer x = 3493
integer y = 1636
end type

type pb_insertar from w_mant_directo`pb_insertar within w_maed_movimiento_colaciones
boolean visible = false
integer x = 3502
integer y = 1624
end type

type pb_salir from w_mant_directo`pb_salir within w_maed_movimiento_colaciones
integer x = 3497
integer y = 892
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_maed_movimiento_colaciones
integer x = 3497
integer y = 536
end type

type pb_grabar from w_mant_directo`pb_grabar within w_maed_movimiento_colaciones
integer x = 3497
integer y = 356
end type

type dw_1 from w_mant_directo`dw_1 within w_maed_movimiento_colaciones
boolean visible = false
integer x = 64
integer y = 272
integer width = 3282
integer height = 1632
string dataobject = "dw_mues_movtocolaciones"
end type

event dw_1::sqlpreview;//
end event

type tab_2 from tab within w_maed_movimiento_colaciones
boolean visible = false
integer x = 59
integer y = 256
integer width = 3264
integer height = 1632
integer taborder = 10
boolean enabled = false
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_2.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_2.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from vuo_tab_movtocasino within tab_2
integer x = 18
integer y = 116
integer width = 3227
integer height = 1500
long backcolor = 16711680
string text = "Colación"
long tabtextcolor = 0
long picturemaskcolor = 0
end type

type st_1 from statictext within w_maed_movimiento_colaciones
integer x = 649
integer y = 116
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Usuario"
boolean focusrectangle = false
end type

type sle_usuario from singlelineedit within w_maed_movimiento_colaciones
integer x = 942
integer y = 100
integer width = 1024
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
borderstyle borderstyle = stylelowered!
end type

type em_fecha from editmask within w_maed_movimiento_colaciones
integer x = 2208
integer y = 100
integer width = 507
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_2 from statictext within w_maed_movimiento_colaciones
integer x = 2007
integer y = 116
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Fecha"
boolean focusrectangle = false
end type

type tab_1 from tab within w_maed_movimiento_colaciones
integer x = 59
integer y = 276
integer width = 3264
integer height = 1592
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
end type

event selectionchanged;Integer	li_area

li_area	=	iuo_tab[NewIndex].iuo_percas.caar_codigo
iuo_tab[NewIndex].Referencias(Parent, gstr_us.Nombre, dw_2.Object.tico_codigo[NewIndex],Date(em_fecha.Text))
iuo_tab[NewIndex].Filtra()
end event

type dw_2 from datawindow within w_maed_movimiento_colaciones
boolean visible = false
integer x = 3497
integer y = 1108
integer width = 155
integer height = 132
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "dw_mues_colacionesdia_porhora"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_maed_movimiento_colaciones
boolean visible = false
integer x = 3497
integer y = 1288
integer width = 155
integer height = 132
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dw_mues_casino_personalcolacion_usuario"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_4 from datawindow within w_maed_movimiento_colaciones
boolean visible = false
integer x = 1248
integer y = 684
integer width = 1390
integer height = 796
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_genera_valesinvitado"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

