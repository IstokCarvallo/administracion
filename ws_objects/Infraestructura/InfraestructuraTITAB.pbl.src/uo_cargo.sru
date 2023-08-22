$PBExportHeader$uo_cargo.sru
$PBExportComments$uo que Chequea la Existencia de Paises
forward
global type uo_cargo from nonvisualobject
end type
end forward

global type uo_cargo from nonvisualobject
end type
global uo_cargo uo_cargo

type variables
Integer 		Codigo, Imprimible
String  		Nombre
DateTime	Fecha
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	carg_codigo, carg_nombre
	INTO	:Codigo, :Nombre
	FROM	dbo.cargo
	WHERE	carg_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Cargos")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Cargos (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_cargo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_cargo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

