$PBExportHeader$uo_servicio.sru
$PBExportComments$uo que Chequea la Existencia de Servicios
forward
global type uo_servicio from nonvisualobject
end type
end forward

global type uo_servicio from nonvisualobject
end type
global uo_servicio uo_servicio

type variables
Integer 		Codigo, Moneda
String  		Nombre
Dec{2}		Valor, Tiempo
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	serv_codigo, serv_nombre, serv_valor, serv_tiepro, mone_codigo
	INTO	:Codigo, :Nombre, :Valor, :Tiempo, :Moneda
	FROM	dbo.servicio
	WHERE	serv_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Servicios")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Servicio (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_servicio.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_servicio.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

