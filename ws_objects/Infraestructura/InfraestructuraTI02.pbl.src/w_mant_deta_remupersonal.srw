$PBExportHeader$w_mant_deta_remupersonal.srw
forward
global type w_mant_deta_remupersonal from w_mant_detalle
end type
end forward

global type w_mant_deta_remupersonal from w_mant_detalle
integer width = 2866
integer height = 1128
string title = "ASIGNACION EQUIPOS"
end type
global w_mant_deta_remupersonal w_mant_deta_remupersonal

type variables

end variables

on w_mant_deta_remupersonal.create
call super::create
end on

on w_mant_deta_remupersonal.destroy
call super::destroy
end on

event open;call super::open;istr_mant.dw.ShareData(dw_1)
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_remupersonal
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_remupersonal
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_remupersonal
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_remupersonal
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_remupersonal
boolean visible = false
integer x = 2469
integer y = 348
boolean enabled = false
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_remupersonal
integer x = 2469
integer y = 140
boolean default = false
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_remupersonal
boolean visible = false
integer x = 2469
integer y = 556
boolean enabled = false
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_remupersonal
integer width = 2318
integer height = 908
string dataobject = "dw_mues_remupersonal"
end type

