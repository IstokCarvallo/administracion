$PBExportHeader$control_casinos.sra
$PBExportComments$Generated Application Object
forward
global type control_casinos from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
str_aplicacion	   gstr_apl
str_usuario		   gstr_us 
str_paramcontabilidad gstr_parcontab
str_parametros	gstr_param

String			nom_empresa, rut_empresa, dir_empresa, tel_empresa, gs_base, &
				gs_CodEmbalaje, gs_disco, gs_password, gs_arreglo1, gs_traspasa,&
				gs_opcion, gs_windows, gs_comprobante, gs_Ambiente = "Windows", &
				gs_LogoEmpresa, gs_LogoImpresion, gs_LogoGobierno, is_base, gs_pfijopallet, gs_Ubicacion_DTE, gs_Ubicacion_pdfdte

w_informes	vinf
inet			ginet_Base
Integer		lar_cuenta, gi_nro_sem, gi_emprconex, gi_CodExport, gi_CodPlanta, gi_Packing, gi_Emisor_Electronico, gi_Conecion_GuiaElectronica
Long			Sistema_Operativo

str_parempresa	gstr_parempresa
str_paramplanta	gstr_paramplanta
uo_ApiWindows	iuo_API

end variables

global type control_casinos from application
string appname = "control_casinos"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
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
global control_casinos control_casinos

type variables
Constant Date			id_FechaLiberacion = Date('2019-02-04')
Constant Time			it_HoraLiberacion  = Now()

end variables

on control_casinos.create
appname="control_casinos"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on control_casinos.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;SetPointer (HourGlass!)

ToolBarPopMenuText		=	"Izquierda,Arriba,Derecha,Abajo,Flotando,Muestra Texto"
MicroHelpDefault			=	"Listo"
gstr_apl.titulo				=	"SISTEMA DE CASINOS"
gstr_apl.ini					=	"Casino.ini"
gstr_apl.bmp				=	"\Desarrollo 17\Imagenes\Sistemas\Casinos.jpg"
gstr_apl.Icono				=	"\Desarrollo 17\Imagenes\Sistemas\Casinos.ico"
gstr_apl.liberacion			=	F_Fecha_Carta(id_FechaLiberacion, 3) + "  " + String(it_HoraLiberacion)
gstr_apl.fechalibera		=  id_FechaLiberacion
gstr_apl.version			=	"5.22.28022023"
//String(id_Version)

gstr_apl.CodigoSistema	=	304
gstr_apl.NombreSistema	=	"Casinos"
Open(w_acceso)
ParEmpresa()

IF Message.DoubleParm <> 1 THEN
	HALT
	RETURN
END IF

IF AccesoSistemaValido() THEN
	Open(w_main)
ELSE
	HALT
	RETURN
END IF
end event

