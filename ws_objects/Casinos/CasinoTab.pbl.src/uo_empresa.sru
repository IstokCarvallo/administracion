$PBExportHeader$uo_empresa.sru
$PBExportComments$Objeto de empresas
forward
global type uo_empresa from nonvisualobject
end type
end forward

global type uo_empresa from nonvisualobject
end type
global uo_empresa uo_empresa

type variables
String		Rut, Nombre, Direccion
Integer	Base
end variables

forward prototypes
public function boolean of_existe (string codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean of_existe (string codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

Select empr_codigo, empr_nombre, empr_direcc, IsNull(empr_standa, 0)
	INTO	:Rut, :Nombre, :Direccion, :Base
	From dbo.empresas
	Where empr_codigo = :Codigo
	USING	at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Empresas")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "No Existe el Rut Empresa " + Codigo + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
end function

on uo_empresa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_empresa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

