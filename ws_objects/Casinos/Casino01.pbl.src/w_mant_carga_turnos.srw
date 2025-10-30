$PBExportHeader$w_mant_carga_turnos.srw
forward
global type w_mant_carga_turnos from w_mant_directo
end type
type dw_carga from uo_dw within w_mant_carga_turnos
end type
type pb_carga from picturebutton within w_mant_carga_turnos
end type
type pb_subir from picturebutton within w_mant_carga_turnos
end type
end forward

global type w_mant_carga_turnos from w_mant_directo
integer width = 3835
integer height = 2104
boolean clientedge = true
dw_carga dw_carga
pb_carga pb_carga
pb_subir pb_subir
end type
global w_mant_carga_turnos w_mant_carga_turnos

type variables
uo_personacolacion	iuo_Personal

String			is_ru

end variables

forward prototypes
public function boolean of_turnoinicial (integer codigo, transaction at_transaccion)
end prototypes

public function boolean of_turnoinicial (integer codigo, transaction at_transaccion);Boolean lb_Retorno

Update dbo.remupersonal
	Set turn_codigo = :Codigo
	Using at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Personal")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False
End If

Return lb_Retorno
end function

on w_mant_carga_turnos.create
int iCurrent
call super::create
this.dw_carga=create dw_carga
this.pb_carga=create pb_carga
this.pb_subir=create pb_subir
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_carga
this.Control[iCurrent+2]=this.pb_carga
this.Control[iCurrent+3]=this.pb_subir
end on

on w_mant_carga_turnos.destroy
call super::destroy
destroy(this.dw_carga)
destroy(this.pb_carga)
destroy(this.pb_subir)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long		ll_Filas
String		ls_persona

w_main.SetMicroHelp("Recuperando Datos...")
SetPointer(HourGlass!)
PostEvent("ue_listo")

If MessageBox('Atencion', 'Se presedera a cargar a todos los usuarios a Turno 1.', INformation!, YesNo!, 1) = 1 Then
	If of_TurnoInicial(1, SQLCA) Then
		MessageBox('Atencion', 'Se marco a todos los usuarios en turno 1')
	End If
End If

pb_imprimir.Enabled	=	False
pb_grabar.Enabled	=	False

ll_Filas	=	dw_1.Retrieve()

If ll_Filas = -1 Then
	F_ErrorBaseDatos(sqlca, "Lectura de Tabla")
	dw_1.SetRedraw(True)
	Return
Else
	istr_Mant.Solo_Consulta	=	istr_mant.UsuarioSoloConsulta
	pb_Grabar.Enabled		=	Not istr_mant.Solo_Consulta
	pb_carga.Enabled			=	Not istr_mant.Solo_Consulta
		
	If ll_Filas > 0 Then
		pb_imprimir.Enabled	=	True
		pb_grabar.Enabled		=	True
	End If
End If
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info

lstr_info.titulo	= "INFORME "
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = ""
vinf.dw_1.SetTransObject(sqlca)

fila = vinf.dw_1.Retrieve()

If fila = -1 Then
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ElseIf fila = 0 Then
	MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
Else
	F_Membrete(vinf.dw_1)
	vinf.dw_1.ModIfy('DataWindow.Print.Preview = Yes')
	vinf.dw_1.ModIfy('DataWindow.Print.Preview.Zoom = 75')

	vinf.Visible	= True
	vinf.Enabled	= True
End If

SetPointer(Arrow!)
end event

event resize;Integer		li_posic_x, li_posic_y, &
				li_Ancho = 300, li_Alto = 245, li_Siguiente = 255

dw_1.Resize(This.WorkSpaceWidth() - 490,This.WorkSpaceHeight() - dw_1.y - 75)

dw_1.x					=	78
st_encabe.x				=	dw_1.x
st_encabe.width		=	dw_1.width

li_posic_x				=	This.WorkSpaceWidth() - 370
If st_encabe.Visible Then
	li_posic_y				=	st_encabe.y
Else
	li_posic_y				=	dw_1.y
End If

If pb_lectura.Visible Then
	pb_lectura.x				=	li_posic_x
	pb_lectura.y				=	li_posic_y
	pb_lectura.width		=	li_Ancho
	pb_lectura.height		=	li_Alto	
	li_posic_y 				+= li_Siguiente * 1.25
End If

If pb_nuevo.Visible Then
	pb_nuevo.x			=	li_posic_x
	pb_nuevo.y			=	li_posic_y
	pb_nuevo.width	=	li_Ancho
	pb_nuevo.height	=	li_Alto
	li_posic_y 			+= li_Siguiente
End If

If pb_insertar.Visible Then
	pb_insertar.x		=	li_posic_x
	pb_insertar.y		=	li_posic_y
	pb_insertar.width	=	li_Ancho
	pb_insertar.height	=	li_Alto
	li_posic_y += li_Siguiente
End If

If pb_eliminar.Visible Then
	pb_eliminar.x			=	li_posic_x
	pb_eliminar.y			=	li_posic_y
	pb_eliminar.width		=	li_Ancho
	pb_eliminar.height	=	li_Alto
	li_posic_y += li_Siguiente
End If

If pb_grabar.Visible Then
	pb_grabar.x				=	li_posic_x
	pb_grabar.y				=	li_posic_y
	pb_grabar.width		=	li_Ancho
	pb_grabar.height		=	li_Alto
	li_posic_y += li_Siguiente
End If

If pb_carga.Visible Then
	pb_carga.x			=	li_posic_x
	pb_carga.y			=	li_posic_y
	pb_carga.width		=	li_Ancho
	pb_carga.height		=	li_Alto
	li_posic_y += li_Siguiente
End If

If pb_subir.Visible Then
	pb_subir.x			=	li_posic_x
	pb_subir.y			=	li_posic_y
	pb_subir.width		=	li_Ancho
	pb_subir.height		=	li_Alto
	li_posic_y += li_Siguiente
End If


If pb_imprimir.Visible Then
	pb_imprimir.x			=	li_posic_x
	pb_imprimir.y			=	li_posic_y
	pb_imprimir.width		=	li_Ancho
	pb_imprimir.height	=	li_Alto
	li_posic_y += li_Siguiente
End If

pb_salir.x				=	li_posic_x
pb_salir.y				=	dw_1.y + dw_1.Height - li_Siguiente
pb_salir.width			=	li_Ancho
pb_salir.height			=	li_Alto


end event

type st_encabe from w_mant_directo`st_encabe within w_mant_carga_turnos
boolean visible = false
integer x = 37
integer y = 24
integer width = 3218
integer height = 296
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_mant_carga_turnos
integer x = 3365
integer y = 512
end type

type pb_lectura from w_mant_directo`pb_lectura within w_mant_carga_turnos
integer x = 3365
integer y = 0
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_mant_carga_turnos
boolean visible = false
integer x = 3365
integer y = 1280
end type

type pb_insertar from w_mant_directo`pb_insertar within w_mant_carga_turnos
boolean visible = false
integer x = 3328
integer y = 1312
end type

type pb_salir from w_mant_directo`pb_salir within w_mant_carga_turnos
integer x = 3365
integer y = 1600
end type

type pb_imprimir from w_mant_directo`pb_imprimir within w_mant_carga_turnos
boolean visible = false
integer x = 3401
integer y = 1280
end type

type pb_grabar from w_mant_directo`pb_grabar within w_mant_carga_turnos
integer x = 3365
integer y = 768
end type

type dw_1 from w_mant_directo`dw_1 within w_mant_carga_turnos
integer x = 37
integer y = 32
integer width = 3218
integer height = 1856
boolean titlebar = true
string title = "Solicitudes de Colaciones"
string dataobject = "dw_mues_personal"
end type

event dw_1::clicked;This.SelectRow(Row, Not This.IsSelected(row))
end event

type dw_carga from uo_dw within w_mant_carga_turnos
boolean visible = false
integer x = 3365
integer y = 256
integer width = 256
integer height = 192
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_mues_personal"
boolean vscrollbar = false
end type

type pb_carga from picturebutton within w_mant_carga_turnos
string tag = "Carga Excel con personal"
integer x = 3291
integer y = 992
integer width = 302
integer height = 244
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string picturename = "\Desarrollo 22\Imagenes\Botones\Aceptar base datos.png"
string disabledname = "\Desarrollo 22\Imagenes\Botones\Aceptar base datos-bn.png"
alignment htextalign = left!
end type

event clicked;String	ls_path, ls_File, ls_Find
Long	ll_File, ll_Find , ll_Fila, ll_Retorno = 1

OleObject 	loo_Excel
loo_Excel		=	Create OleObject 

If GetFileOpenName ( "Carga de Turnos", ls_path, ls_File, "XLSX","Excel Files(*.xls)", "C:\My Documents") < 1 Then Return -1

dw_Carga.Reset()

loo_Excel.ConnectToNewObject( "excel.application" ) 
loo_Excel.Visible = False 
loo_Excel.WorkBooks.Open( ls_Path)
loo_Excel.Application.ActiveWorkbook.Worksheets[1].Activate 
loo_Excel.Application.ActiveWorkbook.Worksheets[1].Range("A1").Activate 
loo_Excel.ActiveCell.CurrentRegion.Select() 
loo_Excel.Selection.Copy() 
dw_Carga.ImportClipBoard (2)

ClipBoard('')
loo_Excel.WorkBooks.Close()
loo_Excel.Application.Quit
loo_Excel.DisconnectObject()

ll_File = dw_carga.ImportFile(CSV!, ls_File)
	
If ll_File < 0 Then
	MessageBox('Alerta', 'Error en la carga de archivo.', Exclamation!, OK!)
	ll_Retorno =  ll_File
Else
	For ll_Fila = 1 To dw_Carga.RowCount()
		If dw_Carga.Object.turn_codigo[ll_Fila] > 1 Then
			ls_Find = "pers_codigo = '" + dw_Carga.Object.pers_codigo[ll_Fila] + "'"
			ll_Find = dw_1.Find(ls_Find, 1, dw_1.RowCount(), Primary!)
			
			if ll_Find > 0 Then
				dw_1.Object.turn_codigo[ll_Find]	= dw_Carga.Object.turn_codigo[ll_Fila]
				
				dw_1.SetRow(ll_Find)
				dw_1.ScrollToRow(ll_Find)
			End If
		End If
	Next
End If

Destroy loo_Excel

pb_imprimir.Enabled	= True
pb_eliminar.Enabled	= True
pb_grabar.Enabled	= True

Return ll_Retorno
end event

type pb_subir from picturebutton within w_mant_carga_turnos
string tag = "Carga Excel con personal"
integer x = 3401
integer y = 1088
integer width = 302
integer height = 244
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "\Desarrollo 17\Imagenes\Botones\Subir Nube.png "
string disabledname = "\Desarrollo 17\Imagenes\Botones\Subir Nube-bn.png "
alignment htextalign = left!
end type

event clicked;String		ls_Path, ls_File

If GetFileSaveName("Genera Turnos",ls_Path, ls_File, "XLSX","Excel Files(*.xls),*.xls", "C:\My Documents") < 1 Then
	MessageBox('Atencion', 'No se pudo crear archivo.')
Else
	If dw_1.Retrieve() = -1 Then
		MessageBox('Atencion', 'No se existe informacion para generar.')
	Else	
		If dw_1.SaveAs(ls_Path, Excel8!, True) = -1 Then
			MessageBox('Atencion', 'No se pudo crear archivo.' + ls_Path)
		Else
			MessageBox('Informacion', 'Se genero archivo.' + ls_Path)
		End If
	End If
End If
end event

