$PBExportHeader$uo_tipomovto.sru
$PBExportComments$Objeto de Validación de comunas
forward
global type uo_tipomovto from nonvisualobject
end type
end forward

global type uo_tipomovto from nonvisualobject
end type
global uo_tipomovto uo_tipomovto

type variables
Integer	Codigo, Sentido, TipoTraslado, TipoDespacho, SolicitaDestino, Estado, EmiteGuia, CreaEquipo
String		Nombre, Glosa
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	tpmv_codigo, tpmv_nombre, tpmv_sentid, tpmv_tipotr, tpmv_tipode, tpmv_soldes, tpmv_glosas, 
			tpmv_estado, IsNull(tpmv_emigde, 0), IsNull(tpmv_creaeq, 0)
	INTO	:Codigo, :Nombre, :Sentido, :TipoTraslado, :TipoDespacho, :SolicitaDestino, :Glosa, 
			:Estado, :EmiteGuia, :CreaEquipo
	FROM	dbo.tipomovimiento
	WHERE	tpmv_codigo = :ai_Codigo
	USING	at_Transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Tipo Movimiento.")

	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Tipo Movimiento" + String(ai_Codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	END IF
END IF

RETURN lb_Retorno
end function

on uo_tipomovto.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_tipomovto.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

