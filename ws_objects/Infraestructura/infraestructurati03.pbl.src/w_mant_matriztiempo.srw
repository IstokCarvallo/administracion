$PBExportHeader$w_mant_matriztiempo.srw
forward
global type w_mant_matriztiempo from w_mant_directo
end type
type st_1 from statictext within w_mant_matriztiempo
end type
type uo_selorigen from uo_seleccion_comunasexp_id within w_mant_matriztiempo
end type
end forward

global type w_mant_matriztiempo from w_mant_directo
integer width = 2437
integer height = 2312
string title = "Matriz de Tiempos Desplazamiento"
st_1 st_1
uo_selorigen uo_selorigen
end type
global w_mant_matriztiempo w_mant_matriztiempo

type variables

uo_comunas	iuo_Comuna
uo_matriztiempo	iuo_Matriz
end variables

forward prototypes
public function boolean duplicado (string columna, string valor)
end prototypes

public function boolean duplicado (string columna, string valor);Integer	li_fila, Destino
Boolean	lb_Retorno = False
String		ls_Find

Destino =	dw_1.Object.comuna_destino_id[dw_1.GetRow()]

Choose Case Columna 
	Case 'comuna_destino_id'
		Destino = Integer(Valor)
		
End Choose 

ls_Find = "comuna_destino_id = " + String(Destino)

li_fila = dw_1.Find(ls_Find, 1, dw_1.RowCount())

If li_fila > 0 And li_fila <> il_fila Then 
	MessageBox("Datos Duplicados", "La Comuna destino esta ingresando, no es valido, ya que ha sido ingresado anteriormente." + &
											 "~r~nPor favor verifique los datos o ingrese otro")
	lb_Retorno = True
End If

Return lb_Retorno
end function

event open;call super::open;Boolean lb_Cerrar 

If IsNull(uo_SelOrigen.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	iuo_Comuna =	Create uo_comunas
	iuo_Matriz	=	Create uo_matriztiempo
	
	uo_SelOrigen.Seleccion(False, False)
	
	buscar			= "Destino.:Ncomuna_destino_id"
	ordenar			= "Destino.:comuna_destino_id"
End If

end event

on w_mant_matriztiempo.create
int iCurrent
call super::create
this.st_1=create st_1
this.uo_selorigen=create uo_selorigen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_selorigen
end on

on w_mant_matriztiempo.destroy
call super::destroy
destroy(this.st_1)
destroy(this.uo_selorigen)
end on

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info

lstr_info.titulo	= "MANTENCION MATRIZ DE TIEMPOS DESPLAZAMIENTO"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_matriztiempo"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(uo_SelOrigen.Codigo)

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

event ue_recuperadatos;Long	ll_fila, respuesta

Do	
	iuo_Matriz.of_CargaMatriz(uo_SelOrigen.Codigo) 
	
	ll_fila	= dw_1.Retrieve(uo_SelOrigen.Codigo)
	
	If ll_fila = -1 Then
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	ElseIf ll_fila > 0 Then
		dw_1.SetRow(1)
		dw_1.SetFocus()
		
		pb_insertar.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled	= True
		pb_imprimir.Enabled	= True
		il_fila						= 1		
	Else
		pb_insertar.Enabled	= True
		pb_insertar.SetFocus()
		ias_campo[1]			= ""
	End If
Loop While respuesta = 1

If respuesta = 2 Then Close(This)
end event

event ue_antesguardar;call super::ue_antesguardar;Long	ll_fila = 1

Do While ll_fila <= dw_1.RowCount()
	If dw_1.GetItemStatus(ll_fila, 0, Primary!) = New! Then
		dw_1.DeleteRow(ll_fila)
	Else
		If dw_1.GetItemStatus(ll_fila, 0, Primary!) = NewModified! Then
			dw_1.Object.clie_codigo[ll_fila]					=	uo_SelOrigen.Codigo
			dw_1.Object.usuario_modificacion[il_Fila]	=	gstr_Us.Nombre
			dw_1.Object.fecha_modificacion[ll_fila]		=	Today()	
		ElseIf dw_1.GetItemStatus(ll_fila, 'tiempo_horas', Primary!) = DataModified! Then
			dw_1.Object.usuario_modificacion[il_Fila]	=	gstr_Us.Nombre
			dw_1.Object.fecha_modificacion[ll_fila]		=	Today()			
		End If		
		ll_fila ++
	End If
Loop
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_matriztiempo
integer x = 64
integer y = 72
integer width = 1838
integer height = 312
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_matriztiempo
integer x = 2002
integer y = 400
end type

event pb_nuevo::clicked;call super::clicked;uo_SelOrigen.Bloquear(False)
end event

type pb_lectura from w_mant_directo`pb_lectura within w_mant_matriztiempo
integer x = 2002
integer y = 104
end type

event pb_lectura::clicked;call super::clicked;uo_SelOrigen.Bloquear(True)
end event

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_matriztiempo
integer x = 2002
integer y = 760
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_matriztiempo
integer x = 2002
integer y = 580
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_matriztiempo
integer x = 2002
integer y = 1504
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_matriztiempo
integer x = 2002
integer y = 1120
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_matriztiempo
integer x = 2002
integer y = 940
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_matriztiempo
integer x = 87
integer y = 420
integer width = 1838
integer height = 1716
string title = "Mantenedor GTIN DUN14"
string dataobject = "dw_mant_matriztiempo"
end type

event dw_1::itemchanged;call super::itemchanged;String		ls_columna, ls_Null

SetNull(ls_Null)
ls_columna	=	dwo.Name

This.SetRedraw(False)

Choose Case ls_columna		
	Case 'comuna_destino_id'
		If Duplicado(ls_Columna, Data) Or Not iuo_Comuna.of_Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return 1
		End If 

End Choose

This.SetRedraw(True)
end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

type st_1 from statictext within w_mant_matriztiempo
integer x = 206
integer y = 184
integer width = 270
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Origen"
boolean focusrectangle = false
end type

type uo_selorigen from uo_seleccion_comunasexp_id within w_mant_matriztiempo
event destroy ( )
integer x = 485
integer y = 172
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

on uo_selorigen.destroy
call uo_seleccion_comunasexp_id::destroy
end on

