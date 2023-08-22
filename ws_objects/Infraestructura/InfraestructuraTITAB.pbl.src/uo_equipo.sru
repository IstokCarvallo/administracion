$PBExportHeader$uo_equipo.sru
$PBExportComments$Objeto de Validación de Sucursales
forward
global type uo_equipo from nonvisualobject
end type
end forward

global type uo_equipo from nonvisualobject
end type
global uo_equipo uo_equipo

type variables
Integer		Codigo, Empresa, Marca, Proveedor, TipoEquipo, Estado, Propiedad, Leasing, CodigoModelo
Long			NroOrdenCompra, NroGuiaDespacho, NroFactura
String			Modelo, Serie, NroInterno, Observacion, NroPoliza, IP, RUT, ACA
DateTime	FechaAdquisicion
Dec{2}		ValorCompra, ValorReposicion
end variables

forward prototypes
public function boolean of_actualizaestado (long ai_equipo, integer ai_estado, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_actulizamarcaent (long ai_equipo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_actualizamarcadev (long ai_equipo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existeparadespacho (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existeparadespacho (string as_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existeparatraslado (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_asignado (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function long of_cantidadserie (string as_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existeaca (string as_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean of_actualizaestado (long ai_equipo, integer ai_estado, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

Update dbo.Equipo
	SET	equi_estado = :ai_Estado
	WHERE	equi_codigo = :ai_Equipo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "No se encontro Código de Equipos (" + String(ai_Equipo, '00000') + ")")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_actulizamarcaent (long ai_equipo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

Update dbo.EquipoAsignado
	SET	eqas_marent = 1
	WHERE	equi_codigo = :ai_Equipo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos Asignado")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "No se encontro Código de Equipos (" + String(ai_Equipo, '00000') + ")")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_actualizamarcadev (long ai_equipo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

Update dbo.EquipoAsignado
	SET	eqas_mardev = 1
	WHERE	equi_codigo = :ai_Equipo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos Adignado")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "No se encontro Código de Equipos (" + String(ai_Equipo, '00000') + ")")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_existeparadespacho (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	equi_codigo, empr_codigo, marc_codigo, prov_codigo, tieq_codigo, 
			equi_modelo, equi_fecadq, equi_nrooc, equi_guides, equi_nrofac, 
			equi_nroser, equi_nroint, equi_valcom, equi_valrep, equi_estado, 
			equi_propie, equi_observ,equi_leasin, equi_nrolea, equi_nroip, mode_codigo
	INTO	:Codigo, :Empresa, :Marca, :Proveedor, :TipoEquipo, 
			:Modelo, :FechaAdquisicion, :NroOrdenCompra, :NroGuiaDespacho, :NroFactura,
			:Serie, :NroInterno, :ValorCompra, :ValorReposicion, :Estado, 
			:Propiedad,:Observacion, :Leasing, :NroPoliza, :IP, :CodigoModelo
	FROM	dbo.equipo
	WHERE	equi_codigo = :ai_Codigo
	  And equi_estado = 0
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Equipos(" + String(ai_Codigo, '00000') + "), no esta en estado Activo, para ser Despachado.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_existeparadespacho (string as_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	equi_codigo, empr_codigo, marc_codigo, prov_codigo, tieq_codigo, 
			equi_modelo, equi_fecadq, equi_nrooc, equi_guides, equi_nrofac, 
			equi_nroser, equi_nroint, equi_valcom, equi_valrep, equi_estado, 
			equi_propie, equi_observ,equi_leasin, equi_nrolea, equi_nroip, mode_codigo
	INTO	:Codigo, :Empresa, :Marca, :Proveedor, :TipoEquipo, 
			:Modelo, :FechaAdquisicion, :NroOrdenCompra, :NroGuiaDespacho, :NroFactura,
			:Serie, :NroInterno, :ValorCompra, :ValorReposicion, :Estado, 
			:Propiedad,:Observacion, :Leasing, :NroPoliza, :IP, :CodigoModelo
	FROM	dbo.equipo
	WHERE	(Upper(equi_nroser) = :as_Codigo
	      Or Upper(equi_nroint) = :as_Codigo)
	  And equi_estado = 0
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", " Numero de Serie de Equipo(" + as_Codigo + "), no esta en estado Activo, para ser Despachado.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_existeparatraslado (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	equi_codigo, empr_codigo, marc_codigo, prov_codigo, tieq_codigo, 
			equi_modelo, equi_fecadq, equi_nrooc, equi_guides, equi_nrofac, 
			equi_nroser, equi_nroint, equi_valcom, equi_valrep, equi_estado, 
			equi_propie, equi_observ,equi_leasin, equi_nrolea, equi_nroip, mode_codigo
	INTO	:Codigo, :Empresa, :Marca, :Proveedor, :TipoEquipo, 
			:Modelo, :FechaAdquisicion, :NroOrdenCompra, :NroGuiaDespacho, :NroFactura,
			:Serie, :NroInterno, :ValorCompra, :ValorReposicion, :Estado, 
			:Propiedad,:Observacion, :Leasing, :NroPoliza, :IP, :CodigoModelo
	FROM	dbo.equipo
	WHERE	equi_codigo = :ai_Codigo
	  And equi_estado = 6
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Equipos(" + String(ai_Codigo, '00000') + "), no esta en estado Activo, para ser Despachado.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_asignado (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	equi_codigo, pers_codigo
	INTO	:Codigo, :Rut
	FROM	dbo.EquipoAsignado
	WHERE	equi_codigo = :ai_Codigo
	   AND	eqas_estado = 1
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos Asignados")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Equipos no posee Personal asignado(" + String(ai_Codigo, '00000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	equi_codigo, empr_codigo, marc_codigo, prov_codigo, tieq_codigo, 
			equi_modelo, equi_fecadq, equi_nrooc, equi_guides, equi_nrofac, 
			equi_nroser, equi_nroint, equi_valcom, equi_valrep, equi_estado, 
			equi_propie, equi_observ,equi_leasin, equi_nrolea, equi_nroip, mode_codigo
	INTO	:Codigo, :Empresa, :Marca, :Proveedor, :TipoEquipo, 
			:Modelo, :FechaAdquisicion, :NroOrdenCompra, :NroGuiaDespacho, :NroFactura,
			:Serie, :NroInterno, :ValorCompra, :ValorReposicion, :Estado, 
			:Propiedad,:Observacion, :Leasing, :NroPoliza, :IP, :CodigoModelo
	FROM	dbo.equipo
	WHERE	equi_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Equipos(" + String(ai_Codigo, '00000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
Else
	of_Asignado(ai_Codigo, ab_Mensaje, at_Transaccion)
END IF

RETURN lb_Retorno
end function

public function long of_cantidadserie (string as_codigo, boolean ab_mensaje, transaction at_transaccion);Long	ll_Retorno = 0

SELECT	IsNull(Count(equi_codigo), 0)
	INTO	:ll_Retorno
	FROM	dbo.equipo
	WHERE	(Upper(equi_nroser) = :as_Codigo
	      Or Upper(equi_nroint) = :as_Codigo)
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	ll_Retorno	=	-1
ELSEIF at_Transaccion.SQLCode = 100 THEN
	ll_Retorno	=	-1

	IF ab_Mensaje THEN
		MessageBox("Atención", " Numero de Serie de Equipo(" + as_Codigo + "), no esta en estado Activo, para ser Despachado.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN ll_Retorno
end function

public function boolean of_existeaca (string as_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	Distinct IsNull(equi_nroaca, '')
	Into	:ACA
	FROM	dbo.equipo
	WHERE	IsNull(equi_nroaca, '') = :as_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Equipos")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Equipos(" + as_Codigo + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_equipo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_equipo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

