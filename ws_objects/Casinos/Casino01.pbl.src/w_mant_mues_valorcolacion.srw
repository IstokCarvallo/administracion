$PBExportHeader$w_mant_mues_valorcolacion.srw
$PBExportComments$Mantención de Registro Precios de Venta.
forward
global type w_mant_mues_valorcolacion from w_mant_directo
end type
type st_5 from statictext within w_mant_mues_valorcolacion
end type
type st_7 from statictext within w_mant_mues_valorcolacion
end type
type em_fecha from editmask within w_mant_mues_valorcolacion
end type
type uo_selzona from uo_seleccion_zonas within w_mant_mues_valorcolacion
end type
type cb_genera from commandbutton within w_mant_mues_valorcolacion
end type
type dw_2 from datawindow within w_mant_mues_valorcolacion
end type
end forward

global type w_mant_mues_valorcolacion from w_mant_directo
integer width = 3008
string title = "VALORES DE COLACIONES"
st_5 st_5
st_7 st_7
em_fecha em_fecha
uo_selzona uo_selzona
cb_genera cb_genera
dw_2 dw_2
end type
global w_mant_mues_valorcolacion w_mant_mues_valorcolacion

type variables
uo_ValorColaciones	iuo_ValColacion
DataWindowChild		idw_Tipo, idwc_Colacion
end variables

forward prototypes
public subroutine wf_soloconsulta (boolean habilita)
public function boolean wf_cargacolaciones (integer ai_zona)
end prototypes

public subroutine wf_soloconsulta (boolean habilita);If Habilita Then
	dw_1.Enabled			=	False
	pb_grabar.Enabled	= 	False
	pb_imprimir.Enabled	= 	True
	This.Title					=	"VALOR COLACION CONSULTA DE REGISTRO"
Else	
	dw_1.Enabled			=	True
	pb_grabar.Enabled	= 	True
	pb_imprimir.Enabled	= 	True
	This.Title					=	'VALOR COLACION'
End If

Return
end subroutine

public function boolean wf_cargacolaciones (integer ai_zona);Boolean		lb_Retorno = True
Long			ll_Filas, ll_Fila, ll_Nueva
Date			ld_UltimaFecha, ld_Fecha
DataStore	lds_Colac

dw_1.SetRedraw(False)

lds_Colac				=	Create DataStore
lds_Colac.DataObject	=	"dw_mues_casino_colaciones"
ld_UltimaFecha			=	iuo_ValColacion.FechaUltimoValor(uo_SelZona.Codigo, False, sqlca)
ld_Fecha					=	Date(em_Fecha.Text)

lds_Colac.SetTransObject(sqlca)

lds_Colac.Retrieve(ai_Zona, -1)

ll_Filas	=	dw_1.Retrieve(ai_Zona, ld_UltimaFecha)

FOR ll_Fila = 1 TO ll_Filas
	ll_Nueva	=	dw_1.InsertRow(0)
	
	dw_1.Object.zona_codigo[ll_Nueva]	=	dw_1.Object.zona_codigo[ll_Fila]
	dw_1.Object.tico_codigo[ll_Nueva]	=	dw_1.Object.tico_codigo[ll_Fila]
	dw_1.Object.caco_codigo[ll_Nueva]	=	dw_1.Object.caco_codigo[ll_Fila]
	dw_1.Object.caco_nombre[ll_Nueva]	=	dw_1.Object.caco_nombre[ll_Fila]
	dw_1.Object.cavc_fecini[ll_Nueva]	=	ld_Fecha
	dw_1.Object.cavc_fecter[ll_Nueva]	=	Date("2099/12/31")
	dw_1.Object.cavc_valcol[ll_Nueva]	=	dw_1.Object.cavc_valcol[ll_Fila]

	dw_1.Object.cavc_fecter[ll_Fila]		=	RelativeDate(ld_Fecha, -1)
NEXT

//	Incluye las Colaciones que Faltan
FOR ll_Fila = 1 TO lds_Colac.RowCount()
	IF dw_1.Find("zona_codigo = " + String(uo_SelZona.Codigo) + &
				" And tico_codigo = " + String(lds_Colac.Object.tico_codigo[ll_Fila]) + &
				" And caco_codigo = " + String(lds_Colac.Object.caco_codigo[ll_Fila]), &
				1, dw_1.RowCount()) = 0 THEN
				
		ll_Nueva	=	dw_1.InsertRow(0)
		
		dw_1.Object.zona_codigo[ll_Nueva]	=	uo_SelZona.Codigo
		dw_1.Object.tico_codigo[ll_Nueva]	=	lds_Colac.Object.tico_codigo[ll_Fila]
		dw_1.Object.caco_codigo[ll_Nueva]	=	lds_Colac.Object.caco_codigo[ll_Fila]
		dw_1.Object.caco_nombre[ll_Nueva]	=	lds_Colac.Object.caco_nombre[ll_Fila]
		dw_1.Object.cavc_fecini[ll_Nueva]	=	ld_Fecha
		dw_1.Object.cavc_fecter[ll_Nueva]	=	Date("2099/12/31")
		dw_1.Object.cavc_valcol[ll_Nueva]	=	0
	END IF
NEXT

dw_1.SetFilter("zona_codigo = " + String(uo_SelZona.Codigo) + &
				" And String(cavc_fecini, 'dd/mm/yyyy') = '" + String(ld_Fecha, "dd/mm/yyyy") + "'")

dw_1.Filter()
dw_1.Sort()

dw_1.SetRedraw(True)

pb_Grabar.Enabled	=	Not istr_mant.Solo_Consulta

RETURN lb_Retorno
end function

event open;call super::open;Boolean	lb_Cerrar

IF IsNull(uo_SelZona.Codigo) THEN lb_Cerrar	=	True

IF lb_Cerrar THEN
	Close(This)
ELSE
	uo_SelZona.Seleccion(False,False)

	iuo_ValColacion		=	Create uo_ValorColaciones
	
	dw_1.GetChild("tico_codigo", idw_Tipo)
	idw_Tipo.SetTransObject(sqlca)
	
	dw_2.SetTransObject(Sqlca)
END IF
end event

event ue_imprimir;Long		ll_Fila
Date		ld_fecha
str_info	lstr_info

lstr_info.titulo	= "INFORME VALORIZACION COLACION"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
ld_Fecha	=	date(em_fecha.Text)
vinf.dw_1.DataObject = "dw_info_valorcolacion"
vinf.dw_1.SetTransObject(sqlca)
vinf.dw_1.GetChild('tico_codigo', idwc_Colacion)

idwc_Colacion.SetTransObject(Sqlca)
If idwc_Colacion.Retrieve(uo_SelZona.Codigo) = 0 Then 
	idwc_Colacion.InsertRow(0)
End If

ll_Fila	=	vinf.dw_1.Retrieve(ld_Fecha, uo_SelZona.Codigo)

IF ll_Fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF ll_Fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo	)
END IF

SetPointer(Arrow!)

end event

event ue_recuperadatos;Long		ll_Filas
Date		ld_Fecha

ld_Fecha	=	Date(em_fecha.Text)
ll_Filas	=	dw_1.Retrieve(uo_SelZona.Codigo, ld_Fecha)

IF ll_Filas = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")

	dw_1.SetRedraw(True)

	RETURN
ELSE
	IF ld_Fecha	=	iuo_ValColacion.SiguienteFecha(uo_SelZona.Codigo, False, Sqlca) THEN
		istr_Mant.Solo_Consulta	=	True
	ELSE
		istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
	END IF

	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
		
	IF ll_Filas > 0 THEN
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
	ELSE
		pb_insertar.SetFocus()
	END IF
END IF
end event

on w_mant_mues_valorcolacion.create
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

on w_mant_mues_valorcolacion.destroy
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

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_valorcolacion
integer width = 2418
integer height = 316
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_valorcolacion
integer x = 2674
integer y = 920
integer taborder = 50
end type

event pb_nuevo::clicked;call super::clicked;Integer	li_Nula

SetNull(li_Nula)

pb_grabar.Enabled		=	False
pb_imprimir.Enabled	=	False

uo_SelZona.dw_Seleccion.Object.Codigo[1]	=	li_Nula
uo_SelZona.Codigo									=	li_Nula
em_fecha.Text 										=	String(li_Nula)

dw_2.Reset()
end event

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_valorcolacion
integer x = 2665
integer y = 156
integer taborder = 30
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_valorcolacion
boolean visible = false
integer x = 2679
integer y = 780
integer taborder = 70
string picturename = "\Desarrollo 17\Imagenes\Botones\Basurero.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Basurero-bn.png"
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_valorcolacion
boolean visible = false
integer x = 2633
integer y = 492
integer taborder = 60
string picturename = "\Desarrollo\Bmp\INSERTE.BMP"
string disabledname = "\Desarrollo\Bmp\INSERTD.BMP"
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_valorcolacion
integer x = 2661
integer y = 1624
integer taborder = 100
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_valorcolacion
integer x = 2661
integer y = 1292
integer taborder = 90
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_valorcolacion
integer x = 2656
integer y = 1124
integer taborder = 80
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_valorcolacion
integer y = 428
integer width = 2418
integer height = 1380
integer taborder = 40
boolean titlebar = true
string title = "Valores de Colaciones"
string dataobject = "dw_mues_valorcolacion"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::sqlpreview;//
end event

type st_5 from statictext within w_mant_mues_valorcolacion
integer x = 160
integer y = 136
integer width = 192
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Zona"
boolean focusrectangle = false
end type

type st_7 from statictext within w_mant_mues_valorcolacion
integer x = 160
integer y = 248
integer width = 210
integer height = 64
boolean bringtotop = true
integer textsize = -8
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

type em_fecha from editmask within w_mant_mues_valorcolacion
integer x = 402
integer y = 236
integer width = 448
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type uo_selzona from uo_seleccion_zonas within w_mant_mues_valorcolacion
event destroy ( )
integer x = 402
integer y = 128
integer height = 84
integer taborder = 10
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;dw_2.Retrieve(Codigo)

idw_Tipo.Retrieve(Codigo)
end event

type cb_genera from commandbutton within w_mant_mues_valorcolacion
integer x = 928
integer y = 240
integer width = 343
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Genera"
end type

event clicked;IF MessageBox("Atención", "¿Está seguro de Generar Valorización~n~r" + &
					"para la Fecha Indicada?", Question!, YesNo!) = 1 THEN
	wf_CargaColaciones(uo_SelZona.Codigo)
ELSE
	// No sé
END IF
end event

type dw_2 from datawindow within w_mant_mues_valorcolacion
integer x = 1531
integer y = 104
integer width = 919
integer height = 240
boolean bringtotop = true
string title = "none"
string dataobject = "dw_mues_valorcolacion_fecha"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF Row > 0 THEN
	This.SelectRow(0, False)
	This.SelectRow(Row, True)

	em_fecha.Text	=	String(This.Object.cavc_fecini[Row], 'dd/mm/yyyy')
END IF
end event

