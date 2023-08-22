$PBExportHeader$w_mant_deta_tipoequipos.srw
forward
global type w_mant_deta_tipoequipos from w_mant_detalle
end type
end forward

global type w_mant_deta_tipoequipos from w_mant_detalle
integer width = 2693
integer height = 1328
string title = "TIPO EQUIPOS"
boolean controlmenu = true
end type
global w_mant_deta_tipoequipos w_mant_deta_tipoequipos

type variables
String	is_Rut
end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	String(dw_1.GetItemNumber(il_fila, "tieq_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
				
End Choose

ll_fila = istr_mant.dw.Find("tieq_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","Código de Tipo Equipos  ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_tipoequipos.create
call super::create
end on

on w_mant_deta_tipoequipos.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "tieq_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "tieq_nombre")
ias_campo[3] = dw_1.GetItemString(il_fila, "tieq_abrevi")
ias_campo[4] = String(dw_1.GetItemNumber(il_fila, "tieq_correl"))
ias_campo[5] = String(dw_1.GetItemNumber(il_fila, "tieq_coract"))

If Not istr_mant.Agrega Then
	dw_1.Object.tieq_codigo.Protect				=	1
	dw_1.Object.tieq_codigo.Color				=	0
	dw_1.Object.tieq_codigo.BackGround.Color=	553648127
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "tieq_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "tieq_nombre", ias_campo[2])
dw_1.SetItem(il_fila, "tieq_abrevi", ias_campo[3])
dw_1.SetItem(il_fila, "tieq_correl", Long(ias_campo[4]))
dw_1.SetItem(il_fila, "tieq_coract", Long(ias_campo[5]))

end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "tieq_codigo")) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de Tipo Equipo"
	ls_colu[li_cont]	= "tieq_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "tieq_nombre")) Or dw_1.GetItemString(il_fila, "tieq_nombre") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nNombre Tipo de Equipos"
	ls_colu[li_cont]	= "tieq_nombre"
End If

If IsNull(dw_1.GetItemString(il_fila, "tieq_abrevi")) Or dw_1.GetItemString(il_fila, "tieq_abrevi") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nAbreviacion de Tipo de Equipos"
	ls_colu[li_cont]	= "tieq_abrevi"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "tieq_correl")) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCorrelativo Inicial."
	ls_colu[li_cont]	= "tieq_correl"
End If


If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('tieq_codigo')
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_tipoequipos
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_tipoequipos
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_tipoequipos
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_tipoequipos
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_tipoequipos
integer x = 2391
integer y = 336
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_tipoequipos
integer x = 2391
integer y = 128
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_tipoequipos
integer x = 2391
integer y = 544
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_tipoequipos
integer width = 2117
integer height = 1004
string dataobject = "dw_mant_tipoequipos"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "tieq_codigo"
		If Duplicado(data, 1) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			Return 1
		End If
		
	Case 'tieq_correl'
		This.SetItem(il_Fila, 'tieq_coract', Integer(Data))
		
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

