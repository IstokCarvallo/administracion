$PBExportHeader$w_mant_deta_unidadmedida.srw
forward
global type w_mant_deta_unidadmedida from w_mant_detalle
end type
end forward

global type w_mant_deta_unidadmedida from w_mant_detalle
integer width = 2199
integer height = 1036
string title = "Unidad de Medida"
boolean controlmenu = true
end type
global w_mant_deta_unidadmedida w_mant_deta_unidadmedida

type variables

end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo = String(dw_1.GetItemNumber(il_fila, "unme_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
		
End Choose

ll_fila = istr_mant.dw.Find("unme_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

IF ll_fila > 0 and ll_fila <> il_FilaAnc THEN
	MessageBox("Error","Código de Unidad de Medida ya fue Ingresado Anteriormente",Information!, OK!)
	RETURN true
ELSE
	RETURN False
END IF


end function

on w_mant_deta_unidadmedida.create
call super::create
end on

on w_mant_deta_unidadmedida.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "unme_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "unme_nombre")
ias_campo[3] = dw_1.GetItemString(il_fila, "unme_simbol")

If Not istr_mant.Agrega Then
	dw_1.Object.unme_codigo.Protect				=	1
	dw_1.Object.unme_codigo.Color					=	0
	dw_1.Object.unme_codigo.BackGround.Color	=	553648127
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "unme_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "unme_nombre", ias_campo[2])
dw_1.SetItem(il_fila, "unme_simbol", ias_campo[3])
end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "unme_codigo")) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de Unidad Medida"
	ls_colu[li_cont]	= "unme_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "unme_nombre")) Or dw_1.GetItemString(il_fila, "unme_nombre") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nDescripción de Unidad Medida"
	ls_colu[li_cont]	= "unme_nombre"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('unme_codigo')
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_unidadmedida
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_unidadmedida
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_unidadmedida
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_unidadmedida
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_unidadmedida
integer x = 1865
integer y = 312
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_unidadmedida
integer x = 1865
integer y = 104
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_unidadmedida
integer x = 1865
integer y = 520
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_unidadmedida
integer width = 1573
integer height = 720
string dataobject = "dw_mant_unidadmedida"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

CHOOSE CASE ls_columna
		
	CASE "unme_codigo"
		IF Duplicado(data, 1) THEN
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			RETURN 1
		END IF
		
END CHOOSE
end event

