$PBExportHeader$uo_seleccion_tipoequipos.sru
$PBExportComments$Objeto público para selección de Tipo de Equipos, Todas o Consolidada
forward
global type uo_seleccion_tipoequipos from userobject
end type
type cbx_consolida from checkbox within uo_seleccion_tipoequipos
end type
type cbx_todos from checkbox within uo_seleccion_tipoequipos
end type
type dw_seleccion from datawindow within uo_seleccion_tipoequipos
end type
end forward

global type uo_seleccion_tipoequipos from userobject
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
global uo_seleccion_tipoequipos uo_seleccion_tipoequipos

type variables
DataWindowChild	idwc_Seleccion

uo_TipoEquipos	iuo_Codigo

Integer	Codigo
String		Nombre, Abreviacion
Long		Inicial, Actual
end variables

forward prototypes
public subroutine seleccion (boolean ab_todos, boolean ab_consolida)
public subroutine todos (boolean ab_todos)
public subroutine limpiardatos ()
public subroutine bloquear (boolean ab_opcion)
public function boolean inicia (long ai_codigo)
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

If iuo_Codigo.Existe(Integer(ai_Codigo), False, sqlca) Then
	Codigo	=	iuo_Codigo.Codigo
	Nombre	=	iuo_Codigo.Nombre
	dw_Seleccion.SetItem(1, "Codigo", ai_Codigo)
	lb_Retorno = True
Else
	dw_Seleccion.SetItem(1, "Codigo", li_Nula)
End If

Return lb_Retorno 
end function

on uo_seleccion_tipoequipos.create
this.cbx_consolida=create cbx_consolida
this.cbx_todos=create cbx_todos
this.dw_seleccion=create dw_seleccion
this.Control[]={this.cbx_consolida,&
this.cbx_todos,&
this.dw_seleccion}
end on

on uo_seleccion_tipoequipos.destroy
destroy(this.cbx_consolida)
destroy(this.cbx_todos)
destroy(this.dw_seleccion)
end on

event constructor;dw_Seleccion.Object.Codigo.Dddw.Name			=	'dw_mues_tipoequipo'
dw_Seleccion.Object.codigo.Dddw.DisplayColumn	=	'tieq_nombre'
dw_Seleccion.Object.codigo.Dddw.DataColumn		=	'tieq_codigo'

dw_Seleccion.GetChild("codigo", idwc_Seleccion)
idwc_Seleccion.SetTransObject(sqlca)

cbx_Todos.FaceName		=	"Tahoma"
cbx_Consolida.FaceName=	"Tahoma"
cbx_Todos.TextColor		=	RGB(255,255,255)
cbx_Consolida.TextColor	=	RGB(255,255,255)

IF	idwc_Seleccion.Retrieve(-1) = 0 THEN
	MessageBox("Atención", "No existen Tipo de Equipos en tabla respectiva")
	
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
	iuo_Codigo		=	Create uo_TipoEquipos
	
	This.Seleccion(True, True)
END IF
end event

type cbx_consolida from checkbox within uo_seleccion_tipoequipos
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

type cbx_todos from checkbox within uo_seleccion_tipoequipos
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

type dw_seleccion from datawindow within uo_seleccion_tipoequipos
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

IF iuo_Codigo.Existe(Integer(Data), True, sqlca) THEN
	Codigo		=	iuo_Codigo.Codigo
	Nombre		=	iuo_Codigo.Nombre
	Abreviacion	=	iuo_Codigo.Abreviacion
	Inicial			=	iuo_Codigo.Inicial
	Actual			=	iuo_Codigo.Actual
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

