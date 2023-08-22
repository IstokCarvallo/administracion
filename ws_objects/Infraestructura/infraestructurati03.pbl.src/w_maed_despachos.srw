$PBExportHeader$w_maed_despachos.srw
forward
global type w_maed_despachos from w_mant_encab_deta
end type
type pb_guia from picturebutton within w_maed_despachos
end type
type st_1 from statictext within w_maed_despachos
end type
type em_serie from editmask within w_maed_despachos
end type
type pb_cierre from picturebutton within w_maed_despachos
end type
end forward

global type w_maed_despachos from w_mant_encab_deta
integer width = 4370
integer height = 2728
string title = "Movimientos de Despachos Equipos"
string menuname = ""
windowstate windowstate = maximized!
event ue_imprimir ( )
pb_guia pb_guia
st_1 st_1
em_serie em_serie
pb_cierre pb_cierre
end type
global w_maed_despachos w_maed_despachos

type variables
String	is_Rut

w_mant_deta_movimientos	iw_mantencion

DataWindowChild	idwc_TipoMovto

uo_TipoMovto		iuo_Tipo
uo_Sucursal			iuo_Origen
uo_Sucursal			iuo_Sucursal
uo_Proveedor		iuo_Proveedor
uo_MovtoEquipo	iuo_Movimiento

uo_Equipo			iuo_Equipos
uo_Marca			iuo_Marca
uo_TipoEquipos	iuo_TipoEquipo
uo_Modelo			iuo_Modelo
uo_GuiaDespacho	iuo_Guia
end variables

forward prototypes
public subroutine habilitaencab (boolean habilita)
public subroutine habilitaingreso ()
protected function boolean wf_actualiza_db (boolean borrando)
public subroutine wf_validatipo (integer ai_tipo)
public subroutine wf_cargadespacho ()
public subroutine wf_cargaequipo (string as_serie, integer ai_recibido, ref datawindow adw)
public subroutine wf_cargaequipo (long al_serie, integer ai_recibido, ref datawindow adw)
public subroutine wf_creaequipos ()
end prototypes

event ue_imprimir;SetPointer(HourGlass!)

Long		fila

str_info	lstr_info
lstr_info.titulo	= "MOVIMIENTOS EQUIPOS COMPUTACIONALES"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)
vinf.dw_1.DataObject = "dw_info_movimiento"
vinf.dw_1.SetTransObject(sqlca)
fila = vinf.dw_1.Retrieve(Long(istr_Mant.Argumento[1]), dw_2.Object.tpmv_codigo[1], dw_2.Object.meec_sucori[1], &
										dw_2.Object.meec_fecham[1], dw_2.Object.meec_fecham[1])

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No Existe información para este informe.", StopSign!, OK!)
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')
END IF

SetPointer(Arrow!)
					
end event

public subroutine habilitaencab (boolean habilita);If Habilita Then
	dw_2.Object.tpmv_codigo.Protect		= 0
	dw_2.Object.meec_numero.Protect	= 0
	dw_2.Object.meec_fecham.Protect	= 0
	dw_2.Object.meec_sucori.Protect		= 0
	
//	dw_2.Object.tpmv_codigo.BackGround.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_numero.BackGround.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_fecham.BackGround.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_sucori.BackGround.Color	=  RGB(255,255,255)
//	
//	dw_2.Object.tpmv_codigo.Color	=  0
//	dw_2.Object.meec_numero.Color	=  0
//	dw_2.Object.meec_fecham.Color	=  0
//	dw_2.Object.meec_sucori.Color	=  0
	
Else
	dw_2.Object.tpmv_codigo.Protect		= 1
	dw_2.Object.meec_numero.Protect	= 1
	dw_2.Object.meec_fecham.Protect	= 1
	dw_2.Object.meec_sucori.Protect		= 1
	
//	dw_2.Object.tpmv_codigo.BackGround.Color	=  553648127
//	dw_2.Object.meec_numero.BackGround.Color	=  553648127
//	dw_2.Object.meec_fecham.BackGround.Color	=  553648127
//	dw_2.Object.meec_sucori.BackGround.Color	=  553648127
//	
//	dw_2.Object.tpmv_codigo.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_numero.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_fecham.Color	=  RGB(255,255,255)
//	dw_2.Object.meec_sucori.Color	=  RGB(255,255,255)
End If

Return
end subroutine

public subroutine habilitaingreso ();Boolean	lb_habilita = True

dw_2.AcceptText()

If IsNull(dw_2.Object.tpmv_codigo[1]) Or dw_2.Object.tpmv_codigo[1] = 0 Or &
	IsNull(dw_2.Object.meec_sucori[1]) Or dw_2.Object.meec_sucori[1] = 0 Or &
	IsNull(dw_2.Object.meec_chofer[1]) Or dw_2.Object.meec_chofer[1] = '' Or &
	IsNull(dw_2.Object.meec_rutcho[1]) Or dw_2.Object.meec_rutcho[1] = '' Or &
	IsNull(dw_2.Object.meec_celcho[1]) Or dw_2.Object.meec_celcho[1] = '' Or &
	IsNull(dw_2.Object.meec_patent[1]) Or dw_2.Object.meec_patent[1] = '' Or &
	IsNull(dw_2.Object.meec_observ[1]) Or dw_2.Object.meec_observ[1] = ''  Then
	lb_habilita = False
End If

pb_ins_det.Enabled	=	lb_habilita
//em_serie.Enabled		=	lb_habilita

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

public subroutine wf_validatipo (integer ai_tipo);String	ls_Null

SetNull(ls_Null)

If iuo_Tipo.Existe(ai_Tipo, True, SQLCA) Then
	If iuo_Tipo.Sentido = 2 Then
		dw_2.Object.b_carga.Visible				=	False
		pb_cierre.Enabled								=	False
		If iuo_Tipo.EmiteGuia = 1 Then
			dw_2.Object.meec_guiemi.Visible		=	True
			pb_guia.Enabled							=	True
			dw_2.Object.meec_guides.Protect 	=	1
		Else
			dw_2.Object.meec_guiemi.Visible		=	False
			pb_guia.Enabled							=	False
		End If
	Else
		If iuo_Tipo.CreaEquipo = 1 Then  
			dw_2.Object.b_carga.Text	=	'Crea Equipos Nuevos'
			dw_2.Object.b_carga.Visible=	False
		Else
			dw_2.Object.b_carga.Visible			=	True
		End If
		pb_cierre.Enabled							=	True
		pb_guia.Enabled							=	False
		dw_2.Object.meec_guiemi.Visible		=	False
		dw_2.Object.meec_guides.Protect 	=	0
	End If

	If iuo_Tipo.SolicitaDestino = 0 Then
		dw_2.Object.prov_codigo.Protect	= 1
		dw_2.Object.sucu_codigo.Protect	= 1
		dw_2.Object.prov_codigo.Visible	= False
		dw_2.Object.sucu_codigo.Visible	= False
		dw_2.Object.prov_codigo_t.Text	=	''
		dw_2.SetItem(1, "sucu_codigo", Integer(ls_Null))
		dw_2.SetItem(1, "prov_codigo", Integer(ls_Null))
	ElseIf iuo_Tipo.SolicitaDestino = 1 Then
		dw_2.Object.prov_codigo.Protect	= 1
		dw_2.Object.sucu_codigo.Protect	= 0
		dw_2.Object.prov_codigo.Visible	= False
		dw_2.Object.sucu_codigo.Visible	= True
		dw_2.Object.prov_codigo_t.Text	=	'Sucursal'
		dw_2.SetItem(1, "prov_codigo", Integer(ls_Null))
	ElseIf iuo_Tipo.SolicitaDestino = 2 Then
		dw_2.Object.prov_codigo.Protect	= 0
		dw_2.Object.sucu_codigo.Protect	= 1
		dw_2.Object.prov_codigo.Visible	= True
		dw_2.Object.sucu_codigo.Visible	= False
		dw_2.Object.prov_codigo_t.Text	=	'Proveedor'
		dw_2.SetItem(1, "sucu_codigo", Integer(ls_Null))
	End If
End If
end subroutine

public subroutine wf_cargadespacho ();str_Busqueda		lstr_Busq
uo_MovtoEquipo	luo_Despacho
DataStore			lds_Despacho
Long					ll_Fila, ll_New

luo_Despacho		=	Create uo_MovtoEquipo
lds_Despacho		=	Create DataStore

lds_Despacho.DataObject = 'dw_mues_movimientodeta'
lds_Despacho.SetTransObject(SQLCA)

lstr_Busq	.Argum[1] = '2'

OpenWithParm(w_busc_movimientos,lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.Argum) >= 2 Then
	If luo_Despacho.of_Existe(Long(lstr_Busq.Argum[1]), False, SQLCA) Then
		dw_2.Object.meec_desori[1] = luo_Despacho.Numero
		dw_2.Object.meec_rutcho[1] = luo_Despacho.RutChofer
		dw_2.Object.meec_chofer[1] = luo_Despacho.Chofer
		dw_2.Object.meec_celcho[1] = luo_Despacho.CelularChofer
		dw_2.Object.meec_patent[1] = luo_Despacho.Patente
		dw_2.Object.meec_guides[1] = luo_Despacho.Guia
		dw_2.Object.meec_sucori[1] = luo_Despacho.Sucursal
		
		If lds_Despacho.Retrieve(luo_Despacho.Numero) > 0 Then
			For ll_Fila = 1 To lds_Despacho.RowCount()
				If lds_Despacho.Object.meed_recibi[ll_Fila] = 0 Then
					If iuo_Equipos.of_ExisteParaTraslado(lds_Despacho.Object.equi_codigo[ll_Fila], False, SQLCA) Then
						iuo_Marca.Existe(iuo_Equipos.Marca, False, SQLCA)
						iuo_Modelo.Existe(iuo_Equipos.Marca, iuo_Equipos.TipoEquipo, iuo_Equipos.CodigoModelo, False, SQLCA)
						iuo_Tipo.Existe(iuo_Equipos.TipoEquipo, False, SQLCA)
						
						ll_New	=  dw_1.InsertRow(0)
						
						dw_1.Object.equi_codigo[ll_New]		=	iuo_Equipos.Codigo
						dw_1.Object.equi_nroser[ll_New]		=	iuo_Equipos.Serie
						dw_1.Object.equi_nroint[ll_New]		=	iuo_Equipos.NroInterno
						dw_1.Object.equi_modelo[ll_New]		=	iuo_Equipos.Modelo
						dw_1.Object.mode_nombre[ll_New]	=	iuo_Modelo.Nombre
						dw_1.Object.marc_nombre[ll_New]	=	iuo_Marca.Nombre
						dw_1.Object.tieq_nombre[ll_New]		=	iuo_Tipo.Nombre
						dw_1.Object.meed_recibi[ll_New]		=	0
					Else
						Messagebox('Atencion', 'Equipo Codigo: ' + String(lds_Despacho.Object.equi_codigo[ll_Fila], '0000') + &
									', Serie: ' + lds_Despacho.Object.equi_nroser[ll_Fila] + ' para traslado.', StopSign!, OK!)
//						Return
					End If
				End If
			Next
		End If
	End If
End If

Destroy lds_Despacho
Destroy luo_Despacho

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled 	= True
	pb_grabar.Enabled	= True
	pb_ins_det.Enabled	= True
	pb_imprimir.Enabled	= True
//	em_Serie.Enabled		= True
	pb_eli_det.Enabled	= True
End If

Return
end subroutine

public subroutine wf_cargaequipo (string as_serie, integer ai_recibido, ref datawindow adw);Long	ll_New

If iuo_Equipos.of_ExisteParaDespacho(as_Serie, True, SQLCA) Then
	iuo_Marca.Existe(iuo_Equipos.Marca, False, SQLCA)
	iuo_Modelo.Existe(iuo_Equipos.Marca, iuo_Equipos.TipoEquipo, iuo_Equipos.CodigoModelo, False, SQLCA)
	iuo_Tipo.Existe(iuo_Equipos.TipoEquipo, False, SQLCA)
	
	ll_New	=  adw.InsertRow(0)
	
	adw.Object.equi_codigo[ll_New]		=	iuo_Equipos.Codigo
	adw.Object.equi_nroser[ll_New]		=	iuo_Equipos.Serie
	adw.Object.equi_nroint[ll_New]		=	iuo_Equipos.NroInterno
	adw.Object.equi_modelo[ll_New]		=	iuo_Equipos.Modelo
	adw.Object.mode_nombre[ll_New]	=	iuo_Modelo.Nombre
	adw.Object.marc_nombre[ll_New]		=	iuo_Marca.Nombre
	adw.Object.tieq_nombre[ll_New]		=	iuo_Tipo.Nombre
	adw.Object.meed_recibi[ll_New] 		=	ai_Recibido
End If	

dw_1.SetRow(ll_New)
dw_1.SelectRow(ll_New,True)

Return
end subroutine

public subroutine wf_cargaequipo (long al_serie, integer ai_recibido, ref datawindow adw);Long	ll_New

If iuo_Equipos.of_ExisteParaDespacho(al_Serie, True, SQLCA)  Then
	iuo_Marca.Existe(iuo_Equipos.Marca, False, SQLCA)
	iuo_Modelo.Existe(iuo_Equipos.Marca, iuo_Equipos.TipoEquipo, iuo_Equipos.CodigoModelo, False, SQLCA)
	iuo_Tipo.Existe(iuo_Equipos.TipoEquipo, False, SQLCA)
	
	ll_New	=  adw.InsertRow(0)
	
	adw.Object.equi_codigo[ll_New]		=	iuo_Equipos.Codigo
	adw.Object.equi_nroser[ll_New]		=	iuo_Equipos.Serie
	adw.Object.equi_nroint[ll_New]		=	iuo_Equipos.NroInterno
	adw.Object.equi_modelo[ll_New]		=	iuo_Equipos.Modelo
	adw.Object.mode_nombre[ll_New]	=	iuo_Modelo.Nombre
	adw.Object.marc_nombre[ll_New]		=	iuo_Marca.Nombre
	adw.Object.tieq_nombre[ll_New]		=	iuo_Tipo.Nombre
	adw.Object.meed_recibi[ll_New] 		=	ai_Recibido
End If	

dw_1.SetRow(ll_New)
dw_1.SelectRow(ll_New,True)

Return
end subroutine

public subroutine wf_creaequipos ();
OpenWithParm(w_mant_deta_cargaequipos, istr_Mant)

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled 	= True
	pb_grabar.Enabled	= True
	pb_ins_det.Enabled	= True
	pb_imprimir.Enabled	= True
	em_Serie.Enabled		= True
	pb_eli_det.Enabled	= True
End If

Return

end subroutine

on w_maed_despachos.create
int iCurrent
call super::create
this.pb_guia=create pb_guia
this.st_1=create st_1
this.em_serie=create em_serie
this.pb_cierre=create pb_cierre
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_guia
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_serie
this.Control[iCurrent+4]=this.pb_cierre
end on

on w_maed_despachos.destroy
call super::destroy
destroy(this.pb_guia)
destroy(this.st_1)
destroy(this.em_serie)
destroy(this.pb_cierre)
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
			wf_ValidaTipo(dw_2.Object.tpmv_codigo[1]) 
			ll_fila_d	= dw_1.Retrieve(Long(istr_Mant.Argumento[1])) 
			
			If ll_fila_d = -1 Then
				respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", Information!, RetryCancel!)
			Else
				pb_eliminar.Enabled 				= True
				pb_grabar.Enabled				= True
				pb_ins_det.Enabled				= True
				pb_imprimir.Enabled				= True
				em_Serie.Enabled					= True
				
				If ll_fila_d > 0 Then
					pb_eli_det.Enabled	= True
					dw_1.SetRow(1)
					dw_1.SelectRow(1,True)
					dw_1.SetFocus()
					
					if dw_2.Object.meec_estado[1] = 1 Then
						pb_eliminar.Enabled 	= False
						pb_ins_det.Enabled	= False
						pb_eli_det.Enabled	= False
						dw_2.Enabled 			= False
					End If					
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

event ue_seleccion;call super::ue_seleccion;str_Busqueda	lstr_Busq

OpenWithParm(w_busc_movimientos,lstr_Busq)

lstr_Busq	= Message.PowerObjectParm

If UpperBound(lstr_Busq.argum) >= 1 Then
	If lstr_Busq.argum[1] <> "" Then
		istr_Mant.Argumento[1]	=	lstr_Busq.Argum[1]
		This.TriggerEvent("ue_recuperadatos")
	Else
		pb_buscar.SetFocus()
	End If 
End If
end event

event ue_nuevo_detalle;call super::ue_nuevo_detalle;istr_mant.Borra		= False
istr_mant.Agrega	= True

OpenWithParm(iw_mantencion, istr_mant)

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled	= True
End If
	
dw_1.SetRow(il_fila)
dw_1.SelectRow(il_fila,True)
end event

event ue_nuevo;call super::ue_nuevo;HabilitaEncab(True)

dw_2.Reset()
	
dw_2.Object.meec_usuari[1] 	=	gstr_us.Nombre
dw_2.Object.meec_comput[1]	=	gstr_us.Computador
dw_2.Object.meec_fecham[1]	=	Today()
pb_Guia.Enabled					=	False
//em_Serie.Enabled					=	False
dw_2.Object.b_carga.Visible	=	False

istr_Mant.Argumento[1]	=	''

dw_2.SetColumn("tpmv_codigo")
end event

event ue_modifica_detalle;If dw_2.Object.meec_estado[1] = 1 Then Return 

If dw_1.RowCount() > 0 Then
	istr_mant.Agrega	= False
	istr_mant.Borra		= False

	OpenWithParm(iw_mantencion, istr_mant)
End If
end event

event ue_antesguardar;call super::ue_antesguardar;Long	ll_Fila, ll_Numero

ll_Numero = dw_2.Object.meec_numero[1]

If IsNull(ll_Numero) Then 
	ll_Numero	=	iuo_Movimiento.of_SiguienteMovto(SQLCA)
	dw_2.Object.meec_numero[1] = ll_Numero
End If

For ll_Fila = 1 To dw_1.RowCount()
	If dw_1.GetItemStatus(ll_Fila, 0, Primary!) = New! Then  dw_1.DeleteRow(ll_Fila)
	dw_1.Object.meec_numero[ll_Fila] = ll_Numero
Next

If iuo_Tipo.Sentido = 1 Then 
	ll_Fila = 1
	Do
		If dw_1.Object.meed_recibi[ll_Fila] = 0 Then 
			dw_1.DeleteRow(ll_Fila)
		Else 
			ll_Fila++
		End If	
	Loop While ll_Fila <= dw_1.RowCount()
End If
end event

event open;call super::open;iuo_Tipo			=	Create uo_TipoMovto
iuo_Origen		=	Create uo_Sucursal		
iuo_Sucursal	=	Create uo_Sucursal		
iuo_Proveedor	=	Create uo_Proveedor
iuo_Movimiento	=	Create uo_MovtoEquipo
iuo_Equipos		=	Create uo_Equipo
iuo_Marca		=	Create uo_Marca
iuo_TipoEquipo	=	Create uo_TipoEquipos
iuo_Modelo		=	Create uo_Modelo
iuo_Guia			=	Create uo_GuiaDespacho

This.Height	=	2600

dw_2.GetChild('tpmv_codigo', idwc_TipoMovto)
idwc_TipoMovto.SetTransObject(SQLCA)
idwc_TipoMovto.Retrieve(-1	)
end event

event resize;Integer	maximo, li_posic_x, li_posic_y, li_visible = 0, &
			li_Ancho = 300, li_Alto = 245, li_Siguiente = 255

If dw_2.width > il_AnchoDw_1 Then
	maximo		=	dw_2.width
Else
	dw_1.width	=	This.WorkSpaceWidth() - 500
	maximo		=	dw_1.width
End If

dw_2.x					=	37 + Round((maximo - dw_2.width) / 3, 0)
dw_2.y					=	37

dw_1.x					=	37 + Round((maximo - dw_1.width) / 2, 0)
dw_1.y					=	64 + dw_2.Height
dw_1.height				=	This.WorkSpaceHeight() - dw_1.y - 41

st_1.x			=	dw_2.x + dw_2.Width + 50
em_Serie.x	=	st_1.x

li_posic_x				=	This.WorkSpaceWidth() - 370
li_posic_y				=	78

If pb_buscar.Visible Then
	pb_buscar.x				=	li_posic_x
	pb_buscar.y				=	li_posic_y
	pb_buscar.width		=	li_Ancho
	pb_buscar.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_nuevo.Visible Then
	pb_nuevo.x				=	li_posic_x
	pb_nuevo.y				=	li_posic_y
	pb_nuevo.width		=	li_Ancho
	pb_nuevo.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If	pb_eliminar.Visible Then
	pb_eliminar.x			=	li_posic_x
	pb_eliminar.y			=	li_posic_y
	pb_eliminar.width		=	li_Ancho
	pb_eliminar.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_grabar.Visible Then
	pb_grabar.x				=	li_posic_x
	pb_grabar.y				=	li_posic_y
	pb_grabar.width		=	li_Ancho
	pb_grabar.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_imprimir.Visible Then
	pb_imprimir.x			=	li_posic_x
	pb_imprimir.y			=	li_posic_y
	pb_imprimir.width		=	li_Ancho
	pb_imprimir.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_cierre.Visible Then
	pb_cierre.x			=	li_posic_x
	pb_cierre.y			=	li_posic_y
	pb_cierre.width		=	li_Ancho
	pb_cierre.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_guia.Visible Then
	pb_guia.x			=	li_posic_x
	pb_guia.y			=	li_posic_y
	pb_guia.width		=	li_Ancho
	pb_guia.height	=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

If pb_salir.Visible Then
	pb_salir.x				=	li_posic_x
	pb_salir.y				=	li_posic_y
	pb_salir.width			=	li_Ancho
	pb_salir.height		=	li_Alto
	li_visible ++
	li_posic_y += li_Siguiente
End If

pb_eli_det.x				=	li_posic_x
pb_eli_det.y				=	dw_1.y + dw_1.Height - li_Siguiente
pb_eli_det.width		=	li_Ancho
pb_eli_det.height		=	li_Alto

pb_ins_det.x			=	li_posic_x
pb_ins_det.y			=	pb_eli_det.y - li_Siguiente - 10
pb_ins_det.width		=	li_Ancho
pb_ins_det.height		=	li_Alto
end event

event ue_listo;If dw_1.RowCount() > 0 Then
	pb_Imprimir.Enabled	=	True
	pb_Eliminar.Enabled	=	True
	
	dw_2.Enabled			=	Not istr_mant.Solo_Consulta
	pb_Eliminar.Enabled	=	Not istr_mant.Solo_Consulta
	pb_Grabar.Enabled	=	Not istr_mant.Solo_Consulta
	pb_ins_det.Enabled	=	Not istr_mant.Solo_Consulta
	pb_eli_det.Enabled	=	Not istr_mant.Solo_Consulta
	
	If dw_2.Object.meec_estado[1] = 1 Then
		pb_Eliminar.Enabled	=	False
		pb_Grabar.Enabled	=	False
		pb_ins_det.Enabled	=	False
		pb_eli_det.Enabled	=	False
		dw_2.Enabled			=	False
		pb_cierre.Enabled		=	False
	End If
	
	wf_BloqueaColumnas(istr_mant.Solo_Consulta)
Else
	pb_ins_det.Enabled	=	Not istr_mant.Solo_Consulta
End If
end event

type dw_1 from w_mant_encab_deta`dw_1 within w_maed_despachos
integer x = 105
integer y = 1172
integer width = 3721
integer height = 912
integer taborder = 100
string title = "Detalle Equipos"
string dataobject = "dw_mues_movimientodeta"
end type

event dw_1::clicked;call super::clicked;If IsNull(Row) Or Row < 1 Then Return
If iuo_Tipo.Sentido = 2 Then Return

If dw_2.Object.meec_estado[1] = 1 Then Return 

If This.Object.meed_recibi[Row] = 1 Then
	This.Object.meed_recibi[Row] = 0
Else
	This.Object.meed_recibi[Row] = 1 
End If
end event

type dw_2 from w_mant_encab_deta`dw_2 within w_maed_despachos
integer x = 101
integer y = 28
integer width = 2409
integer height = 1140
integer taborder = 10
string dataobject = "dw_mant_movimiento"
end type

event dw_2::itemchanged;String		ls_columna, ls_Null

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna
	Case "tpmv_codigo"
		If Not iuo_Tipo.Existe(Integer(Data), True, SQLCA) Then
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return 1
		Else
			If iuo_Tipo.Sentido = 2 Then
				This.Object.b_carga.Visible				=	False
				pb_cierre.Enabled							=	False
				If iuo_Tipo.EmiteGuia = 1 Then
					This.Object.meec_guiemi.Visible		=	True
					pb_guia.Enabled							=	True
					This.Object.meec_guides.Protect 		=	1
				Else
					This.Object.meec_guiemi.Visible		=	False
					pb_guia.Enabled							=	False
				End If
			Else
				This.Object.meec_guiemi.Visible		=	False
				This.Object.b_carga.Visible				=	True
				pb_guia.Enabled							=	False
				pb_cierre.Enabled							=	True
				This.Object.meec_guides.Protect 		=	0
				If iuo_Tipo.CreaEquipo = 1 Then  
					This.Object.b_carga.Text	=	'CREA EQUIPOS NUEVOS'
				Else
					This.Object.b_carga.Text	=	'CARGA DESPACHO'
				End If
			End If

			If iuo_Tipo.SolicitaDestino = 0 Then
				This.Object.prov_codigo.Protect	= 1
				This.Object.sucu_codigo.Protect	= 1
				This.Object.prov_codigo.Visible		= False
				This.Object.sucu_codigo.Visible	= False
				This.Object.prov_codigo_t.Text		=	''
				This.SetItem(Row, "sucu_codigo", Integer(ls_Null))
				This.SetItem(Row, "prov_codigo", Integer(ls_Null))
			ElseIf iuo_Tipo.SolicitaDestino = 1 Then
				This.Object.prov_codigo.Protect	= 1
				This.Object.sucu_codigo.Protect	= 0
				This.Object.prov_codigo.Visible		= False
				This.Object.sucu_codigo.Visible	= True
				This.Object.prov_codigo_t.Text		=	'Sucursal Destino'
				This.SetItem(Row, "prov_codigo", Integer(ls_Null))
			ElseIf iuo_Tipo.SolicitaDestino = 2 Then
				This.Object.prov_codigo.Protect	= 0
				This.Object.sucu_codigo.Protect	= 1
				This.Object.prov_codigo.Visible		= True
				This.Object.sucu_codigo.Visible	= False
				This.Object.prov_codigo_t.Text	=	'Proveedor'
				This.SetItem(Row, "sucu_codigo", Integer(ls_Null))
			End If
		End If
		
	Case 'meec_numero'
		If iuo_Movimiento.of_Existe(Long(Data), False, Sqlca) Then
			istr_Mant.Argumento[1]	=	Data
			Parent.TriggerEvent('ue_recuperadatos')
		Else
			This.SetItem(Row, ls_Columna, Long(ls_Null))
			Return 1
		End If
		
	Case 'sucu_codigo'
		If Not iuo_Sucursal.Existe(Integer(Data), True, SQLCA) Then
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return 1
		End If	
		
	Case 'prov_codigo'
		If Not iuo_Proveedor.Existe(Integer(Data), True, SQLCA) Then
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return 1
		End If	

	Case 'meec_sucori'
		If Not iuo_Origen.Existe(Integer(Data), True, SQLCA) Then
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return 1
		End If	
		
	Case "meec_rutcho"
		is_Rut = F_VerRut(Data, True)
		This.SetItem(Row, ls_Columna, is_Rut)
		Return 1

End Choose

HabilitaIngreso()
end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

event dw_2::itemfocuschanged;call super::itemfocuschanged;If is_rut <> "" Then
	If dwo.Name = "meec_rutcho" Then
		If is_rut <> "" Then
			This.SetItem(il_fila, "meec_rutcho", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		End If
	Else
		This.SetItem(il_fila, "meec_rutcho", is_rut)
	End If
End If
end event

event dw_2::buttonclicking;call super::buttonclicking;String		ls_Boton

ls_Boton = dwo.name

Choose  Case ls_Boton
	Case "b_carga"
		If iuo_Tipo.CreaEquipo = 1 Then
			wf_CreaEquipos()
		Else
			wf_CargaDespacho()
		End If
		
End Choose
end event

type pb_nuevo from w_mant_encab_deta`pb_nuevo within w_maed_despachos
integer x = 3954
integer y = 432
integer taborder = 30
end type

type pb_eliminar from w_mant_encab_deta`pb_eliminar within w_maed_despachos
integer x = 3954
integer y = 612
integer taborder = 40
end type

type pb_grabar from w_mant_encab_deta`pb_grabar within w_maed_despachos
integer x = 3954
integer y = 788
integer taborder = 50
boolean enabled = true
end type

type pb_imprimir from w_mant_encab_deta`pb_imprimir within w_maed_despachos
integer x = 3968
integer y = 976
integer taborder = 60
end type

type pb_salir from w_mant_encab_deta`pb_salir within w_maed_despachos
integer x = 3954
integer y = 1152
integer taborder = 90
end type

type pb_ins_det from w_mant_encab_deta`pb_ins_det within w_maed_despachos
integer x = 3945
integer y = 1608
integer taborder = 70
end type

type pb_eli_det from w_mant_encab_deta`pb_eli_det within w_maed_despachos
integer x = 3945
integer y = 1784
integer taborder = 80
end type

type pb_buscar from w_mant_encab_deta`pb_buscar within w_maed_despachos
integer x = 3959
integer y = 248
integer taborder = 20
end type

type pb_guia from picturebutton within w_maed_despachos
integer x = 3867
integer y = 1324
integer width = 302
integer height = 244
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Guia.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Guia-bn.png"
alignment htextalign = left!
end type

event clicked;Long	ll_NroGuia, li_EmisionGuia, ll_Numero, Fila

SetPointer(HourGlass!)

li_EmisionGuia		=	dw_2.Object.meec_guiemi[1]
ll_Numero			=	dw_2.Object.meec_numero[1]
ll_NroGuia			=	dw_2.Object.meec_guides[1]
	
istr_info.titulo	= "GUIA DESPACHO PROVISORIA"
istr_info.copias	= 1

OpenWithParm(vinf,istr_info)
vinf.dw_1.DataObject = "dw_info_guia_despacho_cal"
vinf.dw_1.SetTransObject(sqlca)

If gi_Emisor_Electronico = 1 Then
	If li_EmisionGuia = 3 Or li_EmisionGuia = 0 Then
		ll_NroGuia = iuo_Guia.of_EmiteGuia(ll_Numero, True)		
		If   ll_NroGuia > 0 Then
			If Not iuo_Guia.of_GeneraLibroGuia() Then 
				MessageBox('Alerta', 'No se pudo actualziar Libro de guias de despacho.', Information!, OK!)
			End If
			iuo_Guia.of_ActualizaEstadoGD(1, ll_Numero, ll_NroGuia, SQLCA)
			iuo_Guia.of_RecuperaPDF(ll_NroGuia, Date(dw_2.Object.meec_fecham[1]))

			Fila = vinf.dw_1.Retrieve(ll_Numero, ll_NroGuia)
			
			dw_2.Object.meec_guides[1]	=	ll_NroGuia
			dw_2.Object.meec_guiemi[1]	=	1
			dw_2.Object.meec_estado[1]	=	1
			
			Parent.TriggerEvent('ue_guardar')

			If Fila = -1 Then
				MessageBox( "Error en Base de Datos", "Se ha producido un error en Base de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
			ElseIf Fila = 0 Then
				MessageBox( "No Existe información", "No existe información para este informe.", StopSign!, Ok!)
			End If
		End If
	Else
		Fila = vinf.dw_1.Retrieve(ll_Numero, ll_NroGuia)
		iuo_Guia.of_RecuperaPDF(ll_NroGuia, Date(dw_2.Object.meec_fecham[1]))
	End If
End If

SetPointer(Arrow!)

CloseWithReturn(Parent, istr_Mant)
end event

type st_1 from statictext within w_maed_despachos
integer x = 2610
integer y = 64
integer width = 375
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 553648127
string text = "Serie"
boolean focusrectangle = false
end type

type em_serie from editmask within w_maed_despachos
integer x = 2610
integer y = 144
integer width = 896
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
long textcolor = 255
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;str_Busqueda	lstr_Busq
String				ls_Busca
Long				ll_Busca, ll_Respuesta, ll_Cantidad

If IsNull(This.Text) or This.Text = '' Then Return

ll_Cantidad = iuo_Equipos.of_CantidadSerie(Upper(This.Text), True, SQLCA)

If ll_Cantidad = -1 Then
	This.Text = ''
	This.SetFocus()
	Return
ElseIf ll_Cantidad > 1 Then
	lstr_Busq.Argum[1] = Upper(This.Text)
	
	OpenWithParm(w_busc_serie,lstr_Busq)
	
	lstr_Busq	=	Message.PowerObjectParm
	
	If UpperBound(lstr_Busq.Argum) = 1 Then
		If lstr_Busq.Argum[1] <> "" Then
			If iuo_Tipo.Sentido = 2 Then
				wf_CargaEquipo(Long(lstr_Busq.Argum[1]), 0, dw_1)
			Else
				ll_Respuesta = MessageBox('Atencion', 'Numero de Serie no pertenece al despacho indicado.' + &
										'~n~nDesea agregarlo a la Recepcion.' , Information!, YesNo!, 2)
				If ll_Respuesta = 1 Then
					wf_CargaEquipo(Long(lstr_Busq.Argum[1]), 1, dw_1)
				End If
				
				This.Text = ''
				This.SetFocus()
			End If
		Else
			This.Text = ''
			This.SetFocus()
		End If 
	Else
		This.Text = ''
		This.SetFocus()
	End If
Else
	ls_Busca = "Upper(equi_nroser) = '" + Upper(This.Text) + "' Or Upper(equi_nroint) = '" + Upper(This.Text) + "'"
	ll_Busca = dw_1.Find(ls_Busca, 1, dw_1.RowCount())
	
	If ll_Busca > 0 Then
		If iuo_Tipo.Sentido = 2 Then
			MessageBox('Atencion', 'Numero de Serie cargado ya esta asignado al movimiento.', Exclamation!, Ok!)
		Else
			dw_1.Object.meed_recibi[ll_Busca] = 1
		End If
		
		This.Text = ''
		This.SetFocus()
	Else
		If iuo_Tipo.Sentido = 2 Then
			wf_CargaEquipo(Upper(This.Text), 0, dw_1)
		Else
			ll_Respuesta = MessageBox('Atencion', 'Numero de Serie no pertenece al despacho indicado.' + &
									'~n~nDesea agregarlo a la Recepcion.' , Information!, YesNo!, 2)
			If ll_Respuesta = 1 Then
				wf_CargaEquipo(Upper(This.Text), 1, dw_1)
			End If
		End If
		
		This.Text = ''
		This.SetFocus()
	End If
End If

If dw_1.RowCount() > 0 And Not pb_eliminar.Enabled Then
	pb_eliminar.Enabled	= True
	pb_grabar.Enabled	= True
	pb_eli_det.Enabled	= True
End If


end event

type pb_cierre from picturebutton within w_maed_despachos
integer x = 3886
integer y = 1196
integer width = 302
integer height = 244
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "System"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\candado.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\candado-bn.png"
alignment htextalign = left!
end type

event clicked;String		ls_Mensaje
Integer	li_Respuesta

ls_Mensaje = 'Se procedera a cerrar el Movimiento de Recepcion.~n~nNo se podra generar ningun cambio una vez cerrada~n~nDesea Continuar?'

li_Respuesta = MessageBox("Atencion", ls_Mensaje, Information!, YesNo!, 2)

If li_Respuesta = 1 Then
	dw_2.Object.meec_estado[1] = 1
Else
	dw_2.Object.meec_estado[1] = 0
End If
end event

