$PBExportHeader$uo_monedas.sru
$PBExportComments$uo que Chequea la Existencia de Monedas
forward
global type uo_monedas from nonvisualobject
end type
end forward

global type uo_monedas from nonvisualobject
end type
global uo_monedas uo_monedas

type variables
Integer Codigo
String  Nombre, Simbolo
end variables

forward prototypes
public function boolean existe (integer ai_moneda, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_moneda, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	mone_codigo, mone_nombre, mone_simbol
	INTO	:Codigo, :Nombre, :Simbolo
	FROM	dbo.Moneda
	WHERE	mone_codigo	=	:ai_Moneda
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Monedas")

	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	If ab_Mensaje THEN
		MessageBox("Atención", "Código de Moneda (" + String(ai_moneda, '00')+ &
						"), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

Return lb_Retorno

end function

on uo_monedas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_monedas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

