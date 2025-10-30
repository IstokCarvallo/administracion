$PBExportHeader$uo_seleccion_empresa.sru
$PBExportComments$Objeto público para selección de Empresa, Todos o Consolidado
forward
global type uo_seleccion_empresa from userobject
end type
type cbx_consolida from checkbox within uo_seleccion_empresa
end type
type cbx_todos from checkbox within uo_seleccion_empresa
end type
type dw_seleccion from datawindow within uo_seleccion_empresa
end type
end forward

global type uo_seleccion_empresa from userobject
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
global uo_seleccion_empresa uo_seleccion_empresa

type variables
DataWindowChild	idwc_Seleccion

uo_Empresa	iuo_Codigo

String		Codigo, Nombre, Direccion
Integer	Base
end variables

forward prototypes
public subroutine seleccion (boolean ab_todos, boolean ab_consolida)
public subroutine todos (boolean ab_todos)
public function boolean inicia (string as_codigo)
public subroutine habilita (boolean ab_habilita)
end prototypes

public subroutine seleccion (boolean ab_todos, boolean ab_consolida);cbx_Todos.Visible			=	ab_Todos
cbx_Consolida.Visible		=	ab_Consolida

If Not ab_Todos AND Not ab_Consolida Then
	dw_Seleccion.y			=	0
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(255, 255, 255)
Else
	dw_Seleccion.y			=	100
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=	553648127
End If

Return
end subroutine

public subroutine todos (boolean ab_todos);If ab_Todos Then
	Codigo						=	'*'
	Nombre						=	'Todos'
	cbx_Todos.Checked		=	True
	cbx_Consolida.Enabled	=	True
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.BackGround.Color	=553648127
	dw_Seleccion.Reset()
	dw_Seleccion.InsertRow(0)
Else
	SetNull(Codigo)
	SetNull(Nombre)
	
	cbx_Todos.Checked		=	False
	cbx_Consolida.Checked	=	False
	cbx_Consolida.Enabled	=	False
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.Codigo[1]						=	Codigo
	dw_Seleccion.Object.Codigo.BackGround.Color	=	RGB(255, 255, 255)
End If
end subroutine

public function boolean inicia (string as_codigo);Integer	li_Nula
Boolean	lb_Retorno = False

SetNull(li_Nula)

If iuo_Codigo.Of_Existe(as_Codigo,  False, sqlca) Then
	Codigo	=	iuo_Codigo.Rut
	Nombre	=	iuo_Codigo.Nombre
	Direccion	=	iuo_Codigo.Direccion
	Base		=	iuo_Codigo.Base
	
	dw_Seleccion.SetItem(1, "codigo", as_Codigo)
	lb_Retorno = True
Else
	dw_Seleccion.SetItem(1, "codigo", li_Nula)
End If

Return lb_Retorno 
end function

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

on uo_seleccion_empresa.create
this.cbx_consolida=create cbx_consolida
this.cbx_todos=create cbx_todos
this.dw_seleccion=create dw_seleccion
this.Control[]={this.cbx_consolida,&
this.cbx_todos,&
this.dw_seleccion}
end on

on uo_seleccion_empresa.destroy
destroy(this.cbx_consolida)
destroy(this.cbx_todos)
destroy(this.dw_seleccion)
end on

event constructor;Long		ll_Filas

dw_Seleccion.Object.Codigo.Dddw.Name			=	'dw_mues_empresa'
dw_Seleccion.Object.codigo.Dddw.DisplayColumn	=	'empr_nombre'
dw_Seleccion.Object.codigo.Dddw.DataColumn		=	'empr_codigo'

dw_Seleccion.GetChild("codigo", idwc_Seleccion)
idwc_Seleccion.SetTransObject(sqlca)
ll_Filas	=	idwc_Seleccion.Retrieve(0)

cbx_Todos.FaceName		=	"Tahoma"
cbx_consolida.FaceName	=	"Tahoma"
cbx_Todos.TextColor		=	RGB(255,255,255)
cbx_Consolida.TextColor	=	RGB(255,255,255)

If	idwc_Seleccion.Retrieve() = 0 Then
	MessageBox("Atención", "No existen Empresas en tabla respectiva")
	
	SetNull(Codigo)
	SetNull(Nombre)
Else
	idwc_Seleccion.SetSort("empr_nombre A")
	idwc_Seleccion.Sort()
	
	dw_Seleccion.Object.Codigo.Font.Height	=	'-8'
	dw_Seleccion.Object.Codigo.Height			=	64
	
	dw_Seleccion.SetTransObject(sqlca)
	dw_Seleccion.InsertRow(0)
	
	Codigo			=	'*'
	Nombre			=	'Todos'
	iuo_Codigo	=	Create uo_Empresa
	
	This.Seleccion(True, True)
End If
end event

type cbx_consolida from checkbox within uo_seleccion_empresa
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
	Codigo	=	'**'
	Nombre	=	'Consolidado'
Else
	Codigo	=	'*'
	Nombre	=	'Todos'
End If

Parent.TriggerEvent("ue_cambio")
End event

type cbx_todos from checkbox within uo_seleccion_empresa
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

type dw_seleccion from datawindow within uo_seleccion_empresa
integer y = 80
integer width = 882
integer height = 176
integer taborder = 30
string title = "none"
string dataobject = "dddw_codstring"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Integer	li_Nula

SetNull(li_Nula)

If iuo_Codigo.of_Existe(data, True, sqlca) Then
	Codigo	=	iuo_Codigo.Rut
	Nombre	=	iuo_Codigo.Nombre
	Direccion	=	iuo_Codigo.Direccion
	Base		=	iuo_Codigo.Base
Else
	This.SetItem(1, "Codigo", li_Nula)

	Return 1
End If

Parent.TriggerEvent("ue_cambio")
end event

event itemerror;Return 1
End event

