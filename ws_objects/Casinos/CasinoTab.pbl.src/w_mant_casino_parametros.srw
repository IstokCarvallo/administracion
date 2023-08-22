$PBExportHeader$w_mant_casino_parametros.srw
forward
global type w_mant_casino_parametros from w_mant_directo
end type
end forward

global type w_mant_casino_parametros from w_mant_directo
integer width = 2930
integer height = 2036
string title = "MANTENCIÓN DE PARAMETROS DE CASINO"
end type
global w_mant_casino_parametros w_mant_casino_parametros

type variables
uo_zona				iuo_zona
uo_casino_areas	iuo_areas
end variables

on w_mant_casino_parametros.create
call super::create
end on

on w_mant_casino_parametros.destroy
call super::destroy
end on

event open;call super::open;iuo_zona		=	Create uo_zona
iuo_areas	=	Create uo_casino_areas
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_FilasDet, ll_FilasEnc

ll_FilasDet	=	dw_1.Retrieve()
	
IF ll_FilasDet = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de Detalle de Colacion")

	RETURN
ELSE
	pb_Eliminar.Enabled  =	Not istr_mant.Solo_Consulta
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
	pb_insertar.Enabled	=	Not istr_mant.Solo_Consulta
	pb_eliminar.Enabled	=	Not istr_mant.Solo_Consulta
		
	IF ll_FilasDet > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()
	END IF

	pb_insertar.SetFocus()
END IF

end event

type st_encabe from w_mant_directo`st_encabe within w_mant_casino_parametros
boolean visible = false
integer x = 2455
integer y = 1388
integer width = 219
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_casino_parametros
integer y = 452
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_casino_parametros
integer y = 144
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_casino_parametros
integer y = 812
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_casino_parametros
integer y = 632
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_casino_parametros
integer y = 1632
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_casino_parametros
boolean visible = false
integer y = 1172
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_casino_parametros
integer y = 992
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_casino_parametros
integer y = 60
integer width = 2217
integer height = 1760
string dataobject = "dw_mues_parametros_casino"
boolean maxbox = true
end type

event dw_1::buttonclicked;call super::buttonclicked;String	ls_columna
Integer	li_area
str_mant	lstr_mant

SetNull(li_area)
ls_columna = dwo.Name

CHOOSE CASE ls_columna
	CASE "b_area"
		lstr_mant.argumento[1]	=	String(This.Object.zona_codigo[row])
		
		IF IsNull(lstr_mant.argumento[1]) OR Integer(lstr_mant.argumento[1]) < 1 THEN
			MessageBox("Error", "Debe ingresar primero un código de zona.", Exclamation!)
			
			This.Object.caar_codigo[row] = li_area
			This.Object.caar_nombre[row] = String(li_area)
			
		ELSE
			OpenWithParm(w_busc_casino_areas, lstr_mant)
			lstr_mant	=	Message.PowerobjectParm
			
			IF UpperBound(lstr_mant.argumento) > 4 THEN
				This.Object.caar_codigo[row] = Integer(lstr_mant.argumento[4])
				This.Object.caar_nombre[row] = lstr_mant.argumento[4]
				
			ELSE
				This.Object.caar_codigo[row] = li_area
				This.Object.caar_nombre[row] = String(li_area)
			END IF
		END IF
		
END CHOOSE
end event

event dw_1::itemchanged;call super::itemchanged;String	ls_columna
Integer	li_area, li_fila, li_cuenta

SetNull(li_area)
ls_columna = dwo.Name

CHOOSE CASE ls_columna
	CASE "zona_codigo"
		IF NOT iuo_zona.Existe(Integer(data), True, sqlca) THEN
			This.Object.zona_codigo[row] = li_area
			Return 1
		END IF
		
		This.Object.caar_codigo[row] = li_area
		This.Object.caar_nombre[row] = String(li_area)
			
	CASE "caar_codigo"
		IF NOT iuo_areas.Existe(This.Object.zona_codigo[row], Integer(data), True, Sqlca) THEN
			This.Object.caar_codigo[row] = li_area
			This.Object.caar_nombre[row] = String(li_area)
			Return 1
			
		ELSE
			This.Object.caar_codigo[row] = iuo_areas.caar_codigo
			This.Object.caar_nombre[row] = iuo_areas.caar_nombre
		END IF
	
	CASE "capa_activa"
		FOR li_fila = 1 TO dw_1.RowCount()
			IF Data = '1' THEN
				This.Object.capa_activa[li_fila]	=	0
			END IF
		NEXT
		
END CHOOSE
end event

event dw_1::itemerror;call super::itemerror;
Return 1
end event

