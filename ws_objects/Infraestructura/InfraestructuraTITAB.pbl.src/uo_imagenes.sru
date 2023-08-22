$PBExportHeader$uo_imagenes.sru
forward
global type uo_imagenes from uo_admdoctos
end type
end forward

global type uo_imagenes from uo_admdoctos
end type
global uo_imagenes uo_imagenes

forward prototypes
public function boolean grabaimagen (datawindow adw, long fila, transaction at_transaccion, string as_archivo)
public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion)
public function boolean recuperaimagen (datawindow adw, long fila, transaction at_transaccion, string tipo)
public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo)
public function boolean grabaimagenot (datawindow adw, long fila, transaction at_transaccion, string as_archivo)
public function blob seleccionadoctoot (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo)
public function boolean recuperaimagenot (datawindow adw, long fila, transaction at_transaccion, string tipo)
public function boolean recuperaimagenli (datawindow adw, long fila, transaction at_transaccion, string tipo)
public function blob seleccionadoctoli (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo)
public function boolean grabaimagenli (datawindow adw, long fila, transaction at_transaccion, string as_archivo)
end prototypes

public function boolean grabaimagen (datawindow adw, long fila, transaction at_transaccion, string as_archivo);Boolean	lb_Retorno = False
Long		ll_Archivo, ll_Numero
String		ls_Tipo 
Blob 		lbl_Datos, lbl_Temporal

Integer	li_Equipo

li_Equipo	=	adw.Object.equi_codigo[Fila]

ls_Tipo		= Mid(as_archivo, 1, 2)
as_Archivo	= Mid(as_archivo, 3)

ll_Archivo	=	FileOpen(as_archivo, StreamMode!)

DO WHILE FileReadEx(ll_Archivo, lbl_Temporal) > 0
	lbl_Datos	+=	lbl_Temporal
LOOP

FileClose(ll_Archivo)

IF ll_Archivo = 1 THEN
	FileReadEx(ll_Archivo, lbl_Datos)
	FileClose(ll_Archivo)
	
	at_Transaccion.AutoCommit	=	True
	
	Choose Case ls_Tipo
		Case 'OC'	
			UPDATEBLOB dbo.equipo
				SET	equi_imorco =	:lbl_Datos 
			WHERE	equi_codigo =	:li_Equipo
			USING at_Transaccion;
					
		Case 'GD'
			UPDATEBLOB dbo.equipo
				SET	equi_imguia =	:lbl_Datos 
			WHERE	equi_codigo =	:li_Equipo
			USING at_Transaccion;
					
		Case 'FA'
			UPDATEBLOB dbo.equipo
				SET	equi_imfactu =	:lbl_Datos 
			WHERE	equi_codigo =	:li_Equipo
			USING at_Transaccion;
			
	End Choose
			
	at_Transaccion.AutoCommit	=	False
	lb_Retorno						=	True
END IF

IF at_Transaccion.SQLNRows > 0 THEN
	Commit;
	lb_Retorno	=	True
END IF

FileClose(ll_Archivo)

RETURN lb_Retorno
end function

public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion);Blob 		lblob_Archivo

SetNull(lblob_Archivo)

Long		ll_Numero
Integer	li_Cliente, li_Especie, li_Codigo

as_File_tmp	=	adw.Object.equi_pathoc[Fila]
li_Codigo		=	adw.Object.equi_codigo[Fila]

SELECTBLOB 	equi_imorco
	INTO	:lblob_Archivo
	FROM	dbo.equipo
	WHERE	equi_codigo	=	:li_Codigo
	USING at_transaccion;

IF at_transaccion.Sqlcode = -1 OR at_transaccion.Sqlcode = 100 THEN
	MessageBox( "Atención", "Ha ocurrido el error: ~n~r" + at_transaccion.SqlErrText ) 
	RETURN lblob_Archivo
END IF

RETURN lblob_Archivo
end function

public function boolean recuperaimagen (datawindow adw, long fila, transaction at_transaccion, string tipo);String 	ls_TemporalWindows, ls_Archivo, ls_ArchivoTemp
Blob   	lblob_Archivo

lblob_Archivo			=	SeleccionaDocto(adw, Fila, ls_Archivo, at_transaccion, Tipo)
ls_TemporalWindows	=	TemporalWindow()

ls_Archivo	=	Mid(ls_Archivo, LastPos(ls_Archivo, '\') + 1)

// Archivo temporal para leer
IF ls_TemporalWindows = "" THEN
	ls_ArchivoTemp  = "c:\" + ls_Archivo
ELSE
	ls_ArchivoTemp = ls_TemporalWindows + ls_Archivo
END IF

IF IsNull(lblob_Archivo) THEN
	MessageBox( "Atención", "Archivo que está leyendo viene nulo" ) 
	RETURN False
END IF

IF ArchivoBlob(ls_ArchivoTemp, lblob_Archivo) THEN
	AbrirDocumento(ls_ArchivoTemp)
END IF
end function

public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo);Blob 		lblob_Archivo

SetNull(lblob_Archivo)

Integer	li_Codigo

as_File_tmp	=	adw.Object.equi_pathoc[Fila]
li_Codigo		=	adw.Object.equi_codigo[Fila]

Choose Case Tipo
	Case 'OC'
		SELECTBLOB 	equi_imorco
			INTO	:lblob_Archivo
			FROM	dbo.equipo
			WHERE	equi_codigo	=	:li_Codigo
			USING at_transaccion;

	Case 'GD'
		SELECTBLOB 	equi_imguia
			INTO	:lblob_Archivo
			FROM	dbo.equipo
			WHERE	equi_codigo	=	:li_Codigo
			USING at_transaccion;

	Case 'FA'
		SELECTBLOB 	equi_imfactu
			INTO	:lblob_Archivo
			FROM	dbo.equipo
			WHERE	equi_codigo	=	:li_Codigo
			USING at_transaccion;

End Choose

IF at_transaccion.Sqlcode = -1 OR at_transaccion.Sqlcode = 100 THEN
	MessageBox( "Atención", "Ha ocurrido el error: ~n~r" + at_transaccion.SqlErrText ) 
	RETURN lblob_Archivo
END IF

RETURN lblob_Archivo
end function

public function boolean grabaimagenot (datawindow adw, long fila, transaction at_transaccion, string as_archivo);Boolean	lb_Retorno = False
Long		ll_Archivo, ll_Numero
String		ls_Tipo 
Blob 		lbl_Datos, lbl_Temporal

Integer	li_Equipo

li_Equipo	=	adw.Object.ortr_codigo[Fila]

ls_Tipo		= Mid(as_archivo, 1, 2)
as_Archivo	= Mid(as_archivo, 3)

ll_Archivo	=	FileOpen(as_archivo, StreamMode!)

DO WHILE FileReadEx(ll_Archivo, lbl_Temporal) > 0
	lbl_Datos	+=	lbl_Temporal
LOOP

FileClose(ll_Archivo)

IF ll_Archivo = 1 THEN
	FileReadEx(ll_Archivo, lbl_Datos)
	FileClose(ll_Archivo)
	
	at_Transaccion.AutoCommit	=	True
	
	Choose Case ls_Tipo
		Case 'OC'	
			UPDATEBLOB dbo.ordentrabajo
				SET	ortr_imorco =	:lbl_Datos 
			WHERE	ortr_codigo =	:li_Equipo
			USING at_Transaccion;
					
		Case 'OT'
			UPDATEBLOB dbo.ordentrabajo
				SET	ortr_imortr	=	:lbl_Datos 
			WHERE	ortr_codigo  =	:li_Equipo
			USING at_Transaccion;
					
		Case 'FA'
			UPDATEBLOB dbo.ordentrabajo
				SET	ortr_imfact	=	:lbl_Datos 
			WHERE	ortr_codigo	=	:li_Equipo
			USING at_Transaccion;
			
	End Choose
			
	at_Transaccion.AutoCommit	=	False
	lb_Retorno						=	True
END IF

IF at_Transaccion.SQLNRows > 0 THEN
	Commit;
	lb_Retorno	=	True
END IF

FileClose(ll_Archivo)

RETURN lb_Retorno
end function

public function blob seleccionadoctoot (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo);Blob 		lblob_Archivo

SetNull(lblob_Archivo)

Integer	li_Codigo

as_File_tmp	=	adw.Object.ortr_pathoc[Fila]
li_Codigo		=	adw.Object.ortr_codigo[Fila]

Choose Case Tipo
	Case 'OC'
		SELECTBLOB 	ortr_imorco
			INTO	:lblob_Archivo
			FROM	dbo.OrdenTrabajo
			WHERE	ortr_codigo	=	:li_Codigo
			USING at_transaccion;

	Case 'OT'
		SELECTBLOB 	ortr_imortr
			INTO	:lblob_Archivo
			FROM	dbo.OrdenTrabajo
			WHERE	ortr_codigo	=	:li_Codigo
			USING at_transaccion;

	Case 'FA'
		SELECTBLOB 	ortr_imfact
			INTO	:lblob_Archivo
			FROM	dbo.OrdenTrabajo
			WHERE	ortr_codigo	=	:li_Codigo
			USING at_transaccion;

End Choose

IF at_transaccion.Sqlcode = -1 OR at_transaccion.Sqlcode = 100 THEN
	MessageBox( "Atención", "Ha ocurrido el error: ~n~r" + at_transaccion.SqlErrText ) 
	RETURN lblob_Archivo
END IF

RETURN lblob_Archivo
end function

public function boolean recuperaimagenot (datawindow adw, long fila, transaction at_transaccion, string tipo);String 	ls_TemporalWindows, ls_Archivo, ls_ArchivoTemp
Blob   	lblob_Archivo

lblob_Archivo			=	SeleccionaDoctoOT(adw, Fila, ls_Archivo, at_transaccion, Tipo)
ls_TemporalWindows	=	TemporalWindow()

ls_Archivo	=	Mid(ls_Archivo, LastPos(ls_Archivo, '\') + 1)

// Archivo temporal para leer
IF ls_TemporalWindows = "" THEN
	ls_ArchivoTemp  = "c:\" + ls_Archivo
ELSE
	ls_ArchivoTemp = ls_TemporalWindows + ls_Archivo
END IF

IF IsNull(lblob_Archivo) THEN
	MessageBox( "Atención", "Archivo que está leyendo viene nulo" ) 
	RETURN False
END IF

IF ArchivoBlob(ls_ArchivoTemp, lblob_Archivo) THEN
	AbrirDocumento(ls_ArchivoTemp)
END IF
end function

public function boolean recuperaimagenli (datawindow adw, long fila, transaction at_transaccion, string tipo);String 	ls_TemporalWindows, ls_Archivo, ls_ArchivoTemp
Blob   	lblob_Archivo

lblob_Archivo			=	SeleccionaDoctoLI(adw, Fila, ls_Archivo, at_transaccion, Tipo)
ls_TemporalWindows	=	TemporalWindow()

ls_Archivo	=	Mid(ls_Archivo, LastPos(ls_Archivo, '\') + 1)

// Archivo temporal para leer
IF ls_TemporalWindows = "" THEN
	ls_ArchivoTemp  = "c:\" + ls_Archivo
ELSE
	ls_ArchivoTemp = ls_TemporalWindows + ls_Archivo
END IF

IF IsNull(lblob_Archivo) THEN
	MessageBox( "Atención", "Archivo que está leyendo viene nulo" ) 
	RETURN False
END IF

IF ArchivoBlob(ls_ArchivoTemp, lblob_Archivo) THEN
	AbrirDocumento(ls_ArchivoTemp)
END IF
end function

public function blob seleccionadoctoli (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion, string tipo);Blob 		lblob_Archivo

SetNull(lblob_Archivo)

Integer	li_Codigo

as_File_tmp	=	adw.Object.lice_pathoc[Fila]
li_Codigo		=	adw.Object.lice_codigo[Fila]

Choose Case Tipo
	Case 'OC'
		SELECTBLOB 	lice_imorco
			INTO	:lblob_Archivo
			FROM	dbo.LicenciasSW
			WHERE	lice_codigo	=	:li_Codigo
			USING at_transaccion;

	Case 'FA'
		SELECTBLOB 	lice_imfact
			INTO	:lblob_Archivo
			FROM	dbo.LicenciasSW
			WHERE	lice_codigo	=	:li_Codigo
			USING at_transaccion;

End Choose

IF at_transaccion.Sqlcode = -1 OR at_transaccion.Sqlcode = 100 THEN
	MessageBox( "Atención", "Ha ocurrido el error: ~n~r" + at_transaccion.SqlErrText ) 
	RETURN lblob_Archivo
END IF

RETURN lblob_Archivo
end function

public function boolean grabaimagenli (datawindow adw, long fila, transaction at_transaccion, string as_archivo);Boolean	lb_Retorno = False
Long		ll_Archivo, ll_Numero
String		ls_Tipo 
Blob 		lbl_Datos, lbl_Temporal

Integer	li_Equipo

li_Equipo	=	adw.Object.lice_codigo[Fila]

ls_Tipo		= Mid(as_archivo, 1, 2)
as_Archivo	= Mid(as_archivo, 3)

ll_Archivo	=	FileOpen(as_archivo, StreamMode!)

DO WHILE FileReadEx(ll_Archivo, lbl_Temporal) > 0
	lbl_Datos	+=	lbl_Temporal
LOOP

FileClose(ll_Archivo)

IF ll_Archivo = 1 THEN
	FileReadEx(ll_Archivo, lbl_Datos)
	FileClose(ll_Archivo)
	
	at_Transaccion.AutoCommit	=	True
	
	Choose Case ls_Tipo
		Case 'OC'	
			UPDATEBLOB dbo.LicenciasSW
				SET	lice_imorco =	:lbl_Datos 
			WHERE	lice_codigo =	:li_Equipo
			USING at_Transaccion;
					
		Case 'FA'
			UPDATEBLOB dbo.LicenciasSW
				SET	lice_imfact	=	:lbl_Datos 
			WHERE	lice_codigo	=	:li_Equipo
			USING at_Transaccion;
			
	End Choose
			
	at_Transaccion.AutoCommit	=	False
	lb_Retorno						=	True
END IF

IF at_Transaccion.SQLNRows > 0 THEN
	Commit;
	lb_Retorno	=	True
END IF

FileClose(ll_Archivo)

RETURN lb_Retorno
end function

on uo_imagenes.create
call super::create
end on

on uo_imagenes.destroy
call super::destroy
end on

