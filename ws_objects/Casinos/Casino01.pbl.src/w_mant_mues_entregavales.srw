$PBExportHeader$w_mant_mues_entregavales.srw
$PBExportComments$Mantención de Registro Precios de Venta.
forward
global type w_mant_mues_entregavales from w_mant_directo
end type
type st_1 from statictext within w_mant_mues_entregavales
end type
type st_2 from statictext within w_mant_mues_entregavales
end type
type st_3 from statictext within w_mant_mues_entregavales
end type
type uo_selproveedor from uo_seleccion_clienprove within w_mant_mues_entregavales
end type
type uo_selzona from uo_seleccion_zonas within w_mant_mues_entregavales
end type
type em_fecha from editmask within w_mant_mues_entregavales
end type
end forward

global type w_mant_mues_entregavales from w_mant_directo
integer width = 4009
integer height = 1948
string title = "ENTREGA VALES CONTRATISTA"
event ue_validaborrar ( )
st_1 st_1
st_2 st_2
st_3 st_3
uo_selproveedor uo_selproveedor
uo_selzona uo_selzona
em_fecha em_fecha
end type
global w_mant_mues_entregavales w_mant_mues_entregavales

type variables
integer    			ii_tipo, ii_especie
String     			is_rut, is_codigo

uo_movtocasino	iuo_movto
uo_casino_areas	iuo_area

DataWindowChild	idwc_area, idwc_tipocolacion
uo_tipocolacion		iuo_tipocolacion
end variables

forward prototypes
public function boolean duplicado (string codigo) 
public function boolean noexisteclie (string as_valor)
public subroutine existerut ()
public subroutine buscacliente ()
public subroutine buscaentidad ()
public function boolean noexisteentidad (string as_entidad)
end prototypes

event ue_validaborrar();Integer				li_retorno = 0, li_zona, li_area, li_valesusados
Long					ll_valeini, ll_valeter
String				ls_contratista
Date					ld_fecval
Time					lt_valhorini, lt_valhorter

li_zona			=	dw_1.Object.zona_codigo[dw_1.GetRow()]
li_area			=	dw_1.Object.caar_codigo[dw_1.GetRow()]
lt_valhorini	=	dw_1.Object.evct_horaiv[dw_1.GetRow()] 
lt_valhorter	=	dw_1.Object.evct_horatv[dw_1.GetRow()]
ll_valeini		=	dw_1.Object.evct_nroini[dw_1.GetRow()]
ll_valeter		=	dw_1.Object.evct_nroter[dw_1.GetRow()]
ld_fecval		=	dw_1.Object.evct_fechav[dw_1.GetRow()]
ls_contratista	=	dw_1.Object.clpr_rut[dw_1.GetRow()]

SELECT count(*) into :li_valesusados
  FROM dbo.Casino_MovtoColaciones
 where zona_codigo = :li_zona
   and caar_codigo = :li_area
   and camv_fechac = :ld_fecval
   and camv_hormvt between :lt_valhorini and :lt_valhorter
   and clpr_rut = :ls_contratista
   and camv_nroval between :ll_valeini and :ll_valeter;
	
IF sqlca.sqlcode = -1 THEN
	F_ErrorBaseDatos(sqlca,"No se pudo leer la tabla Casino_MovtoColaciones")
	li_retorno	=	-1
	
ELSEIF li_valesusados <> 0 THEN
	Messagebox("Atención","El Rango de vales entregados que intenta eliminar ya ha sido utilizado.")
	li_retorno	=	-1
	
END IF

Message.DoubleParm = li_retorno
end event

public function boolean duplicado (string codigo);Long		ll_fila
	
	ll_fila	= dw_1.Find("mqub_codigo = " + codigo , 1, dw_1.RowCount())
	
	
	IF ll_fila > 0 and ll_fila <> il_fila THEN
		MessageBox("Error","Código de Ubicación, Ya Fue ingresado anteriormente",Information!, Ok!)
		RETURN True
	ELSE
		RETURN False
	END IF

end function

public function boolean noexisteclie (string as_valor);Integer li_contador
String ls_rut, ls_nombre
Boolean lb_retorno

dw_1.Accepttext()

ls_rut = as_valor

  SELECT Count(*)
   INTO :li_contador  
   FROM dbo.clienprove as cl,dbo.tiposanalis as tp 
   //WHERE cl.clpr_tipoan = tp.tian_tipoan
	WHERE cl.clpr_rut = :ls_rut
	AND cl.clpr_tipoan = 0	 
	AND tp.tian_codigo = 21;
	
IF sqlca.sqlcode = -1 THEN
	F_ErrorBaseDatos(sqlca,"No se pudo leer la tabla Clienprove")
	lb_Retorno  = TRUE
ELSEIF li_Contador = 0 THEN
	Messagebox("Atención","Rut no está asociado a Código Tipo de Analisis 21")
	lb_Retorno =  TRUE
ELSE
	dw_1.Object.clpr_rut[il_fila] = is_codigo
	
END IF
RETURN lb_Retorno
end function

public subroutine existerut ();String	ls_nombre

	SELECT clpr_nombre
	INTO :ls_nombre
	FROM dbo.clienprove
	WHERE clpr_rut = :is_codigo;
	
	dw_1.Object.clpr_nombre[il_fila] = ls_nombre

end subroutine

public subroutine buscacliente ();Str_busqueda	lstr_busq

dw_1.Modify("buscacliente.border = 0")
dw_1.Modify("buscacliente.border = 5")

lstr_busq.argum[1] 	= "1"


OpenWithParm(w_busc_clienprove, lstr_busq)

lstr_busq = Message.PowerObjectParm

IF lstr_busq.argum[1] = "" THEN
	
	dw_1.SetColumn("clpr_rut")
	dw_1.SetFocus()
	
ELSE
	
	is_rut = F_Verrut(lstr_busq.argum[1], True)
	
	dw_1.SetItem(1, "clpr_rut", lstr_busq.argum[1])
	dw_1.SetItem(1, "clpr_nombre", lstr_busq.argum[2])
   dw_1.Object.clpr_rut[il_fila] 	= lstr_busq.argum[1]
	dw_1.Object.clpr_nombre[il_fila] = lstr_busq.argum[2]
	
	dw_1.SetColumn("mqub_codigo")
	
END IF

dw_1.Modify("buscacliente.border = 0")
dw_1.Modify("buscacliente.border = 6")

RETURN

end subroutine

public subroutine buscaentidad ();Str_busqueda	lstr_busq

lstr_busq.argum[1]	=	'21'	

OpenWithParm(w_busc_clienprove, lstr_busq)

istr_busq	= Message.PowerObjectParm

IF istr_busq.argum[1] = "" THEN
	dw_1.SetColumn("clpr_rut")
	dw_1.SetFocus()
ELSE
	NoExisteEntidad(istr_busq.argum[1])
END IF
RETURN
end subroutine

public function boolean noexisteentidad (string as_entidad);String	ls_nombre

IF Len(as_entidad) > 6 THEN
	is_rut	= Fill('0', 10 - Len(as_entidad)) + as_entidad
ELSE
	is_rut	= Fill('0', 6 - Len(as_entidad)) + as_entidad
END IF

SELECT	clpr_nombre
	INTO	:ls_nombre
	FROM	dbo.CLIENPROVE as cli, dbo.ANALISENTIDAD as ana
	WHERE	cli.clpr_rut		=	:is_rut
	AND	ana.clpr_rut		=	cli.clpr_rut
	AND	ana.tian_codigo	=	21 ;
	
IF sqlca.SQLCode = -1 THEN
 F_ErrorBaseDatos(sqlca,"Lectura de la Tabla CLIENPROVE")
	RETURN True
ELSEIF sqlca.SQLCode = 100 THEN
	MessageBox("Atención", "Código de Entidad no ha sido Creada / No Corresponde.", &
		Exclamation!, OK!)
	RETURN True
ELSE
	dw_1.SetItem(il_fila,"clpr_rut", is_rut)
	dw_1.SetItem(il_fila,"clpr_nombre", ls_nombre)
	RETURN False
END IF




end function

on w_mant_mues_entregavales.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.uo_selproveedor=create uo_selproveedor
this.uo_selzona=create uo_selzona
this.em_fecha=create em_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_selproveedor
this.Control[iCurrent+5]=this.uo_selzona
this.Control[iCurrent+6]=this.em_fecha
end on

on w_mant_mues_entregavales.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.uo_selproveedor)
destroy(this.uo_selzona)
destroy(this.em_fecha)
end on

event open;call super::open;Boolean	lb_Cerrar

IF IsNull(uo_SelZona.Codigo) THEN lb_Cerrar	=	True
IF IsNull(uo_SelProveedor.Codigo) THEN lb_Cerrar	=	True

IF lb_Cerrar THEN
	Close(This)
ELSE
	uo_SelZona.Seleccion(False,False)
	uo_SelProveedor.Seleccion(False,False)
	
	em_fecha.Text	=	String(Today(), 'dd/mm/yyyy')
	dw_1.SetRowFocusIndicator(Off!)	

	iuo_movto			=	Create uo_movtocasino
	iuo_area				=	Create uo_casino_areas
	iuo_tipocolacion	=	Create uo_tipocolacion
	
	dw_1.GetChild("caar_codigo", idwc_area)
	idwc_area.SetTransObject(sqlca)
	idwc_area.Retrieve(0)
	
	dw_1.GetChild("tico_codigo", idwc_tipocolacion)
	idwc_tipocolacion.SetTransObject(sqlca)
	idwc_tipocolacion.Retrieve(0)
END IF
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve(uo_SelZona.Codigo, uo_SelProveedor.Codigo, Date(em_fecha.text))
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()
		
		pb_insertar.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled		= True
		pb_imprimir.Enabled	= True
		il_fila					= 1
	ELSE
		pb_insertar.Enabled	= True
		pb_insertar.SetFocus()
		ias_campo[1]			= ""
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

event ue_nuevo;call super::ue_nuevo;dw_1.SetColumn("evct_fechav")

dw_1.Object.evct_fechav[il_Fila]	=	Today()
dw_1.Object.evct_secuen[il_Fila]	=	il_Fila
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info

lstr_info.titulo	= "MAESTRO ENTREGA VALES CONTRATISTA"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_entregavales"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(uo_SelZona.Codigo, uo_SelProveedor.Codigo, Date(em_fecha.text))

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", &
					StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN
	   	F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
	
  	END IF
END IF

SetPointer(Arrow!)        
end event

event ue_validaregistro;Integer	li_cont
String	ls_mensaje, ls_colu[]

IF Isnull(dw_1.Object.evct_fechav[il_fila])  THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nFecha Vigencia"
	ls_colu[li_cont]	= "evct_fechav"
END IF

IF Isnull(dw_1.Object.evct_horaiv[il_fila]) THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nHora Inicio Vigencia"
	ls_colu[li_cont]	= "evct_horaiv"
END IF

IF Isnull(dw_1.Object.evct_horatv[il_fila]) THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nHora Termino Vigencia"
	ls_colu[li_cont]	= "evct_horatv"
END IF

IF Isnull(dw_1.Object.tico_codigo[il_fila]) Or dw_1.Object.tico_codigo[il_fila] = 0 THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nTipo de Colación"
	ls_colu[li_cont]	= "tico_codigo"
END IF

IF Isnull(dw_1.Object.evct_cantid[il_fila]) Or dw_1.Object.evct_cantid[il_fila] = 0 THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nCantidad de vales entregados"
	ls_colu[li_cont]	= "evct_cantid"
END IF

IF Isnull(dw_1.Object.evct_nroini[il_fila]) Or dw_1.Object.evct_nroini[il_fila] = 0 THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nPrimer Nro. asignado."
	ls_colu[li_cont]	= "evct_nroini"
END IF

IF Isnull(dw_1.Object.evct_nroter[il_fila]) Or dw_1.Object.evct_nroter[il_fila] = 0 THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nUltimo Nro. asignado."
	ls_colu[li_cont]	= "evct_nroter"
END IF

IF li_cont > 0 THEN
	MessageBox("Error de Consistencia", "Falta el ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[li_cont])
	dw_1.SetFocus()
	Message.DoubleParm = -1
END IF
end event

event ue_antesguardar;Long	ll_Fila

FOR ll_Fila = 1 TO dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_Fila, 0, Primary!) = New! THEN
		dw_1.DeleteRow(ll_Fila)
	ELSEIF dw_1.GetItemStatus(ll_Fila, 0, Primary!) = NewModified! THEN
		dw_1.Object.zona_codigo[ll_Fila]	=	uo_SelZona.Codigo
		dw_1.Object.clpr_rut[ll_Fila]		=	uo_SelProveedor.Codigo
		dw_1.Object.evct_fechae[ll_Fila]	=	Date(em_fecha.Text)
		dw_1.Object.evct_estado[il_Fila]	=	1
		TriggerEvent("ue_validaregistro")		
	END IF
NEXT
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_entregavales
integer x = 37
integer y = 32
integer width = 3515
integer height = 320
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_entregavales
integer x = 3735
integer y = 356
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_entregavales
integer x = 3735
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_entregavales
integer x = 3735
integer y = 712
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_entregavales
integer x = 3735
integer y = 532
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_entregavales
integer x = 3735
integer y = 1432
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_entregavales
integer x = 3735
integer y = 1072
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_entregavales
integer x = 3735
integer y = 892
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_entregavales
integer x = 37
integer y = 380
integer width = 3515
integer height = 1220
string dataobject = "dw_mues_entregavales"
end type

event dw_1::sqlpreview;//
end event

event dw_1::itemchanged;call super::itemchanged;Integer	li_null
String	ls_columna

SetNull(li_null)
ls_Columna	=	Dwo.Name

Choose Case ls_columna
	Case "evct_cantid"
		This.Object.evct_nroini[Row]	=	0
		This.Object.evct_nroter[Row]	=	0
		
	Case "evct_nroini"
		If  Not iuo_movto.ExisteMinimo(Long(data), uo_selproveedor.Codigo, uo_selzona.codigo, True, SqlCa) Then
			This.Object.evct_nroini[Row]	=	0
			Return 1
			
		End If 
		
	Case "evct_nroter"
		If  Integer(Data) < This.Object.evct_nroini[Row] Then
			MessageBox("Error", "El Rango ingresado no esta permitido")
			This.Object.evct_nroter[Row]	=	0
			Return 1
			
		ElseIf  (Integer(Data) - This.Object.evct_nroini[Row]) + 1 < This.Object.evct_cantid[Row] Then
			MessageBox("Error", "El Rango ingresado no concuerda con la cantidad de vales a entregar")
			This.Object.evct_nroter[Row]	=	0
			Return 1
			
		ElseIf  Not iuo_movto.ExisteMaximo(Long(data), uo_selproveedor.Codigo, uo_selzona.codigo, True, SQLCA) Then
			This.Object.evct_nroter[Row]	=	0
			Return 1
			
//		ElseIf  Not iuo_movto.ExisteEnRango(Long(This.Object.evct_nroini[Row]), Long(data), &
//												 uo_selproveedor.Codigo, Long(This.Object.evct_cantid[Row]), &
//												 uo_selzona.codigo, True, SQLCA) Then
//			This.Object.evct_nroter[Row]	=	0
//			Return 1
			
		End If 
		
	Case "caar_codigo"
		If  Not iuo_area.Existe(uo_selzona.codigo, Integer(data), True, Sqlca) Then
			This.Object.caar_codigo[Row]	=	li_null
			Return 1
			
		End If 
		
	CASE "tico_codigo"
		IF Not IsNull(data) THEN
			IF NOT iuo_tipocolacion.Existe(uo_selzona.Codigo, Integer(data), True, sqlca) THEN
				This.Object.tico_codigo[row]	=	li_null
				Return 1
				
			END IF
		END IF
End Choose 
end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

type st_1 from statictext within w_mant_mues_entregavales
integer x = 1074
integer y = 60
integer width = 352
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
string text = "Zona"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mant_mues_entregavales
integer x = 1074
integer y = 152
integer width = 352
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
string text = "Contratista"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_mant_mues_entregavales
integer x = 1074
integer y = 244
integer width = 352
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
string text = "Fecha"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_selproveedor from uo_seleccion_clienprove within w_mant_mues_entregavales
integer x = 1522
integer y = 144
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

on uo_selproveedor.destroy
call uo_seleccion_clienprove::destroy
end on

type uo_selzona from uo_seleccion_zonas within w_mant_mues_entregavales
integer x = 1522
integer y = 52
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;idwc_Area.Retrieve(uo_SelZona.Codigo)
idwc_TipoColacion.Retrieve(uo_SelZona.Codigo)
end event

type em_fecha from editmask within w_mant_mues_entregavales
integer x = 1522
integer y = 236
integer width = 498
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

