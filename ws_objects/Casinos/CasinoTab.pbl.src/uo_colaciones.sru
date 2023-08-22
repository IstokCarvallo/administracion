$PBExportHeader$uo_colaciones.sru
$PBExportComments$Objeto de Validación de Colaciones por Zona
forward
global type uo_colaciones from nonvisualobject
end type
end forward

global type uo_colaciones from nonvisualobject
end type
global uo_colaciones uo_colaciones

type variables
Integer	Codigo, Zona, TipoColacion
String	Nombre, Abreviacion
end variables

forward prototypes
public function boolean existe (integer ai_zona, integer ai_tipocolacion, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_zona, integer ai_tipocolacion, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	zona_codigo, tico_codigo,caco_codigo,caco_nombre,caco_abrevi
	INTO	:Zona, :TipoColacion, :Codigo,:Nombre,:Abreviacion
	FROM	dbo.casino_colaciones
	WHERE	zona_codigo	=	:ai_Zona
	AND	tico_codigo	=	:ai_TipoColacion
	AND	caco_codigo	=	:ai_Codigo
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Colaciones")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Colación " + String(ai_Codigo) + &
					", no ha sido Ingresado para Zona.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

on uo_colaciones.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_colaciones.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

