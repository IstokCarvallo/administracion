$PBExportHeader$w_carga_regularizamarcas.srw
forward
global type w_carga_regularizamarcas from w_para_informes
end type
type uo_selzona from uo_seleccion_zonas within w_carga_regularizamarcas
end type
type uo_seltipo from uo_seleccion_tipocolacion within w_carga_regularizamarcas
end type
type sle_usuario from singlelineedit within w_carga_regularizamarcas
end type
type st_4 from statictext within w_carga_regularizamarcas
end type
type st_5 from statictext within w_carga_regularizamarcas
end type
type st_6 from statictext within w_carga_regularizamarcas
end type
type em_fecha from editmask within w_carga_regularizamarcas
end type
type st_9 from statictext within w_carga_regularizamarcas
end type
type dw_1 from uo_dw within w_carga_regularizamarcas
end type
end forward

global type w_carga_regularizamarcas from w_para_informes
integer width = 4037
integer height = 2156
string title = "INFORME DE CONSUMOS DIARIOS"
boolean center = true
event ue_antesguardar ( )
uo_selzona uo_selzona
uo_seltipo uo_seltipo
sle_usuario sle_usuario
st_4 st_4
st_5 st_5
st_6 st_6
em_fecha em_fecha
st_9 st_9
dw_1 dw_1
end type
global w_carga_regularizamarcas w_carga_regularizamarcas

type variables
uo_personacasino	iuo_Personal
end variables

forward prototypes
protected function boolean wf_actualiza_db ()
end prototypes

event ue_antesguardar();Long		ll_Filas
Datetime	ld_Fecha

ld_Fecha = DateTime(Today(), Now())

For ll_Filas = 1 To dw_1.RowCount()
	If dw_1.IsSelected(ll_Filas) Then
		dw_1.Object.camv_estado[ll_Filas]	=	9
		dw_1.Object.camv_fecham[ll_Filas]	= 	ld_Fecha
		dw_1.Object.usua_codigo[ll_Filas]		= 	gstr_Us.Nombre
		dw_1.Object.camv_appain[ll_Filas]	= 	"Fuera Hora"
	End If
Next
end event

protected function boolean wf_actualiza_db ();Boolean	lb_AutoCommit, lb_Retorno
DateTime	ldt_FechaHora
ldt_FechaHora		=	F_FechaHora()
dw_1.GrupoFecha	=	ldt_FechaHora

IF Not dw_1.uf_check_required(0) THEN RETURN False

IF Not dw_1.uf_validate(0) THEN RETURN False

lb_AutoCommit		=	sqlca.AutoCommit
sqlca.AutoCommit	=	False

IF dw_1.Update(True, False) = 1 then 
	Commit;
	
	IF sqlca.SQLCode <> 0 THEN
		F_ErrorBaseDatos(sqlca, This.Title)
		lb_Retorno	=	False
	ELSE
		lb_Retorno	=	True
			
		dw_1.ResetUpdate()
	END IF
ELSE
	RollBack;
	
	IF sqlca.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
	
	lb_Retorno	=	False
END IF

sqlca.AutoCommit	=	lb_AutoCommit

RETURN lb_Retorno
end function

on w_carga_regularizamarcas.create
int iCurrent
call super::create
this.uo_selzona=create uo_selzona
this.uo_seltipo=create uo_seltipo
this.sle_usuario=create sle_usuario
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.em_fecha=create em_fecha
this.st_9=create st_9
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_selzona
this.Control[iCurrent+2]=this.uo_seltipo
this.Control[iCurrent+3]=this.sle_usuario
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.em_fecha
this.Control[iCurrent+8]=this.st_9
this.Control[iCurrent+9]=this.dw_1
end on

on w_carga_regularizamarcas.destroy
call super::destroy
destroy(this.uo_selzona)
destroy(this.uo_seltipo)
destroy(this.sle_usuario)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.em_fecha)
destroy(this.st_9)
destroy(this.dw_1)
end on

event open;call super::open;Boolean	lb_Cerrar

If IsNull(uo_SelZona.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelTipo.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else	
	iuo_Personal	=	Create uo_personacasino
	
	If Not iuo_Personal.of_Existe(gstr_Us.Nombre, True, SQLCA) Then
		Close(This)
		Return
	End If
	
	IF iuo_Personal.Invita <> 1 Then
		MessageBox('Error', 'Usuario no esta registrado para regularizar.')
		Close(This)
		Return
	End If
	
	sle_Usuario.Text	=	gstr_Us.Nombre
	em_Fecha.Text		=	String(Today(), 'dd/mm/yyyy')
	
	uo_SelZona.Seleccion(False, False)
	uo_SelTipo.Seleccion(False, False)
	
	uo_SelZona.Inicia(iuo_Personal.Zona)
	uo_SelTipo.Filtra(iuo_Personal.Zona)
	dw_1.SetTransObject(SQLCA)
End If
end event

type pb_excel from w_para_informes`pb_excel within w_carga_regularizamarcas
boolean visible = true
integer x = 3602
integer y = 728
integer taborder = 40
integer weight = 400
fontcharset fontcharset = ansi!
string picturename = "\Desarrollo 17\Imagenes\Botones\Guardar Todo.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Guardar Todo-bn.png"
end type

event pb_excel::clicked;call super::clicked;If dw_1.AcceptText() = -1 Then Return

SetPointer(HourGlass!)

w_main.SetMicroHelp("Grabando información...")

Message.DoubleParm = 0
Parent.TriggerEvent("ue_antesguardar")
If Message.DoubleParm = -1 Then Return

If wf_actualiza_db() Then
	w_main.SetMicroHelp("Información Grabada.")
Else
	w_main.SetMicroHelp("No se puede Grabar información.")
	Message.DoubleParm = -1
	Return
End If
end event

type st_computador from w_para_informes`st_computador within w_carga_regularizamarcas
integer x = 1102
end type

type st_usuario from w_para_informes`st_usuario within w_carga_regularizamarcas
integer x = 1102
end type

type st_temporada from w_para_informes`st_temporada within w_carga_regularizamarcas
integer x = 1102
end type

type p_logo from w_para_informes`p_logo within w_carga_regularizamarcas
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_carga_regularizamarcas
integer x = 242
integer width = 3168
integer height = 96
string text = "Carga Regularizacion Alimentacion"
end type

type pb_acepta from w_para_informes`pb_acepta within w_carga_regularizamarcas
integer x = 3607
integer y = 476
integer height = 240
integer taborder = 50
string picturename = "\Desarrollo 17\Imagenes\Botones\Busqueda.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Busqueda-bn.png"
end type

event pb_acepta::clicked;call super::clicked;Long	ll_Filas

If IsNull(uo_SelTipo.Codigo) Or uo_SelTipo.Codigo < 0 Then
	MessageBox('Atencion', 'Debe seleccionar un Tipo Colacion')
	Return
End If

ll_Filas	=	dw_1.Retrieve(uo_SelZona.Codigo, uo_SelTipo.Codigo, Date(em_Fecha.Text))

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")
	dw_1.SetRedraw(True)
	Return
ElseIf ll_Filas = 0 Then
	MessageBox('Atencion', 'No existe informacion para fecha y tipo comida seleccionada.')
	Return
Else
	pb_Excel.Enabled		=	True
		
	If ll_Filas > 0 Then		
		dw_1.SetRow(1)
		dw_1.SetFocus()
	End If
End If

uo_SelZona.Habilita(False)
uo_SelTipo.Habilita(False)
end event

type pb_salir from w_para_informes`pb_salir within w_carga_regularizamarcas
integer x = 3602
integer y = 1072
integer taborder = 60
end type

type uo_selzona from uo_seleccion_zonas within w_carga_regularizamarcas
integer x = 658
integer y = 448
integer width = 878
integer height = 96
integer taborder = 10
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		
	Case Else
		uo_SelTipo.Filtra(This.Codigo)
		
End Choose
end event

type uo_seltipo from uo_seleccion_tipocolacion within w_carga_regularizamarcas
integer x = 658
integer y = 576
integer width = 878
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_seltipo.destroy
call uo_seleccion_tipocolacion::destroy
end on

type sle_usuario from singlelineedit within w_carga_regularizamarcas
integer x = 1902
integer y = 448
integer width = 878
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_carga_regularizamarcas
integer x = 1573
integer y = 464
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Usuario"
boolean focusrectangle = false
end type

type st_5 from statictext within w_carga_regularizamarcas
integer x = 256
integer y = 464
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Zona"
boolean focusrectangle = false
end type

type st_6 from statictext within w_carga_regularizamarcas
integer x = 256
integer y = 592
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Tipo Colacion"
boolean focusrectangle = false
end type

type em_fecha from editmask within w_carga_regularizamarcas
integer x = 1902
integer y = 568
integer width = 457
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "###"
end type

type st_9 from statictext within w_carga_regularizamarcas
integer x = 1573
integer y = 592
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Fecha"
boolean focusrectangle = false
end type

type dw_1 from uo_dw within w_carga_regularizamarcas
integer x = 242
integer y = 716
integer width = 3168
integer height = 1228
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_carga_regularizamarcas"
end type

event clicked;call super::clicked;Long	ll_Fila, ll_SelectedRow

If Row = 0 Then
	/*
	Para que funcione este ordenamiento los títulos deben tener el nombre
	de la columna y terminacion "_t", de lo contrario no funcionará
	*/
	String		ls_old_sort, ls_column, ls_color_old
	Char		lc_sort
	
	IF IsNull(dwo) THEN RETURN
	
	If Right(dwo.Name,2) = '_t' Then
		ls_column	= Left (dwo.Name, Len(String(dwo.Name)) - 2)
		ls_old_sort	= This.Describe("Datawindow.Table.sort")
		ls_color_old	=This.Describe(ls_Column + "_t.Color")
	
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
			This.Modify(Left(ls_old_sort, Len(ls_old_sort) - 2) + "_t.Color = " + ls_color_old)
		End If
		
		This.Modify(dwo.Name + ".Color = " + String(Rgb(0, 0, 255)))
		
		This.Sort()
	End If

Else
	ll_SelectedRow = dw_1.GetSelectedRow(0)
	
	If KeyDown(KeyShift!) Then
		If ll_SelectedRow = 0 Then
			This.SelectRow(Row, True)
		Else
			This.SelectRow(1, False)
			If Row > ll_SelectedRow Then
				For ll_Fila = ll_SelectedRow To Row
					This.SelectRow(ll_Fila, True)
				Next
			Else
				For ll_Fila = Row To ll_SelectedRow
					This.SelectRow(ll_Fila, True)
				Next
			End If
		End If
	
	ElseIf KeyDown(KeyControl!) Then
		If This.IsSelected(Row) Then
			This.SelectRow(Row, False)
		Else
			This.SelectRow(Row, True)
		End If
	
	Else
		If This.IsSelected(Row) Then
			This.SelectRow(0, False)
			This.SelectRow(Row, True)
		Else
			This.SelectRow(0, False)
			This.SelectRow(Row, True)
		End If
	End If
End If
end event

