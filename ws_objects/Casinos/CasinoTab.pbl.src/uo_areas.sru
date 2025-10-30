$PBExportHeader$uo_areas.sru
$PBExportComments$Objeto de Validación de Áreas
forward
global type uo_areas from nonvisualobject
end type
end forward

global type uo_areas from nonvisualobject
end type
global uo_areas uo_areas

type variables
Integer	Zona, Codigo
String	Nombre, Abreviacion
end variables

forward prototypes
public function boolean of_existe (integer ai_zona, string as_empresa, integer ai_area, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean of_existe (integer ai_zona, string as_empresa, integer ai_area, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	zona_codigo, caar_codigo, caar_nombre, caar_abrevi
	INTO	:Zona, :Codigo, :Nombre, :Abreviacion
	FROM	dbo.casino_areas
	WHERE	zona_codigo	=	:ai_zona
	AND 	caar_codigo	=	:ai_area
	And empr_codigo = :as_Empresa
	USING	at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Areas")
	
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "En la Zona no Existe el Area" + String(ai_area) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
end function

on uo_areas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_areas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

