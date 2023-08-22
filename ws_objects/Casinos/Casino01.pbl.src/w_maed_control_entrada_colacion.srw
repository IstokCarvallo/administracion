$PBExportHeader$w_maed_control_entrada_colacion.srw
forward
global type w_maed_control_entrada_colacion from w_mant_directo
end type
type sle_1 from singlelineedit within w_maed_control_entrada_colacion
end type
type dw_2 from datawindow within w_maed_control_entrada_colacion
end type
type st_1 from statictext within w_maed_control_entrada_colacion
end type
type dw_horarios from datawindow within w_maed_control_entrada_colacion
end type
end forward

global type w_maed_control_entrada_colacion from w_mant_directo
integer width = 3950
integer height = 2020
string title = "MOVIMIENTOS DE CASINO"
windowstate windowstate = maximized!
sle_1 sle_1
dw_2 dw_2
st_1 st_1
dw_horarios dw_horarios
end type
global w_maed_control_entrada_colacion w_maed_control_entrada_colacion

type variables
uo_movtocasino		iuo_casino

Integer			ii_tipocolacion, ii_clasif, ii_control
String				is_rut, is_nombre, is_apepat, is_apemat, is_eleccion
Date				id_fecha
Time				it_time

end variables

on w_maed_control_entrada_colacion.create
int iCurrent
call super::create
this.sle_1=create sle_1
this.dw_2=create dw_2
this.st_1=create st_1
this.dw_horarios=create dw_horarios
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_horarios
end on

on w_maed_control_entrada_colacion.destroy
call super::destroy
destroy(this.sle_1)
destroy(this.dw_2)
destroy(this.st_1)
destroy(this.dw_horarios)
end on

event resize;Integer		li_posi_y, li_objeto

dw_2.x			=	(This.WorkSpaceWidth() / 2) - (dw_2.Width / 2)
sle_1.x			=	dw_2.x
st_encabe.x		=	dw_2.x
st_1.x				=	dw_2.x + 46
dw_1.x			=	dw_2.x + 46

pb_lectura.x		=	dw_2.x + 3547
pb_salir.x		=	dw_2.x + 3547
end event

event open;x												= 	0
y												= 	0
This.Width									= 	dw_1.width + 540
This.Height									= 	1993
im_menu										= 	m_principal

iuo_casino									=	Create uo_movtocasino

This.ParentWindow().ToolBarVisible	=	True
im_menu.Item[1].Item[6].Enabled		=	True
im_menu.Item[7].Visible					=	False
This.Icon									=	Gstr_apl.Icono

istr_mant.UsuarioSoloConsulta			=	OpcionSoloConsulta()
istr_mant.Solo_Consulta					=	istr_mant.UsuarioSoloConsulta

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, This.Title, "Acceso a Aplicación", 1)

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_2.ShareData(dw_1)

This.PostEvent("ue_nuevo")

Timer(5)
end event

event ue_recuperadatos;long		ll_filas

w_main.SetMicroHelp("Recuperando Datos...")
SetPointer(HourGlass!)
PostEvent("ue_listo")

ll_Filas	=	dw_1.Retrieve(is_rut, id_Fecha, ii_tipocolacion)

IF ll_Filas = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Movimiento Casino")

	dw_1.SetRedraw(True)

	RETURN
ELSE
	dw_1.Object.camv_estado[il_fila]	=	9
	dw_1.Object.camv_hormvt[il_fila]	=	it_time
	
	ii_control 	=	1
	is_eleccion	=	dw_1.Object.caco_nombre[il_fila]
	ii_clasif 	= 	dw_1.Object.camv_invcur[il_fila]
	
	IF ii_clasif = 0 THEN
		is_apepat	=	wordcap(dw_1.Object.cape_apepat[il_fila])
		is_apemat	=	wordcap(dw_1.Object.cape_apemat[il_fila])
		is_nombre	=	wordcap(dw_1.Object.cape_nombre[il_fila])
	ELSE
		is_apepat	=	wordcap(dw_1.Object.camv_appain[il_fila])
		is_apemat	=	wordcap(dw_1.Object.camv_apmain[il_fila])
		is_nombre	=	wordcap(dw_1.Object.camv_nominv[il_fila])
	END IF
	
	This.TriggerEvent("ue_guardar")
	Timer(5)
END IF


end event

event ue_nuevo;DateTime		ld_fechahora
Integer		li_filas

ld_fechahora	=	f_fechahora()

it_time			=	Time(ld_fechahora)
id_fecha			=	Date(ld_fechahora)

dw_1.Reset()
dw_2.Reset()
dw_horarios.Reset()

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_horarios.SetTransObject(sqlca)
dw_1.ShareData(dw_2)

dw_horarios.Retrieve(-1, id_fecha)

IF dw_horarios.RowCount() < 1 THEN
	MessageBox("Error", "No Existen colaciones creadas para el dia en curso.~r~n" + &
								"Favor de avisar al administrador del sistema", Exclamation!)
	Halt
END IF

li_filas				=	dw_horarios.find(String(it_time) + " between cahc_horini and cahc_horter", &
												1, dw_horarios.RowCount())

il_fila = dw_1.InsertRow(0)
dw_1.ScrollToRow(il_fila)
dw_1.SetRow(il_fila)
dw_1.SetFocus()
dw_1.SetColumn(1)

IF li_filas > 0 THEN
	ii_tipocolacion						= 	dw_horarios.Object.tico_codigo[li_filas]
	dw_1.Object.tico_nombre[il_fila]	=	dw_horarios.Object.tico_nombre[li_filas]
	
	dw_1.Object.camv_invcur[il_fila] = 	ii_clasif
	dw_1.Object.cape_apepat[il_fila]	=	is_apepat
	dw_1.Object.cape_apemat[il_fila]	=	is_apemat
	dw_1.Object.cape_nombre[il_fila]	=	is_nombre
	dw_1.Object.caco_nombre[il_fila]	=	is_eleccion
	
ELSE
	ii_tipocolacion						= 	-1
	dw_1.Object.tico_nombre[il_fila]	=	"Horario No Asignado"
	
END IF

IF il_fila > 0 THEN
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled		= True
	
END IF

dw_1.Object.camv_fechac[il_fila]	=	id_fecha
dw_1.Object.camv_horaco[il_fila]	=	it_time
end event

event timer;call super::timer;DateTime		ld_fechahora
Integer		li_filas

ld_fechahora	=	f_fechahora()

it_time			=	Time(ld_fechahora)
id_fecha			=	Date(ld_fechahora)

dw_1.Reset()
dw_2.Reset()
dw_horarios.Reset()

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_horarios.SetTransObject(sqlca)
dw_1.ShareData(dw_2)

dw_horarios.Retrieve(-1, id_fecha)

IF dw_horarios.RowCount() < 1 THEN
	MessageBox("Error", "No Existen colaciones creadas para el dia en curso.~r~n" + &
								"Favor de avisar al administrador del sistema", Exclamation!)
	Halt
END IF

li_filas				=	dw_horarios.find(String(it_time) + " between cahc_horini and cahc_horter", &
												  1, dw_horarios.RowCount())

il_fila = dw_1.InsertRow(0)
dw_1.ScrollToRow(il_fila)
dw_1.SetRow(il_fila)
dw_1.SetFocus()
dw_1.SetColumn(1)

ii_control++

IF li_filas > 0 THEN
	ii_tipocolacion						= 	dw_horarios.Object.tico_codigo[li_filas]
	dw_1.Object.tico_nombre[il_fila]	=	dw_horarios.Object.tico_nombre[li_filas]
	
	IF ii_control < 5 THEN
		dw_1.Object.camv_invcur[il_fila] = 	ii_clasif
		dw_1.Object.cape_apepat[il_fila]	=	is_apepat
		dw_1.Object.cape_apemat[il_fila]	=	is_apemat
		dw_1.Object.cape_nombre[il_fila]	=	is_nombre
		dw_1.Object.caco_nombre[il_fila]	=	is_eleccion
	ELSE
		ii_control = 0
		
		SetNull(ii_clasif)
		SetNull(is_apepat)
		SetNull(is_apemat)
		SetNull(is_nombre)
		SetNull(is_eleccion)
	END IF
	
ELSE
	ii_tipocolacion						= 	-1
	dw_1.Object.tico_nombre[il_fila]	=	"Horario No Asignado"
	
END IF

IF il_fila > 0 THEN
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled		= True
	
END IF

dw_1.Object.camv_fechac[il_fila]	=	id_fecha
dw_1.Object.camv_horaco[il_fila]	=	it_time
end event

event ue_antesguardar;Long	ll_fila = 1

DO WHILE ll_fila <= dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_fila, 0, Primary!) = New! OR &
		dw_1.Object.zona_codigo[ll_fila] < 1 OR &
		IsNull(dw_1.Object.zona_codigo[ll_fila] < 1) THEN
		dw_1.DeleteRow(ll_fila)
	ELSE
		ll_fila ++
	END IF
LOOP
end event

type st_encabe from w_mant_directo`st_encabe within w_maed_control_entrada_colacion
integer x = 55
integer y = 48
integer width = 3433
integer height = 228
alignment alignment = center!
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_maed_control_entrada_colacion
boolean visible = false
integer x = 4027
integer y = 20
end type

type pb_lectura from w_mant_directo`pb_lectura within w_maed_control_entrada_colacion
string tag = "Muestra Ultimo Ingreso"
integer x = 3547
integer y = 240
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
long backcolor = 553648127
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_maed_control_entrada_colacion
boolean visible = false
integer x = 4027
integer y = 20
end type

type pb_insertar from w_mant_directo`pb_insertar within w_maed_control_entrada_colacion
boolean visible = false
integer x = 4027
integer y = 20
end type

type pb_salir from w_mant_directo`pb_salir within w_maed_control_entrada_colacion
integer x = 3547
integer y = 548
fontcharset fontcharset = vietnamesecharset!
long backcolor = 553648127
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_maed_control_entrada_colacion
boolean visible = false
integer x = 4027
integer y = 20
end type

type pb_grabar from w_mant_directo`pb_grabar within w_maed_control_entrada_colacion
boolean visible = false
integer x = 4027
integer y = 20
end type

type dw_1 from w_mant_directo`dw_1 within w_maed_control_entrada_colacion
integer x = 137
integer y = 348
integer width = 3269
integer height = 396
string dataobject = "dw_mues_controlingreso_casino"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::itemchanged;Integer	li_fila
string	ls_null, ls_columna

Timer(0)

SetNull(ls_null)

ls_columna	=	dwo.Name

CHOOSE CASE ls_columna
	CASE "lectura"
		IF iuo_casino.existeenfecha(data, ii_tipocolacion, id_fecha, True, sqlca) THEN
			is_rut	=	Mid(data, 17, 8)
			Parent.PostEvent("ue_recuperadatos")
		ELSE
			This.SetItem(Row, ls_columna, ls_null)
			Return 1
		END IF

END CHOOSE
end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

event dw_1::sqlpreview;//
end event

type sle_1 from singlelineedit within w_maed_control_entrada_colacion
integer x = 55
integer y = 276
integer width = 3433
integer height = 540
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 33554432
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

type dw_2 from datawindow within w_maed_control_entrada_colacion
integer x = 55
integer y = 832
integer width = 3698
integer height = 956
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "DETALLE DEL PERSONAL"
string dataobject = "dw_mues_controlingreso_casino_sharedata"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_maed_control_entrada_colacion
integer x = 101
integer y = 104
integer width = 3342
integer height = 128
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "MOVIMIENTOS DE CASINO"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_horarios from datawindow within w_maed_control_entrada_colacion
boolean visible = false
integer x = 3584
integer y = 56
integer width = 192
integer height = 136
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_mues_colacionesdia_porhora"
boolean border = false
boolean livescroll = true
end type

