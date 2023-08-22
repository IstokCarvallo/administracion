$PBExportHeader$uo_licencia.sru
$PBExportComments$Objeto de Validación de Sucursales
forward
global type uo_licencia from nonvisualobject
end type
end forward

global type uo_licencia from nonvisualobject
end type
global uo_licencia uo_licencia

type variables
Integer		Codigo
String			Nombre, KEY
DateTime	Fecha
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	lice_codigo, lice_nombre, lice_serie, lice_feccom
	INTO	:Codigo, :Nombre, :KEY, :Fecha
	FROM	dbo.licenciasSW
	WHERE	lice_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Licencias")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Licencia(" + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_licencia.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_licencia.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

