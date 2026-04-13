$PBExportHeader$uo_matriztiempo.sru
$PBExportComments$Objeto de Validación y claculo de Matriz de tiempos
forward
global type uo_matriztiempo from nonvisualobject
end type
end forward

global type uo_matriztiempo from nonvisualobject
end type
global uo_matriztiempo uo_matriztiempo

type variables
Integer	Codigo
String		Nombre
Dec{2}	Tiempo

end variables

forward prototypes
public function boolean of_cargamatriz (integer comuna)
public function boolean of_existe (integer origen, integer destino, boolean ab_mensaje, transaction at_transaccion)
end prototypes

public function boolean of_cargamatriz (integer comuna);
DECLARE sp_generar PROCEDURE FOR dbo.Infra_generar_matriz_comuna
    @comuna_origen_id = :Comuna
	 Using SQLCA;

EXECUTE sp_generar;

 If SQLCA.SQLCode <> 0 Then 
	  ROLLBACK USING SQLCA;	  
	   F_ErrorBaseDatos(SQLCA, "Ejecución SP FProc_generar_matriz_comuna")	  
	  Return False	
End If
 
 COMMIT USING SQLCA;

Return True 
end function

public function boolean of_existe (integer origen, integer destino, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

  SELECT IsNull(tiempo_horas, 0)
    INTO :Tiempo
    FROM dbo.matriz_tiempos  
  	 WHERE comuna_origen_id =	:Origen
		And comuna_destino_id =	:Destino
	 USING	at_Transaccion; 
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Matriz de Tiempos ")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "Código de Comuna Destino " + String(Destino) + &
					", no tiene tiempo asignado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
end function

on uo_matriztiempo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_matriztiempo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

