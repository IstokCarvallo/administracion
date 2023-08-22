$PBExportHeader$w_maed_ordentrabajo.srw
forward
global type w_maed_ordentrabajo from w_mant_encab_deta
end type
type tab_1 from tab within w_maed_ordentrabajo
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
type tab_1 from tab within w_maed_ordentrabajo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type tab_2 from tab within w_maed_ordentrabajo
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
type pb_carga from picturebutton within tabpage_5
end type
type dw_items from uo_dw within tabpage_5
end type
type tabpage_5 from userobject within tab_2
pb_carga pb_carga
dw_items dw_items
end type
type tab_2 from tab within w_maed_ordentrabajo
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
end forward

global type w_maed_ordentrabajo from w_mant_encab_deta
integer width = 3726
integer height = 2728
string title = "Maestro Ordenes de Trabajo"
string menuname = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_imprimir ( )
tab_1 tab_1
tab_2 tab_2
end type
global w_maed_ordentrabajo w_maed_ordentrabajo

type variables
w_mant_deta_ordentrabajoservicios	iw_mantencion
w_mant_deta_ordentrabajoequipos	iw_mantencion2

DataWindowChild	idwc_Responsable, idwc_Ejecutante


String	is_Ruta

uo_Proveedor		iuo_Proveedor
uo_Monedas		iuo_Moneda
uo_Personal			iuo_Responsable
uo_Personal			iuo_Ejecutante
uo_imagenes		iuo_Imagenes
uo_OrdenTrabajo	iuo_Orden
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

Long		fila
str_info	lstr_info
Datetime	ld_Desde, ld_Hasta

lstr_info.titulo	= "MAESTRO DE ORDENES DE TRABAJO"
lstr_info.copias	= 1

ld_Desde	=	DateTime(Date('19000101'), Time('00:00:00'))
ld_Hasta	=	DateTime(Today(), Time('23:59:59'))

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_ordentrabajo"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(Integer(istr_mant.argumento[1]), -1, -1, -1, ld_Desde, ld_Hasta)

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
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.Protect	= 0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.Protect	= 0
	
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.BackGround.Color	=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.BackGround.Color		=  RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.BackGround.Color	=  RGB(255,255,255)
	
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.Color	=  0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.Color		=	0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.Color		=  0
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.Color	=  0
Else
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.Protect	= 1
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.Protect	= 1
	
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.BackGround.Color=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.BackGround.Color	=	553648127
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.BackGround.Color	=  553648127
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.BackGround.Color=  553648127
	
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_codigo.Color		=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.mone_codigo.Color	=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.Color	=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_tipord.Color		=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_fecord.Color		=	0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_respon.Color		=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_ejecut.Color		=  0 //RGB(255,255,255)
	Tab_1.TabPage_1.dw_Equipos.Object.ortr_montov.Color	=  0 //RGB(255,255,255)
	
End If

Return
end subroutine

public subroutine habilitaingreso ();Boolean	lb_habilita = True

dw_2.AcceptText()

If IsNull(dw_2.Object.ortr_codigo[1]) Or dw_2.Object.ortr_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.mone_codigo[1]) Or dw_2.Object.mone_codigo[1] = 0 Then
	lb_habilita = False
ElseIf IsNull(dw_2.Object.ortr_fecord[1]) Then
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
	If Not IsNull(dw_2.Object.ortr_pathoc[1]) Then iuo_Imagenes.GrabaImagenOT(dw_2, 1, Sqlca, 'OC'+dw_2.Object.ortr_pathoc[1])
	If Not IsNull(dw_2.Object.ortr_pathot[1]) Then iuo_Imagenes.GrabaImagenOT(dw_2, 1, Sqlca, 'OT'+dw_2.Object.ortr_pathot[1])
	If Not IsNull(dw_2.Object.ortr_pathfa[1]) Then	 iuo_Imagenes.GrabaImagenOT(dw_2, 1, Sqlca, 'FA'+dw_2.Object.ortr_pathfa[1])
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
			ls_Columna = 'ortr_pathoc'
			
		Case 'OT'
			ls_Columna = 'ortr_pathot'
			
		Case 'FA'
			ls_Columna = 'ortr_pathfa'
			
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
		ls_Archivo	=	adw.Object.ortr_pathoc[Row]
		
	Case 'OT'
		ls_Archivo	=	adw.Object.ortr_pathgd[Row]
		
	Case 'FA'
		ls_Archivo	=	adw.Object.ortr_pathfa[Row]
End Choose

If FileExists(ls_Archivo) Then 
	iuo_Imagenes.AbrirDocumento(ls_Archivo)
Else
	iuo_Imagenes.RecuperaImagenOT(adw, Row, Sqlca, Tipo)
End If

Return
end subroutine

on w_maed_ordentrabajo.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.tab_2=create tab_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.tab_2
end on

on w_maed_ordentrabajo.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.tab_2)
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
			ll_fila_d	= Tab_2.TabPage_5.dw_Items.Retrieve(Long(istr_Mant.Argumento[1])) 
			
			If ll_fila_d = -1 Then
				respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
			Else
				pb_eliminar.Enabled 	= True
				pb_grabar.Enabled	= True
				pb_ins_det.Enabled	= True
				pb_imprimir.Enabled	= True
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

istr_mant.Argumento[1]	=	String(dw_2.Object.ortr_codigo[1])

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

OpenWithParm(w_busc_ordentrabajo,istr_busq)

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

lb_TabPage	=	Tab_2.SelectedTab

istr_mant.Borra		= False
istr_mant.Agrega	= True

istr_mant.Argumento[1]	=	String(dw_2.Object.ortr_codigo[1])

Choose Case lb_TabPage
		Case 1
			istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador
			
			OpenWithParm(iw_mantencion, istr_mant)

			If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
				pb_eliminar.Enabled	= True
				pb_grabar.Enabled	= True
			End If
			
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
	
//dw_2.Object.usua_codigo[1] 	=	gstr_us.Nombre
//dw_2.Object.smen_usuari[1]	=	gstr_us.Nombre
//dw_2.Object.smen_fechad[1]	=	Today()

dw_2.Object.ortr_estado[1]						= 1
dw_2.Object.ortr_tipord[1]						= 0
Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.Protect 				= 1
Tab_1.TabPage_1.dw_Equipos.Object.prov_codigo.BackGround.Color	= 553648127

istr_Mant.Argumento[1]	=	''
istr_Mant.Argumento[2]	=	''

dw_2.SetColumn("ortr_codigo")

Tab_2.TabPage_5.dw_Items.Reset()
end event

event ue_modifica_detalle;Byte lb_TabPage

lb_TabPage	=	Tab_2.SelectedTab

istr_mant.Argumento[1]	=	String(dw_2.Object.ortr_codigo[1])

istr_mant.Agrega	= False
istr_mant.Borra		= False

Choose Case lb_TabPage
	Case 1
		If dw_1.RowCount() > 0 Then
			istr_mant.dw						=	Tab_2.TabPage_4.dw_Colaborador

			OpenWithParm(iw_mantencion, istr_mant)
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

dw_1.ShareData(Tab_2.TabPage_4.dw_Colaborador)
dw_1.ShareData(Tab_2.TabPage_5.dw_Items)

Tab_1.TabPage_1.dw_Equipos.SetTransObject(SQLCA)
Tab_1.TabPage_2.dw_Documentacion.SetTransObject(SQLCA)
Tab_1.TabPage_3.dw_Observacion.SetTransObject(SQLCA)

Tab_2.TabPage_4.dw_Colaborador.SetTransObject(SQLCA)
Tab_2.TabPage_5.dw_Items.SetTransObject(SQLCA)

Tab_1.TabPage_1.dw_Equipos.GetChild('ortr_respon', idwc_Responsable)
idwc_Responsable.SetTransObject(Sqlca)
idwc_Responsable.Retrieve(1)

Tab_1.TabPage_1.dw_Equipos.GetChild('ortr_ejecut', idwc_Ejecutante)
idwc_Ejecutante.SetTransObject(Sqlca)
idwc_Ejecutante.Retrieve(1)

iuo_Proveedor		=	Create uo_Proveedor
iuo_Moneda			=	Create uo_Monedas
iuo_Responsable	=	Create uo_Personal
iuo_Ejecutante		=	Create uo_Personal
iuo_Imagenes		=	Create uo_imagenes
iuo_Orden			=	Create uo_OrdenTRabajo

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

event resize;call super::resize;
Tab_1.x			=	dw_2.x
Tab_1.y 			=	dw_2.y
Tab_1.Width	=	dw_2.Width
Tab_1.Height	=	dw_2.Height

Tab_2.x			=	dw_1.x
Tab_2.y 			=	dw_1.y
Tab_2.Width	=	dw_1.Width
Tab_2.Height	=	dw_1.Height

Tab_2.TabPage_4.dw_Colaborador.Width	=	Tab_2.Width - 70
Tab_2.TabPage_5.dw_Items.Width			=	Tab_2.Width - 70 - (Tab_2.TabPage_5.pb_carga.Width + 50)

Tab_2.TabPage_4.dw_Colaborador.Height	=	Tab_2.Height - 170
Tab_2.TabPage_5.dw_Items.Height			=	Tab_2.Height - 170

Tab_2.TabPage_5.pb_carga.x	=	Tab_2.TabPage_5.dw_Items.Width + 60

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

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_ordentrabajo
boolean visible = false
integer x = 110
integer y = 1152
integer width = 2976
integer height = 1036
integer taborder = 100
boolean titlebar = false
string title = "Documentos"
string dataobject = "dw_mues_ordentrabajoservicio"
end type

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_ordentrabajo
integer x = 82
integer y = 36
integer width = 2322
integer height = 1136
integer taborder = 10
string dataobject = "dw_mant_ordentrabajo"
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

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_ordentrabajo
integer x = 3278
integer y = 352
integer taborder = 30
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_ordentrabajo
integer x = 3278
integer y = 532
integer taborder = 40
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_ordentrabajo
integer x = 3278
integer y = 708
integer taborder = 50
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_ordentrabajo
integer x = 3291
integer y = 896
integer taborder = 60
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_ordentrabajo
integer x = 3278
integer y = 1072
integer taborder = 90
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_ordentrabajo
integer x = 3291
integer y = 1364
integer taborder = 70
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_ordentrabajo
integer x = 3291
integer y = 1540
integer taborder = 80
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_ordentrabajo
integer x = 3282
integer y = 168
integer taborder = 20
end type

type tab_1 from tab within w_maed_ordentrabajo
integer x = 91
integer y = 32
integer width = 2322
integer height = 1100
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
integer y = 116
integer width = 2286
integer height = 968
long backcolor = 16777215
string text = "Orden Trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
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
integer width = 2126
integer height = 840
integer taborder = 11
string dataobject = "dw_mant_ordentrabajo_ot"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case 'ortr_codigo'
		istr_Mant.Argumento[1] = Data
		If iuo_Orden.Existe(Long(Data), False, Sqlca) Then
			w_maed_ordentrabajo.TriggerEvent("ue_recuperadatos")
		End If

	Case 'mone_codigo'
		If Not iuo_Moneda.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
			
	Case 'prov_codigo'
		If Not iuo_Proveedor.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
	Case 'ortr_ejecut'
		If Not iuo_Ejecutante.Existe(Data, True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, ls_Null)
			Return -1
		End If
			
	Case 'ortr_respon'
		If Not iuo_Responsable.Existe(Data, True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, ls_Null)
			Return -1
		End If
		
	Case 'ortr_tipord'
		If Data = '0' Then
			This.Object.prov_codigo[Row]					=	Integer(ls_Null)
			This.Object.prov_codigo.Protect 				= 1
			This.Object.prov_codigo.BackGround.Color	= 553648127
		Else
			This.Object.prov_codigo.Protect 				= 0
			This.Object.prov_codigo.BackGround.Color	= Rgb(255,255,255)
		End If
		
End Choose

HabilitaIngreso()
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 2286
integer height = 968
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
integer width = 2171
integer height = 872
integer taborder = 11
string dataobject = "dw_mant_ordentrabajo_documentacion"
boolean vscrollbar = false
boolean border = false
end type

event buttonclicked;call super::buttonclicked;String		ls_Null, ls_Boton

SetNull(ls_Null)
ls_Boton = dwo.name

Choose  Case ls_Boton		
	Case 'b_carga_orden'
		wf_Carga('OC', Row)
	
	Case 'b_carga_ot'
		wf_Carga('OT', Row)
		
	Case 'b_carga_factura'
		wf_Carga('FA', Row)
		
	Case 'b_vis_orden'
		wf_MuestraArchivo(This, Row, 'OC')
		
	Case 'b_vis_ot'
		wf_MuestraArchivo(This, Row, 'OT')
		
	Case 'b_vis_factura'
		wf_MuestraArchivo(This, Row, 'FA')
		
End Choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 2286
integer height = 968
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
integer width = 2176
integer height = 880
integer taborder = 11
string dataobject = "dw_mant_ordentrabajo_observacion"
boolean vscrollbar = false
boolean border = false
end type

type tab_2 from tab within w_maed_ordentrabajo
integer x = 110
integer y = 1184
integer width = 2949
integer height = 1188
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
integer y = 116
integer width = 2912
integer height = 1056
long backcolor = 16777215
string text = "Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
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
integer width = 2802
integer height = 1036
integer taborder = 11
string dataobject = "dw_mues_ordentrabajoservicio"
end type

event clicked;call super::clicked;IF Row > 0 THEN
	il_fila = Row
	This.SelectRow(0,False)
	This.SetRow(il_fila)
	This.SelectRow(il_fila,True)
END IF

RETURN 0
end event

event itemchanged;call super::itemchanged;String  ls_columna, ls_Null

SetNull(ls_Null)

ls_columna = dwo.Name

Choose Case ls_columna		
	Case 'orde_estado'
		If data = '1' Then 
			This.SetItem(Row, 'orde_feejre', Today())
		Else
			This.SetItem(Row, 'orde_feejre', DateTime(ls_Null))
		End If
		
End Choose
end event

event doubleclicked;call super::doubleclicked;w_maed_ordentrabajo.TriggerEvent("ue_modifica_detalle")

RETURN 0
end event

type tabpage_5 from userobject within tab_2
integer x = 18
integer y = 116
integer width = 2912
integer height = 1056
long backcolor = 16777215
string text = "Equipos Computacionales"
long tabtextcolor = 33554432
long tabbackcolor = 30586022
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
pb_carga pb_carga
dw_items dw_items
end type

on tabpage_5.create
this.pb_carga=create pb_carga
this.dw_items=create dw_items
this.Control[]={this.pb_carga,&
this.dw_items}
end on

on tabpage_5.destroy
destroy(this.pb_carga)
destroy(this.dw_items)
end on

type pb_carga from picturebutton within tabpage_5
integer x = 2670
integer y = 68
integer width = 233
integer height = 196
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "ArrangeTables!"
alignment htextalign = left!
end type

event clicked;MessageBox('Atencion', 'En Construccion.', Exclamation!, OK!)


end event

type dw_items from uo_dw within tabpage_5
integer x = 18
integer y = 12
integer width = 2619
integer height = 1036
integer taborder = 11
string dataobject = "dw_mues_ordentrabajoequipo"
end type

event clicked;call super::clicked;IF Row > 0 THEN
	il_fila = Row
	This.SelectRow(0,False)
	This.SetRow(il_fila)
	This.SelectRow(il_fila,True)
END IF

RETURN 0
end event

event doubleclicked;call super::doubleclicked;w_maed_ordentrabajo.TriggerEvent("ue_modifica_detalle")

RETURN 0
end event

