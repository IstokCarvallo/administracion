$PBExportHeader$w_info_consumosdiarios.srw
forward
global type w_info_consumosdiarios from w_para_informes
end type
type dw_1 from datawindow within w_info_consumosdiarios
end type
end forward

global type w_info_consumosdiarios from w_para_informes
integer width = 2807
integer height = 1692
string title = "INFORME DE CONSUMOS DIARIOS"
dw_1 dw_1
end type
global w_info_consumosdiarios w_info_consumosdiarios

type variables
DataWindowChild			ldwc_area, ldwc_contratista, ldwc_tico, ldwc_caco, idwc_CCosto

uo_zona						iuo_zona
uo_casino_areas			iuo_area
uo_centrocosto				iuo_ccosto
uo_clienprove				iuo_contra
uo_casino_tipocolacion	iuo_tico
uo_casino_colacion		iuo_caco
uo_Empresa					iuo_Empresa

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
dw_1.GetChild("ccosto", idwc_CCosto)

ldwc_area.SetTransObject(sqlca)
ldwc_contratista.SetTransObject(sqlca)
ldwc_tico.SetTransObject(sqlca)
ldwc_caco.SetTransObject(sqlca)
idwc_CCosto.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

dw_1.InsertRow(0)
ldwc_contratista.Retrieve(1)
ldwc_area.Retrieve(-1, '*')
idwc_CCosto.Retrieve('*')

iuo_zona			=	Create uo_zona						
iuo_area			=	Create uo_casino_areas			
iuo_ccosto		=	Create uo_centrocosto			
iuo_contra		=	Create uo_clienprove				
iuo_tico			=	Create uo_casino_tipocolacion	
iuo_caco			=	Create uo_casino_colacion		
iuo_Empresa	=	Create uo_Empresa	

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
String 	ls_RutCont, ls_filtro, ls_Empresa
Long		fila

SetPointer(HourGlass!)

dw_1.AcceptText()

// Acepta Zona //
If dw_1.Object.todoszona[1] = 1 Then
	li_Zona 		=	-1
Else
	li_Zona = dw_1.Object.zona[1]
	If IsNull(li_Zona) Then
		MessageBox( "Zona Errónea", "Falta seleccionar una Zona.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
End If
// Acepta area //
If dw_1.Object.todosarea[1] = 1 Then
	If dw_1.Object.consarea[1] = 1 Then
		li_Area = -9
	Else
		li_Area = -1
	End If
Else
	li_Area = dw_1.Object.area[1]
	If IsNull(li_Area) Then
		MessageBox( "Area Errónea", "Falta seleccionar una Area.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
End If
// Acepta ccosto //
If dw_1.Object.todosccosto[1] = 1 Then
	If dw_1.Object.consccosto[1] = 1 Then
		li_CCosto = -9
	Else
		li_CCosto = -1
	End If
Else
	li_CCosto = dw_1.Object.ccosto[1]
	If IsNull(li_CCosto) Then
		MessageBox( "C. Costo Erróneo", "Falta seleccionar una C. Costo.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
End If
// Acepta tico //
If dw_1.Object.todostico[1] = 1 Then
	If dw_1.Object.constico[1] = 1 Then
		li_Tico 		= -9
		ls_filtro	=	"Cons. Tico/"
	Else
		li_Tico 		= -1
		ls_filtro	=	"Todos Tico/"
	End If
Else
	li_Tico = dw_1.Object.tico[1]
	If IsNull(li_Tico) Then
		MessageBox( "Tipo de Colación Erróneo", "Falta seleccionar un Tipo de Colación.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	"Tico" + String(li_Tico) + "/"
End If
// Acepta caco //
If dw_1.Object.todoscaco[1] = 1 Then
	If dw_1.Object.conscaco[1] = 1 Then
		li_Caco 		= -9
		ls_filtro	=	ls_filtro + "Cons. Caco/"
	Else
		li_Caco 		= -1
		ls_filtro	=	ls_filtro + "Todos Caco/"
	End If
Else
	li_Caco = dw_1.Object.caco[1]
	If IsNull(li_Caco) Then
		MessageBox( "Colación Errónea", "Falta seleccionar una Colación.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	ls_filtro + "Caco " + String(li_Caco) + " /"
End If
// Acepta estado //
If dw_1.Object.todosesta[1] = 1 Then
	li_Estado 	= -1
	ls_filtro	=	ls_filtro + "Todos Estado/"
Else
	li_Estado = dw_1.Object.estado[1]
	If IsNull(li_Estado) Then
		MessageBox( "Estado Erróneo", "Falta seleccionar un Estado.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	ls_filtro + "Estado " + String(li_Estado) + "/"
End If
// Acepta filtro //
If dw_1.Object.todosfiltro[1] = 1 Then
	li_Filtro 	= -1
	ls_filtro	=	ls_filtro + "Todos Filtro/"
Else
	li_Filtro = dw_1.Object.filtro[1]
	If IsNull(li_Filtro) Then
		MessageBox( "Filtro Erróneo", "Falta seleccionar un Filtro.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	ls_filtro + "Filtro " + String(li_Filtro) + " /"
End If
// Acepta contratista //
If dw_1.Object.todoscontra[1] = 1 Then
	ls_RutCont 	= '-1'
	ls_filtro	=	ls_filtro + "Todos Cont./"
Else
	ls_RutCont = dw_1.Object.contratista[1]
	If IsNull(ls_RutCont) Then
		MessageBox( "Contratista Erróneo", "Falta seleccionar un Contratista.", &
	             StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	ls_filtro + "Cont. " + String(ls_RutCont) + "/"
End If

// Acepta Emnpresa //
If dw_1.Object.todosempr[1] = 1 Then
	ls_Empresa		= '*'
Else
	ls_Empresa = dw_1.Object.empresa[1]
	If IsNull(ls_Empresa) Then
		MessageBox( "Contratista Erróneo", "Falta seleccionar una Empresa.",  StopSign!, Ok!)
		RETURN				 
   End If
	ls_filtro	=	ls_filtro + "Empresa. " + String(ls_Empresa) + "/"
End If


If dw_1.Object.conspers[1] = 1 Then
	li_ConsPer	=	-9
	ls_filtro	=	ls_filtro + "Cons. Pers./"
Else
	li_ConsPer	=	-1
	ls_filtro	=	ls_filtro + "Todos Pers./"
End If

ld_FechaIni	=	dw_1.Object.fecinicio[1]
ld_FechaTer	=	dw_1.Object.fectermino[1]
If ld_FechaIni > ld_FechaTer Then 
	MessageBox( "Fechas Erróneas", "La Fecha de Termino no puede ser Inferior a la de Inicio.",  StopSign!, Ok!)
	RETURN
End If

istr_info.titulo	= "INFORME DE CONSUMOS DIARIOS"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)
vinf.dw_1.DataObject = "dw_info_casino_infoconsumosdiarios"
vinf.dw_1.SetTransObject(sqlca)

fila = vinf.dw_1.Retrieve(li_Zona, li_Area, li_CCosto, ld_FechaIni, ld_FechaTer, &
                          ls_RutCont, li_Tico, li_Caco, li_Estado, li_Filtro, li_ConsPer, ls_Empresa)

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.ModIfy("t_filtro.text = 'Filtro " + ls_filtro + "'")
	If gs_Ambiente <> 'Windows' Then F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo) 
End If

SetPointer(Arrow!)

end event

type pb_salir from w_para_informes`pb_salir within w_info_consumosdiarios
integer x = 2295
integer y = 1096
end type

type dw_1 from datawindow within w_info_consumosdiarios
integer x = 242
integer y = 420
integer width = 1915
integer height = 1132
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_info_resumencolacion"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String		ls_columna
Integer	li_Null

SetNull(li_Null)

ls_columna	=	dwo.Name

Choose Case ls_columna
	Case "zona"
		If Not iuo_zona.Existe(Integer(data), True, sqlca) Then
			This.Object.zona[Row]		=	li_Null
			Return 1
		Else
			ldwc_area.Retrieve(Integer(data), iuo_Empresa.Rut)
			ldwc_tico.Retrieve(Integer(data))
			This.Object.area[Row]		=	li_Null
			This.Object.area[Row]		=	li_Null
			This.Object.tico[Row]			=	li_Null
			This.Object.caco[Row]		=	li_Null
		End If
		
	Case "empresa"
		If Not iuo_Empresa.Of_Existe(Data, True, SQLCA) Then
			This.Object.empresa[Row]		=	li_Null
			Return 1
		Else
			ldwc_area.Retrieve(This.Object.zona[Row], iuo_Empresa.Rut)
			idwc_CCosto.Retrieve(iuo_Empresa.Rut)
		End If

	Case "area"
		If Not iuo_area.Existe(This.Object.zona[Row], iuo_Empresa.Rut, Integer(data), True, sqlca) Then
			This.Object.area[Row]		=	li_Null
			Return 1
		End If

	Case "ccosto"
		If Not iuo_ccosto.of_Existe(iuo_Empresa.Rut, Integer(data), True, sqlca) Then
			This.Object.ccosto[Row]		=	li_Null
			Return 1
		End If

	Case "contratista"
		If Not iuo_contra.Existe(data, True, sqlca) Then
			This.Object.ccosto[Row]		=	String(li_Null)
			Return 1
		End If

	Case "tico"
		If Not iuo_tico.Existe(This.Object.zona[Row], Integer(data), True, sqlca) Then
			This.Object.tico[Row]		=	li_Null
			Return 1
		Else
			ldwc_caco.Retrieve(This.Object.zona[Row], Integer(data))
			This.Object.caco[Row]		=	li_Null
		End If

	Case "caco"
		If Not iuo_caco.of_Existe(This.Object.zona[Row], This.Object.tico[Row], Integer(data), True, sqlca) Then
			This.Object.caco[Row]		=	li_Null
			Return 1
		End If
		
	Case "todoszona"
		If Data = '1' Then
			This.Object.zona[Row]			=	li_Null
			This.Object.area[Row]			=	li_Null
			This.Object.area[Row]			=	li_Null
			This.Object.tico[Row]				=	li_Null
			This.Object.caco[Row]			=	li_Null
			This.Object.todosarea[Row]		=	1
			This.Object.todostico[Row]		=	1
			This.Object.todoscaco[Row]		=	1
		End If
		
	Case "todosempr"
		If Data = '1' Then This.Object.empresa[Row]	=	li_Null
		
	Case "todosarea"
		If Data = '1' Then This.Object.area[Row] =	li_Null
		
	Case "todosccosto"
		If Data = '1' Then This.Object.ccosto[Row]	=	li_Null
		
	Case "todoscontra"
		If Data = '1' Then This.Object.contratista[Row]	=	String(li_Null)
		
	Case "todostico"
		If Data = '1' Then
			This.Object.tico[Row]				=	li_Null
			This.Object.caco[Row]			=	li_Null
			This.Object.todoscaco[Row]		=	1
		End If
		
	Case "todosesta"
		If Data = '1' Then This.Object.estado[Row]	=	li_Null
		
	Case "todosfiltro"
		If Data = '1' Then This.Object.filtro[Row]	=	li_Null
		
End Choose
end event

event itemerror;Return 1
end event

