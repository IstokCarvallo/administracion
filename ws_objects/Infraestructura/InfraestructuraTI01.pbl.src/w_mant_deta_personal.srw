$PBExportHeader$w_mant_deta_personal.srw
forward
global type w_mant_deta_personal from w_mant_detalle
end type
type cb_rrhh from commandbutton within w_mant_deta_personal
end type
type dw_2 from uo_dw within w_mant_deta_personal
end type
end forward

global type w_mant_deta_personal from w_mant_detalle
integer width = 2944
integer height = 1792
string title = "COLABORADOR"
boolean controlmenu = true
cb_rrhh cb_rrhh
dw_2 dw_2
end type
global w_mant_deta_personal w_mant_deta_personal

type variables
String	is_Rut

uo_Empresa	iuo_Empresa
uo_Sucursal	iuo_Sucursal
uo_Seccion	iuo_Seccion
uo_Cargo	iuo_Cargo

DataWindowChild	idwc_empresa, idwc_sucursal, idwc_seccion, idwc_cargo
end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	dw_1.GetItemString(il_fila, "pers_nrorut")

Choose Case Tipo
	Case 1
		ls_Campo = campo
				
End Choose

ll_fila = istr_mant.dw.Find("pers_nrorut = '" + ls_Campo + "'", 1, istr_mant.dw.RowCount())

If ll_fila > 0 and ll_fila <> il_FilaAnc Then
	MessageBox("Error","Código de Colaborador ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

on w_mant_deta_personal.create
int iCurrent
call super::create
this.cb_rrhh=create cb_rrhh
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rrhh
this.Control[iCurrent+2]=this.dw_2
end on

on w_mant_deta_personal.destroy
call super::destroy
destroy(this.cb_rrhh)
destroy(this.dw_2)
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1] = dw_1.GetItemString(il_fila, "pers_codigo")
ias_campo[2] = dw_1.GetItemString(il_fila, "pers_nrorut")
ias_campo[3] = dw_1.GetItemString(il_fila, "pers_nombre")
ias_campo[4] = dw_1.GetItemString(il_fila, "pers_apellido")
ias_campo[5] = dw_1.GetItemString(il_fila, "pers_correo")
ias_campo[6] = String(dw_1.GetItemNumber(il_fila, "pers_anexo"))
ias_campo[7] = String(dw_1.GetItemNumber(il_fila, "pers_tipper"))
ias_campo[8] = String(dw_1.GetItemNumber(il_fila, "empr_codigo"))
ias_campo[9] = String(dw_1.GetItemNumber(il_fila, "sucu_codigo"))
ias_campo[10] = String(dw_1.GetItemNumber(il_fila, "secc_codigo"))
ias_campo[11] = String(dw_1.GetItemNumber(il_fila, "carg_codigo"))

iuo_Empresa.Codigo	=	dw_1.GetItemNumber(il_fila, "empr_codigo")
iuo_Sucursal.Codigo	=	dw_1.GetItemNumber(il_fila, "sucu_codigo")	
iuo_Seccion.Codigo	=	dw_1.GetItemNumber(il_fila, "secc_codigo")
iuo_Cargo.Codigo		=	dw_1.GetItemNumber(il_fila, "carg_codigo")

If Not istr_mant.Agrega Then
	dw_1.Object.pers_nrorut.Protect				=	1
	dw_1.Object.pers_nrorut.Color					=	RGB(255,255,255)
	dw_1.Object.pers_nrorut.BackGround.Color	=	553648127
	
	dw_1.GetChild("secc_codigo", idwc_Seccion)
	idwc_Seccion.SetTransObject(Sqlca)
	If idwc_Seccion.Retrieve(dw_1.Object.empr_codigo[1]) = 0 Then idwc_Seccion.InsertRow(0)

End If

dw_1.SetFocus()
end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "pers_codigo", ias_campo[1])
dw_1.SetItem(il_fila, "pers_nrorut", ias_campo[2])
dw_1.SetItem(il_fila, "pers_nombre", ias_campo[3])
dw_1.SetItem(il_fila, "pers_apellido", ias_campo[4])
dw_1.SetItem(il_fila, "pers_correo", ias_campo[5])
dw_1.SetItem(il_fila, "pers_anexo", Integer(ias_campo[6]))
dw_1.SetItem(il_fila, "pers_tipper", Integer(ias_campo[7]))
dw_1.SetItem(il_fila, "empr_codigo", Integer(ias_campo[8]))
dw_1.SetItem(il_fila, "sucu_codigo", Integer(ias_campo[9]))
dw_1.SetItem(il_fila, "secc_codigo", Integer(ias_campo[10]))
dw_1.SetItem(il_fila, "carg_codigo", Integer(ias_campo[11]))

end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.GetItemString(il_fila, "pers_codigo")) Or dw_1.GetItemString(il_fila, "pers_codigo") = "" Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de Colaborador"
	ls_colu[li_cont]	= "sucu_codigo"
End If

If IsNull(dw_1.GetItemString(il_fila, "pers_nrorut")) Or dw_1.GetItemString(il_fila, "pers_nrorut") = "" Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nRUT de Colaborador"
	ls_colu[li_cont]	= "pers_nrorut"
End If

If IsNull(dw_1.GetItemString(il_fila, "pers_nombre")) Or dw_1.GetItemString(il_fila, "pers_nombre") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nNombre Colaborador"
	ls_colu[li_cont]	= "pers_nombre"
End If

If IsNull(dw_1.GetItemString(il_fila, "pers_apellido")) Or dw_1.GetItemString(il_fila, "pers_apellido") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nApellido Colaborador"
	ls_colu[li_cont]	= "pers_apellido"
End If

If IsNull(dw_1.GetItemString(il_fila, "pers_correo")) Or dw_1.GetItemString(il_fila, "pers_correo") = "" Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nCorreo Colaborador"
	ls_colu[li_cont]	= "pers_correo"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "carg_codigo")) Or dw_1.GetItemNumber(il_fila, "carg_codigo") = 0 Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nCargo Colaborador"
	ls_colu[li_cont]	= "carg_codigo"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "empr_codigo")) Or dw_1.GetItemNumber(il_fila, "empr_codigo") = 0 Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nEmpresa Colaborador"
	ls_colu[li_cont]	= "empr_codigo"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "secc_codigo")) Or dw_1.GetItemNumber(il_fila, "secc_codigo") = 0 Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nSeccion Colaborador"
	ls_colu[li_cont]	= "secc_codigo"
End If

If IsNull(dw_1.GetItemNumber(il_fila, "sucu_codigo")) Or dw_1.GetItemNumber(il_fila, "sucu_codigo") = 0 Then
	li_cont ++
   ls_mensaje			= ls_mensaje + "~nSucursal Colaborador"
	ls_colu[li_cont]	= "sucu_codigo"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn('pers_codigo')
end event

event open;call super::open;iuo_Empresa	=	Create uo_Empresa
iuo_Sucursal	=	Create uo_Sucursal
iuo_Seccion		=	Create uo_Seccion
iuo_Cargo		=	Create uo_Cargo

dw_1.GetChild("empr_codigo", idwc_Empresa)
idwc_Empresa.SetTransObject(Sqlca)
If idwc_Empresa.Retrieve() = 0 Then idwc_Empresa.InsertRow(0)

dw_1.GetChild("sucu_codigo", idwc_Sucursal)
idwc_Sucursal.SetTransObject(Sqlca)
If idwc_Sucursal.Retrieve() = 0 Then idwc_Sucursal.InsertRow(0)

dw_1.GetChild("secc_codigo", idwc_Seccion)
idwc_Seccion.SetTransObject(Sqlca)
If idwc_Seccion.Retrieve(-1) = 0 Then idwc_Seccion.InsertRow(0)

dw_1.GetChild("carg_codigo", idwc_cargo)
idwc_cargo.SetTransObject(Sqlca)
If idwc_cargo.Retrieve() = 0 Then idwc_cargo.InsertRow(0)

end event

event resize;call super::resize;cb_rrhh.x = pb_Salir.x
cb_rrhh.y = pb_Salir.y + 255
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_personal
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_personal
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_personal
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_personal
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_personal
integer x = 2391
integer y = 372
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_personal
integer x = 2391
integer y = 164
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_personal
integer x = 2391
integer y = 580
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_personal
integer width = 2117
integer height = 1488
string dataobject = "dw_mant_personal"
end type

event dw_1::itemchanged;call super::itemchanged;String  ls_columna, ls_Null

SetNull(ls_Null)

ls_columna = dwo.Name

Choose Case ls_columna		
	Case "pers_codigo"
		is_Rut = F_VerRut(Data, True)
		
		If Duplicado(is_Rut, 1) Then
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			Return 1
		End If
		
	Case "pers_nrorut"
		is_Rut = F_VerRut(Data, True)
		If is_Rut = "" Then
			This.SetItem(il_fila, ls_columna, ias_campo[2])
			Return 1
		ElseIf Duplicado(is_Rut, 1) Then
			This.SetItem(il_fila, ls_columna, ias_campo[2])
			Return 1
		Else
			This.SetItem(il_Fila, "pers_codigo", is_Rut)
		End If
		
	Case "empr_codigo"
		If Not iuo_Empresa.Existe(Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ls_Null))
			Return 1
		Else
			dw_1.GetChild("secc_codigo", idwc_Seccion)
			idwc_Seccion.SetTransObject(Sqlca)
			If idwc_Seccion.Retrieve(iuo_Empresa.Codigo) = 0 Then idwc_Seccion.InsertRow(0)
		End If
		
	Case "secc_codigo"
		If Not iuo_Seccion.Existe(iuo_Empresa.Codigo, Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ls_Null))
			Return 1
		End If
		
	Case "sucu_codigo"
		If Not iuo_Sucursal.Existe(Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ls_Null))
			Return 1
		End If
		
	Case "carg_codigo"
		If Not iuo_Cargo.Existe(Integer(Data), True, Sqlca) Then
			This.SetItem(il_fila, ls_columna, Integer(ls_Null))
			Return 1
		End If
		
End Choose
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;If is_rut <> "" Then
	If dwo.Name = "pers_nrorut" Then
		If is_rut <> "" Then
			This.SetItem(il_fila, "pers_nrorut", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		End If
	Else
		This.SetItem(il_fila, "pers_nrorut", is_rut)
	End If
End If
end event

type cb_rrhh from commandbutton within w_mant_deta_personal
integer x = 2391
integer y = 956
integer width = 302
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "RRHH"
end type

event clicked;Transaction lt_Tran
str_Mant		lstr_Mant
lt_Tran	=	Create Transaction


If IsNull(dw_1.Object.pers_codigo[1]) Or dw_1.Object.pers_codigo[1] = '' Then 
	MessageBox('Atencion', 'Debe ingresar RUT de Colaborador antes.', StopSign!, Ok!)
	Return
End If

If IsNull(dw_1.Object.empr_codigo[1]) Or dw_1.Object.empr_codigo[1] = 0 Then 
	MessageBox('Atencion', 'Debe ingresar codigo de empresa antes.', StopSign!, Ok!)
	Return
End If

If Not iuo_Empresa.of_ExisteConexion(iuo_Empresa.Codigo, True, Sqlca) Then
	Return
Else
	If Not iuo_Empresa.of_Conecta(lt_Tran) Then
		MessageBox('Atencion', 'No se pudo conectar a Base de RRHH.', StopSign!, Ok!)
		Return
	Else
		dw_2.SetTransObject(lt_Tran)
		If dw_2.Retrieve(dw_1.Object.pers_codigo[1]) = 0 Then
			MessageBox('Atencion', 'No se pudo encontro RUT en Base de RRHH.', StopSign!, Ok!)
			Return
		Else
			lstr_Mant.dw = dw_2
			OpenWithParm(w_mant_deta_remupersonal, lstr_Mant)
		End if
	End If
End If

iuo_Empresa.of_Desconecta(lt_Tran)
Destroy lt_Tran


	
end event

type dw_2 from uo_dw within w_mant_deta_personal
boolean visible = false
integer x = 2377
integer y = 1212
integer width = 256
integer height = 172
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_mues_remupersonal"
end type

