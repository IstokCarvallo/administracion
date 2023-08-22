$PBExportHeader$uo_modelo.sru
$PBExportComments$Objeto de Validación de comunas
forward
global type uo_modelo from nonvisualobject
end type
end forward

global type uo_modelo from nonvisualobject
end type
global uo_modelo uo_modelo

type variables
Integer	Marca, TipoEquipo, Codigo
String		Nombre
end variables

forward prototypes
public function boolean existe (integer ai_marca, integer ai_tipo, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_marca, integer ai_tipo, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	marc_codigo, tieq_codigo, mode_codigo, mode_nombre
	INTO	:Marca, :TipoEquipo, :Codigo, :Nombre
	FROM	dbo.modelo
	WHERE	marc_codigo	=	:ai_marca
	AND	tieq_codigo	=	:ai_Tipo
	AND	mode_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Modelo")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Marca y/o Tipo Equipo y/o Modelo (" + String(ai_marca, '000') + " - " + &
						String(ai_Tipo, '000') + " - " + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_modelo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_modelo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

