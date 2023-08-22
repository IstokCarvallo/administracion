$PBExportHeader$w_maed_casino_areacontacto.srw
forward
global type w_maed_casino_areacontacto from w_mant_encab_deta
end type
end forward

global type w_maed_casino_areacontacto from w_mant_encab_deta
integer width = 2830
integer height = 2072
string title = "AREAS POR CONTACTOS"
string menuname = ""
end type
global w_maed_casino_areacontacto w_maed_casino_areacontacto

type variables
uo_zona					iuo_zona
uo_casino_areas		iuo_area
uo_personacolacion	iuo_persona

DataWindowChild		idc_area

String					is_rut
end variables

forward prototypes
public subroutine habilitaingreso (string as_columna)
public subroutine buscapersona (integer ai_fila)
public subroutine habilitaencab (boolean ab_habilita)
public function boolean duplicado (string campo)
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

public subroutine buscapersona (integer ai_fila);Str_Busqueda	lstr_Busq

istr_mant.Argumento[1]	= String(iuo_Zona.Codigo)

OpenWithParm(w_busc_personacolacion_porzonaarea, istr_mant)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.Argum) > 1 Then
	If lstr_Busq.argum[1] <> "" Then
		If Not iuo_persona.existe(lstr_Busq.argum[1], True, SQLCa) Then Return
		
		dw_2.Object.cape_codigo[ai_fila]	=	lstr_Busq.argum[1]
		dw_2.Object.cape_apepat[ai_fila]	=	lstr_Busq.argum[2]
		dw_2.Object.cape_apemat[ai_fila]	=	lstr_Busq.argum[3]
		dw_2.Object.cape_nombre[ai_fila]=	lstr_Busq.argum[4]
		dw_2.Object.cape_usuari[ai_fila]	=	lstr_Busq.argum[5]
	End If
End If
end subroutine

public subroutine habilitaencab (boolean ab_habilita);If ab_habilita Then
	dw_2.Object.zona_codigo.Protect					=	0
	dw_2.Object.cape_codigo.Protect					= 	0
	dw_2.Object.zona_codigo.BackGround.Color	=	RGB(255, 255, 255)
	dw_2.Object.cape_codigo.BackGround.Color	=	RGB(255, 255, 255)
	dw_2.Object.zona_codigo.Color					=	0
	dw_2.Object.cape_codigo.Color					=	0
Else
	dw_2.Object.zona_codigo.Protect					=	1
	dw_2.Object.cape_codigo.Protect					= 	1
	dw_2.Object.zona_codigo.BackGround.Color	=	553648127
	dw_2.Object.cape_codigo.BackGround.Color	=	553648127
	dw_2.Object.zona_codigo.Color					=	RGB(255, 255, 255)
	dw_2.Object.cape_codigo.Color					=	RGB(255, 255, 255)	
End If
end subroutine

public function boolean duplicado (string campo);Long		ll_fila
Integer	li_Codigo

li_Codigo = Integer(Campo)

ll_fila	= 	dw_1.Find('caar_codigo = ' + String(li_Codigo), 1, dw_1.RowCount())
			
IF ll_fila > 0  AND ll_fila<>il_fila THEN
	MessageBox("Error","Registro ya fue ingresado anteriormente",Information!, Ok!)
	RETURN True
ELSE
	RETURN False
END IF
end function

on w_maed_casino_areacontacto.create
call super::create
end on

on w_maed_casino_areacontacto.destroy
call super::destroy
end on

event open;call super::open;iuo_zona		=	Create uo_zona
iuo_area		=	Create uo_casino_areas
iuo_persona	=	Create uo_personacolacion
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_FilasEnc, ll_FilasDet

ll_FilasEnc		=	dw_2.Retrieve(iuo_Zona.Codigo, iuo_persona.Codigo)

IF ll_FilasEnc = -1 THEN
	F_ErrorBaseDatos(sqlca, "Lectura de contactos en areas")

	RETURN
ELSEIF ll_FilasEnc > 0 THEN
		istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
		dw_1.GetChild("caar_codigo", idc_area)
		idc_area.SetTransObject(sqlca)
		idc_area.Retrieve(iuo_Zona.Codigo)
		
		ll_FilasDet	=	dw_1.Retrieve(iuo_Zona.Codigo, iuo_persona.Codigo)
			
		IF ll_FilasDet = -1 THEN
			F_ErrorBaseDatos(sqlca, "Lectura de Detalle de contacto de areas")
		
			RETURN
		ELSE
			pb_Eliminar.Enabled  =	Not istr_mant.Solo_Consulta
			pb_Grabar.Enabled	=	Not istr_mant.Solo_Consulta
			pb_ins_det.Enabled	=	Not istr_mant.Solo_Consulta
			pb_eli_det.Enabled	=	Not istr_mant.Solo_Consulta
				
			IF ll_FilasDet > 0 THEN
				pb_imprimir.Enabled	=	True
				
				dw_1.SetRow(1)
				dw_1.SetFocus()
				
				HabilitaEncab(False)
			END IF
		
			pb_ins_det.SetFocus()
		END IF
ELSE
	RETURN
END IF

end event

event ue_nuevo;call super::ue_nuevo;HabilitaEncab(True)
dw_2.Object.cape_codigo[1] = ''
end event

event ue_nuevo_detalle;call super::ue_nuevo_detalle;il_fila			=	dw_1.InsertRow(0)
dw_1.SetRow(il_fila)
dw_1.ScrollToRow(il_fila)
dw_1.SetColumn('caar_codigo')

pb_grabar.Enabled	=	True
end event

event ue_borra_detalle;call super::ue_borra_detalle;il_fila	=	dw_1.GetRow()
dw_1.DeleteRow(il_fila)

IF dw_1.RowCount() > 0 THEN
	il_fila	=	dw_1.RowCount()
	dw_1.SetRow(il_fila)
	dw_1.ScrollToRow(il_fila)
	
	pb_grabar.Enabled		=	True
ELSE
	pb_eli_det.Enabled	=	False
	
END IF
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila

istr_info.titulo	= "INFORME DE CONTACTOS POR AREA"
istr_info.copias	= 1

OpenWithParm(vinf,istr_info)
vinf.dw_1.DataObject = "dw_info_areacontacto"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(iuo_Zona.Codigo)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
END IF

SetPointer(Arrow!)
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_casino_areacontacto
integer x = 41
integer y = 760
integer width = 2341
integer height = 1160
string title = "Detalle de Areas Por Contacto"
string dataobject = "dw_mues_areacontacto"
end type

event dw_1::itemerror;call super::itemerror;Return 1
end event

event dw_1::doubleclicked;//
end event

event dw_1::sqlpreview;//
end event

event dw_1::itemchanged;call super::itemchanged;String	ls_columna, ls_nulo

SetNull(ls_nulo)
ls_columna	=	dwo.name

Choose Case ls_columna
	Case "caar_codigo"
		If Not iuo_area.Existe(iuo_Zona.Codigo, Integer(Data), True, SQLCa) Or Duplicado(Data)Then
			This.Object.caar_codigo[row]	=	Integer(ls_Nulo)
			This.Object.ccos_codigo[row]	=	Integer(ls_Nulo)
			This.Object.caar_nombre[row]	=	ls_nulo
			Return 1
		Else
			This.Object.caar_codigo[row]	=	iuo_area.caar_codigo
			This.Object.caar_nombre[row]	=	iuo_area.caar_nombre
			This.Object.ccos_codigo[row]	=	iuo_area.ccos_codigo
			This.Object.zona_codigo[row]	=	iuo_Zona.Codigo
			This.Object.cape_codigo[row]	=	iuo_persona.Codigo			
		End If
End Choose
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_casino_areacontacto
integer x = 475
integer y = 52
integer width = 1403
integer height = 636
string dataobject = "dw_encab_personalcontacto"
end type

event dw_2::itemchanged;call super::itemchanged;integer	li_fila
String	ls_nulo, ls_columna

SetNull(ls_nulo)

ls_columna	=	dwo.Name

Choose Case ls_columna
	Case "zona_codigo"
		If Not iuo_zona.existe(Integer(Data), True, SQLCa) Then
			This.SetItem(Row, ls_Columna, Integer(ls_Nulo))
			Return 1
		End If
		
	Case "cape_codigo"
		is_rut = F_verrut(data, True)
		If is_rut = ""  Then
			This.SetItem(row, ls_columna, ls_nulo)
			Return 1
		Else
			If Not iuo_persona.existe(is_rut, True, sqlca) Then
				This.Object.cape_codigo[Row]		=	ls_nulo
				This.Object.cape_apepat[Row]		=	ls_nulo
				This.Object.cape_apemat[Row]	=	ls_nulo
				This.Object.cape_nombre[Row]	=	ls_nulo
				This.Object.cape_usuari[Row]		=	ls_nulo
				Return 1
			Else
				This.Object.cape_codigo[Row]		=	iuo_persona.Codigo
				This.Object.cape_apepat[Row]		=	iuo_persona.ApellidoPat
				This.Object.cape_apemat[Row]	=	iuo_persona.ApellidoMat
				This.Object.cape_nombre[Row]	=	iuo_persona.Nombres
				This.Object.cape_usuari[Row]		=	iuo_persona.Usuario
				HabilitaEncab(False)
				Parent.TriggerEvent("ue_recuperadatos")
			End If
		End If
End Choose


end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

event dw_2::buttonclicked;call super::buttonclicked;String	ls_columna

ls_columna	=	dwo.name

Choose Case ls_columna
	Case "b_personal"
		BuscaPersona(Row)
		HabilitaEncab(False)
		Parent.TriggerEvent("ue_recuperadatos")
		
End Choose


end event

event dw_2::itemfocuschanged;call super::itemfocuschanged;String ls_Colunma

ls_Colunma = dwo.Name

IF is_rut <> "" THEN
	IF ls_Colunma = "cape_codigo" THEN
		This.Object.cape_codigo[row] = is_rut
		This.Object.cape_codigo.EditMask.Mask	=	"XXXXXXXXXX"
		
		IF is_rut <> "" THEN
			This.Object.cape_codigo[row] = is_rut
			This.SetItem(il_fila, ls_Colunma, String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		END IF
	ELSE
		This.Object.cape_codigo[row] = is_rut
		This.Object.cape_codigo.EditMask.Mask	=	"###.###.###-!"
		This.SetItem(il_fila,ls_Colunma, is_rut)
	END IF
END IF
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_casino_areacontacto
integer x = 2510
integer y = 296
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_casino_areacontacto
boolean visible = false
integer x = 2510
integer y = 476
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_casino_areacontacto
integer x = 2510
integer y = 660
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_casino_areacontacto
integer x = 2510
integer y = 836
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_casino_areacontacto
integer x = 2510
integer y = 1016
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_casino_areacontacto
integer x = 2510
integer y = 1404
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_casino_areacontacto
integer x = 2510
integer y = 1576
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_casino_areacontacto
integer x = 2510
integer y = 116
end type

