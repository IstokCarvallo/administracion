$PBExportHeader$w_maed_casino_pedidos.srw
$PBExportComments$Mantención de Pedidos
forward
global type w_maed_casino_pedidos from w_mant_encab_deta
end type
end forward

global type w_maed_casino_pedidos from w_mant_encab_deta
integer width = 2770
integer height = 2176
string title = "MANTENCION DE PEDIDOS"
string menuname = ""
event ue_validaregistro ( )
end type
global w_maed_casino_pedidos w_maed_casino_pedidos

type variables
uo_colaciones				iuo_Colacion
uo_zona						iuo_zonas
uo_tipocolacion				iuo_TipoColacion
uo_personacolacion		iuo_Personal, iuo_encargado
uo_Pedidos					iuo_Pedidos

DataWindowChild			idwc_Colacion, idwc_TipoColac

String						is_ultimacol, is_rut, is_rutcol, is_persona
end variables

forward prototypes
public function boolean duplicado (string as_columna, string as_valor)
public subroutine habilitaencab (boolean ib_habilita)
public subroutine habilitaingreso (string as_columna)
public function boolean cargausuario ()
end prototypes

event ue_validaregistro();Integer	li_Contador
String	ls_Mensaje, ls_Columna[]

dw_1.AcceptText()

IF IsNull(dw_1.Object.caco_codigo[il_Fila]) OR &
	dw_1.Object.caco_codigo[il_Fila] = 0 THEN
	li_Contador ++
	ls_Mensaje 					+=	"~nCódigo de Colación"
	ls_Columna[li_Contador]	= "caco_codigo"
END IF

IF IsNull(dw_1.Object.cape_codigo[il_Fila]) OR dw_1.Object.cape_codigo[il_Fila] = "" THEN
	li_Contador ++
	ls_Mensaje					+=	"~nPersona"
	ls_Columna[li_Contador]	=	"cape_codigo"
END IF

IF li_Contador > 0 THEN
	MessageBox("Error de Consistencia", "Falta el ingreso de :" + ls_Mensaje + &
					".", StopSign!, Ok!)
	dw_1.SetColumn(ls_Columna[1])
	dw_1.SetRow(il_Fila)
	dw_1.SetFocus()
	
	Message.DoubleParm	=	-1
END IF
end event

public function boolean duplicado (string as_columna, string as_valor);Long		ll_Fila
String	ls_Codigo

ls_Codigo	=	String(dw_1.Object.tico_codigo[il_Fila])

CHOOSE CASE as_Columna
	CASE "tico_codigo"
		ls_Codigo	=	as_Valor
		
END CHOOSE

ll_Fila	=	dw_1.Find("tico_codigo = " + ls_Codigo, &	
							1, dw_1.RowCount())

IF ll_Fila > 0 AND ll_Fila <> il_Fila THEN
	MessageBox("Error", "Registro ya fue ingresado anteriormente", &
					Information!, Ok!)
	RETURN True
ELSE
	RETURN False
END IF
end function

public subroutine habilitaencab (boolean ib_habilita);IF ib_Habilita THEN
	dw_2.Object.zona_codigo.Protect					=	0
	dw_2.Object.pcen_numero.Protect				= 	0
	dw_2.Object.zona_codigo.BackGround.Color	=	0
	dw_2.Object.pcen_numero.BackGround.Color	=	0
	dw_2.Object.zona_codigo.BackGround.Color	=	RGB(255, 255, 255)
	dw_2.Object.pcen_numero.BackGround.Color	=	RGB(255, 255, 255)
ELSE
	dw_2.Object.zona_codigo.Protect					=	1
	dw_2.Object.pcen_numero.Protect				= 	1
	dw_2.Object.zona_codigo.BackGround.Color	=	RGB(255,255,255)
	dw_2.Object.pcen_numero.BackGround.Color	=	RGB(255,255,255)
	dw_2.Object.zona_codigo.BackGround.Color	=	553648127
	dw_2.Object.pcen_numero.BackGround.Color	=	553648127
END IF

RETURN
end subroutine

public subroutine habilitaingreso (string as_columna);Boolean	lb_Estado = True

IF as_Columna <> "tico_codigo" AND &
	(dw_2.Object.tico_codigo[il_Fila] = 0 OR IsNull(dw_2.Object.tico_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF

IF as_Columna <> "zona_codigo" AND &
	(dw_2.Object.zona_codigo[il_Fila] = 0 OR IsNull(dw_2.Object.zona_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF

IF as_Columna <> "cape_codigo" AND &
	(dw_2.Object.cape_codigo[il_Fila] = '' OR IsNull(dw_2.Object.cape_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF

pb_ins_det.Enabled = lb_Estado
end subroutine

public function boolean cargausuario ();String		ls_nombre
Integer	li_pedidos

SELECT cape_codigo, convert(Varchar(100), cape_nombre + ' ' + cape_apepat + ' ' + cape_apemat) as cape_nomcom, cape_pedcas
  INTO :is_rut, :ls_nombre, :li_pedidos
  FROM dbo.Casino_PersonaColacion
 where Upper(cape_usuari) = Upper(:gstr_us.Nombre)
 Using Sqlca;

IF sqlca.SqlCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de Tabla Personal Colación")
	RETURN False
ELSEIF li_pedidos <> 1 THEN
	MessageBox("Atención", "Usuario " + gstr_us.Nombre + ", no tiene permido solicitar~r" + &
				  "colaciones a casino.~r~rPor favor, ingrese con el usuario indicado.")
	RETURN False
ELSE
	dw_2.Object.cape_codigo[1]	=	is_rut
	dw_2.Object.nombre[1]		=	ls_nombre
END IF

RETURN True
end function

on w_maed_casino_pedidos.create
call super::create
end on

on w_maed_casino_pedidos.destroy
call super::destroy
end on

event open;iuo_Colacion		=	Create uo_colaciones
iuo_Zonas			= 	Create uo_zona
iuo_TipoColacion	=	Create uo_tipocolacion
iuo_Personal		=	Create uo_personacolacion
iuo_encargado		=	Create uo_personacolacion
iuo_Pedidos			=	Create uo_pedidos

dw_1.getChild('caco_codigo', idwc_Colacion)
idwc_Colacion.SetTransObject(Sqlca)

dw_2.getChild('tico_codigo', idwc_TipoColac)
idwc_TipoColac.SetTransObject(Sqlca)

idwc_Colacion.InsertRow(0)
idwc_TipoColac.InsertRow(0)

Call Super::Open

buscar			=	""
ordenar			=	""
is_Ultimacol	=	"caco_codigo"

IF NOT CargaUsuario() THEN
	CLOSE(THIS)
	
END IF
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_FilasDet, ll_FilasEnc

is_rut		=	''
is_persona	=	''

ll_FilasEnc		=	dw_2.Retrieve(dw_2.Object.zona_codigo[1], dw_2.Object.pcen_numero[1])

IF ll_FilasEnc = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Encabezado Inventario de Pallet")

	RETURN
ELSEIF ll_FilasEnc > 0 THEN
		istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
ELSE
	RETURN
END IF
		
ll_FilasDet	=	dw_1.Retrieve(dw_2.Object.zona_codigo[1], dw_2.Object.pcen_numero[1])
	
IF ll_FilasDet = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Detalle Inventario de Pallet")

	RETURN
ELSE
	pb_Eliminar.Enabled  =	Not istr_mant.Solo_Consulta
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
	pb_ins_det.Enabled	=	Not istr_mant.Solo_Consulta
	pb_eli_det.Enabled	=	Not istr_mant.Solo_Consulta
		
	IF ll_FilasDet > 0 THEN
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
		IF idwc_TipoColac.Retrieve(dw_2.Object.zona_codigo[1]) < 1 THEN
			idwc_TipoColac.InsertRow(0)
		END IF
			
		IF idwc_Colacion.Retrieve(dw_2.Object.zona_codigo[1], dw_2.Object.tico_codigo[1]) < 1 THEN
			idwc_Colacion.InsertRow(0)
		END IF
		
		HabilitaEncab(False)
	END IF

	pb_ins_det.SetFocus()
END IF
end event

event ue_nuevo_detalle;IF il_Fila > 0 THEN
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled		= True
END IF

il_Fila	=	dw_1.InsertRow(0)

dw_1.ScrollToRow(il_Fila)
dw_1.SetRow(il_Fila)
dw_1.SetFocus()
dw_1.SetColumn("cape_codigo")

dw_1.SelectRow(0, False)
end event

event ue_borra_detalle;IF dw_1.RowCount() < 1 THEN RETURN

IF dw_1.DeleteRow(0) <> 1 THEN
	MessageBox(This.Title, "No se puede borrar actual registro.")
END IF

IF dw_1.RowCount() = 0 THEN
	pb_eli_det.Enabled	=	False
ELSE
	il_Fila	=	dw_1.GetRow()
END IF
end event

event ue_antesguardar;call super::ue_antesguardar;Long		ll_Fila, ll_Numero

IF dw_2.GetItemStatus(1, 0, Primary!) = NewModified! THEN
	dw_2.Object.pcen_numero[1]	=	iuo_Pedidos.UltimoPedido(dw_2.Object.zona_codigo[1], sqlca) + 1
	
END IF

FOR ll_Fila = 1 TO dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_Fila, 0, Primary!) = NewModified! THEN
		dw_1.Object.zona_codigo[ll_Fila]	=	dw_2.Object.zona_codigo[1]
		dw_1.Object.pcen_numero[ll_Fila]	=	dw_2.Object.pcen_numero[1]
		dw_1.Object.tico_codigo[ll_Fila]	=	dw_2.Object.tico_codigo[1]
	END IF
NEXT
end event

event ue_nuevo;call super::ue_nuevo;dw_2.Reset()
dw_2.InsertRow(0)
HabilitaEncab(True)

is_rut		=	''
is_persona	=	''

IF NOT CargaUsuario() THEN
	CLOSE(THIS)
	
END IF
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila

istr_info.titulo	=	"INFORME DE PEDIDOS"
istr_info.copias	=	1

OpenWithParm(vinf,istr_info)
vinf.dw_1.DataObject	=	"dw_info_pedidos"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(dw_2.Object.zona_codigo[1], dw_2.Object.pcen_numero[1])

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
END IF

SetPointer(Arrow!)
end event

event ue_seleccion;call super::ue_seleccion;IF iuo_Pedidos.Busqueda(sqlca, iuo_Zonas.Codigo) THEN
	dw_2.Object.zona_codigo[1]	=	iuo_Pedidos.Zona
	dw_2.Object.pcen_numero[1]	=	iuo_Pedidos.Numero
	is_Rut							=	iuo_Pedidos.Persona
	This.TriggerEvent("ue_recuperadatos")
ELSE
	pb_buscar.SetFocus()
END IF
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_casino_pedidos
event ue_nomover pbm_syscommand
integer x = 50
integer y = 904
integer width = 2272
integer height = 1120
integer taborder = 80
string title = "Detalle de Pedido"
string dataobject = "dw_mant_mues_pedidodeta"
end type

event dw_1::ue_nomover;uint wParam, lParam

wParam = Message.WordParm

Choose Case wParam
	Case 61456, 61458
	     Message.Processed = True
	     Message.ReturnValue = 0

End Choose
end event

event dw_1::dwnkey;call super::dwnkey;This.SetRedraw(False)

CHOOSE CASE key
	CASE KeyRightArrow!, KeyLeftArrow!
		This.SetRedraw(True)
		RETURN -1
		
	CASE KeyDownArrow!, KeyUpArrow!
		Message.DoubleParm = 0
		
		Parent.TriggerEvent("ue_validaregistro")
		
		IF Message.DoubleParm = -1 THEN
			This.SetRedraw(True)
			RETURN -1
		ELSEIF Key = KeyDownArrow! AND il_fila = dw_1.RowCount() THEN
			Parent.TriggerEvent("ue_nuevo_detalle")
		END IF
		
	CASE KeyTab!
		IF is_ultimacol = This.GetColumnName() AND il_fila = dw_1.RowCount() THEN
			Message.DoubleParm = 0
			
			Parent.TriggerEvent("ue_validaregistro")
			
			IF Message.DoubleParm = -1 THEN
				This.SetRedraw(True)
				RETURN -1
			END IF
		END IF

END CHOOSE

This.SetRedraw(True)
This.SetColumn(1)
This.SetFocus()
This.SelectRow(0, False)

RETURN 0
end event

event dw_1::sqlpreview;//
end event

event dw_1::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)
ls_Columna	=	dwo.Name

Choose Case ls_Columna
	Case 'cape_codigo'
		is_persona = F_verrut(data, True)
		
		If Not iuo_Personal.Existe(is_persona, True, Sqlca) Then
			This.SetItem(Row, ls_Columna, ls_Nula)
			Return 1
		Else
			If iuo_Personal.PedidoCasino = 0 Then
				MessageBox('Alerta', 'Esta persona no puede solicitar colaciones.', Information!, OK!)
				This.SetItem(Row, ls_Columna, ls_Nula)
				Return 1
			End If
		End If
		
	Case 'caco_codigo'
		If Not iuo_Colacion.Existe(dw_2.Object.zona_codigo[1], dw_2.Object.tico_codigo[1], Integer(data), True, Sqlca) Then
			This.SetItem(Row, ls_Columna, ls_Nula)
			Return 1
		End If		
End Choose
end event

event dw_1::losefocus;call super::losefocus;IF is_persona <> '' THEN
	is_persona		=	String(Double(Mid(is_persona, 1, Len(is_persona) - 1)), "000000000") + &
							Mid(is_persona, Len(is_persona))
	
	This.SetItem(il_fila, "cape_codigo", is_persona)
	
	AcceptText()
	This.SelectRow(0, False)
END IF
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;String	ls_Columna

ls_Columna = dwo.Name

IF is_persona <> "" THEN
	IF ls_Columna = "cape_codigo" THEN
		This.Object.cape_codigo.EditMask.Mask	=	"XXXXXXXXXX"
		
		IF is_persona <> "" THEN
			This.SetItem(il_fila, "cape_codigo", String(Double(Mid(is_persona, 1, 9)), "#########") + Mid(is_persona, 10))
		END IF
	ELSE
		This.Object.cape_codigo.EditMask.Mask	=	"###.###.###-!"
		This.SetItem(il_fila, "cape_codigo", is_persona)
	END IF
END IF
end event

event dw_1::buttonclicked;call super::buttonclicked;String	ls_Boton

ls_Boton	= dwo.Name

Choose Case ls_Boton
	Case 'b_persona'
		If iuo_Personal.Busqueda(sqlca) Then
			is_persona 							=	F_verrut(iuo_Personal.Codigo, True)
			This.Object.cape_codigo[Row]	=	iuo_Personal.Codigo
			This.Object.nombre[Row]			=	iuo_Personal.Nombres + ' ' + iuo_Personal.ApellidoPat
		Else
			pb_buscar.SetFocus()
		End If
End Choose
end event

event dw_1::rowfocuschanged;ib_datos_ok = True

IF rowcount() < 1 OR getrow() = 0 OR ib_borrar THEN
	ib_datos_ok = False
ELSE
	il_fila = getrow()
	This.SelectRow(0,False)
END IF

RETURN 0
end event

event dw_1::getfocus;//
end event

event dw_1::clicked;call super::clicked;SelectRow(0, False)
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_casino_pedidos
integer x = 402
integer y = 20
integer width = 1490
integer height = 816
string dataobject = "dw_mant_pedido"
end type

event dw_2::itemchanged;call super::itemchanged;String	ls_Columna, ls_Nula

SetNull(ls_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE 'zona_codigo'
		IF Not iuo_Zonas.Existe(Integer(Data),  True, sqlca) THEN
			F_RestauraValor(Row, ls_Columna, dw_2)
			RETURN 1
		ELSE
			IF idwc_TipoColac.Retrieve(iuo_Zonas.Codigo) < 1 THEN
				idwc_TipoColac.InsertRow(0)
			END IF
		END IF
		
	CASE "tico_codigo"
		IF iuo_TipoColacion.Existe(This.Object.zona_codigo[row], Integer(Data), True, sqlca) THEN
			dw_1.GetChild('caco_codigo', idwc_colacion)
			idwc_Colacion.SetTransObject(Sqlca)
			
			IF idwc_Colacion.Retrieve(iuo_Zonas.Codigo, iuo_TipoColacion.Codigo) < 1 THEN
				idwc_Colacion.InsertRow(0)
			END IF
			
			IF iuo_Pedidos.Existe(Long(Data), This.Object.pcen_numero[1], False, Sqlca) THEN
				This.AcceptText()
				Parent.TriggerEvent('ue_recuperadatos')
			END IF
		ELSE
			F_RestauraValor(Row, ls_Columna, dw_2)
			RETURN 1
		END IF

	CASE 'pcen_numero'
		IF iuo_Pedidos.Existe(iuo_Zonas.Codigo, Long(Data), False, Sqlca) THEN
			This.AcceptText()
			Parent.TriggerEvent('ue_recuperadatos')
		END IF

	CASE 'cape_codigo'
		is_rut = F_verrut(data, True)
		
		IF Not iuo_encargado.Existe(is_rut, True, Sqlca) THEN
			F_RestauraValor(Row, ls_Columna, dw_2)
			RETURN 1
		ELSE
			IF iuo_encargado.PedidoCasino = 0 THEN
				MessageBox('Alerta', 'Esta persona no puede solicitar colaciones.', Information!, OK!)
				F_RestauraValor(Row, ls_Columna, dw_2)
				RETURN 1
			Else
				This.Object.nombre[Row]	=	iuo_encargado.Nombres + ' ' + iuo_encargado.ApellidoPat
			END IF
		END IF
END CHOOSE

HabilitaIngreso(ls_Columna)
end event

event dw_2::itemfocuschanged;call super::itemfocuschanged;String	ls_Columna

ls_Columna = dwo.Name

IF is_rut <> "" THEN
	IF ls_Columna = "cape_codigo" THEN
		This.Object.cape_codigo.EditMask.Mask	=	"XXXXXXXXXX"
		
		IF is_rut <> "" THEN
			This.SetItem(il_fila, "cape_codigo", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		END IF
	ELSE
		This.Object.cape_codigo.EditMask.Mask	=	"###.###.###-!"
		This.SetItem(il_fila, "cape_codigo", is_rut)
	END IF
END IF
end event

event dw_2::losefocus;call super::losefocus;IF is_rut <> '' THEN
	is_rut		=	String(Double(Mid(is_rut, 1, Len(is_rut) - 1)), "000000000") + &
						Mid(is_rut, Len(is_rut))
	
	This.SetItem(il_fila, "cape_codigo", is_rut)
	
	AcceptText()
END IF
end event

event dw_2::buttonclicked;call super::buttonclicked;String	ls_Boton

ls_Boton	= dwo.Name

Choose Case ls_Boton
	Case 'b_persona'
		If iuo_encargado.Busqueda(sqlca) Then
			is_rut 								=	F_verrut(iuo_encargado.Codigo, True)
			This.Object.cape_codigo[Row]	=	iuo_encargado.Codigo
			This.Object.nombre[Row]			=	iuo_encargado.Nombres + ' ' + iuo_Personal.ApellidoPat
		Else
			pb_buscar.SetFocus()
		End If
End Choose
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_casino_pedidos
integer x = 2427
integer y = 340
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_casino_pedidos
integer x = 2427
integer y = 520
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_casino_pedidos
integer x = 2427
integer y = 704
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_casino_pedidos
integer x = 2427
integer y = 880
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_casino_pedidos
integer x = 2427
integer y = 1060
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_casino_pedidos
integer x = 2427
integer y = 1344
integer taborder = 90
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_casino_pedidos
integer x = 2427
integer y = 1516
integer taborder = 100
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_casino_pedidos
integer x = 2427
integer y = 160
end type

