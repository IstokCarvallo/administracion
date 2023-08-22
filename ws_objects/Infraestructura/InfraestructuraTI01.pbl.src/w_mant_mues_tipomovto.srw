$PBExportHeader$w_mant_mues_tipomovto.srw
forward
global type w_mant_mues_tipomovto from w_mant_tabla
end type
end forward

global type w_mant_mues_tipomovto from w_mant_tabla
integer width = 3959
integer height = 1876
string title = "MAESTRO CARGOS"
string icon = "AppIcon!"
end type
global w_mant_mues_tipomovto w_mant_mues_tipomovto

type variables
w_mant_deta_tipomovto iw_mantencion
end variables

forward prototypes
public subroutine wf_replicacion ()
end prototypes

public subroutine wf_replicacion ();//
end subroutine

on w_mant_mues_tipomovto.create
call super::create
end on

on w_mant_mues_tipomovto.destroy
call super::destroy
end on

event open;call super::open;buscar	= "Codigo:Ncarg_codigo, Descripcion:Ncarg_nombre"
ordenar	= "Codigo:carg_codigo, Descripción:carg_nombre"

end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve(-1)
	
	IF ll_fila	= -1 THEN
		respuesta	= MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
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

lstr_info.titulo	= "MAESTRO TIPO MOVIMIENTO EQUIPOS"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_tipomovto"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve(-1)

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

type dw_1 from w_mant_tabla`dw_1 within w_mant_mues_tipomovto
integer y = 64
integer width = 3255
integer height = 1572
string dataobject = "dw_mues_tipomovto"
end type

type st_encabe from w_mant_tabla`st_encabe within w_mant_mues_tipomovto
boolean visible = false
integer x = 0
integer y = 32
integer width = 2226
integer height = 184
end type

type pb_lectura from w_mant_tabla`pb_lectura within w_mant_mues_tipomovto
integer x = 3520
integer y = 52
end type

type pb_nuevo from w_mant_tabla`pb_nuevo within w_mant_mues_tipomovto
boolean visible = false
integer x = 3529
integer y = 520
integer height = 136
end type

type pb_insertar from w_mant_tabla`pb_insertar within w_mant_mues_tipomovto
integer x = 3529
integer y = 460
end type

type pb_eliminar from w_mant_tabla`pb_eliminar within w_mant_mues_tipomovto
integer x = 3534
integer y = 640
end type

type pb_grabar from w_mant_tabla`pb_grabar within w_mant_mues_tipomovto
integer x = 3538
integer y = 784
end type

type pb_imprimir from w_mant_tabla`pb_imprimir within w_mant_mues_tipomovto
integer x = 3552
integer y = 1012
end type

type pb_salir from w_mant_tabla`pb_salir within w_mant_mues_tipomovto
integer x = 3575
integer y = 1452
end type

