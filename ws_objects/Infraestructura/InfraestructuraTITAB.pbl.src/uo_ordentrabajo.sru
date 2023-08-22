$PBExportHeader$uo_ordentrabajo.sru
$PBExportComments$Objeto de Validación de Sucursales
forward
global type uo_ordentrabajo from nonvisualobject
end type
end forward

global type uo_ordentrabajo from nonvisualobject
end type
global uo_ordentrabajo uo_ordentrabajo

type variables
Integer		Moneda, Proveedor, TipoOrden
String			Codigo, Responsable, Ejecutante
DateTime	Fecha
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	ortr_codigo, mone_codigo, prov_codigo, ortr_tipord, 
			ortr_fecord, ortr_respon, ortr_ejecut
	INTO	:Codigo, :Moneda, :Proveedor, :TipoOrden, 
			:Fecha, :Responsable, :Ejecutante
	FROM	dbo.ordentrabajo
	WHERE	ortr_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Ordenes Trabajo")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Orden Trabajo(" + String(ai_Codigo, '00000000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_ordentrabajo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_ordentrabajo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

