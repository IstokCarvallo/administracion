$PBExportHeader$w_mant_pedidos_cambiaestado.srw
forward
global type w_mant_pedidos_cambiaestado from w_mant_directo
end type
type st_1 from statictext within w_mant_pedidos_cambiaestado
end type
type st_2 from statictext within w_mant_pedidos_cambiaestado
end type
type st_3 from statictext within w_mant_pedidos_cambiaestado
end type
type em_fini from editmask within w_mant_pedidos_cambiaestado
end type
type em_fter from editmask within w_mant_pedidos_cambiaestado
end type
type st_4 from statictext within w_mant_pedidos_cambiaestado
end type
type em_rut from editmask within w_mant_pedidos_cambiaestado
end type
type cb_pers from commandbutton within w_mant_pedidos_cambiaestado
end type
type sle_nombre from singlelineedit within w_mant_pedidos_cambiaestado
end type
type ddlb_estado from dropdownlistbox within w_mant_pedidos_cambiaestado
end type
type st_5 from statictext within w_mant_pedidos_cambiaestado
end type
type st_6 from statictext within w_mant_pedidos_cambiaestado
end type
type uo_selzona from uo_seleccion_zonas within w_mant_pedidos_cambiaestado
end type
type cb_2 from commandbutton within w_mant_pedidos_cambiaestado
end type
type cb_3 from commandbutton within w_mant_pedidos_cambiaestado
end type
type cb_4 from commandbutton within w_mant_pedidos_cambiaestado
end type
type cb_5 from commandbutton within w_mant_pedidos_cambiaestado
end type
type gb_4 from groupbox within w_mant_pedidos_cambiaestado
end type
type st_7 from statictext within w_mant_pedidos_cambiaestado
end type
type cbx_pers from checkbox within w_mant_pedidos_cambiaestado
end type
end forward

global type w_mant_pedidos_cambiaestado from w_mant_directo
integer width = 4846
integer height = 2088
st_1 st_1
st_2 st_2
st_3 st_3
em_fini em_fini
em_fter em_fter
st_4 st_4
em_rut em_rut
cb_pers cb_pers
sle_nombre sle_nombre
ddlb_estado ddlb_estado
st_5 st_5
st_6 st_6
uo_selzona uo_selzona
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
gb_4 gb_4
st_7 st_7
cbx_pers cbx_pers
end type
global w_mant_pedidos_cambiaestado w_mant_pedidos_cambiaestado

type variables
uo_personacolacion	iuo_persona

String					is_rut
Integer					ii_index

end variables

forward prototypes
public subroutine buscapersona ()
public subroutine actualizaestado (integer ai_estado)
public subroutine habilitaencab (boolean lb_habilita)
end prototypes

public subroutine buscapersona ();Str_Busqueda	lstr_Busq

istr_mant.Argumento[1]	= String(uo_selzona.Codigo)

OpenWithParm(w_busc_personacolacion_porzonaarea, istr_mant)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.Argum) > 1 Then
	If lstr_Busq.argum[1] <> "" Then
		If Not iuo_persona.existe(lstr_Busq.argum[1], True, SQLCa) Then Return	
		em_rut.Text			=	lstr_Busq.argum[1]
		sle_nombre.Text	=	lstr_Busq.argum[4] + ' ' + lstr_Busq.argum[2] + ' ' + lstr_Busq.argum[3]
	
	End If
End If
end subroutine

public subroutine actualizaestado (integer ai_estado);Integer	li_fila

FOR li_fila = 1 TO dw_1.RowCount()
	IF dw_1.IsSelected(li_fila) THEN
		dw_1.Object.pcen_estado[li_fila]	=	ai_estado
		
	END IF
NEXT

pb_grabar.TriggerEvent(Clicked!)
TriggerEvent("ue_recuperadatos")
end subroutine

public subroutine habilitaencab (boolean lb_habilita);uo_selzona.Enabled	=	lb_habilita
em_fini.Enabled 		= 	lb_habilita
em_fter.Enabled 		= 	lb_habilita
cbx_pers.Enabled		=	lb_habilita
ddlb_estado.Enabled	=	lb_habilita
end subroutine

on w_mant_pedidos_cambiaestado.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.em_fini=create em_fini
this.em_fter=create em_fter
this.st_4=create st_4
this.em_rut=create em_rut
this.cb_pers=create cb_pers
this.sle_nombre=create sle_nombre
this.ddlb_estado=create ddlb_estado
this.st_5=create st_5
this.st_6=create st_6
this.uo_selzona=create uo_selzona
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.gb_4=create gb_4
this.st_7=create st_7
this.cbx_pers=create cbx_pers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_fini
this.Control[iCurrent+5]=this.em_fter
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_rut
this.Control[iCurrent+8]=this.cb_pers
this.Control[iCurrent+9]=this.sle_nombre
this.Control[iCurrent+10]=this.ddlb_estado
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.uo_selzona
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.cb_3
this.Control[iCurrent+16]=this.cb_4
this.Control[iCurrent+17]=this.cb_5
this.Control[iCurrent+18]=this.gb_4
this.Control[iCurrent+19]=this.st_7
this.Control[iCurrent+20]=this.cbx_pers
end on

on w_mant_pedidos_cambiaestado.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_fini)
destroy(this.em_fter)
destroy(this.st_4)
destroy(this.em_rut)
destroy(this.cb_pers)
destroy(this.sle_nombre)
destroy(this.ddlb_estado)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.uo_selzona)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.gb_4)
destroy(this.st_7)
destroy(this.cbx_pers)
end on

event open;Boolean 	lb_cerrar
x												= 	0
y												= 	0
im_menu										= 	m_principal
This.ParentWindow().ToolBarVisible	=	True
im_menu.Item[1].Item[6].Enabled		=	True
im_menu.Item[7].Visible					=	False
This.Icon									=	Gstr_apl.Icono
istr_mant.UsuarioSoloConsulta			=	OpcionSoloConsulta()
istr_mant.Solo_Consulta					=	istr_mant.UsuarioSoloConsulta

dw_1.SetTransObject(sqlca)
dw_1.Modify("datawindow.message.title='Error '+ is_titulo")

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, &
							This.Title, "Acceso a Aplicación", 1)
								
buscar			= "Número:Npcen_numero"
ordenar			= "Número:pcen_numero,Personal:cape_codigo,Fecha:pcen_fechap,Hora:pcen_horape"

IF IsNull(uo_SelZona.Codigo) THEN lb_Cerrar	=	True

IF lb_cerrar THEN 
	Close(This)
	
ELSE
	uo_SelZona.Seleccion(False, False)
	em_fini.text	=	String(RelativeDate(Today(), -1), 'dd/mm/yyyy')
	em_fter.text	=	String(Today(), 'dd/mm/yyyy')
	
	iuo_persona		=	Create uo_personacolacion
	
	ddlb_estado.SelectItem(1)
	ii_index			=	1	
	
END IF
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_Filas
Date		ld_Fini, ld_fter
Integer	li_zona, li_estado
String	ls_persona
w_main.SetMicroHelp("Recuperando Datos...")
SetPointer(HourGlass!)
PostEvent("ue_listo")

pb_imprimir.Enabled	=	False
pb_grabar.Enabled		=	False

ld_Fini					=	Date(em_fini.Text)
ld_Fter					=	Date(em_fter.Text)
li_zona					=	uo_selzona.Codigo

IF cbx_pers.Checked THEN
	ls_persona	=	'-1'
ELSE
	ls_persona	=	em_rut.Text
END IF

CHOOSE CASE ii_index
	CASE 1
		li_estado 	= -1
		
	CASE ELSE
		li_estado	=	ii_index - 1
		
END CHOOSE

ll_Filas	=	dw_1.Retrieve(li_Zona, ls_persona, ld_fini, ld_fter, li_estado)

IF ll_Filas = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla")

	dw_1.SetRedraw(True)

	RETURN
ELSE
	istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
	pb_Grabar.Enabled			=	Not istr_mant.Solo_Consulta
		
	IF ll_Filas > 0 THEN
		pb_imprimir.Enabled	=	True
		pb_grabar.Enabled		=	True
		HabilitaEncab(False)
	END IF
END IF
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info
Date		ld_Fini, ld_fter
Integer	li_zona, li_estado
String	ls_persona

lstr_info.titulo	= "INFORME DE SOLICITUDES DE COLACIONES"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)

vinf.dw_1.DataObject = "dw_info_pedidos_cambiaestado"

vinf.dw_1.SetTransObject(sqlca)

ld_Fini					=	Date(em_fini.Text)
ld_Fter					=	Date(em_fter.Text)
li_zona					=	uo_selzona.Codigo

IF cbx_pers.Checked THEN
	ls_persona	=	'-1'
ELSE
	ls_persona	=	em_rut.Text
END IF

CHOOSE CASE ii_index
	CASE 1
		li_estado 	= -1
		
	CASE ELSE
		li_estado	=	ii_index - 1
		
END CHOOSE

fila = vinf.dw_1.Retrieve(li_Zona, ls_persona, ld_fini, ld_fter, li_estado)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", &
					StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')

	vinf.Visible	= True
	vinf.Enabled	= True
END IF

SetPointer(Arrow!)
end event

event resize;call super::resize;dw_1.x		=	st_7.x + st_7.Width
dw_1.y		=	st_7.y
dw_1.width	=	st_1.Width - st_7.Width
dw_1.Height	=	st_7.Height

end event

type st_encabe from w_mant_directo`st_encabe within w_mant_pedidos_cambiaestado
boolean visible = false
integer x = 4329
integer y = 60
integer width = 128
integer height = 100
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_pedidos_cambiaestado
integer x = 4425
integer y = 656
end type

event pb_nuevo::clicked;call super::clicked;HabilitaEncab(True)
end event

type pb_lectura from w_mant_directo`pb_lectura within w_mant_pedidos_cambiaestado
integer x = 4425
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_pedidos_cambiaestado
boolean visible = false
integer x = 4425
integer y = 1016
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_pedidos_cambiaestado
boolean visible = false
integer x = 4425
integer y = 836
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_pedidos_cambiaestado
integer x = 4425
integer y = 1756
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_pedidos_cambiaestado
integer x = 4425
integer y = 1016
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_pedidos_cambiaestado
integer x = 4425
integer y = 836
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_pedidos_cambiaestado
integer x = 553
integer y = 316
integer width = 3703
integer height = 1636
boolean titlebar = true
string title = "Solicitudes de Colaciones"
string dataobject = "dw_mues_pedidos_cambiaestado"
end type

event dw_1::clicked;This.SelectRow(Row, Not This.IsSelected(row))
end event

type st_1 from statictext within w_mant_pedidos_cambiaestado
integer x = 41
integer y = 24
integer width = 4206
integer height = 296
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16711680
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mant_pedidos_cambiaestado
integer x = 933
integer y = 84
integer width = 215
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Zona"
boolean focusrectangle = false
end type

type st_3 from statictext within w_mant_pedidos_cambiaestado
integer x = 3040
integer y = 84
integer width = 407
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Fecha Termino"
boolean focusrectangle = false
end type

type em_fini from editmask within w_mant_pedidos_cambiaestado
integer x = 2510
integer y = 76
integer width = 416
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_fter from editmask within w_mant_pedidos_cambiaestado
integer x = 3433
integer y = 76
integer width = 425
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_4 from statictext within w_mant_pedidos_cambiaestado
integer x = 933
integer y = 200
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Personal"
boolean focusrectangle = false
end type

type em_rut from editmask within w_mant_pedidos_cambiaestado
integer x = 1257
integer y = 188
integer width = 407
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
boolean enabled = false
string text = "0000000000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###.###.###-X"
end type

event modified;is_rut = F_verrut(This.Text, True)

If is_rut = ""  Then
	This.Text			=	'0000000000'
	sle_nombre.Text	=	''
	This.SetFocus()
Else
	If Not iuo_persona.existe(is_rut, True, sqlca) Then
		This.Text			=	'0000000000'
		sle_nombre.Text	=	''
		This.SetFocus()
	Else
		sle_nombre.Text	=	iuo_persona.Nombres + ' ' + iuo_persona.ApellidoPat + ' ' + iuo_persona.ApellidoMat
		
	End If
End If
end event

type cb_pers from commandbutton within w_mant_pedidos_cambiaestado
integer x = 1669
integer y = 188
integer width = 105
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "..."
end type

event clicked;buscapersona()
end event

type sle_nombre from singlelineedit within w_mant_pedidos_cambiaestado
integer x = 1778
integer y = 188
integer width = 1147
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
boolean enabled = false
string text = "Todos"
borderstyle borderstyle = stylelowered!
end type

type ddlb_estado from dropdownlistbox within w_mant_pedidos_cambiaestado
integer x = 3433
integer y = 188
integer width = 425
integer height = 416
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean sorted = false
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"Todos","Solicitado","Cursado","Entregado","Anulado"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_index	=	Index
end event

type st_5 from statictext within w_mant_pedidos_cambiaestado
integer x = 3040
integer y = 196
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Estado"
boolean focusrectangle = false
end type

type st_6 from statictext within w_mant_pedidos_cambiaestado
integer x = 2185
integer y = 84
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Fecha Inicio"
boolean focusrectangle = false
end type

type uo_selzona from uo_seleccion_zonas within w_mant_pedidos_cambiaestado
integer x = 1248
integer y = 72
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

type cb_2 from commandbutton within w_mant_pedidos_cambiaestado
integer x = 101
integer y = 712
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Solicitado"
end type

event clicked;ActualizaEstado(1)
end event

type cb_3 from commandbutton within w_mant_pedidos_cambiaestado
integer x = 101
integer y = 844
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cursado"
end type

event clicked;ActualizaEstado(2)
end event

type cb_4 from commandbutton within w_mant_pedidos_cambiaestado
integer x = 101
integer y = 976
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Entregado"
end type

event clicked;ActualizaEstado(3)
end event

type cb_5 from commandbutton within w_mant_pedidos_cambiaestado
integer x = 101
integer y = 1108
integer width = 402
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Anulado"
end type

event clicked;ActualizaEstado(4)
end event

type gb_4 from groupbox within w_mant_pedidos_cambiaestado
integer x = 78
integer y = 616
integer width = 453
integer height = 652
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Act. Estado"
end type

type st_7 from statictext within w_mant_pedidos_cambiaestado
integer x = 41
integer y = 320
integer width = 507
integer height = 1636
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16711680
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cbx_pers from checkbox within w_mant_pedidos_cambiaestado
integer x = 2930
integer y = 188
integer width = 78
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
boolean checked = true
end type

event clicked;em_rut.Enabled		=	Not This.Checked
cb_pers.Enabled	=	Not This.Checked
em_rut.Text	=	"0000000000"

IF em_rut.Enabled THEN
	sle_nombre.Text	=	""
ELSE
	sle_nombre.Text	=	"Todos"
	
END IF
	
end event

