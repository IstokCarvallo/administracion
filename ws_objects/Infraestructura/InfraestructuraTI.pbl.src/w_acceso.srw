﻿$PBExportHeader$w_acceso.srw
forward
global type w_acceso from w_acceso_usuario
end type
end forward

global type w_acceso from w_acceso_usuario
end type
global w_acceso w_acceso

on w_acceso.create
call super::create
end on

on w_acceso.destroy
call super::destroy
end on

event ue_validainstalacion;//
end event

event ue_usuario;call super::ue_usuario;RegistryGet("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\ComputerName\ComputerName", "ComputerName", RegString!, is_Computador)
				
gstr_us.Nombre		=	sle_nombre.text
gstr_us.Computador	=	is_Computador

sqlca.LogId		=	sle_nombre.text
sqlca.UserId		=	sle_nombre.text
sqlca.LogPass	=	sle_clave.text
sqlca.DbPass	=	sle_clave.text

This.TriggerEvent("ue_conectar")

gs_base	=	is_base
end event

event ue_datosempresa;call super::ue_datosempresa;gstr_apl.referencia	=	gstr_apl.nom_empresa
end event

type p_aceptar from w_acceso_usuario`p_aceptar within w_acceso
end type

type p_cerrar from w_acceso_usuario`p_cerrar within w_acceso
end type

type sle_nombre from w_acceso_usuario`sle_nombre within w_acceso
end type

type p_1 from w_acceso_usuario`p_1 within w_acceso
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type ddlb_bases from w_acceso_usuario`ddlb_bases within w_acceso
long backcolor = 33554431
end type

type st_titulo from w_acceso_usuario`st_titulo within w_acceso
end type

type st_empresa from w_acceso_usuario`st_empresa within w_acceso
end type

type st_conect from w_acceso_usuario`st_conect within w_acceso
end type

type sle_clave from w_acceso_usuario`sle_clave within w_acceso
end type

type st_2 from w_acceso_usuario`st_2 within w_acceso
end type

type st_1 from w_acceso_usuario`st_1 within w_acceso
end type

type p_mono from w_acceso_usuario`p_mono within w_acceso
end type

