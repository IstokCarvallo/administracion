$PBExportHeader$w_maed_asignacionlicencias.srw
forward
global type w_maed_asignacionlicencias from w_mant_encab_deta
end type
type tab_1 from tab within w_maed_asignacionlicencias
end type
type tabpage_1 from userobject within tab_1
end type
type dw_equipos from uo_dw within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_equipos dw_equipos
end type
type tabpage_2 from userobject within tab_1
end type
type dw_documentacion from uo_dw within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_documentacion dw_documentacion
end type
type tabpage_3 from userobject within tab_1
end type
type dw_observacion from uo_dw within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_observacion dw_observacion
end type
type tab_1 from tab within w_maed_asignacionlicencias
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_maed_asignacionlicencias from w_mant_encab_deta
integer width = 3301
integer height = 2728
string title = "Maestro Asignacion de Licencias"
string menuname = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_imprimir ( )
tab_1 tab_1
end type
global w_maed_asignacionlicencias w_maed_asignacionlicencias

type variables
w_mant_deta_licenciapersonal	iw_mantencion

String	is_Ruta

uo_Licencia			iuo_Licencia
uo_imagenes		iuo_Imagenes
end variables

forward prototypes
public subroutine habilitaencab (boolean habilita)
public subroutine habilitaingreso ()
protected function boolean wf_actualiza_db (boolean borrando)
public function boolean wf_grabaimagenes ()
public function boolean wf_carga (string as_tipo, integer row)
public subroutine wf_muestraarchivo (datawindow adw, integer row, string tipo)
end prototypes

event ue_imprimir;SetPointer(HourGlass!)

Datetime	ld_desde, ld_hasta
Long		fila

str_info	lstr_info

lstr_info.titulo	= "FICHA LICENCIAS"
lstr_info.copias	= 1

ld_Desde	=	DateTime(Date('19000101'), Time('00:00:00'))
ld_Hasta	=	DateTime(Today(), Time('23:59:59'))

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_licencias"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(Integer(istr_mant.argumento[1]), ld_desde, ld_hasta)

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No Existe información para este informe.", &
					StopSign!, OK!)
	
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')
END IF

SetPointer(Arrow!)
					
end event

public subroutine habilitaencab (boolean habilita);If Habilita Then
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.Protect		= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.Protect	= 0
	
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.BackGround.Color=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.BackGround.Color=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.BackGround.Color	=  RGB(255,255,255)
	
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.Color=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.Color=  0
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.Color	=  0
	
Else
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.Protect		= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.Protect	= 1
	
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.BackGround.Color=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.BackGround.Color=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.BackGround.Color	=  553648127
	
	Tab_1.TabPage_1.dw_Equipos.Object.lice_codigo.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_nombre.Color=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_feccom.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_valcom.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_serie.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canmes.Color=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.lice_canins.Color	=  RGB(255,255,255)
End If

Return
end subroutine

public subroutine habilitaingreso ();Boolean	lb_habilita = True

dw_2.AcceptText()

If IsNull(dw_2.Object.lice_codigo[1]) Or dw_2.Object.lice_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.lice_serie[1]) Or dw_2.Object.lice_serie[1] = '' Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.lice_feccom[1]) Then
	lb_habilita = False
End If

pb_ins_det.Enabled	=	lb_habilita

Return
end subroutine

protected function boolean wf_actualiza_db (boolean borrando);Boolean	lb_AutoCommit, lb_Retorno

If Not dw_2.uf_check_required(0) Then Return False
If Not dw_1.uf_validate(0) Then Return False

lb_AutoCommit		=	sqlca.AutoCommit
sqlca.AutoCommit	=	False

If Borrando Then
	If dw_1.Update(True, False) = 1 Then
			If dw_2.Update(True, False) = 1 Then
				Commit;
				
				If sqlca.SQLCode <> 0 Then
					F_ErrorBaseDatos(sqlca, This.Title)
					
					RollBack;
				Else
					lb_Retorno	=	True
					
					dw_1.ResetUpdate()
					dw_2.ResetUpdate()
				End If
			Else
				F_ErrorBaseDatos(sqlca, This.Title)
				
				RollBack;
			End If
	Else
		F_ErrorBaseDatos(sqlca, This.Title)
	End If
Else
	If dw_2.Update(True, False) = 1 Then
		If dw_1.Update(True, False) = 1 Then
			Commit;
			
			If sqlca.SQLCode <> 0 Then
				F_ErrorBaseDatos(sqlca, This.Title)
				
				RollBack;
			Else
				lb_Retorno	=	True
				
				dw_2.ResetUpdate()
				dw_1.ResetUpdate()
			End If
		Else
			F_ErrorBaseDatos(sqlca, This.Title)
			
			RollBack;
		End If
	Else
		F_ErrorBaseDatos(sqlca, This.Title)
	End If
End If

sqlca.AutoCommit	=	lb_AutoCommit

Return lb_Retorno
end function

public function boolean wf_grabaimagenes ();Boolean	lb_Retorno = True

If dw_2.RowCount() < 1 Then
	lb_Retorno = False
Else
	If Not IsNull(dw_2.Object.lice_pathoc[1]) Then iuo_Imagenes.GrabaImagenLI(dw_2, 1, Sqlca, 'OC'+dw_2.Object.lice_pathoc[1])
	If Not IsNull(dw_2.Object.lice_pathfa[1]) Then	 iuo_Imagenes.GrabaImagenLI(dw_2, 1, Sqlca, 'FA'+dw_2.Object.lice_pathfa[1])
End If

Return lb_Retorno



end function

public function boolean wf_carga (string as_tipo, integer row);Boolean	lb_Retorno
String 	ls_Path, ls_File, ls_Columna
integer 	li_respuesta

li_Respuesta	= GetFileOpenName("Seleccion de Archivo", ls_Path, ls_File, "PDF", + "PDF Files (*.PDF),*.PDF", is_Ruta, 18) 

IF li_Respuesta < 1 Then
	lb_Retorno = False
Else
	Choose Case as_Tipo
		Case 'OC'
			ls_Columna = 'lice_pathoc'
						
		Case 'FA'
			ls_Columna = 'lice_pathfa'
			
	End Choose
	
	If dw_2.SetItem(Row, ls_Columna, ls_Path) < 1 Then
		lb_Retorno = False
	Else
		lb_Retorno = True
	End If
End If

Return lb_Retorno
end function

public subroutine wf_muestraarchivo (datawindow adw, integer row, string tipo);String	ls_Archivo

If Row < 1 Then Return

Choose Case Tipo
	Case 'OC'
		ls_Archivo	=	adw.Object.lice_pathoc[Row]
				
	Case 'FA'
		ls_Archivo	=	adw.Object.lice_pathfa[Row]
End Choose

If FileExists(ls_Archivo) Then 
	iuo_Imagenes.AbrirDocumento(ls_Archivo)
Else
	iuo_Imagenes.RecuperaImagenLI(adw, Row, Sqlca, Tipo)
End If

Return
end subroutine

on w_maed_asignacionlicencias.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_maed_asignacionlicencias.destroy
call super::destroy
destroy(this.tab_1)
end on

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila_d, ll_fila_e, respuesta, ll_fila

Do
	dw_2.SetRedraw(False)
	dw_2.Reset()
	ll_fila_e	= dw_2.Retrieve(Long(istr_Mant.Argumento[1]))
	
	If ll_fila_e = -1 Then
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
	Else
		HabilitaEncab(False)
		Do
			ll_fila_d	= dw_1.Retrieve(Long(istr_Mant.Argumento[1])) 
			
			If ll_fila_d = -1 Then
				respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
			Else
				pb_eliminar.Enabled 	= True
				pb_grabar.Enabled	= True
				pb_ins_det.Enabled	= True
				pb_imprimir.Enabled	= True
				If ll_fila_d > 0 Then
					pb_eli_det.Enabled	= True
					dw_1.SetRow(1)
					dw_1.SelectRow(1,True)
					dw_1.SetFocus()
				Else
					pb_ins_det.SetFocus()
				End If
			End If
		Loop While respuesta = 1

		If respuesta = 2 Then Close(This)
	End If
	dw_2.SetRedraw(True)
	
Loop While respuesta = 1

If respuesta = 2 Then Close(This)
end event

event ue_borra_detalle;call super::ue_borra_detalle;Long	ll_fila
Byte lb_TabPage

SetPointer(HourGlass!)

istr_mant.Borra		= True
istr_mant.Agrega	= False

istr_mant.Argumento[1]	=	String(dw_2.Object.lice_codigo[1])

If dw_1.RowCount() < 1 Then Return

ib_borrar = True

w_main.SetMicrohelp("Validando la eliminacion de detalle...")

Message.DoubleParm = 0

This.TriggerEvent ("ue_validaborrar_detalle")

If Message.DoubleParm = -1 Then Return

OpenWithParm(iw_mantencion, istr_mant)
istr_mant = Message.PowerObjectParm

If istr_mant.respuesta = 1 Then
	If dw_1.DeleteRow(0) = 1 Then
		ib_borrar = False
		w_main.SetMicroHelp("Borrando Registro...")
		
		ll_fila = dw_1.GetRow()
		dw_1.SetRow(ll_fila)
		dw_1.SelectRow(ll_fila, True)		
	Else
		ib_borrar = False
		MessageBox(This.Title,"No se puede borrar actual registro.")
	End If
	
	If dw_1.RowCount() = 0 Then
		Habilitaencab(True)
		pb_eli_det.Enabled = False
	End If
End If

SetPointer(Arrow!)
istr_mant.Borra	= False

end event

event ue_seleccion;call super::ue_seleccion;istr_busq.Argum[2] = gstr_us.Nombre

OpenWithParm(w_busc_licencias,istr_busq)

istr_busq	= Message.PowerObjectParm

If UpperBound(istr_busq.argum) > 1 Then
	If istr_busq.argum[1] <> "" Then
		istr_Mant.Argumento[1]	=	istr_Busq.Argum[1]
		istr_Mant.Argumento[2]	=	istr_Busq.Argum[2]
		This.TriggerEvent("ue_recuperadatos")
	Else
		pb_buscar.SetFocus()
	End If 
End If
end event

event ue_nuevo_detalle;call super::ue_nuevo_detalle;istr_mant.Borra		= False
istr_mant.Agrega	= True

istr_mant.Argumento[1]	=	String(dw_2.Object.lice_codigo[1])

OpenWithParm(iw_mantencion, istr_mant)

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled	= True
End If
	
dw_1.SetRow(il_fila)
dw_1.SelectRow(il_fila,True)
end event

event ue_nuevo;call super::ue_nuevo;HabilitaEncab(True)
	
//dw_2.Object.usua_codigo[1] 	=	gstr_us.Nombre
//dw_2.Object.smen_usuari[1]	=	gstr_us.Nombre
//dw_2.Object.smen_fechad[1]	=	Today()

istr_Mant.Argumento[1]	=	''
istr_Mant.Argumento[2]	=	''

dw_2.SetColumn("lice_codigo")

end event

event ue_modifica_detalle;istr_mant.Argumento[1]	=	String(dw_2.Object.lice_codigo[1])

If dw_1.RowCount() > 0 Then
	istr_mant.Agrega	= False
	istr_mant.Borra		= False

	OpenWithParm(iw_mantencion, istr_mant)
End If
end event

event open;call super::open;dw_2.ShareData(tab_1.TabPage_1.dw_Equipos)
dw_2.ShareData(tab_1.TabPage_2.dw_Documentacion)
dw_2.ShareData(tab_1.TabPage_3.dw_Observacion)


Tab_1.TabPage_1.dw_Equipos.SetTransObject(SQLCA)
Tab_1.TabPage_2.dw_Documentacion.SetTransObject(SQLCA)
Tab_1.TabPage_3.dw_Observacion.SetTransObject(SQLCA)

iuo_Licencia		=	Create uo_Licencia
iuo_Imagenes	=	Create uo_imagenes

RegistryGet( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Personal", RegString!, is_Ruta)
end event

event ue_antesguardar;call super::ue_antesguardar;Long	ll_Fila

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.GetItemStatus(ll_Fila, 0, Primary!) = New! Then
		dw_1.DeleteRow(ll_Fila)
	End If
Next
end event

event ue_guardar;call super::ue_guardar;If dw_1.AcceptText() = -1 Then Return

SetPointer(HourGlass!)

w_main.SetMicroHelp("Grabando información...")

Message.DoubleParm = 0

TriggerEvent("ue_antesguardar")

If Message.DoubleParm = -1 Then Return

If wf_actualiza_db(False) Then	
	If Not wf_GrabaImagenes() Then MessageBox('Atencion', 'Imagenes no pudieron ser almacenadas', Information!, OK!)
	
	w_main.SetMicroHelp("Información Grabada.")
	pb_eliminar.Enabled	= True
	pb_imprimir.Enabled	= True
Else
	w_main.SetMicroHelp("No se puede Grabar información.")
	Message.DoubleParm = -1
	Return
End If
end event

event resize;call super::resize;Tab_1.x			=	dw_2.x
Tab_1.y 			=	dw_2.y
Tab_1.Width	=	dw_2.Width
Tab_1.Height	=	dw_2.Height
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_asignacionlicencias
integer x = 105
integer y = 1048
integer width = 2642
integer height = 1036
integer taborder = 100
string title = "Documentos"
string dataobject = "dw_mues_licenciapersonal"
end type

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_asignacionlicencias
integer x = 87
integer y = 124
integer width = 2345
integer height = 924
integer taborder = 10
string dataobject = "dw_mant_licencias"
end type

event dw_2::itemchanged;Integer	li_Null
String		ls_columna, ls_Rut

SetNull(li_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case ''		
End Choose

HabilitaIngreso()


end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_asignacionlicencias
integer x = 2930
integer taborder = 30
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_asignacionlicencias
integer x = 2930
integer y = 524
integer taborder = 40
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_asignacionlicencias
integer x = 2930
integer y = 700
integer taborder = 50
boolean enabled = true
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_asignacionlicencias
integer x = 2944
integer y = 888
integer taborder = 60
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_asignacionlicencias
integer x = 2930
integer y = 1064
integer taborder = 90
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_asignacionlicencias
integer x = 2944
integer y = 1356
integer taborder = 70
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_asignacionlicencias
integer x = 2944
integer y = 1532
integer taborder = 80
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_asignacionlicencias
integer x = 2935
integer y = 160
integer taborder = 20
end type

type tab_1 from tab within w_maed_asignacionlicencias
integer x = 87
integer y = 24
integer width = 2345
integer height = 904
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
alignment alignment = right!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2309
integer height = 776
long backcolor = 16777215
string text = "Licencias"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
string picturename = "Custom072!"
long picturemaskcolor = 536870912
dw_equipos dw_equipos
end type

on tabpage_1.create
this.dw_equipos=create dw_equipos
this.Control[]={this.dw_equipos}
end on

on tabpage_1.destroy
destroy(this.dw_equipos)
end on

type dw_equipos from uo_dw within tabpage_1
integer x = 50
integer y = 52
integer width = 2158
integer height = 640
integer taborder = 11
string dataobject = "dw_mant_licencias_licen"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case 'lice_codigo'
		istr_Mant.Argumento[1] = Data
		If iuo_Licencia.Existe(Long(Data), False, Sqlca) Then
			w_maed_asignacionlicencias.TriggerEvent("ue_recuperadatos")
		End If
		
End Choose

HabilitaIngreso()


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2309
integer height = 776
long backcolor = 16777215
string text = "Documentación"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
string picturename = "CreateIndex!"
long picturemaskcolor = 536870912
dw_documentacion dw_documentacion
end type

on tabpage_2.create
this.dw_documentacion=create dw_documentacion
this.Control[]={this.dw_documentacion}
end on

on tabpage_2.destroy
destroy(this.dw_documentacion)
end on

type dw_documentacion from uo_dw within tabpage_2
integer x = 50
integer y = 52
integer width = 2240
integer height = 704
integer taborder = 11
string dataobject = "dw_mant_licencias_documentos"
boolean vscrollbar = false
boolean border = false
end type

event buttonclicked;call super::buttonclicked;String		ls_Null, ls_Boton

SetNull(ls_Null)
ls_Boton = dwo.name

Choose  Case ls_Boton		
	Case 'b_carga_orden'
		wf_Carga('OC', Row)
		
	Case 'b_carga_factura'
		wf_Carga('FA', Row)
		
	Case 'b_vis_orden'
		wf_MuestraArchivo(This, Row, 'OC')
		
	Case 'b_vis_factura'
		wf_MuestraArchivo(This, Row, 'FA')
		
End Choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2309
integer height = 776
long backcolor = 16777215
string text = "Observaciones"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
string picturename = "Copy!"
long picturemaskcolor = 536870912
dw_observacion dw_observacion
end type

on tabpage_3.create
this.dw_observacion=create dw_observacion
this.Control[]={this.dw_observacion}
end on

on tabpage_3.destroy
destroy(this.dw_observacion)
end on

type dw_observacion from uo_dw within tabpage_3
integer x = 50
integer y = 52
integer width = 2208
integer height = 684
integer taborder = 11
string dataobject = "dw_mant_licencia_observacion"
boolean vscrollbar = false
boolean border = false
end type

