$PBExportHeader$w_carga_plantillacolacion.srw
forward
global type w_carga_plantillacolacion from w_para_informes
end type
type dw_asignacion from uo_dw within w_carga_plantillacolacion
end type
type mle_msg from multilineedit within w_carga_plantillacolacion
end type
type dw_carga from uo_dw within w_carga_plantillacolacion
end type
type st_1 from statictext within w_carga_plantillacolacion
end type
type uo_selzona from uo_seleccion_zonas within w_carga_plantillacolacion
end type
end forward

global type w_carga_plantillacolacion from w_para_informes
integer width = 2693
integer height = 1608
string title = "Plantilla Colacion"
dw_asignacion dw_asignacion
mle_msg mle_msg
dw_carga dw_carga
st_1 st_1
uo_selzona uo_selzona
end type
global w_carga_plantillacolacion w_carga_plantillacolacion

type variables

end variables

forward prototypes
public subroutine wf_msg (string msg)
protected function boolean wf_actualiza_db ()
end prototypes

public subroutine wf_msg (string msg);If IsNull(MSG) Then MSG = ''

mle_MSG.Text += String(Today(), 'dd/mm/yyyy hh:mm:ss') + ' - ' + MSG + '~r~n'
mle_MSG.Scroll(mle_MSG.LineCount())

end subroutine

protected function boolean wf_actualiza_db ();Boolean		lb_AutoCommit, lb_Retorno
DateTime	ldt_FechaHora

ldt_FechaHora				=	F_FechaHora()
dw_Carga.GrupoFecha	=	ldt_FechaHora

IF Not dw_Carga.uf_check_required(0) THEN RETURN False
IF Not dw_Carga.uf_validate(0) THEN RETURN False

lb_AutoCommit		=	sqlca.AutoCommit
SQLCA.AutoCommit	=	False

IF dw_Carga.Update(True, False) = 1 then 
	Commit;
	IF SQLCA.SQLCode <> 0 THEN
		F_ErrorBaseDatos(sqlca, This.Title)
		lb_Retorno	=	False
	ELSE
		lb_Retorno	=	True
		dw_Carga.ResetUpdate()
	END IF
ELSE
	RollBack;
	IF SQLCA.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
	
	lb_Retorno	=	False
END IF

sqlca.AutoCommit	=	lb_AutoCommit

RETURN lb_Retorno
end function

on w_carga_plantillacolacion.create
int iCurrent
call super::create
this.dw_asignacion=create dw_asignacion
this.mle_msg=create mle_msg
this.dw_carga=create dw_carga
this.st_1=create st_1
this.uo_selzona=create uo_selzona
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_asignacion
this.Control[iCurrent+2]=this.mle_msg
this.Control[iCurrent+3]=this.dw_carga
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.uo_selzona
end on

on w_carga_plantillacolacion.destroy
call super::destroy
destroy(this.dw_asignacion)
destroy(this.mle_msg)
destroy(this.dw_carga)
destroy(this.st_1)
destroy(this.uo_selzona)
end on

event open;call super::open;Boolean	lb_Cerrar

If IsNull(uo_SelZona.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	dw_Asignacion.SetTransObject(Sqlca)
	dw_Carga.SetTransObject(Sqlca)
	
	uo_SelZona.Seleccion(False, False)
End If
end event

type pb_excel from w_para_informes`pb_excel within w_carga_plantillacolacion
string tag = "Carga Plantilla Excel"
boolean visible = true
integer x = 2304
integer y = 768
integer weight = 400
fontcharset fontcharset = ansi!
string picturename = "\Desarrollo 17\Imagenes\Botones\Descargar Nube.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Descargar Nube-bn.png"
end type

event pb_excel::clicked;call super::clicked;Boolean	lb_Retorno
Long		ll_File, ll_Fila, ll_Find, ll_New
String		ls_Path, ls_File, ls_Find

SetPointer(HourGlass!)

dw_Carga.SetRedraw(False)

wf_Msg('Inicio Proceso de Carga Plantilla Asignacion de Colaciones...')

If GetFileOpenName("Archivo para Casino", ls_Path, ls_File, "XLS","Excel Files(*.xls),*.xls", "C:\My Documents") < 1 Then 
	wf_Msg('No se pudo Cargar Plantilla Asignacion de Colaciones...')
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
	
	wf_Msg('Importacion de Plantilla Asignacion de Colaciones...')
		
	If ll_File < 0 Then
		wf_Msg('Error en la carga de Plantilla Asignacion de Colaciones...')
	Else
		For ll_Fila = 1 To dw_Asignacion.RowCount()
			
			If dw_Asignacion.Object.Desayuno[ll_Fila] > 1 Then
				ls_Find = "pers_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 1"  + &
							" and zona_codigo = " + String(uo_SelZona.Codigo) + " And caco_codigo = " + String(dw_Asignacion.Object.Desayuno[ll_Fila])
				ll_Find = dw_Carga.Find(ls_Find, 1, dw_Carga.RowCount(), Primary!)
				
				If ll_Find = 0 Then
					ll_New = dw_Carga.InsertRow(0)
					dw_Carga.Object.pers_codigo[ll_New]	=	dw_Asignacion.Object.Rut[ll_Fila]
					dw_Carga.Object.zona_codigo[ll_New]	=	uo_SelZona.Codigo
					dw_Carga.Object.tico_codigo[ll_New]		=	1
					dw_Carga.Object.caco_codigo[ll_New]	=	dw_Asignacion.Object.Desayuno[ll_Fila]
				End If
			End If
			
			SetNull(ll_Find)
			If dw_Asignacion.Object.ALmuerzo[ll_Fila] > 1 Then
				ls_Find = "pers_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 2"  + &
							" and zona_codigo = " + String(uo_SelZona.Codigo) + " And caco_codigo = " + String(dw_Asignacion.Object.Desayuno[ll_Fila])
				ll_Find = dw_Carga.Find(ls_Find, 1, dw_Carga.RowCount(), Primary!)
				
				If ll_Find = 0 Then
					ll_New = dw_Carga.InsertRow(0)
					dw_Carga.Object.pers_codigo[ll_New]	=	dw_Asignacion.Object.Rut[ll_Fila]
					dw_Carga.Object.zona_codigo[ll_New]	=	uo_SelZona.Codigo
					dw_Carga.Object.tico_codigo[ll_New]		=	2
					dw_Carga.Object.caco_codigo[ll_New]	=	dw_Asignacion.Object.Almuerzo[ll_Fila]
				End If
			End If
			
			SetNull(ll_Find)
			If dw_Asignacion.Object.Once[ll_Fila] > 1 Then
				ls_Find = "pers_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 3"  + &
							" and zona_codigo = " + String(uo_SelZona.Codigo) + " And caco_codigo = " + String(dw_Asignacion.Object.Desayuno[ll_Fila])
				ll_Find = dw_Carga.Find(ls_Find, 1, dw_Carga.RowCount(), Primary!)
				
				If ll_Find = 0 Then
					ll_New = dw_Carga.InsertRow(0)
					dw_Carga.Object.pers_codigo[ll_New]	=	dw_Asignacion.Object.Rut[ll_Fila]
					dw_Carga.Object.zona_codigo[ll_New]	=	uo_SelZona.Codigo
					dw_Carga.Object.tico_codigo[ll_New]		=	3
					dw_Carga.Object.caco_codigo[ll_New]	=	dw_Asignacion.Object.Once[ll_Fila]
				End If
			End If
			
			SetNull(ll_Find)
			If dw_Asignacion.Object.Cena[ll_Fila] > 1 Then
				ls_Find = "pers_codigo = '" + dw_Asignacion.Object.Rut[ll_Fila] + "' and tico_codigo = 4"  + &
							" and zona_codigo = " + String(uo_SelZona.Codigo) + " And caco_codigo = " + String(dw_Asignacion.Object.Desayuno[ll_Fila])
				ll_Find = dw_Carga.Find(ls_Find, 1, dw_Carga.RowCount(), Primary!)
				
				If ll_Find = 0 Then
					ll_New = dw_Carga.InsertRow(0)
					dw_Carga.Object.pers_codigo[ll_New]	=	dw_Asignacion.Object.Rut[ll_Fila]
					dw_Carga.Object.zona_codigo[ll_New]	=	uo_SelZona.Codigo
					dw_Carga.Object.tico_codigo[ll_New]		=	4
					dw_Carga.Object.caco_codigo[ll_New]	=	dw_Asignacion.Object.Cena[ll_Fila]
				End If
			End If
		Next
	End If
	Destroy loo_Excel
End If

wf_Msg('Termino Proceso de Carga Plantilla Asignacion de Colaciones...')

dw_Carga.SetRedraw(True)

If wf_actualiza_db() Then
	wf_Msg('Información Grabada Plantilla Asignacion de Colaciones...')
Else
	wf_Msg('No se puede Grabar información Plantilla Asignacion de Colaciones...')
End If

SetPointer(Arrow!)

end event

type st_computador from w_para_informes`st_computador within w_carga_plantillacolacion
integer x = 1074
end type

type st_usuario from w_para_informes`st_usuario within w_carga_plantillacolacion
integer x = 1074
end type

type st_temporada from w_para_informes`st_temporada within w_carga_plantillacolacion
integer x = 1074
end type

type p_logo from w_para_informes`p_logo within w_carga_plantillacolacion
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_carga_plantillacolacion
integer x = 242
integer width = 1929
integer height = 96
string text = "Carga Plantilla Colaciones"
end type

type pb_acepta from w_para_informes`pb_acepta within w_carga_plantillacolacion
string tag = "Genera Plantilla Excel"
integer x = 2304
integer y = 480
string picturename = "\Desarrollo 17\Imagenes\Botones\Subir Nube.png "
string disabledname = "\Desarrollo 17\Imagenes\Botones\Subir Nube-bn.png "
end type

event pb_acepta::clicked;call super::clicked;String		ls_Path, ls_File

wf_Msg('Inicio Proceso de Generacion archivo para asignacion de colaciones...')

If GetFileSaveName("Archivo para Casino", ls_Path, ls_File, "XLSX","Excel Files(*.xls),*.xls", "C:\My Documents") < 1 Then
	MessageBox('Atencion', 'No se pudo crear archivo.')
Else
	If dw_Asignacion.Retrieve() = -1 Then 
		wf_Msg("No se pudo generar para asignacion de colaciones: " + ls_File)
	Else
		If dw_Asignacion.SaveAs(ls_Path, Excel8!, True) = -1 Then
			wf_Msg("No se pudo grabar archivo  para asignacion de colaciones: " + ls_File)
		Else
			wf_Msg("Grabo archivo  para asignacion de colaciones: " + ls_Path)
		End If
	End If
End If

wf_Msg('Termino Proceso de Generacion archivo para asignacion de colaciones...')
end event

type pb_salir from w_para_informes`pb_salir within w_carga_plantillacolacion
integer x = 2295
integer y = 1096
end type

type dw_asignacion from uo_dw within w_carga_plantillacolacion
boolean visible = false
integer x = 2121
integer y = 96
integer width = 183
integer height = 128
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_genera_personalcolacion"
boolean vscrollbar = false
end type

type mle_msg from multilineedit within w_carga_plantillacolacion
integer x = 219
integer y = 608
integer width = 1938
integer height = 800
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean italic = true
long textcolor = 16711680
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_carga from uo_dw within w_carga_plantillacolacion
boolean visible = false
integer x = 2158
integer y = 224
integer width = 183
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_mues_plantillacolacion"
boolean vscrollbar = false
end type

type st_1 from statictext within w_carga_plantillacolacion
integer x = 256
integer y = 464
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Zona"
boolean focusrectangle = false
end type

type uo_selzona from uo_seleccion_zonas within w_carga_plantillacolacion
integer x = 439
integer y = 448
integer width = 878
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		
	Case Else
		pb_Excel.Enabled = True
		
End Choose
end event

