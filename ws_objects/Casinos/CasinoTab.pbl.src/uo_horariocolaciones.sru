$PBExportHeader$uo_horariocolaciones.sru
$PBExportComments$Objeto de Validación de Horario Colaciones por Zona
forward
global type uo_horariocolaciones from nonvisualobject
end type
end forward

global type uo_horariocolaciones from nonvisualobject
end type
global uo_horariocolaciones uo_horariocolaciones

type variables
Integer	Codigo, Zona, TipoColacion
Date		Inicio, Termino
Dec{2}	Valor
end variables

forward prototypes
public function boolean existe (integer ai_zona, integer ai_tipo, integer ai_codigo, date ad_fecha, boolean ab_mensaje, transaction at_transaccion)
public function date ultimafecha (integer ai_zona, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_zona, integer ai_tipo, integer ai_codigo, date ad_fecha, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

//SELECT	zona_codigo, tico_codigo, caco_codigo, cavc_fecini, cavc_fecter, cavc_valcol
//	INTO	:Zona, :TipoColacion, :Codigo, :Inicio, :Termino, :Valor
//	FROM	dbo.casino_valorcolacion
//	WHERE	zona_codigo	=	:ai_Zona
//	AND	tico_codigo	=	:ai_Tipo
//	And	caco_codigo	=	:ai_Codigo
//	And 	cavc_fecini	=	:ad_Fecha
//	USING	at_Transaccion;
//	
//IF at_Transaccion.SQLCode = -1 THEN
//	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla valor Colación Colaciones")
//	
//	lb_Retorno	=	False
//ELSEIF at_Transaccion.SQLCode = 100 THEN
//	lb_Retorno	=	False
//
//	IF ab_Mensaje THEN
//		MessageBox("Atención", "Código de Valorizacion de Colación " + &
//					", no ha sido Ingresado para Zona.~r~rIngrese o seleccione otro Código.")	
//	END IF
//END IF

RETURN lb_Retorno
end function

public function date ultimafecha (integer ai_zona, boolean ab_mensaje, transaction at_transaccion);Date	ld_Retorno

SetNull(ld_Retorno)

SELECT	Max(cahc_fecini)
	INTO	:ld_Retorno
	FROM	dbo.casino_horariocolaciones
	WHERE	zona_codigo	=	:ai_Zona
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla valor Colación")
END IF

RETURN ld_Retorno
end function

on uo_horariocolaciones.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_horariocolaciones.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

