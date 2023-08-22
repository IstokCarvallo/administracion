$PBExportHeader$w_info_consumosdiarios.srw
forward
global type w_info_consumosdiarios from w_para_informes
end type
type dw_1 from datawindow within w_info_consumosdiarios
end type
end forward

global type w_info_consumosdiarios from w_para_informes
integer width = 2807
integer height = 1608
string title = "INFORME DE CONSUMOS DIARIOS"
dw_1 dw_1
end type
global w_info_consumosdiarios w_info_consumosdiarios

type variables
DataWindowChild			ldwc_area, ldwc_contratista, ldwc_tico, ldwc_caco

uo_zona						iuo_zona
uo_casino_areas			iuo_area
uo_centrocosto				iuo_ccosto
uo_clienprove				iuo_contra
uo_casino_tipocolacion	uo_tico
uo_casino_colacion		uo_caco

end variables

on w_info_consumosdiarios.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_info_consumosdiarios.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.GetChild("area", ldwc_area)
dw_1.GetChild("contratista", ldwc_contratista)
dw_1.GetChild("tico", ldwc_tico)
dw_1.GetChild("caco", ldwc_caco)

ldwc_area.SetTransObject(sqlca)
ldwc_contratista.SetTransObject(sqlca)
ldwc_tico.SetTransObject(sqlca)
ldwc_caco.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_1.InsertRow(0)
ldwc_contratista.Retrieve(1)

iuo_zona							=	Create uo_zona						
iuo_area							=	Create uo_casino_areas			
iuo_ccosto						=	Create uo_centrocosto			
iuo_contra						=	Create uo_clienprove				
uo_tico							=	Create uo_casino_tipocolacion	
uo_caco							=	Create uo_casino_colacion		

dw_1.Object.fecinicio[1]		=	RelativeDate(Today(), -365)
dw_1.Object.fectermino[1]	=	Today()
end event

type pb_excel from w_para_informes`pb_excel within w_info_consumosdiarios
integer x = 2313
integer y = 444
end type

type st_computador from w_para_informes`st_computador within w_info_consumosdiarios
integer x = 1074
end type

type st_usuario from w_para_informes`st_usuario within w_info_consumosdiarios
integer x = 1074
end type

type st_temporada from w_para_informes`st_temporada within w_info_consumosdiarios
integer x = 1074
end type

type p_logo from w_para_informes`p_logo within w_info_consumosdiarios
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_consumosdiarios
integer x = 242
integer width = 1929
integer height = 96
string text = "Informe de Consumos Diarios"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_consumosdiarios
integer x = 2299
integer y = 732
end type

event pb_acepta::clicked;Integer 	li_Zona, li_Area, li_CCosto, li_Tico, li_Caco, li_Estado, li_Filtro, li_ConsPer
Date 		ld_FechaIni, ld_FechaTer
String 	ls_RutCont, ls_filtro
Long		fila

SetPointer(HourGlass!)

dw_1.AcceptText()

// Acepta Zona //
IF dw_1.Object.todoszona[1] = 1 THEN
	li_Zona 		=	-1
ELSE
	li_Zona = dw_1.Object.zona[1]
	IF IsNull(li_Zona) THEN
		MessageBox( "Zona Errónea", "Falta seleccionar una Zona.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
END IF
// Acepta area //
IF dw_1.Object.todosarea[1] = 1 THEN
	IF dw_1.Object.consarea[1] = 1 THEN
		li_Area = -9
	ELSE
		li_Area = -1
	END IF
ELSE
	li_Area = dw_1.Object.area[1]
	IF IsNull(li_Area) THEN
		MessageBox( "Area Errónea", "Falta seleccionar una Area.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
END IF
// Acepta ccosto //
IF dw_1.Object.todosccosto[1] = 1 THEN
	IF dw_1.Object.consccosto[1] = 1 THEN
		li_CCosto = -9
	ELSE
		li_CCosto = -1
	END IF
ELSE
	li_CCosto = dw_1.Object.ccosto[1]
	IF IsNull(li_CCosto) THEN
		MessageBox( "C. Costo Erróneo", "Falta seleccionar una C. Costo.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
END IF
// Acepta tico //
IF dw_1.Object.todostico[1] = 1 THEN
	IF dw_1.Object.constico[1] = 1 THEN
		li_Tico 		= -9
		ls_filtro	=	"Cons. Tico/"
	ELSE
		li_Tico 		= -1
		ls_filtro	=	"Todos Tico/"
	END IF
ELSE
	li_Tico = dw_1.Object.tico[1]
	IF IsNull(li_Tico) THEN
		MessageBox( "Tipo de Colación Erróneo", "Falta seleccionar un Tipo de Colación.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
	ls_filtro	=	"Tico" + String(li_Tico) + "/"
END IF
// Acepta caco //
IF dw_1.Object.todoscaco[1] = 1 THEN
	IF dw_1.Object.conscaco[1] = 1 THEN
		li_Caco 		= -9
		ls_filtro	=	ls_filtro + "Cons. Caco/"
	ELSE
		li_Caco 		= -1
		ls_filtro	=	ls_filtro + "Todos Caco/"
	END IF
ELSE
	li_Caco = dw_1.Object.caco[1]
	IF IsNull(li_Caco) THEN
		MessageBox( "Colación Errónea", "Falta seleccionar una Colación.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
	ls_filtro	=	ls_filtro + "Caco " + String(li_Caco) + " /"
END IF
// Acepta estado //
IF dw_1.Object.todosesta[1] = 1 THEN
	li_Estado 	= -1
	ls_filtro	=	ls_filtro + "Todos Estado/"
ELSE
	li_Estado = dw_1.Object.estado[1]
	IF IsNull(li_Estado) THEN
		MessageBox( "Estado Erróneo", "Falta seleccionar un Estado.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
	ls_filtro	=	ls_filtro + "Estado " + String(li_Estado) + "/"
END IF
// Acepta filtro //
IF dw_1.Object.todosfiltro[1] = 1 THEN
	li_Filtro 	= -1
	ls_filtro	=	ls_filtro + "Todos Filtro/"
ELSE
	li_Filtro = dw_1.Object.filtro[1]
	IF IsNull(li_Filtro) THEN
		MessageBox( "Filtro Erróneo", "Falta seleccionar un Filtro.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
	ls_filtro	=	ls_filtro + "Filtro " + String(li_Filtro) + " /"
END IF
// Acepta contratista //
IF dw_1.Object.todoscontra[1] = 1 THEN
	ls_RutCont 	= '-1'
	ls_filtro	=	ls_filtro + "Todos Cont./"
ELSE
	ls_RutCont = dw_1.Object.contratista[1]
	IF IsNull(ls_RutCont) THEN
		MessageBox( "Contratista Erróneo", "Falta seleccionar un Contratista.", &
	             StopSign!, Ok!)
		RETURN				 
   END IF
	ls_filtro	=	ls_filtro + "Cont. " + String(ls_RutCont) + "/"
END IF

IF dw_1.Object.conspers[1] = 1 THEN
	li_ConsPer	=	-9
	ls_filtro	=	ls_filtro + "Cons. Pers./"
ELSE
	li_ConsPer	=	-1
	ls_filtro	=	ls_filtro + "Todos Pers./"
END IF

ld_FechaIni	=	dw_1.Object.fecinicio[1]
ld_FechaTer	=	dw_1.Object.fectermino[1]
IF ld_FechaIni > ld_FechaTer THEN 
	MessageBox( "Fechas Erróneas", "La Fecha de Termino no puede ser Inferior a la de Inicio.",  StopSign!, Ok!)
	RETURN
END IF

istr_info.titulo	= "INFORME DE CONSUMOS DIARIOS"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_casino_infoconsumosdiarios"
vinf.dw_1.SetTransObject(sqlca)

fila = vinf.dw_1.Retrieve(li_Zona, li_Area, li_CCosto, ld_FechaIni, ld_FechaTer, &
                          ls_RutCont, li_Tico, li_Caco, li_Estado, li_Filtro, li_ConsPer)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify("t_filtro.text = 'Filtro " + ls_filtro + "'")
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo) 
END IF

SetPointer(Arrow!)

end event

type pb_salir from w_para_informes`pb_salir within w_info_consumosdiarios
integer x = 2295
integer y = 1096
end type

type dw_1 from datawindow within w_info_consumosdiarios
integer x = 242
integer y = 420
integer width = 1929
integer height = 992
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_info_resumencolacion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String	ls_columna
Integer	li_nulo

SetNull(li_nulo)

ls_columna	=	dwo.Name

CHOOSE CASE ls_columna
	CASE "zona"
		IF NOT iuo_zona.Existe(Integer(data), True, sqlca) THEN
			This.Object.zona[Row]		=	li_nulo
			Return 1
		ELSE
			ldwc_area.Retrieve(Integer(data))
			ldwc_tico.Retrieve(Integer(data))
			This.Object.area[row]		=	li_nulo
			This.Object.area[row]		=	li_nulo
			This.Object.tico[row]		=	li_nulo
			This.Object.caco[row]		=	li_nulo
		END IF

	CASE "area"
		IF NOT iuo_area.Existe(This.Object.zona[row], Integer(data), True, sqlca) THEN
			This.Object.area[Row]		=	li_nulo
			Return 1
		END IF

	CASE "ccosto"
		IF NOT iuo_ccosto.Existe(Integer(data), True, sqlca) THEN
			This.Object.ccosto[Row]		=	li_nulo
			Return 1
		END IF

	CASE "contratista"
		IF NOT iuo_contra.Existe(data, True, sqlca) THEN
			This.Object.ccosto[Row]		=	String(li_nulo)
			Return 1
		END IF

	CASE "tico"
		IF NOT uo_tico.Existe(This.Object.zona[row], Integer(data), True, sqlca) THEN
			This.Object.tico[Row]		=	li_nulo
			Return 1
		ELSE
			ldwc_caco.Retrieve(This.Object.zona[row], Integer(data))
			This.Object.caco[row]		=	li_nulo
		END IF

	CASE "caco"
		IF NOT uo_caco.Existe(This.Object.zona[row], This.Object.tico[row], Integer(data), True, sqlca) THEN
			This.Object.caco[Row]		=	li_nulo
			Return 1
		END IF
		
	CASE "todoszona"
		IF Data = '1' THEN
			This.Object.zona[row]			=	li_nulo
			This.Object.area[row]			=	li_nulo
			This.Object.area[row]			=	li_nulo
			This.Object.tico[row]			=	li_nulo
			This.Object.caco[row]			=	li_nulo
			This.Object.todosarea[row]		=	1
			This.Object.todostico[row]		=	1
			This.Object.todoscaco[row]		=	1
			
		END IF
		
	CASE "todosarea"
		IF Data = '1' THEN
			This.Object.area[row]			=	li_nulo
		END IF
		
	CASE "todosccosto"
		IF Data = '1' THEN
			This.Object.ccosto[row]			=	li_nulo
		END IF
		
	CASE "todoscontra"
		IF Data = '1' THEN
			This.Object.contratista[row]	=	String(li_nulo)
		END IF
		
	CASE "todostico"
		IF Data = '1' THEN
			This.Object.tico[row]			=	li_nulo
			This.Object.caco[row]			=	li_nulo
			This.Object.todoscaco[row]		=	1
		END IF
		
	CASE "todosesta"
		IF Data = '1' THEN
			This.Object.estado[row]			=	li_nulo
		END IF
		
	CASE "todosfiltro"
		IF Data = '1' THEN
			This.Object.filtro[row]			=	li_nulo
		END IF
		
END CHOOSE
end event

event itemerror;Return 1
end event

