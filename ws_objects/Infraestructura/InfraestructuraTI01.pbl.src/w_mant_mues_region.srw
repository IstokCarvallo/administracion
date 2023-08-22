$PBExportHeader$w_mant_mues_region.srw
forward
global type w_mant_mues_region from w_mant_directo
end type
type uo_selpais from uo_seleccion_paises within w_mant_mues_region
end type
type st_1 from statictext within w_mant_mues_region
end type
end forward

global type w_mant_mues_region from w_mant_directo
integer width = 2414
string title = "MAESTRO REGIONES"
string icon = "AppIcon!"
uo_selpais uo_selpais
st_1 st_1
end type
global w_mant_mues_region w_mant_mues_region

type variables

end variables

forward prototypes
public function boolean duplicado (string codigo)
end prototypes

public function boolean duplicado (string codigo);Long		ll_fila

ll_fila	= dw_1.Find("regi_codigo = " + Codigo , 1, dw_1.RowCount())

If ll_fila > 0 and ll_fila <> il_fila Then
	MessageBox("Error","Código de la Region ya fue ingresada anteriormente",Information!, Ok!)
	Return True
Else
	Return False
End If
end function

on w_mant_mues_region.create
int iCurrent
call super::create
this.uo_selpais=create uo_selpais
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_selpais
this.Control[iCurrent+2]=this.st_1
end on

on w_mant_mues_region.destroy
call super::destroy
destroy(this.uo_selpais)
destroy(this.st_1)
end on

event open;call super::open;Boolean lb_Cerrar 


If IsNull(uo_SelPais.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	uo_SelPais.Seleccion(False, False)
	
	
	buscar			= "Código:Nregi_codigo,Nombre:Sregi_nombre"
	ordenar			= "Código:regi_codigo,Nombre:reginombre"
End IF
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_fila, respuesta

DO
	ll_fila	= dw_1.Retrieve(uo_SelPais.Codigo)
	
	IF ll_fila	= -1 THEN
		respuesta	= MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", &
											Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SetFocus()
		pb_imprimir.Enabled	= True		
		pb_insertar.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled		= True
		
		il_fila					= 1
	ELSE
		pb_insertar.Enabled	= True
		pb_insertar.SetFocus()
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
	
end event

event ue_imprimir;Long	fila
str_info lstr_info

lstr_info.titulo	= "MAESTRO REGIONES"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_region"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve(uo_SelPais.Codigo)

If fila	= -1 Then
	MessageBox("Error en Base de Datos", "Se ha Producido un error en Basede Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ElseIf fila	= 0 Then
	MessageBox("No Existe Información", "No Existe Información para este Informa.", StopSign!, OK!)
Else
	F_Membrete(vinf.dw_1)
	If gs_Ambiente = 'Windows' Then
		vinf.dw_1.ModIfy('DataWindow.Print.Preview	= Yes')
		vinf.dw_1.ModIfy('DataWindow.Print.Preview.Zoom	= 75')
		vinf.Visible	= True
		vinf.Enabled	= True
	Else
		F_ImprimeInformePdf(vinf.dw_1, lstr_info.titulo)
	End If
End If
end event

event ue_validaregistro;call super::ue_validaregistro;Integer	li_cont
String   ls_mensaje, ls_colu[]

If IsNull(dw_1.Object.regi_codigo[il_fila]) Then
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nCódigo de la Región"
	ls_colu[li_cont]	= "regi_codigo"
End If

If IsNull(dw_1.Object.regi_nombre[il_fila]) Or dw_1.Object.regi_nombre[il_fila] = "" Then
	li_cont ++
	ls_mensaje		= ls_mensaje + "~nDescripción de la Región"
	ls_colu[li_cont]	= "regi_nombre"
End If

If li_cont > 0 Then
	MessageBox("Error de Consistencia", "Falta el Ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
End If	
end event

event ue_antesguardar;call super::ue_antesguardar;Long	ll_fila = 1

DO WHILE ll_fila <= dw_1.RowCount()
	If dw_1.GetItemStatus(ll_fila, 0, Primary!) = NewModified! Then
		dw_1.Object.pais_codigo[ll_fila] = uo_SelPais.Codigo
	End If
	ll_fila++
LOOP
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_region
integer y = 24
integer width = 1842
integer height = 348
boolean enabled = true
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_region
integer x = 2039
integer y = 356
integer taborder = 50
end type

event pb_nuevo::clicked;call super::clicked;dw_1.Reset()

end event

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_region
integer x = 2034
integer y = 124
integer taborder = 40
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_region
integer x = 2034
integer y = 716
integer taborder = 80
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_region
integer x = 2034
integer y = 536
integer taborder = 70
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_region
integer x = 2025
integer y = 1508
integer taborder = 110
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_region
integer x = 2034
integer y = 1076
integer taborder = 100
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_region
integer x = 2034
integer y = 896
integer taborder = 90
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_region
integer y = 396
integer width = 1842
integer height = 1476
integer taborder = 60
string dataobject = "dw_mant_mues_region"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_Null, ls_Columna

SetNull(ls_Null)
ls_Columna = dwo.name

Choose Case ls_Columna
	Case "regi_codigo"		
		If Duplicado(data) Then
			This.SetItem(il_fila, ls_Columna, Integer(ls_Null))
			Return 1
		End If
End Choose

pb_grabar.Enabled		= True

end event

type uo_selpais from uo_seleccion_paises within w_mant_mues_region
integer x = 558
integer y = 152
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

on uo_selpais.destroy
call uo_seleccion_paises::destroy
end on

type st_1 from statictext within w_mant_mues_region
integer x = 306
integer y = 164
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Pais"
boolean focusrectangle = false
end type

