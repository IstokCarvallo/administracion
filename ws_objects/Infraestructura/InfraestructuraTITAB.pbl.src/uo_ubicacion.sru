$PBExportHeader$uo_ubicacion.sru
$PBExportComments$uo que Chequea la Existencia de Ubicaciones
forward
global type uo_ubicacion from nonvisualobject
end type
end forward

global type uo_ubicacion from nonvisualobject
end type
global uo_ubicacion uo_ubicacion

type variables
Integer Codigo, Correlativo
String  Nombre
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	ubic_codigo, ubic_nombre
	INTO	:Codigo, :Nombre
	FROM	dbo.ubicacion
	WHERE	ubic_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Ubicaciones")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Ubicacion (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_ubicacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_ubicacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

