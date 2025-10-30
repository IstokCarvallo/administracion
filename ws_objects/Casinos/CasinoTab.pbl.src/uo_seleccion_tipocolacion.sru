$PBExportHeader$uo_seleccion_tipocolacion.sru
$PBExportComments$Objeto público para selección de Planta, Todas o Consolidada
forward
global type uo_seleccion_tipocolacion from userobject
end type
type cbx_consolida from checkbox within uo_seleccion_tipocolacion
end type
type cbx_todos from checkbox within uo_seleccion_tipocolacion
end type
type dw_seleccion from datawindow within uo_seleccion_tipocolacion
end type
end forward

global type uo_seleccion_tipocolacion from userobject
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
global uo_seleccion_tipocolacion uo_seleccion_tipocolacion

type variables
DataWindowChild	idwc_Seleccion

uo_TipoColacion	iuo_Codigo

Long		Codigo, Zona
String 	Nombre
end variables

forward prototypes
public subroutine seleccion (boolean ab_todos, boolean ab_consolida)
public subroutine todos (boolean ab_todos)
public subroutine limpiadatos ()
public function boolean inicia (integer ai_codigo)
public subroutine filtra (integer ai_zona)
public subroutine habilita (boolean ab_habilita)
end prototypes

public subroutine seleccion (boolean ab_todos, boolean ab_consolida);cbx_Todos.Visible			=	ab_Todos
cbx_Consolida.Visible	=	ab_Consolida

If Not ab_Todos AND Not ab_Consolida Then
	dw_Seleccion.y			=	0
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(255, 255, 255)
Else
	dw_Seleccion.y			=	100
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(192, 192, 192)
End If

Return
End subroutine

public subroutine todos (boolean ab_todos);If ab_Todos Then
	Codigo						=	-1
	Nombre						=	'Todos'
	cbx_Todos.Checked			=	True
	cbx_Consolida.Enabled	=	True
	dw_Seleccion.Enabled		=	False
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(192, 192, 192)
	
	dw_Seleccion.Reset()
	
	dw_Seleccion.InsertRow(0)
Else
	SetNull(Codigo)
	SetNull(Nombre)
	
	cbx_Todos.Checked			=	False
	cbx_Consolida.Checked	=	False
	cbx_Consolida.Enabled	=	False
	dw_Seleccion.Enabled		=	True
	
	dw_Seleccion.Object.Codigo[1]						=	Codigo
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(255, 255, 255)
End If

Return
End subroutine

public subroutine limpiadatos ();String	ls_Nula

SetNull(ls_Nula)

dw_Seleccion.SetItem(1, "codigo", Integer(ls_Nula))
End subroutine

public function boolean inicia (integer ai_codigo);Integer	li_Nula
Boolean	lb_Retorno = False

SetNull(li_Nula)

If iuo_Codigo.Of_Existe(ai_Codigo,  False, sqlca) Then
	Codigo	=	iuo_Codigo.Codigo
	Nombre	=	iuo_Codigo.Nombre	
	
	dw_Seleccion.SetItem(1, "codigo", String(ai_Codigo))
	lb_Retorno = True
Else
	dw_Seleccion.SetItem(1, "codigo", li_Nula)
End If

Return lb_Retorno 
End function

public subroutine filtra (integer ai_zona);Zona	=	ai_Zona
 
dw_Seleccion.GetChild("codigo", idwc_Seleccion)

idwc_Seleccion.SetTransObject(sqlca)

If idwc_Seleccion.Retrieve(Zona) = 0 Then
	MessageBox("Atención", "No existen colaciones para Tipo seleccionada.")
	
	SetNull(Codigo)
	SetNull(Nombre)
End If

Return
end subroutine

public subroutine habilita (boolean ab_habilita);String	Nula

SetNull(Nula)

If ab_Habilita Then
	dw_Seleccion.Object.Codigo[1]		=	Nula
	dw_Seleccion.Enabled				=	True
	dw_Seleccion.Object.Codigo.BackGround.Mode	=	0
Else
	dw_Seleccion.Enabled	=	False
	dw_Seleccion.Object.Codigo.BackGround.Mode	=	1
End If
end subroutine

on uo_seleccion_tipocolacion.create
this.cbx_consolida=create cbx_consolida
this.cbx_todos=create cbx_todos
this.dw_seleccion=create dw_seleccion
this.Control[]={this.cbx_consolida,&
this.cbx_todos,&
this.dw_seleccion}
end on

on uo_seleccion_tipocolacion.destroy
destroy(this.cbx_consolida)
destroy(this.cbx_todos)
destroy(this.dw_seleccion)
end on

event constructor;dw_Seleccion.Object.Codigo.Dddw.Name				=	'dw_mues_tipocolacion'
dw_Seleccion.Object.codigo.Dddw.DisplayColumn		=	'tico_nombre'
dw_Seleccion.Object.codigo.Dddw.DataColumn			=	'tico_codigo'

dw_Seleccion.GetChild("codigo", idwc_Seleccion)

idwc_Seleccion.SetTransObject(sqlca)
If	idwc_Seleccion.Retrieve(-1) = 0 Then
	MessageBox("Atención", "No existen Tipos de Colacion en Tabla Respectiva.", Information!, Ok!)
	SetNull(Codigo)
	SetNull(Nombre)
Else
	idwc_Seleccion.SetSort("tico_nombre A")
	idwc_Seleccion.Sort()
	
	dw_Seleccion.Object.codigo.Font.Height	=	'-8'
	dw_Seleccion.Object.codigo.Height		=	64
	
	dw_Seleccion.SetTransObject(sqlca)
	dw_Seleccion.InsertRow(0)
	
	Codigo		=	-1
	Nombre		=	'Todas'
	
	iuo_Codigo	=	Create uo_TipoColacion
	
	This.Seleccion(True, True)
End If
end event

type cbx_consolida from checkbox within uo_seleccion_tipocolacion
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

event clicked;If This.Checked Then
	Codigo	=	-9
	Nombre	=	'Consolidada'
Else
	Codigo	=	-1
	Nombre	=	'Todas'
End If

Parent.TriggerEvent("ue_cambio")
End event

type cbx_todos from checkbox within uo_seleccion_tipocolacion
integer width = 402
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

Parent.TriggerEvent("ue_cambio")
End event

type dw_seleccion from datawindow within uo_seleccion_tipocolacion
integer y = 80
integer width = 882
integer height = 144
integer taborder = 30
string title = "none"
string dataobject = "dddw_codnumero"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Integer	li_Nula

SetNull(li_Nula)

If iuo_Codigo.of_Existe(Integer(data),True, SQLCA) Then
	Codigo			=	iuo_Codigo.Codigo
	Nombre			=	iuo_Codigo.Nombre
Else
	This.SetItem(1, "Codigo", li_Nula)
	Return 1
End If

Parent.TriggerEvent("ue_cambio")
End event

event itemerror;Return 1
End event

