$PBExportHeader$w_mant_mues_sucursal.srw
forward
global type w_mant_mues_sucursal from w_mant_tabla
end type
end forward

global type w_mant_mues_sucursal from w_mant_tabla
integer width = 3333
integer height = 1876
string title = "MAESTRO SUCURSALES"
string icon = "AppIcon!"
end type
global w_mant_mues_sucursal w_mant_mues_sucursal

type variables
w_mant_deta_sucursal iw_mantencion
end variables

forward prototypes
public subroutine wf_replicacion ()
end prototypes

public subroutine wf_replicacion ();//
end subroutine

on w_mant_mues_sucursal.create
call super::create
end on

on w_mant_mues_sucursal.destroy
call super::destroy
end on

event open;call super::open;buscar	= "Codigo:Nsucu_codigo, Descripcion:Ssucu_nombre"
ordenar	= "Codigo:sucu_codigo, Descripción:sucu_nombre"

end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve()
	
	IF ll_fila	= -1 THEN
		respuesta	= MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", &
											Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SelectRow(1, True)
		dw_1.SetFocus()
		pb_imprimir.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled		= True
	ELSE
		pb_insertar.SetFocus()
	END IF
LOOP WHILE respuesta	 = 1

IF respuesta	= 2 THEN Close(This)

end event

event ue_nuevo;call super::ue_nuevo;istr_mant.Borra		= False
istr_mant.Agrega	= True

OpenWithParm(iw_mantencion, istr_mant)

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled	= True
End If

dw_1.SetRow(il_fila)
dw_1.SelectRow(il_fila, True)

end event

event ue_imprimir;Long	fila
str_info lstr_info

lstr_info.titulo	= "MAESTRO SUCURSALES"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_sucursal"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve()

IF fila	= -1 THEN
	MessageBox("Error en Base de Datos", "Se ha Producido un error en Basede Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ELSEIF fila	= 0 THEN
	MessageBox("No Existe Información", "No Existe Información para este Informa.", StopSign!, OK!)
ElSE
	F_Membrete(vinf.dw_1)
	If gs_Ambiente = 'Windows' Then
		vinf.dw_1.Modify('DataWindow.Print.Preview	= Yes')
		vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom	= 75')
		
		vinf.Visible	= True
		vinf.Enabled	= True
	Else
		F_ImprimeInformePdf(vinf.dw_1, lstr_info.titulo)
	End If
END IF

end event

event ue_borrar;call super::ue_borrar;IF dw_1.rowcount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar	= TRUE
w_main.SetMicroHelp("Validando la Eliminación...")

Message.DoubleParm	= 0

This.TriggerEvent("ue_validaborrar")

IF Message.DoubleParm	= -1 THEN RETURN

istr_mant.borra	= True
istr_mant.agrega	= False

OpenWithParm(iw_mantencion, istr_mant)

istr_mant	= Message.PowerObjectParm

IF istr_mant.respuesta	= 1 THEN
	IF dw_1.DeleteRow(0)	= 1 THEN
		ib_borrar	= False
		w_main.SetMicroHelp("Borrando Registro...")
		SetPointer(Arrow!)
	ELSE
		ib_borrar	= False
		MessageBox(This.Title, "No se puede borrar actual Registro.")
	END IF
	
	IF dw_1.RowCount()	= 0 THEN
		pb_eliminar.Enabled	= False
	ELSE
		il_fila	= dw_1.GetRow()
		dw_1.SelectRow(il_fila, True)
	END IF
END IF

istr_mant.borra	= False

end event

event ue_modifica;call super::ue_modifica;IF dw_1.RowCount() > 0 THEN
	istr_mant.agrega	= False
	istr_mant.borra	= False

	OpenWithParm(iw_mantencion, istr_mant)
END IF
end event

type dw_1 from w_mant_tabla`dw_1 within w_mant_mues_sucursal
integer y = 64
integer width = 2711
integer height = 1352
string dataobject = "dw_mues_sucursal"
end type

type st_encabe from w_mant_tabla`st_encabe within w_mant_mues_sucursal
boolean visible = false
integer x = 0
integer y = 32
integer width = 2226
integer height = 184
end type

type pb_lectura from w_mant_tabla`pb_lectura within w_mant_mues_sucursal
integer x = 2903
integer y = 44
end type

type pb_nuevo from w_mant_tabla`pb_nuevo within w_mant_mues_sucursal
boolean visible = false
integer x = 2912
integer y = 512
integer height = 192
end type

type pb_insertar from w_mant_tabla`pb_insertar within w_mant_mues_sucursal
integer x = 2912
integer y = 452
end type

type pb_eliminar from w_mant_tabla`pb_eliminar within w_mant_mues_sucursal
integer x = 2917
integer y = 632
end type

type pb_grabar from w_mant_tabla`pb_grabar within w_mant_mues_sucursal
integer x = 2921
integer y = 776
end type

type pb_imprimir from w_mant_tabla`pb_imprimir within w_mant_mues_sucursal
integer x = 2935
integer y = 1004
end type

type pb_salir from w_mant_tabla`pb_salir within w_mant_mues_sucursal
integer x = 2958
integer y = 1444
end type

