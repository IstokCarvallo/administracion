$PBExportHeader$uo_seccion.sru
$PBExportComments$Objeto de Validación de Secciones
forward
global type uo_seccion from nonvisualobject
end type
end forward

global type uo_seccion from nonvisualobject
end type
global uo_seccion uo_seccion

type variables
Integer	Empresa, Codigo
String		Nombre
end variables

forward prototypes
public function boolean existe (integer ai_empresa, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_empresa, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	empr_codigo,secc_codigo,secc_nombre
	INTO	:Empresa, :Codigo, :Nombre
	FROM	dbo.seccion
	WHERE	empr_codigo	=	:ai_Empresa
	AND	secc_codigo	=	:ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Secciones")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Empresa y/o Seccion (" + String(ai_Empresa, '00') + " - " + &
						String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_seccion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_seccion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

