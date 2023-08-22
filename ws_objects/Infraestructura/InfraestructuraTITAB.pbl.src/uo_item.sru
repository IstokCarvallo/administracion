$PBExportHeader$uo_item.sru
$PBExportComments$uo que Chequea la Existencia de Paises
forward
global type uo_item from nonvisualobject
end type
end forward

global type uo_item from nonvisualobject
end type
global uo_item uo_item

type variables
Integer 		Codigo, Imprimible
String  		Nombre
DateTime	Fecha
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	item_codigo, item_nombre, item_feccom, IsNull(item_imprim, 0)
	INTO	:Codigo, :Nombre, :Fecha, :Imprimible
	FROM	dbo.item
	WHERE	item_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Item")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Item (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_item.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_item.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

