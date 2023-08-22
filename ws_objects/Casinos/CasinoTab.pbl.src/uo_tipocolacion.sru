$PBExportHeader$uo_tipocolacion.sru
$PBExportComments$Objeto de Validación de Tipos de Colación
forward
global type uo_tipocolacion from nonvisualobject
end type
end forward

global type uo_tipocolacion from nonvisualobject
end type
global uo_tipocolacion uo_tipocolacion

type variables
Integer	Codigo, ZonaCol = 0
String	Nombre, Abreviacion
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function integer secuencias (integer ai_tipocolacion, transaction at_transaccion)
public function boolean busqueda (transaction at_transaccion, integer zona)
public function boolean existe (integer ai_zona, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT tico_codigo,tico_nombre,tico_abrevi
  INTO :Codigo,:Nombre,:Abreviacion
  FROM dbo.casino_tipocolacion
 WHERE tico_codigo	=	:ai_Codigo
	AND :ZonaCol in (0, zona_codigo)
 USING at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipos de Colación")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Tipo de Colación " + String(ai_Codigo) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

public function integer secuencias (integer ai_tipocolacion, transaction at_transaccion);Integer	li_Secuencias

SELECT	IsNull(Max(caco_codigo), 0)
	INTO	:li_Secuencias
	FROM	dbo.casino_colaciones
	WHERE	tico_codigo	=	:ai_TipoColacion
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Colaciones")
	
	li_Secuencias	=	0
END IF

RETURN li_Secuencias
end function

public function boolean busqueda (transaction at_transaccion, integer zona);Boolean			lb_Retorno	=	False
Str_Busqueda	lstr_Busq

lstr_Busq.Argum[1]	= String(Zona)
OpenWithParm(w_busc_tipocolacion, lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.argum) > 1 Then
	IF lstr_Busq.argum[1] <> "" THEN
		ZonaCol	=	Zona
		Existe(Zona, Integer(lstr_Busq.Argum[1]), False, at_Transaccion)
		
		lb_Retorno	=	True
	END IF
End If

RETURN lb_Retorno
end function

public function boolean existe (integer ai_zona, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT tico_codigo,tico_nombre,tico_abrevi
  INTO :Codigo,:Nombre,:Abreviacion
  FROM dbo.casino_tipocolacion
 WHERE tico_codigo	=	:ai_Codigo
	AND zona_codigo = :ai_zona
 USING at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipos de Colación")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Tipo de Colación " + String(ai_Codigo) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

on uo_tipocolacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_tipocolacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

