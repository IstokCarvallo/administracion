$PBExportHeader$w_maed_rgto_tiposeventosenca.srw
$PBExportComments$Mantención de Tipos de Eventos para Rendir
forward
global type w_maed_rgto_tiposeventosenca from w_mant_encab_deta
end type
end forward

global type w_maed_rgto_tiposeventosenca from w_mant_encab_deta
integer width = 3063
integer height = 1740
string title = "Mantención de Eventos para Rendiciones"
string menuname = ""
event ue_validaregistro ( )
end type
global w_maed_rgto_tiposeventosenca w_maed_rgto_tiposeventosenca

type variables
uo_tipocolacion	iuo_TipoEvento
uo_colaciones	iuo_Concepto

String	is_ultimacol
end variables

forward prototypes
public function boolean duplicado (string as_columna, string as_valor)
public subroutine habilitaencab (boolean ib_habilita)
public subroutine habilitaingreso (string as_columna)
end prototypes

event ue_validaregistro();Integer	li_Contador
String	ls_Mensaje, ls_Columna[]

dw_1.AcceptText()

IF IsNull(dw_1.Object.rgcp_codigo[il_Fila]) OR &
	dw_1.Object.rgcp_codigo[il_Fila] = 0 THEN
	li_Contador ++
	ls_Mensaje 					+=	"~nConcepto de Rendición"
	ls_Columna[li_Contador]	= "rgcp_codigo"
END IF

IF IsNull(dw_1.Object.rgtd_descri[il_Fila]) OR &
	dw_1.Object.rgtd_descri[il_Fila] = "" THEN
	li_Contador ++
	ls_Mensaje					+=	"~nDescripción"
	ls_Columna[li_Contador]	=	"rgtd_descri"
END IF

IF dw_1.Object.rgcp_valref[il_Fila] = 1 THEN
	IF IsNull(dw_1.Object.rgtd_valref[il_Fila]) OR &
		dw_1.Object.rgtd_valref[il_Fila] <= 0 THEN
		li_Contador ++
		ls_Mensaje					+=	"~nValor de Referencia"
		ls_Columna[li_Contador]	=	"rgtd_valref"
	END IF
END IF

IF li_Contador > 0 THEN
	MessageBox("Error de Consistencia", "Falta el ingreso de :" + ls_Mensaje + &
					".", StopSign!, Ok!)
	dw_1.SetColumn(ls_Columna[1])
	dw_1.SetRow(il_Fila)
	dw_1.SetFocus()
	
	Message.DoubleParm	=	-1
END IF
end event

public function boolean duplicado (string as_columna, string as_valor);Long		ll_Fila
String	ls_Concepto

ls_Concepto	=	String(dw_1.Object.rgcp_codigo[il_Fila])

CHOOSE CASE as_Columna
	CASE "rgcp_codigo"
		ls_Concepto	=	as_Valor
		
END CHOOSE

ll_Fila	=	dw_1.Find("rgcp_codigo = " + ls_Concepto, &	
							1, dw_1.RowCount())

IF ll_Fila > 0 AND ll_Fila <> il_Fila THEN
	MessageBox("Error", "Registro ya fue ingresado anteriormente", &
					Information!, Ok!)
	RETURN True
ELSE
	RETURN False
END IF
end function

public subroutine habilitaencab (boolean ib_habilita);IF ib_Habilita THEN
	dw_2.Object.rgte_tipoev.Protect				=	0
	dw_2.Object.rgte_tipoev.BackGround.Color	=	RGB(255, 255, 255)
ELSE
	dw_2.Object.rgte_tipoev.Protect				=	1
	dw_2.Object.rgte_tipoev.BackGround.Color	=	RGB(192, 192, 192)
END IF

RETURN
end subroutine

public subroutine habilitaingreso (string as_columna);Boolean	lb_Estado = True

IF as_Columna <> "rgte_tipoev" AND &
	(dw_2.Object.rgte_tipoev[il_Fila] = 0 OR IsNull(dw_2.Object.rgte_tipoev[il_Fila])) THEN
	lb_Estado	=	False
END IF
	
IF as_Columna <> "rgte_nombre" AND &
	(dw_2.Object.rgte_nombre[il_Fila] = "" OR IsNull(dw_2.Object.rgte_nombre[il_Fila])) THEN
	lb_Estado	=	False
END IF
	
pb_ins_det.Enabled = lb_Estado
end subroutine

on w_maed_rgto_tiposeventosenca.create
call super::create
end on

on w_maed_rgto_tiposeventosenca.destroy
call super::destroy
end on

event open;call super::open;buscar			=	""
ordenar			=	""
is_Ultimacol	=	"rgtd_valref"
iuo_TipoEvento	=	Create uo_tipocolacion
iuo_Concepto	=	Create uo_colaciones
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_FilasDet, ll_FilasEnc

ll_FilasEnc		=	dw_2.Retrieve(iuo_TipoEvento.Codigo)

IF ll_FilasEnc = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Encabezado Inventario de Pallet")

	RETURN
ELSEIF ll_FilasEnc > 0 THEN
//	IF AlgúnControl THEN
//		istr_Mant.Solo_Consulta	=	True
//	ELSE
		istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
		iuo_TipoEvento.Existe(dw_2.Object.rgte_tipoev[1], False, sqlca)
//	END IF
ELSE
	RETURN
END IF
		
ll_FilasDet	=	dw_1.Retrieve(iuo_TipoEvento.Codigo)
	
IF ll_FilasDet = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Detalle Inventario de Pallet")

	RETURN
ELSE
	pb_Eliminar.Enabled  =	Not istr_mant.Solo_Consulta
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
	pb_ins_det.Enabled	=	Not istr_mant.Solo_Consulta
	pb_eli_det.Enabled	=	Not istr_mant.Solo_Consulta
		
	IF ll_FilasDet > 0 THEN
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
		
		HabilitaEncab(False)
	END IF

	pb_ins_det.SetFocus()
END IF
end event

event ue_nuevo_detalle;IF il_Fila > 0 THEN
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled		= True
END IF

il_Fila	=	dw_1.InsertRow(0)

dw_1.ScrollToRow(il_Fila)
dw_1.SetRow(il_Fila)
dw_1.SetFocus()
dw_1.SetColumn("rgcp_codigo")
end event

event ue_borra_detalle;IF dw_1.RowCount() < 1 THEN RETURN

IF dw_1.DeleteRow(0) <> 1 THEN
	MessageBox(This.Title, "No se puede borrar actual registro.")
END IF

IF dw_1.RowCount() = 0 THEN
	pb_eli_det.Enabled	=	False
ELSE
	il_Fila	=	dw_1.GetRow()
END IF
end event

event ue_antesguardar;call super::ue_antesguardar;Long		ll_Fila
Integer	li_Secuencia

//li_Secuencia	=	iuo_TipoEvento.Secuencias(iuo_TipoEvento.Codigo, sqlca)

FOR ll_Fila = 1 TO dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_Fila, 0, Primary!) = NewModified! THEN
		li_Secuencia ++
		
		dw_1.Object.rgte_tipoev[ll_Fila]	=	dw_2.Object.rgte_tipoev[1]
		dw_1.Object.rgtd_secuen[ll_Fila]	=	li_Secuencia
	END IF
NEXT
end event

event ue_nuevo;call super::ue_nuevo;HabilitaEncab(True)
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila

istr_info.titulo	=	"TIPOS DE EVENTO RENDICIÓN"
istr_info.copias	=	1

OpenWithParm(vinf,istr_info)

vinf.dw_1.DataObject	=	"dw_info_rgto_tiposevento"

vinf.dw_1.SetTransObject(sqlca)

fila = vinf.dw_1.Retrieve(iuo_TipoEvento.Codigo)

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

event ue_guardar;call super::ue_guardar;iuo_TipoEvento.Existe(dw_2.Object.rgte_tipoev[1], False, sqlca)
end event

event ue_seleccion;call super::ue_seleccion;//IF iuo_TipoEvento.Busqueda(sqlca) THEN
//	This.TriggerEvent("ue_recuperadatos")
//ELSE
//	pb_buscar.SetFocus()
//END IF
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_rgto_tiposeventosenca
integer x = 37
integer y = 412
integer width = 2642
integer height = 1220
integer taborder = 80
string title = "Detalle de Eventos"
string dataobject = "dw_mues_rgto_tiposeventodeta"
end type

event dw_1::itemchanged;call super::itemchanged;//String	ls_Columna, ls_Nula
//
//SetNull(ls_Nula)
//
//ls_Columna	=	dwo.Name
//
//CHOOSE CASE ls_Columna
//	CASE "rgcp_codigo"
//		IF Not iuo_Concepto.Existe(Integer(Data), True, sqlca) THEN
//			F_RestauraValor(il_Fila, ls_Columna, dw_1)
//			
//			RETURN 1
//		ELSE
//			This.Object.rgcp_valref[il_Fila]	=	iuo_Concepto.ValorReferencial
//		END IF
//		
//	CASE "rgtd_valref"
//		IF Dec(Data) <= 0 AND This.Object.rgcp_valref[il_Fila] = 1 THEN
//			MessageBox("Atención", "Valor de Referencia debe ser Mayor que Cero." + &
//							"~r~rIngrese otro Valor.", Exclamation!)
//			F_RestauraValor(il_Fila, ls_Columna, dw_1)
//			
//			RETURN 1
//		END IF
//		
//END CHOOSE
end event

event dw_1::dwnkey;call super::dwnkey;This.SetRedraw(False)

CHOOSE CASE key
	CASE KeyRightArrow!, KeyLeftArrow!
		This.SetRedraw(True)
		RETURN -1
		
	CASE KeyDownArrow!, KeyUpArrow!
		Message.DoubleParm = 0
		
		Parent.TriggerEvent("ue_validaregistro")
		
		IF Message.DoubleParm = -1 THEN
			This.SetRedraw(True)
			RETURN -1
		ELSEIF Key = KeyDownArrow! AND il_fila = dw_1.RowCount() THEN
			Parent.TriggerEvent("ue_nuevo_detalle")
		END IF
		
	CASE KeyTab!
		IF is_ultimacol = This.GetColumnName() AND il_fila = dw_1.RowCount() THEN
			Message.DoubleParm = 0
			
			Parent.TriggerEvent("ue_validaregistro")
			
			IF Message.DoubleParm = -1 THEN
				This.SetRedraw(True)
				RETURN -1
			END IF
		END IF

END CHOOSE

This.SetRedraw(True)
This.SetColumn(1)
This.SetFocus()

RETURN 0
end event

event dw_1::ue_seteafila;il_Fila	=	This.GetRow()
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_rgto_tiposeventosenca
integer x = 0
integer y = 0
integer width = 1600
integer height = 408
string dataobject = "dw_mant_rgto_tiposeventoenca"
end type

event dw_2::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE "rgte_tipoev"
		IF iuo_TipoEvento.Existe(Integer(Data), False, sqlca) THEN
			This.AcceptText()
			Parent.TriggerEvent("ue_recuperadatos")
		END IF
		
END CHOOSE

HabilitaIngreso(ls_Columna)
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 268
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 448
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 632
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 808
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 988
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 1272
integer taborder = 90
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 1444
integer taborder = 100
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_rgto_tiposeventosenca
integer x = 2775
integer y = 88
end type

