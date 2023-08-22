$PBExportHeader$w_mant_deta_ordentrabajoequipos.srw
forward
global type w_mant_deta_ordentrabajoequipos from w_mant_detalle
end type
end forward

global type w_mant_deta_ordentrabajoequipos from w_mant_detalle
integer width = 2706
integer height = 980
string title = "EQUIPOS A SERVICIO"
boolean controlmenu = true
end type
global w_mant_deta_ordentrabajoequipos w_mant_deta_ordentrabajoequipos

type variables
uo_Equipo	iuo_Equipo
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
	MessageBox("Error","Código de Equipo ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_ordentrabajoequipos.create
call super::create
end on

on w_mant_deta_ordentrabajoequipos.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "equi_codigo"))
ias_campo[2] = String(dw_1.GetItemNumber(il_fila, "oreq_estado"))

If Not istr_mant.Agrega Then
	dw_1.Object.equi_codigo.Protect				=	1
	dw_1.Object.equi_codigo.BackGround.Color	=	553648127
	dw_1.Object.equi_codigo.Color					=	0 //RGB(255,255,255)
End If

dw_1.Object.ortr_codigo[il_fila] = Long(istr_Mant.Argumento[1])

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "equi_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "oreq_estado", Integer(ias_campo[2]))

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

dw_1.Object.ortr_codigo[il_fila] = Long(istr_Mant.Argumento[1])

end event

event open;call super::open;iuo_Equipo	=	Create uo_Equipo
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_ordentrabajoequipos
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_ordentrabajoequipos
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_ordentrabajoequipos
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_ordentrabajoequipos
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_ordentrabajoequipos
integer x = 2391
integer y = 336
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_ordentrabajoequipos
integer x = 2391
integer y = 128
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_ordentrabajoequipos
integer x = 2391
integer y = 544
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_ordentrabajoequipos
integer width = 2135
integer height = 708
string dataobject = "dw_mant_servicioequipo"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "equi_codigo"
		If Duplicado(data, 1) Or Not iuo_Equipo.of_Existe(Dec(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			Return 1
		Else
			This.SetItem(Row, 'pers_codigo', iuo_Equipo.Rut)
		End If
		
End Choose
end event

