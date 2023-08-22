$PBExportHeader$w_proc_devolucion_equipos.srw
forward
global type w_proc_devolucion_equipos from w_mant_directo
end type
type pb_todos from picturebutton within w_proc_devolucion_equipos
end type
type pb_ninguno from picturebutton within w_proc_devolucion_equipos
end type
type st_1 from statictext within w_proc_devolucion_equipos
end type
type uo_selcolaborador from uo_seleccion_colaborador within w_proc_devolucion_equipos
end type
type st_2 from statictext within w_proc_devolucion_equipos
end type
type em_serie from editmask within w_proc_devolucion_equipos
end type
end forward

global type w_proc_devolucion_equipos from w_mant_directo
integer width = 4430
integer height = 1760
string title = "Devolucion de Equipos Computacionales"
pb_todos pb_todos
pb_ninguno pb_ninguno
st_1 st_1
uo_selcolaborador uo_selcolaborador
st_2 st_2
em_serie em_serie
end type
global w_proc_devolucion_equipos w_proc_devolucion_equipos

type variables
uo_Equipo	iuo_Equipos
end variables

on w_proc_devolucion_equipos.create
int iCurrent
call super::create
this.pb_todos=create pb_todos
this.pb_ninguno=create pb_ninguno
this.st_1=create st_1
this.uo_selcolaborador=create uo_selcolaborador
this.st_2=create st_2
this.em_serie=create em_serie
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_todos
this.Control[iCurrent+2]=this.pb_ninguno
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_selcolaborador
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_serie
end on

on w_proc_devolucion_equipos.destroy
call super::destroy
destroy(this.pb_todos)
destroy(this.pb_ninguno)
destroy(this.st_1)
destroy(this.uo_selcolaborador)
destroy(this.st_2)
destroy(this.em_serie)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve(uo_SelColaborador.Codigo)
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()	
		pb_Todos.Enabled		=	True
		pb_Ninguno.Enabled	=	True
		il_fila						= 1
		em_Serie.SetFocus()
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event resize;call super::resize;pb_Ninguno.x	=	st_encabe.Width - pb_Ninguno.Width - 60
pb_Todos.x		=	pb_Ninguno.x - pb_Todos.width -30
end event

event ue_antesguardar;call super::ue_antesguardar;Long ll_Fila

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.IsSelected(ll_Fila) Then
		dw_1.Object.eqas_estado[ll_Fila]	= 2
		dw_1.Object.eqas_fecter[ll_Fila]	= Today()		
	End If
Next
end event

event open;call super::open;Boolean lb_Cerrar

If IsNull(uo_SelColaborador.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else	
	uo_SelColaborador.Seleccion(False, False)
	iuo_Equipos	=	Create uo_Equipo
End If
end event

event ue_imprimir;call super::ue_imprimir;SetPointer(HourGlass!)

Long		fila

str_info	lstr_info
lstr_info.titulo	= "CARTA DE DEVOLUCION EQUIPOS COMPUTACIONALES"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_carta_asignacion"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(-1, uo_SelColaborador.Codigo, 2)

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No Existe información para este informe.", StopSign!, OK!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.ModIfy('DataWindow.Print.Preview = Yes')
	vinf.dw_1.ModIfy('DataWindow.Print.Preview.Zoom = 75')
	
	Long	ll_Fila

	For ll_Fila = 1 To dw_1.RowCount()
		If dw_1.IsSelected(ll_Fila) Then
			iuo_Equipos.of_ActualizaMarcaDev(dw_1.Object.equi_codigo[ll_Fila], False, SQLCA)
		End If
	Next
End If

SetPointer(Arrow!)
end event

event ue_guardar;call super::ue_guardar;Long	ll_Fila

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.IsSelected(ll_Fila) Then
		If Not iuo_Equipos.of_ActualizaEstado(dw_1.Object.equi_codigo[ll_Fila], 0, False, SQLCA) Then
			Messagebox('Error', 'No se puedo actulizar equipo codigo:' + String(dw_1.Object.equi_codigo[ll_Fila], '00000'), StopSign!, OK!)
		End If
	End if
Next
end event

type st_encabe from w_mant_directo`st_encabe within w_proc_devolucion_equipos
integer x = 352
integer width = 3419
integer height = 284
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_proc_devolucion_equipos
integer x = 4018
integer y = 288
integer taborder = 40
end type

event pb_nuevo::clicked;call super::clicked;pb_Todos.Enabled		=	False
pb_Ninguno.Enabled	=	False
end event

type pb_lectura from w_mant_directo`pb_lectura within w_proc_devolucion_equipos
integer x = 4009
integer y = 52
integer taborder = 20
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_proc_devolucion_equipos
boolean visible = false
integer x = 4009
integer y = 644
integer taborder = 60
end type

type pb_insertar from w_mant_directo`pb_insertar within w_proc_devolucion_equipos
boolean visible = false
integer x = 4023
integer y = 468
integer taborder = 50
end type

type pb_salir from w_mant_directo`pb_salir within w_proc_devolucion_equipos
integer x = 4009
integer y = 1320
integer taborder = 90
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_proc_devolucion_equipos
integer x = 4009
integer y = 1004
integer taborder = 80
end type

type pb_grabar from w_mant_directo`pb_grabar within w_proc_devolucion_equipos
integer x = 4009
integer y = 824
integer taborder = 70
end type

type dw_1 from w_mant_directo`dw_1 within w_proc_devolucion_equipos
integer y = 396
integer width = 3694
integer height = 1092
integer taborder = 0
string dataobject = "dw_mues_equipoasignado_activo"
boolean hscrollbar = true
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

type pb_todos from picturebutton within w_proc_devolucion_equipos
integer x = 2706
integer y = 120
integer width = 425
integer height = 180
integer taborder = 100
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

type pb_ninguno from picturebutton within w_proc_devolucion_equipos
integer x = 3173
integer y = 120
integer width = 425
integer height = 180
integer taborder = 110
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

type st_1 from statictext within w_proc_devolucion_equipos
integer x = 658
integer y = 236
integer width = 375
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
string text = "Serie"
boolean focusrectangle = false
end type

type uo_selcolaborador from uo_seleccion_colaborador within w_proc_devolucion_equipos
integer x = 1083
integer y = 108
integer height = 92
integer taborder = 10
boolean bringtotop = true
end type

on uo_selcolaborador.destroy
call uo_seleccion_colaborador::destroy
end on

type st_2 from statictext within w_proc_devolucion_equipos
integer x = 658
integer y = 116
integer width = 375
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
string text = "Colaborador"
boolean focusrectangle = false
end type

type em_serie from editmask within w_proc_devolucion_equipos
integer x = 1083
integer y = 224
integer width = 896
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;String	ls_Busca
Long	ll_Busca

If IsNull(This.Text) or This.Text = '' Then Return

ls_Busca = "Upper(equi_nroser) = '" + Upper(This.Text) + "' Or Upper(equi_nroint) = '" + Upper(This.Text) + "'"

ll_Busca = dw_1.Find(ls_Busca, 1, dw_1.RowCount())

If ll_Busca > 0 Then
	If dw_1.IsSelected(ll_Busca) Then
		MessageBox('Atencion', 'Numero de Serie cargado ya esta marcado.', Exclamation!, Ok!)
		This.Text = ''
		This.SetFocus()
	Else
		dw_1.SelectRow(ll_Busca, True)
		This.Text = ''
		This.SetFocus()
	End If
Else
	Messagebox('Atencion', 'Numero de serie no encontrado, en asignacion a colaborador', Information!, OK!)
	This.Text = ''
	This.SetFocus()
End If


end event

