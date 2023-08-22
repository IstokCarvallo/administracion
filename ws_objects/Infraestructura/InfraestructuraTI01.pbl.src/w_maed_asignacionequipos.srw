$PBExportHeader$w_maed_asignacionequipos.srw
forward
global type w_maed_asignacionequipos from w_mant_encab_deta
end type
type tab_1 from tab within w_maed_asignacionequipos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_equipos from uo_dw within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_equipos dw_equipos
end type
type tabpage_6 from userobject within tab_1
end type
type dw_datos from uo_dw within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_datos dw_datos
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
type tab_1 from tab within w_maed_asignacionequipos
tabpage_1 tabpage_1
tabpage_6 tabpage_6
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type tab_2 from tab within w_maed_asignacionequipos
end type
type tabpage_4 from userobject within tab_2
end type
type dw_colaborador from uo_dw within tabpage_4
end type
type tabpage_4 from userobject within tab_2
dw_colaborador dw_colaborador
end type
type tabpage_5 from userobject within tab_2
end type
type dw_items from uo_dw within tabpage_5
end type
type tabpage_5 from userobject within tab_2
dw_items dw_items
end type
type tab_2 from tab within w_maed_asignacionequipos
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type pb_barcode from picturebutton within w_maed_asignacionequipos
end type
type dw_barcode from uo_dw within w_maed_asignacionequipos
end type
end forward

global type w_maed_asignacionequipos from w_mant_encab_deta
integer width = 4439
integer height = 2728
string title = "Maestro Equipos / Asignacion"
string menuname = ""
windowstate windowstate = maximized!
event ue_imprimir ( )
tab_1 tab_1
tab_2 tab_2
pb_barcode pb_barcode
dw_barcode dw_barcode
end type
global w_maed_asignacionequipos w_maed_asignacionequipos

type variables
w_mant_deta_asignaequipos	iw_mantencion
w_mant_deta_itemequipos		iw_mantencion2

DataWindowChild idwc_Modelo

String	is_Ruta

uo_Empresa			iuo_Empresa
uo_Marca			iuo_Marca
uo_Proveedor		iuo_Proveedor
uo_Proveedor		iuo_Leasing
uo_TipoEquipos	iuo_Tipo
uo_Equipo			iuo_Equipo
uo_imagenes		iuo_Imagenes
uo_Modelo			iuo_Modelo
uo_Ubicacion		iuo_Ubicacion
end variables

forward prototypes
public subroutine habilitaencab (boolean habilita)
public subroutine habilitaingreso ()
protected function boolean wf_actualiza_db (boolean borrando)
public function boolean wf_grabaimagenes ()
public function string wf_codigointerno (string as_prefijo, long al_serie, string as_fecha)
public function boolean wf_carga (string as_tipo, integer row)
public subroutine wf_muestraarchivo (datawindow adw, integer row, string tipo)
public function boolean wf_cambiaestado ()
end prototypes

event ue_imprimir;SetPointer(HourGlass!)

Datetime	ld_desde, ld_hasta
Long		fila

str_info	lstr_info

lstr_info.titulo	= "FICHA EQUIPOS COMPUTACIONALES"
lstr_info.copias	= 1

ld_Desde	=	DateTime(Date('19000101'), Time('00:00:00'))
ld_Hasta	=	DateTime(Today(), Time('23:59:59'))

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_equipoasignado"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(Integer(istr_mant.argumento[1]), -1, -1, -1, -1, -1, '*', ld_desde, ld_hasta)

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
	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.Protect	= 0
	
	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.BackGround.Color	=  RGB(255,255,255)

	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.Color	=  0

Else
	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.Protect	= 1
//	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.Protect	= 1
	
	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.BackGround.Color		=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.BackGround.Color		=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.equi_nroint.BackGround.Color		=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.BackGround.Color		=  553648127


	Tab_1.TabPage_1.dw_Equipos.Object.equi_codigo.Color		=  0 //Rgb(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.tieq_codigo.Color		=  0 //Rgb(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.equi_fecadq.Color	=  0 //Rgb(255,255,255)

End If

Return
end subroutine

public subroutine habilitaingreso ();Boolean	lb_habilita = True

dw_2.AcceptText()

If IsNull(dw_2.Object.equi_codigo[1]) Or dw_2.Object.equi_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.empr_codigo[1]) Or dw_2.Object.empr_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.marc_codigo[1]) Or dw_2.Object.marc_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.prov_codigo[1]) Or dw_2.Object.prov_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.tieq_codigo[1]) Or dw_2.Object.tieq_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.equi_nroser[1]) Or dw_2.Object.equi_nroser[1] = '' Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.ubic_codigo[1]) Or dw_2.Object.ubic_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.equi_fecadq[1]) Then
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
		If Tab_2.TabPage_5.dw_Items.Update(True, False) = 1 Then
			If dw_2.Update(True, False) = 1 Then
				Commit;
				
				If sqlca.SQLCode <> 0 Then
					F_ErrorBaseDatos(sqlca, This.Title)
					
					RollBack;
				Else
					lb_Retorno	=	True
					
					dw_1.ResetUpdate()
					dw_2.ResetUpdate()
					Tab_2.TabPage_5.dw_Items.ResetUpdate()
				End If
			Else
				F_ErrorBaseDatos(sqlca, This.Title)
				
				RollBack;
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
			If Tab_2.TabPage_5.dw_Items.Update(True, False) = 1 Then
				Commit;
				
				If sqlca.SQLCode <> 0 Then
					F_ErrorBaseDatos(sqlca, This.Title)
					
					RollBack;
				Else
					lb_Retorno	=	True
					
					dw_2.ResetUpdate()
					dw_1.ResetUpdate()
					Tab_2.TabPage_5.dw_Items.ResetUpdate()
				End If
			Else
				F_ErrorBaseDatos(sqlca, This.Title)
				
				RollBack;
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
	If Not IsNull(dw_2.Object.equi_pathoc[1]) Then iuo_Imagenes.GrabaImagen(dw_2, 1, Sqlca, 'OC'+dw_2.Object.equi_pathoc[1])
	If Not IsNull(dw_2.Object.equi_pathgd[1]) Then iuo_Imagenes.GrabaImagen(dw_2, 1, Sqlca, 'GD'+dw_2.Object.equi_pathgd[1])
	If Not IsNull(dw_2.Object.equi_pathfa[1]) Then	 iuo_Imagenes.GrabaImagen(dw_2, 1, Sqlca, 'FA'+dw_2.Object.equi_pathfa[1])
End If

Return lb_Retorno



end function

public function string wf_codigointerno (string as_prefijo, long al_serie, string as_fecha);String	ls_Retorno

If IsNull(as_Prefijo) Or as_Prefijo = '' Then 
	ls_Retorno = ''
ElseIf IsNull(al_Serie) Then 
	ls_Retorno = ''
ElseIf IsNull(as_Fecha) Or as_Fecha = '' Then 
	ls_Retorno = ''
Else
	ls_Retorno = as_Prefijo + as_fecha + String(al_Serie, '00000')
End If

Return ls_Retorno	
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
			ls_Columna = 'equi_pathoc'
			
		Case 'GD'
			ls_Columna = 'equi_pathgd'
			
		Case 'FA'
			ls_Columna = 'equi_pathfa'
			
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
		ls_Archivo	=	adw.Object.equi_pathoc[Row]
		
	Case 'GD'
		ls_Archivo	=	adw.Object.equi_pathgd[Row]
		
	Case 'FA'
		ls_Archivo	=	adw.Object.equi_pathfa[Row]
End Choose

If FileExists(ls_Archivo) Then 
	iuo_Imagenes.AbrirDocumento(ls_Archivo)
Else
	iuo_Imagenes.RecuperaImagen(adw, Row, Sqlca, Tipo)
End If

Return
end subroutine

public function boolean wf_cambiaestado ();Long			ll_Fila, ll_Find
DateTime	ld_Fecha
Boolean		lb_Retorno = True

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.GetItemStatus(ll_Fila, "eqas_estado", Primary!) = NewModified! Or &
		dw_1.GetItemStatus(ll_Fila, "eqas_estado", Primary!) = DataModified!  Then
		If dw_1.Object.eqas_estado[ll_Fila] = 1 Then 
			ll_Find = ll_Fila
			ld_Fecha = dw_1.Object.eqas_fecasg[ll_Fila]
		End If
	End If
Next

If ll_Find > 0 Then 
	For ll_Fila = 1 To dw_1.RowCount()
		If (dw_1.Object.eqas_estado[ll_Fila] = 1) And (ll_Fila <> ll_Find) Then
			dw_1.Object.eqas_estado[ll_Fila]	= 2
			dw_1.Object.eqas_fecter[ll_Fila]	= ld_Fecha
		End If
	Next
	dw_2.Object.equi_estado[1] = 1
Else
	dw_2.Object.equi_estado[1] = 0
End If

Return lb_Retorno
end function

on w_maed_asignacionequipos.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.tab_2=create tab_2
this.pb_barcode=create pb_barcode
this.dw_barcode=create dw_barcode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.tab_2
this.Control[iCurrent+3]=this.pb_barcode
this.Control[iCurrent+4]=this.dw_barcode
end on

on w_maed_asignacionequipos.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.tab_2)
destroy(this.pb_barcode)
destroy(this.dw_barcode)
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
			iuo_Tipo.Existe(dw_2.Object.tieq_codigo[1], False, SQLCA)
			
			Tab_1.TabPage_1.dw_Equipos.GetChild('mode_codigo', idwc_Modelo)
			idwc_Modelo.SetTransObject(SQLCA)
			idwc_Modelo.Retrieve(dw_2.Object.marc_codigo[1], dw_2.Object.tieq_codigo[1])
					
			ll_fila_d	= dw_1.Retrieve(Long(istr_Mant.Argumento[1])) 
			ll_fila_d	= Tab_2.TabPage_5.dw_Items.Retrieve(Long(istr_Mant.Argumento[1])) 
			
			If ll_fila_d = -1 Then
				respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
			Else
				pb_eliminar.Enabled 	= True
				pb_grabar.Enabled	= True
				pb_ins_det.Enabled	= True
				pb_imprimir.Enabled	= True
				pb_barcode.Enabled	= True
				
				If ll_fila_d > 0 Then
					pb_eli_det.Enabled	= True
					Tab_2.TabPage_4.dw_Colaborador.SetRow(1)
					Tab_2.TabPage_4.dw_Colaborador.SelectRow(1,True)
					Tab_2.TabPage_4.dw_Colaborador.SetFocus()
					
					Tab_2.TabPage_5.dw_Items.SetRow(1)
					Tab_2.TabPage_5.dw_Items.SelectRow(1,True)
					Tab_2.TabPage_5.dw_Items.SetFocus()
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

lb_TabPage	=	Tab_2.SelectedTab

istr_mant.Borra		= True
istr_mant.Agrega	= False

istr_mant.Argumento[1]	=	String(dw_2.Object.equi_codigo[1])

Choose Case lb_TabPage
		Case 1
			If dw_1.RowCount() < 1 Then Return
			
			istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador
			ib_borrar = True
			w_main.SetMicrohelp("Validando la eliminacion de detalle...")
			Message.DoubleParm = 0
			
			This.TriggerEvent ("ue_validaborrar_detalle")
			
			If Message.DoubleParm = -1 Then Return
			
			OpenWithParm(iw_mantencion, istr_mant)
			
			istr_mant = Message.PowerObjectParm
			
			
			If istr_mant.respuesta = 1 Then
				If Tab_2.TabPage_4.dw_Colaborador.DeleteRow(0) = 1 Then
					ib_borrar = False
					w_main.SetMicroHelp("Borrando Registro...")
					
					ll_fila = Tab_2.TabPage_4.dw_Colaborador.GetRow()
					Tab_2.TabPage_4.dw_Colaborador.SetRow(ll_fila)
					Tab_2.TabPage_4.dw_Colaborador.SelectRow(ll_fila, True)	
					wf_CambiaEstado()
				Else
					ib_borrar = False
					MessageBox(This.Title,"No se puede borrar actual registro.")
				End If
				
				If dw_1.RowCount() = 0 Then
					Habilitaencab(True)
					pb_eli_det.Enabled = False
				End If
			End If
	Case 2
			If Tab_2.TabPage_5.dw_Items.RowCount() < 1 Then Return
			
			istr_mant.dw						=	Tab_2.TabPage_5.dw_Items
			
			ib_borrar = True
			w_main.SetMicrohelp("Validando la eliminacion de detalle...")
			Message.DoubleParm = 0
			
			OpenWithParm(iw_mantencion2, istr_mant)
			istr_mant = Message.PowerObjectParm
			
			If istr_mant.respuesta = 1 Then
				If Tab_2.TabPage_5.dw_Items.DeleteRow(0) = 1 Then
					ib_borrar = False
					w_main.SetMicroHelp("Borrando Registro...")
					
					ll_fila = Tab_2.TabPage_5.dw_Items.GetRow()
					Tab_2.TabPage_5.dw_Items.SetRow(ll_fila)
					Tab_2.TabPage_5.dw_Items.SelectRow(ll_fila, True)		
				Else
					ib_borrar = False
					MessageBox(This.Title,"No se puede borrar actual registro.")
				End If
				
				If Tab_2.TabPage_5.dw_Items.RowCount() = 0 Then
					Habilitaencab(True)
					pb_eli_det.Enabled = False
				End If
			End If
			
	End Choose

SetPointer(Arrow!)
istr_mant.Borra	= False






			
	
end event

event ue_seleccion;call super::ue_seleccion;istr_busq.Argum[2] = gstr_us.Nombre

OpenWithParm(w_busc_equipos,istr_busq)

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

event ue_nuevo_detalle;call super::ue_nuevo_detalle;Byte lb_TabPage

If dw_2.Object.equi_estado[1] > 1 Then
	MessageBox('Error', 'Equipo no esta disponible para asignacion,', Information!, OK!)
	Return
End If

lb_TabPage	=	Tab_2.SelectedTab

istr_mant.Borra		= False
istr_mant.Agrega	= True

istr_mant.Argumento[1]	=	String(dw_2.Object.equi_codigo[1])

Choose Case lb_TabPage
		Case 1
			istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador
			
			OpenWithParm(iw_mantencion, istr_mant)

			If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
				pb_eliminar.Enabled	= True
				pb_grabar.Enabled	= True
			End If
			
			wf_CambiaEstado()
			
			dw_1.SetRow(il_fila)
			dw_1.SelectRow(il_fila,True)

		Case 2				
			istr_mant.dw						=	Tab_2.TabPage_5.dw_Items
			
			OpenWithParm(iw_mantencion2, istr_mant)
			
			If Tab_2.TabPage_5.dw_Items.RowCount() > 0 And Not pb_eliminar.Enabled Then
				pb_eliminar.Enabled	= True
				pb_grabar.Enabled	= True
			End If
			
			Tab_2.TabPage_5.dw_Items.SetRow(il_fila)
			Tab_2.TabPage_5.dw_Items.SelectRow(il_fila,True)
			
	End Choose

end event

event ue_nuevo;call super::ue_nuevo;HabilitaEncab(True)

pb_barcode.Enabled	= False

dw_2.Object.equi_estado[1] = 0
dw_2.Object.equi_propie[1] = 0

istr_Mant.Argumento[1]	=	''
istr_Mant.Argumento[2]	=	''

dw_2.SetColumn("equi_codigo")

Tab_2.TabPage_5.dw_Items.Reset()
end event

event ue_modifica_detalle;Byte lb_TabPage

lb_TabPage	=	Tab_2.SelectedTab

istr_mant.Argumento[1]	=	String(dw_2.Object.equi_codigo[1])

istr_mant.Agrega	= False
istr_mant.Borra		= False

Choose Case lb_TabPage
	Case 1
		If dw_1.RowCount() > 0 Then
			istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador

			OpenWithParm(iw_mantencion, istr_mant)
			
			wf_CambiaEstado()
		End If
		
	Case 2
		If Tab_2.TabPage_5.dw_Items.RowCount() > 0 Then
			istr_mant.dw						=	Tab_2.TabPage_5.dw_Items
			
			OpenWithParm(iw_mantencion2, istr_mant)
		End if			
End Choose
end event

event open;call super::open;//iuo_Imagenes	=	Create uo_doctos

istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador
istr_mant.dw2						=	Tab_2.TabPage_5.dw_Items

Tab_2.TabPage_4.dw_Colaborador.SetRowFocusIndicator(Hand!)
Tab_2.TabPage_5.dw_Items.SetRowFocusIndicator(Hand!)

dw_2.ShareData(tab_1.TabPage_1.dw_Equipos)
dw_2.ShareData(tab_1.TabPage_2.dw_Documentacion)
dw_2.ShareData(tab_1.TabPage_3.dw_Observacion)
dw_2.ShareData(tab_1.TabPage_6.dw_Datos)

dw_1.ShareData(Tab_2.TabPage_4.dw_Colaborador)
dw_1.ShareData(Tab_2.TabPage_5.dw_Items)

Tab_1.TabPage_1.dw_Equipos.SetTransObject(SQLCA)
Tab_1.TabPage_2.dw_Documentacion.SetTransObject(SQLCA)
Tab_1.TabPage_3.dw_Observacion.SetTransObject(SQLCA)

Tab_2.TabPage_4.dw_Colaborador.SetTransObject(SQLCA)
Tab_2.TabPage_5.dw_Items.SetTransObject(SQLCA)

Tab_1.TabPage_1.dw_Equipos.GetChild('mode_codigo', idwc_Modelo)
idwc_Modelo.SetTransObject(SQLCA)
idwc_Modelo.Retrieve(-1, -1)

dw_BarCode.SetTransObject(SQLCA)

iuo_Empresa	=	Create uo_Empresa	
iuo_Marca		=	Create uo_Marca
iuo_Proveedor	=	Create uo_Proveedor
iuo_Tipo			=	Create uo_TipoEquipos
iuo_Equipo		=	Create uo_Equipo
iuo_Leasing		=	Create uo_Proveedor
iuo_Imagenes	=	Create uo_imagenes
iuo_Modelo		=	Create uo_Modelo
iuo_Ubicacion	=	Create uo_Ubicacion

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
	If Not iuo_Tipo.Correlativo(iuo_Tipo.Actual+1, iuo_Tipo.Codigo, Sqlca) Then Return
	
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

event resize;Integer	maximo, li_posic_x, li_posic_y, li_visible = 0, &
			li_Ancho = 300, li_Alto = 245, li_Siguiente = 255

IF dw_2.width > il_AnchoDw_1 THEN
	maximo		=	dw_2.width
ELSE
	dw_1.width	=	This.WorkSpaceWidth() - 500
	maximo		=	dw_1.width
END IF

dw_2.x					=	37 + Round((maximo - dw_2.width) / 2, 0)
dw_2.y					=	37

dw_1.x					=	37 + Round((maximo - dw_1.width) / 2, 0)
dw_1.y					=	64 + dw_2.Height
dw_1.height				=	This.WorkSpaceHeight() - dw_1.y - 41

li_posic_x				=	This.WorkSpaceWidth() - 370
li_posic_y				=	78

IF pb_buscar.Visible THEN
	pb_buscar.x				=	li_posic_x
	pb_buscar.y				=	li_posic_y
	pb_buscar.width		=	li_Ancho
	pb_buscar.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_nuevo.Visible THEN
	pb_nuevo.x				=	li_posic_x
	pb_nuevo.y				=	li_posic_y
	pb_nuevo.width		=	li_Ancho
	pb_nuevo.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF	pb_eliminar.Visible THEN
	pb_eliminar.x			=	li_posic_x
	pb_eliminar.y			=	li_posic_y
	pb_eliminar.width		=	li_Ancho
	pb_eliminar.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_grabar.Visible THEN
	pb_grabar.x				=	li_posic_x
	pb_grabar.y				=	li_posic_y
	pb_grabar.width		=	li_Ancho
	pb_grabar.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_imprimir.Visible THEN
	pb_imprimir.x			=	li_posic_x
	pb_imprimir.y			=	li_posic_y
	pb_imprimir.width		=	li_Ancho
	pb_imprimir.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_BarCode.Visible THEN
	pb_BarCode.x			=	li_posic_x
	pb_BarCode.y			=	li_posic_y
	pb_BarCode.width		=	li_Ancho
	pb_BarCode.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

IF pb_salir.Visible THEN
	pb_salir.x				=	li_posic_x
	pb_salir.y				=	li_posic_y
	pb_salir.width			=	li_Ancho
	pb_salir.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
END IF

pb_eli_det.x				=	li_posic_x
pb_eli_det.y				=	dw_1.y + dw_1.Height - li_Siguiente
pb_eli_det.width		=	li_Ancho
pb_eli_det.height		=	li_Alto

pb_ins_det.x			=	li_posic_x
pb_ins_det.y			=	pb_eli_det.y - li_Siguiente - 10
pb_ins_det.width		=	li_Ancho
pb_ins_det.height		=	li_Alto

Tab_1.x			=	dw_2.x
Tab_1.y 			=	dw_2.y
Tab_1.Width	=	dw_2.Width
Tab_1.Height	=	dw_2.Height

Tab_2.x			=	dw_1.x
Tab_2.y 			=	dw_1.y
Tab_2.Width	=	dw_1.Width
Tab_2.Height	=	dw_1.Height

Tab_2.TabPage_4.dw_Colaborador.Width	=	Tab_2.Width - 70
Tab_2.TabPage_5.dw_Items.Width			=	Tab_2.Width - 70

Tab_2.TabPage_4.dw_Colaborador.Height	=	Tab_2.Height - 170
Tab_2.TabPage_5.dw_Items.Height			=	Tab_2.Height - 170


end event

event ue_borrar;IF dw_2.RowCount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar = True
w_main.SetMicroHelp("Validando la eliminación...")

Message.DoubleParm = 0

This.TriggerEvent ("ue_validaborrar")

IF Message.DoubleParm = -1 THEN RETURN

IF dw_1.RowCount() > 0 THEN dw_1.RowsMove(1,dw_1.RowCount(),Primary!,dw_1,1,Delete!)
IF Tab_2.TabPage_5.dw_Items.RowCount() > 0 THEN Tab_2.TabPage_5.dw_Items.RowsMove(1,Tab_2.TabPage_5.dw_Items.RowCount(),&
																										Primary!,Tab_2.TabPage_5.dw_Items,1,Delete!)
IF dw_2.DeleteRow(0) = 1 THEN
		ib_borrar = False
		w_main.SetMicroHelp("Borrando Registro...")
		IF wf_actualiza_db(True) THEN
			w_main.SetMicroHelp("Registro Borrado...")
			This.TriggerEvent("ue_nuevo")
			SetPointer(Arrow!)
		ELSE
			w_main.SetMicroHelp("Registro no Borrado...")
		END IF			
ELSE
	ib_borrar = False
	MessageBox(This.Title,"No se puede borrar actual registro.")
END IF
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_asignacionequipos
integer x = 96
integer y = 1332
integer width = 3771
integer height = 1036
integer taborder = 100
string title = "Documentos"
string dataobject = "dw_mues_equipoasignado"
end type

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_asignacionequipos
integer x = 82
integer y = 128
integer width = 2821
integer height = 1260
integer taborder = 10
string dataobject = "dw_mant_equipos"
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

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_asignacionequipos
integer x = 4059
integer y = 360
integer taborder = 30
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_asignacionequipos
integer x = 4059
integer y = 540
integer taborder = 40
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_asignacionequipos
integer x = 4059
integer y = 716
integer taborder = 50
boolean enabled = true
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_asignacionequipos
integer x = 4073
integer y = 904
integer taborder = 60
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_asignacionequipos
integer x = 4059
integer y = 1080
integer taborder = 90
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_asignacionequipos
integer x = 4073
integer y = 1372
integer taborder = 70
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_asignacionequipos
integer x = 4073
integer y = 1548
integer taborder = 80
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_asignacionequipos
integer x = 4064
integer y = 176
integer taborder = 20
end type

type tab_1 from tab within w_maed_asignacionequipos
integer x = 82
integer y = 28
integer width = 2821
integer height = 1296
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
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_6 tabpage_6
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_6=create tabpage_6
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_6,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_6)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2784
integer height = 1168
long backcolor = 16777215
string text = "Equipo"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "Custom064!"
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
integer width = 2592
integer height = 1024
integer taborder = 11
string dataobject = "dw_mant_equipos_equi"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case 'equi_codigo'
		istr_Mant.Argumento[1] = Data
		If iuo_Equipo.of_Existe(Long(Data), False, Sqlca) Then
			w_maed_asignacionequipos.TriggerEvent("ue_recuperadatos")
		End If
		
	Case 'empr_codigo'
		If Not iuo_Empresa.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'marc_codigo'
		If Not iuo_Marca.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		Else
			This.GetChild('mode_codigo', idwc_Modelo)
			idwc_Modelo.SetTransObject(SQLCA)
			idwc_Modelo.Retrieve(iuo_Marca.Codigo, iuo_Tipo.Codigo)
		End If
		
	Case 'prov_codigo'
		If Not iuo_Proveedor.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'mode_codigo'
		If Not iuo_Modelo.Existe(iuo_Marca.Codigo, iuo_Tipo.Codigo, Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		Else
			This.SetItem(Row, 'equi_modelo', iuo_Modelo.Nombre)
		End If
		
	Case	'ubic_codigo'
		If Not iuo_Ubicacion.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'tieq_codigo'
		If Not iuo_Tipo.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		Else
			If IsNull(This.Object.equi_nroint[Row]) Or This.Object.equi_nroint[Row] = '' Then
				This.Object.equi_nroint[Row] = wf_CodigoInterno(iuo_Tipo.Abreviacion, iuo_Tipo.Actual, String(This.Object.equi_fecadq[Row], 'yyyymm'))
			End If
			
			This.GetChild('mode_codigo', idwc_Modelo)
			idwc_Modelo.SetTransObject(SQLCA)
			idwc_Modelo.Retrieve(iuo_Marca.Codigo, iuo_Tipo.Codigo)
		End If
		
	Case 'equi_fecadq'
		If IsNull(This.Object.equi_nroint[Row]) Or This.Object.equi_nroint[Row] = '' Then
			This.Object.equi_nroint[Row] = wf_CodigoInterno(iuo_Tipo.Abreviacion, iuo_Tipo.Actual, Mid(Data, 1, 4) + Mid(Data, 6, 2))
		End If
		
End Choose

This.AcceptText()

HabilitaIngreso()


end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2784
integer height = 1168
long backcolor = 16777215
string text = "Identificación"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "Blob!"
long picturemaskcolor = 536870912
dw_datos dw_datos
end type

on tabpage_6.create
this.dw_datos=create dw_datos
this.Control[]={this.dw_datos}
end on

on tabpage_6.destroy
destroy(this.dw_datos)
end on

type dw_datos from uo_dw within tabpage_6
integer x = 50
integer y = 52
integer width = 2592
integer height = 1024
integer taborder = 40
string dataobject = "dw_mant_equipos_datos"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case 'equi_codigo'
		istr_Mant.Argumento[1] = Data
		If iuo_Equipo.of_Existe(Long(Data), False, Sqlca) Then
			w_maed_asignacionequipos.TriggerEvent("ue_recuperadatos")
		End If
		
	Case 'empr_codigo'
		If Not iuo_Empresa.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'marc_codigo'
		If Not iuo_Marca.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'prov_codigo'
		If Not iuo_Proveedor.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'tieq_codigo'
		If Not iuo_Tipo.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		Else
			This.Object.equi_nroint[Row] = wf_CodigoInterno(iuo_Tipo.Abreviacion, iuo_Tipo.Actual, String(This.Object.equi_fecadq[Row], 'yyyymm'))
		End If
		
	Case 'equi_fecadq'
		This.Object.equi_nroint[Row] = wf_CodigoInterno(iuo_Tipo.Abreviacion, iuo_Tipo.Actual, Mid(Data, 1, 4) + Mid(Data, 6, 2))
		
End Choose

HabilitaIngreso()


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2784
integer height = 1168
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
integer width = 2629
integer height = 1020
integer taborder = 11
string dataobject = "dw_mant_equipos_documentacion"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna		
	Case 'equi_leasin'
		If Not iuo_Leasing.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
End Choose

HabilitaIngreso()


end event

event buttonclicked;call super::buttonclicked;String		ls_Null, ls_Boton

SetNull(ls_Null)
ls_Boton = dwo.name

Choose  Case ls_Boton		
	Case 'b_carga_orden'
		wf_Carga('OC', Row)
	
	Case 'b_carga_guia'
		wf_Carga('GD', Row)
		
	Case 'b_carga_factura'
		wf_Carga('FA', Row)
		
	Case 'b_vis_orden'
		wf_MuestraArchivo(This, Row, 'OC')
		
	Case 'b_vis_guia'
		wf_MuestraArchivo(This, Row, 'GD')
		
	Case 'b_vis_factura'
		wf_MuestraArchivo(This, Row, 'FA')
		
End Choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2784
integer height = 1168
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
integer width = 2560
integer height = 1020
integer taborder = 11
string dataobject = "dw_mant_equipos_observacion"
boolean vscrollbar = false
boolean border = false
end type

type tab_2 from tab within w_maed_asignacionequipos
integer x = 91
integer y = 1340
integer width = 3854
integer height = 1228
integer taborder = 70
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
integer selectedtab = 1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_2.create
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_4,&
this.tabpage_5}
end on

on tab_2.destroy
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_4 from userobject within tab_2
integer x = 18
integer y = 112
integer width = 3817
integer height = 1100
long backcolor = 16777215
string text = "Colaboradores"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "Run!"
long picturemaskcolor = 536870912
dw_colaborador dw_colaborador
end type

on tabpage_4.create
this.dw_colaborador=create dw_colaborador
this.Control[]={this.dw_colaborador}
end on

on tabpage_4.destroy
destroy(this.dw_colaborador)
end on

type dw_colaborador from uo_dw within tabpage_4
integer x = 18
integer y = 12
integer width = 3771
integer height = 1036
integer taborder = 11
string dataobject = "dw_mues_equipoasignado"
end type

event clicked;call super::clicked;IF Row > 0 THEN
	il_fila = Row
	This.SelectRow(0,False)
	This.SetRow(il_fila)
	This.SelectRow(il_fila,True)
END IF

RETURN 0
end event

event doubleclicked;call super::doubleclicked;w_maed_asignacionequipos.TriggerEvent("ue_modifica_detalle")

RETURN 0
end event

type tabpage_5 from userobject within tab_2
integer x = 18
integer y = 112
integer width = 3817
integer height = 1100
long backcolor = 553648127
string text = "Items"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
dw_items dw_items
end type

on tabpage_5.create
this.dw_items=create dw_items
this.Control[]={this.dw_items}
end on

on tabpage_5.destroy
destroy(this.dw_items)
end on

type dw_items from uo_dw within tabpage_5
integer x = 18
integer y = 12
integer width = 3771
integer height = 1036
integer taborder = 11
string dataobject = "dw_mues_equipoitem"
end type

event clicked;call super::clicked;IF Row > 0 THEN
	il_fila = Row
	This.SelectRow(0,False)
	This.SetRow(il_fila)
	This.SelectRow(il_fila,True)
END IF

RETURN 0
end event

event doubleclicked;call super::doubleclicked;w_maed_asignacionequipos.TriggerEvent("ue_modifica_detalle")

RETURN 0
end event

type pb_barcode from picturebutton within w_maed_asignacionequipos
string tag = "Emite Codigo Barras Equipo"
integer x = 3712
integer y = 1036
integer width = 302
integer height = 244
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\BarCode.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\BarCode-bn.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Imprime Codigo Barras"
end type

event clicked;Long	ll_Respuesta

ll_Respuesta = MessageBox('Atencion', 'Se imprimira directo Codigo de Barra. Verificar Impresora.', Information!, YesNo!, 2)

If ll_Respuesta = 2 Then 
	Return
Else
	dw_BarCode.Object.ole_codigo.Object.Text 	= 	dw_2.Object.equi_nroint[1]
	dw_BarCode.Object.Codigo[1]						= 	dw_2.Object.equi_codigo[1]
		
	dw_BarCode.AcceptText()
	dw_BarCode.Print()
	dw_BarCode.Reset()
	dw_barcode.Visible = False
End If
end event

type dw_barcode from uo_dw within w_maed_asignacionequipos
boolean visible = false
integer x = 3616
integer y = 396
integer width = 302
integer height = 180
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_info_nroserie"
boolean vscrollbar = false
end type

