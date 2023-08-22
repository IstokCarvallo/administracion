$PBExportHeader$w_mant_mues_empresasconexion.srw
forward
global type w_mant_mues_empresasconexion from w_mant_tabla
end type
end forward

global type w_mant_mues_empresasconexion from w_mant_tabla
integer width = 3918
integer height = 1956
string title = "CONEXIONES EMPRESAS"
event ue_validapassword ( )
end type
global w_mant_mues_empresasconexion w_mant_mues_empresasconexion

type variables
w_mant_deta_empresasconexion iw_mantencion
end variables

on w_mant_mues_empresasconexion.create
call super::create
end on

on w_mant_mues_empresasconexion.destroy
call super::destroy
end on

event open;call super::open;Integer	li_contad

buscar	= "Código:Nempr_codigo,Nombre:Sempr_nombre,Abreviación:Sempr_abrevi"
ordenar	= "Código:empr_codigo,Nombre:empr_nombre,Abreviación:empr_abrevi"
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

event ue_imprimir;Long	fila
str_info lstr_info

lstr_info.titulo	= "EMPRESAS DE CONSOLIDACION COLABORADORES"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_empresasconexion"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve()

IF fila	= -1 THEN
	MessageBox("Error en Base de Datos", "Se ha Producido un error en Basede Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ELSEIF fila	= 0 THEN
	MessageBox("No Existe Información", "No Existe Información para este Informe.", StopSign!, OK!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.Titulo)
END IF
end event

event ue_nuevo;call super::ue_nuevo;istr_mant.borra	= False
istr_mant.agrega	= True

OpenWithParm(iw_mantencion, istr_mant)

IF dw_1.RowCount() > 0 and pb_eliminar.Enabled	= FALSE THEN
	pb_eliminar.Enabled	= TRUE
	pb_grabar.Enabled		= TRUE
END IF

dw_1.SetRow(il_fila)
dw_1.SelectRow(il_fila, True)

end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve(0)
	
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

event ue_modifica;call super::ue_modifica;IF dw_1.RowCount() > 0 THEN
	istr_mant.agrega	= False
	istr_mant.borra	= False

	OpenWithParm(iw_mantencion, istr_mant)
END IF
end event

type dw_1 from w_mant_tabla`dw_1 within w_mant_mues_empresasconexion
integer y = 68
integer width = 3497
integer height = 1616
string dataobject = "dw_mues_empresasconexion"
boolean hscrollbar = true
end type

type st_encabe from w_mant_tabla`st_encabe within w_mant_mues_empresasconexion
boolean visible = false
integer x = 581
integer y = 348
integer width = 571
integer height = 236
end type

type pb_lectura from w_mant_tabla`pb_lectura within w_mant_mues_empresasconexion
integer x = 3209
integer y = 152
end type

type pb_nuevo from w_mant_tabla`pb_nuevo within w_mant_mues_empresasconexion
boolean visible = false
integer x = 3552
integer y = 340
end type

type pb_insertar from w_mant_tabla`pb_insertar within w_mant_mues_empresasconexion
integer x = 3209
integer y = 456
end type

type pb_eliminar from w_mant_tabla`pb_eliminar within w_mant_mues_empresasconexion
integer x = 3209
integer y = 636
end type

type pb_grabar from w_mant_tabla`pb_grabar within w_mant_mues_empresasconexion
integer x = 3209
integer y = 816
end type

type pb_imprimir from w_mant_tabla`pb_imprimir within w_mant_mues_empresasconexion
integer x = 3209
integer y = 996
end type

type pb_salir from w_mant_tabla`pb_salir within w_mant_mues_empresasconexion
integer x = 3209
integer y = 1332
end type

