$PBExportHeader$w_maed_casino_tipocolacion.srw
$PBExportComments$Mantención de Tipos de Colación y Colaciones
forward
global type w_maed_casino_tipocolacion from w_mant_encab_deta
end type
end forward

global type w_maed_casino_tipocolacion from w_mant_encab_deta
integer width = 2592
integer height = 1800
string title = "TIPOS DE COLACIONES"
string menuname = ""
event ue_validaregistro ( )
end type
global w_maed_casino_tipocolacion w_maed_casino_tipocolacion

type variables
uo_tipocolacion		iuo_TipoColacion
uo_colaciones		iuo_Colacion
uo_zona				iuo_Zona

String				is_ultimacol
end variables

forward prototypes
public function boolean duplicado (string as_columna, string as_valor)
public subroutine habilitaencab (boolean ib_habilita)
public subroutine habilitaingreso (string as_columna)
end prototypes

event ue_validaregistro();Integer	li_Contador
String	ls_Mensaje, ls_Columna[]

dw_1.AcceptText()

IF IsNull(dw_1.Object.caco_nombre[il_Fila]) OR &
	dw_1.Object.caco_nombre[il_Fila] = "" THEN
	li_Contador ++
	ls_Mensaje					+=	"~nDescripción"
	ls_Columna[li_Contador]	=	"caco_nombre"
END IF

IF IsNull(dw_1.Object.caco_abrevi[il_Fila]) OR &
	dw_1.Object.caco_abrevi[il_Fila] = "" THEN
	li_Contador ++
	ls_Mensaje					+=	"~nAbreviación"
	ls_Columna[li_Contador]	=	"caco_abrevi"
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
String	ls_Codigo

ls_Codigo	=	String(dw_1.Object.tico_codigo[il_Fila])

CHOOSE CASE as_Columna
	CASE "tico_codigo"
		ls_Codigo	=	as_Valor
		
END CHOOSE

ll_Fila	=	dw_1.Find("tico_codigo = " + ls_Codigo, &	
							1, dw_1.RowCount())

IF ll_Fila > 0 AND ll_Fila <> il_Fila THEN
	MessageBox("Error", "Registro ya fue ingresado anteriormente", &
					Information!, Ok!)
	RETURN True
ELSE
	RETURN False
END IF
end function

public subroutine habilitaencab (boolean ib_habilita);If ib_Habilita Then
	dw_2.Object.tico_codigo.Protect				=	0
	dw_2.Object.tico_codigo.BackGround.Color	=	RGB(255, 255, 255)
	dw_2.Object.tico_codigo.Color					=	0
Else
	dw_2.Object.tico_codigo.Protect				=	1
	dw_2.Object.tico_codigo.BackGround.Color	=	553648127
	dw_2.Object.tico_codigo.Color					=	RGB(255, 255, 255)
END If
end subroutine

public subroutine habilitaingreso (string as_columna);Boolean	lb_Estado = True

IF as_Columna <> "tico_codigo" AND &
	(dw_2.Object.tico_codigo[il_Fila] = 0 OR IsNull(dw_2.Object.tico_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF
	
IF as_Columna <> "tico_nombre" AND &
	(dw_2.Object.tico_nombre[il_Fila] = "" OR IsNull(dw_2.Object.tico_nombre[il_Fila])) THEN
	lb_Estado	=	False
END IF
	
pb_ins_det.Enabled = lb_Estado
end subroutine

on w_maed_casino_tipocolacion.create
call super::create
end on

on w_maed_casino_tipocolacion.destroy
call super::destroy
end on

event open;call super::open;is_Ultimacol			=	"caco_abrevi"
iuo_TipoColacion	=	Create uo_tipocolacion
iuo_Colacion		=	Create uo_colaciones
iuo_Zona				=	Create uo_zona
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_FilasDet, ll_FilasEnc

ll_FilasEnc		=	dw_2.Retrieve(iuo_Zona.Codigo, iuo_TipoColacion.Codigo)

IF ll_FilasEnc = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Encabezado de Colacion")

	RETURN
ELSEIF ll_FilasEnc > 0 THEN
				
	ll_FilasDet	=	dw_1.Retrieve(iuo_Zona.Codigo, iuo_TipoColacion.Codigo)
	
	IF ll_FilasDet = -1 THEN
		F_ErrorBaseDatos(sqlca, "Lectura de Detalle de Colacion")
	
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
dw_1.SetColumn("caco_nombre")
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

li_Secuencia	=	iuo_TipoColacion.Secuencias(iuo_TipoColacion.Codigo, sqlca)

FOR ll_Fila = 1 TO dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_Fila, 0, Primary!) = NewModified! THEN
		li_Secuencia ++
		
		dw_1.Object.zona_codigo[ll_Fila]	=	dw_2.Object.zona_codigo[1]
		dw_1.Object.tico_codigo[ll_Fila]	=	dw_2.Object.tico_codigo[1]
		dw_1.Object.caco_codigo[ll_Fila]	=	li_Secuencia
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
vinf.dw_1.DataObject	=	"dw_info_colaciones"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(iuo_Zona.Codigo, iuo_TipoColacion.Codigo)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
END IF

SetPointer(Arrow!)
end event

event ue_guardar;call super::ue_guardar;//iuo_TipoColacion.Existe(dw_2.Object.tico_codigo[1], False, sqlca)
end event

event ue_seleccion;call super::ue_seleccion;IF iuo_TipoColacion.Busqueda(sqlca, iuo_Zona.Codigo) THEN
	This.TriggerEvent("ue_recuperadatos")
ELSE
	pb_buscar.SetFocus()
END IF
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_casino_tipocolacion
integer x = 32
integer y = 596
integer width = 2126
integer height = 1028
integer taborder = 80
string title = "Detalle de Colaciones por Tipo"
string dataobject = "dw_mues_casino_colaciones"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE "caco_codigo"
//		IF Not iuo_Colacion.Existe(Integer(Data), True, sqlca) THEN
//			F_RestauraValor(il_Fila, ls_Columna, dw_1)
//			
//			RETURN 1
//		END IF
		
END CHOOSE
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

event dw_1::sqlpreview;//
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_casino_tipocolacion
integer x = 256
integer y = 36
integer width = 1623
integer height = 488
string dataobject = "dw_mant_casino_tipocolacion"
end type

event dw_2::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE "zona_codigo"
		IF Not iuo_Zona.Existe(Integer(Data), True, sqlca) THEN
			F_RestauraValor(il_Fila, ls_Columna, dw_2)
			RETURN 1
		END IF
		
	CASE "tico_codigo"
		IF iuo_TipoColacion.Existe(This.Object.zona_codigo[row], Integer(Data), False, sqlca) THEN
			This.AcceptText()
			Parent.TriggerEvent("ue_recuperadatos")
		Else
			iuo_TipoColacion.Codigo = Integer(Data)
		END IF
		
END CHOOSE

HabilitaIngreso(ls_Columna)
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_casino_tipocolacion
integer x = 2240
integer y = 268
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_casino_tipocolacion
integer x = 2240
integer y = 448
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_casino_tipocolacion
integer x = 2240
integer y = 632
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_casino_tipocolacion
integer x = 2240
integer y = 808
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_casino_tipocolacion
integer x = 2240
integer y = 988
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_casino_tipocolacion
integer x = 2240
integer y = 1272
integer taborder = 90
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_casino_tipocolacion
integer x = 2240
integer y = 1444
integer taborder = 100
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_casino_tipocolacion
integer x = 2240
end type

