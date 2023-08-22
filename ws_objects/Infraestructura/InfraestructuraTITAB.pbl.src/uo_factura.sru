$PBExportHeader$uo_factura.sru
forward
global type uo_factura from uo_admdoctos
end type
end forward

global type uo_factura from uo_admdoctos
end type
global uo_factura uo_factura

forward prototypes
public function boolean grabaimagen (datawindow adw, long fila, transaction at_transaccion, string as_archivo)
public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion)
end prototypes

public function boolean grabaimagen (datawindow adw, long fila, transaction at_transaccion, string as_archivo);Boolean	lb_Retorno = True
Long		ll_File, ll_numero
Blob 		lbl_data, lbl_temp
Integer	li_Secuencia
String		ls_Usuario

ls_Usuario	=	adw.Object.usua_codigo[Fila]
ll_Numero	=	adw.Object.smen_numero[Fila]
li_Secuencia	=	adw.Object.smed_secuen[Fila]

ll_File = FileOpen(as_archivo, StreamMode!)

Do While FileRead(ll_file, lbl_temp) > 0
	lbl_data += lbl_temp
Loop

FileClose(ll_file)

If ll_File = 1 Then
	FileRead(ll_file, lbl_data)
	FileClose(ll_file)
	at_Transaccion.AutoCommit = True
	
	UpDateBlob dbo.seguromovtodeta
			Set smed_doctos = :lbl_data 
		WHERE smen_numero =:ll_Numero
		    and usua_codigo		=:ls_usuario
 		    and smed_secuen	=:li_Secuencia
			Using at_Transaccion;
			
	at_Transaccion.AutoCommit = False
ELSE
	lb_Retorno = False
END IF

IF at_Transaccion.SQLNRows > 0 THEN
	Commit;
ELSE
	lb_Retorno = False
END IF

FileClose(ll_file)

Return lb_Retorno = False
end function

public function blob seleccionadocto (datawindow adw, long fila, ref string as_file_tmp, transaction at_transaccion);Blob 		lblob_file
Long		ll_Numero
Integer	li_Secuencia
String		ls_Usuario

SetNull(lblob_file)

as_file_tmp	=	adw.Object.smed_archiv[Fila]
ls_Usuario	=	adw.Object.usua_codigo[Fila]
ll_Numero	=	adw.Object.smen_numero[Fila]
li_Secuencia	=	adw.Object.smed_secuen[Fila]

SELECTBLOB  smed_doctos
INTO :lblob_file
FROM dbo.seguromovtodeta
WHERE smen_numero =:ll_Numero
  and usua_codigo		=:ls_usuario
  and smed_secuen	=:li_Secuencia
USING at_transaccion;

If at_transaccion.Sqlcode = -1 OR at_transaccion.Sqlcode = 100 Then
	MessageBox( "Atención", "Ha ocurrido el error: ~n~r" + at_transaccion.SqlErrText ) 
	Return lblob_file
End If

Return lblob_file
end function

on uo_factura.create
call super::create
end on

on uo_factura.destroy
call super::destroy
end on

