$PBExportHeader$w_carga_colaboradores_fuerazona.srw
forward
global type w_carga_colaboradores_fuerazona from w_para_informes
end type
type st_1 from statictext within w_carga_colaboradores_fuerazona
end type
type uo_selzona from uo_seleccion_zonas within w_carga_colaboradores_fuerazona
end type
type st_2 from statictext within w_carga_colaboradores_fuerazona
end type
type dw_1 from uo_dw within w_carga_colaboradores_fuerazona
end type
type st_3 from statictext within w_carga_colaboradores_fuerazona
end type
type uo_selempresa from uo_seleccion_empresa within w_carga_colaboradores_fuerazona
end type
type st_4 from statictext within w_carga_colaboradores_fuerazona
end type
type sle_search from singlelineedit within w_carga_colaboradores_fuerazona
end type
type uo_selarea from uo_seleccion_areas within w_carga_colaboradores_fuerazona
end type
end forward

global type w_carga_colaboradores_fuerazona from w_para_informes
integer width = 4325
integer height = 2372
string title = "Carga Colaboradores"
st_1 st_1
uo_selzona uo_selzona
st_2 st_2
dw_1 dw_1
st_3 st_3
uo_selempresa uo_selempresa
st_4 st_4
sle_search sle_search
uo_selarea uo_selarea
end type
global w_carga_colaboradores_fuerazona w_carga_colaboradores_fuerazona

type variables

end variables

on w_carga_colaboradores_fuerazona.create
int iCurrent
call super::create
this.st_1=create st_1
this.uo_selzona=create uo_selzona
this.st_2=create st_2
this.dw_1=create dw_1
this.st_3=create st_3
this.uo_selempresa=create uo_selempresa
this.st_4=create st_4
this.sle_search=create sle_search
this.uo_selarea=create uo_selarea
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_selzona
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.uo_selempresa
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_search
this.Control[iCurrent+9]=this.uo_selarea
end on

on w_carga_colaboradores_fuerazona.destroy
call super::destroy
destroy(this.st_1)
destroy(this.uo_selzona)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_3)
destroy(this.uo_selempresa)
destroy(this.st_4)
destroy(this.sle_search)
destroy(this.uo_selarea)
end on

event open;call super::open;Boolean	lb_Cerrar

If IsNull(uo_SelZona.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelEmpresa.Codigo) Then lb_Cerrar = True
If IsNull(uo_SelArea.Codigo) Then lb_Cerrar = True

If lb_Cerrar Then
	Close(This)
Else
	dw_1.SetTransObject(SqlCa)
	If dw_1.Retrieve() > 0 Then pb_Acepta.Enabled = True
	
	uo_SelZona.Seleccion(False, False)
	uo_SelEmpresa.Seleccion(False, False)
	uo_SelArea.Seleccion(False, False)
	
	uo_SelArea.Filtra(-1, '*')
End If
end event

event resize;call super::resize;dw_1.Resize(This.WorkSpaceWidth() - 650,This.WorkSpaceHeight() - dw_1.y - 75)
end event

type pb_excel from w_para_informes`pb_excel within w_carga_colaboradores_fuerazona
string tag = "Carga Plantilla Excel"
integer x = 3913
integer y = 772
integer taborder = 0
integer weight = 400
fontcharset fontcharset = ansi!
string picturename = "\Desarrollo 17\Imagenes\Botones\Descargar Nube.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Descargar Nube-bn.png"
end type

type st_computador from w_para_informes`st_computador within w_carga_colaboradores_fuerazona
integer x = 1074
end type

type st_usuario from w_para_informes`st_usuario within w_carga_colaboradores_fuerazona
integer x = 1074
end type

type st_temporada from w_para_informes`st_temporada within w_carga_colaboradores_fuerazona
integer x = 1074
end type

type p_logo from w_para_informes`p_logo within w_carga_colaboradores_fuerazona
string picturename = "\Desarrollo 17\Imagenes\Logos\RBlanco.jpg"
end type

type st_titulo from w_para_informes`st_titulo within w_carga_colaboradores_fuerazona
integer x = 242
integer width = 3543
integer height = 96
string text = "Carga Colaboradores fuera zona"
end type

type pb_acepta from w_para_informes`pb_acepta within w_carga_colaboradores_fuerazona
string tag = "Genera Plantilla Excel"
integer x = 3913
integer y = 484
integer taborder = 50
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Aceptar.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Aceptar-bn.png"
end type

event pb_acepta::clicked;call super::clicked;Long	ll_Fila

If dw_1.Object.Marcados[1] = 0 Then 
	MessageBox('Alerta', 'No existe ningun registro marcado para cargar colaboradores.')
	Return
End If

If uo_SelZona.Codigo = -1 Or uo_SelArea.Codigo = -1 Or uo_SelEmpresa.Codigo = '*' then
	MessageBox('Alerta', 'Debe seleccioanr una Zona, Area y/o Empresa para cargar colaboradores.')
	Return
End If

uo_PersonaColacion luo_Personal
luo_Personal	= Create uo_PersonaColacion


For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.Object.ticket[ll_Fila] = 1 Then 
		luo_Personal.of_Carga(dw_1.Object.pers_codigo[ll_Fila], dw_1.Object.pers_apepat[ll_Fila], dw_1.Object.pers_apemat[ll_Fila], &
					dw_1.Object.pers_nombre[ll_Fila], uo_SelZona.Codigo, uo_SelArea.Codigo, uo_SelEmpresa.Codigo, True, SQLCA)
	
	End If
Next

MessageBox('Atencion', 'Colaboradores cargados.')

If dw_1.Retrieve() = 0 Then pb_Acepta.Enabled = False

Destroy luo_Personal


end event

type pb_salir from w_para_informes`pb_salir within w_carga_colaboradores_fuerazona
integer x = 3904
integer y = 1100
integer taborder = 60
end type

type st_1 from statictext within w_carga_colaboradores_fuerazona
integer x = 256
integer y = 452
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Zona"
boolean focusrectangle = false
end type

type uo_selzona from uo_seleccion_zonas within w_carga_colaboradores_fuerazona
integer x = 489
integer y = 448
integer width = 878
integer height = 96
integer taborder = 10
boolean bringtotop = true
end type

on uo_selzona.destroy
call uo_seleccion_zonas::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case -1, -9
		
	Case Else
		uo_SelArea.Filtra(This.Codigo, uo_SelEmpresa.Codigo)
		
End Choose 
end event

type st_2 from statictext within w_carga_colaboradores_fuerazona
integer x = 2578
integer y = 452
integer width = 242
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Area"
boolean focusrectangle = false
end type

type dw_1 from uo_dw within w_carga_colaboradores_fuerazona
integer x = 242
integer y = 664
integer width = 3543
integer height = 1560
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_carga_colaboradores_fuerazona"
end type

type st_3 from statictext within w_carga_colaboradores_fuerazona
integer x = 1381
integer y = 456
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Empresa"
boolean focusrectangle = false
end type

type uo_selempresa from uo_seleccion_empresa within w_carga_colaboradores_fuerazona
integer x = 1682
integer y = 448
integer width = 878
integer height = 96
integer taborder = 20
boolean bringtotop = true
end type

on uo_selempresa.destroy
call uo_seleccion_empresa::destroy
end on

event ue_cambio;call super::ue_cambio;If IsNull(This.Codigo) Then Return

Choose Case This.Codigo
	Case '*', '**'
		
	Case Else
		uo_SelArea.Filtra(uo_SelZona.Codigo, This.Codigo)
		
End Choose 
end event

type st_4 from statictext within w_carga_colaboradores_fuerazona
integer x = 256
integer y = 560
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 553648127
string text = "Buscar"
boolean focusrectangle = false
end type

type sle_search from singlelineedit within w_carga_colaboradores_fuerazona
event ue_ingreso_tecla pbm_keyup
integer x = 485
integer y = 536
integer width = 3246
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

event ue_ingreso_tecla;String	ls_Search
dw_1.SetReDraw(False)

If IsNull(This.Text) Or This.Text = '' Then 
	dw_1.SetFilter("")
	dw_1.Filter()
Else
	ls_Search 	= "(Lower(pers_nombre) like '%" + This.Text + "%') Or "
	ls_Search  += "(Lower(pers_apepat) like '%" + This.Text + "%') Or "
	ls_Search  += "(Lower(pers_apemat) like '%" + This.Text + "%') Or "
	ls_Search  += "(Lower(pers_codigo) like '%" + This.Text + "%')"
	
	dw_1.SetFilter(ls_Search)
	dw_1.Filter()
End If

dw_1.SetReDraw(True)
end event

type uo_selarea from uo_seleccion_areas within w_carga_colaboradores_fuerazona
integer x = 2853
integer y = 448
integer width = 878
integer height = 96
integer taborder = 40
boolean bringtotop = true
end type

on uo_selarea.destroy
call uo_seleccion_areas::destroy
end on

