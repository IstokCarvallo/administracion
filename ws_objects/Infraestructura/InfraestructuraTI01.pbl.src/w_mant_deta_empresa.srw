$PBExportHeader$w_mant_deta_empresa.srw
forward
global type w_mant_deta_empresa from w_mant_detalle
end type
end forward

global type w_mant_deta_empresa from w_mant_detalle
integer width = 2199
integer height = 1328
string title = "EMPRESAS"
boolean controlmenu = true
end type
global w_mant_deta_empresa w_mant_deta_empresa

type variables
String	is_Rut
end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
public function boolean wf_duplicado (string as_campo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	String(dw_1.GetItemNumber(il_fila, "empr_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
				
End Choose

ll_fila = istr_mant.dw.Find("empr_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","Código de Proveedor ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

public function boolean wf_duplicado (string as_campo);Long     	ll_fila

ll_fila = istr_mant.dw.Find("empr_nrorut = '" + as_Campo + "'", 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","RUT de Proveedor ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_empresa.create
call super::create
end on

on w_mant_deta_empresa.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "empr_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "empr_razsoc")
ias_campo[3] = dw_1.GetItemString(il_fila, "empr_nrorut")
ias_campo[4] = dw_1.GetItemString(il_fila, "empr_direcc")

If Not istr_mant.Agrega Then
	dw_1.Object.empr_codigo.Protect				=	1
	dw_1.Object.empr_nrorut.Protect				=	1
	dw_1.Object.empr_codigo.Color					=	0
	dw_1.Object.empr_nrorut.Color					=	0
	dw_1.Object.empr_codigo.BackGround.Color	=	553648127
	dw_1.Object.empr_nrorut.BackGround.Color	=	553648127
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "empr_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "empr_razsoc", ias_campo[2])
dw_1.SetItem(il_fila, "empr_nrorut", ias_campo[3])
dw_1.SetItem(il_fila, "empr_direcc", ias_campo[4])

end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "empr_codigo")) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de Empresa"
	ls_colu[li_cont]	= "empr_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "empr_razsoc")) Or dw_1.GetItemString(il_fila, "empr_razsoc") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~Razon Social"
	ls_colu[li_cont]	= "empr_razsoc"
End If

If IsNull(dw_1.GetItemString(il_fila, "empr_nrorut")) Or dw_1.GetItemString(il_fila, "empr_nrorut") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nRUT del Empresa"
	ls_colu[li_cont]	= "empr_nrorut"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('empr_codigo')
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_empresa
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_empresa
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_empresa
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_empresa
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_empresa
integer x = 1865
integer y = 312
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_empresa
integer x = 1865
integer y = 104
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_empresa
integer x = 1865
integer y = 520
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_empresa
integer width = 1568
integer height = 1004
string dataobject = "dw_mant_empresa"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "empr_codigo"
		If Duplicado(data, 1) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			Return 1
		End If
		
	CASE "empr_nrorut"
		is_rut		=	F_verrut(data, True)
		
		If is_rut = ""  Then
			This.SetItem(row, ls_Columna, ias_campo[3])
			Return 1
		Else
			If wf_Duplicado(is_rut) Then
				This.SetItem(il_fila, ls_columna, ias_campo[3])
				Return 1
			End If
		End If
		
End Choose
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;If is_rut <> "" Then
	If dwo.Name = "empr_nrorut" Then
		If is_rut <> "" Then
			This.SetItem(il_fila, "empr_nrorut", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		End If
	Else
		This.SetItem(il_fila, "empr_nrorut", is_rut)
	End If
End If
end event

