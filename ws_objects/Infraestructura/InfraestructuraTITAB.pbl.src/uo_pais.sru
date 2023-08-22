$PBExportHeader$uo_pais.sru
$PBExportComments$uo que Chequea la Existencia de Paises
forward
global type uo_pais from nonvisualobject
end type
end forward

global type uo_pais from nonvisualobject
end type
global uo_pais uo_pais

type variables
Integer Codigo, Correlativo
String  Nombre
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function integer correlativo (transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	pais_codigo, pais_nombre
	INTO	:Codigo, :Nombre
	FROM	dbo.pais
	WHERE	pais_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Paises")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Pais (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

public function integer correlativo (transaction at_transaccion);Integer	li_Retorno 

SELECT	IsNull(Count(pais_codigo), 0) + 1
	INTO	:Correlativo
	FROM	dbo.pais
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Paises")
	li_Retorno	=	0
Else
	li_Retorno	=	0
End If


Return li_Retorno
end function

on uo_pais.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_pais.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

