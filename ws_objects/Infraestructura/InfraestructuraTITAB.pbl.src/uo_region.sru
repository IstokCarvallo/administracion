$PBExportHeader$uo_region.sru
$PBExportComments$Objeto de Validación de Regiones
forward
global type uo_region from nonvisualobject
end type
end forward

global type uo_region from nonvisualobject
end type
global uo_region uo_region

type variables
Integer	Pais, Codigo
String		Nombre
end variables

forward prototypes
public function boolean existe (integer ai_pais, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_pais, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	pais_codigo,regi_codigo,regi_nombre
	INTO	:Pais, :Codigo, :Nombre
	FROM	dbo.region
	WHERE	pais_codigo	=	:ai_Pais
	AND	regi_codigo	=	:ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Regiones")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Pais y/o Region (" + String(ai_Pais, '00') + " - " + &
						String(ai_Codigo, '0000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_region.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_region.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

