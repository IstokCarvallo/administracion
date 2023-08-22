$PBExportHeader$uo_seleccion_colaborador.sru
$PBExportComments$Objeto público para selección de Planta, Todas o Consolidada
forward
global type uo_seleccion_colaborador from userobject
end type
type cbx_consolida from checkbox within uo_seleccion_colaborador
end type
type cbx_todos from checkbox within uo_seleccion_colaborador
end type
type dw_seleccion from datawindow within uo_seleccion_colaborador
end type
end forward

global type uo_seleccion_colaborador from userobject
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
global uo_seleccion_colaborador uo_seleccion_colaborador

type variables
DataWindowChild	idwc_Seleccion

uo_Personal	iuo_Codigo

String 	Codigo, Nombre, RUT
end variables

forward prototypes
public subroutine seleccion (boolean ab_todos, boolean ab_consolida)
public subroutine todos (boolean ab_todos)
public subroutine limpiadatos ()
public function boolean inicia (string as_codigo)
public subroutine bloquear (boolean ab_opcion)
end prototypes

public subroutine seleccion (boolean ab_todos, boolean ab_consolida);cbx_Todos.Visible		=	ab_Todos
cbx_Consolida.Visible	=	ab_Consolida

IF Not ab_Todos AND Not ab_Consolida THEN
	dw_Seleccion.y			=	0
	dw_Seleccion.Enabled	=	True
	
	dw_Seleccion.Object.Codigo.Color					=	0
	dw_Seleccion.Object.codigo.BackGround.Color	=	RGB(255, 255, 255)
ELSE
	dw_Seleccion.y			=	100
	dw_Seleccion.Enabled	=	False
	
	dw_Seleccion.Object.Codigo.Color					=	RGB(255, 255, 255)
	dw_Seleccion.Object.codigo.BackGround.Color	=	553648127
END IF
end subroutine

public subroutine todos (boolean ab_todos);IF ab_Todos THEN
	Codigo						=	'*'
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

public subroutine limpiadatos ();String	ls_Nula

SetNull(ls_Nula)

dw_Seleccion.SetItem(1, "codigo", ls_Nula)
end subroutine

public function boolean inicia (string as_codigo);Integer	li_Nula
Boolean	lb_Retorno = False

SetNull(li_Nula)

If iuo_Codigo.Existe(as_Codigo, False, sqlca) Then
	Codigo	=	iuo_Codigo.Codigo
	Nombre	=	iuo_Codigo.Nombre
	dw_Seleccion.SetItem(1, "Codigo", as_Codigo)
	lb_Retorno = True
Else
	dw_Seleccion.SetItem(1, "Codigo", li_Nula)
End If

Return lb_Retorno 
end function

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

on uo_seleccion_colaborador.create
this.cbx_consolida=create cbx_consolida
this.cbx_todos=create cbx_todos
this.dw_seleccion=create dw_seleccion
this.Control[]={this.cbx_consolida,&
this.cbx_todos,&
this.dw_seleccion}
end on

on uo_seleccion_colaborador.destroy
destroy(this.cbx_consolida)
destroy(this.cbx_todos)
destroy(this.dw_seleccion)
end on

event constructor;dw_Seleccion.Object.Codigo.Dddw.Name			=	'dw_mues_personal'
dw_Seleccion.Object.codigo.Dddw.DisplayColumn	=	'compute_1'
dw_Seleccion.Object.codigo.Dddw.DataColumn		=	'pers_codigo'

dw_Seleccion.GetChild("codigo", idwc_Seleccion)
idwc_Seleccion.SetTransObject(sqlca)

cbx_Todos.FaceName		=	"Tahoma"
cbx_Consolida.FaceName=	"Tahoma"
cbx_Todos.TextColor		=	RGB(255,255,255)
cbx_Consolida.TextColor	=	RGB(255,255,255)

IF	idwc_Seleccion.Retrieve('*') = 0 THEN
	MessageBox("Atención", "No existen Colaboradores en tabla.", Information!, Ok!)
	SetNull(Codigo)
	SetNull(Nombre)
Else
	idwc_Seleccion.SetSort("compute_1 A")
	idwc_Seleccion.Sort()
	
	dw_Seleccion.Object.codigo.Font.Height	=	'-8'
	dw_Seleccion.Object.codigo.Height		=	64
	
	dw_Seleccion.SetTransObject(sqlca)
	dw_Seleccion.InsertRow(0)
	
	Codigo		=	'*'
	Nombre		=	'Todas'
	iuo_Codigo	=	Create uo_Personal
	
	This.Seleccion(True, True)
End If
end event

type cbx_consolida from checkbox within uo_seleccion_colaborador
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
	Codigo	=	'**'
	Nombre	=	'Consolidada'
ELSE
	Codigo	=	'*'
	Nombre	=	'Todas'
END IF

Parent.TriggerEvent("ue_cambio")
end event

type cbx_todos from checkbox within uo_seleccion_colaborador
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
end event

type dw_seleccion from datawindow within uo_seleccion_colaborador
integer y = 80
integer width = 882
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "dddw_codcaracteres"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String	li_Nula

SetNull(li_Nula)

RUT = F_VerRut(Data, True)

IF iuo_Codigo.Existe(RUT,True, sqlca) THEN
	Codigo			=	iuo_Codigo.Codigo
	Nombre			=	iuo_Codigo.NombreCompleto
ELSE
	This.SetItem(1, "Codigo", li_Nula)
	RETURN 1
END IF

Parent.TriggerEvent("ue_cambio")
end event

event itemerror;RETURN 1
end event

event itemfocuschanged;String	ls_Columna

ls_Columna = dwo.Name

IF Codigo <> "" THEN
	IF ls_Columna = "Codigo" THEN
		This.Object.Codigo.EditMask.Mask	=	"XXXXXXXXXX"
		
		IF Codigo <> "" THEN
			This.SetItem(Row, "cape_codigo", String(Double(Mid(Codigo, 1, 9)), "#########") + Mid(Codigo, 10))
		END IF
	ELSE
		This.Object.Codigo.EditMask.Mask	=	"###.###.###-!"
		This.SetItem(Row, "Codigo", Codigo)
	END IF
END IF
end event

event losefocus;Codigo		=	String(Double(Mid(Codigo, 1, Len(Codigo) - 1)), "000000000") + &
					Mid(Codigo, Len(Codigo))

This.SetItem(1, "codigo", Codigo)

AcceptText()
end event

