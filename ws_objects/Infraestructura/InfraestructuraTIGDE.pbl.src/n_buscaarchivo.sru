$PBExportHeader$n_buscaarchivo.sru
forward
global type n_buscaarchivo from nonvisualobject
end type
type filetime from structure within n_buscaarchivo
end type
type win32_find_data from structure within n_buscaarchivo
end type
type systemtime from structure within n_buscaarchivo
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type win32_find_data from structure
	unsignedlong		dwfileattributes
	filetime		ftcreationtime
	filetime		ftlastaccesstime
	filetime		ftlastwritetime
	unsignedlong		nfilesizehigh
	unsignedlong		nfilesizelow
	unsignedlong		dwreserved0
	unsignedlong		dwreserved1
	character		cfilename[260]
	character		calternatefilename[14]
end type

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

global type n_buscaarchivo from nonvisualobject
end type
global n_buscaarchivo n_buscaarchivo

type prototypes
Function boolean FileTimeToSystemTime ( &
	Ref FILETIME lpFileTime, &
	Ref SYSTEMTIME lpSystemTime &
	) Library "kernel32.dll" Alias For "FileTimeToSystemTime"

Function long FindFirstFile ( &
	Ref string filename, &
	Ref WIN32_FIND_DATA findfiledata &
	) Library "kernel32.dll" Alias For "FindFirstFileW"

Function boolean FindNextFile ( &
	ulong handle, &
	Ref WIN32_FIND_DATA findfiledata &
	) Library "kernel32.dll" Alias For "FindNextFileW"

Function boolean FindClose ( &
	ulong handle &
	) Library "kernel32.dll" Alias For "FindClose"

Function long GetModuleFileName ( &
	ULong hModule, &
	Ref String lpFileName, &
	Long nSize &
	) Library "kernel32.dll" Alias For "GetModuleFileNameW"

end prototypes

type variables
Integer ii_file
end variables

forward prototypes
public function integer abrirdocumento (string as_fichero)
private function boolean of_checkbit (long al_number, unsignedinteger ai_bit)
private function datetime of_filedatetimetopb (filetime astr_filetime)
private function integer of_getfiles (string as_filespec, ref string as_filename[], ref datetime adt_updated[], ref datetime ad_fechamayor, ref integer ai_archivo)
end prototypes

public function integer abrirdocumento (string as_fichero);String			ls_Fichero, ls_filename[], ls_Ruta
Datetime		ldt_updated[], ld_fechamayor

Integer		li_Retorno, li_archivo
OleObject	loo_Objeto

ls_Fichero	=	as_Fichero

ls_Ruta	=	Mid(ls_Fichero, 1, LastPos(ls_Fichero, '\') - 1)

IF Pos(ls_Fichero,'"') = 0 THEN ls_Fichero = '"' + ls_Fichero + '"'

IF Not FileExists(as_Fichero) THEN 
	IF Pos(ls_Fichero,'*')>0 THEN
		ii_file = 0
		of_GetFiles(as_Fichero,ls_filename,ldt_updated,ld_fechamayor,li_archivo)
		IF li_archivo > 0 THEN
			ls_Fichero	=	ls_Ruta + ls_filename[li_archivo]
			IF Not FileExists(ls_Fichero) THEN 
				RETURN -1
			END IF
		ELSE
			RETURN -1
		END IF
	ELSE
		RETURN -1
	END IF
ELSE
	RETURN -1
END IF

loo_Objeto	=	CREATE OleObject
li_Retorno	=	loo_Objeto.ConnectToNewObject('WScript.Shell')

IF li_Retorno >= 0 THEN
	loo_Objeto.Run(ls_Fichero, 1, False)
	
	loo_Objeto.DisconnectObject()
	
	li_Retorno	=	1
ELSE
   li_Retorno	=	-1
END IF

DESTROY loo_Objeto

RETURN li_retorno
end function

private function boolean of_checkbit (long al_number, unsignedinteger ai_bit);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_Checkbit
//
// PURPOSE:    This function determines if a certain bit is on or off within
//					the number.
//
// ARGUMENTS:  al_number	- Number to check bits
//             ai_bit		- Bit number ( starting at 1 )
//
// RETURN:		True = On, False = Off
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/03/2006  RolandS		Initial creation
// -----------------------------------------------------------------------------

If Int(Mod(al_number / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False

end function

private function datetime of_filedatetimetopb (filetime astr_filetime);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_FileDateTimeToPB
//
// PURPOSE:    This function converts file datetime to UTC PB datetime.
//
// ARGUMENTS:  astr_filetime	- Filetime structure
//
// RETURN:     Datetime
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/03/2006  RolandS		Initial creation
// -----------------------------------------------------------------------------

DateTime ldt_filedate
SYSTEMTIME lstr_systime
String ls_time
Date ld_fdate
Time lt_ftime

SetNull(ldt_filedate)

If Not FileTimeToSystemTime(astr_filetime, &
			lstr_systime) Then Return ldt_filedate

ld_fdate = Date(lstr_systime.wYear, &
					lstr_systime.wMonth, lstr_systime.wDay)

ls_time = String(lstr_systime.wHour) + ":" + &
			 String(lstr_systime.wMinute) + ":" + &
			 String(lstr_systime.wSecond) + ":" + &
			 String(lstr_systime.wMilliseconds)
lt_ftime = Time(ls_Time)

ldt_filedate = DateTime(ld_fdate, lt_ftime)

Return ldt_filedate

end function

private function integer of_getfiles (string as_filespec, ref string as_filename[], ref datetime adt_updated[], ref datetime ad_fechamayor, ref integer ai_archivo);// -----------------------------------------------------------------------------
// SCRIPT:     n_apibuscaarchivo.of_GetFiles
//
// PURPOSE:    This function recursively returns an array of filenames and
//					their last updated datetime.
//
// ARGUMENTS:  as_filespec	- The directory to get files in.
//             as_filename	- By reference array of file names.
//					adt_updated	- By reference array of last write datetime.
//
// RETURN:		The number of files returned
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/03/2006  RolandS		Initial creation
// 01/23/2012	RolandS		Changed li_file to instance ii_file
// -----------------------------------------------------------------------------

Long ll_Handle
Boolean lb_found, lb_subdir
String ls_filespec, ls_filename
Datetime	ld_ultimafecha
Integer	li_pos

WIN32_FIND_DATA lstr_fd

// append filename pattern
ls_filespec = as_filespec
li_pos	=Pos(ls_filespec,'*')
IF li_pos>0 THEN
	ls_filespec = Mid(ls_filespec,1, LastPos(ls_filespec,'\',1)-1)
END IF
/*
Esto se usa para capturar todos los archivos de una carpeta
Queda comentado para que solo actue con los archivos segun se especifique.

If Right(as_filespec, 1) = "\" Then
	as_filespec += "*.*"
Else
	as_filespec += "\*.*"
End If
*/
// find first file
ll_Handle = FindFirstFile(as_filespec, lstr_fd)
If ll_Handle < 1 Then Return -1

// loop through each file
Do
	// add file to array
	ls_filename = String(lstr_fd.cFilename)
	If ls_filename = "." Or ls_filename = ".." Then
	Else
		lb_subdir = of_CheckBit(lstr_fd.dwFileAttributes, 5)
		If lb_subdir Then
			of_GetFiles(ls_filespec + "\" + ls_filename, as_filename, adt_updated, ad_fechamayor, ai_archivo)
		Else
			// get file properties
			ii_file++
			as_filename[ii_file] = ls_filespec + "\" + ls_filename
			ld_ultimafecha	=	of_FileDateTimeToPB(lstr_fd.ftlastwritetime)
			adt_updated[ii_file] = ld_ultimafecha
			IF ld_ultimafecha > ad_fechamayor then
				ad_fechamayor = ld_ultimafecha
				ai_archivo = ii_file
			END IF
		End If
	End If
	// find next file
	lb_Found = FindNextFile(ll_Handle, lstr_fd)
Loop Until Not lb_Found

// close find handle
FindClose(ll_Handle)

Return ii_file
end function

on n_buscaarchivo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_buscaarchivo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

