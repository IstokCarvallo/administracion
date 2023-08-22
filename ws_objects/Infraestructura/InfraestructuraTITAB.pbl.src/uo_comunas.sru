$PBExportHeader$uo_comunas.sru
$PBExportComments$Objeto de Validación de comunas
forward
global type uo_comunas from nonvisualobject
end type
end forward

global type uo_comunas from nonvisualobject
end type
global uo_comunas uo_comunas

type variables
Integer	Pais, Region, Codigo
String		Nombre
end variables

forward prototypes
public function boolean existe (integer ai_pais, integer ai_region, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_pais, integer ai_region, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	pais_codigo, regi_codigo, comu_codigo, comu_nombre
	INTO	:Pais, :Region, :Codigo, :Nombre
	FROM	dbo.comuna
	WHERE	pais_codigo	=	:ai_Pais
	AND	regi_codigo	=	:ai_Region
	AND	comu_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Comunas")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Pais y/o Region y/o Comiuna (" + String(ai_Pais, '000') + " - " + &
						String(ai_region, '0000') + " - " + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_comunas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_comunas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

