$PBExportHeader$uo_proveedor.sru
$PBExportComments$uo que Chequea la Existencia de Proveedores
forward
global type uo_proveedor from nonvisualobject
end type
end forward

global type uo_proveedor from nonvisualobject
end type
global uo_proveedor uo_proveedor

type variables
Integer 		Codigo, Pais, Region, Comuna
String  		Rut, Nombre, Telefono, Correo, Contacto, Direccion, Giro
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	prov_codigo, prov_nrorut, prov_nombre, prov_telefo, prov_correo, prov_contac, 
			prov_direcc, prov_giroem, pais_codigo, regi_codigo, comu_codigo
	INTO	:Codigo, :Rut, :Nombre, :Telefono, :Correo, :Contacto, 
			:Direccion, :Giro, :Pais, :Region, :Comuna
	FROM	dbo.proveedor
	WHERE	prov_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Proveedores")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de proveedor (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

on uo_proveedor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_proveedor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

