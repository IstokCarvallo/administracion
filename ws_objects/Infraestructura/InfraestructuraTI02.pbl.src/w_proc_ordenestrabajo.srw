$PBExportHeader$w_proc_ordenestrabajo.srw
forward
global type w_proc_ordenestrabajo from w_mant_directo
end type
type st_2 from statictext within w_proc_ordenestrabajo
end type
type st_1 from statictext within w_proc_ordenestrabajo
end type
type em_desde from editmask within w_proc_ordenestrabajo
end type
type em_hasta from editmask within w_proc_ordenestrabajo
end type
type pb_todos from picturebutton within w_proc_ordenestrabajo
end type
type pb_ninguno from picturebutton within w_proc_ordenestrabajo
end type
type st_titulo from statictext within w_proc_ordenestrabajo
end type
end forward

global type w_proc_ordenestrabajo from w_mant_directo
integer width = 4183
integer height = 1760
st_2 st_2
st_1 st_1
em_desde em_desde
em_hasta em_hasta
pb_todos pb_todos
pb_ninguno pb_ninguno
st_titulo st_titulo
end type
global w_proc_ordenestrabajo w_proc_ordenestrabajo

type variables
String		is_Tipo
Integer	ii_Tipo = 1
end variables

on w_proc_ordenestrabajo.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.em_desde=create em_desde
this.em_hasta=create em_hasta
this.pb_todos=create pb_todos
this.pb_ninguno=create pb_ninguno
this.st_titulo=create st_titulo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_desde
this.Control[iCurrent+4]=this.em_hasta
this.Control[iCurrent+5]=this.pb_todos
this.Control[iCurrent+6]=this.pb_ninguno
this.Control[iCurrent+7]=this.st_titulo
end on

on w_proc_ordenestrabajo.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_desde)
destroy(this.em_hasta)
destroy(this.pb_todos)
destroy(this.pb_ninguno)
destroy(this.st_titulo)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve(1, Datetime(em_Desde.Text), Datetime(em_Hasta.Text))
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()	
		pb_Todos.Enabled		=	True
		pb_Ninguno.Enabled	=	True
		il_fila					= 1
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event open;x				=	0
y				=	0

String	ls_Titulo

is_Tipo	=	Message.StringParm

This.Icon									=	Gstr_apl.Icono

If is_Tipo = 'C' Then 
	st_Titulo.Text = ' C I E R R E '
	This.Title	= 'Cierre de Ordenes de Trabajo'
	ls_Titulo	= 'Cierre de Ordenes de Trabajo'
	ii_Tipo 	= 2
Else
	st_Titulo.Text = ' A N U L A '
	This.Title	= 'Anulacion de Ordenes de Trabajo'
	ls_Titulo	= 'Anulacion de Ordenes de Trabajo'
	ii_Tipo 	= 3	
End If

em_Desde.Text	= String(Today(), 'dd/mm/yyyy')
em_Hasta.Text	= String(Today(), 'dd/mm/yyyy')

dw_1.SetTransObject(sqlca)
dw_1.Modify("datawindow.message.title='Error '+ is_titulo")

istr_mant.UsuarioSoloConsulta	=	OpcionSoloConsulta()
istr_mant.Solo_Consulta			=	istr_mant.UsuarioSoloConsulta

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, This.Title, ls_Titulo, 1)
end event

event resize;call super::resize;pb_Ninguno.x	=	st_encabe.Width - pb_Ninguno.Width - 60
pb_Todos.x		=	pb_Ninguno.x - pb_Todos.width -30

st_Titulo.x		=	em_Hasta.x + em_Hasta.Width + 60
end event

event ue_antesguardar;call super::ue_antesguardar;Long ll_Fila 

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.IsSelected(ll_Fila) Then
		dw_1.Object.ortr_estado[ll_Fila] = ii_Tipo
	End If
Next
end event

type st_encabe from w_mant_directo`st_encabe within w_proc_ordenestrabajo
integer width = 3621
integer height = 284
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_proc_ordenestrabajo
integer x = 3867
integer y = 336
integer taborder = 50
end type

event pb_nuevo::clicked;call super::clicked;pb_Todos.Enabled		=	False
pb_Ninguno.Enabled	=	False
em_Desde.Text	= String(Today(), 'dd/mm/yyyy')
em_Hasta.Text	= String(Today(), 'dd/mm/yyyy')

end event

type pb_lectura from w_mant_directo`pb_lectura within w_proc_ordenestrabajo
integer x = 3858
integer y = 100
integer taborder = 40
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_proc_ordenestrabajo
boolean visible = false
integer x = 3858
integer y = 692
integer taborder = 80
end type

type pb_insertar from w_mant_directo`pb_insertar within w_proc_ordenestrabajo
boolean visible = false
integer x = 3872
integer y = 516
integer taborder = 70
end type

type pb_salir from w_mant_directo`pb_salir within w_proc_ordenestrabajo
integer x = 3858
integer y = 1368
integer taborder = 110
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_proc_ordenestrabajo
boolean visible = false
integer x = 3858
integer y = 1052
integer taborder = 100
end type

type pb_grabar from w_mant_directo`pb_grabar within w_proc_ordenestrabajo
integer x = 3858
integer y = 872
integer taborder = 90
end type

type dw_1 from w_mant_directo`dw_1 within w_proc_ordenestrabajo
integer y = 396
integer width = 3621
integer height = 1092
integer taborder = 60
string dataobject = "dw_mues_ordentrabajo_estado"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;call super::clicked;String	ls_old_sort, ls_column
Char		lc_sort

IF IsNull(dwo) THEN RETURN

If Right(dwo.Name,2) = '_t' Then
	ls_column = Left (dwo.Name, Len(String(dwo.Name)) - 2)
	ls_old_sort = This.Describe("Datawindow.Table.sort")

	If ls_column = Left(ls_old_sort, Len(ls_old_sort) - 2) Then
		lc_sort = Right(ls_old_sort, 1)
		If lc_sort = 'A' Then
			lc_sort = 'D'
		Else
			lc_sort = 'A'
		End If
		This.SetSort(ls_column+" "+lc_sort)
	Else
		This.SetSort(ls_column+" A")
		This.Modify(Left(ls_old_sort, Len(ls_old_sort) - 2) + "_t.Color = " + String(Rgb(255,255,255)))
	End If
	
	This.Modify(dwo.Name + ".Color = " + String(Rgb(255, 255, 0)))
	
	This.Sort()
End If

IF Row > 0 THEN
	This.SetRow(Row)
	If This.IsSelected(Row) Then 
		This.SelectRow(Row,False)
	Else
		This.SelectRow(Row,True)
	End If
END IF

RETURN 0
end event

type st_2 from statictext within w_proc_ordenestrabajo
integer x = 1051
integer y = 176
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Hasta"
boolean focusrectangle = false
end type

type st_1 from statictext within w_proc_ordenestrabajo
integer x = 169
integer y = 176
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Desde"
boolean focusrectangle = false
end type

type em_desde from editmask within w_proc_ordenestrabajo
integer x = 434
integer y = 164
integer width = 512
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_hasta from editmask within w_proc_ordenestrabajo
integer x = 1271
integer y = 164
integer width = 512
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type pb_todos from picturebutton within w_proc_ordenestrabajo
integer x = 2706
integer y = 120
integer width = 425
integer height = 180
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\btn_todos_on.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\btn_todos_off.png"
alignment htextalign = left!
end type

event clicked;Long ll_Fila 

For ll_Fila = 1 To dw_1.RowCount()
	dw_1.SelectRow(ll_Fila, True)
Next
end event

type pb_ninguno from picturebutton within w_proc_ordenestrabajo
integer x = 3182
integer y = 120
integer width = 425
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\btn_ninguno_on.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\btn_ninguno_off.png"
alignment htextalign = left!
end type

event clicked;dw_1.SelectRow(0, False)
end event

type st_titulo from statictext within w_proc_ordenestrabajo
integer x = 1746
integer y = 148
integer width = 827
integer height = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "ANULA"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

