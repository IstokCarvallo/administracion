$PBExportHeader$uo_valescontratista.sru
$PBExportComments$Objeto de Validación de Áreas
forward
global type uo_valescontratista from nonvisualobject
end type
end forward

global type uo_valescontratista from nonvisualobject
end type
global uo_valescontratista uo_valescontratista

type variables
Integer	Zona, Ubicacion
Long		Numero, Ultimo
String		Contratista
end variables

forward prototypes
public function boolean existe (integer ai_zona, string as_rut, long al_numero, boolean ab_mensaje, transaction at_transaccion)
public function boolean ultimovale (integer ai_zona, string as_rut, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_zona, string as_rut, long al_numero, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	zona_codigo, clpr_rut, vact_numero, vact_ubicac
	INTO	:Zona, :Contratista, :Numero, :Ubicacion
	FROM	dbo.casino_valescontratista
	WHERE	zona_codigo	=	:ai_zona
		And	clpr_rut		=	:as_rut
		And	vact_numero=	:al_numero
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Areas")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "En la Vale Contratista no Existe" + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean ultimovale (integer ai_zona, string as_rut, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	IsNull(Max(vact_numero), 0)
	INTO	:Ultimo
	FROM	dbo.casino_valescontratista
	WHERE	zona_codigo	=	:ai_zona
		And	clpr_rut		=	:as_rut
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Areas")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
END IF

RETURN lb_Retorno
end function

on uo_valescontratista.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_valescontratista.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

