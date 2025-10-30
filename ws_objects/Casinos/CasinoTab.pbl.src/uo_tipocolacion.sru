$PBExportHeader$uo_tipocolacion.sru
$PBExportComments$Objeto de Validación de Tipos de Colación
forward
global type uo_tipocolacion from nonvisualobject
End type
End forward

global type uo_tipocolacion from nonvisualobject
End type
global uo_tipocolacion uo_tipocolacion

type variables
Integer	Codigo, ZonaCol = 0
String	Nombre, Abreviacion
End variables

forward prototypes
public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existe (integer ai_zona, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_busqueda (transaction at_transaccion, integer zona)
public function integer of_secuencias (integer ai_tipocolacion, transaction at_transaccion)
End prototypes

public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT tico_codigo,tico_nombre,tico_abrevi
  INTO :Codigo,:Nombre,:Abreviacion
  FROM dbo.casino_tipocolacion
 WHERE tico_codigo	=	:ai_Codigo
	AND :ZonaCol in (0, zona_codigo)
 USING at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipos de Colación")
	
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "Código de Tipo de Colación " + String(ai_Codigo) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
End function

public function boolean of_existe (integer ai_zona, integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT tico_codigo,tico_nombre,tico_abrevi
  INTO :Codigo,:Nombre,:Abreviacion
  FROM dbo.casino_tipocolacion
 WHERE tico_codigo	=	:ai_Codigo
	AND zona_codigo = :ai_zona
 USING at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipos de Colación")
	
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "Código de Tipo de Colación " + String(ai_Codigo) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
End function

public function boolean of_busqueda (transaction at_transaccion, integer zona);Boolean			lb_Retorno	=	False
Str_Busqueda	lstr_Busq

lstr_Busq.Argum[1]	= String(Zona)
OpenWithParm(w_busc_tipocolacion, lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.argum) > 1 Then
	If lstr_Busq.argum[1] <> "" Then
		ZonaCol	=	Zona
		of_Existe(Zona, Integer(lstr_Busq.Argum[1]), False, at_Transaccion)
		
		lb_Retorno	=	True
	End If
End If

Return lb_Retorno
End function

public function integer of_secuencias (integer ai_tipocolacion, transaction at_transaccion);Integer	li_Secuencias

SELECT	IsNull(Max(caco_codigo), 0)
	INTO	:li_Secuencias
	FROM	dbo.casino_colaciones
	WHERE	tico_codigo	=	:ai_TipoColacion
	USING	at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Colaciones")
	
	li_Secuencias	=	0
End If

Return li_Secuencias
End function

on uo_tipocolacion.create
call super::create
TriggerEvent( this, "constructor" )
End on

on uo_tipocolacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
End on

