$PBExportHeader$w_mant_desasigna.srw
forward
global type w_mant_desasigna from w_mant_directo
end type
end forward

global type w_mant_desasigna from w_mant_directo
integer width = 3835
integer height = 2104
boolean clientedge = true
end type
global w_mant_desasigna w_mant_desasigna

type variables
uo_personacolacion	iuo_Personal

String			is_ru

end variables

on w_mant_desasigna.create
call super::create
end on

on w_mant_desasigna.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_Filas

ll_Filas	=	dw_1.Retrieve()

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")

	dw_1.SetRedraw(True)

	Return
Else
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
		
	If ll_Filas > 0 Then
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
	Else
		pb_insertar.SetFocus()
	End If
End If
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_desasigna
boolean visible = false
integer x = 37
integer y = 24
integer width = 3218
integer height = 296
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_desasigna
integer x = 3365
integer y = 512
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_desasigna
integer x = 3365
integer y = 0
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_desasigna
boolean visible = false
integer x = 3365
integer y = 1280
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_desasigna
boolean visible = false
integer x = 3328
integer y = 1312
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_desasigna
integer x = 3365
integer y = 1600
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_desasigna
boolean visible = false
integer x = 3401
integer y = 1280
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_desasigna
integer x = 3365
integer y = 768
end type

event pb_grabar::clicked;SetPointer(HourGlass!)

ib_borrar = True
w_main.SetMicroHelp("Validando la eliminación...")

Message.DoubleParm = 0

This.TriggerEvent ("ue_validaborrar")

If Message.DoubleParm = -1 Then Return

If dw_1.RowCount() > 0 Then dw_1.RowsMove(1,dw_1.RowCount(),Primary!,dw_1,1,Delete!)

ib_borrar = False
w_main.SetMicroHelp("Borrando Registro...")

If wf_actualiza_db() Then
	w_main.SetMicroHelp("Registro Borrado...")
	MessageBox('Atencion', 'SE desasignaron todos los finiquitdos.')
	This.TriggerEvent("ue_nuevo")
Else
	w_main.SetMicroHelp("Registro no Borrado...")
End If			

SetPointer(Arrow!)
end event

type dw_1 from w_mant_directo`dw_1 within w_mant_desasigna
integer x = 37
integer y = 32
integer width = 3218
integer height = 1856
boolean titlebar = true
string title = "Solicitudes de Colaciones"
string dataobject = "dw_mant_mues_personalcolacion"
end type

event dw_1::clicked;This.SelectRow(Row, Not This.IsSelected(row))
end event

