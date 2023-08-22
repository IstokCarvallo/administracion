$PBExportHeader$w_mant_mues_horariocolaciones.srw
$PBExportComments$Mantención de Colaciones por Horario
forward
global type w_mant_mues_horariocolaciones from w_mant_directo
end type
type st_5 from statictext within w_mant_mues_horariocolaciones
end type
type st_7 from statictext within w_mant_mues_horariocolaciones
end type
type em_fecha from editmask within w_mant_mues_horariocolaciones
end type
type uo_selzona from uo_seleccion_zonas within w_mant_mues_horariocolaciones
end type
type cb_genera from commandbutton within w_mant_mues_horariocolaciones
end type
type dw_2 from datawindow within w_mant_mues_horariocolaciones
end type
end forward

global type w_mant_mues_horariocolaciones from w_mant_directo
integer width = 4251
string title = "HORARIOS DE COLACIONES"
st_5 st_5
st_7 st_7
em_fecha em_fecha
uo_selzona uo_selzona
cb_genera cb_genera
dw_2 dw_2
end type
global w_mant_mues_horariocolaciones w_mant_mues_horariocolaciones

type variables
uo_HorarioColaciones	iuo_Horario
DataWindowChild		idw_Tipo1, idw_Tipo2, idw_Tipo3, idw_Tipo4, idw_Tipo5, &
							idw_Tipo6, idw_Tipo7, idwc_Colacion
							
							
uo_tipocolacion		iuo_tipocolacion
end variables

forward prototypes
public function boolean wf_cargahorario (integer ai_zona)
end prototypes

public function boolean wf_cargahorario (integer ai_zona);Boolean		lb_Retorno = True
Long			ll_Filas, ll_Fila, ll_Nueva
Date			ld_UltimaFecha, ld_Fecha
Integer		li_NroDia
Decimal		ld_Hora
Time			lt_Hora

dw_1.SetRedraw(False)

ld_UltimaFecha			=	iuo_Horario.UltimaFecha(uo_SelZona.Codigo, False, sqlca)
ld_Fecha					=	Date(em_Fecha.Text)
ll_Filas					=	dw_1.Retrieve(ai_Zona, ld_UltimaFecha)

FOR ll_Fila = 1 TO ll_Filas
	ll_Nueva	=	dw_1.InsertRow(0)
	
	dw_1.Object.zona_codigo[ll_Nueva]	=	dw_1.Object.zona_codigo[ll_Fila]
	dw_1.Object.cahc_fecini[ll_Nueva]	=	ld_Fecha
	dw_1.Object.cahc_nrodia[ll_Nueva]	=	dw_1.Object.cahc_nrodia[ll_Fila]
	dw_1.Object.cahc_horini[ll_Nueva]	=	dw_1.Object.cahc_horini[ll_Fila]
	dw_1.Object.tico_codigo[ll_Nueva]	=	dw_1.Object.tico_codigo[ll_Fila]
	dw_1.Object.cahc_fecter[ll_Nueva]	=	Date("2099/12/31")
	dw_1.Object.cahc_horter[ll_Nueva]	=	dw_1.Object.cahc_horter[ll_Fila]

	dw_1.Object.cahc_fecter[ll_Fila]		=	RelativeDate(ld_Fecha, -1)
NEXT

IF ll_Filas = 0 THEN
	//	Incluye las Colaciones que Faltan
	FOR li_NroDia = 1 TO 7
		lt_Hora	=	Time("00:00:00")
		
		FOR ld_Hora = 0 TO 23.5 STEP 0.5
			ll_Nueva	=	dw_1.InsertRow(0)
			
			dw_1.Object.zona_codigo[ll_Nueva]	=	uo_SelZona.Codigo
			dw_1.Object.cahc_fecini[ll_Nueva]	=	ld_Fecha
			dw_1.Object.cahc_nrodia[ll_Nueva]	=	li_NroDia
			dw_1.Object.cahc_horini[ll_Nueva]	=	lt_Hora
			dw_1.Object.cahc_fecter[ll_Nueva]	=	Date("2099/12/31")
			dw_1.Object.cahc_horter[ll_Nueva]	=	RelativeTime(lt_Hora, 1740)

			lt_Hora										=	RelativeTime(lt_Hora, 1800)
		NEXT
	NEXT
END IF

dw_1.SetFilter("zona_codigo = " + String(uo_SelZona.Codigo) + &
				" And String(cahc_fecini, 'dd/mm/yyyy') = '" + String(ld_Fecha, "dd/mm/yyyy") + "'")

dw_1.Filter()
dw_1.Sort()

dw_1.SetRedraw(True)

pb_Grabar.Enabled	=	Not istr_mant.Solo_Consulta

RETURN lb_Retorno
end function

event open;call super::open;Boolean	lb_Cerrar

IF IsNull(uo_SelZona.Codigo) THEN lb_Cerrar	=	True

This.Height	=	2410

dw_1.Modify("DataWindow.Footer.Height = 0")

IF lb_Cerrar THEN
	Close(This)
ELSE
	uo_SelZona.Seleccion(False, False)
	
	iuo_Horario	=	Create uo_HorarioColaciones
	
	dw_1.GetChild("tico_codigo_1", idw_Tipo1)
	dw_1.GetChild("tico_codigo_2", idw_Tipo2)
	dw_1.GetChild("tico_codigo_3", idw_Tipo3)
	dw_1.GetChild("tico_codigo_4", idw_Tipo4)
	dw_1.GetChild("tico_codigo_5", idw_Tipo5)
	dw_1.GetChild("tico_codigo_6", idw_Tipo6)
	dw_1.GetChild("tico_codigo_7", idw_Tipo7)

	idw_Tipo1.SetTransObject(sqlca)
	idw_Tipo2.SetTransObject(sqlca)
	idw_Tipo3.SetTransObject(sqlca)
	idw_Tipo4.SetTransObject(sqlca)
	idw_Tipo5.SetTransObject(sqlca)
	idw_Tipo6.SetTransObject(sqlca)
	idw_Tipo7.SetTransObject(sqlca)
	
	dw_2.SetTransObject(Sqlca)
END IF

iuo_tipocolacion	=	Create uo_tipocolacion
end event

event ue_imprimir;Long					ll_Fila
Date					ld_fecha
str_info				lstr_info
DataWindowChild	ldwc_Colacion

lstr_info.titulo	= "INFORME HORARIOS DE COLACION"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
ld_Fecha	=	date(em_fecha.Text)
vinf.dw_1.DataObject = "dw_info_horariocolaciones"
vinf.dw_1.SetTransObject(sqlca)
ll_Fila	=	vinf.dw_1.Retrieve(uo_SelZona.Codigo, ld_Fecha)

IF ll_Fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF ll_Fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	FOR ll_fila = 1 TO 7
		vinf.dw_1.GetChild('tico_codigo_' + String(ll_fila), ldwc_Colacion)
		
		ldwc_Colacion.SetTransObject(Sqlca)
		IF ldwc_Colacion.Retrieve(uo_SelZona.Codigo) = 0 THEN 
			ldwc_Colacion.InsertRow(0)
		END IF
	NEXT
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
END IF

SetPointer(Arrow!)

end event

event ue_recuperadatos;Long		ll_Filas
Date		ld_Fecha

ld_Fecha	=	Date(em_fecha.Text)
ll_Filas	=	dw_1.Retrieve(uo_SelZona.Codigo, ld_fecha)

IF ll_Filas = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")

	dw_1.SetRedraw(True)

	RETURN
ELSE
	istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
	pb_Grabar.Enabled			=	Not istr_mant.Solo_Consulta
		
	IF ll_Filas > 0 THEN
		pb_imprimir.Enabled	=	True
		pb_eliminar.Enabled	=	True

		dw_1.ScrollNextPage()

		dw_1.SetRow(99)
		dw_1.SetFocus()
	ELSE
		pb_insertar.SetFocus()
	END IF
END IF
end event

on w_mant_mues_horariocolaciones.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_7=create st_7
this.em_fecha=create em_fecha
this.uo_selzona=create uo_selzona
this.cb_genera=create cb_genera
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.em_fecha
this.Control[iCurrent+4]=this.uo_selzona
this.Control[iCurrent+5]=this.cb_genera
this.Control[iCurrent+6]=this.dw_2
end on

on w_mant_mues_horariocolaciones.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_7)
destroy(this.em_fecha)
destroy(this.uo_selzona)
destroy(this.cb_genera)
destroy(this.dw_2)
end on

event ue_antesguardar;call super::ue_antesguardar;dw_1.SetRedraw(False)
dw_1.SetFilter("")
dw_1.Filter()
end event

event ue_guardar;call super::ue_guardar;TriggerEvent("ue_recuperadatos")

dw_1.SetRedraw(True)
end event

event ue_borrar;IF dw_1.rowcount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar = True

IF MessageBox("Eliminación de Registro", "Está seguro de Eliminar este Registro", Question!, YesNo!) = 1 THEN
	IF dw_1.RowsMove(1, dw_1.RowCount(), Primary!, dw_1, 1, Delete!) = 1 THEN
		dw_2.DeleteRow(dw_2.GetRow())
		ib_borrar = False
		w_main.SetMicroHelp("Borrando Registro...")
		SetPointer(Arrow!)
	ELSE
		ib_borrar = False
		MessageBox(This.Title,"No se puede borrar actual registro.")
	END IF

 IF dw_1.RowCount() = 0 THEN
		pb_eliminar.Enabled = False
	ELSE
		il_fila = dw_1.GetRow()
	END IF
END IF
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_horariocolaciones
integer y = 40
integer width = 3735
integer height = 316
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_horariocolaciones
integer x = 3895
integer y = 948
integer taborder = 50
end type

event pb_nuevo::clicked;call super::clicked;Integer	li_Nula

SetNull(li_Nula)

pb_grabar.Enabled		=	False
pb_imprimir.Enabled	=	False
pb_eliminar.Enabled	=	False

uo_SelZona.dw_Seleccion.Object.Codigo[1]	=	li_Nula
uo_SelZona.Codigo									=	li_Nula
em_fecha.Text 										=	String(li_Nula)

dw_2.Reset()
end event

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_horariocolaciones
integer x = 3895
integer y = 140
integer taborder = 30
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_horariocolaciones
string tag = "Eliminar Rango"
integer x = 3858
integer y = 692
integer taborder = 70
string picturename = "\Desarrollo 17\Imagenes\Botones\Basurero.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Basurero-bn.png"
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_horariocolaciones
boolean visible = false
integer x = 3858
integer y = 496
integer taborder = 60
string picturename = "\Desarrollo\Bmp\INSERTE.BMP"
string disabledname = "\Desarrollo\Bmp\INSERTD.BMP"
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_horariocolaciones
integer x = 3895
integer y = 1624
integer taborder = 100
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_horariocolaciones
integer x = 3895
integer y = 1320
integer taborder = 90
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_horariocolaciones
integer x = 3895
integer y = 1152
integer taborder = 80
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_horariocolaciones
integer y = 384
integer width = 3735
integer height = 1748
integer taborder = 40
boolean titlebar = true
string title = "Horario Semanal"
string dataobject = "dw_mues_horariocolaciones"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::sqlpreview;//
end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

event dw_1::itemchanged;call super::itemchanged;String	ls_columna
Integer	li_null

SetNull(li_null)
ls_columna	=	dwo.name

CHOOSE CASE ls_columna
	CASE "tico_codigo"
		IF Not IsNull(data) THEN
			IF NOT iuo_tipocolacion.Existe(uo_selzona.Codigo, Integer(data), True, sqlca) THEN
				This.Object.tico_codigo[row]	=	li_null
				Return 1
				
			END IF
		END IF
		
END CHOOSE
end event

type st_5 from statictext within w_mant_mues_horariocolaciones
integer x = 667
integer y = 108
integer width = 155
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Zona"
boolean focusrectangle = false
end type

type st_7 from statictext within w_mant_mues_horariocolaciones
integer x = 667
integer y = 220
integer width = 192
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Fecha"
boolean focusrectangle = false
end type

type em_fecha from editmask within w_mant_mues_horariocolaciones
integer x = 910
integer y = 212
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type uo_selzona from uo_seleccion_zonas within w_mant_mues_horariocolaciones
event destroy ( )
integer x = 910
integer y = 100
integer height = 84
integer taborder = 10
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;dw_2.Retrieve(Codigo)

idw_Tipo1.Retrieve(Codigo)
idw_Tipo2.Retrieve(Codigo)
idw_Tipo3.Retrieve(Codigo)
idw_Tipo4.Retrieve(Codigo)
idw_Tipo5.Retrieve(Codigo)
idw_Tipo6.Retrieve(Codigo)
idw_Tipo7.Retrieve(Codigo)
end event

type cb_genera from commandbutton within w_mant_mues_horariocolaciones
integer x = 1344
integer y = 212
integer width = 343
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera"
end type

event clicked;IF MessageBox("Atención", "¿Está seguro de Generar Valorización~n~r" + &
					"para la Fecha Indicada?", Question!, YesNo!) = 1 THEN
	wf_CargaHorario(uo_SelZona.Codigo)
ELSE
	// No sé
END IF
end event

type dw_2 from datawindow within w_mant_mues_horariocolaciones
integer x = 2085
integer y = 76
integer width = 882
integer height = 248
boolean bringtotop = true
string title = "none"
string dataobject = "dw_mues_horariocolaciones_fecha"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF Row > 0 THEN
	This.SelectRow(0, False)
	This.SelectRow(Row, True)
	This.SetRow(Row)

	em_fecha.Text	=	String(This.Object.cahc_fecini[Row], 'dd/mm/yyyy')
END IF
end event

