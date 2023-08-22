$PBExportHeader$infraestructutati.sra
$PBExportComments$Generated Application Object
forward
global type infraestructutati from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
str_aplicacion		gstr_apl
str_usuario			gstr_us
str_parempresa	gstr_parempresa

Integer			gi_emprconex, gi_CodPlanta, gi_CodExport, gi_Packing, gi_Emisor_Electronico, gi_Conecion_GuiaElectronica
Long				Sistema_Operativo
String				nom_empresa, rut_empresa, dir_empresa, tel_empresa, gs_tipo, gs_opcion, gs_windows, &
					gs_base, gs_menuprincipal,  gs_comprobante, gs_Password, gs_Ambiente = "Windows", &
					gs_LogoEmpresa, gs_LogoImpresion, gs_LogoGobierno, is_base, gs_pfijopallet, gs_Ubicacion_DTE, gs_Ubicacion_pdfdte

w_informes		vinf
inet				ginet_Base

uo_ApiWindows	iuo_API


end variables

global type infraestructutati from application
string appname = "infraestructutati"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Flat Design Blue"
boolean nativepdfvalid = true
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "\Desarrollo 17\Imagenes\Sistemas\Infraestructura.ico"
string appruntimeversion = "22.0.0.1900"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
end type
global infraestructutati infraestructutati

type prototypes

end prototypes

type variables
Constant	Date			id_FechaLiberacion	=	Date('2019-02-04')
Constant	Time			it_HoraLiberacion		=	Now()

end variables

on infraestructutati.create
appname="infraestructutati"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on infraestructutati.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;SetPointer ( HourGlass! )
ToolBarPopMenuText		=	"Izquierda,Arriba,Derecha,Abajo,Flotando,Muestra Texto"
MicroHelpDefault			=	"Listo"
gstr_apl.titulo				=	"SISTEMA CONTROL DE INFRAESTRUCTURA TI"

gstr_apl.ini					=	"InfraestructuraTI.ini"
gstr_apl.bmp				=	"\Desarrollo 17\Imagenes\Sistemas\Infraestructura.png"
gstr_apl.Icono				=	"\Desarrollo 17\Imagenes\Sistemas\Infraestructura.ico"
gstr_apl.liberacion			=	F_Fecha_Carta(id_FechaLiberacion, 3) + "  " + &
									String(it_HoraLiberacion)
gstr_apl.version			=	"5.22.28022023"
gstr_apl.fechalibera		=  id_FechaLiberacion
gstr_apl.CodigoSistema	=	525
gstr_apl.NombreSistema	=	"Infraestructura TI"

Open(w_acceso)

IF Message.DoubleParm <> 1 THEN
	HALT
	RETURN
END IF

IF AccesoSistemaValido() THEN
	ParEmpresa()
	Open(w_main)
ELSE
	HALT
	RETURN
END IF
end event

