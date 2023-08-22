$PBExportHeader$uo_casino_tipocolacion.sru
forward
global type uo_casino_tipocolacion from nonvisualobject
end type
end forward

global type uo_casino_tipocolacion from nonvisualobject
end type
global uo_casino_tipocolacion uo_casino_tipocolacion

type variables
Integer	zona_codigo,  tico_codigo
String	tico_nombre,  tico_abrevi
end variables

forward prototypes
public function boolean existe (integer ai_zona, integer ai_tico, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_zona, integer ai_tico, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_retorno	=	True

  SELECT  zona_codigo,  tico_codigo,  tico_nombre,  tico_abrevi  
    INTO :zona_codigo, :tico_codigo, :tico_nombre, :tico_abrevi  
    FROM dbo.casino_tipocolacion
   WHERE zona_codigo =:ai_zona
  	  AND tico_codigo =:ai_tico
   USING at_transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Casino Tipo Colacion")
	lb_Retorno	=	False
	
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	IF ab_Mensaje THEN
		MessageBox("Atención", "En la Zona " + String(ai_zona) 					 	+ 	&
									  " no existe el tipo de colación " + String(ai_tico) 	+ 	&
									  ".~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

on uo_casino_tipocolacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_casino_tipocolacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

