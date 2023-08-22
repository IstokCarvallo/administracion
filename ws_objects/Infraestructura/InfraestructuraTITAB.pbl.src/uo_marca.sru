$PBExportHeader$uo_marca.sru
$PBExportComments$uo que Chequea la Existencia de Paises
forward
global type uo_marca from nonvisualobject
end type
end forward

global type uo_marca from nonvisualobject
end type
global uo_marca uo_marca

type variables
Integer Codigo, Correlativo
String  Nombre
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	marc_codigo, marc_nombre
	INTO	:Codigo, :Nombre
	FROM	dbo.marca
	WHERE	marc_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Marcas")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Marca (" + String(ai_codigo, '00') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_marca.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_marca.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

