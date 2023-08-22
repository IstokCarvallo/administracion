$PBExportHeader$w_proc_equipos.srw
forward
global type w_proc_equipos from w_mant_directo
end type
type pb_todos from picturebutton within w_proc_equipos
end type
type pb_ninguno from picturebutton within w_proc_equipos
end type
type ddlb_estado from dropdownlistbox within w_proc_equipos
end type
type st_1 from statictext within w_proc_equipos
end type
end forward

global type w_proc_equipos from w_mant_directo
integer width = 4279
integer height = 1760
pb_todos pb_todos
pb_ninguno pb_ninguno
ddlb_estado ddlb_estado
st_1 st_1
end type
global w_proc_equipos w_proc_equipos

type variables
byte	ib_Estado
end variables

on w_proc_equipos.create
int iCurrent
call super::create
this.pb_todos=create pb_todos
this.pb_ninguno=create pb_ninguno
this.ddlb_estado=create ddlb_estado
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_todos
this.Control[iCurrent+2]=this.pb_ninguno
this.Control[iCurrent+3]=this.ddlb_estado
this.Control[iCurrent+4]=this.st_1
end on

on w_proc_equipos.destroy
call super::destroy
destroy(this.pb_todos)
destroy(this.pb_ninguno)
destroy(this.ddlb_estado)
destroy(this.st_1)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve()
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()	
//		pb_Todos.Enabled		=	True
//		pb_Ninguno.Enabled	=	True
		il_fila					= 1
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event resize;call super::resize;pb_Ninguno.x	=	st_encabe.Width - pb_Ninguno.Width - 60
pb_Todos.x		=	pb_Ninguno.x - pb_Todos.width -30
end event

event ue_antesguardar;call super::ue_antesguardar;Long ll_Fila 

Open(w_sele_observa)

istr_Mant = Message.PowerObjectParm 

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.IsSelected(ll_Fila) Then
		dw_1.Object.equi_estado[ll_Fila] = ib_Estado
		dw_1.Object.equi_observ[ll_Fila] = dw_1.Object.equi_observ[ll_Fila] + istr_Mant.Argumento[1]
	End If
Next
end event

type st_encabe from w_mant_directo`st_encabe within w_proc_equipos
integer width = 3726
integer height = 284
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_proc_equipos
integer x = 3867
integer y = 336
integer taborder = 50
end type

event pb_nuevo::clicked;call super::clicked;pb_Todos.Enabled		=	False
pb_Ninguno.Enabled	=	False
end event

type pb_lectura from w_mant_directo`pb_lectura within w_proc_equipos
integer x = 3858
integer y = 100
integer taborder = 40
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_proc_equipos
boolean visible = false
integer x = 3858
integer y = 692
integer taborder = 80
end type

type pb_insertar from w_mant_directo`pb_insertar within w_proc_equipos
boolean visible = false
integer x = 3872
integer y = 516
integer taborder = 70
end type

type pb_salir from w_mant_directo`pb_salir within w_proc_equipos
integer x = 3858
integer y = 1368
integer taborder = 110
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_proc_equipos
boolean visible = false
integer x = 3858
integer y = 1052
integer taborder = 100
end type

type pb_grabar from w_mant_directo`pb_grabar within w_proc_equipos
integer x = 3858
integer y = 872
integer taborder = 90
end type

type dw_1 from w_mant_directo`dw_1 within w_proc_equipos
integer y = 396
integer width = 3726
integer height = 1092
integer taborder = 60
string dataobject = "dw_mues_equipos_estado"
boolean hscrollbar = true
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

type pb_todos from picturebutton within w_proc_equipos
boolean visible = false
integer x = 2715
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

type pb_ninguno from picturebutton within w_proc_equipos
boolean visible = false
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

type ddlb_estado from dropdownlistbox within w_proc_equipos
integer x = 1371
integer y = 164
integer width = 1248
integer height = 400
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
boolean sorted = false
string item[] = {"De Baja","Robado","Venta","Traslado","Devolucion Proveedor"}
end type

event selectionchanged;ib_Estado	= Index + 2
end event

type st_1 from statictext within w_proc_equipos
integer x = 1138
integer y = 176
integer width = 224
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Estado"
boolean focusrectangle = false
end type

