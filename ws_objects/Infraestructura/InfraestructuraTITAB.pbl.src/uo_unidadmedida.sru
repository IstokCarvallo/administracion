$PBExportHeader$uo_unidadmedida.sru
$PBExportComments$uo que Chequea la Existencia de Paises
forward
global type uo_unidadmedida from nonvisualobject
end type
end forward

global type uo_unidadmedida from nonvisualobject
end type
global uo_unidadmedida uo_unidadmedida

type variables
Integer 		Codigo
String  		Nombre, Simbolo
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	unme_codigo, unme_nombre, unme_simbol
	INTO	:Codigo, :Nombre, :Simbolo
	FROM	dbo.unidadmedida
	WHERE	unme_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Unidades de Medida")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Unidad de Medida (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_unidadmedida.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_unidadmedida.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

