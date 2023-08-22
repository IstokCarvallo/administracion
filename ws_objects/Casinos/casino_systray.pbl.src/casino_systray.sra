$PBExportHeader$casino_systray.sra
$PBExportComments$Generated Application Object
forward
global type casino_systray from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

Str_mant			istr_mant
Str_aplicacion	gstr_apl
Str_usuario		gstr_us

Integer			ii_Pos
String				is_base
Boolean			ib_connected
end variables

global type casino_systray from application
string appname = "casino_systray"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "\Desarrollo 17\Imagenes\Sistemas\Casinos.ico"
string appruntimeversion = "22.0.0.1892"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
end type
global casino_systray casino_systray

type prototypes
FUNCTION ulong FindWindow(ref string  classname, ref string   windowname)  LIBRARY "user32.dll" ALIAS FOR "FindWindowA;ansi"
end prototypes

type variables
Constant	Date			id_FechaLiberacion	=	Date('2019-02-04')
Constant	Time			it_HoraLiberacion		=	Now()
end variables

on casino_systray.create
appname="casino_systray"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on casino_systray.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;ulong hWnd
string ls_title, ls_class//, ls_name

gstr_apl.ini				=	"casino_systray.ini"
gstr_apl.icono			=	"\Desarrollo 17\Imagenes\Sistemas\Casinos.ico"

SetPointer ( HourGlass! )

ls_title = "Movimientos Casino"
SetNull(ls_class)

hWnd = FindWindow(ls_class, ls_title)

IF NOT IsNull(hWnd) THEN
    // WM_CLOSE = &H10
    send(hwnd, 16, 0, 0)
END IF

gstr_apl.version			=	"5.22.28022023"
gstr_apl.fechalibera		=  id_FechaLiberacion
gstr_apl.CodigoSistema	=	21
gstr_apl.NombreSistema	=	"SysTray Casino"

RegistryGet("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\ComputerName\ComputerName", &
				"ComputerName", RegString!, gstr_us.Computador)

Open(w_movto_casinos_systray)
end event

