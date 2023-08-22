$PBExportHeader$w_mant_deta_tipomovto.srw
forward
global type w_mant_deta_tipomovto from w_mant_detalle
end type
end forward

global type w_mant_deta_tipomovto from w_mant_detalle
integer width = 3045
integer height = 1772
string title = "Unidad de Medida"
boolean controlmenu = true
end type
global w_mant_deta_tipomovto w_mant_deta_tipomovto

type variables

end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo = String(dw_1.GetItemNumber(il_fila, "tpmv_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
		
End Choose

ll_fila = istr_mant.dw.Find("tpmv_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

IF ll_fila > 0 and ll_fila <> il_FilaAnc THEN
	MessageBox("Error","Código de Tipo Movimiento ya fue Ingresado Anteriormente",Information!, OK!)
	RETURN true
ELSE
	RETURN False
END IF


end function

on w_mant_deta_tipomovto.create
call super::create
end on

on w_mant_deta_tipomovto.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "tpmv_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "tpmv_nombre")
ias_campo[3] = String(dw_1.GetItemNumber(il_fila, "tpmv_sentid"))
ias_campo[4] = String(dw_1.GetItemNumber(il_fila, "tpmv_tipodo"))
ias_campo[5] = String(dw_1.GetItemNumber(il_fila, "tpmv_soldes"))
ias_campo[6] = String(dw_1.GetItemNumber(il_fila, "tpmv_tipotr"))
ias_campo[7] = String(dw_1.GetItemNumber(il_fila, "tpmv_tipode"))
ias_campo[8] = dw_1.GetItemString(il_fila, "tpmv_glosas")
ias_campo[9] = String(dw_1.GetItemNumber(il_fila, "tpmv_estado"))
ias_campo[10] = String(dw_1.GetItemNumber(il_fila, "tpmv_emigde"))
ias_campo[11] = String(dw_1.GetItemNumber(il_fila, "tpmv_creaeq"))

IF dw_1.Object.tpmv_sentid[1]= 1 THEN
	dw_1.Object.tpmv_soldes.Protect	=	1
	dw_1.Object.tpmv_creaeq.Protect	=	0
ELSE
	dw_1.Object.tpmv_soldes.Protect	=	0
	dw_1.Object.tpmv_creaeq.Protect	=	1
END IF

If Not istr_mant.Agrega Then
	dw_1.Object.tpmv_codigo.Protect					=	1
	dw_1.Object.tpmv_codigo.Color					=	0
	dw_1.Object.tpmv_codigo.BackGround.Color	=	553648127
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "tpmv_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "tpmv_nombre", ias_campo[2])
dw_1.SetItem(il_fila, "tpmv_sentid", Integer(ias_campo[3]))
dw_1.SetItem(il_fila, "tpmv_tipodo", Integer(ias_campo[4]))
dw_1.SetItem(il_fila, "tpmv_soldes", Integer(ias_campo[5]))
dw_1.SetItem(il_fila, "tpmv_tipotr", Integer(ias_campo[6]))
dw_1.SetItem(il_fila, "tpmv_tipode", Integer(ias_campo[7]))
dw_1.SetItem(il_fila, "tpmv_glosas", ias_campo[8])
dw_1.SetItem(il_fila, "tpmv_estado", Integer(ias_campo[9]))
dw_1.SetItem(il_fila, "tpmv_emigde", Integer(ias_campo[10]))
dw_1.SetItem(il_fila, "tpmv_creaeq", Integer(ias_campo[11]))
end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "tpmv_codigo")) Then
	li_cont ++
	ls_mensaje		= ls_mensaje + "~nCódigo de Tipo Movimientos Equipos"
	ls_colu[li_cont]	= "tpmv_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "tpmv_nombre")) Or dw_1.GetItemString(il_fila, "tpmv_nombre") = "" Then
	li_cont ++
   ls_mensaje		= ls_mensaje + "~nDescripción de Tipo Movimiento Equipos"
	ls_colu[li_cont]	= "tpmv_nombre"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "tpmv_sentid")) Then
	li_cont ++
	ls_mensaje		= ls_mensaje + "~nSentido del Tipo Movimientos Equipos"
	ls_colu[li_cont]	= "tpmv_sentid"
End If

If dw_1.Object.tpmv_tipodo[il_fila] = 2 Then
	If IsNull(dw_1.GetItemNumber(il_fila, "tpmv_tipotr")) Then
		li_cont ++
		ls_mensaje		= ls_mensaje + "~nCódigo de Tipo Traslado"
		ls_colu[li_cont]	= "tpmv_tipotr"
	End If

	If IsNull(dw_1.GetItemNumber(il_fila, "tpmv_tipode")) Then
		li_cont ++
		ls_mensaje		= ls_mensaje + "~nCódigo de Tipo Despacho"
		ls_colu[li_cont]	= "tpmv_tipode"
	End If
End if

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('tpmv_codigo')
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_tipomovto
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_tipomovto
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_tipomovto
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_tipomovto
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_tipomovto
integer x = 2661
integer y = 348
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_tipomovto
integer x = 2661
integer y = 140
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_tipomovto
integer x = 2661
integer y = 556
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_tipomovto
integer width = 2478
integer height = 1540
string dataobject = "dw_mant_tipomovto"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)

ls_Columna	=	dwo.name

CHOOSE CASE ls_Columna
	CASE "tpmv_codigo"
		IF Duplicado(Data, 1) THEN
			This.SetItem(il_Fila, ls_Columna, Integer(ls_Nula))
			RETURN 1
		END IF
		 
	CASE "tpmv_sentid"
		IF Integer(Data) = 1 THEN
			This.Object.tpmv_soldes.Protect	=	1
			This.Object.tpmv_soldes[il_Fila]	=	0
			This.Object.tpmv_creaeq.Protect	=	0
			This.Object.tpmv_creaeq[il_Fila]	=	0
		ELSE
			This.Object.tpmv_soldes.Protect	=	0
			This.Object.tpmv_soldes[il_Fila]	=	0
			This.Object.tpmv_creaeq.Protect	=	1
			This.Object.tpmv_creaeq[il_Fila]	=	0
		END IF
		
	Case "tpmv_tipodo"
		If Data = '2' Then
			This.Object.tpmv_tipotr.Protect		= 0
			This.Object.tpmv_tipode.Protect	= 0
		Else
			This.SetItem(Row, 'tpmv_tipotr', Integer(ls_Nula))
			This.SetItem(Row, 'tpmv_tipode', Integer(ls_Nula))
			This.Object.tpmv_tipotr.Protect 	= 1
			This.Object.tpmv_tipode.Protect 	= 1
		End If
	
END CHOOSE
end event

