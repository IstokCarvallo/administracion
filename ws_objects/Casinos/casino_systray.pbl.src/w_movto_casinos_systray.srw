$PBExportHeader$w_movto_casinos_systray.srw
forward
global type w_movto_casinos_systray from w_systray
end type
type st_mensaje from statictext within w_movto_casinos_systray
end type
type dw_ticket from datawindow within w_movto_casinos_systray
end type
type st_estado from statictext within w_movto_casinos_systray
end type
type dw_1 from datawindow within w_movto_casinos_systray
end type
type dw_2 from datawindow within w_movto_casinos_systray
end type
type dw_horarios from datawindow within w_movto_casinos_systray
end type
type pb_lectura from picturebutton within w_movto_casinos_systray
end type
type pb_salir from picturebutton within w_movto_casinos_systray
end type
type st_encabe from statictext within w_movto_casinos_systray
end type
type sle_1 from statictext within w_movto_casinos_systray
end type
type notifyicondata from structure within w_movto_casinos_systray
end type
end forward

type notifyicondata from structure
	long		cbsize
	long		hwnd
	long		uid
	long		uflags
	long		ucallbackmessage
	long		hicon
	character		sztip[64]
end type

global type w_movto_casinos_systray from w_systray
string tag = "Movimientos Casino"
integer width = 4398
integer height = 2272
string title = "Movimientos Casino"
long backcolor = 16777215
string icon = "AppIcon!"
event ue_antesguardar ( )
event ue_guardar ( )
event ue_nuevo ( )
event ue_recuperadatos ( )
st_mensaje st_mensaje
dw_ticket dw_ticket
st_estado st_estado
dw_1 dw_1
dw_2 dw_2
dw_horarios dw_horarios
pb_lectura pb_lectura
pb_salir pb_salir
st_encabe st_encabe
sle_1 sle_1
end type
global w_movto_casinos_systray w_movto_casinos_systray

type variables
uo_movtocasino		iuo_casino

Integer				ii_tipocolacion, ii_clasif, ii_control
String					is_rut, is_nombre, is_apepat, is_apemat, is_eleccion
Date					id_fecha
Time					it_time

protected:
Long					il_fila
String					buscar, ordenar, is_ultimacol, ias_campo[]
Boolean				ib_datos_ok, ib_borrar, ib_ok, ib_traer, ib_deshace = True
Date					id_FechaAcceso
Time					it_HoraAcceso
end variables

forward prototypes
public function boolean wf_actualiza_db ()
end prototypes

event ue_antesguardar();Long	ll_fila = 1

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

event ue_guardar();IF dw_1.AcceptText() = -1 THEN RETURN

SetPointer(HourGlass!)

TriggerEvent("ue_antesguardar")

IF NOT wf_actualiza_db() THEN
	Message.DoubleParm = -1
	RETURN
END IF
end event

event ue_nuevo();DateTime	ld_fechahora
Integer		li_filas

st_estado.Text	=	"Sin Conexión A La Base de Datos"
If ib_connected Then
	st_estado.Text	=	"Conectado Exitosamente A La Base de Datos"
	
	dw_1.Reset()
	dw_2.Reset()
	dw_horarios.Reset()
	
	dw_1.SetTransObject(sqlca)
	dw_2.SetTransObject(sqlca)
	dw_horarios.SetTransObject(sqlca)
	dw_1.ShareData(dw_2)
	
	li_filas	=	dw_horarios.Retrieve(-1, Date('19000101'))
	
	DO
		If li_filas = -1 Then
			st_estado.Text	=	"Sin Conexión A La Base de Datos"
			Conexion()
	
			dw_1.SetTransObject(sqlca)
			dw_2.SetTransObject(sqlca)
			dw_horarios.SetTransObject(sqlca)
			dw_1.ShareData(dw_2)
			li_filas	=	dw_horarios.Retrieve(-1, Date('19000101'))
		End If
	LOOP WHILE li_filas = -1
	
	st_estado.Text	=	"Conectado Exitosamente A La Base de Datos"
	
	ld_fechahora	=	f_fechahora()
	
	it_time			=	Time(ld_fechahora)
	id_fecha			=	Date(ld_fechahora)
	
	li_filas	=	dw_horarios.Retrieve(-1, id_fecha)
	
	If dw_horarios.RowCount() < 1 Then
		st_Mensaje.Text =	"No Existen colaciones creadas para el dia en curso."
		Halt
	End If
	
	li_filas	=	dw_horarios.find(String(it_time) + " between cahc_horini and cahc_horter",  1, dw_horarios.RowCount())
	
	il_fila = dw_1.InsertRow(0)
	dw_1.ScrollToRow(il_fila)
	dw_1.SetRow(il_fila)
	dw_1.SetFocus()
	dw_1.SetColumn(1)
	
	If li_filas > 0 Then
		ii_tipocolacion							= 	dw_horarios.Object.tico_codigo[li_filas]
		dw_1.Object.tico_nombre[il_fila]	=	dw_horarios.Object.tico_nombre[li_filas]
		
		dw_1.Object.camv_invcur[il_fila] 	= 	ii_clasIf
		dw_1.Object.cape_apepat[il_fila]	=	is_apepat
		dw_1.Object.cape_apemat[il_fila]	=	is_apemat
		dw_1.Object.cape_nombre[il_fila]	=	is_nombre
		dw_1.Object.caco_nombre[il_fila]	=	is_eleccion
	Else
		ii_tipocolacion							= 	-1
		dw_1.Object.tico_nombre[il_fila]	=	"Horario No Asignado"
	End If
	
	dw_1.Object.camv_fechac[il_fila]	=	id_fecha
	dw_1.Object.camv_horaco[il_fila]	=	it_time
End If
end event

event ue_recuperadatos();long		ll_filas

SetPointer(HourGlass!)
PostEvent("ue_listo")

ll_Filas	=	dw_1.Retrieve(is_rut, ii_tipocolacion, id_Fecha, iuo_casino.ii_secuencia)

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Movimiento Casino")
	dw_1.SetRedraw(True)
	Return
Else
	dw_1.Object.camv_estado[il_fila]	=	9
	dw_1.Object.camv_hormvt[il_fila]	=	it_time
	
	ii_control 	=	1
	is_eleccion	=	dw_1.Object.caco_nombre[il_fila]
	ii_clasIf 		= 	dw_1.Object.camv_invcur[il_fila]
	
	If ii_clasIf = 0 Then
		is_apepat	=	wordcap(dw_1.Object.cape_apepat[il_fila])
		is_apemat	=	wordcap(dw_1.Object.cape_apemat[il_fila])
		is_nombre	=	wordcap(dw_1.Object.cape_nombre[il_fila])
	Else
		is_apepat	=	wordcap(dw_1.Object.camv_appain[il_fila])
		is_apemat	=	wordcap(dw_1.Object.camv_apmain[il_fila])
		is_nombre	=	wordcap(dw_1.Object.camv_nominv[il_fila])
	End If
	
	This.TriggerEvent("ue_guardar")
	Timer(5)
End If

end event

public function boolean wf_actualiza_db ();Boolean	lb_AutoCommit, lb_Retorno
DateTime	ldt_FechaHora
Time		it_ahora
Date		camv_fechac
Integer	zona_codigo, caar_codigo, camv_secuen

it_ahora	=	time(f_fechahora())

IF dw_1.RowCount() > 0 THEN
	zona_codigo = dw_1.Object.zona_codigo[1] 
	caar_codigo = dw_1.Object.caar_codigo[1] 
	camv_fechac = dw_1.Object.camv_fechac[1] 
	camv_secuen = dw_1.Object.camv_secuen[1]
END IF

lb_AutoCommit		=	sqlca.AutoCommit
sqlca.AutoCommit	=	False

Update dbo.Casino_MovtoColaciones
	set camv_hormvt = :it_ahora,
		 camv_estado =	9
 where zona_codigo = :zona_codigo 
   and caar_codigo = :caar_codigo 
   and camv_fechac = :camv_fechac 
   and camv_secuen = :camv_secuen;

IF sqlca.SQLCode = 0 then 
	Commit;
	
	IF dw_1.RowCount() > 0 THEN
		IF Not IsNull(dw_1.Object.zona_codigo[1]) AND dw_1.Object.zona_codigo[1] > 0 THEN
			dw_ticket.Print(False, False)
		END IF
	END IF
	
	IF sqlca.SQLCode <> 0 THEN
		F_ErrorBaseDatos(sqlca, This.Title)
		lb_Retorno	=	False
	ELSE
		lb_Retorno	=	True
			
		dw_1.ResetUpdate()
	END IF
ELSE
	RollBack;
	
	IF sqlca.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
	
	lb_Retorno	=	False
END IF

sqlca.AutoCommit	=	lb_AutoCommit

RETURN lb_Retorno
end function

on w_movto_casinos_systray.create
int iCurrent
call super::create
this.st_mensaje=create st_mensaje
this.dw_ticket=create dw_ticket
this.st_estado=create st_estado
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_horarios=create dw_horarios
this.pb_lectura=create pb_lectura
this.pb_salir=create pb_salir
this.st_encabe=create st_encabe
this.sle_1=create sle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mensaje
this.Control[iCurrent+2]=this.dw_ticket
this.Control[iCurrent+3]=this.st_estado
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_horarios
this.Control[iCurrent+7]=this.pb_lectura
this.Control[iCurrent+8]=this.pb_salir
this.Control[iCurrent+9]=this.st_encabe
this.Control[iCurrent+10]=this.sle_1
end on

on w_movto_casinos_systray.destroy
call super::destroy
destroy(this.st_mensaje)
destroy(this.dw_ticket)
destroy(this.st_estado)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_horarios)
destroy(this.pb_lectura)
destroy(this.pb_salir)
destroy(this.st_encabe)
destroy(this.sle_1)
end on

event open;call super::open;x												= 	0
y												= 	0
This.Width									= 	dw_1.width + 540
This.Height									= 	2500

iuo_casino									=	Create uo_movtocasino

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_ticket.SetTransObject(sqlca)

dw_1.ShareData(dw_2)
dw_2.ShareData(dw_ticket)

This.PostEvent("ue_nuevo")

Timer(5)
end event

event resize;call super::resize;dw_2.x				=	(This.WorkSpaceWidth() / 2) - (dw_2.Width / 2)

st_encabe.Width		=	dw_2.Width
sle_1.Width				=	dw_2.Width
st_mensaje.Width		=	dw_2.Width
st_estado.Width		=	dw_2.Width

st_encabe.x			=	dw_2.x
sle_1.x				=	dw_2.x
st_mensaje.x		=	dw_2.x
st_estado.x			=	dw_2.x

dw_1.x				=	sle_1.x + ((sle_1.Width / 2) - (dw_1.Width / 2))

pb_Salir.x			=	dw_2.x + dw_2.Width + 100
pb_Salir.y			=	dw_2.y + dw_2.Height - pb_Salir.Height
end event

event timer;call super::timer;DateTime		ld_fechahora
Integer			li_filas
DataStore		lds_pruebaconexion

Timer(0)
st_estado.Text	=	"Sin Conexión A La Base de Datos"
st_Mensaje.Text	=	""

IF NOT ib_connected THEN
	Conexion()
END IF

IF ib_connected THEN
	st_estado.Text	=	"Conectado Exitosamente A La Base de Datos"
	
	dw_1.Reset()
	dw_2.Reset()
	dw_horarios.Reset()
	
	dw_1.SetTransObject(sqlca)
	dw_2.SetTransObject(sqlca)
	dw_horarios.SetTransObject(sqlca)
	dw_1.ShareData(dw_2)
	
	lds_pruebaconexion						=	Create DataStore
	lds_pruebaconexion.DataObject		=	dw_horarios.DataObject
	lds_pruebaconexion.SetTransObject(sqlca)
	
	li_filas									=	lds_pruebaconexion.Retrieve(-1, Date('19000101'))
	
	DO
		IF li_filas = -1 THEN
			st_estado.Text	=	"Sin Conexión A La Base de Datos"
			Conexion()
	
			dw_1.SetTransObject(sqlca)
			dw_2.SetTransObject(sqlca)
			dw_horarios.SetTransObject(sqlca)
			dw_1.ShareData(dw_2)
			lds_pruebaconexion.SetTransObject(sqlca)
			li_filas	=	lds_pruebaconexion.Retrieve(-1, Date('19000101'))
			
		END IF
	LOOP WHILE li_filas = -1
	
	st_estado.Text	=	"Conectado Exitosamente A La Base de Datos"
	ld_fechahora	=	f_fechahora()
	it_time			=	Time(ld_fechahora)
	id_fecha			=	Date(ld_fechahora)
	li_filas			=	dw_horarios.Retrieve(-1, id_fecha)
	
	IF dw_horarios.RowCount() < 1 THEN
		st_Mensaje.Text = "No Existen colaciones creadas para el dia en curso."
		Halt
	END IF

	li_filas	=	dw_horarios.find(String(it_time) + " between cahc_horini and cahc_horter", 1, dw_horarios.RowCount())
	il_fila 	= 	dw_1.InsertRow(0)
	
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
	dw_1.Object.camv_fechac[il_fila]	=	id_fecha
	dw_1.Object.camv_horaco[il_fila]	=	it_time
	
END IF

Timer(5)
end event

event ue_trayrightclicked;call super::ue_trayrightclicked;m_casino_opcion lm_menu_opcion

This.SetFocus()
lm_menu_opcion = CREATE m_casino_opcion
lm_menu_opcion.m_pop.PopMenu(PointerX(),PointerY())
DESTROY lm_menu_opcion
end event

type st_mensaje from statictext within w_movto_casinos_systray
integer x = 32
integer y = 1792
integer width = 3694
integer height = 168
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = script!
string facename = "Comic Sans MS"
boolean italic = true
long textcolor = 65535
long backcolor = 16711680
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_ticket from datawindow within w_movto_casinos_systray
boolean visible = false
integer x = 4059
integer y = 48
integer width = 206
integer height = 140
integer taborder = 30
string title = "none"
string dataobject = "dw_info_controlingreso_casino_sharedata"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_estado from statictext within w_movto_casinos_systray
integer x = 32
integer y = 1968
integer width = 3694
integer height = 128
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 8388608
long backcolor = 16777215
string text = "Sin Conexion a Base de Datos"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_movto_casinos_systray
integer x = 247
integer y = 336
integer width = 3269
integer height = 388
integer taborder = 20
string dataobject = "dw_mues_controlingreso_casino"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Integer	li_fila
string	ls_null, ls_columna

Timer(0)

SetNull(ls_null)

ls_columna	=	dwo.Name
st_mensaje.Text = ''

Choose Case ls_columna
	Case "lectura"
		If IsNumber(Left(data, 3)) Then 
			data = 'INV' + Data
		End If
		
		If iuo_casino.ExisteEnFecha(Data, ii_TipoColacion, id_Fecha, True, sqlca) Then
			If Left(data, 3) = 'CTT' Then
				is_rut	=	iuo_casino.clpr_rutt	
			Else
				is_rut	=	Right(data, Len(data) - 3)
			End If
			
			Parent.PostEvent("ue_recuperadatos")	
		Else
			This.SetItem(Row, ls_columna, ls_null)
			Timer(5)
			Return 1
		End If
End Choose

Timer(5)
end event

event itemerror;Return 1
end event

type dw_2 from datawindow within w_movto_casinos_systray
integer x = 32
integer y = 816
integer width = 3707
integer height = 936
integer taborder = 20
boolean titlebar = true
string title = "DETALLE DEL PERSONAL"
string dataobject = "dw_mues_controlingreso_casino_sharedata"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_horarios from datawindow within w_movto_casinos_systray
boolean visible = false
integer x = 4014
integer y = 936
integer width = 178
integer height = 132
integer taborder = 20
string title = "none"
string dataobject = "dw_mues_colacionesdia_porhora"
boolean border = false
boolean livescroll = true
end type

type pb_lectura from picturebutton within w_movto_casinos_systray
string tag = "Muestra Ultimo Ingreso"
boolean visible = false
integer x = 4023
integer y = 216
integer width = 302
integer height = 244
integer taborder = 10
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png "
string powertiptext = "Muestra Ultimo Ingreso"
end type

type pb_salir from picturebutton within w_movto_casinos_systray
string tag = "Salir [Cerrar Ventana Activa]"
integer x = 4009
integer y = 556
integer width = 302
integer height = 244
integer taborder = 10
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "\Desarrollo 17\Imagenes\Botones\Apagar.png"
end type

event clicked;Parent.Hide()
end event

type st_encabe from statictext within w_movto_casinos_systray
integer x = 32
integer y = 32
integer width = 3694
integer height = 228
integer textsize = -26
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 16711680
string text = "MOVIMIENTOS DE CASINO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_1 from statictext within w_movto_casinos_systray
integer x = 32
integer y = 260
integer width = 3694
integer height = 540
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16711680
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

