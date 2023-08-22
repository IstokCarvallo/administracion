$PBExportHeader$uo_casino_colacion.sru
forward
global type uo_casino_colacion from nonvisualobject
end type
end forward

global type uo_casino_colacion from nonvisualobject
end type
global uo_casino_colacion uo_casino_colacion

type variables
Integer	zona_codigo,  tico_codigo,  caco_codigo
String	caco_nombre,  caco_abrevi
end variables

forward prototypes
public function boolean existe (integer ai_zona, integer ai_tico, integer ai_caco, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_zona, integer ai_tico, integer ai_caco, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_retorno	=	True

  SELECT  zona_codigo,  tico_codigo,  caco_codigo,  caco_nombre,  caco_abrevi  
    INTO :zona_codigo, :tico_codigo, :caco_codigo, :caco_nombre, :caco_abrevi  
    FROM dbo.casino_colaciones
   WHERE zona_codigo =:ai_zona
  	  AND tico_codigo =:ai_tico
  	  AND caco_codigo =:ai_caco
   USING at_transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Casino Colaciones")
	lb_Retorno	=	False
	
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	IF ab_Mensaje THEN
		MessageBox("Atención", "En la Zona " + String(ai_zona) 					 	+ 	&
									  " para el tipo de colación " + String(ai_tico) 	+ 	&
									  ", no existe la colación "  + String(ai_caco) 	+	&
									  ".~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

on uo_casino_colacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_casino_colacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

