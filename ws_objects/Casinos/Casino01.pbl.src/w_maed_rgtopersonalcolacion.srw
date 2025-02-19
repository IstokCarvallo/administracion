$PBExportHeader$w_maed_rgtopersonalcolacion.srw
forward
global type w_maed_rgtopersonalcolacion from w_mant_directo
end type
type dw_4 from uo_dw within w_maed_rgtopersonalcolacion
end type
type pb_reproceso from picturebutton within w_maed_rgtopersonalcolacion
end type
type dw_5 from uo_dw within w_maed_rgtopersonalcolacion
end type
type tab_1 from tab within w_maed_rgtopersonalcolacion
end type
type tab_1 from tab within w_maed_rgtopersonalcolacion
end type
type dw_6 from uo_dw within w_maed_rgtopersonalcolacion
end type
type dw_3 from uo_dw within w_maed_rgtopersonalcolacion
end type
type dw_2 from uo_dw within w_maed_rgtopersonalcolacion
end type
type dw_errores from datawindow within w_maed_rgtopersonalcolacion
end type
type tab_2 from tab within w_maed_rgtopersonalcolacion
end type
type tabpage_1 from vuo_tab_personalcasino within tab_2
end type
type tabpage_1 from vuo_tab_personalcasino within tab_2
end type
type tab_2 from tab within w_maed_rgtopersonalcolacion
tabpage_1 tabpage_1
end type
end forward

global type w_maed_rgtopersonalcolacion from w_mant_directo
integer width = 3863
integer height = 2528
string title = "PERSONAL POR ZONAS"
dw_4 dw_4
pb_reproceso pb_reproceso
dw_5 dw_5
tab_1 tab_1
dw_6 dw_6
dw_3 dw_3
dw_2 dw_2
dw_errores dw_errores
tab_2 tab_2
end type
global w_maed_rgtopersonalcolacion w_maed_rgtopersonalcolacion

type variables
vuo_tab_personalcasino	iuo_tab[]

Long							il_tabs
Integer						ii_zona
Transaction					it_trans
uo_zona						iuo_zona

Integer						ii_areas[]
end variables

forward prototypes
public function boolean cargatabs ()
public subroutine personalvigente (integer ai_fila)
protected function boolean wf_actualiza_db ()
public subroutine rescatanombre (string as_nombre)
public function boolean usuariobd (string as_username, boolean crear)
public subroutine bloqueaventana (boolean ab_estado)
public function boolean wf_conectaempresa (integer ai_fila)
public function boolean wf_reprocesaempresa ()
end prototypes

public function boolean cargatabs ();Boolean 	lb_retorno = True
Integer	li_filas, li_fila
long		area
string		codigo, paterno

dw_1.SetSort("zona_codigo asc, caar_codigo asc")
dw_1.Sort()

area=	dw_1.Object.caar_codigo[1]
codigo=dw_1.Object.cape_codigo[1]
paterno=dw_1.Object.cape_apepat[1]

ii_areas[1]	=	dw_1.Object.caar_codigo[1]

FOR li_filas = 2 TO dw_1.RowCount()
	area=	dw_1.Object.caar_codigo[li_filas]
	codigo=dw_1.Object.cape_codigo[li_filas]
	paterno=dw_1.Object.cape_apepat[li_filas]
	IF ii_areas[UpperBound(ii_areas[])]	<>	dw_1.Object.caar_codigo[li_filas] THEN
		ii_areas[UpperBound(ii_areas[]) + 1]	=	dw_1.Object.caar_codigo[li_filas]
	END IF
NEXT

FOR li_filas =	1 TO UpperBound(ii_areas[])
	il_tabs ++
	iuo_tab[il_tabs]					=	Create vuo_tab_personalcasino
	tab_1.OpenTab(iuo_tab[il_tabs], 0)
	Tab_1.Control[il_tabs].Text	=	"Area: "
	Tab_1.SelectTab(il_tabs)
	iuo_tab[il_tabs].Referencias(This, ii_zona, ii_areas[li_filas])
	iuo_tab[il_tabs].Filtra()
	Tab_1.Control[il_tabs].Text	=	iuo_tab[il_tabs].dw_2.Object.caar_nombre[1]
	
NEXT

Return lb_retorno
end function

public subroutine personalvigente (integer ai_fila);Integer		li_fila, li_find, li_empresa
String			ls_perscodigo
DataStore	lds_dw_1

lds_dw_1				=	Create DataStore
lds_dw_1.DataObject	=	"dw_mues_casino_personacolacion"

dw_1.RowsCopy(1, dw_1.RowCount(), Primary!, lds_dw_1, 1, Primary!)
dw_1.RowsCopy(1, dw_1.FilteredCount(), Filter!, lds_dw_1, 1, Filter!)

lds_dw_1.SetFilter("")
lds_dw_1.Filter()

li_empresa	=	dw_2.Object.empr_codigo[ai_fila]

dw_6.SetTransObject(sqlca)
dw_6.Retrieve(li_empresa, '')

FOR li_fila = dw_6.RowCount() TO 1 Step -1
	li_find 	= 	dw_2.find("empr_codigo = " + String(dw_6.Object.empr_codigo[li_fila]),  1, dw_2.RowCount())
								 
	IF li_find > 0 THEN
		dw_6.Object.empr_nombre[li_fila]	=	dw_2.Object.empr_abrevi[li_find]
	END IF

	ls_perscodigo	=	dw_6.Object.pers_codigo[li_fila]
	li_find			=	lds_dw_1.Find("cape_codigo = '" + ls_perscodigo + "'", 1, lds_dw_1.RowCount())
	IF li_find > 0 THEN
		dw_6.DeleteRow(li_fila)
	END IF
	
NEXT

dw_6.SetSort("empr_codigo, pers_nomcom")
dw_6.Sort()

Destroy lds_dw_1;
end subroutine

protected function boolean wf_actualiza_db ();Integer	li_filas
Boolean	lb_AutoCommit, lb_Retorno
DateTime	ldt_FechaHora

ldt_FechaHora		=	F_FechaHora()
dw_1.GrupoFecha	=	ldt_FechaHora

IF Not dw_1.uf_check_required(0) THEN RETURN False

IF Not dw_1.uf_validate(0) THEN RETURN False

lb_AutoCommit		=	sqlca.AutoCommit
sqlca.AutoCommit	=	False

IF dw_5.Update(True, False) = 1 THEN 
	IF dw_1.Update(True, False) = 1 THEN 
		Commit;

		IF sqlca.SQLCode <> 0 THEN
			F_ErrorBaseDatos(sqlca, This.Title)
			lb_Retorno	=	False
			
		ELSE
			lb_Retorno	=	True
			
			FOR li_filas = 1 TO dw_1.DeletedCount()
				UsuarioBD(dw_1.Object.cape_usuari.Delete[li_filas], False)
				
			NEXT
			
			FOR li_filas = 1 TO dw_1.RowCount()
				IF dw_1.GetItemStatus(0, li_filas, Primary!)	=	NewModified! THEN
					UsuarioBD(dw_1.Object.cape_usuari[li_filas], True)
				END IF
			NEXT
			
			dw_1.ResetUpdate()
			dw_5.ResetUpdate()
		END IF
	ELSE
		RollBack;
		
		IF sqlca.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
		
		lb_Retorno	=	False
	END IF
ELSE
	RollBack;
	
	IF sqlca.SQLCode <> 0 THEN F_ErrorBaseDatos(sqlca, This.Title)
	
	lb_Retorno	=	False
END IF

sqlca.AutoCommit	=	lb_AutoCommit

RETURN lb_Retorno
end function

public subroutine rescatanombre (string as_nombre);Integer	li_tab

li_tab		=	tab_1.SelectedTab

IF Len(as_nombre) > 0 THEN
	Tab_1.Control[li_tab].Text	=	as_nombre
ELSE
	Tab_1.Control[li_tab].Text	=	"Area:"
END IF
end subroutine

public function boolean usuariobd (string as_username, boolean crear);String		ls_Sentencia, ls_usuario, ls_passnew
Boolean	lb_Acepta = False, lb_AutoCommit
Long		ll_User_id

IF SQLCA.DBMS = 'ODBC' THEN
	IF Crear THEN
		DECLARE id_user PROCEDURE FOR dbo.f_user_id  
			@Usuario =	:as_username USING sqlca;
			
		EXECUTE id_user;
		
		IF sqlca.SQLCode <> -1 THEN
			lb_Acepta		=	True
			FETCH id_user INTO :ll_user_id;
		END IF
		
		CLOSE id_user;
	
		IF ll_User_id = 0 THEN
			
			ls_Sentencia	=	"GRANT CONNECT TO " + as_username + " " + &
									"IDENTIFIED BY RIO; GRANT DBA, RESOURCE TO " + as_username 
			EXECUTE IMMEDIATE :ls_Sentencia USING sqlca ;
	
			IF sqlca.SQLCode = 0 THEN
				lb_Acepta		=	True
			END IF
		END IF
	ELSE
		ls_Sentencia	=	"REVOKE CONNECT FROM " + as_username 
		EXECUTE IMMEDIATE :ls_Sentencia USING sqlca ;

		IF sqlca.SQLCode = 0 THEN
			lb_Acepta		=	True
		END IF

	END IF
END IF

RETURN lb_Acepta
end function

public subroutine bloqueaventana (boolean ab_estado);
end subroutine

public function boolean wf_conectaempresa (integer ai_fila);String		ls_Usuario, ls_Password, ls_DBMS, ls_Nombre, ls_DBParm, ls_Base, ls_Server, ls_Provider
Boolean	lb_conectado

SetPointer(HourGlass!)

DISCONNECT USING it_trans;													

ls_DBMS		=	dw_2.Object.empr_nodbms[ai_fila]
ls_nombre	=	dw_2.Object.empr_idodbc[ai_fila]
ls_usuario  	=  dw_2.Object.empr_nomusu[ai_fila]
ls_Password	=  dw_2.Object.empr_passwo[ai_fila]
ls_Server	=	dw_2.Object.empr_nomser[ai_fila]
ls_Base		=	dw_2.Object.empr_nombas[ai_fila]
ls_Provider	=	"SQLNCLI11"//dw_2.Object.empr_driver[ai_fila]

it_trans.Dbms			=	ls_DBMS
it_trans.ServerName	=	ls_Server
it_trans.DataBase		=	ls_Base

If ls_DBMS = "ODBC" Then
		it_trans.DbParm		=	"Connectstring='DSN=" + ls_Nombre + ";" + &
													"UID=" + ls_Usuario  + ";" + &
													"PWD=" + ls_Password + "'// ;" + &
													"ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT'" + &
													"PBUseProcOwner = "  + '"Yes"'
	ElseIf ls_Dbms = 'OLEDB' Then
		it_trans.LogId   		= ls_usuario
		it_trans.LogPass 		= ls_Password
		it_trans.Autocommit	= True
		
		If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm

		ls_DBParm = "PROVIDER='" + ls_Provider + "',PROVIDERSTRING='database="+ls_Base + "'," + &
					 "DATASOURCE='"+ls_Server +"'"+ls_DbParm
				
		it_trans.DbParm = ls_DbParm
	ElseIf Mid(ls_Dbms,1,3) = 'SNC' or Mid(ls_Dbms,1,9) = 'TRACE SNC' Then
		it_trans.LogId  	 		= ls_usuario
		it_trans.LogPass  		= ls_Password
		it_trans.Autocommit	= True
			
		If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm
		
		ls_Dbparm = "Provider='" + ls_Provider + "',Database='"+ls_Base+"'"+ls_DbParm+",TrimSpaces=1,"
			
		it_trans.DBParm = ls_Dbparm
	ElseIf	ls_Dbms = "ADO.Net" Then
		it_trans.DBMS 			= "ADO.Net"
		it_trans.LogId			=	ls_usuario
		it_trans.LogPass		=	ls_Password
		it_trans.Autocommit	=	True
		it_trans.DBParm 		= "DataSource='" + ls_Server + "',Database='" + ls_Base + "',Namespace='System.Data.OleDb',Provider='SQLNCLI10'"
	Else
		it_trans.LogId			=	ls_usuario
		it_trans.LogPass		=	ls_Password
		it_trans.Autocommit	=	True
	End If
	
CONNECT USING it_trans;

IF it_trans.SQLCode = 0 THEN
	lb_conectado	=	True
ELSE
	lb_conectado	=	False
	F_ErrorBaseDatos(it_trans, This.Title)
END IF

RETURN lb_conectado
end function

public function boolean wf_reprocesaempresa ();SetPointer(HourGlass!)

Long			ll_empresas, ll_fila
Boolean		lb_AutoCommit
Integer		respuesta, li_codigo, li_find, li_Numero, li_Retorno
String			ls_empresa
String			ls_Errores[] = {"Falló Apertura de Traspaso", 					&
									"Demasiadas Columnas", 						&
									"Tabla ya Existe", 									&
									"Tabla no Existe", 									&
									"Perdió Conexión", 								&
									"Argumentos Erróneos", 							&
									"Columna(s) de distinto Tipo", 					&
									"Error Fatal en SQL de Fuente", 				&
									"Error Fatal en SQL de Destino", 				&
									"Exedió máximo de Errores", 					&
									"",														&
									"Error de Sintáxis en Tabla", 					&
									"Tabla requiere de LLave pero no tiene",		&
									"", 													&
									"Traspaso ya estaba en Progreso",			&
									"Error en Base de Datos Fuente",				&
									"Error en Base de Datos Destino",				&
									"Base de Datos Destino es de Sólo Lectura"}


Pipeline				lpl_Traspaso
lpl_Traspaso	=	Create PipeLine

lpl_Traspaso.Cancel()

//Carga personal por empresa
FOR ll_empresas = 1 TO dw_2.RowCount()
	If dw_2.IsSelected(ll_empresas) Then
		
		If NOT wf_ConectaEmpresa(ll_empresas) Then
			Return False
		End If
		
		li_codigo						=	dw_2.Object.empr_codigo[ll_empresas]
		dw_errores.Visible 		= 	True
		lpl_Traspaso.DataObject	=	"dpl_remupersonal"
		li_Retorno					=	lpl_Traspaso.Start(it_trans, sqlca, dw_errores, li_codigo)
		
		If li_Retorno < 0 Then
			MessageBox("Error", "Se ha producido el siguiente Error en el Traspaso de " 	+	&
							lpl_Traspaso.DataObject + "~r~r"	+	&
							String(li_Retorno) + " : "	+	ls_Errores[Abs(li_Retorno)] 			+	&
							"~r~rAvise a Administrador de Sistema.")
			Return False
		End If
		
		If li_Retorno < 1 Then  Return False
		
		dw_errores.Visible 		= 	True
		lpl_Traspaso.DataObject	=	"dpl_centrocosto"
		li_Retorno					=	lpl_Traspaso.Start(it_trans, sqlca, dw_errores)
		
		If li_Retorno < 0 Then
			MessageBox("Error", "Se ha producido el siguiente Error en el Traspaso de " 	+	&
							"dpl_centrocosto. ~r~r" 	+	&
							String(li_Retorno) + " : "	+	ls_Errores[Abs(li_Retorno)] 			+	&
							"~r~rAvise a Administrador de Sistema.")
			Return False
		End If
		
		If li_Retorno < 1 Then Return False
	End If
NEXT

dw_errores.Visible = False

Destroy lpl_Traspaso

Return True
end function

event resize;call super::resize;Integer		li_posic_x, li_posic_y, &
				li_Ancho = 300, li_Alto = 245, li_Siguiente = 255

dw_1.Resize (This.WorkSpaceWidth() - (510) - dw_6.Width, This.WorkSpaceHeight() - dw_1.y  - (75))
tab_1.Resize(This.WorkSpaceWidth() - (510) - dw_6.Width, This.WorkSpaceHeight() - tab_1.y - (75))
tab_2.Resize(This.WorkSpaceWidth() - (510) - dw_6.Width, This.WorkSpaceHeight() - tab_2.y - (75))

dw_1.x					= 	1143
tab_1.x					= 	1143
tab_2.x					= 	1143
st_encabe.x				= 	37
st_encabe.Width		=	dw_4.Width + 200
dw_3.x					= 	37
dw_6.x					= 	37
dw_2.x					= 	dw_1.x + (dw_1.Width - dw_2.Width)
dw_errores.x			= 	dw_1.x + (dw_1.Width - dw_2.Width)

dw_3.y					=	344
dw_1.y					=	344
dw_6.y					=	344
tab_1.y					=	344
tab_2.y					=	344

dw_3.Height				=	tab_1.Height
dw_6.Height				=	tab_1.Height

li_posic_x				= This.WorkSpaceWidth() - 392

IF pb_reproceso.Visible THEN
	pb_reproceso.x			= 	li_posic_x
	pb_reproceso.y			=	pb_Imprimir.y + li_Siguiente
	pb_reproceso.width	= 	li_Ancho
	pb_reproceso.height	= 	li_Alto
	
	li_posic_y		+= li_Siguiente
END IF

end event

on w_maed_rgtopersonalcolacion.create
int iCurrent
call super::create
this.dw_4=create dw_4
this.pb_reproceso=create pb_reproceso
this.dw_5=create dw_5
this.tab_1=create tab_1
this.dw_6=create dw_6
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_errores=create dw_errores
this.tab_2=create tab_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_4
this.Control[iCurrent+2]=this.pb_reproceso
this.Control[iCurrent+3]=this.dw_5
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_6
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_errores
this.Control[iCurrent+9]=this.tab_2
end on

on w_maed_rgtopersonalcolacion.destroy
call super::destroy
destroy(this.dw_4)
destroy(this.pb_reproceso)
destroy(this.dw_5)
destroy(this.tab_1)
destroy(this.dw_6)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_errores)
destroy(this.tab_2)
end on

event open;Integer	li_filas
x												= 	0
y												= 	0
im_menu										=	m_principal

This.ParentWindow().ToolBarVisible	=	True
im_menu.Item[1].Item[6].Enabled		=	True
im_menu.Item[7].Visible					=	False
This.Icon									=	Gstr_apl.Icono
							
it_trans										=	Create Transaction
iuo_zona										=	Create uo_zona

dw_1.SetTransObject(sqlca)
dw_1.Modify("datawindow.message.title='Error '+ is_titulo")
dw_1.SetRowFocusIndicator(Hand!)
dw_1.Modify("DataWindow.Footer.Height = 110")

istr_mant.UsuarioSoloConsulta			=	OpcionSoloConsulta()
istr_mant.Solo_Consulta					=	istr_mant.UsuarioSoloConsulta

GrabaAccesoAplicacion(True, id_FechaAcceso, it_HoraAcceso, &
							This.Title, "Acceso a Aplicación", 1)

dw_2.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_5.SetTransObject(sqlca)

dw_4.InsertRow(0)
li_filas	=	dw_2.Retrieve()

IF li_filas > 0 THEN
	pb_reproceso.Enabled	=	True
	
ELSE
	pb_reproceso.Enabled	=	False
	
END IF

Tab_1.Visible				=	False
Tab_2.Visible				=	True
Tab_2.Enabled				=	False
Tab_2.tabpage_1.Enabled	=	False

buscar			= "Rut:Spers_codigo,Nombre:Spers_nomcom"
ordenar			= "Rut:pers_codigo,Nombre:pers_nomcom"

end event

event ue_borrar;Long							ll_tabs, ll_recorre, ll_posicion
Integer						li_respuesta, li_fila, li_find
vuo_tab_personalcasino	luo_tab[]

IF dw_1.rowcount() < 1 THEN RETURN

SetPointer(HourGlass!)

ib_borrar = True
w_main.SetMicroHelp("Validando la eliminación...")

Message.DoubleParm = 0

ll_tabs			=	tab_1.SelectedTab
il_tabs			=	il_tabs - 1

li_respuesta	=	Messagebox("Eliminación de Registros", "¿Desea eliminar el Area completa, o solo el personal seleccionado?."+&
														"~r~nPresione [Si] para eliminar el area, [No] para eliminar el Personal seleccionado, "+&
														"o [Cancelar]", Question!, YesNoCancel!)
CHOOSE CASE li_respuesta
	CASE 1
		Tab_1.CloseTab(iuo_tab[ll_tabs])
		
		FOR li_fila = 1 TO dw_1.RowCount()
			li_find	=	dw_2.Find("empr_codigo = " + String(dw_1.Object.empr_codigo[li_fila]), &
										 1, dw_2.RowCount())
			dw_2.SelectRow(li_find, True)
		NEXT
		
		dw_1.RowsMove(1, dw_1.RowCount(), Primary!, dw_1, 1, Delete!)
		dw_5.DeleteRow(dw_5.GetRow())

		FOR ll_recorre = ll_tabs TO (UpperBound(iuo_tab[]) - 1)
			iuo_tab[ll_recorre]	=	iuo_tab[ll_recorre + 1]	
		NEXT

		Destroy iuo_tab[ll_recorre];

		il_tabs	=	UpperBound(Tab_1.Control[])
		IF il_tabs > 0 THEN Tab_1.SelectTab(il_tabs)

	CASE 2
		li_fila	=	iuo_tab[ll_tabs].dw_1.GetRow()
		li_find	=	dw_2.Find("empr_codigo = " + &
						String(iuo_tab[ll_tabs].dw_1.Object.empr_codigo[li_fila]), 1, dw_2.RowCount())
						
		dw_2.SelectRow(li_find, True)
		
		iuo_tab[ll_tabs].dw_1.DeleteRow(iuo_tab[ll_tabs].dw_1.GetRow())

END CHOOSE
FOR ll_recorre = 1 TO dw_2.RowCount()
	IF dw_2.IsSelected(ll_recorre) THEN 
		PersonalVigente(ll_recorre)
		dw_2.SelectRow(ll_recorre, False)
	END IF
NEXT
end event

event ue_recuperadatos;Long		ll_fila, respuesta, ll_empresas
Integer	li_todos = 0, li_codigo
String	ls_empresa

SetPointer(HourGlass!)

DO
	ll_fila		=	dw_5.Retrieve(ii_zona)
	
	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila = 0 THEN
		dw_5.InsertRow(0)
	END IF
LOOP WHILE respuesta = 1

IF respuesta = 2 THEN Close(This)

DO
	ll_fila		=	dw_1.Retrieve(ii_zona)

	IF ll_fila = -1 THEN
		respuesta = MessageBox("Error en Base de Datos", "No es posible conectar la Base de Datos.", &
										Information!, RetryCancel!)
	ELSEIF ll_fila > 0 THEN
		pb_grabar.Enabled		=	True
		pb_lectura.Enabled	=	False

		Tab_2.Visible			=	False
		Tab_1.Visible			=	True

		IF NOT CargaTabs() THEN
			Close(This)
			Return
		END IF
		
		pb_eliminar.Enabled	=	True
		pb_imprimir.Enabled	=	True
		
	ELSE
		Tab_2.Visible			=	False
		Tab_1.Visible			=	True
		pb_grabar.Enabled		=	True
		
		pb_insertar.TriggerEvent(Clicked!)
	END IF
LOOP WHILE respuesta = 1

dw_6.Reset()
FOR ll_fila = 1 TO dw_2.RowCount()
	PersonalVigente(ll_fila)
NEXT

IF respuesta = 2 THEN Close(This)

pb_lectura.Enabled	=	False
pb_insertar.Enabled	=	True
end event

event ue_imprimir;SetPointer(HourGlass!)

Long		fila
str_info	lstr_info

lstr_info.titulo	= "PERSONAL POR ZONAS"
lstr_info.copias	= 1

OpenWithParm(vinf,lstr_info)

vinf.dw_1.DataObject = "dw_info_casino_personacolacion"

vinf.dw_1.SetTransObject(sqlca)

fila = vinf.dw_1.Retrieve()

IF fila = -1 THEN
	MessageBox( "Error en Base de Datos", "Se ha producido un error en Base " + &
					"de datos : ~n" + sqlca.SQLErrText, StopSign!, Ok!)
ELSEIF fila = 0 THEN
	MessageBox( "No Existe información", "No existe información para este informe.", &
					StopSign!, Ok!)
ELSE
	F_Membrete(vinf.dw_1)
	vinf.dw_1.Modify('DataWindow.Print.Preview = Yes')
	vinf.dw_1.Modify('DataWindow.Print.Preview.Zoom = 75')
	
	vinf.dw_1.Sort()
			
	vinf.Visible	= True
	vinf.Enabled	= True
END IF

SetPointer(Arrow!)
end event

event closequery;call super::closequery;IF dw_errores.Visible THEN
	MessageBox("Advertencia", "No se puede cerrar la ventana mientras se~r~n" + &
									  "este realizando Consolidación de Datos", Exclamation!)
	Return 1
ELSE
	Return 0
END IF
end event

event ue_ordenar;String ls_info

str_parms	parm

parm.string_arg[1]	= ordenar
parm.dw_arg				= dw_6

OpenWithParm(w_columna_orden, parm)

ls_info	= Message.StringParm

dw_6.SetRow(1)

RETURN
end event

type st_encabe from w_mant_directo`st_encabe within w_maed_rgtopersonalcolacion
integer x = 37
integer y = 28
integer width = 1797
integer height = 300
end type

type pb_nuevo from w_mant_directo`pb_nuevo within w_maed_rgtopersonalcolacion
integer x = 3470
end type

type pb_lectura from w_mant_directo`pb_lectura within w_maed_rgtopersonalcolacion
integer x = 3470
end type

type pb_eliminar from w_mant_directo`pb_eliminar within w_maed_rgtopersonalcolacion
integer x = 3470
end type

type pb_insertar from w_mant_directo`pb_insertar within w_maed_rgtopersonalcolacion
integer x = 3470
end type

event pb_insertar::clicked;Long	ll_tabs

il_tabs ++
iuo_tab[il_tabs]					=	Create vuo_tab_personalcasino
tab_1.OpenTab(iuo_tab[il_tabs], 0)
Tab_1.Control[il_tabs].Text	=	"Area:"
Tab_1.SelectTab(il_tabs)
iuo_tab[il_tabs].Referencias(Parent, ii_zona, 0)
iuo_tab[il_tabs].Filtra()

pb_grabar.Enabled		=	True
end event

type pb_salir from w_mant_directo`pb_salir within w_maed_rgtopersonalcolacion
integer x = 3470
integer y = 1632
end type

event pb_salir::clicked;Close(Parent)

end event

type pb_imprimir from w_mant_directo`pb_imprimir within w_maed_rgtopersonalcolacion
integer x = 3470
end type

type pb_grabar from w_mant_directo`pb_grabar within w_maed_rgtopersonalcolacion
integer x = 3470
end type

type dw_1 from w_mant_directo`dw_1 within w_maed_rgtopersonalcolacion
integer x = 1138
integer y = 440
integer width = 1376
integer height = 368
string dataobject = "dw_mues_casino_personacolacion"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::sqlpreview;//
end event

type dw_4 from uo_dw within w_maed_rgtopersonalcolacion
integer x = 110
integer y = 84
integer width = 1650
integer height = 184
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_zonas"
boolean vscrollbar = false
end type

event itemchanged;call super::itemchanged;Integer	li_Nula
String 	ls_Columna

SetNull(li_Nula)
ls_Columna	=	dwo.name

Choose Case ls_Columna
	Case "zona_codigo"
		If NOT iuo_zona.Existe(Integer(data), True, Sqlca) Then
			This.SetItem(Row, ls_Columna, li_Nula)
			Return 1
		Else
			ii_zona	=	Integer(data)
			This.Object.zona_nombre[Row]	=	iuo_zona.nombre
		End If
		
End Choose
end event

type pb_reproceso from picturebutton within w_maed_rgtopersonalcolacion
string tag = "Consolidacion de Datos"
integer x = 3328
integer y = 1136
integer width = 302
integer height = 244
integer taborder = 80
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
string powertiptext = "Consolidacion de Datos"
end type

event clicked;wf_ReprocesaEmpresa()
end event

type dw_5 from uo_dw within w_maed_rgtopersonalcolacion
integer x = 1253
integer y = 552
integer width = 215
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encab_casino_areas"
boolean vscrollbar = false
boolean border = false
end type

event sqlpreview;//
end event

type tab_1 from tab within w_maed_rgtopersonalcolacion
integer x = 1161
integer y = 364
integer width = 2199
integer height = 1668
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 30586022
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
end type

event selectionchanged;Integer	li_area

li_area	=	iuo_tab[NewIndex].ii_area
iuo_tab[NewIndex].Referencias(Parent, ii_zona, li_area)
iuo_tab[NewIndex].Filtra()
end event

type dw_6 from uo_dw within w_maed_rgtopersonalcolacion
event ue_mousemove pbm_mousemove
integer x = 37
integer y = 352
integer width = 1097
integer height = 1652
integer taborder = 11
string dragicon = "\Desarrollo\Bmp\Row.ico"
boolean titlebar = true
string title = "Personal Vigente"
string dataobject = "dw_mant_mues_remupersona_seleccion"
boolean hscrollbar = true
end type

event ue_mousemove;IF This.IsSelected(GetRow()) AND message.WordParm = 1 THEN
	This.Drag(begin!)
END IF
end event

event clicked;IF row > 0 THEN
	This.SelectRow(0, False)
	This.SelectRow(row, True)
END IF
end event

event doubleclicked;call super::doubleclicked;Datawindow	ldw_usuarios
Integer		li_tabactiva, li_fila, li_area
String		ls_codigo
Long			ll_source, ll_nueva

IF Row < 1 THEN Return

li_tabactiva	=	tab_1.SelectedTab
ldw_usuarios	=	iuo_tab[li_tabactiva].dw_1
ll_source		=	row
li_area			=	iuo_tab[li_tabactiva].ii_area

IF li_area = 0 OR IsNull(li_area) THEN
	MessageBox("Error", "Debe ingresar datos del area antes de asignar personal.", Exclamation!)
	Return 
END IF

FOR li_fila	=	1 TO ldw_usuarios.RowCount()
	IF ldw_usuarios.Object.cape_codigo[li_fila]	=	This.Object.pers_codigo[ll_source] THEN
		MessageBox("Error", "El personal seleccionado ya pertenece a Este Grupo", Exclamation!)
		Return 
	END IF
NEXT

FOR li_fila = 1 TO ldw_usuarios.FilteredCount()
	ls_codigo	 =	ldw_usuarios.GetItemString(li_fila, "cape_codigo", Filter!, True)
	
	IF ls_codigo = This.Object.pers_codigo[ll_source] THEN 
		MessageBox("Error", "El personal seleccionado pertenece a Otro Grupo", Exclamation!)
		Return 
	END IF
NEXT

ll_nueva												=	ldw_usuarios.InsertRow(0)

ldw_usuarios.Object.cape_apepat[ll_nueva]	=	This.Object.pers_apepat[ll_source]
ldw_usuarios.Object.cape_apemat[ll_nueva]	=	This.Object.pers_apemat[ll_source]
ldw_usuarios.Object.cape_nombre[ll_nueva]	=	This.Object.pers_nombre[ll_source]

ldw_usuarios.Object.cape_codigo[ll_nueva]	=	This.Object.pers_codigo[ll_source]
ldw_usuarios.Object.cape_usuari[ll_nueva]	=	Left(This.Object.pers_nombre[ll_source], 1) + &
															This.Object.pers_apepat[ll_source]
			
ldw_usuarios.Object.cape_tipope[ll_nueva]	=	0
ldw_usuarios.Object.cape_invita[ll_nueva]	=	0
ldw_usuarios.Object.cape_topein[ll_nueva]	=	0
ldw_usuarios.Object.cape_pedcas[ll_nueva]	=	0
ldw_usuarios.Object.cape_ctacte[ll_nueva]	=	0

ldw_usuarios.Object.empr_codigo[ll_nueva]	=	This.Object.empr_codigo[ll_source]
ldw_usuarios.Object.zona_codigo[ll_nueva]	=	ii_zona
ldw_usuarios.Object.caar_codigo[ll_nueva]	=	li_area
ldw_usuarios.Object.control[ll_nueva]		=	0

This.DeleteRow(row)
end event

event dragdrop;call super::dragdrop;DataWindow	ldw_Source
Datawindow	ldw_usuarios
Integer		li_tabactiva, li_fila, li_area, li_find
String			ls_codigo
Long			ll_source, ll_nueva

IF Row < 1 THEN Return

li_tabactiva	=	tab_1.SelectedTab
ldw_usuarios	=	iuo_tab[li_tabactiva].dw_1
li_area			=	iuo_tab[li_tabactiva].ii_area

IF source.TypeOf() = DataWindow! THEN 
	ldw_Source 	= 	Source
	CHOOSE CASE Source 	
		CASE dw_6
			RETURN
			
		CASE ldw_usuarios
			li_fila	=	This.InsertRow(0)
			This.Object.pers_apepat[li_fila]	=	ldw_usuarios.Object.cape_apepat[ldw_usuarios.GetRow()]
			This.Object.pers_apemat[li_fila]	=	ldw_usuarios.Object.cape_apemat[ldw_usuarios.GetRow()]
			This.Object.pers_nombre[li_fila]	=	ldw_usuarios.Object.cape_nombre[ldw_usuarios.GetRow()]
			
			This.Object.pers_nomcom[li_fila]	=	ldw_usuarios.Object.cape_apepat[ldw_usuarios.GetRow()] + ' ' + &
															ldw_usuarios.Object.cape_apemat[ldw_usuarios.GetRow()] + ' ' + &
															ldw_usuarios.Object.cape_nombre[ldw_usuarios.GetRow()]
		
			This.Object.pers_codigo[li_fila]	=	ldw_usuarios.Object.cape_codigo[ldw_usuarios.GetRow()]
			This.Object.empr_codigo[li_fila]	=	ldw_usuarios.Object.empr_codigo[ldw_usuarios.GetRow()]
			
			li_find	=	dw_2.Find("empr_codigo = " + String(This.Object.empr_codigo[li_fila]), &
										 1, dw_2.RowCount())
			This.Object.empr_nombre[li_fila]	=	dw_2.Object.empr_abrevi[li_find]
			
			This.AcceptText()
			
			This.SetSort("empr_codigo, pers_nomcom")
			This.Sort()
			
			ldw_usuarios.DeleteRow(ldw_usuarios.GetRow())
			ldw_usuarios.SelectRow(ldw_usuarios.GetRow(), False)
			RETURN
			
	END CHOOSE
ELSE
	RETURN
END IF

ldw_Source.DeleteRow(ldw_Source.GetRow())
end event

event retrievestart;call super::retrievestart;Return 2
end event

type dw_3 from uo_dw within w_maed_rgtopersonalcolacion
boolean visible = false
integer x = 37
integer y = 352
integer width = 1097
integer height = 1652
integer taborder = 11
boolean titlebar = true
string title = "Personal Vigente En Empresa Seleccionada"
string dataobject = "dw_mues_personal_empresas"
boolean vscrollbar = false
end type

type dw_2 from uo_dw within w_maed_rgtopersonalcolacion
integer x = 1888
integer y = 28
integer width = 1454
integer height = 300
integer taborder = 11
string dataobject = "dw_mues_nombre_empresas"
end type

event itemchanged;call super::itemchanged;IF Row > 0 THEN This.SelectRow(Row, Not This.IsSelected(Row))
end event

event doubleclicked;call super::doubleclicked;Long	ll_fila

This.SelectRow(0, False)
This.SelectRow(Row, True)

dw_6.Reset()

FOR ll_fila = 1 TO dw_2.RowCount()
	IF dw_2.IsSelected(ll_fila) THEN 
		PersonalVigente(ll_fila)
	END IF
NEXT
end event

type dw_errores from datawindow within w_maed_rgtopersonalcolacion
boolean visible = false
integer y = 28
integer width = 1454
integer height = 300
integer taborder = 21
string title = "none"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type tab_2 from tab within w_maed_rgtopersonalcolacion
integer x = 1184
integer y = 360
integer width = 2199
integer height = 1668
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_2.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_2.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from vuo_tab_personalcasino within tab_2
integer x = 18
integer y = 112
integer width = 2162
integer height = 1540
string text = "Muestra"
end type

