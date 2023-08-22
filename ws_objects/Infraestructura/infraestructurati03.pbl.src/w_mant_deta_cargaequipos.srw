$PBExportHeader$w_mant_deta_cargaequipos.srw
forward
global type w_mant_deta_cargaequipos from w_mant_detalle
end type
type dw_2 from uo_dw within w_mant_deta_cargaequipos
end type
type dw_3 from uo_dw within w_mant_deta_cargaequipos
end type
type pb_inserta from picturebutton within w_mant_deta_cargaequipos
end type
type pb_elimina from picturebutton within w_mant_deta_cargaequipos
end type
type pb_crea from picturebutton within w_mant_deta_cargaequipos
end type
end forward

global type w_mant_deta_cargaequipos from w_mant_detalle
integer width = 3022
integer height = 2224
string title = "ASIGNACION COLABORADORES"
boolean controlmenu = true
dw_2 dw_2
dw_3 dw_3
pb_inserta pb_inserta
pb_elimina pb_elimina
pb_crea pb_crea
end type
global w_mant_deta_cargaequipos w_mant_deta_cargaequipos

type variables
uo_Marca			iuo_Marca
uo_Modelo			iuo_Modelo
uo_TipoEquipos	iuo_Tipo
uo_Empresa			iuo_Empresa
uo_Proveedor		iuo_Proveedor
uo_Proveedor		iuo_Leasing

DataWindowChild	idwc_Modelo
end variables

forward prototypes
public subroutine wf_habilitaingreso ()
public function boolean wf_duplicado (string campo, integer tipo)
public subroutine wf_cargaequipodespacho ()
public function boolean compartedatos (long al_filaorigen, long al_filadestino, datawindow adw_origen, datawindow adw_destino)
public subroutine asignavalor (string as_columna, long al_fila, datawindow adw_origen, datawindow adw_destino)
end prototypes

public subroutine wf_habilitaingreso ();Boolean	lb_habilita = True

dw_2.AcceptText()

If IsNull(dw_2.Object.empr_codigo[1]) Or dw_2.Object.empr_codigo[1] = 0 Or &
	IsNull(dw_2.Object.marc_codigo[1]) Or dw_2.Object.marc_codigo[1] = 0 Or &
	IsNull(dw_2.Object.prov_codigo[1]) Or dw_2.Object.prov_codigo[1] = 0 Or &
	IsNull(dw_2.Object.mode_codigo[1]) Or dw_2.Object.mode_codigo[1] = 0 Or &
	IsNull(dw_2.Object.tieq_codigo[1]) Or dw_2.Object.tieq_codigo[1] = 0 Or &
	IsNull(dw_2.Object.equi_fecadq[1]) Then
	lb_habilita = False
End If

pb_crea.Enabled	=	lb_habilita
pb_inserta.Enabled	=	lb_habilita

end subroutine

public function boolean wf_duplicado (string campo, integer tipo);Long     	ll_fila
String		ls_Campo

ls_Campo	=	dw_1.GetItemString(il_fila, "equi_nroser")

Choose Case Tipo
	Case 1
		ls_Campo = Campo
				
End Choose

ll_fila = dw_3.Find("equi_nroser= '" + ls_Campo + "'", 1, dw_3.RowCount())

If ll_fila > 0  Then
	MessageBox("Error","Numero de Serie ya fue Ingresado Anteriormente",Information!, OK!)
	Return	True
Else
	Return	False
End If


end function

public subroutine wf_cargaequipodespacho ();Long	ll_Fila, Row, ll_Busca
String	ls_Busca

uo_Equipo			luo_Equipos
uo_Marca			luo_Marca
uo_Modelo			luo_Modelo
uo_TipoEquipos	luo_Tipo

luo_Equipos	=	Create uo_Equipo
luo_Marca	=	Create uo_Marca
luo_Modelo	=	Create uo_Modelo
luo_Tipo		=	Create uo_TipoEquipos

For ll_Fila = 1 To dw_3.RowCount()
	If luo_Equipos.of_ExisteParaDespacho(dw_3.Object.equi_codigo[ll_Fila], True, SQLCA) Then
		luo_Marca.Existe(luo_Equipos.Marca, False, SQLCA)
		luo_Modelo.Existe(luo_Equipos.Marca, luo_Equipos.TipoEquipo, luo_Equipos.CodigoModelo, False, SQLCA)
		iuo_Tipo.Existe(luo_Equipos.TipoEquipo, False, SQLCA)
		
		ls_Busca = 'equi_codigo = ' + String(dw_3.Object.equi_codigo[ll_Fila])
		ll_Busca = dw_1.Find(ls_Busca, 1, dw_1.RowCount(), Primary!)
		
		If ll_Busca = 0 Then 
			Row = dw_1.InsertRow(0)
			
			dw_1.Object.equi_codigo[Row]		=	dw_3.Object.equi_codigo[ll_Fila]
			dw_1.Object.equi_nroser[Row]		=	luo_Equipos.Serie
			dw_1.Object.equi_nroint[Row]		=	luo_Equipos.NroInterno
			dw_1.Object.equi_modelo[Row]	=	luo_Equipos.Modelo
			dw_1.Object.mode_nombre[Row]	=	luo_Modelo.Nombre
			dw_1.Object.marc_nombre[Row]	=	luo_Marca.Nombre
			dw_1.Object.tieq_nombre[Row]	=	luo_Tipo.Nombre
		End If
	End If	
Next

Destroy luo_Equipos
Destroy luo_Marca
Destroy luo_Modelo
Destroy luo_Tipo
end subroutine

public function boolean compartedatos (long al_filaorigen, long al_filadestino, datawindow adw_origen, datawindow adw_destino);Return True
end function

public subroutine asignavalor (string as_columna, long al_fila, datawindow adw_origen, datawindow adw_destino);//
end subroutine

on w_mant_deta_cargaequipos.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.pb_inserta=create pb_inserta
this.pb_elimina=create pb_elimina
this.pb_crea=create pb_crea
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.pb_inserta
this.Control[iCurrent+4]=this.pb_elimina
this.Control[iCurrent+5]=this.pb_crea
end on

on w_mant_deta_cargaequipos.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.pb_inserta)
destroy(this.pb_elimina)
destroy(this.pb_crea)
end on

event open;call super::open;iuo_Marca		=	Create uo_Marca
iuo_Modelo		=	Create uo_Modelo
iuo_Tipo			=	Create uo_TipoEquipos
iuo_Empresa	=	Create uo_Empresa	
iuo_Proveedor	=	Create uo_Proveedor
iuo_Leasing		=	Create uo_Proveedor

dw_3.SetRowFocusIndicator(Hand!)

dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

dw_2.GetChild('mode_codigo', idwc_Modelo)
idwc_Modelo.SetTransObject(SQLCA)
idwc_Modelo.Retrieve(-1, -1)

dw_2.InsertRow(0)

istr_mant.dw.ShareData(dw_1)
end event

event resize;//
end event

event ue_recuperadatos;//
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_cargaequipos
boolean visible = false
boolean enabled = false
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_cargaequipos
boolean visible = false
boolean enabled = false
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_cargaequipos
boolean visible = false
boolean enabled = false
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_cargaequipos
boolean visible = false
boolean enabled = false
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_cargaequipos
boolean visible = false
integer x = 2533
integer y = 408
boolean enabled = false
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_cargaequipos
integer x = 2533
integer y = 160
boolean default = false
end type

event pb_acepta::clicked;CloseWithReturn(Parent, istr_mant)
end event

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_cargaequipos
boolean visible = false
integer x = 2533
integer y = 656
boolean enabled = false
boolean cancel = false
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_cargaequipos
boolean visible = false
integer x = 114
integer y = 1140
integer width = 2309
integer height = 912
string dataobject = "dw_mues_movimientodeta"
end type

type dw_2 from uo_dw within w_mant_deta_cargaequipos
integer x = 398
integer y = 88
integer width = 1806
integer height = 1044
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_mant_cargaequipo"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna		
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
		
	Case 'mode_codigo'
		If Not iuo_Modelo.Existe(iuo_Marca.Codigo, iuo_Tipo.Codigo, Integer(Data), True, Sqlca) Then 
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
			This.GetChild('mode_codigo', idwc_Modelo)
			idwc_Modelo.SetTransObject(SQLCA)
			idwc_Modelo.Retrieve(iuo_Marca.Codigo, iuo_Tipo.Codigo)
		End If
		
	Case 'equi_leasin'
		If Not iuo_Leasing.Existe(Integer(Data), True, Sqlca) Then 
			This.SetItem(Row, ls_Columna, Integer(ls_Null))
			Return -1
		End If
		
End Choose

wf_HabilitaIngreso()
end event

type dw_3 from uo_dw within w_mant_deta_cargaequipos
integer x = 119
integer y = 1140
integer width = 2286
integer height = 968
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_mues_cargaequipo"
boolean vscrollbar = false
end type

event itemchanged;call super::itemchanged;String		ls_Null, ls_columna

SetNull(ls_Null)
ls_columna = dwo.name

Choose  Case ls_columna		
	Case 'equi_nroser'
		If wf_Duplicado(Data, 1) Then
			This.SetItem(Row, ls_Columna, ls_Null)
			Return 1
		Else
			pb_Inserta.TriggerEvent("clicked")
			Return 1
		End If
		
End Choose


end event

event itemerror;call super::itemerror;Return 1
end event

type pb_inserta from picturebutton within w_mant_deta_cargaequipos
integer x = 2533
integer y = 1404
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
string picturename = "\Desarrollo 17\Imagenes\Botones\Signo Mas.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Signo Mas-bn.png"
alignment htextalign = left!
end type

event clicked;il_fila = dw_3.InsertRow(0)

If il_fila > 0 Then pb_elimina.Enabled	= True

dw_3.ScrollToRow(il_fila)
dw_3.SetRow(il_fila)
dw_3.SetFocus()
dw_3.SetColumn(1)
end event

type pb_elimina from picturebutton within w_mant_deta_cargaequipos
integer x = 2533
integer y = 1652
integer width = 302
integer height = 244
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\Signo Menos.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\Signo Menos-bn.png"
alignment htextalign = left!
end type

event clicked;IF dw_3.RowCount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar = True
w_main.SetMicroHelp("Validando la eliminación...")

IF MessageBox("Eliminación de Registro", "Está seguro de Eliminar este Registro", Question!, YesNo!) = 1 THEN
	IF dw_3.DeleteRow(0) = 1 THEN
		ib_borrar = False
		w_main.SetMicroHelp("Borrando Registro...")
		SetPointer(Arrow!)
	ELSE
		ib_borrar = False
		MessageBox(PArent.Title,"No se puede borrar actual registro.")
	END IF

	IF dw_3.RowCount() = 0 THEN
		pb_elimina.Enabled = False
	ELSE
		il_fila = dw_1.GetRow()
	END IF
END IF
end event

type pb_crea from picturebutton within w_mant_deta_cargaequipos
integer x = 2533
integer y = 1156
integer width = 302
integer height = 244
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "\Desarrollo 17\Imagenes\Botones\notebook.png"
string disabledname = "\Desarrollo 17\Imagenes\Botones\notebook-bn.png"
alignment htextalign = left!
end type

event clicked;Long 			ll_Fila = 1, ll_Respuesta, ll_CodigoID
Integer 		li_Empresa, li_Marca, li_Proveedor, li_Modelo, li_TipoEquipo, li_Leasing
String			ls_NroPoliza, ls_NroAca, ls_NroSerie, ls_NroInterno
DateTime	ld_Fecha

DO WHILE ll_fila <= dw_3.RowCount()
	IF dw_3.GetItemStatus(ll_fila, 0, Primary!) = New! THEN
		dw_3.DeleteRow(ll_fila)
	ELSE
		ll_fila ++
	END IF
LOOP

dw_3.AcceptText()
If dw_3.RowCount() = 0 Then Return

ll_Respuesta = MessageBox('Atencion', 'Se procedera a crear equipos ingresados.~n~nDesea Continuar', Exclamation!, YesNo!, 2)

If ll_Respuesta = 1 Then		
	li_Empresa		=	dw_2.Object.empr_codigo[1]
	li_Marca			=	dw_2.Object.marc_codigo[1]
	li_Proveedor		=	dw_2.Object.prov_codigo[1]
	li_Modelo		=	dw_2.Object.mode_codigo[1]
	li_TipoEquipo	=	dw_2.Object.tieq_codigo[1]
	li_Leasing		=	dw_2.Object.equi_leasin[1]
	ls_NroPoliza		=	dw_2.Object.equi_nrolea[1]
	ls_NroAca		=	dw_2.Object.equi_nroaca[1]
	ld_Fecha			=	dw_2.Object.equi_fecadq[1]
	
	For ll_Fila = 1 To dw_3.RowCount()
			If IsNull(dw_3.Object.equi_codigo[ll_Fila]) Then
				ls_NroSerie = dw_3.Object.equi_nroser[ll_Fila]
				
				DECLARE CreaEquipos PROCEDURE FOR dbo.Infra_CreaEquipo
					@Empresa		=	:li_Empresa,
					@Marca			=	:li_Marca,
					@Proveedor		=	:li_Proveedor, 
					@Modelo			=	:li_Modelo, 
					@TipoEquipo	=	:li_TipoEquipo, 
					@Fecha			=	:ld_Fecha,
					@Leasing		=	:li_Leasing, 
					@NroPoliza		=	:ls_NroPoliza,
					@NroAca			=	:ls_NroAca, 
					@NroSerie		=	:ls_NroSerie
					USING SQLCA;
					
				EXECUTE CreaEquipos;
					
				FETCH CreaEquipos INTO :ls_NroInterno, :ll_CodigoID;
				
				CLOSE CreaEquipos;
				
				dw_3.Object.equi_nroint[ll_Fila] = ls_NroInterno
				dw_3.Object.equi_codigo[ll_Fila] = ll_CodigoId
			End If
			
			dw_3.SetRow(ll_Fila)
			dw_3.SelectRow(ll_Fila,True)
	Next
	wf_CargaEquipoDespacho()
Else
	Return
End If
end event

