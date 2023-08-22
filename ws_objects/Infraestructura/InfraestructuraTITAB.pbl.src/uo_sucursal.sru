$PBExportHeader$uo_sucursal.sru
$PBExportComments$Objeto de Validación de Sucursales
forward
global type uo_sucursal from nonvisualobject
end type
end forward

global type uo_sucursal from nonvisualobject
end type
global uo_sucursal uo_sucursal

type variables
Integer	Pais, Region, Comuna, Codigo
String		Nombre, Telefono, RUT, Giro, Direccion, RazonSocial, Ciudad
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	pais_codigo, regi_codigo, comu_codigo, sucu_codigo, sucu_nombre, sucu_telefo, 
			sucu_nrorut, sucu_giroem, sucu_direcc, sucu_razsoc, sucu_ciudad
	INTO	:Pais, :Region, :Comuna, :Codigo, :Nombre, :Telefono, 
			:RUT, :Giro, :Direccion, :RazonSocial, :Ciudad
	FROM	dbo.sucursal
	WHERE	sucu_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Sucursales")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Sucursal(" + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_sucursal.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_sucursal.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

