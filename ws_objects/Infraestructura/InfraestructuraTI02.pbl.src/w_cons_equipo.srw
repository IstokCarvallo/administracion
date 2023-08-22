$PBExportHeader$w_cons_equipo.srw
forward
global type w_cons_equipo from w_mant_directo
end type
type st_2 from statictext within w_cons_equipo
end type
type st_1 from statictext within w_cons_equipo
end type
type em_numero from editmask within w_cons_equipo
end type
end forward

global type w_cons_equipo from w_mant_directo
integer width = 2341
integer height = 1664
string title = "Consulta de Equipos / Leasing"
st_2 st_2
st_1 st_1
em_numero em_numero
end type
global w_cons_equipo w_cons_equipo

type variables
uo_Equipo	iuo_Equipo
end variables

on w_cons_equipo.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.em_numero=create em_numero
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_numero
end on

on w_cons_equipo.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_numero)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve(em_numero.Text)
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	ELSEIF ll_fila = 1 THEN
		dw_1.DataObject = 'dw_cons_equipo'
		dw_1.SetTRansObject(Sqlca)
		dw_1.Retrieve(em_numero.Text)
		This.Windowstate = Normal!
		
		dw_1.SetRow(1)
		dw_1.SetFocus()	
		il_fila					= 1
	ELSEIF ll_fila > 1 THEN
		dw_1.DataObject = 'dw_cons_equipo_multi'
		dw_1.SetTRansObject(Sqlca)
		dw_1.Retrieve(em_numero.Text)
		dw_1.HScrollBar	= True
		This.Windowstate = Maximized!
	ELSE
		MessageBox("Atencion...", "No es posible encontrar codigo ingresado.", Information!, OK!)
		em_numero.Text = ''
		dw_1.InsertRow(0)
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event open;x				=	0
y				=	0
This.Icon									=	Gstr_apl.Icono

dw_1.SetTransObject(sqlca)
dw_1.Modify("datawindow.message.title='Error '+ is_titulo")
dw_1.InsertRow(0)

istr_mant.UsuarioSoloConsulta	=	OpcionSoloConsulta()
istr_mant.Solo_Consulta			=	istr_mant.UsuarioSoloConsulta

iuo_Equipo	=	Create uo_Equipo

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, This.Title, "Consulta de Equipos por Nro. Serie / Nro.", 1)
end event

type st_encabe from w_mant_directo`st_encabe within w_cons_equipo
integer width = 1733
integer height = 284
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_cons_equipo
boolean visible = false
integer x = 1934
integer y = 324
integer taborder = 50
boolean enabled = false
end type

type pb_lectura from w_mant_directo`pb_lectura within w_cons_equipo
boolean visible = false
integer x = 1925
integer y = 88
integer taborder = 40
boolean enabled = false
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_cons_equipo
boolean visible = false
integer x = 1925
integer y = 680
integer taborder = 80
end type

type pb_insertar from w_mant_directo`pb_insertar within w_cons_equipo
boolean visible = false
integer x = 1938
integer y = 504
integer taborder = 70
end type

type pb_salir from w_mant_directo`pb_salir within w_cons_equipo
integer x = 1870
integer y = 1184
integer taborder = 110
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_cons_equipo
boolean visible = false
integer x = 1925
integer y = 1040
integer taborder = 100
end type

type pb_grabar from w_mant_directo`pb_grabar within w_cons_equipo
boolean visible = false
integer x = 1925
integer y = 860
integer taborder = 90
end type

event pb_grabar::clicked;
//If iuo_usuario.Administra <> 1 Then
//	MessageBox('Atención...', 'No es Administrador no puede cambiar Estado de Solicitudes Solo Consultar', &
//					StopSign!, OK!)
//	Return -1
//End If

Call Super::clicked
end event

type dw_1 from w_mant_directo`dw_1 within w_cons_equipo
integer y = 396
integer width = 1733
integer height = 1132
integer taborder = 60
string dataobject = "dw_cons_equipo"
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
		This.Modify(Left(ls_old_sort, Len(ls_old_sort) - 2) + "_t.Color = 0")
	End If
	
	This.Modify(dwo.Name + ".Color = " + String(Rgb(0, 0, 255)))
	
	This.Sort()
End If

IF Row > 0 THEN
	il_fila = Row
	This.SelectRow(0,False)
	This.SetRow(il_fila)
	This.SelectRow(il_fila,True)
END IF

RETURN 0
end event

type st_2 from statictext within w_cons_equipo
integer x = 146
integer y = 236
integer width = 361
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Nro. Interno"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cons_equipo
integer x = 146
integer y = 152
integer width = 361
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Nro. Serie o"
boolean focusrectangle = false
end type

type em_numero from editmask within w_cons_equipo
integer x = 571
integer y = 168
integer width = 1179
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;Parent.PostEvent("ue_recuperadatos")


end event

