$PBExportHeader$uo_tipoequipos.sru
$PBExportComments$Objeto de Validación de Tipo de Equipos
forward
global type uo_tipoequipos from nonvisualobject
end type
end forward

global type uo_tipoequipos from nonvisualobject
end type
global uo_tipoequipos uo_tipoequipos

type variables
Integer	Codigo
String		Nombre, Abreviacion
Long		Inicial, Actual
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean correlativo (long al_correlativo, integer ai_codigo, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	tieq_codigo, tieq_nombre, tieq_abrevi, tieq_correl, tieq_coract
	INTO	:Codigo, :Nombre, :Abreviacion, :Inicial, :Actual
	FROM	dbo.tipoequipo
	WHERE	tieq_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla TIpos de Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Tipo Equipos(" + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean correlativo (long al_correlativo, integer ai_codigo, transaction at_transaccion);Boolean	lb_Retorno = True

UPDATE dbo.tipoequipo
	Set tieq_coract = :al_Correlativo
	WHERE	tieq_codigo = :ai_Codigo
	USING	at_Transaccion;

Commit;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Grabacion en  de Tipos de Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	MessageBox("Atención", "No se pudo grabar el Correltivo para el Código de Tipo Equipos(" + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
END IF

RETURN lb_Retorno
end function

on uo_tipoequipos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_tipoequipos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

