$PBExportHeader$uo_personacasino.sru
forward
global type uo_personacasino from nonvisualobject
end type
end forward

global type uo_personacasino from nonvisualobject
end type
global uo_personacasino uo_personacasino

type variables
String		Rut, Paterno, Materno, Nombre, Usuario, Empresa
Integer	Zona, Area, TipoPedido, Invita, TopeInvita, PedidoCasino, CtaCte
end variables

forward prototypes
public function boolean of_existe (string as_usuario, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean of_existe (string as_usuario, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

  SELECT cape_codigo, cape_apepat, cape_apemat, cape_nombre, cape_usuari,
  			zona_codigo, caar_codigo, empr_codigo, cape_tipope, IsNull(cape_invita, 0),  
			IsNull(cape_topein, 0), IsNull(cape_pedcas, 0), IsNull(cape_ctacte, 0)
	 INTO:Rut,:Paterno,:Materno,:Nombre,:Usuario,
  		  :Zona, :Area, :Empresa, :TipoPedido, :Invita,
		  :TopeInvita,:PedidoCasino,:CtaCte
	 FROM dbo.casino_personacolacion
	WHERE cape_usuari = :as_usuario
	USING at_transaccion;

If at_transaccion.SqlCode = -1 Then
	F_ErrorBaseDatos(at_transaccion,"Lectura de Tabla Personal Colación")
	lb_Retorno = False
ElseIf at_transaccion.SQLCode = 100 Then
	If ab_mensaje	=	True Then
		MessageBox("Atención", "Usuario " + as_usuario + ", no ha sido~r creado como administrador.~r~rIngrese con el usuario indicado.")
	End If
	lb_Retorno = False
End If

Return lb_Retorno
end function

on uo_personacasino.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_personacasino.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

