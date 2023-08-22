$PBExportHeader$uo_personal.sru
$PBExportComments$uo que Chequea la Existencia de Proveedores
forward
global type uo_personal from nonvisualobject
end type
end forward

global type uo_personal from nonvisualobject
end type
global uo_personal uo_personal

type variables
Integer Sucursal, Seccion, Empresa, Anexo, Tipo
String  Codigo, Rut, Nombre, Apellido, Correo, NombreCompleto
end variables

forward prototypes
public function boolean existe (string as_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (string as_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True



SELECT	pers_codigo, sucu_codigo, secc_codigo, empr_codigo, pers_nrorut, 
			pers_nombre, pers_apellido, pers_anexo, pers_correo, pers_tipper 
	INTO	:Codigo, :Sucursal, :Seccion, :Empresa, :Rut, 
			:Nombre, :Apellido, :Anexo, :Correo, :Tipo
	FROM	dbo.personal
	WHERE	pers_codigo	=	:as_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Personal")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de personal (" + as_codigo + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

NombreCompleto = Nombre + ' ' + Apellido

RETURN lb_Retorno

end function

on uo_personal.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_personal.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

