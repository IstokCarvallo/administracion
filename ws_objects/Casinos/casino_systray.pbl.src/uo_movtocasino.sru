$PBExportHeader$uo_movtocasino.sru
forward
global type uo_movtocasino from nonvisualobject
end type
end forward

global type uo_movtocasino from nonvisualobject
end type
global uo_movtocasino uo_movtocasino

type variables
String		cape_codigo, camv_appain, camv_apmain, camv_nominv, camv_rutinv, NomComp
Integer	zona_codigo, caar_codigo, camv_secuen, tico_codigo, &
			caco_codigo, camv_tipope, camv_tdieta, camv_estado, camv_invcur
Date		camv_fechac
Time		camv_horaco

Integer	zona_codigot, evct_secuent, evct_cantidt, caar_codigot, tico_codigot, vact_ubicact, ii_secuencia
Long		evct_nroinit, evct_nrotert
String 	clpr_rutt
Date		evct_fechaet, evct_fechavt
Time		evct_horaivt, evct_horatvt, cahc_horinit
end variables

forward prototypes
public function boolean existeenfecha (string as_rut, integer ai_colacion, date ad_fecha, boolean ab_mensaje, transaction at_transaccion)
public function integer secuenciamax (date ad_fecha, transaction at_transaccion)
public function boolean existeminimo (long al_rango, string as_contratista, integer ai_zona, boolean ab_mensaje, transaction at_transaccion)
public function boolean existemaximo (long al_rango, string as_contratista, integer ai_zona, boolean ab_mensaje, transaction at_transaccion)
public function boolean existeenrango (long al_rangoini, long al_rangoter, string as_contratista, integer ai_vales, integer ai_zona, boolean ab_mensaje, transaction at_transaccion)
public function boolean creamovto (string as_tarjeta, integer ai_colacion, date ad_fecha)
public function boolean existetarjeta (string as_rut, string as_nrotarjeta, date ad_fecha, integer ai_colacion, boolean ab_mensaje, transaction at_transaccion)
public function integer secuenciamax (date ad_fecha, integer ai_zona, integer ai_area, transaction at_transaccion)
end prototypes

public function boolean existeenfecha (string as_rut, integer ai_colacion, date ad_fecha, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_retorno = True
String		ls_etiqueta, ls_rut, ls_Zona, ls_Tarjeta
Integer	li_secuencia
Long		ll_Tarjeta

ls_etiqueta	= 	Mid(as_rut, 1, 3)
ls_rut			=	Mid(as_rut, 7, 10)

If Len(ls_rut) < 7 Then ls_etiqueta = 'INV'

If ls_etiqueta = 'CTT' Then
	ls_Zona		=	Mid(as_rut, 4, 3)
	ls_rut			=	Mid(as_rut, 7, 10)
	ls_Tarjeta	=	Mid(as_rut, 17, 8)
	//CTT009096968120K00000005
	lb_retorno = ExisteTarjeta(ls_rut, ls_Tarjeta, ad_fecha, ai_colacion, ab_mensaje, at_transaccion)
	
	ll_Tarjeta = Long(ls_Tarjeta)
	
	SELECT IsNull(Max(camv_estado), 0)
	  INTO :camv_estado
	  FROM dbo.casino_movtocolaciones
	 WHERE ( (:ls_rut = cape_codigo AND camv_invcur = 0) 
	 		OR (:ls_rut = camv_rutinv AND camv_invcur = 1) )
		AND camv_fechac	=:ad_fecha
		AND tico_codigo 	=:ai_colacion
		And camv_nroval	= :ll_Tarjeta
	 USING at_transaccion;
	 
	 If at_Transaccion.SQLCode = -1 Then
		F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Movimientos de Colación")
		lb_Retorno	=	False
	Else
		If camv_estado <> 1 Then
			If camv_estado = 9 Then
				w_movto_casinos_systray.st_Mensaje.Text = "La persona cuyo rut esta ingresando, ya efectuo el movto. correspondiente a este horario."
				lb_retorno	=	False
			End If
		End If
	End If	 
	 
	If lb_retorno Then
		ii_secuencia	=	secuenciaMax(ad_fecha, at_transaccion)
		
		  INSERT INTO dbo.casino_movtocolaciones( zona_codigo,  caar_codigo,  camv_fechac,  camv_secuen, camv_horaco,  cape_codigo,  
		  										tico_codigo,  caco_codigo,camv_tipope,  camv_tdieta,  camv_appain, camv_apmain,
												camv_nominv,  camv_estado,  camv_rutinv,  camv_invcur, clpr_rut, camv_nroval) 
			VALUES (:zona_codigot,:caar_codigot,:ad_fecha, :ii_secuencia,   :cahc_horinit, :clpr_rutt,
					:tico_codigot, 1, 1, Null,Null,Null,
					Null, 9, Null,0, :clpr_rutt,:ls_Tarjeta) 
			using at_transaccion ;
			 
			 If at_Transaccion.SQLCode <> 0 Then
				F_ErrorBaseDatos(at_Transaccion, "Grabación en Tabla Movimientos de Colación")
				Rollback;
				lb_Retorno	=	False
			Else
				Commit;
			End If
	End If
Else
	ls_rut			=	Mid(as_rut, 4)

	SELECT zona_codigo, caar_codigo, camv_fechac, camv_secuen, 
			 camv_horaco, cape_codigo, tico_codigo, caco_codigo, 
			 camv_tipope, camv_tdieta, camv_appain, camv_apmain, 
			 camv_nominv, camv_estado, camv_rutinv, camv_invcur
	  INTO:zona_codigo,:caar_codigo,:camv_fechac,:camv_secuen, 
			:camv_horaco,:cape_codigo,:tico_codigo,:caco_codigo, 
			:camv_tipope,:camv_tdieta,:camv_appain,:camv_apmain, 
			:camv_nominv,:camv_estado,:camv_rutinv,:camv_invcur
	  FROM dbo.casino_movtocolaciones
	 WHERE ( (:ls_rut = cape_codigo AND camv_invcur = 0) 
	 		OR (:ls_rut = camv_rutinv AND camv_invcur = 1) )
		AND camv_fechac =:ad_fecha
		AND tico_codigo =:ai_colacion
	 USING at_transaccion;
	
	If at_Transaccion.SQLCode = -1 Then
		F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Movimientos de Colación")
		lb_Retorno	=	False
	ElseIf at_Transaccion.SQLCode = 100 Then
		If Not CreaMovto(as_rut, ai_colacion, ad_fecha) Then
			lb_Retorno	=	False
		
			If ab_Mensaje Then
				w_movto_casinos_systray.st_Mensaje.Text = "Código de Personal " + ls_rut + ", no ha sido Asignado al movimiento actual."
			End If
		Else	
			lb_Retorno	=	True
		End If	
	Else
		ii_secuencia	=	camv_secuen
		If camv_estado <> 1 Then
			If camv_estado = 9 Then
				w_movto_casinos_systray.st_Mensaje.Text = "La persona cuyo rut esta ingresando, ya efectuo el movto. correspondiente a este horario."
			End If
			lb_retorno	=	False
		End If
	End If
End If

RETURN lb_Retorno
end function

public function integer secuenciamax (date ad_fecha, transaction at_transaccion);Integer	li_secuencia

select max(IsNull(camv_secuen, 0))
  into :li_secuencia from dbo.casino_movtocolaciones
 where zona_codigo =: zona_codigot
   and caar_codigo =: caar_codigot
	and camv_fechac =: ad_fecha using at_transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Movimientos de Colación")
	Return 0
ELSE
	IF IsNull(li_secuencia) THEN li_secuencia = 0
	Return li_secuencia + 1
END IF
end function

public function boolean existeminimo (long al_rango, string as_contratista, integer ai_zona, boolean ab_mensaje, transaction at_transaccion);Integer	li_filas
Boolean 	lb_retorno	=	True


SELECT Count(*)
  INTO :li_filas
  FROM dbo.casino_valescontratista
 WHERE zona_codigo =: ai_zona
 	AND clpr_rut	 =: as_contratista
	AND vact_numero >=:al_rango
 USING at_transaccion;
 
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Vales Contratista")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		w_movto_casinos_systray.st_Mensaje.Text = "Número de vale " + String(al_rango) + ", No es un codigo valido para el rango de vales a entregar."
	END IF
END IF

Return lb_retorno
end function

public function boolean existemaximo (long al_rango, string as_contratista, integer ai_zona, boolean ab_mensaje, transaction at_transaccion);Integer	li_filas
Boolean 	lb_retorno	=	True


SELECT Count(*)
  INTO :li_filas
  FROM dbo.casino_valescontratista
 WHERE zona_codigo =: ai_zona
 	AND clpr_rut	 =: as_contratista
	AND vact_numero <=:al_rango
 USING at_transaccion;
 
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Vales Contratista")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		w_movto_casinos_systray.st_Mensaje.Text = "Número de vale " + String(al_rango) + ", No es un codigo valido para el rango de vales a entregar."
	END IF
END IF

Return lb_retorno
end function

public function boolean existeenrango (long al_rangoini, long al_rangoter, string as_contratista, integer ai_vales, integer ai_zona, boolean ab_mensaje, transaction at_transaccion);Integer	li_filas
Boolean 	lb_retorno	=	True


SELECT Count(*)
  INTO :li_filas
  FROM dbo.casino_valescontratista
 WHERE zona_codigo =: ai_zona
 	AND clpr_rut	 =: as_contratista
	AND vact_numero <=:al_rangoter
	AND vact_numero >=:al_rangoini
	AND vact_ubicac = 1
 USING at_transaccion;
 
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Vales Contratista")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		w_movto_casinos_systray.st_Mensaje.Text = "Número de vale " + String(ai_vales) + ", No es un codigo valido para el rango de vales a entregar."
	END IF
ELSEIF ai_vales <> li_filas THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		w_movto_casinos_systray.st_Mensaje.Text = "El rango ingresado no abarca la cantidad de " + String(ai_vales) + " Vales."
	END IF
END IF

Return lb_retorno
end function

public function boolean creamovto (string as_tarjeta, integer ai_colacion, date ad_fecha);String	ls_pers_codigo, ls_pers_apepat, ls_pers_apemat, ls_pers_nombre, ls_tarjinv
Long		ll_pers_nrotar
Integer	li_tico_codigo, li_zona, li_area, li_zonatrans, li_areatrans
Time		lt_cahc_horini
str_mant	lstr_mant

ll_pers_nrotar	=	1
as_tarjeta = Mid(as_tarjeta, 4)

SELECT DISTINCT tico_codigo,  cahc_horini
  INTO :li_tico_codigo, :lt_cahc_horini
  FROM dbo.casino_horariocolaciones
 WHERE convert(time, GetDate()) between cahc_horini and cahc_horter
	AND Getdate() between cahc_fecini and cahc_fecter
    AND datepart(dw, GetDate()) = cahc_nrodia;
	
If sqlca.SQLCode = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla RemuPersonal")
ElseIf sqlca.SQLCode = 100 OR IsNull(li_tico_codigo) Then
	w_movto_casinos_systray.st_Mensaje.Text = "No existe colación alguna asignada a este horario"
	Return False
Else
	SELECT zona_codigo,  caar_codigo
	  INTO :li_zonatrans,:li_areatrans
	  FROM dbo.Casino_PersonaColacion
	 WHERE cape_codigo =:as_tarjeta
	 USING sqlca;
	
	IF sqlca.SQLCode = -1 Then
		F_ErrorBaseDatos(sqlca, "Lectura de Tabla Casino_PersonaColacion")
		Return False
	ELSEIF sqlca.SQLCode = 100 Then
//		F_ErrorBaseDatos(sqlca, "Lectura de Tabla Casino_PersonaColacion, Persona no ha sido asignada.")
//		Return False
	ELSEIF sqlca.SQLCode <> 100 Then
		zona_codigot	=	li_zonatrans
		caar_codigot	=	li_areatrans
	END IF
	
	SELECT  pers_codigo, 	 pers_apepat, 		pers_apemat,  pers_nombre, 	 pers_nrotar
	  INTO :ls_pers_codigo, :ls_pers_apepat, :ls_pers_apemat, :ls_pers_nombre, :ll_pers_nrotar
	  FROM dbo.remupersonal
	 WHERE :as_tarjeta IN (pers_codigo)
	 USING sqlca;
	
	If sqlca.SQLCode = -1 Then
		F_ErrorBaseDatos(sqlca, "Lectura de Tabla RemuPersonal")
		Return False
	ElseIf sqlca.SQLCode = 100 Then
		lstr_mant.Argumento[1]	=	String(li_tico_codigo)
		lstr_mant.Argumento[2]	=	String(lt_cahc_horini)
		lstr_mant.Argumento[3]	=	""

		OpenWithParm(w_mant_tarjeta_anfitrion, lstr_mant)

		lstr_mant	=	Message.PowerObjectParm
		
		If UpperBound(lstr_mant.Argumento) > 3 AND IsNumber(lstr_mant.Argumento[10]) Then
			ii_secuencia		=	SecuenciaMax(ad_fecha, Integer(lstr_mant.Argumento[11]), Integer(lstr_mant.Argumento[12]), sqlca)
			ls_pers_codigo	=	lstr_mant.Argumento[4]
			li_zona			=	Integer(lstr_mant.Argumento[11])
			li_area			=	Integer(lstr_mant.Argumento[12])
			
			If Not IsNumber(Left(as_tarjeta, 1)) Then
				ls_tarjinv		=	Right(as_tarjeta, Len(as_tarjeta) - 3)
			Else
				ls_tarjinv		=	as_tarjeta
			End If
			
			INSERT INTO dbo.casino_movtocolaciones( zona_codigo,  caar_codigo,  camv_fechac,  camv_secuen,camv_horaco,  cape_codigo,  
											tico_codigo,  caco_codigo,camv_tipope,  camv_tdieta,  camv_appain,  camv_apmain,
											camv_nominv,  camv_estado,  camv_rutinv,  camv_invcur,clpr_rut,camv_nroval) 
				VALUES  (:li_zona,     :li_area,    :ad_fecha,    :ii_secuencia,   :lt_cahc_horini,:ls_pers_codigo,
							:li_tico_codigo, 1,  1, Null, 'Invitado Generico','',
							'', 9, :ls_tarjinv, 1, :ls_pers_codigo, Null) 
				Using sqlca;

			If sqlca.SQLCode <> 0 Then
				F_ErrorBaseDatos(sqlca, "Grabación en Tabla Movimientos de Colación")
				Rollback;
				Return False
			Else
				Commit;
				Return True
			End If
		Else
			If UpperBound(lstr_mant.Argumento) = 99 Then w_movto_casinos_systray.St_Mensaje.Text = lstr_mant.Argumento[99]
			
		End If
	Else
		ii_secuencia	=	SecuenciaMax(ad_fecha, sqlca)

		INSERT INTO dbo.casino_movtocolaciones ( zona_codigo,  caar_codigo,  camv_fechac,  camv_secuen, camv_horaco,  cape_codigo,  
											tico_codigo,  caco_codigo, camv_tipope,  camv_tdieta,  camv_appain,  camv_apmain,
											camv_nominv,  camv_estado,  camv_rutinv,  camv_invcur,clpr_rut, camv_nroval) 
			VALUES  (:zona_codigot,:caar_codigot, :ad_fecha,    :ii_secuencia, :lt_cahc_horini,:ls_pers_codigo, 
						:li_tico_codigo, 1, 1, Null, Null, Null,
						Null, 9, Null, 0, :ls_pers_codigo, Null)
			Using sqlca ;

		 If sqlca.SQLCode <> 0 Then
			F_ErrorBaseDatos(sqlca, "Grabación en Tabla Movimientos de Colación")
			Rollback;
			Return False
		Else
			Commit;
			Return True
		End If
	End If
End If

Return True
end function

public function boolean existetarjeta (string as_rut, string as_nrotarjeta, date ad_fecha, integer ai_colacion, boolean ab_mensaje, transaction at_transaccion);Long		ll_tarjeta
Integer	li_colacion
Boolean	lb_Retorno = True
String 	ls_mensaje

ll_tarjeta	=	Long(as_nrotarjeta)

  SELECT cev.zona_codigo, cev.clpr_rut,		cev.evct_fechae, cev.evct_secuen,
         cev.evct_fechav, cev.evct_horaiv,	cev.evct_horatv, cev.evct_cantid,
         cev.evct_nroini, cev.evct_nroter, 	cev.caar_codigo, cvc.vact_ubicac
    INTO:zona_codigot,	 :clpr_rutt, 		  :evct_fechaet,	 :evct_secuent,
        :evct_fechavt,	 :evct_horaivt,	  :evct_horatvt,	 :evct_cantidt,
        :evct_nroinit,	 :evct_nrotert,	  :caar_codigot, 	 :vact_ubicact
    FROM dbo.casino_entregavales as cev, dbo.casino_valescontratista as cvc
	WHERE :ll_tarjeta between cev.evct_nroini and cev.evct_nroter
	  AND cev.evct_fechav	= 	:ad_fecha
	  AND cev.zona_codigo	=	cvc.zona_codigo
	  AND cev.clpr_rut		=	cvc.clpr_rut
	  AND cvc.vact_numero	=	:ll_tarjeta
	  AND cev.clpr_rut		= 	:as_Rut
	  AND cev.tico_codigo	=	:ai_colacion
	USING at_transaccion;

IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Entrega de Vales ")
	
	lb_Retorno	=	False
ELSEIF at_Transaccion.SQLCode = 100 THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		w_movto_casinos_systray.st_Mensaje.Text = "Vale de colación " + as_nrotarjeta + ", no ha sido Asignado al Presente Día o ya fue utilizado."
	END IF
	
ELSEIF vact_ubicact <> 2 THEN
	lb_Retorno	=	False
	
	IF ab_Mensaje THEN
		CHOOSE CASE vact_ubicact
			CASE 1
				ls_mensaje = ", no esta disponible para su uso."
				
			CASE 3
				ls_mensaje = ", ya fue utilizado y aun no es renovado."
				
			CASE 9
				ls_mensaje = ", esta marcado como extraviado, no es posible utilizarlo."
				
		END CHOOSE
		w_movto_casinos_systray.st_Mensaje.Text = "Vale de colación " + as_nrotarjeta + ls_mensaje
					  
	END IF
END IF

IF lb_retorno THEN
	SELECT  DISTINCT tico_codigo,  cahc_horini
	  INTO :tico_codigot,:cahc_horinit
	  FROM dbo.casino_horariocolaciones
	 WHERE ( cahc_horini between :evct_horaivt and :evct_horatvt OR
	 		   cahc_horter between :evct_horaivt and :evct_horatvt)
		AND Convert(Time, Getdate()) between cahc_horini and cahc_horter
		AND :evct_fechavt between cahc_fecini and cahc_fecter
		AND tico_codigo = :ai_colacion
	USING at_transaccion;

	IF at_Transaccion.SQLCode = -1 THEN
		F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Horario Colaciones")
		
		lb_Retorno	=	False
	ELSEIF at_Transaccion.SQLCode = 100 THEN
		lb_Retorno	=	False
		
		IF ab_Mensaje THEN
			w_movto_casinos_systray.st_Mensaje.Text = "Vale de colación " + as_nrotarjeta + ", no esta autorizado para consumo de colaciones en este horario."
		END IF
	END IF
	
END IF

RETURN lb_retorno
end function

public function integer secuenciamax (date ad_fecha, integer ai_zona, integer ai_area, transaction at_transaccion);Integer	li_secuencia

select max(IsNull(camv_secuen, 0))
  into :li_secuencia from dbo.casino_movtocolaciones
 where zona_codigo = :ai_zona
   and caar_codigo = :ai_area
	and camv_fechac = :ad_fecha using at_transaccion;
	
IF at_Transaccion.SQLCode = -1 THEN
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Movimientos de Colación")
	Return 0
ELSE
	IF IsNull(li_secuencia) THEN li_secuencia = 0
	Return li_secuencia + 1
END IF
end function

on uo_movtocasino.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_movtocasino.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;select zona_codigo, caar_codigo
  into :zona_codigot, :caar_codigot
  from dbo.casino_parametros
 where capa_activa = 1;
 
IF sqlca.SQLCode = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla casino_parametros")
	
ELSEIF sqlca.SQLCode = 100 THEN
	zona_codigot = 9
	caar_codigot = 1
END IF
end event

