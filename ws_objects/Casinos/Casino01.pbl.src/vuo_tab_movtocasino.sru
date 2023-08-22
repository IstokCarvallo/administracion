$PBExportHeader$vuo_tab_movtocasino.sru
forward
global type vuo_tab_movtocasino from userobject
end type
type cb_sincola from commandbutton within vuo_tab_movtocasino
end type
type cb_asignar from commandbutton within vuo_tab_movtocasino
end type
type cbx_tipo from checkbox within vuo_tab_movtocasino
end type
type cbx_hora from checkbox within vuo_tab_movtocasino
end type
type cb_llamar from commandbutton within vuo_tab_movtocasino
end type
type cb_confirmado from commandbutton within vuo_tab_movtocasino
end type
type dw_colac from datawindow within vuo_tab_movtocasino
end type
type dw_horas from datawindow within vuo_tab_movtocasino
end type
type pb_eliminar from picturebutton within vuo_tab_movtocasino
end type
type pb_insertar from picturebutton within vuo_tab_movtocasino
end type
type dw_2 from datawindow within vuo_tab_movtocasino
end type
type dw_1 from uo_dw within vuo_tab_movtocasino
end type
type gb_asignacion from groupbox within vuo_tab_movtocasino
end type
type gb_todos from groupbox within vuo_tab_movtocasino
end type
end forward

global type vuo_tab_movtocasino from userobject
integer width = 3255
integer height = 1504
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_nuevo ( )
event ue_borrar ( )
event ue_resize pbm_size
cb_sincola cb_sincola
cb_asignar cb_asignar
cbx_tipo cbx_tipo
cbx_hora cbx_hora
cb_llamar cb_llamar
cb_confirmado cb_confirmado
dw_colac dw_colac
dw_horas dw_horas
pb_eliminar pb_eliminar
pb_insertar pb_insertar
dw_2 dw_2
dw_1 dw_1
gb_asignacion gb_asignacion
gb_todos gb_todos
end type
global vuo_tab_movtocasino vuo_tab_movtocasino

type variables
Integer								ii_zona, ii_area, ii_tipoco, il_fila, il_filatrans
Date									id_fecha
String								is_rut


DataWindowChild					idwc_colaciones, idwc_horarios

w_maed_movimiento_colaciones	iw_me
uo_personacasino					iuo_percas
end variables

forward prototypes
public subroutine referencias (window aw_me, string as_usuario, integer ai_caco_codigo, date ad_fecha)
public function boolean filtra ()
public function boolean puedeinvitar (string as_cape_codigo)
public subroutine wf_carga_estado (integer ai_estado)
end prototypes

event ue_nuevo();Integer	li_filas

li_filas =	dw_1.GetRow()

IF PuedeInvitar(dw_1.Object.cape_codigo[li_filas]) THEN
	li_filas										=	dw_1.InsertRow(li_filas + 1)
	dw_1.Object.cape_codigo[li_filas]	=	dw_1.Object.cape_codigo[li_filas - 1]
	dw_1.Object.cape_apepat[li_filas]	=	dw_1.Object.cape_apepat[li_filas - 1]
	dw_1.Object.cape_apemat[li_filas]	=	dw_1.Object.cape_apemat[li_filas - 1]
	dw_1.Object.cape_nombre[li_filas]	=	dw_1.Object.cape_nombre[li_filas - 1]
	dw_1.Object.caar_codigo[li_filas]	=	dw_1.Object.caar_codigo[li_filas - 1]
	dw_1.Object.tico_codigo[li_filas]	=	dw_1.Object.tico_codigo[li_filas - 1]
	dw_1.Object.zona_codigo[li_filas]	=	dw_1.Object.zona_codigo[li_filas - 1]
	dw_1.Object.camv_fechac[li_filas]	=	dw_1.Object.camv_fechac[li_filas - 1]
	dw_1.Object.camv_estado[li_filas]	=	0
	dw_1.Object.camv_invcur[li_filas]	=	1
	il_fila										=	li_filas
	is_rut										=	""
	
	dw_1.ScrollToRow(il_fila)
	dw_1.SetRow(il_fila)
	dw_1.SetColumn("camv_rutinv")
	dw_1.SetFocus()
END IF
end event

event ue_borrar();IF dw_1.RowCount() < 1 THEN Return

dw_1.DeleteRow(dw_1.GetRow())

end event

event ue_resize;Decimal		ld_nuevax

This.width			=	newwidth
This.Height			=	newheight

pb_insertar.x		=	newwidth - 279
pb_eliminar.x		=	newwidth - 279

gb_asignacion.x	=	newwidth - 400
gb_todos.x			=	newwidth - 400

dw_1.width			=	newwidth  - 444
dw_1.Height			=	newheight - 64

ld_nuevax			=	gb_asignacion.x + (gb_asignacion.Width / 2)
cbx_tipo.x			=	ld_nuevax - (cbx_tipo.Width / 2)
cbx_hora.x			=	ld_nuevax - (cbx_hora.Width / 2)
cb_asignar.x		=	ld_nuevax - (cb_asignar.Width / 2)

cb_confirmado.x	=	ld_nuevax - (cb_confirmado.Width / 2)
cb_Llamar.x			=	ld_nuevax - (cb_Llamar.Width / 2)
cb_sincola.x		=	ld_nuevax - (cb_sincola.Width / 2)
end event

public subroutine referencias (window aw_me, string as_usuario, integer ai_caco_codigo, date ad_fecha);iw_me			=	Create w_maed_movimiento_colaciones
iw_me			=	aw_me
ii_tipoco	=	ai_caco_codigo
id_fecha		=	ad_fecha

iw_me.dw_1.Sharedata(dw_1)
iw_me.dw_3.Sharedata(dw_2)

iuo_percas.Existe(as_usuario, True, sqlca)
end subroutine

public function boolean filtra ();Integer	li_fila, li_find
Boolean	lb_retorno = True

dw_1.SetFilter("tico_codigo = " + String(ii_tipoco))
dw_1.Filter()
	
dw_colac.Retrieve(iuo_percas.zona_codigo, ii_tipoco)
dw_horas.Retrieve(iuo_percas.zona_codigo, id_fecha, ii_tipoco)

IF dw_colac.RowCount() * dw_horas.RowCount() = 0 THEN
	Return False
END IF

IF dw_1.RowCount() <> dw_2.RowCount() THEN
	FOR li_fila = 1 TO dw_2.RowCount()
		li_find	=	dw_1.Find("cape_codigo = '" + dw_2.Object.cape_codigo[li_fila] + "'", 1, dw_1.RowCount())
		IF li_find = 0 THEN
			li_find									=	dw_1.InsertRow(0)
			dw_1.Object.cape_codigo[li_find]	=	dw_2.Object.cape_codigo[li_fila]
			dw_1.Object.cape_apepat[li_find]	=	dw_2.Object.cape_apepat[li_fila]
			dw_1.Object.cape_apemat[li_find]	=	dw_2.Object.cape_apemat[li_fila]
			dw_1.Object.cape_nombre[li_find]	=	dw_2.Object.cape_nombre[li_fila]
			dw_1.Object.caar_codigo[li_find]	=	dw_2.Object.caar_codigo[li_fila]
			dw_1.Object.tico_codigo[li_find]	=	ii_tipoco
			dw_1.Object.zona_codigo[li_find]	=	iuo_percas.zona_codigo
			dw_1.Object.camv_fechac[li_find]	=	id_fecha
			dw_1.Object.camv_estado[li_find]	=	1
			dw_1.Object.camv_invcur[li_find]	=	0
			dw_1.Object.caco_codigo[li_find]	=	dw_colac.Object.caco_codigo[1]
			dw_1.Object.caco_nombre[li_find]	=	dw_colac.Object.caco_nombre[1]
			dw_1.Object.camv_horaco[li_find]	=	dw_horas.Object.cahc_horini[1]
			
		END IF
		
	NEXT
END IF
dw_1.SetSort("tico_codigo, cape_apepat, cape_apemat, cape_nombre")
dw_1.Sort()

FOR li_fila = 1 TO dw_1.RowCount()
	li_find	=	dw_colac.Find("caco_codigo = " + String(dw_1.Object.caco_codigo[li_fila]), &
																1, dw_colac.RowCount())
	IF li_find > 0 THEN
		dw_1.Object.caco_nombre[li_fila]	=	dw_colac.Object.caco_abrevi[li_find]
	END IF
NEXT

Return lb_retorno
end function

public function boolean puedeinvitar (string as_cape_codigo);Integer	li_fila, li_recorre, li_invitados

li_fila	=	dw_2.Find ("cape_codigo = '" + as_cape_codigo + "'", 1, dw_2.RowCount())
								
If li_fila > 0 Then
	If dw_2.Object.cape_invita[li_fila] = 1 Then
		FOR li_recorre = 1 TO dw_1.RowCount()
			If dw_1.Object.cape_codigo[li_recorre] = as_cape_codigo Then
				li_invitados ++
			End If
		NEXT
		li_invitados --
		If li_invitados <= dw_2.Object.cape_topein[li_fila] Then
			Return True
		Else
			MessageBox("Error", "El personal seleccionado no puede realizar mas invitaciones.~r~n" + &
									"No es posible cursar invitaciones a su nombre.", StopSign!)
			Return False
		End If
	Else
		MessageBox("Error", "El personal seleccionado no esta habilitado para realizar invitaciones.~r~n" + &
								"No es posible cursar invitaciones a su nombre.", StopSign!)
		Return False
	End If
Else
	MessageBox("Error", "No se puede encontrar al personal seleccionado.~r~n" + &
								"No es posible cursar invitaciones a su nombre.", StopSign!)
	Return False
End If
end function

public subroutine wf_carga_estado (integer ai_estado);Long	ll_Fila

FOR ll_Fila  = 1 To dw_1.RowCount()
	IF dw_1.Object.camv_estado[ll_Fila] <> 9 THEN
		dw_1.Object.camv_estado[ll_Fila]	=	ai_Estado
	END IF
NEXT
end subroutine

on vuo_tab_movtocasino.create
this.cb_sincola=create cb_sincola
this.cb_asignar=create cb_asignar
this.cbx_tipo=create cbx_tipo
this.cbx_hora=create cbx_hora
this.cb_llamar=create cb_llamar
this.cb_confirmado=create cb_confirmado
this.dw_colac=create dw_colac
this.dw_horas=create dw_horas
this.pb_eliminar=create pb_eliminar
this.pb_insertar=create pb_insertar
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_asignacion=create gb_asignacion
this.gb_todos=create gb_todos
this.Control[]={this.cb_sincola,&
this.cb_asignar,&
this.cbx_tipo,&
this.cbx_hora,&
this.cb_llamar,&
this.cb_confirmado,&
this.dw_colac,&
this.dw_horas,&
this.pb_eliminar,&
this.pb_insertar,&
this.dw_2,&
this.dw_1,&
this.gb_asignacion,&
this.gb_todos}
end on

on vuo_tab_movtocasino.destroy
destroy(this.cb_sincola)
destroy(this.cb_asignar)
destroy(this.cbx_tipo)
destroy(this.cbx_hora)
destroy(this.cb_llamar)
destroy(this.cb_confirmado)
destroy(this.dw_colac)
destroy(this.dw_horas)
destroy(this.pb_eliminar)
destroy(this.pb_insertar)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_asignacion)
destroy(this.gb_todos)
end on

event constructor;iuo_percas		=	Create uo_personacasino

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_horas.SetTransObject(sqlca)
dw_colac.SetTransObject(sqlca)

dw_1.GetChild("caco_codigo", idwc_colaciones)
idwc_colaciones.SetTransObject(sqlca)

dw_1.GetChild("camv_horaco", idwc_horarios)
idwc_horarios.SetTransObject(sqlca)

end event

type cb_sincola from commandbutton within vuo_tab_movtocasino
integer x = 2875
integer y = 1040
integer width = 343
integer height = 112
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sin Colación"
end type

event clicked;dw_1.SetRedraw(False)

wf_carga_estado(5)

dw_1.SetRedraw(True)
end event

type cb_asignar from commandbutton within vuo_tab_movtocasino
integer x = 2871
integer y = 780
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Asignar"
end type

event clicked;Integer			li_fila
str_busqueda	lstr_busq

lstr_busq.Argum[1]	=	String(iuo_percas.zona_codigo)
lstr_busq.Argum[2]	=	String(ii_tipoco)
lstr_busq.Argum[3]	=	String(id_fecha)

IF cbx_tipo.Checked THEN
	OpenWithParm(w_busc_casino_colaciones, lstr_busq)
	lstr_busq	=	Message.PowerobjectParm
	
	IF lstr_busq.Argum[4] <> "" THEN
		FOR li_fila = 1 TO dw_1.RowCount()
			IF dw_1.Object.flag[li_fila] = 1 THEN 
				dw_1.Object.caco_codigo[li_fila]	=	Integer(lstr_busq.Argum[4])
				dw_1.Object.caco_nombre[li_fila]	=	lstr_busq.Argum[5]
			END IF
		NEXT
	END IF
	
END IF

IF cbx_hora.Checked THEN
	OpenWithParm(w_busc_hora_colacion, lstr_busq)
	lstr_busq	=	Message.PowerobjectParm
	
	IF lstr_busq.Argum[4] <> "" THEN
		FOR li_fila = 1 TO dw_1.RowCount()
			IF dw_1.Object.flag[li_fila] = 1 THEN 
				dw_1.Object.camv_horaco[li_fila]	=	Time(lstr_busq.Argum[4])
				
			END IF
		NEXT
		
	END IF
	
END IF

FOR li_fila = 1 TO dw_1.RowCount()
	IF dw_1.Object.flag[li_fila] = 1 THEN
		dw_1.Object.flag[li_fila] 	= 	0
	END IF
NEXT
end event

type cbx_tipo from checkbox within vuo_tab_movtocasino
integer x = 2921
integer y = 616
integer width = 238
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Tipo"
end type

event clicked;IF This.Checked THEN 
	cb_asignar.Enabled	=	True
ELSE
	IF NOT cbx_hora.Checked THEN
		cb_asignar.Enabled	=	False
	END IF
END IF
end event

type cbx_hora from checkbox within vuo_tab_movtocasino
integer x = 2921
integer y = 696
integer width = 238
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Hora"
end type

event clicked;IF This.Checked THEN 
	cb_asignar.Enabled	=	True
ELSE
	IF NOT cbx_tipo.Checked THEN
		cb_asignar.Enabled	=	False
	END IF
END IF
end event

type cb_llamar from commandbutton within vuo_tab_movtocasino
integer x = 2875
integer y = 1288
integer width = 343
integer height = 112
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Llamar"
end type

event clicked;dw_1.SetRedraw(False)

wf_carga_estado(0)

dw_1.SetRedraw(True)
end event

type cb_confirmado from commandbutton within vuo_tab_movtocasino
integer x = 2875
integer y = 1164
integer width = 343
integer height = 112
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Confirmad."
end type

event clicked;dw_1.SetRedraw(False)

wf_carga_estado(1)

dw_1.SetRedraw(True)
end event

type dw_colac from datawindow within vuo_tab_movtocasino
boolean visible = false
integer x = 3031
integer y = 1592
integer width = 155
integer height = 132
integer taborder = 60
string title = "none"
string dataobject = "dw_mues_casino_colaciones_bloqueado"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_horas from datawindow within vuo_tab_movtocasino
boolean visible = false
integer x = 3031
integer y = 1592
integer width = 155
integer height = 132
integer taborder = 50
string title = "none"
string dataobject = "dw_mues_horarios_colacion_fechazonatipo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_eliminar from picturebutton within vuo_tab_movtocasino
event mousemove pbm_mousemove
string tag = "Eliminar Detalle"
integer x = 2885
integer y = 284
integer width = 300
integer height = 245
integer taborder = 40
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Signo Menos.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Signo Menos-bn.png"
alignment htextalign = left!
string powertiptext = "Eliminar Detalle"
end type

event clicked;Parent.TriggerEvent("ue_borrar")
end event

type pb_insertar from picturebutton within vuo_tab_movtocasino
event mousemove pbm_mousemove
string tag = "Ingresar Nuevo Detalle"
integer x = 2885
integer y = 40
integer width = 300
integer height = 245
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Signo Mas.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Signo Mas-bn.png"
alignment htextalign = left!
string powertiptext = "Ingresar Nuevo Detalle"
end type

event clicked;Parent.TriggerEvent("ue_nuevo")
end event

type dw_2 from datawindow within vuo_tab_movtocasino
boolean visible = false
integer x = 3031
integer y = 1592
integer width = 155
integer height = 132
integer taborder = 20
string title = "none"
string dataobject = "dw_mues_casino_personalcolacion_usuario"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from uo_dw within vuo_tab_movtocasino
integer x = 32
integer y = 32
integer width = 2789
integer height = 1440
integer taborder = 10
string title = "Movimiento Colaciones"
string dataobject = "dw_mues_movtocolaciones"
boolean hscrollbar = true
end type

event clicked;call super::clicked;IF row < 1 THEN Return

IF dw_1.Object.control[row] = 1 OR &
	dw_1.Object.camv_estado[row] = 9 THEN
	pb_insertar.Enabled	=	False
	pb_eliminar.Enabled	=	False
	
ELSE 
	pb_insertar.Enabled	=	True
	pb_eliminar.Enabled	=	True
	
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.AcceptText()

IF CurrentRow < 1 THEN Return

IF dw_1.Object.control[CurrentRow] = 1 OR &
	dw_1.Object.camv_estado[CurrentRow] = 9 THEN
	pb_insertar.Enabled	=	False
	pb_eliminar.Enabled	=	False
ELSE
	pb_insertar.Enabled	=	True
	pb_eliminar.Enabled	=	True
END IF
end event

event itemchanged;call super::itemchanged;String		ls_columna, valor, ls_null
Integer		li_find


SetNull(ls_null)

ls_columna = dwo.name

CHOOSE CASE ls_columna
	CASE "camv_rutinv"
		IF LEN(data) > 6 THEN
			is_rut = F_verrut(data, True)
		
			IF is_rut = ""  THEN
				This.SetItem(row, ls_columna, ls_null)
				RETURN 1
			END IF
		END IF
		
	CASE "camv_estado"
		IF Data = '9' THEN
			IF MessageBox("ADVERTENCIA", "Si selecciona el estado REALIZADO, No podrá modificarlo posteriormente.~r~n"+&
												  "¿Está seguro del cambio?", Question!, OKCancel!, 2) = 2 THEN
				This.SetItem(row, ls_columna, 1)
				RETURN 1
			END IF
		END IF
		
	CASE "caco_codigo"
		li_find	=	dw_colac.Find("caco_codigo = " + data, 1, dw_colac.RowCount())
		IF li_find > 0 THEN
			dw_1.Object.caco_nombre[row]	=	dw_colac.Object.caco_abrevi[li_find]
		ELSE
			MessageBox("Error", "El codigo ingresado no existe. Favor ingrese otro.")
			This.SetItem(row, ls_columna, Integer(ls_null))
			RETURN 1
		END IF
	
	CASE "camv_horaco"
		li_find	=	dw_horas.Find("cahc_horini = " + data, 1, dw_horas.RowCount())
		IF li_find > 0 THEN
			dw_1.Object.camv_horaco[row]	=	dw_horas.Object.cahc_horini[li_find]
		ELSE
			MessageBox("Error", "La hora ingresada no existe. Favor ingrese otro.")
			This.SetItem(row, ls_columna, Time(ls_null))
			RETURN 1
		END IF
		
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String 	ls_codigo

IF dwo.Name <> "camv_rutinv" THEN
	IF il_fila <> 0 AND NOT IsNull(il_fila) THEN
		ls_codigo	=	This.Object.camv_rutinv[il_fila]
		IF LEN(ls_codigo) < 7 THEN
			This.SetItem(il_fila, "camv_rutinv", Right('000000', 6 - len(ls_codigo)) + ls_codigo)
		END IF
	END IF
END IF
end event

event buttonclicked;call super::buttonclicked;string			ls_columna
str_busqueda	lstr_busq

IF row < 1 THEN Return

lstr_busq.Argum[1]	=	String(iuo_percas.zona_codigo)
lstr_busq.Argum[2]	=	String(ii_tipoco)
lstr_busq.Argum[3]	=	String(id_fecha, 'dd/mm/yyyy')

ls_columna	=	dwo.name

CHOOSE CASE ls_columna
	CASE "b_buscacolacion"
		OpenWithParm(w_busc_casino_colaciones, lstr_busq)
		lstr_busq	=	Message.PowerobjectParm
		
		IF lstr_busq.Argum[4] <> "" THEN
			This.Object.caco_codigo[row]	=	Integer(lstr_busq.Argum[4])
			This.Object.caco_nombre[row]	=	lstr_busq.Argum[5]
		END IF
	CASE "b_buscahora"
		OpenWithParm(w_busc_hora_colacion, lstr_busq)
		lstr_busq	=	Message.PowerobjectParm
		
		IF lstr_busq.Argum[4] <> "" THEN
			This.Object.camv_horaco[row]	=	Time(lstr_busq.Argum[4])
		END IF
END CHOOSE
end event

event losefocus;call super::losefocus;//is_rut		=	String(Double(Mid(is_rut, 1, Len(is_rut) - 1)), "000000000") + &
//					Mid(is_rut, Len(is_rut))
//
//This.SetItem(il_fila, "camv_rutinv", is_rut)
//
//AcceptText()
end event

type gb_asignacion from groupbox within vuo_tab_movtocasino
integer x = 2843
integer y = 544
integer width = 398
integer height = 356
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Asignación"
end type

type gb_todos from groupbox within vuo_tab_movtocasino
integer x = 2843
integer y = 948
integer width = 398
integer height = 484
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Todos"
end type

