$PBExportHeader$w_mant_deta_modelo.srw
forward
global type w_mant_deta_modelo from w_mant_detalle
end type
end forward

global type w_mant_deta_modelo from w_mant_detalle
integer width = 2199
integer height = 1284
string title = "Unidad de Medida"
boolean controlmenu = true
end type
global w_mant_deta_modelo w_mant_deta_modelo

type variables

end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo = String(dw_1.GetItemNumber(il_fila, "mode_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
		
End Choose

ll_fila = istr_mant.dw.Find("mode_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

IF ll_fila > 0 and ll_fila <> il_FilaAnc THEN
	MessageBox("Error","Código de Cargo ya fue Ingresado Anteriormente",Information!, OK!)
	RETURN true
ELSE
	RETURN False
END IF


end function

on w_mant_deta_modelo.create
call super::create
end on

on w_mant_deta_modelo.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "marc_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "tieq_codigo")
ias_campo[3] = dw_1.GetItemString(il_fila, "mode_codigo")
ias_campo[4] = dw_1.GetItemString(il_fila, "mode_nombre")

If Not istr_mant.Agrega Then
	dw_1.Object.mode_codigo.Protect					=	1
	dw_1.Object.mode_codigo.Color					=	0
	dw_1.Object.mode_codigo.BackGround.Color	=	553648127
Else
	dw_1.Object.marc_codigo[il_Fila]	=	Integer(istr_Mant.Argumento[1])
	dw_1.Object.tieq_codigo[il_Fila]	=	Integer(istr_Mant.Argumento[2])
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "marc_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "tieq_codigo", Integer(ias_campo[2]))
dw_1.SetItem(il_fila, "mode_codigo", Integer(ias_campo[3]))
dw_1.SetItem(il_fila, "mode_nombre", ias_campo[4])

end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "mode_codigo")) Then
	li_cont ++
	ls_mensaje		= ls_mensaje + "~nCódigo de Modelos"
	ls_colu[li_cont]	= "mode_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "mode_nombre")) Or dw_1.GetItemString(il_fila, "mode_nombre") = "" Then
	li_cont ++
   ls_mensaje		= ls_mensaje + "~nDescripción de Modelos"
	ls_colu[li_cont]	= "mode_nombre"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.Object.marc_codigo[il_Fila]	=	Integer(istr_Mant.Argumento[1])
dw_1.Object.tieq_codigo[il_Fila]	=	Integer(istr_Mant.Argumento[2])

dw_1.SetColumn('mode_codigo')
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_modelo
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_modelo
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_modelo
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_modelo
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_modelo
integer x = 1865
integer y = 312
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_modelo
integer x = 1865
integer y = 104
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_modelo
integer x = 1865
integer y = 520
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_modelo
integer width = 1568
integer height = 1056
string dataobject = "dw_mant_modelo"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

CHOOSE CASE ls_columna
		
	CASE "mode_codigo"
		IF Duplicado(data, 1) THEN
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			RETURN 1
		END IF
		
END CHOOSE
end event

