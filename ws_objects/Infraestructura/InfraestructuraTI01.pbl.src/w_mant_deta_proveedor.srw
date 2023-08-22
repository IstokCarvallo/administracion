$PBExportHeader$w_mant_deta_proveedor.srw
forward
global type w_mant_deta_proveedor from w_mant_detalle
end type
end forward

global type w_mant_deta_proveedor from w_mant_detalle
integer width = 2199
integer height = 1464
string title = "Proveedores"
boolean controlmenu = true
end type
global w_mant_deta_proveedor w_mant_deta_proveedor

type variables
String	is_Rut

uo_Pais			iuo_Pais
uo_Region		iuo_Region
uo_Comunas	iuo_Comuna

DataWindowChild	idwc_Pais, idwc_Region, idwc_Comuna
end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
public function boolean wf_duplicado (string as_campo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	String(dw_1.GetItemNumber(il_fila, "prov_codigo"))

Choose Case Tipo
	Case 1
		ls_Campo = campo
				
End Choose

ll_fila = istr_mant.dw.Find("prov_codigo = " + ls_Campo, 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","Código de Proveedor ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

public function boolean wf_duplicado (string as_campo);Long     	ll_fila

ll_fila = istr_mant.dw.Find("prov_nrorut = '" + as_Campo + "'", 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","RUT de Proveedor ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_proveedor.create
call super::create
end on

on w_mant_deta_proveedor.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = String(dw_1.GetItemNumber(il_fila, "prov_codigo"))
ias_campo[2] = dw_1.GetItemString(il_fila, "prov_nombre")
ias_campo[3] = dw_1.GetItemString(il_fila, "prov_nrorut")
ias_campo[4] = dw_1.GetItemString(il_fila, "prov_telefo")
ias_campo[5] = dw_1.GetItemString(il_fila, "prov_contac")
ias_campo[6] = dw_1.GetItemString(il_fila, "prov_direcc")
ias_campo[7] = dw_1.GetItemString(il_fila, "prov_correo")

iuo_Pais.Codigo		=	dw_1.GetItemNumber(il_fila, "pais_codigo")
iuo_Region.Codigo		= 	dw_1.GetItemNumber(il_fila, "regi_codigo")
iuo_Comuna.Codigo	=	dw_1.GetItemNumber(il_fila, "comu_codigo")

If Not istr_mant.Agrega Then
	dw_1.Object.prov_codigo.Protect				=	1
	dw_1.Object.prov_nrorut.Protect				=	1
	dw_1.Object.prov_codigo.Color					=	0
	dw_1.Object.prov_nrorut.Color					=	0
	dw_1.Object.prov_codigo.BackGround.Color	=	553648127
	dw_1.Object.prov_nrorut.BackGround.Color	=	553648127
End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "prov_codigo", Integer(ias_campo[1]))
dw_1.SetItem(il_fila, "prov_nombre", ias_campo[2])
dw_1.SetItem(il_fila, "prov_nrorut", ias_campo[3])
dw_1.SetItem(il_fila, "prov_telefo", ias_campo[4])
dw_1.SetItem(il_fila, "prov_contac", ias_campo[5])
dw_1.SetItem(il_fila, "prov_direcc", ias_campo[6])
dw_1.SetItem(il_fila, "prov_correo", ias_campo[7])

end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemNumber(il_fila, "prov_codigo")) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de Proveedor"
	ls_colu[li_cont]	= "prov_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "prov_nombre")) Or dw_1.GetItemString(il_fila, "prov_nombre") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nDescripción de Proveedor"
	ls_colu[li_cont]	= "prov_nombre"
End If

If IsNull(dw_1.GetItemString(il_fila, "prov_nrorut")) Or dw_1.GetItemString(il_fila, "prov_nrorut") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nRUT del Proveedor"
	ls_colu[li_cont]	= "prov_nrorut"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('prov_codigo')
end event

event open;call super::open;iuo_Pais		=	Create uo_Pais
iuo_Region	=	Create uo_Region	
iuo_Comuna	=	Create uo_Comunas

dw_1.GetChild("pais_codigo", idwc_Pais)
idwc_Pais.SetTransObject(Sqlca)
If idwc_Pais.Retrieve() = 0 Then idwc_Pais.InsertRow(0)

dw_1.GetChild("regi_codigo", idwc_Region)
idwc_Region.SetTransObject(Sqlca)
If idwc_Region.Retrieve(-1) = 0 Then idwc_Region.InsertRow(0)

dw_1.GetChild("comu_codigo", idwc_Comuna)
idwc_Comuna.SetTransObject(Sqlca)
If idwc_Comuna.Retrieve(-1, -1) = 0 Then idwc_Comuna.InsertRow(0)
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_proveedor
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_proveedor
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_proveedor
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_proveedor
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_proveedor
integer x = 1787
integer y = 312
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_proveedor
integer x = 1787
integer y = 104
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_proveedor
integer x = 1787
integer y = 520
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_proveedor
integer width = 1559
integer height = 1240
string dataobject = "dw_mant_proveedor"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "prov_codigo"
		If Duplicado(data, 1) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			Return 1
		End If
		
	CASE "prov_nrorut"
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
		
	Case "pais_codigo"
		If Not iuo_Pais.Existe(Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[4]))
			Return 1
		Else
			dw_1.GetChild("regi_codigo", idwc_Region)
			idwc_Region.SetTransObject(Sqlca)
			If idwc_Region.Retrieve(iuo_Pais.Codigo) = 0 Then idwc_Region.InsertRow(0)
		End If
		
	Case "regi_codigo"
		If Not iuo_Region.Existe(iuo_Pais.Codigo, Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[4]))
			Return 1
		Else
			dw_1.GetChild("comu_codigo", idwc_Comuna)
			idwc_Comuna.SetTransObject(Sqlca)
			If idwc_Comuna.Retrieve(iuo_Region.Pais, iuo_Region.Codigo) = 0 Then idwc_Comuna.InsertRow(0)
		End If
		
	Case "comu_codigo"
		If Not iuo_Comuna.Existe(iuo_Pais.Codigo, iuo_Region.Codigo, Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[4]))
			Return 1
		End If

		
End Choose
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;If is_rut <> "" Then
	If dwo.Name = "prov_nrorut" Then
		If is_rut <> "" Then
			This.SetItem(il_fila, "prov_nrorut", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		End If
	Else
		This.SetItem(il_fila, "prov_nrorut", is_rut)
	End If
End If
end event

