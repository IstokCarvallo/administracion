$PBExportHeader$w_mant_mues_modelo.srw
forward
global type w_mant_mues_modelo from w_mant_tabla
end type
type st_1 from statictext within w_mant_mues_modelo
end type
type st_2 from statictext within w_mant_mues_modelo
end type
type uo_selmarca from uo_seleccion_marca within w_mant_mues_modelo
end type
type uo_seltipoequipo from uo_seleccion_tipoequipos within w_mant_mues_modelo
end type
end forward

global type w_mant_mues_modelo from w_mant_tabla
integer width = 2862
integer height = 1876
string title = "MAESTRO MODELOS"
string icon = "AppIcon!"
st_1 st_1
st_2 st_2
uo_selmarca uo_selmarca
uo_seltipoequipo uo_seltipoequipo
end type
global w_mant_mues_modelo w_mant_mues_modelo

type variables
w_mant_deta_modelo iw_mantencion
end variables

forward prototypes
public subroutine wf_replicacion ()
end prototypes

public subroutine wf_replicacion ();//
end subroutine

on w_mant_mues_modelo.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.uo_selmarca=create uo_selmarca
this.uo_seltipoequipo=create uo_seltipoequipo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.uo_selmarca
this.Control[iCurrent+4]=this.uo_seltipoequipo
end on

on w_mant_mues_modelo.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.uo_selmarca)
destroy(this.uo_seltipoequipo)
end on

event open;call super::open;Boolean lb_Cerrar = False

If IsNull(uo_SelMarca.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelTipoEquipo.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	uo_SelMarca.Seleccion(False, False)
	uo_SelTipoEquipo.Seleccion(False, False)

	buscar	= "Codigo:Ncarg_codigo, Descripcion:Ncarg_nombre"
	ordenar	= "Codigo:carg_codigo, Descripción:carg_nombre"
End If
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve(uo_SelMarca.Codigo, uo_SelTipoEquipo.Codigo)
	
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

istr_Mant.Argumento[1]	=	String(uo_SelMarca.Codigo)
istr_Mant.Argumento[2]	=	String(uo_SelTipoEquipo.Codigo)

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

lstr_info.titulo	= "MAESTRO MODELOS EQUIPOS"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_modelo"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve(uo_SelMarca.Codigo, uo_SelTipoEquipo.Codigo)

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

istr_mant.Borra		= True
istr_mant.Agrega	= False

istr_Mant.Argumento[1]	=	String(uo_SelMarca.Codigo)
istr_Mant.Argumento[2]	=	String(uo_SelTipoEquipo.Codigo)

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
	istr_mant.Agrega	= False
	istr_mant.Borra		= False
	
	istr_Mant.Argumento[1]	=	String(uo_SelMarca.Codigo)
	istr_Mant.Argumento[2]	=	String(uo_SelTipoEquipo.Codigo)

	OpenWithParm(iw_mantencion, istr_mant)
END IF
end event

type dw_1 from w_mant_tabla`dw_1 within w_mant_mues_modelo
integer y = 388
integer width = 2025
integer height = 1248
string dataobject = "dw_mues_modelo"
end type

type st_encabe from w_mant_tabla`st_encabe within w_mant_mues_modelo
integer y = 40
integer width = 2025
integer height = 320
boolean enabled = true
end type

type pb_lectura from w_mant_tabla`pb_lectura within w_mant_mues_modelo
integer x = 2267
end type

type pb_nuevo from w_mant_tabla`pb_nuevo within w_mant_mues_modelo
boolean visible = false
integer x = 2277
integer y = 572
integer height = 136
end type

type pb_insertar from w_mant_tabla`pb_insertar within w_mant_mues_modelo
integer x = 2277
integer y = 512
end type

type pb_eliminar from w_mant_tabla`pb_eliminar within w_mant_mues_modelo
integer x = 2281
integer y = 692
end type

type pb_grabar from w_mant_tabla`pb_grabar within w_mant_mues_modelo
integer x = 2286
integer y = 836
end type

type pb_imprimir from w_mant_tabla`pb_imprimir within w_mant_mues_modelo
integer x = 2299
integer y = 1064
end type

type pb_salir from w_mant_tabla`pb_salir within w_mant_mues_modelo
integer x = 2322
integer y = 1504
end type

type st_1 from statictext within w_mant_mues_modelo
integer x = 251
integer y = 216
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 16711680
string text = "Tipo Equipo"
boolean focusrectangle = false
end type

type st_2 from statictext within w_mant_mues_modelo
integer x = 251
integer y = 112
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 16711680
string text = "Marca"
boolean focusrectangle = false
end type

type uo_selmarca from uo_seleccion_marca within w_mant_mues_modelo
integer x = 750
integer y = 96
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_selmarca.destroy
call uo_seleccion_marca::destroy
end on

type uo_seltipoequipo from uo_seleccion_tipoequipos within w_mant_mues_modelo
integer x = 750
integer y = 200
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_seltipoequipo.destroy
call uo_seleccion_tipoequipos::destroy
end on

