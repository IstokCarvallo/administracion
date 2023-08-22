$PBExportHeader$uo_guiadespacho.sru
forward
global type uo_guiadespacho from nonvisualobject
end type
end forward

global type uo_guiadespacho from nonvisualobject
end type
global uo_guiadespacho uo_guiadespacho

type variables
Private Transaction	SQLProd
Private DataStore		ids_Guia, ids_Source

Private 	Long		il_NroGuia = -1
Private 	Integer	TipoTrasporte
Private 	String		PuertoDestino, NumerosSellos, CantidadSellos, UbicacionSello, GlosaGD, RutRecibidor, Recibidor, &
						RUT, Direccion, Ciudad, Comuna

Private Constant	Integer 	_TipoDocto 			= 28
Private Constant	Integer 	_TipoDoctoDTE 	= 52
Private Constant 	Integer 	_Emisor	 			= 1
Private Constant	String	  	_Separador			= '_'
Private Constant	String	 	_SeparadorDTE	= '|'

Private uo_Empresa 		iuo_Coneccion
Private n_buscaarchivo	iuo_BuscaArchivo

end variables

forward prototypes
private function boolean of_conectar (integer ai_coneccion)
private function boolean of_desconectar ()
private function long of_obtienenroguia (integer tipodocto, integer emisor, transaction at_transaccion)
private subroutine of_insertaregistro (string tag, string referencia)
public subroutine of_setpuertodestino (string codigo)
public subroutine of_setnumerosellos (string codigo)
public subroutine of_setcantidadsellos (string codigo)
public subroutine of_setglosagd (string codigo)
public subroutine of_setubicacionsellos (string codigo)
private subroutine of_setdireccion (string codigo)
private subroutine of_setcomuna (string codigo)
private subroutine of_setcuidad (string codigo)
private subroutine of_setrut (string codigo)
private subroutine of_setrecibidor (string codigo)
private subroutine of_setrutrecibidor (string codigo)
public function boolean of_anulaguiadespacho (integer estado, integer cliente, integer planta, long guia, integer tipo, transaction at_transaccion)
public function boolean of_generaanulaguia (integer ai_cliente, integer ai_planta, long al_guia, long al_numero, integer ai_tipo, string as_embarque, integer ai_modulo, string as_motivo)
public function long of_emiteguia (long movimiento, boolean conecta)
private function boolean of_datosempresa ()
private function boolean of_grabaarchivo (long folio)
private function boolean of_generaguia (long movimiento)
public function boolean of_generalibroguia ()
public function long of_recuperapdf (long al_nroguia, date ad_fecha)
public function boolean of_actualizaestadogd (integer estado, long numero, long guia, transaction at_transaccion)
private subroutine of_settipotransporte (integer codigo)
end prototypes

private function boolean of_conectar (integer ai_coneccion);SetPointer (HourGlass!)

Boolean	lb_Retorno = True
String		ls_Mensaje

If Not iuo_Coneccion.of_ExisteConexion(ai_Coneccion, True, SQLCA) Then
	lb_Retorno = False
Else	
	If iuo_Coneccion.DBMS = 'ODBC' Then
		SQLProd.ServerName		=	iuo_Coneccion.Servidor
		SQLProd.DataBase			=	iuo_Coneccion.NombreBase
		SQLProd.Dbms				= 	iuo_Coneccion.DBMS
		SQLProd.DbParm			=	"Connectstring='DSN=" + iuo_Coneccion.ODBC + ";UID=" + iuo_Coneccion.Usuario + &
										";PWD=" + iuo_Coneccion.Password + "'// ;PBUseProcOwner = " + '"Yes"'
										
	ElseIf Mid(iuo_Coneccion.DBMS,1,3) = 'SNC' or Mid(iuo_Coneccion.DBMS,1,9) = 'TRACE SNC' Then
		SQLProd.LogId				=	iuo_Coneccion.Usuario
		SQLProd.LogPass			=	iuo_Coneccion.Password
		SQLProd.DbParm			=	"Provider='" + iuo_Coneccion.Provider + "',Database='"+iuo_Coneccion.NombreBase+"',TrimSpaces=1"	
		SQLProd.ServerName		=	iuo_Coneccion.Servidor
		SQLProd.DataBase			=	iuo_Coneccion.NombreBase
		SQLProd.Dbms				= 	iuo_Coneccion.DBMS
	End If
	
	CONNECT USING SQLProd;

	If SQLProd.SQLCode = 0 Then
		lb_Retorno	=	True
	Else
		If SQLProd.SQLCode = 18456 Then
			ls_Mensaje = 'User Login Failed'
		Else//If SQLProd.SQLCode = 18456 Then
			ls_Mensaje = 'No se pudo establecer una coneccion'
		End If
		lb_Retorno	=	False
	End If
End If	
	
SetPointer(Arrow!)

Return	lb_Retorno
end function

private function boolean of_desconectar ();Boolean	lb_Retorno = True

DISCONNECT USING SQLProd;

If SQLProd.SQLCode = 0 Then
	lb_Retorno	=	True
Else
	lb_Retorno	=	False
End If

Return lb_Retorno
end function

private function long of_obtienenroguia (integer tipodocto, integer emisor, transaction at_transaccion);Long	ll_Retorno

DECLARE ObtieneGuia PROCEDURE FOR dba.Cont_GeneraDocumentos	
		  @CentroEmisor 	= :Emisor,
		  @TipoDoc 			= :TipoDocto
	Using at_Transaccion;
		  
EXECUTE ObtieneGuia;

Fetch ObtieneGuia into :ll_Retorno;

Close ObtieneGuia;
		
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura Procedimiento Cont_GeneraDocumentos, Obtiene Numero de Guia.")
	ll_Retorno =  -1
End If	

Return ll_Retorno
end function

private subroutine of_insertaregistro (string tag, string referencia);Long	ll_New 
String	ls_Registro

//Agrega Referencia
If IsNull(Referencia) Then
	ls_Registro = '<' + Tag + '>'
ElseIf Tag = '' Then
	ls_Registro = Referencia
Else
	ls_Registro = Tag + _SeparadorDTE + Referencia
End If

ll_New = ids_Guia.InsertRow(0)	
ids_Guia.Object.registro[ll_New] = ls_Registro

end subroutine

public subroutine of_setpuertodestino (string codigo);If IsNull(Codigo) Then Codigo = ''
This.PuertoDestino = Trim(Codigo)
end subroutine

public subroutine of_setnumerosellos (string codigo);If IsNull(Codigo) Then Codigo = ''
This.NumerosSellos	= Trim(Codigo)


end subroutine

public subroutine of_setcantidadsellos (string codigo);If IsNull(Codigo) Then Codigo = ''
This.CantidadSellos	= Trim(Codigo)


end subroutine

public subroutine of_setglosagd (string codigo);If IsNull(Codigo) Then Codigo = ''
This.GlosaGD	= Trim(Codigo)
end subroutine

public subroutine of_setubicacionsellos (string codigo);If IsNull(Codigo) Then Codigo = ''
This.UbicacionSello	= Trim(Codigo)
end subroutine

private subroutine of_setdireccion (string codigo);If IsNull(Codigo) Then Codigo = ''
This.Direccion	= Trim(Codigo)
end subroutine

private subroutine of_setcomuna (string codigo);If IsNull(Codigo) Then Codigo = ''
This.Comuna	= Trim(Codigo)
end subroutine

private subroutine of_setcuidad (string codigo);If IsNull(Codigo) Then Codigo = ''
This.Ciudad	= Trim(Codigo)
end subroutine

private subroutine of_setrut (string codigo);If IsNull(Codigo) Then Codigo = ''
This.RUT	= Trim(Codigo)
end subroutine

private subroutine of_setrecibidor (string codigo);If IsNull(Codigo) Then Codigo = ''
This.Recibidor	= Trim(Codigo)


end subroutine

private subroutine of_setrutrecibidor (string codigo);If IsNull(Codigo) Then Codigo = ''
This.RutRecibidor	= Trim(Codigo)


end subroutine

public function boolean of_anulaguiadespacho (integer estado, integer cliente, integer planta, long guia, integer tipo, transaction at_transaccion);Boolean	lb_Retorno = True

If Tipo = 1 Then 
	Update dbo.despafrigoen
		Set	defe_guiaem = :Estado,
				defe_guides	=	Null
		Where plde_codigo 	=	:Planta
			And clie_codigo		=	:Cliente
			And defe_guides	=	:Guia
	Using	at_Transaccion;
ElseIf Tipo = 2 Then 
	Update dbo.spro_movtoenvaenca
		Set 	meen_guiemi = :Estado,
				meen_guisii	=	Null
		Where plde_codigo 	=	:Planta
			And clie_codigo		=	:Cliente
			And meen_guisii	=	:Guia
	Using	at_Transaccion;	
ElseIf Tipo = 3 Then 
	Update dbo.spro_movtofrutacomenca
		Set 	mfco_guiemi = :Estado,
				mfco_guisii	=	Null
		Where plde_codigo 	=	:Planta
			And clie_codigo		=	:Cliente
			And mfco_guisii	=	:Guia
	Using	at_Transaccion;
ElseIf Tipo = 4 Then 
	Update dbo.spro_movtofrutagranenca
		Set 	mfge_guiemi = :Estado,
				mfge_guisii	=	Null
		Where plde_codigo 	=	:Planta
			And clie_codigo		=	:Cliente
			And mfge_guisii	=	:Guia
	Using	at_Transaccion;
End If

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Falló Actualizacion Estado Emision Guia Electronica.")
	lb_Retorno =  False
End If

Return lb_Retorno
end function

public function boolean of_generaanulaguia (integer ai_cliente, integer ai_planta, long al_guia, long al_numero, integer ai_tipo, string as_embarque, integer ai_modulo, string as_motivo);Boolean	lb_Retorno = True
String		ls_Cuerpo, ls_Modulo, ls_Asunto,ls_Error
Integer	li_Correo
uo_Mail	iuo_Mail


iuo_Mail	=	Create uo_Mail

Choose Case ai_Modulo
	Case 1
		ls_Modulo = 'Fruta Embalada'
	Case 2
		ls_Modulo = 'Envases'
	Case 3
		ls_Modulo = 'Fruta Comercial'
	Case 4
		ls_Modulo = 'Fruta Granel'
End Choose
	
	
INSERT INTO dbo.spro_anulaguia(clie_codigo, plde_codigo, angu_nrogui, angu_fechaa, angu_numero, tpmv_codigo, 
											embq_codigo,angu_usuari, angu_comput, angu_modulo, angu_motivo) 
	  VALUES ( :ai_Cliente, :ai_Planta, :al_Guia, GetDate(), :al_Numero, :ai_Tipo,
				:as_Embarque, :gstr_us.Nombre, :gstr_us.Computador, :ai_Modulo, :as_Motivo)
	Using SQLCA;

If SQLCA.SQLCode = -1 Then
	F_ErrorBaseDatos(SQLCA, "Error Carga de Tabla Anulacion Guias Despachos")
	lb_Retorno =  False
Else	
//	If IsNull(gstr_parempresa.Correo_Anulacion_DTE) Or gstr_parempresa.Correo_Anulacion_DTE = '' Then
//		MessageBox('Error', 'No se pudo enviar correo con informe de anulacion, ya que no existe Correo Configurado.', StopSign!, Ok!)
//	Else
//		If iuo_Mail.of_ObtieneSMTP() < 0 Then 
//			MessageBox('Error', 'No se pudo enviar correo con informe de anulacion, ya que no existe SMTP Configurado.', StopSign!, Ok!)
//		Else
//			ls_Asunto = "Anulacion de Guias Despacho SII"
//			ls_Cuerpo  = 'Estimados:~n~n' + 'Se anulo la Guia De Despacho Numero: ' + String(al_Numero, '00000000') + '~n~n' + &
//						'Del modulo: ' + ls_Modulo +  '~n~n' + &
//						'Por el usuario: ' + gstr_Us.Nombre + ' desde el computador: ' + gstr_Us.Computador + ' con fecha: ' + String(Today(), 'dd/mm/yyyy')
//			
//			li_Correo = iuo_Mail.Send_Mail(iuo_Mail.SMTP,"<SendMail@rioblanco.net>", gstr_parempresa.Correo_Anulacion_DTE, "", "", ls_Asunto, ls_Cuerpo,"", ls_Error)
//			
//			If (li_Correo < 0) Then MessageBox("Error No" + String(li_Correo), ls_Error)
//			
//		End If
//	End If
End If

Destroy iuo_Mail
Return lb_Retorno
end function

public function long of_emiteguia (long movimiento, boolean conecta);
If Conecta Then
	If of_Conectar( gstr_ParEmpresa.Conecion_GuiaElectronica) Then
		il_NroGuia = of_ObtieneNroGuia(_TipoDocto, _Emisor, SQLProd)
		If il_NroGuia = -1 Then
			MessageBox('Error', 'No hay correlativos disponibles, se utilizo el ultimo.', StopSign!, OK!)
		ElseIf il_NroGuia = -2 Then
			MessageBox('Error', 'No existen rangos vigentes para correlativos.', StopSign!, OK!)
		Else
			If of_DesConectar() Then 
				of_GeneraGuia(Movimiento)
			Else
				MessageBox('Error', 'No pudo desconectare de la base emisora de Folios.', StopSign!, OK!)
			End If
		End If
	Else
		MessageBox('Error', 'No se pudo conectar con la base emisora de Folios.', StopSign!, OK!)
		il_NroGuia = -3
	End If
Else
	il_NroGuia	= Movimiento
	If Not of_GeneraGuia(Movimiento) Then il_NroGuia = -3
End If 

Return il_NroGuia
end function

private function boolean of_datosempresa ();Boolean	lb_Retorno = True

If of_Conectar(gstr_ParEmpresa.Conecion_GuiaElectronica) Then

	Select empr_rutemp, empr_comuna, empr_ciudad, empr_direcc
		Into :Rut, :Comuna, :Ciudad, :Direccion
		 From dba.parempresa
	Using	SQLProd;
	
	If SQLProd.SQLCode = -1 Then
		F_ErrorBaseDatos(SQLProd, "No se pudo Cargar Datos de la Empresa Emisora.")
		lb_Retorno =  False
	Else
		of_DesConectar()
	End If
Else
	MessageBox('Error', 'No se pudo conectar con la base Emisora(Datos Empresa).', StopSign!, OK!)
	lb_Retorno =  False
End If

Return lb_Retorno
end function

private function boolean of_grabaarchivo (long folio);Boolean	lb_Retorno = True
String 	ls_File, ls_Path, ls_Ubicacion

SetPointer(HourGlass!)

If of_DatosEmpresa() Then
	ls_Ubicacion = gstr_ParEmpresa.Ubicacion_DTE
	
//	If DirectoryExists(ls_Ubicacion) Then
		ls_Path	= ls_Ubicacion
//	Else
		If Not DirectoryExists("C:\GeneraGuiaElectronica") Then CreateDirectory ("C:\GeneraGuiaElectronica")
//			ls_Path	= "C:\GeneraGuiaElectronica\"
//		Else
//			ls_Path	= "C:\GeneraGuiaElectronica\"
//		End If
//	End If

	ls_File	=	"C:\GeneraGuiaElectronica\" + String(_TipoDoctoDTE) + _Separador + String(Folio) + _Separador + This.Rut + '.txt'
	ids_Guia.SaveAs(ls_File, Text!, False)
	
	ls_File	=	ls_Path + String(_TipoDoctoDTE) + _Separador + String(Folio) + _Separador + This.Rut + '.txt'
	
	If ids_Guia.SaveAs(ls_File, Text!, False) = -1 Then
		MessageBox('Error', 'No se pùdo generar archivo ('+ ls_File +') con información solicitda.' , StopSign!, OK! )
		lb_Retorno = False
	Else
		MessageBox('Atencion', 'Archivo ('+ ls_File +') generado satisfactoriamente.' , Information!, OK! )
	End If
Else
	lb_Retorno = False
End If

SetPointer(Arrow!)

Return lb_Retorno
end function

private function boolean of_generaguia (long movimiento);Boolean	lb_Retorno = True
Long		ll_Fila, ll_Linea, ll_Largo, ll_Cont
String		ls_Referencia, ls_Rut, ls_PuertoOrigen, ls_Puerto, ls_Pais, ls_Totales

SetNull(ls_Referencia)

IF of_DatosEmpresa() Then
	//Movimiento
	ll_Fila = ids_Source.Retrieve(Movimiento, il_NroGuia)
	
	If  ll_Fila	= -1 Then
		MessageBox('Error', 'Error al cargar informacion para generacion de Guia Electronica.', StopSign!, OK!)
		lb_Retorno = False
	ElseIf ll_Fila	= 0 Then
		MessageBox('Alerta', 'No se pudo recuperar informacion de Guia Electronica (Filas Recuperadas = ' + String(ll_Fila)+ ')', Exclamation!, OK!)
		lb_Retorno = False
	Else
		//Genera Archivo DTE
		ids_Guia.Reset()
		
		of_SetRutRecibidor(ids_Source.Object.embc_nrorut[1])
		of_SetRecibidor(ids_Source.Object.embc_nombre[1])
		of_SetTipoTransporte(ids_Source.Object.defe_tipotr[1])
		
		ls_Rut = String(Long(Mid(This.RutRecibidor, 1, Len(String(This.RutRecibidor)) - 1))) + '-' + Right(This.RutRecibidor, 1)
	
		//Genera Encabezado
		of_InsertaRegistro('ENCABEZADO', ls_Referencia)
		
		of_InsertaRegistro('Tipo DTE', String(_TipoDoctoDTE))
		of_InsertaRegistro('Folio', String(il_NroGuia))
		of_InsertaRegistro('Fecha de Emision', String(ids_Source.Object.defe_fecdes[1], 'dd-mm-yyyy'))
		of_InsertaRegistro('Ind. traslado de bienes', String(ids_Source.Object.defe_tipotr[1]))
		of_InsertaRegistro('Codigo Traslado', '1')
		of_InsertaRegistro('Tipo Despacho', String(ids_Source.Object.defe_tipode[1]))
		of_InsertaRegistro('Forma Pago', '')
		of_InsertaRegistro('Codigo Vendedor', '')
		
		of_InsertaRegistro('Rut Receptor', ls_Rut)
		of_InsertaRegistro('Codigo Interno Receptor', '')
		of_InsertaRegistro('Razon Social Receptor', This.Recibidor)
		of_InsertaRegistro('Giro Receptor', Mid(ids_Source.Object.embc_giroem[1], 1, 40)) 
		of_InsertaRegistro('Contacto Receptor', '')
		of_InsertaRegistro('Direccion Receptor', ids_Source.Object.embc_dirori[1])
		of_InsertaRegistro('Comuna Receptor', ids_Source.Object.embc_comuna[1])
		of_InsertaRegistro('Ciudad Receptor', ids_Source.Object.embc_ciudad[1])
		
		ls_Rut = String(Long(Mid(ids_Source.Object.defe_chfrut[1], 1, Len(String(ids_Source.Object.defe_chfrut[1])) - 1))) + '-' + &
									Right(ids_Source.Object.defe_chfrut[1], 1)
									
		of_InsertaRegistro('RUT Chofer', ls_Rut)
		of_InsertaRegistro('xCelular Chofer', ids_Source.Object.defe_celcho[1])
		of_InsertaRegistro('Nombre Chofer', ids_Source.Object.defe_chofer[1])
		of_InsertaRegistro("Patente Transporte", ids_Source.Object.defe_patent[1])
//		of_InsertaRegistro("xPatenteCarro", ids_Source.Object.defe_pataco[1])
		
		of_InsertaRegistro('Direccion Origen', This.Direccion) 
		of_InsertaRegistro('Comuna Origen', This.Comuna)
		of_InsertaRegistro('Ciudad Origen', This.Ciudad)
	
		of_InsertaRegistro('Direccion Destino', ids_Source.Object.embc_direcc[1])
		of_InsertaRegistro('Comuna Destino', ids_Source.Object.embc_comdes[1])
		of_InsertaRegistro('xSitiodestino', ids_Source.Object.defe_nomdes[1])
		
		of_InsertaRegistro('Monto Neto', '0')
		of_InsertaRegistro('Iva', '')
		of_InsertaRegistro('Monto Total', '0')
		
		of_InsertaRegistro('Monto Exento', '')
		of_InsertaRegistro('Tasa Iva', '')
		of_InsertaRegistro('xMontoEscrito', '')			
	
		If IsNull(ids_Source.Object.tpmv_glosas[1]) Then
			ls_Referencia = ''
		Else	
			ls_Referencia = Trim(ids_Source.Object.tpmv_glosas[1])
		End If
		
		of_InsertaRegistro('xObservaciones', Mid(ls_Referencia, 1, 120))
		of_InsertaRegistro('xObservaciones1', Mid(ids_Source.Object.defe_nomdes[1], 1, 120))		
//		of_InsertaRegistro('xObservaciones2', Mid(ls_Referencia, 1, 120))
		
		of_InsertaRegistro('xUsuario Emision', gstr_us.Nombre)
		of_InsertaRegistro('xLugar Emision', ids_Source.Object.embc_nomori[1])
		
		//Genera Detalle
		SetNull(ls_Referencia)
		of_InsertaRegistro('DETALLE', ls_Referencia)	
		of_InsertaRegistro('', "Nro.Linea|Tipo codigo|Codigo del Item|Indicador Exencion|Nombre del Item|Descripcion Adicional Item|Cantidad|Unidad de Medida|Precio Unitario Item|Monto Item")
		For ll_Fila = 1 To ids_Source.RowCount()
			ls_Referencia = String(ll_Fila) + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			
			ls_Referencia += Mid(Trim(ids_Source.Object.Detalle[ll_Fila]) ,1,80)+ _SeparadorDTE
			ls_Referencia += Trim(ids_Source.Object.Detalle[ll_Fila]) + _SeparadorDTE
			ls_Referencia += String(ids_Source.Object.cantidad[ll_Fila], "#,##0") + _SeparadorDTE
			ls_Referencia += 'UNID' + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '0'				
			
			of_InsertaRegistro('', ls_Referencia)
		Next
		
		ll_Linea = ll_Fila
		ll_Largo = Ceiling(LenA(Trim(ids_Source.Object.GlosaSerie[1])) / 80)
		ll_Fila = 1
		ll_Cont = 1
		
		Do While ll_Fila <= ll_Largo
			
			ls_Totales = Mid(Trim(ids_Source.Object.GlosaSerie[1]), ll_Cont, 80)

			ls_Referencia = String(ll_Linea) + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '2' + _SeparadorDTE
			ls_Referencia += ls_Totales + _SeparadorDTE
			ls_Referencia += ls_Totales + _SeparadorDTE
			ls_Referencia += ''+ _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '' + _SeparadorDTE
			ls_Referencia += '0'
			
			of_InsertaRegistro('', ls_Referencia)
			ll_Cont = ll_Cont + 80
			ll_Fila++
			ll_Linea++
		Loop
		
		SetNull(ls_Referencia)
		//Genera Referencia
		of_InsertaRegistro('REFERENCIA', ls_Referencia)
		of_InsertaRegistro('', "Nro Linea Referencia|Tipo Documento Referencia|Folio Referencia|Fecha Referencia|Codigo Referencia")
		
		//Graba Archivo
		of_GrabaArchivo(il_NroGuia)
	End If
Else
	lb_Retorno = False
End If

Return lb_Retorno 
end function

public function boolean of_generalibroguia ();Boolean	lb_Retorno = True

If of_Conectar(gstr_ParEmpresa.Conecion_GuiaElectronica) Then
	INSERT INTO dba.contguiasdespacho (tpdo_codigo, guia_numero, guia_estado, guia_anumod, guia_tipope, guia_fechag, clpr_rut, guia_nomrec, 
												 guia_valnet, guia_poriva, guia_valiva, guia_valtot, guia_valmod, guia_tdrefe, guia_docref, guia_fecref, 
												 ceem_codigo, guia_usuemi, guia_modori, guia_feccre, guia_usumod, guia_fecmod, bode_codigo) 
		  VALUES ( 28, :il_NroGuia, 1, NULL, :This.TipoTrasporte, GetDate(), :This.RutRecibidor, SubString(:This.Recibidor,1,60), 
					0, 0, 0, 0, 0, NULL, NULL, NULL, 
					1, :gstr_us.Nombre, SubString(:gstr_apl.NombreSistema,1,40), GetDate(), NULL, NULL, Null)
		Using SQLProd;
	
	If SQLProd.SQLCode = -1 Then
		F_ErrorBaseDatos(SQLProd, "Lectura Carga de Libro de Guia Electronicas")
		lb_Retorno =  False
	Else
		If of_DesConectar() Then 
		End If
	End If
Else
	MessageBox('Error', 'No se pudo conectar con la base para generar libro de Guias.', StopSign!, OK!)
End If

Return lb_Retorno
end function

public function long of_recuperapdf (long al_nroguia, date ad_fecha);Long	ll_Retorno = -1
String	ls_Path, ls_Directorio, ls_Ubicacion
Int		li_Contador =	0

If IsNull(al_NroGuia) Then al_NroGuia = il_NroGuia
ls_Directorio = String(ad_Fecha, 'yyyy-mm') + '\'
ls_Ubicacion = gstr_ParEmpresa.Ubicacion_PDFDTE

If DirectoryExists( ls_Ubicacion + ls_Directorio) Then
	ls_Path = ls_Ubicacion + ls_Directorio + String(_TipoDoctoDTE) + '_' + String(al_NroGuia) + '*C1.PDF'
	
	Do 
		ll_Retorno = iuo_BuscaArchivo.AbrirDocumento(ls_Path)
		
		If ll_Retorno = -1 Then 
			li_Contador++
			Sleep(5)
		End If
	Loop Until li_Contador = 3 Or ll_Retorno = 1
Else
	MessageBox('Error', 'No se encuentra la carpeta(' + ls_Ubicacion + ls_Directorio + ') para acceder a documentos PDF.~n~nFavor Contactarse con Informatica', StopSign!, OK!)
	ll_Retorno = -1
End If

Return ll_Retorno
end function

public function boolean of_actualizaestadogd (integer estado, long numero, long guia, transaction at_transaccion);Boolean	lb_Retorno = True

Update dbo.movtoequipoenca
	Set meec_guiemi = :Estado
	Where  meec_numero =	:Numero
		And meec_guides	=	:Guia
Using	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Falló Actualizacion Estado Emision Guia Electronica.")
	lb_Retorno =  False
End If

Return lb_Retorno
end function

private subroutine of_settipotransporte (integer codigo);If IsNull(Codigo) Then Codigo = 0
This.TipoTrasporte	= Codigo
end subroutine

on uo_guiadespacho.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_guiadespacho.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;SQLProd				=	Create Transaction
ids_Guia				=	Create DataStore
ids_Source			=	Create DataStore
iuo_Coneccion		=	Create uo_Empresa
iuo_BuscaArchivo	=	Create n_buscaarchivo	

ids_Source.DataObject = 'dw_info_guia_despacho_cal'
ids_Source.SetTransObject(Sqlca)

ids_Guia.DataObject = 'dw_guiadespacho_dte'
ids_Guia.SetTransObject(Sqlca)
end event

event destructor;Destroy SQLProd
//Destroy iuo_Coneccion
Destroy ids_Guia
Destroy ids_Source
Destroy iuo_BuscaArchivo
end event

