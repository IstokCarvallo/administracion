$PBExportHeader$w_mant_mues_clienprove_servicios.srw
forward
global type w_mant_mues_clienprove_servicios from w_mant_tabla
end type
type rb_nacional from radiobutton within w_mant_mues_clienprove_servicios
end type
type rb_extranjero from radiobutton within w_mant_mues_clienprove_servicios
end type
type st_1 from st_encabe within w_mant_mues_clienprove_servicios
end type
end forward

global type w_mant_mues_clienprove_servicios from w_mant_tabla
integer width = 4535
integer height = 2184
string title = "Mantención Proveedores"
rb_nacional rb_nacional
rb_extranjero rb_extranjero
st_1 st_1
end type
global w_mant_mues_clienprove_servicios w_mant_mues_clienprove_servicios

type variables
w_mant_deta_clienprove	iw_mantencion
DataStore					ids_analisentidad
Long							il_fila2


end variables

forward prototypes
protected function boolean wf_actualiza_db ()
end prototypes

protected function boolean wf_actualiza_db ();Boolean	lb_AutoCommit, lb_Retorno

IF Not dw_1.uf_check_required(0) THEN RETURN False

IF Not dw_1.uf_validate(0) THEN RETURN False

lb_AutoCommit		=	sqlca.AutoCommit
sqlca.AutoCommit	=	False

IF dw_1.Update(True,False) = 1 OR ids_analisentidad.Update(True,False) = 1 then 
	Commit;
	
	IF sqlca.SQLCode <> 0 THEN
		F_ErrorBaseDatos(sqlca, This.Title)
		lb_Retorno	=	False
	ELSE
		lb_Retorno	=	True
		dw_1.ResetUpdate()
		ids_analisentidad.ResetUpdate()
	END IF
ELSE
	RollBack;
	
	IF sqlca.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
	
	lb_Retorno	=	False
END IF

sqlca.AutoCommit	=	lb_AutoCommit

RETURN lb_Retorno
end function

event ue_nuevo;istr_mant.borra	= False
istr_mant.agrega	= True

OpenWithParm(iw_mantencion, istr_mant)

IF dw_1.RowCount() > 0 AND pb_eliminar.Enabled = FALSE THEN
	pb_eliminar.Enabled	= TRUE
	pb_grabar.Enabled		= TRUE
END IF

dw_1.SetRow(il_fila)
dw_1.SelectRow(il_fila,True)
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info lstr_info

lstr_info.titulo	= "MAESTRO PROVEEDORES"
lstr_info.copias	= 1

OpenWithParm(vinf, lstr_info)
vinf.dw_1.DataObject	= "dw_info_clienprove_tipent"
vinf.dw_1.SetTransObject(sqlca)
fila	= vinf.dw_1.Retrieve(Integer(Istr_Mant.Argumento[1]))

IF fila	= -1 THEN
	MessageBox("Error en Base de Datos", "Se ha Producido un error en Base" + &
					"de Datos : ~n" + sqlca.SQLErrText, StopSign!, OK!)
ELSEIF fila	= 0 THEN
	MessageBox("No Existe Información", "No Existe Información para este Informa.", StopSign!, OK!)
ElSE
	F_Membrete(vinf.dw_1)
	IF gs_Ambiente <> 'Windows' THEN F_ImprimeInformePdf(vinf.dw_1, istr_info.titulo)
END IF

SetPointer(Arrow!)
end event

event ue_recuperadatos;call super::ue_recuperadatos;Long	ll_fila, respuesta
DO
	ll_fila	= dw_1.Retrieve(integer(istr_mant.argumento[1]))
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox(	"Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		dw_1.SetRow(1)
		dw_1.SelectRow(1,True)
		dw_1.SetFocus()
		pb_insertar.Enabled	= True
		pb_eliminar.Enabled	= True
		pb_grabar.Enabled		= True
		pb_imprimir.Enabled	= True
	ELSE
		pb_insertar.Enabled 	= True
		pb_insertar.SetFocus()
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)
end event

on w_mant_mues_clienprove_servicios.create
int iCurrent
call super::create
this.rb_nacional=create rb_nacional
this.rb_extranjero=create rb_extranjero
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_nacional
this.Control[iCurrent+2]=this.rb_extranjero
this.Control[iCurrent+3]=this.st_1
end on

on w_mant_mues_clienprove_servicios.destroy
call super::destroy
destroy(this.rb_nacional)
destroy(this.rb_extranjero)
destroy(this.st_1)
end on

event ue_borrar;IF dw_1.rowcount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar = True
w_main.SetMicroHelp("Validando la eliminación...")

Message.DoubleParm = 0

This.TriggerEvent ("ue_validaborrar")

IF Message.DoubleParm = -1 THEN RETURN

istr_mant.borra	= True
istr_mant.agrega	= False

OpenWithParm(iw_mantencion, istr_mant)  
														
istr_mant = Message.PowerObjectParm

IF istr_mant.respuesta = 1 THEN
	IF dw_1.DeleteRow(0) = 1 THEN
		ib_borrar = False
	w_main.SetMicroHelp("Borrando Registro...")
		SetPointer(Arrow!)
	ELSE
		ib_borrar = False
		MessageBox(This.Title,"No se puede borrar actual registro.")
	END IF
	
	IF dw_1.RowCount() = 0 THEN
		pb_eliminar.Enabled = False
	ELSE
		il_fila = dw_1.GetRow()
		dw_1.SelectRow(il_fila,True)
	END IF
END IF

istr_mant.borra	 = False
end event

event open;call super::open;istr_mant.argumento[1]	=	'1'
buscar						=	'R.U.T.:Sclpr_rut,Nombre:Sclpr_nombre'
ordenar						= 	'R.U.T.:clpr_rut,Nombre:clpr_nombre'


ids_analisentidad					= Create DataStore
ids_analisentidad.DataObject	=	"dw_mues_analisentidad"
ids_analisentidad.SetTransObject(sqlca)


end event

event ue_modifica;call super::ue_modifica;IF dw_1.RowCount() > 0 THEN
	istr_mant.agrega	= False
	istr_mant.borra	= False

	OpenWithParm(iw_mantencion, istr_mant)
END IF
end event

event ue_antesguardar;Long		ll_Fila
String   ls_rut
Integer	li_tipana

li_tipana	= Integer(Istr_Mant.Argumento[1])

ids_analisentidad.SetTransObject(sqlca)
FOR ll_Fila = 1 TO dw_1.RowCount()
	IF dw_1.GetItemStatus(ll_fila,"clpr_rut",Primary!) = DataModified! OR &
		dw_1.GetItemStatus(ll_fila,"clpr_rut",Primary!) = NewModified! THEN
		
		ids_analisentidad.Retrieve(dw_1.Object.clpr_rut[ll_fila])
		il_fila2 = ids_analisentidad.InsertRow(0)
		ids_analisentidad.Object.clpr_rut[il_fila2] = dw_1.Object.clpr_rut[ll_fila]
		ids_analisentidad.Object.tian_codigo[il_fila2] = li_tipana
		
		dw_1.SetItemStatus(ll_fila,"clpr_rut",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_nrorut",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_nombre",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_nomper",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_apepat",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_apemat",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_fantas",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_giroem",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_contac",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"clpr_direcc",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"ciud_codigo",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"comu_codigo",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"clpr_telefo",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"clpr_nrofax",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_tipoan",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"zona_codigo",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_tipoen",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_rutrep",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_nomrep",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_rutre2",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"clpr_nomre2",Primary!, NotModified!)
		dw_1.SetItemStatus(ll_fila,"pais_codigo",Primary!, NotModified!)	
		dw_1.SetItemStatus(ll_fila,"clpr_corint",Primary!, NotModified!)	
	END IF
NEXT
end event

event ue_validaborrar;call super::ue_validaborrar;Integer	li_tipo
String	ls_rut

ls_rut	= dw_1.Object.clpr_rut[il_fila]

SELECT Count(*)
  INTO :li_tipo
  FROM dbo.Casino_ProveedorServ
 WHERE clpr_rut 	= :ls_rut;
				
IF SQLCA.SqlCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de la Tabla ANALISENTIDAD")
	Message.DoubleParm = -1
	
ELSEIF li_tipo > 0 THEN
	MessageBox("Atención","Registro No se Puede Borrar" + &
					"~r~rEsta Referenciado en Otra Tabla",StopSign!)
	Message.DoubleParm = -1
	
END IF
end event

type dw_1 from w_mant_tabla`dw_1 within w_mant_mues_clienprove_servicios
integer y = 356
integer width = 4110
integer height = 1688
integer taborder = 40
string dataobject = "dw_mues_clienprove"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_encabe from w_mant_tabla`st_encabe within w_mant_mues_clienprove_servicios
boolean visible = false
integer x = 192
integer y = 476
integer width = 2144
integer height = 240
end type

type pb_lectura from w_mant_tabla`pb_lectura within w_mant_mues_clienprove_servicios
integer x = 4233
integer taborder = 20
end type

event pb_lectura::clicked;rb_extranjero.Enabled	=	False
rb_nacional.Enabled		=	False

Parent.TriggerEvent("ue_recuperadatos")

end event

type pb_nuevo from w_mant_tabla`pb_nuevo within w_mant_mues_clienprove_servicios
integer x = 4233
integer taborder = 30
end type

event pb_nuevo::clicked;call super::clicked;pb_insertar.Enabled		= 	False
pb_eliminar.Enabled		= 	False
pb_grabar.Enabled		=	False
pb_imprimir.Enabled		=	False
rb_extranjero.Enabled	=	True
rb_nacional.Enabled		=	True
rb_nacional.Checked		=	True
istr_mant.argumento[1]	=	'1'
end event

type pb_insertar from w_mant_tabla`pb_insertar within w_mant_mues_clienprove_servicios
integer x = 4233
integer y = 620
integer taborder = 50
end type

type pb_eliminar from w_mant_tabla`pb_eliminar within w_mant_mues_clienprove_servicios
integer x = 4233
integer y = 832
integer taborder = 60
end type

type pb_grabar from w_mant_tabla`pb_grabar within w_mant_mues_clienprove_servicios
integer x = 4233
integer y = 1052
integer height = 152
integer taborder = 70
end type

type pb_imprimir from w_mant_tabla`pb_imprimir within w_mant_mues_clienprove_servicios
integer x = 4233
integer y = 1268
integer taborder = 80
end type

type pb_salir from w_mant_tabla`pb_salir within w_mant_mues_clienprove_servicios
integer x = 4233
integer y = 1484
integer taborder = 90
end type

type rb_nacional from radiobutton within w_mant_mues_clienprove_servicios
integer x = 1262
integer y = 156
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Nacional"
boolean checked = true
end type

event clicked;istr_mant.argumento[1]	=	'1'
end event

type rb_extranjero from radiobutton within w_mant_mues_clienprove_servicios
integer x = 2597
integer y = 156
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Extranjero"
end type

event clicked;istr_mant.argumento[1]	=	'5'
end event

type st_1 from st_encabe within w_mant_mues_clienprove_servicios
boolean visible = true
integer x = 78
integer y = 76
integer width = 4110
end type

