$PBExportHeader$vou_personal.sru
forward
global type vou_personal from userobject
end type
type dw_asignacion from uo_dw within vou_personal
end type
type pb_generar from picturebutton within vou_personal
end type
type pb_subir from picturebutton within vou_personal
end type
end forward

global type vou_personal from userobject
integer width = 590
integer height = 236
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_asignacion dw_asignacion
pb_generar pb_generar
pb_subir pb_subir
end type
global vou_personal vou_personal

type variables
Private String			_Usuario, _Filter
Private Date				_Fecha, _Hasta
Private DataWindow	_Dw
end variables

forward prototypes
private function boolean of_subir ()
private subroutine of_setusuario (string as_usuario)
private subroutine of_setfecha (date ad_fecha)
private subroutine of_habilitar (boolean subir, boolean genera)
private subroutine of_sethasta (date ad_fecha)
private function boolean of_bajar (ref datawindow adw, string filtro)
public subroutine of_iniciar (string usuario, date fecha, boolean subir, boolean bajar, ref datawindow adw, string filtro)
end prototypes

private function boolean of_subir ();Boolean	lb_Retorno
String		ls_Path, ls_File

If GetFileSaveName("Archivo para Casino", ls_Path, ls_File, "XLSX","Excel Files(*.xls),*.xls", "C:\My Documents") < 1 Then
	lb_Retorno = False
Else
	If dw_Asignacion.Retrieve(_Usuario, _Fecha) = -1 Then 
		MessageBox("Error", "No se pudo generar Informacion de archivo para casino: " + ls_File, Information!, Ok!)
		lb_Retorno = False
	Else
		If dw_Asignacion.SaveAs(ls_Path, Excel8!, True) = -1 Then
			MessageBox("Error", "No se pudo grabar archivo para casino: " + ls_File, Information!, Ok!)
			lb_Retorno = False
		End If
	End If
End If 

Return lb_Retorno
end function

private subroutine of_setusuario (string as_usuario);If IsNull(as_Usuario) Then Return
This._Usuario = as_Usuario
end subroutine

private subroutine of_setfecha (date ad_fecha);If IsNull(ad_Fecha) Then 
	This._Fecha= ToDay()
Else
	This._Fecha= ad_Fecha
End If
end subroutine

private subroutine of_habilitar (boolean subir, boolean genera);pb_Subir.Enabled = Subir 
pb_Generar.Enabled = Genera
end subroutine

private subroutine of_sethasta (date ad_fecha);If IsNull(ad_Fecha) Then 
	This._Hasta= ToDay()
Else
	This._Hasta= ad_Fecha
End If
end subroutine

private function boolean of_bajar (ref datawindow adw, string filtro);Boolean	lb_Retorno
Long		ll_File, ll_Fila, ll_Find
String		ls_Path, ls_File, ls_Find

SetPointer(HourGlass!)

adw.SetRedraw(False)

adw.SetFilter("")
adw.Filter()

If GetFileOpenName("Archivo para Casino", ls_Path, ls_File, "XLS","Excel Files(*.xls),*.xls", "C:\My Documents") < 1 Then 
	lb_Retorno = False
Else
	
	OleObject 	loo_Excel
	loo_Excel		=	Create OleObject 
	
	dw_Asignacion.Reset()
	
	loo_Excel.ConnectToNewObject( "excel.application" ) 
	loo_Excel.Visible = False 
	loo_Excel.WorkBooks.Open( ls_Path)
	loo_Excel.Application.ActiveWorkbook.Worksheets[1].Activate 
	loo_Excel.Application.ActiveWorkbook.Worksheets[1].Range("A1").Activate 
	loo_Excel.ActiveCell.CurrentRegion.Select() 
	loo_Excel.Selection.Copy() 
	dw_Asignacion.ImportClipBoard (2)
	
	ClipBoard('')
	loo_Excel.WorkBooks.Close()
	loo_Excel.Application.Quit
	loo_Excel.DisconnectObject()
	
	ll_File = dw_Asignacion.ImportFile(CSV!, ls_File)
		
	If ll_File < 0 Then
		MessageBox('Alerta', 'Error en la carga de archivo.', Exclamation!, OK!)
		lb_Retorno = False
	Else
		For ll_Fila = 1 To dw_Asignacion.RowCount()
			
			ls_Find = "cape_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 1"
			ll_Find = adw.Find(ls_Find, 1, adw.RowCount(), Primary!)
			
			if ll_Find > 0 Then
				adw.Object.caco_codigo[ll_Find]	=	dw_Asignacion.Object.Desayuno[ll_Fila]
				
				adw.SetRow(ll_Find)
				adw.ScrollToRow(ll_Find)
			End If
			
			SetNull(ll_Find)
			ls_Find = "cape_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 2"
			ll_Find = adw.Find(ls_Find, 1, adw.RowCount(), Primary!)
			
			if ll_Find > 0 Then
				adw.Object.caco_codigo[ll_Find]	=	dw_Asignacion.Object.Almuerzo[ll_Fila]
				
				adw.SetRow(ll_Find)
				adw.ScrollToRow(ll_Find)
			End If
			
			SetNull(ll_Find)
			ls_Find = "cape_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 3"
			ll_Find = adw.Find(ls_Find, 1, adw.RowCount(), Primary!)
			
			if ll_Find > 0 Then
				adw.Object.caco_codigo[ll_Find]	=	dw_Asignacion.Object.Once[ll_Fila]
				
				adw.SetRow(ll_Find)
				adw.ScrollToRow(ll_Find)
			End If
			
			SetNull(ll_Find)
			ls_Find = "cape_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 4"
			ll_Find = adw.Find(ls_Find, 1, adw.RowCount(), Primary!)
			
			if ll_Find > 0 Then
				adw.Object.caco_codigo[ll_Find]	=	dw_Asignacion.Object.Cena[ll_Fila]
				
				adw.SetRow(ll_Find)
				adw.ScrollToRow(ll_Find)
			End If
			
		Next
	End If
	Destroy loo_Excel
End If

adw.SetFilter(Filtro)
adw.Filter()

adw.SetRedraw(True)

SetPointer(Arrow!)

Return lb_Retorno
end function

public subroutine of_iniciar (string usuario, date fecha, boolean subir, boolean bajar, ref datawindow adw, string filtro);Date ld_Hasta

SetNull(ld_Hasta)

of_Habilitar(Subir, Bajar)

of_SetUsuario(Usuario)
of_SetFecha(Fecha)
of_SetHasta(ld_Hasta)

_Dw		= adw
_Filter	=	Filtro

Return
end subroutine

on vou_personal.create
this.dw_asignacion=create dw_asignacion
this.pb_generar=create pb_generar
this.pb_subir=create pb_subir
this.Control[]={this.dw_asignacion,&
this.pb_generar,&
this.pb_subir}
end on

on vou_personal.destroy
destroy(this.dw_asignacion)
destroy(this.pb_generar)
destroy(this.pb_subir)
end on

event constructor;dw_Asignacion.SetTransObject(SQLCA)

end event

type dw_asignacion from uo_dw within vou_personal
boolean visible = false
integer x = 658
integer y = 32
integer width = 110
integer height = 96
integer taborder = 30
boolean enabled = false
string dataobject = "dw_genera_personalcolacion"
boolean vscrollbar = false
boolean border = false
end type

type pb_generar from picturebutton within vou_personal
string tag = "carga Archivo para Colaciones"
integer x = 293
integer width = 302
integer height = 244
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Descargar Nube.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Descargar Nube-bn.png"
alignment htextalign = left!
end type

event clicked;of_Bajar(_Dw, _Filter)
end event

type pb_subir from picturebutton within vou_personal
string tag = "Genera Archvio para Colaciones"
integer width = 302
integer height = 244
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Subir Nube.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Subir Nube-bn.png "
alignment htextalign = left!
end type

event clicked;of_subir()
end event

