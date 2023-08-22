$PBExportHeader$w_maed_devolucionvales.srw
forward
global type w_maed_devolucionvales from w_mant_encab_deta
end type
type dw_3 from datawindow within w_maed_devolucionvales
end type
type st_1 from statictext within w_maed_devolucionvales
end type
type st_2 from statictext within w_maed_devolucionvales
end type
type dw_4 from datawindow within w_maed_devolucionvales
end type
end forward

global type w_maed_devolucionvales from w_mant_encab_deta
integer width = 4018
integer height = 2188
string title = "RECEPCIÓN DE VALES DESDE CASINO"
string menuname = ""
dw_3 dw_3
st_1 st_1
st_2 st_2
dw_4 dw_4
end type
global w_maed_devolucionvales w_maed_devolucionvales

type variables
uo_zona				iuo_zona
uo_areas				iuo_area
uo_clienprove		iuo_rut

DataWindowChild	idwc_area


end variables

forward prototypes
public function boolean buscacont ()
public subroutine marcatodos (integer ai_marca)
public function boolean existemovto ()
end prototypes

public function boolean buscacont ();Boolean			lb_respuesta=True
str_busqueda	lstr_busq

lstr_busq.argum[1]	=	'0'

OpenWithParm(w_busc_clienprove, lstr_busq)

lstr_busq				=	Message.PowerobjectParm

IF UpperBound(lstr_busq.argum) < 2 THEN
	lb_respuesta = False
ELSE
	dw_2.Object.clpr_rut[1]		=	lstr_busq.argum[1]
	dw_2.Object.clpr_nombre[1]	=	lstr_busq.argum[2]
	istr_mant.argumento[3]		=	lstr_busq.argum[1]
END IF

Return lb_respuesta
end function

public subroutine marcatodos (integer ai_marca);Integer	li_filas

FOR li_filas = 1 TO dw_1.RowCount()
	dw_1.Object.vact_ubicac[li_filas]	=	ai_marca
NEXT
end subroutine

public function boolean existemovto ();Long	ll_fila

ll_fila	= dw_4.Retrieve(Integer(istr_mant.argumento[1]), &
								 			istr_mant.argumento[3], &
								 	 Date(istr_mant.argumento[4]), &
								 Integer(istr_mant.argumento[2]), &
								 Integer(istr_mant.argumento[5]))
								 
IF ll_fila > 0 THEN
	IF ll_fila > 1 THEN
		Messagebox("Duplicidad de datos",  "Para los datos ingresados, existe mas de una secuencia, "+&
					  "favor seleccionar la entrega de vales que corresponda en la siguiente ventana")
		
	ELSE
		istr_mant.argumento[5]	=	String(dw_4.Object.evct_secuen[1])
	END IF
	
	Return TRUE
ELSE
	RETURN FALSE
END IF
end function

event open;x				=	0
y				=	0
im_menu		=	m_principal

This.Icon									=	Gstr_apl.Icono
This.ParentWindow().ToolBarVisible	=	True
im_menu.Item[1].Item[6].Enabled		=	True
im_menu.Item[7].Visible					=	True

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.Modify("datawindow.message.title='Error '+ is_titulo")
dw_1.Modify("DataWindow.Footer.Height = 110")

istr_mant.dw						=	dw_1
istr_mant.UsuarioSoloConsulta	=	OpcionSoloConsulta()

pb_nuevo.PostEvent(Clicked!)

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, &
							This.Title, "Acceso a Aplicación", 1)
							
iuo_zona			=	Create uo_zona
iuo_area			=	Create uo_areas				
iuo_rut			=	Create uo_clienprove	

dw_2.GetChild("caar_codigo", idwc_area)
idwc_area.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)

istr_mant.argumento[1]	=	''
istr_mant.argumento[2]	=	''
istr_mant.argumento[3]	=	''
istr_mant.argumento[4]	=	''
istr_mant.argumento[5]	=	'-1'

/* La asignación a las siguientes variables no se hereda, debe ser adicional en ventana descendiente */
buscar	= "Código:Ncodigo,Descripción:Sconcepto"
ordenar	= "Código:codigo,Descripción:concepto"
end event

on w_maed_devolucionvales.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.st_1=create st_1
this.st_2=create st_2
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_4
end on

on w_maed_devolucionvales.destroy
call super::destroy
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_4)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_2.Retrieve(Integer(istr_mant.argumento[1]), 	&
									 istr_mant.argumento[3], 				&
									 Date(istr_mant.argumento[4]), 		&
									 Integer(istr_mant.argumento[2]), 	&
									 Integer(istr_mant.argumento[5]))
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox(	"Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		DO

		ll_fila	= dw_1.Retrieve(Integer(istr_mant.argumento[1]), 	&
									 	 istr_mant.argumento[3], 				&
									 	 Date(istr_mant.argumento[4]), 		&
									 	 Integer(istr_mant.argumento[2]), 	&
									 	 Integer(istr_mant.argumento[5]))
			
			IF ll_fila = -1 THEN
				respuesta = MessageBox(	"Error en Base de Datos", "No es posible conectar la Base de Datos.", &
												Information!, RetryCancel!)
			ELSEIF ll_fila > 0 THEN
				
				dw_3.InsertRow(0)
				dw_3.SetRow(1)
				dw_3.SetFocus()
				
				pb_grabar.Enabled		= True
				pb_imprimir.Enabled	= True
				il_fila					= 1
			END IF
		LOOP WHILE respuesta = 1

		IF respuesta = 2 THEN Close(This)	
		ias_campo[1]			= ""
	ELSE
		ias_campo[1]			= ""
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event resize;call super::resize;Integer	maximo, li_posic_x, li_posic_y, li_visible = 0, &
			li_Ancho = 300, li_Alto = 245, li_Siguiente = 255

IF dw_2.width > il_AnchoDw_1 THEN
	maximo		=	dw_2.width
ELSE
	dw_1.width	=	This.WorkSpaceWidth() - 500
	maximo		=	dw_1.width
END IF

dw_2.x					= 37 + Round((maximo - dw_2.width) / 2, 0)
dw_2.y					= 44
dw_3.x					= 37 + Round((maximo - dw_3.width) / 2, 0)
dw_3.y					= 544

dw_1.x					= 37 + Round((maximo - dw_1.width) / 2, 0)
dw_1.y					= 10 + st_1.y + st_1.Height + st_2.Height
dw_1.height				= This.WorkSpaceHeight() - dw_1.y - 41

st_1.Width			=	dw_1.Width
st_2.Width			=	dw_1.Width
st_1.x					=	37 + Round((maximo - dw_1.width) / 2, 0)
st_2.x					=	37 + Round((maximo - dw_1.width) / 2, 0)


li_posic_x				= This.WorkSpaceWidth() - 370
li_posic_y				= 78

IF pb_buscar.Visible THEN
	pb_buscar.x				= li_posic_x
	pb_buscar.y				= li_posic_y
	pb_buscar.width		= li_Ancho
	pb_buscar.height		= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_nuevo.Visible THEN
	pb_nuevo.x				= li_posic_x
	pb_nuevo.y				= li_posic_y
	pb_nuevo.width		= li_Ancho
	pb_nuevo.height		= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF	pb_eliminar.Visible THEN
	pb_eliminar.x			= li_posic_x
	pb_eliminar.y			= li_posic_y
	pb_eliminar.width		= li_Ancho
	pb_eliminar.height		= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_grabar.Visible THEN
	pb_grabar.x				= li_posic_x
	pb_grabar.y				= li_posic_y
	pb_grabar.width		= li_Ancho
	pb_grabar.height		= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_imprimir.Visible THEN
	pb_imprimir.x			= li_posic_x
	pb_imprimir.y			= li_posic_y
	pb_imprimir.width		= li_Ancho 
	pb_imprimir.height	= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_salir.Visible THEN
	pb_salir.x				= li_posic_x
	pb_salir.y				= li_posic_y
	pb_salir.width			= li_Ancho
	pb_salir.height			= li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

li_posic_y += 200

pb_ins_det.x			= li_posic_x
pb_ins_det.y			= li_posic_y
pb_ins_det.width		= li_Ancho
pb_ins_det.height		= li_Alto
li_posic_y += li_Siguiente

pb_eli_det.x				= li_posic_x
pb_eli_det.y				= li_posic_y
pb_eli_det.width		= li_Ancho
pb_eli_det.height		= li_Alto
end event

event ue_seleccion;Integer			li_opcion
dwitemstatus 	stat
str_busqueda	lstr_busq

ib_ok	= True

IF dw_1.AcceptText() = -1 THEN li_opcion = -1
IF dw_2.AcceptText() = -1 THEN li_opcion = -1
IF dw_1.ModifiedCount() > 0 THEN 
	li_opcion = 1
END IF

CHOOSE CASE li_opcion
	CASE -1
		ib_ok = False
	CASE 0
		CHOOSE CASE MessageBox("Grabar registro(s)","Desea Grabar la información ?", Question!, YesNoCancel!)
			CASE 1
				Message.DoubleParm = 0
				This.triggerevent("ue_guardar")
				IF message.doubleparm = -1 THEN ib_ok = False
				RETURN
			CASE 3
				ib_ok	= False
				RETURN
		END CHOOSE
END CHOOSE

IF ib_ok = False THEN RETURN

OpenWithParm(w_busc_entregavalescontratista, lstr_busq)

lstr_busq			=	Message.PowerobjectParm
IF UpperBound(lstr_busq.argum) = 12 THEN
	dw_2.Object.zona_codigo[1]	=	Integer(lstr_busq.argum[01])
	dw_2.Object.clpr_rut[1]		=	String(lstr_busq.argum[02])
	dw_2.Object.evct_fechae[1]	=	Date(lstr_busq.argum[03])
	dw_2.Object.evct_secuen[1]	=	Integer(lstr_busq.argum[04])
	dw_2.Object.caar_codigo[1]	=	Integer(lstr_busq.argum[11])
	istr_mant.argumento[1]		=	lstr_busq.argum[01]
	istr_mant.argumento[3]		=	lstr_busq.argum[02]
	istr_mant.argumento[4]		=	lstr_busq.argum[03]
	istr_mant.argumento[2]		=	lstr_busq.argum[11]
	istr_mant.argumento[5]		=	lstr_busq.argum[04]
	
	This.TriggerEvent("ue_recuperadatos")
END IF
end event

event ue_antesguardar;call super::ue_antesguardar;dw_2.Object.evct_estado[1]	=	2
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_devolucionvales
integer x = 69
integer y = 1076
integer width = 3470
integer height = 956
string title = "Detalle de Vales Entregados"
string dataobject = "dw_mues_valescontratista_ubicacion"
end type

event dw_1::clicked;call super::clicked;This.SelectRow(0, False)
end event

event dw_1::doubleclicked;//
end event

event dw_1::sqlpreview;//
end event

event dw_1::getfocus;call super::getfocus;This.SelectRow(0, False)
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_devolucionvales
integer x = 256
integer y = 68
integer width = 3099
integer height = 392
string dataobject = "dw_encab_entregalotes"
end type

event dw_2::itemchanged;call super::itemchanged;String	ls_columna
Integer	li_null

ls_columna	=	dwo.name
SetNull(li_null)

CHOOSE CASE ls_columna
	CASE "zona_codigo"
		IF NOT iuo_zona.existe(Integer(data), True, Sqlca) THEN
			This.Object.zona_codigo[row]	=	li_null
			Return 1
		ELSE
			idwc_area.SetTransObject(Sqlca)
			idwc_area.Retrieve(Integer(data))
			istr_mant.argumento[1]			=	data
		END IF

	CASE "caar_codigo"
		IF NOT iuo_area.Existe(Integer(istr_mant.argumento[1]), Integer(data), True, Sqlca) THEN
			This.Object.caar_codigo[row]	=	li_null
			Return 1
		ELSE
			istr_mant.argumento[2]			=	data
		END IF

	CASE "clpr_rut"
		IF NOT iuo_rut.existe(data, True, Sqlca) THEN
			This.Object.clpr_rut[row]		=	String(li_null)
			Return 1
		ELSE
			istr_mant.argumento[3]			=	data
			This.Object.clpr_nombre[row]	=	iuo_rut.Nombre
		END IF

	CASE "evct_fechae"
		istr_mant.argumento[4]		=	data

END CHOOSE

IF ExisteMovto() THEN
	Parent.TriggerEvent("ue_recuperadatos")
END IF
end event

event dw_2::buttonclicked;call super::buttonclicked;String	ls_columna

ls_columna	=	dwo.name

CHOOSE CASE ls_columna
	CASE "b_persona"
		BuscaCont()
		
END CHOOSE
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_devolucionvales
integer x = 3694
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_devolucionvales
boolean visible = false
integer x = 69
integer y = 2324
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_devolucionvales
integer x = 3694
integer y = 452
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_devolucionvales
integer x = 3694
integer y = 632
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_devolucionvales
integer x = 3694
integer y = 812
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_devolucionvales
string tag = "Marcar Todos como recepcionados"
integer x = 3694
integer y = 1448
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
string powertiptext = "Marcar Todos como recepcionados"
end type

event pb_ins_det::clicked;MarcaTodos(1)
end event

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_devolucionvales
string tag = "Marcar Todos como Extraviados"
integer x = 3694
integer y = 1620
string picturename = "\Desarrollo 17\Imagenes\Botones\Cancelar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Cancelar-bn.png"
string powertiptext = "Marcar Todos como Extraviados"
end type

event pb_eli_det::clicked;MarcaTodos(9)
end event

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_devolucionvales
integer x = 3694
end type

type dw_3 from datawindow within w_maed_devolucionvales
integer x = 128
integer y = 564
integer width = 3351
integer height = 448
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_valeretorno"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String	ls_columna

ls_columna = dwo.name

CHOOSE CASE ls_columna
	CASE "estadosi", "t_1"
		This.Object.estadosi[row]	=	1
		This.Object.estadono[row]	=	0
		
	CASE "estadono", "t_2"
		This.Object.estadosi[row]	=	0
		This.Object.estadono[row]	=	1
		
END CHOOSE
end event

event itemchanged;Integer	li_filas, li_ubic
String	ls_vale
String	ls_columna

ls_columna	=	dwo.name

CHOOSE CASE ls_columna
	CASE "codigo_vale"
		ls_vale	=	Right(Data, Len(Data) - 3)
		IF left(Data, 3) = "CTT" THEN
			li_ubic	=	dw_1.find("vact_numero = " + ls_vale, 1, dw_1.RowCount())
			IF li_ubic > 0 THEN
				IF This.Object.estadosi[row]	=	1 THEN
					dw_1.Object.vact_ubicac[li_ubic]	=	1
				ELSE
					dw_1.Object.vact_ubicac[li_ubic]	=	9
				END IF
			ELSE
				MessageBox("Error", "El numero de vale ingresado no pertenece "+&
							  "al movimiento seleccionado.~r~nIngrese o seleccione otro.")
			END IF
		ELSE
			MessageBox("Error", "El codigo ingresado no corresponde a un vale de colación "+&
						  "de contratista.~r~nIngrese o seleccione otro.")
		END IF

		SetNull(ls_vale)
		This.Object.codigo_vale[row]	=	ls_vale
		Return 1

END CHOOSE
end event

event itemerror;Return 1
end event

type st_1 from statictext within w_maed_devolucionvales
integer x = 73
integer y = 16
integer width = 3470
integer height = 500
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

type st_2 from statictext within w_maed_devolucionvales
integer x = 69
integer y = 520
integer width = 3470
integer height = 540
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

type dw_4 from datawindow within w_maed_devolucionvales
boolean visible = false
integer x = 256
integer y = 68
integer width = 283
integer height = 192
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "dw_encab_entregalotes"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

