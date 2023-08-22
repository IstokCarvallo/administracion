$PBExportHeader$uo_personacasino.sru
forward
global type uo_personacasino from nonvisualobject
end type
end forward

global type uo_personacasino from nonvisualobject
end type
global uo_personacasino uo_personacasino

type variables
String		cape_codigo, cape_apepat, cape_apemat, cape_nombre, cape_usuari
Integer		zona_codigo, caar_codigo, empr_codigo, cape_tipope, cape_invita, &
				cape_topein, cape_pedcas, cape_ctacte
end variables

forward prototypes
public function boolean existe (string as_usuario, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean existe (string as_usuario, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

  SELECT cape_codigo, cape_apepat, cape_apemat, cape_nombre, cape_usuari,
  			zona_codigo, caar_codigo, empr_codigo, cape_tipope, cape_invita, 
			cape_topein, cape_pedcas, cape_ctacte
	 INTO:cape_codigo,:cape_apepat,:cape_apemat,:cape_nombre,:cape_usuari,
  		  :zona_codigo,:caar_codigo,:empr_codigo,:cape_tipope,:cape_invita,
		  :cape_topein,:cape_pedcas,:cape_ctacte
	 FROM dbo.casino_personacolacion
	WHERE cape_usuari = :as_usuario
	USING at_transaccion;

IF at_transaccion.SqlCode = -1 THEN
	F_ErrorBaseDatos(at_transaccion,"Lectura de Tabla Personal Colación")
	lb_Retorno = False
ELSEIF at_transaccion.SQLCode = 100 THEN
	IF ab_mensaje	=	True THEN
		MessageBox("Atención", "Usuario " + as_usuario + ", no ha sido~r" + &
		"creado como administrador de grupo.~r~rIngrese con el usuario indicado.")
	END IF
	lb_Retorno = False
END IF

RETURN lb_Retorno
end function

on uo_personacasino.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_personacasino.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

