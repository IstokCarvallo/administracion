$PBExportHeader$uo_pedidos.sru
$PBExportComments$Objeto de Validación de Tipos de Colación
forward
global type uo_pedidos from nonvisualobject
end type
end forward

global type uo_pedidos from nonvisualobject
end type
global uo_pedidos uo_pedidos

type variables
Integer	Zona, TipoColacion, Estado
String		Persona
Long		Numero
Date		Fecha
Time		Hora
end variables

forward prototypes
public function boolean existe (integer ai_zona, long al_numero, boolean ab_mensaje, transaction at_transaccion)
public function long ultimopedido (integer ai_zona, transaction at_transaccion)
public function boolean busqueda (transaction at_transaccion, integer ai_zona)
end prototypes

public function boolean existe (integer ai_zona, long al_numero, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	zona_codigo, pcen_numero, cape_codigo, tico_codigo, 
			pcen_fechap,  pcen_horape, pcen_estado
	INTO	:Zona, :Numero, :Persona, :TipoColacion,
			:Fecha, :Hora, :Estado
	FROM	dbo.casino_PedidosEncab
	WHERE	zona_codigo	=	:ai_Zona
	AND	pcen_numero	=	:al_Numero
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipos de Colación")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Pedido" + String(al_Numero) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

public function long ultimopedido (integer ai_zona, transaction at_transaccion);Long	ll_UltimoPedido

SELECT	IsNull(Max(pcen_numero), 0)
	INTO	:ll_UltimoPedido
	FROM	dbo.casino_PedidosEncab
	WHERE	zona_codigo	=	:ai_Zona
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Pedidos de Colación")
END IF

RETURN ll_UltimoPedido
end function

public function boolean busqueda (transaction at_transaccion, integer ai_zona);Boolean			lb_Retorno	=	False
Str_Busqueda	lstr_Busq

lstr_Busq.Argum[1]	=	String(ai_Zona)

OpenWithParm(w_busc_pedidos, lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.Argum) > 2 Then
	IF lstr_Busq.argum[1] <> "" THEN
		Existe(Integer(lstr_Busq.Argum[1]), Long(lstr_Busq.Argum[2]), False, at_Transaccion)
		
		lb_Retorno	=	True
	END IF
End If

RETURN lb_Retorno
end function

on uo_pedidos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_pedidos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

