$PBExportHeader$uo_seleccion_modelo.sru
$PBExportComments$Objeto público para selección de modelos equipo Todas o Consolidada
forward
global type uo_seleccion_modelo from userobject
end type
type cbx_consolida from checkbox within uo_seleccion_modelo
end type
type cbx_todos from checkbox within uo_seleccion_modelo
end type
type dw_seleccion from datawindow within uo_seleccion_modelo
end type
end forward

global type uo_seleccion_modelo from userobject
integer width = 896
integer height = 176
long backcolor = 553648127
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_cambio ( )
cbx_consolida cbx_consolida
cbx_todos cbx_todos
dw_seleccion dw_seleccion
end type
global uo_seleccion_modelo uo_seleccion_modelo

type variables
DataWindowChild	idwc_Seleccion

uo_modelo iuo_Codigo

Integer	Codigo, Empresa, Marca, TipoEquipo
String		Nombre 
end variables

forward prototypes
public subroutine seleccion (boolean ab_todos, boolean ab_consolida)
public subroutine todos (boolean ab_todos)
public subroutine limpiardatos ()
public subroutine bloquear (boolean ab_opcion)
public function boolean inicia (long ai_codigo)
public subroutine filtra (integer ai_marca, integer ai_tipoequipo)
end prototypes

public subroutine seleccion (boolean ab_todos, boolean ab_consolida);cbx_Todos.Visible		=	ab_Todos
cbx_Consolida.Visible	=	ab_Consolida

IF Not ab_Todos AND Not ab_Consolida THEN
	dw_Seleccion.y				=	0
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.Codigo.Color					=	0
	dw_Seleccion.Object.codigo.BackGround.Color	=	RGB(255, 255, 255)
ELSE
	dw_Seleccion.y				=	100
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.Color					=	RGB(255, 255, 255)
	dw_Seleccion.Object.codigo.BackGround.Color	=	553648127
END IF
end subroutine

public subroutine todos (boolean ab_todos);IF ab_Todos THEN
	Codigo						=	-1
	Nombre						=	'Todos'
	cbx_Todos.Checked		=	True
	cbx_Consolida.Enabled	=	True
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.Color					=	RGB(255, 255, 255)
	dw_Seleccion.Object.codigo.BackGround.Color	=	553648127
	
	dw_Seleccion.Reset()
	dw_Seleccion.InsertRow(0)
ELSE
	SetNull(Codigo)
	SetNull(Nombre)
	
	cbx_Todos.Checked		=	False
	cbx_Consolida.Checked	=	False
	cbx_Consolida.Enabled	=	False
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.codigo[1]						=	Codigo
	dw_Seleccion.Object.Codigo.Color					=	0
	dw_Seleccion.Object.codigo.BackGround.Color	=	RGB(255, 255, 255)
END IF
end subroutine

public subroutine limpiardatos ();String	ls_Null

SetNull(ls_Null)

dw_Seleccion.Object.Codigo[1] = Long(ls_Null)
Codigo = Long(ls_Null)
end subroutine

public subroutine bloquear (boolean ab_opcion);If ab_opcion Then
	dw_Seleccion.Enabled	= False
	dw_Seleccion.Object.Codigo.Color					=	RGB(255, 255, 255)
	dw_Seleccion.Object.Codigo.BackGround.Color	=	553648127
Else
	dw_Seleccion.Enabled	= True
	dw_Seleccion.Object.Codigo.Color					=	0
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(255, 255, 255)
End If
end subroutine

public function boolean inicia (long ai_codigo);Integer	li_Nula
Boolean	lb_Retorno = False

SetNull(li_Nula)

If iuo_Codigo.Existe(Marca, TipoEquipo, Integer(ai_Codigo), False, sqlca) Then
	Codigo	=	iuo_Codigo.Codigo
	Nombre	=	iuo_Codigo.Nombre
	dw_Seleccion.SetItem(1, "Codigo", ai_Codigo)
	lb_Retorno = True
Else
	dw_Seleccion.SetItem(1, "Codigo", li_Nula)
End If

Return lb_Retorno 
end function

public subroutine filtra (integer ai_marca, integer ai_tipoequipo);Marca =	ai_Marca
TipoEquipo	= ai_TipoEquipo
 
dw_Seleccion.GetChild("codigo", idwc_Seleccion)

idwc_Seleccion.SetTransObject(sqlca)

IF idwc_Seleccion.Retrieve(Marca, TipoEquipo) = 0 THEN
	MessageBox("Atención", "No existen Modelos de Equipo para Marca / Tipo Equipo seleccionada.")
	
	SetNull(Codigo)
	SetNull(Nombre)
END IF

RETURN
end subroutine

on uo_seleccion_modelo.create
this.cbx_consolida=create cbx_consolida
this.cbx_todos=create cbx_todos
this.dw_seleccion=create dw_seleccion
this.Control[]={this.cbx_consolida,&
this.cbx_todos,&
this.dw_seleccion}
end on

on uo_seleccion_modelo.destroy
destroy(this.cbx_consolida)
destroy(this.cbx_todos)
destroy(this.dw_seleccion)
end on

event constructor;dw_Seleccion.Object.Codigo.Dddw.Name			=	'dw_mues_modelo'
dw_Seleccion.Object.codigo.Dddw.DisplayColumn	=	'mode_nombre'
dw_Seleccion.Object.codigo.Dddw.DataColumn		=	'mode_codigo'

dw_Seleccion.GetChild("codigo", idwc_Seleccion)
idwc_Seleccion.SetTransObject(sqlca)

cbx_Todos.FaceName		=	"Tahoma"
cbx_Consolida.FaceName=	"Tahoma"
cbx_Todos.TextColor		=	RGB(255,255,255)
cbx_Consolida.TextColor	=	RGB(255,255,255)

IF	idwc_Seleccion.Retrieve(-1, -1) = 0 THEN
	MessageBox("Atención", "No existen Modelos en tabla respectiva")
	
	SetNull(Codigo)
	SetNull(Nombre)
ELSE
	idwc_Seleccion.SetSort("vari_nombre A")
	idwc_Seleccion.Sort()
	
	dw_Seleccion.Object.codigo.Font.Height	=	'-8'
	dw_Seleccion.Object.codigo.Height		=	64
	
	dw_Seleccion.InsertRow(0)
	
	Codigo			=	-1
	Nombre			=	'Todas'
	iuo_Codigo		=	Create uo_Modelo
	
	This.Seleccion(True, True)
END IF
end event

type cbx_consolida from checkbox within uo_seleccion_modelo
integer x = 480
integer width = 407
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Consolidado"
end type

event clicked;IF This.Checked THEN
	Codigo	=	-9
	Nombre	=	'Consolidada'
ELSE
	Codigo	=	-1
	Nombre	=	'Todas'
END IF
//cbx_todos.Checked = False
Parent.TriggerEvent("ue_cambio")
end event

type cbx_todos from checkbox within uo_seleccion_modelo
integer width = 315
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Todos"
boolean checked = true
end type

event clicked;Todos(This.Checked)
//cbx_consolida.Checked = False
Parent.TriggerEvent("ue_cambio")
end event

type dw_seleccion from datawindow within uo_seleccion_modelo
integer y = 84
integer width = 882
integer height = 96
integer taborder = 30
string title = "none"
string dataobject = "dddw_codnumero"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Integer	li_Nula

SetNull(li_Nula)

IF iuo_Codigo.Existe(Marca, TipoEquipo, Integer(data), True, sqlca) THEN
	Codigo	=	iuo_Codigo.Codigo
	Nombre	=	iuo_Codigo.Nombre
ELSE
	This.SetItem(1, "codigo", li_Nula)

	RETURN 1
END IF

Parent.TriggerEvent("ue_cambio")
end event

event itemerror;Return 1
end event

event clicked;//cbx_consolida.Checked = False
//cbx_todos.Checked = False
end event

