$PBExportHeader$w_info_proforma_fact_serv.srw
forward
global type w_info_proforma_fact_serv from w_para_informes
end type
type dw_1 from datawindow within w_info_proforma_fact_serv
end type
end forward

global type w_info_proforma_fact_serv from w_para_informes
integer width = 2697
integer height = 1224
string title = "INFORME PROFORMA FACTURA DE SERVICIOS"
dw_1 dw_1
end type
global w_info_proforma_fact_serv w_info_proforma_fact_serv

type variables
DataWindowChild			ldwc_area, ldwc_contratista, ldwc_tico, ldwc_caco

uo_zona						iuo_zona
uo_casino_areas			iuo_area
uo_centrocosto				iuo_ccosto 
uo_clienprove				iuo_contra
uo_casino_tipocolacion	uo_tico
uo_casino_colacion		uo_caco

end variables

on w_info_proforma_fact_serv.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_info_proforma_fact_serv.destroy
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
iuo_ccosto	=	Create uo_centrocosto			
iuo_contra	=	Create uo_clienprove				
uo_tico		=	Create uo_casino_tipocolacion	
uo_caco		=	Create uo_casino_colacion		

dw_1.Object.fecinicio[1]	=	RelativeDate(Today(), -365)
dw_1.Object.fectermino[1]	=	Today()
end event

type pb_excel from w_para_informes`pb_excel within w_info_proforma_fact_serv
end type

type st_computador from w_para_informes`st_computador within w_info_proforma_fact_serv
integer x = 1038
integer y = 156
end type

type st_usuario from w_para_informes`st_usuario within w_info_proforma_fact_serv
integer x = 1038
integer y = 84
end type

type st_temporada from w_para_informes`st_temporada within w_info_proforma_fact_serv
integer x = 1038
integer y = 12
end type

type p_logo from w_para_informes`p_logo within w_info_proforma_fact_serv
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_info_proforma_fact_serv
integer width = 1847
integer height = 92
string text = "Informe Proforma Factura de Servicios"
end type

type pb_acepta from w_para_informes`pb_acepta within w_info_proforma_fact_serv
integer x = 2135
integer y = 480
end type

event pb_acepta::clicked;Integer 	li_Zona, li_Area, li_CCosto, li_Tico, li_Caco, li_Estado, li_Filtro, li_ConsPer
Date 		ld_FechaIni, ld_FechaTer
String 	ls_RutCont, ls_filtro
Long		fila

SetPointer(HourGlass!)

dw_1.AcceptText()


// Acepta contratista //
If dw_1.Object.todoscontra[1] = 1 Then
	ls_RutCont 	= '-1'
	ls_filtro	=	ls_filtro + "Todos Cont./"
Else
	ls_RutCont = dw_1.Object.contratista[1]
	If IsNull(ls_RutCont) Then
		MessageBox( "Proveedor Erróneo", "Falta seleccionar un Proveedor.", &
	             StopSign!, Ok!)
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

ld_FechaIni	=	dw_1.Object.fecinicio[1]
ld_FechaTer	=	dw_1.Object.fectermino[1]

If ld_FechaIni > ld_FechaTer Then 
	MessageBox( "Fechas Erróneas", "La Fecha de Termino no puede ser Inferior a la de Inicio.", StopSign!, Ok!)
	Return
End If

istr_info.titulo	= "INFORME PROFORMA FACTURA DE SERVICIOS"
istr_info.copias	= 1

OpenWithParm(vinf, istr_info)

vinf.dw_1.DataObject = "dw_proforma_casino"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(ld_FechaIni, ld_FechaTer, ls_RutCont)

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	If gs_Ambiente <> 'Windows' Then F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
End If

SetPointer(Arrow!)

end event

type pb_salir from w_para_informes`pb_salir within w_info_proforma_fact_serv
integer x = 2135
integer y = 744
end type

type dw_1 from datawindow within w_info_proforma_fact_serv
integer x = 247
integer y = 440
integer width = 1847
integer height = 576
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_info_proforma"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

