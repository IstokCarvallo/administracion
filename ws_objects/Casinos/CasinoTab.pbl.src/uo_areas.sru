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
public function boolean busqueda (transaction at_transaccion)
public function boolean existe (integer ai_zona, integer ai_area, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean busqueda (transaction at_transaccion);Boolean			lb_Retorno	=	False
//Str_Busqueda	lstr_Busq
//
//OpenWithParm(w_busc_rgto_tiposeventosenca, lstr_Busq)
//
//lstr_Busq	= Message.PowerObjectParm
//
//IF lstr_Busq.argum[1] <> "" THEN
//	Existe(Integer(lstr_Busq.Argum[1]), False, at_Transaccion)
//	
//	lb_Retorno	=	True
//END IF
//
RETURN lb_Retorno
end function

public function boolean existe (integer ai_zona, integer ai_area, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	zona_codigo, caar_codigo, caar_nombre, caar_abrevi
	INTO	:Zona, :Codigo, :Nombre, :Abreviacion
	FROM	dbo.casino_areas
	WHERE	zona_codigo	=	:ai_zona
	AND 	caar_codigo	=	:ai_area
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Areas")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "En la Zona no Existe el Area" + String(ai_area) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
END IF

RETURN lb_Retorno
end function

on uo_areas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_areas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

