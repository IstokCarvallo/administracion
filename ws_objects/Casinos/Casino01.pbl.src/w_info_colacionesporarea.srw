$PBExportHeader$w_info_colacionesporarea.srw
forward
global type w_info_colacionesporarea from w_para_informes
end type
type dw_1 from datawindow within w_info_colacionesporarea
end type
end forward

global type w_info_colacionesporarea from w_para_informes
integer width = 2354
integer height = 1224
string title = "INFORME DE COLACIONES POR AREA"
dw_1 dw_1
end type
global w_info_colacionesporarea w_info_colacionesporarea

type variables
DataWindowChild			ldwc_area, ldwc_contratista, ldwc_tico, ldwc_caco

uo_zona						iuo_zona
uo_casino_areas			iuo_area
uo_centrocosto				iuo_ccosto
uo_clienprove				iuo_contra
uo_casino_tipocolacion	uo_tico
uo_casino_colacion		uo_caco

end variables

on w_info_colacionesporarea.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_info_colacionesporarea.destroy
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

iuo_zona		=	Create uo_zona						
iuo_area		=	Create uo_casino_areas		
uo_tico		=	Create uo_casino_tipocolacion	

iuo_ccosto	=	Create uo_centrocosto			
iuo_contra	=	Create uo_clienprove				
uo_caco		=	Create uo_casino_colacion		

dw_1.Object.Desde[1]	=	Today()
dw_1.Object.Hasta[1]		=	Today()
dw_1.Object.hoy[1]		=	1
end event

type pb_excel from w_para_informes`pb_excel within w_info_colacionesporarea
integer x = 2309
integer y = 464
end type

type st_computador from w_para_informes`st_computador within w_info_colacionesporarea
integer x = 1038
integer y = 156
end type

type st_usuario from w_para_informes`st_usuario within w_info_colacionesporarea
integer x = 1038
integer y = 84
end type

type st_temporada from w_para_informes`st_temporada within w_info_colacionesporarea
integer x = 1038
integer y = 12
end type

type p_logo from w_para_informes`p_logo within w_info_colacionesporarea
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_colacionesporarea
integer width = 1577
integer height = 112
string text = "Informe de Colaciones Por Area"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_colacionesporarea
integer x = 1915
integer y = 460
end type

event pb_acepta::clicked;Integer 	li_Zona, li_Area, li_CCosto, li_Tico, li_Caco, li_Estado, li_Filtro, li_ConsPer
Date 		ld_FechaIni, ld_FechaTer
String 	ls_RutCont, ls_filtro
Long		fila

SetPointer(HourGlass!)

dw_1.AcceptText()

// Acepta Zona //
If dw_1.Object.todoszona[1] = 1 Then
	li_Zona 		=	-1
Else
	li_Zona = dw_1.Object.zona[1]
	If IsNull(li_Zona) Then
		MessageBox( "Zona Errónea", "Falta seleccionar una Zona.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Area Errónea", "Falta seleccionar una Area.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "C. Costo Erróneo", "Falta seleccionar una C. Costo.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Tipo de Colación Erróneo", "Falta seleccionar un Tipo de Colación.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Colación Errónea", "Falta seleccionar una Colación.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Estado Erróneo", "Falta seleccionar un Estado.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Filtro Erróneo", "Falta seleccionar un Filtro.", StopSign!, Ok!)
		Return				 
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
		MessageBox( "Contratista Erróneo", "Falta seleccionar un Contratista.", StopSign!, Ok!)
		Return				 
   End If
	ls_filtro	=	ls_filtro + "Cont. " + String(ls_RutCont) + "/"
End If

If dw_1.Object.conspers[1] = 1 Then
	li_ConsPer	=	-9
	ls_filtro	=	ls_filtro + "Cons. Pers./"
Else
	li_ConsPer	=	-1
	ls_filtro	=	ls_filtro + "Todos Pers./"
End If

ld_FechaIni	=	dw_1.Object.desde[1]
ld_FechaTer	=	dw_1.Object.hasta[1]

If ld_FechaIni > ld_FechaTer Then 
	MessageBox( "Fechas Erróneas", "La Fecha de Termino no puede ser Inferior a la de Inicio.", StopSign!, Ok!)
	Return
End If

istr_info.titulo	= "INFORME DE COLACIONES POR AREA"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)
If dw_1.Object.informe[1] = 0 Then
	vinf.dw_1.DataObject = "dw_encabe_colaciones_por_area"
Else
	vinf.dw_1.DataObject = "dw_encabe_colaciones_por_area_cuadratura"
End If

vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(ld_FechaIni, li_Area, li_Tico, ld_FechaTer)

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.ModIfy("t_filtro.text = 'Filtro " + ls_filtro + "'")
	If gs_Ambiente <> 'Windows' Then F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
End If

SetPointer(Arrow!)
end event

type pb_salir from w_para_informes`pb_salir within w_info_colacionesporarea
integer x = 1915
integer y = 808
end type

type dw_1 from datawindow within w_info_colacionesporarea
integer x = 251
integer y = 440
integer width = 1577
integer height = 604
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_info_colaciones_por_area"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String	ls_columna
Integer	li_nulo

SetNull(li_nulo)

ls_columna	=	dwo.Name

CHOOSE Case ls_columna
	Case "zona"
		If NOT iuo_zona.Existe(Integer(data), True, sqlca) Then
			This.Object.zona[Row]		=	li_nulo
			Return 1
		Else
			ldwc_area.Retrieve(Integer(data))
			ldwc_tico.Retrieve(Integer(data))
			This.Object.area[row]		=	li_nulo
			This.Object.area[row]		=	li_nulo
			This.Object.tico[row]		=	li_nulo
			This.Object.caco[row]		=	li_nulo
		End If

	Case "area"
		If NOT iuo_area.Existe(This.Object.zona[row], Integer(data), True, sqlca) Then
			This.Object.area[Row]		=	li_nulo
			Return 1
		End If

	Case "ccosto"
		If NOT iuo_ccosto.Existe(Integer(data), True, sqlca) Then
			This.Object.ccosto[Row]		=	li_nulo
			Return 1
		End If

	Case "contratista"
		If NOT iuo_contra.Existe(data, True, sqlca) Then
			This.Object.ccosto[Row]		=	String(li_nulo)
			Return 1
		End If

	Case "tico"
		If NOT uo_tico.Existe(This.Object.zona[row], Integer(data), True, sqlca) Then
			This.Object.tico[Row]		=	li_nulo
			Return 1
		Else
			ldwc_caco.Retrieve(This.Object.zona[row], Integer(data))
			This.Object.caco[row]		=	li_nulo
		End If

	Case "caco"
		If NOT uo_caco.Existe(This.Object.zona[row], This.Object.tico[row], Integer(data), True, sqlca) Then
			This.Object.caco[Row]		=	li_nulo
			Return 1
		End If
		
	Case "todoszona"
		If Data = '1' Then
			This.Object.zona[row]			=	li_nulo
			This.Object.area[row]			=	li_nulo
			This.Object.area[row]			=	li_nulo
			This.Object.tico[row]			=	li_nulo
			This.Object.caco[row]			=	li_nulo
			This.Object.todosarea[row]		=	1
			This.Object.todostico[row]		=	1
			This.Object.todoscaco[row]		=	1
			
		End If
		
	Case "todosarea"
		If Data = '1' Then
			This.Object.area[row]			=	li_nulo
		End If
		
	Case "todosccosto"
		If Data = '1' Then
			This.Object.ccosto[row]			=	li_nulo
		End If
		
	Case "todoscontra"
		If Data = '1' Then
			This.Object.contratista[row]	=	String(li_nulo)
		End If
		
	Case "todostico"
		If Data = '1' Then
			This.Object.tico[row]				=	li_nulo
			This.Object.caco[row]			=	li_nulo
			This.Object.todoscaco[row]		=	1
		End If
		
	Case "todosesta"
		If Data = '1' Then
			This.Object.estado[row]			=	li_nulo
		End If
		
	Case "todosfiltro"
		If Data = '1' Then
			This.Object.filtro[row]			=	li_nulo
		End If
		
	Case "hoy"
		If Data = '1' Then
			This.Object.Desde[row]	=	Today()
			This.Object.Hasta[row]	=	Today()
		End If
		
End CHOOSE
end event

event itemerror;Return 1
end event

