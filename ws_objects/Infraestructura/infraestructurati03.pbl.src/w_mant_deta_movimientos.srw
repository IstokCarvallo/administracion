﻿$PBExportHeader$w_mant_deta_movimientos.srw
forward
global type w_mant_deta_movimientos from w_mant_detalle
end type
end forward

global type w_mant_deta_movimientos from w_mant_detalle
integer width = 2464
integer height = 1176
string title = "ASIGNACION COLABORADORES"
boolean controlmenu = true
end type
global w_mant_deta_movimientos w_mant_deta_movimientos

type variables
uo_Equipo			iuo_Equipos
uo_Marca			iuo_Marca
uo_Modelo			iuo_Modelo
uo_TipoEquipos	iuo_Tipo
end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	String(dw_1.GetItemNumber(il_fila, "equi_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
				
End Choose

ll_fila = istr_mant.dw.Find("equi_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","Código de Colaborador ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_movimientos.create
call super::create
end on

on w_mant_deta_movimientos.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "equi_codigo"))

If Not istr_mant.Agrega Then
	dw_1.Object.equi_codigo.Protect				=	1
	dw_1.Object.equi_codigo.BackGround.Color	=	553648127
	dw_1.Object.equi_codigo.Color					=	RGB(255,255,255)
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "equi_codigo", Long(ias_campo[1]))
end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "equi_codigo")) Or dw_1.GetItemNumber(il_fila, "equi_codigo") = 0 Then
	li_cont ++
	ls_mensaje		= ls_mensaje + "~nCódigo de Equipo"
	ls_colu[li_cont]	= "equi_codigo"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('equi_codigo')
end event

event open;call super::open;iuo_Equipos	=	Create uo_Equipo
iuo_Marca	=	Create uo_Marca
iuo_Modelo	=	Create uo_Modelo
iuo_Tipo		=	Create uo_TipoEquipos
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_movimientos
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_movimientos
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_movimientos
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_movimientos
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_movimientos
integer x = 2089
integer y = 352
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_movimientos
integer x = 2089
integer y = 144
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_movimientos
integer x = 2089
integer y = 560
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_movimientos
integer width = 1966
integer height = 912
string dataobject = "dw_mant_movimientodeta"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna, ls_Null
SetNull(ls_Null)

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "equi_codigo"
		If Not iuo_Equipos.of_ExisteParaDespacho(Long(Data), True, SQLCA) Or Duplicado(data, 1) Then
			This.SetItem(il_fila, ls_columna, ls_Null)
			dw_1.Object.equi_nroser[Row]		=	ls_Null
			dw_1.Object.equi_nroint[Row]		=	ls_Null
			dw_1.Object.equi_modelo[Row]	=	ls_Null
			dw_1.Object.mode_nombre[Row]	=	ls_Null
			dw_1.Object.marc_nombre[Row]	=	ls_Null
			dw_1.Object.tieq_nombre[Row]	=	ls_Null
			Return 1
		Else
			iuo_Marca.Existe(iuo_Equipos.Marca, False, SQLCA)
			iuo_Modelo.Existe(iuo_Equipos.Marca, iuo_Equipos.TipoEquipo, iuo_Equipos.CodigoModelo, False, SQLCA)
			iuo_Tipo.Existe(iuo_Equipos.TipoEquipo, False, SQLCA)
			
			dw_1.Object.equi_nroser[Row]		=	iuo_Equipos.Serie
			dw_1.Object.equi_nroint[Row]		=	iuo_Equipos.NroInterno
			dw_1.Object.equi_modelo[Row]	=	iuo_Equipos.Modelo
			dw_1.Object.mode_nombre[Row]	=	iuo_Modelo.Nombre
			dw_1.Object.marc_nombre[Row]	=	iuo_Marca.Nombre
			dw_1.Object.tieq_nombre[Row]	=	iuo_Tipo.Nombre
		End If
			
End Choose
end event

