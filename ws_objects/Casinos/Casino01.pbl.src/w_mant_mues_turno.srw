$PBExportHeader$w_mant_mues_turno.srw
$PBExportComments$Mantención de Registro Precios de Venta.
forward
global type w_mant_mues_turno from w_mant_directo
end type
end forward

global type w_mant_mues_turno from w_mant_directo
integer width = 4375
string title = "Turnos"
end type
global w_mant_mues_turno w_mant_mues_turno

type variables

end variables

forward prototypes
public subroutine wf_soloconsulta (boolean habilita)
end prototypes

public subroutine wf_soloconsulta (boolean habilita);If Habilita Then
	dw_1.Enabled			=	False
	pb_grabar.Enabled	= 	False
	pb_imprimir.Enabled	= 	True
	This.Title					=	"VALOR COLACION CONSULTA DE REGISTRO"
Else	
	dw_1.Enabled			=	True
	pb_grabar.Enabled	= 	True
	pb_imprimir.Enabled	= 	True
	This.Title					=	'VALOR COLACION'
End If

Return
end subroutine

event ue_imprimir;Long		ll_Fila
str_info	lstr_info

lstr_info.titulo	= "INFORME TURNOS"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "w_info_turno"
vinf.dw_1.SetTransObject(sqlca)

ll_Fila	=	vinf.dw_1.Retrieve()

If ll_Fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf ll_Fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	If gs_Ambiente <> 'Windows' Then F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo	)
End If

SetPointer(Arrow!)

end event

event ue_recuperadatos;Long		ll_Filas

ll_Filas	=	dw_1.Retrieve()

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla Buscada")

	dw_1.SetRedraw(True)

	Return
Else
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
		
	If ll_Filas > 0 Then
		pb_imprimir.Enabled	=	True
		
		dw_1.SetRow(1)
		dw_1.SetFocus()
	Else
		pb_insertar.SetFocus()
	End If
End If
end event

on w_mant_mues_turno.create
call super::create
end on

on w_mant_mues_turno.destroy
call super::destroy
end on

event ue_antesguardar;call super::ue_antesguardar;dw_1.SetRedraw(False)
dw_1.SetFilter("")
dw_1.Filter()
end event

event ue_guardar;call super::ue_guardar;TriggerEvent("ue_recuperadatos")

dw_1.SetRedraw(True)
end event

type st_encabe from w_mant_directo`st_encabe within w_mant_mues_turno
boolean visible = false
integer x = 73
integer width = 1609
integer height = 316
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_mues_turno
integer x = 3968
integer y = 304
integer taborder = 50
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_mues_turno
integer x = 3968
integer y = 80
integer taborder = 30
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_mues_turno
integer x = 3968
integer y = 496
integer taborder = 70
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_mues_turno
integer x = 3968
integer y = 752
integer taborder = 60
boolean enabled = true
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_mues_turno
integer x = 3968
integer y = 1648
integer taborder = 100
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_mues_turno
integer x = 3968
integer y = 1040
integer taborder = 90
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_mues_turno
integer x = 3968
integer y = 816
integer taborder = 80
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_mues_turno
integer x = 73
integer y = 64
integer width = 3813
integer height = 2048
integer taborder = 40
string title = "Valores de Colaciones"
string dataobject = "dw_mant_mues_turno"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::sqlpreview;//
end event

event dw_1::itemchanged;call super::itemchanged;String ls_Columna, ls_Null

SetNull(ls_Null)
ls_Columna = dwo.name

Choose Case ls_Columna
	Case 'turn_desayu'
		if Data = '0' Then 
			This.SetItem(Row, 'turn_inicio_desayuno', Time(ls_Null))
			This.SetItem(Row, 'turn_fin_desayuno', Time(ls_Null))
		End If
	
	Case 'turn_almuer'
		if Data = '0' Then 
			This.SetItem(Row, 'turn_inicio_almuerzo', Time(ls_Null))
			This.SetItem(Row, 'turn_fin_Almuerzo', Time(ls_Null))
		End If
	
	Case 'turn_once'
		if Data = '0' Then 
			This.SetItem(Row, 'turn_inicio_once', Time(ls_Null))
			This.SetItem(Row, 'turn_fin_once', Time(ls_Null))
		End If
			
	Case 'turn_cena'
		if Data = '0' Then 
			This.SetItem(Row, 'turn_inicio_cena', Time(ls_Null))
			This.SetItem(Row, 'turn_fin_cena', Time(ls_Null))
		End If
		
End Choose
end event

