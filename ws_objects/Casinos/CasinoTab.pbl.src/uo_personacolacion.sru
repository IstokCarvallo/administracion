$PBExportHeader$uo_personacolacion.sru
$PBExportComments$Objeto de Validación de Personal de Colación
forward
global type uo_personacolacion from nonvisualobject
end type
end forward

global type uo_personacolacion from nonvisualobject
end type
global uo_personacolacion uo_personacolacion

type variables
Integer	ZonaCodigo, AreaCodigo, EmpresaCodigo, TipoPersonal, &
			Invitador, TopeInvitados, PedidoCasino, AplicaCtaCte
String		Codigo, ApellidoPat, ApellidoMat, Nombres, Usuario, NombreCompleto
end variables

forward prototypes
public function boolean existe (string as_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean busqueda (transaction at_transaccion)
end prototypes

public function boolean existe (string as_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	cape_codigo, cape_apepat, cape_apemat, cape_nombre,
			cape_usuari, zona_codigo, caar_codigo, empr_codigo,
			cape_tipope, cape_invita, cape_topein, cape_pedcas,
			cape_ctacte
	INTO	:Codigo, :ApellidoPat, :ApellidoMat, :Nombres,
			:Usuario, :ZonaCodigo, :AreaCodigo, :EmpresaCodigo,
			:TipoPersonal, :Invitador, :TopeInvitados, :PedidoCasino,
			:AplicaCtaCte
	FROM	dbo.casino_personacolacion
	WHERE	cape_codigo	=	:as_Codigo
	USING	at_Transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Personal de Colación")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False

	IF ab_Mensaje THEN
		MessageBox("Atención", "Código de Personal " + as_Codigo + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	END IF
ELSE
	NombreCompleto	=	Nombres + " " + ApellidoPat + " " + ApellidoMat
END IF

RETURN lb_Retorno
end function

public function boolean busqueda (transaction at_transaccion);Boolean			lb_Retorno	=	False
Str_Busqueda	lstr_Busq

OpenWithParm(w_busc_personacolacion, lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.Argum) > 2 Then
	IF lstr_Busq.argum[1] <> "" THEN
		Existe(lstr_Busq.Argum[1], False, at_Transaccion)
		
		lb_Retorno	=	True
	END IF
End If

RETURN lb_Retorno	
end function

on uo_personacolacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_personacolacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

