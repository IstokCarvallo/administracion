$PBExportHeader$uo_movtoequipo.sru
$PBExportComments$Objeto de Validación de Sucursales
forward
global type uo_movtoequipo from nonvisualobject
end type
end forward

global type uo_movtoequipo from nonvisualobject
end type
global uo_movtoequipo uo_movtoequipo

type variables
Long		Numero, Guia, DespachoOrigen
Integer	TipoMovto, Sucursal, Proveedor, EstadoGuia, SucursalOrigen
Datetime	Fecha
String		Chofer, RUTChofer, CelularChofer, Patente, Observacion, Usuario, Computador
end variables

forward prototypes
public function boolean of_existe (long al_codigo, boolean ab_mensaje, transaction at_transaccion)
public function long of_siguientemovto (transaction at_transaccion)
end prototypes

public function boolean of_existe (long al_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	meec_numero,tpmv_codigo,sucu_codigo,prov_codigo,meec_fecham,meec_chofer,    
        		meec_rutcho,meec_celcho,meec_patent,meec_guides,meec_observ,meec_usuari,
        		meec_comput,meec_guiemi,meec_sucori,meec_desori
    INTO :Numero, :TipoMovto, :Sucursal, :Proveedor, :Fecha, :Chofer,
         :RUTChofer, :CelularChofer, :Patente, :Guia, :Observacion, :Usuario,
         :Computador, :EstadoGuia, :SucursalOrigen, :DespachoOrigen
	FROM	dbo.movtoequipoenca
	WHERE	meec_numero = :al_codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla MovimientoEquipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Numero de Movimiento de Equipos(" + String(al_codigo, '00000000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function long of_siguientemovto (transaction at_transaccion);Long	ll_Retorno

SELECT	IsNull(Max(meec_numero), 0) + 1
    INTO :ll_Retorno
	FROM	dbo.movtoequipoenca
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla MovimientoEquipos")
	ll_Retorno	=	-1
ELSEIF at_Transaccion.SQLCode = 100 THEN
	ll_Retorno	=	-1
END IF

RETURN ll_Retorno
end function

on uo_movtoequipo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_movtoequipo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

