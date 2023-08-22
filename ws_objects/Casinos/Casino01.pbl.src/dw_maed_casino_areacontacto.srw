$PBExportHeader$dw_maed_casino_areacontacto.srw
forward
global type dw_maed_casino_areacontacto from w_mant_encab_deta
end type
end forward

global type dw_maed_casino_areacontacto from w_mant_encab_deta
integer width = 2747
string title = "AREAS DE CONTACTO"
end type
global dw_maed_casino_areacontacto dw_maed_casino_areacontacto

type variables
uo_zona	iuo_zona

Integer	ii_zona, ii_area
end variables

forward prototypes
public subroutine habilitaingreso (string as_columna)
public subroutine habilitaencab (boolean ib_habilita)
end prototypes

public subroutine habilitaingreso (string as_columna);Boolean	lb_Estado = True

IF as_Columna <> "zona_codigo" AND &
	(dw_2.Object.zona_codigo[il_Fila] = 0 OR IsNull(dw_2.Object.zona_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF

IF as_Columna <> "caar_codigo" AND &
	(dw_2.Object.caar_codigo[il_Fila] = 0 OR IsNull(dw_2.Object.caar_codigo[il_Fila])) THEN
	lb_Estado	=	False
END IF

pb_ins_det.Enabled = lb_Estado
end subroutine

public subroutine habilitaencab (boolean ib_habilita);IF ib_Habilita THEN
	dw_2.Object.zona_codigo.Protect				=	0
	dw_2.Object.caar_codigo.Protect				= 	0
	dw_2.Object.zona_codigo.BackGround.Color	=	RGB(255, 255, 255)
	dw_2.Object.caar_codigo.BackGround.Color	=	RGB(255, 255, 255)
ELSE
	dw_2.Object.zona_codigo.Protect				=	1
	dw_2.Object.caar_codigo.Protect				= 	1
	dw_2.Object.zona_codigo.BackGround.Color	=	RGB(192, 192, 192)
	dw_2.Object.caar_codigo.BackGround.Color	=	RGB(192, 192, 192)
END IF

RETURN
end subroutine

on dw_maed_casino_areacontacto.create
call super::create
end on

on dw_maed_casino_areacontacto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;iuo_zona		=	Create uo_zona
end event

type dw_1 from w_mant_encab_deta`dw_1 within dw_maed_casino_areacontacto
integer y = 692
integer width = 2281
integer height = 1384
string dataobject = "dw_mues_areacontacto"
end type

type dw_2 from w_mant_encab_deta`dw_2 within dw_maed_casino_areacontacto
integer x = 247
integer y = 52
integer width = 1440
integer height = 612
string dataobject = "dw_maed_areas_zonas"
end type

event dw_2::itemchanged;call super::itemchanged;integer	li_fila
String	ls_nulo, ls_columna

SetNull(ls_nulo)

ls_columna	=	dwo.Name

CHOOSE CASE ls_columna
	CASE "zona_codigo"
		IF NOT iuo_zona.existe(Integer(Data), True, SQLCa) THEN
			This.Object.zona_codigo[row]	=	Integer(ls_nulo)
			Return 1
		END IF
		
		ii_zona	=	Integer(Data)
		
	CASE "caar_codigo"
		ii_area	=	Integer(Data)
		
END CHOOSE


end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within dw_maed_casino_areacontacto
integer x = 2400
integer y = 348
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within dw_maed_casino_areacontacto
integer x = 2400
integer y = 528
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within dw_maed_casino_areacontacto
integer x = 2400
integer y = 712
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within dw_maed_casino_areacontacto
integer x = 2400
integer y = 888
end type

type pb_salir from w_mant_encab_deta`pb_salir within dw_maed_casino_areacontacto
integer x = 2400
integer y = 1068
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within dw_maed_casino_areacontacto
integer x = 2400
integer y = 1456
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within dw_maed_casino_areacontacto
integer x = 2400
integer y = 1628
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within dw_maed_casino_areacontacto
integer x = 2400
integer y = 168
end type

