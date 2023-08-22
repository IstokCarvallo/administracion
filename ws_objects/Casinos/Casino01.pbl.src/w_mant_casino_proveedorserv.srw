$PBExportHeader$w_mant_casino_proveedorserv.srw
forward
global type w_mant_casino_proveedorserv from w_mant_directo
end type
end forward

global type w_mant_casino_proveedorserv from w_mant_directo
integer width = 3579
string title = "MAESTRO DE PROVEEDORES SERVICIO CASINO"
end type
global w_mant_casino_proveedorserv w_mant_casino_proveedorserv

type variables
String	is_rut
end variables

forward prototypes
public function boolean existeclienprove (string as_columna, string as_codigo)
public function boolean validarango (string as_columna, string as_valor)
public subroutine buscacliente ()
end prototypes

public function boolean existeclienprove (string as_columna, string as_codigo);Integer 				li_tipana, li_comuna, li_ciudad, li_tipoan, li_zona, li_tipoen, li_tipo, li_pais,li_corint
String				ls_rut, ls_nrorut, ls_nombre, ls_nomper, ls_apepat, ls_apemat, ls_fantas,&
						ls_giroem, ls_contact, ls_direcc, ls_telefo, ls_fax,  ls_rutrep,&
						ls_nomrep, ls_rutre2, ls_nomre2
str_clienprove		le_cliente

SELECT	clpr_rut, clpr_nrorut, clpr_nombre, clpr_nomper, clpr_apepat, 
         clpr_apemat, clpr_fantas, clpr_giroem,	clpr_contac, clpr_direcc, 
			ciud_codigo,	comu_codigo, clpr_telefo, clpr_nrofax, clpr_tipoan,
			zona_codigo, clpr_tipoen, clpr_rutrep,	clpr_nomrep,clpr_rutre2, 
			clpr_nomre2, pais_codigo, clpr_corint 
	INTO	:ls_rut, :ls_nrorut, :ls_nombre, :ls_nomper,:ls_apepat, 
			:ls_apemat, :ls_fantas,	:ls_giroem, :ls_contact, :ls_direcc,
			:li_ciudad, :li_comuna, :ls_telefo, :ls_fax, :li_tipoan,
			:li_zona, :li_tipoen,:ls_rutrep, :ls_nomrep, :ls_rutre2,
			:ls_nomre2, :li_pais, :li_corint 
	FROM	dbo.clienprove
	WHERE	clpr_rut 	= :as_codigo;
			
IF SQLCA.SqlCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de la Tabla CLIENPROVE")
	RETURN False
	
ELSEIF SQLCA.SqlCode = 0 THEN
	dw_1.Object.clpr_nombre[il_fila]=	ls_nombre
	RETURN True
	
ELSE
	MessageBox("Error", "Rut ingresado no existe, por favor digite otro.", StopSign!)
	RETURN False
	
END IF	

RETURN True
end function

public function boolean validarango (string as_columna, string as_valor);String	ls_fecini, ls_fecter, ls_find
Integer	li_fila

ls_fecini	=	String(dw_1.Object.prse_fecini[dw_1.GetRow()])
ls_fecter	=	String(dw_1.Object.prse_fecter[dw_1.GetRow()])

CHOOSE CASE as_columna
	CASE "prse_fecini"
		ls_fecini	=	as_valor
		
	CASE "prse_fecter"
		ls_fecter	=	as_valor
		
END CHOOSE

ls_find	=	"Date('" + ls_fecini + "') between prse_fecini and prse_fecter"
li_fila 	=	dw_1.Find(ls_find, 1, dw_1.RowCount())

IF li_fila <> dw_1.GetRow() AND li_fila > 0 THEN
	MessageBox("Error", "La fecha ingresada no es válida (Se encuentra en otro Rango) , por favor ingrese otra", StopSign!)
	Return False
END IF

Return True
end function

public subroutine buscacliente ();str_busqueda	lstr_busq

lstr_busq.Argum[1]	=	'0'

OpenWithParm(w_busc_clienprove, lstr_busq)

lstr_busq				=	Message.PowerobjectParm

IF Upperbound(lstr_busq.Argum) > 2 THEN
	dw_1.Object.clpr_rut[dw_1.GetRow()]		=	lstr_busq.argum[1]
	dw_1.Object.clpr_nombre[dw_1.GetRow()]	=	lstr_busq.argum[2]
END IF
end subroutine

on w_mant_casino_proveedorserv.create
call super::create
end on

on w_mant_casino_proveedorserv.destroy
call super::destroy
end on

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info

lstr_info.titulo	= "PROVEEDORES DE SERVICIO DE CASINO"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_proveedores_casino"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve()

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

event open;call super::open;PostEvent("ue_recuperadatos")

buscar						=	'R.U.T.:Sclpr_rut'
ordenar						= 	'R.U.T.:clpr_rut'

end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve()
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox(	"Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()
		pb_insertar.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled		= True
		pb_imprimir.Enabled	= True
	ELSE
		pb_insertar.Enabled 	= True
		pb_insertar.SetFocus()
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_casino_proveedorserv
boolean visible = false
integer width = 2665
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_casino_proveedorserv
integer x = 3031
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_casino_proveedorserv
integer x = 3031
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_casino_proveedorserv
integer y = 64
integer width = 2665
integer height = 1644
string dataobject = "dw_mant_mues_proveedores_casino"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_Nula, ls_Columna
Integer  li_Nula

SetNull(ls_Nula)
SetNull(li_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE "clpr_rut"
		is_rut = F_verrut(data, True)
		
		IF is_rut = ""  THEN
			This.SetItem(row, "clpr_rut", ls_Nula)
			RETURN 1
			
		ELSEIF NOT ExisteClienProve('clpr_rut', is_rut) THEN
			This.SetItem(row, "clpr_rut", ls_Nula)
			RETURN 1
		END IF
		
	CASE "prse_fecini"
		IF This.Object.prse_fecter[Row] < Date(data) THEN
			MessageBox("Error", "La fecha de termino no puede ser inferior a la de inicio", Exclamation!)
			This.SetItem(row, "prse_fecini", Date(ls_Nula))
			Return 1
			
		ELSEIF NOT ValidaRango(ls_columna, data) THEN
			This.SetItem(row, "prse_fecini", Date(ls_Nula))
			Return 1
		END IF
		
	CASE "prse_fecter"
		IF This.Object.prse_fecini[Row] > Date(data) THEN
			MessageBox("Error", "La fecha de termino no puede ser inferior a la de inicio", Exclamation!)
			This.SetItem(row, "prse_fecter", Date(ls_Nula))
			Return 1
			
		ELSEIF NOT ValidaRango(ls_columna, data) THEN
			This.SetItem(row, "prse_fecini", Date(ls_Nula))
			Return 1
		END IF
		
END CHOOSE
end event

event dw_1::buttonclicked;call super::buttonclicked;String	ls_Nula, ls_Columna
Integer  li_Nula

SetNull(ls_Nula)
SetNull(li_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
	CASE "b_busca"
		BuscaCliente()
		
END CHOOSE
end event

