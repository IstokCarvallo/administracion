$PBExportHeader$w_mant_deta_clienprove_casino.srw
forward
global type w_mant_deta_clienprove_casino from w_mant_detalle
end type
end forward

global type w_mant_deta_clienprove_casino from w_mant_detalle
integer width = 3141
integer height = 1656
string title = "Clientes y Proveedores"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
end type
global w_mant_deta_clienprove_casino w_mant_deta_clienprove_casino

type variables
String	is_rut, is_rut2, is_codigo, is_rutrep, is_rutrep2

DataWindowChild	idwc_zonas, idwc_ciudades, idwc_comunas


end variables

forward prototypes
public function boolean duplicado (string campo, integer tipo)
public subroutine buscacomuna ()
public subroutine igualrut ()
public function boolean noexisteciudad (integer ciud_codigo)
public function boolean noexistecomuna (integer comu_codigo)
public subroutine armanombre (string as_columna, string as_valor)
public function boolean existeclienprove (string as_columna, string as_codigo)
public function boolean duplicadocorint (long campo)
end prototypes

public function boolean duplicado (string campo, integer tipo);Long		ll_fila
String	ls_rut, ls_codigo

ls_codigo	= dw_1.GetItemString(il_fila,"clpr_rut")

CHOOSE CASE tipo
	CASE 1
		ls_codigo = campo	

END CHOOSE

ll_fila = istr_mant.dw.Find("clpr_rut = '" + ls_codigo + "'", 1, istr_mant.dw.RowCount())		

IF ll_fila > 0 and ll_fila <> il_FilaAnc THEN
	MessageBox("Error","Registro ya fue ingresado anteriormente.", Information!, OK!)
	dw_1.SetItem(il_fila,"clpr_rut", '')
	RETURN True
ELSE
	RETURN False
END IF
end function

public subroutine buscacomuna ();dw_1.Modify("buscacomuna.border = 0")
dw_1.Modify("buscacomuna.border = 5")

istr_busq.argum[1] = String(dw_1.GetItemNumber(il_fila, "ciud_codigo"))

OpenWithParm(w_busc_comunas, istr_busq)

istr_busq	= Message.PowerObjectParm

IF istr_busq.argum[3] = "" THEN
	dw_1.SetColumn("comu_codigo")
	dw_1.SetFocus()
ELSE
	dw_1.SetItem(il_fila,"ciud_codigo",Integer(istr_busq.argum[1]))
	dw_1.SetItem(il_fila,"comu_codigo",Integer(istr_busq.argum[3]))
	dw_1.SetItem(il_fila,"comunas_comu_nombre",istr_busq.argum[4])
	dw_1.SetFocus()
END IF

dw_1.Modify("buscacomuna.border = 0")
dw_1.Modify("buscacomuna.border = 6")

RETURN
end subroutine

public subroutine igualrut ();String ls_nrorut

dw_1.Modify("igualrut.border = 0")
dw_1.Modify("igualrut.border = 5")

ls_nrorut = dw_1.GetItemString(il_fila,"clpr_nrorut")

 IF Duplicado(ls_nrorut, 1) = False THEN dw_1.SetItem(il_fila, "clpr_rut", ls_nrorut)

dw_1.Modify("igualrut.border = 0")
dw_1.Modify("igualrut.border = 6")

RETURN
end subroutine

public function boolean noexisteciudad (integer ciud_codigo);String	ciud_nombre

SELECT	ciud_nombre 
	INTO	:ciud_nombre
	FROM	dbo.CIUDADES
	WHERE	ciud_codigo = :ciud_codigo ;
	
IF sqlca.SQLCode =-1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de la Tabla ciudades")
	RETURN False
ELSEIF sqlca.SQLCode = 100 THEN
	MessageBox("Atención","Codigo de Ciudades no ha sido Creado. Ingrese otro Codigo.",&
							Exclamation!, OK!)
	RETURN True
ELSE
	RETURN False
END IF
end function

public function boolean noexistecomuna (integer comu_codigo);String	comu_nombre
Integer	ciud_codigo

ciud_codigo = dw_1.Object.ciud_codigo[il_fila]

IF IsNull(ciud_codigo) = False AND ciud_codigo > 0 THEN
	SELECT	comu_nombre 
		INTO	:comu_nombre
		FROM	dbo.COMUNAS
		WHERE	ciud_codigo = :ciud_codigo
		AND 	comu_codigo = :comu_codigo ;
		
	IF sqlca.SQLCode =-1 THEN
		F_ErrorBaseDatos(sqlca,"Lectura de la Tabla comunas")
		RETURN False
	ELSEIF sqlca.SQLCode = 100 THEN
		MessageBox("Atención","Codigo de Comunas no ha sido Creado. Ingrese otro Codigo.",&
								Exclamation!, OK!)
		RETURN True
	ELSE
		RETURN False
	END IF
ELSE
	RETURN False
END IF
end function

public subroutine armanombre (string as_columna, string as_valor);String	ls_Nombre, ls_ApePaterno, ls_ApeMaterno

ls_Nombre		=	dw_1.Object.clpr_nomper[il_fila]
ls_ApePaterno	=	dw_1.Object.clpr_apepat[il_fila]
ls_ApeMaterno	=	dw_1.Object.clpr_apemat[il_fila]

CHOOSE CASE as_Columna
	CASE "clpr_nomper"
		ls_Nombre		=	as_Valor
		
	CASE "clpr_apepat"
		ls_ApePaterno	=	as_Valor
		
	CASE "clpr_apemat"
		ls_ApeMaterno	=	as_Valor
		
END CHOOSE

IF IsNull(ls_Nombre) THEN ls_Nombre = ''
IF IsNull(ls_ApePaterno) THEN ls_ApePaterno = ''
IF IsNull(ls_ApeMaterno) THEN ls_ApeMaterno = ''

dw_1.Object.clpr_nombre[il_fila]	=	Mid(ls_Nombre + "  "+ ls_ApePaterno + "  " + &
										ls_ApeMaterno + Fill(" ", 60), 1, 60)

IF Not IsNull(ls_ApeMaterno) AND ls_ApeMaterno <> "" THEN
	ls_ApeMaterno	=	Mid(ls_ApeMaterno, 1, 1) + "."
END IF

dw_1.Object.clpr_fantas[il_fila]	=	Mid(ls_Nombre + " " + ls_ApePaterno + " " + &
										ls_ApeMaterno + Fill(" ", 20), 1, 20)

RETURN

end subroutine

public function boolean existeclienprove (string as_columna, string as_codigo);Integer 	li_tipana, li_comuna, li_ciudad, li_tipoan, li_zona, li_tipoen, li_tipo, li_pais,li_corint
String	ls_rut, ls_nrorut, ls_nombre, ls_nomper, ls_apepat, ls_apemat, ls_fantas,&
			ls_giroem, ls_contact, ls_direcc, ls_telefo, ls_fax,  ls_rutrep,&
			ls_nomrep, ls_rutre2, ls_nomre2
str_clienprove		le_cliente

li_tipana	= Integer(Istr_Mant.Argumento[1])

SELECT	clpr_rut, clpr_nrorut, clpr_nombre, clpr_nomper, clpr_apepat, 
         clpr_apemat, clpr_fantas, clpr_giroem,	clpr_contac, clpr_direcc, 
			ciud_codigo,	comu_codigo, clpr_telefo, clpr_nrofax, clpr_tipoan,
			zona_codigo, clpr_tipoen, clpr_rutrep,	clpr_nomrep,clpr_rutre2, 
			clpr_nomre2, pais_codigo, clpr_corint 
	INTO	:ls_rut, :ls_nrorut, :ls_nombre, :ls_nomper,:ls_apepat, 
			:ls_apemat, :ls_fantas,	:ls_giroem, :ls_contact, :ls_direcc,
			:li_ciudad, :li_comuna, :ls_telefo, :ls_fax, :li_tipoan,
			:li_zona, :li_tipoen,:ls_rutrep, :ls_nomrep, :ls_rutre2,
			:ls_nomre2, :li_pais, :li_corint 
	FROM	dbo.clienprove
	WHERE	clpr_rut 	= :as_codigo;
			
IF SQLCA.SqlCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de la Tabla CLIENPROVE")
	RETURN False
ELSEIF SQLCA.SqlCode = 0 THEN
		
	SELECT	tian_codigo
		INTO	:li_tipo
		FROM	dbo.analisentidad
		WHERE	clpr_rut 	= :as_codigo
		AND	tian_codigo = :li_tipana;
				
	IF SQLCA.SqlCode = -1 THEN
		F_ErrorBaseDatos(sqlca,"Lectura de la Tabla ANALISENTIDAD")
		RETURN False
	ELSEIF SQLCA.SqlCode = 0 THEN
		MessageBox("Atención","Rut ya Está Asociado a Este Tipo de Entidad",Exclamation!)
		RETURN False
	END IF
		
		idwc_comunas.Retrieve(li_ciudad)
		dw_1.Object.clpr_nombre[il_fila]=	ls_nombre
		dw_1.Object.clpr_fantas[il_fila]=	ls_fantas
		dw_1.Object.clpr_contac[il_fila]=	ls_contact
		dw_1.Object.clpr_direcc[il_fila]=	ls_direcc
		dw_1.Object.ciud_codigo[il_fila]=	li_ciudad		
		dw_1.Object.comu_codigo[il_fila]=	li_Comuna
		dw_1.Object.clpr_telefo[il_fila]=	ls_Telefo
		dw_1.Object.clpr_nrofax[il_fila]=	ls_Fax
		dw_1.Object.clpr_tipoan[il_fila]=	li_Tipoan
		dw_1.Object.zona_codigo[il_fila]=	li_Zona		
		dw_1.Object.pais_codigo[il_fila]=	li_pais
		dw_1.Object.clpr_corint[il_fila]=	li_corint
		
		dw_1.SetItemStatus(il_fila,"clpr_rut",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_nrorut",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_nombre",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_nomper",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_apepat",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_apemat",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_fantas",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_giroem",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_contac",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"clpr_direcc",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"ciud_codigo",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"comu_codigo",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"clpr_telefo",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"clpr_nrofax",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_tipoan",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"zona_codigo",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_tipoen",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_rutrep",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_nomrep",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_rutre2",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"clpr_nomre2",Primary!, DataModified!)
		dw_1.SetItemStatus(il_fila,"pais_codigo",Primary!, DataModified!)	
		dw_1.SetItemStatus(il_fila,"clpr_corint",Primary!, DataModified!)	
		RETURN True
END IF	

RETURN True
end function

public function boolean duplicadocorint (long campo);Long		ll_fila, ll_codigo,ll_pais
String	ls_rut

ll_codigo = campo	
ll_pais = dw_1.object.pais_codigo[il_fila]

ll_fila = istr_mant.dw.Find("clpr_corint = " + string(ll_codigo) + " and pais_codigo=" + string(ll_pais), &
						  			 1, istr_mant.dw.RowCount())		
						  
IF ll_fila > 0 and ll_fila <> il_FilaAnc THEN
	MessageBox("Error","Correlativo ya fue ingresado anteriormente para el país.", Information!, OK!)
	dw_1.SetItem(il_fila,"clpr_corint", '')
	RETURN True
ELSE 
	SELECT count(*) into :ll_fila
  	  FROM dbo.CLIENPROVE
    WHERE PAIS_CODIGO = :ll_pais
	   AND CLPR_CORINT = :ll_codigo;
	IF ll_fila > 0  THEN
		MessageBox("Error","Correlativo ya fue ingresado anteriormente para el país.", Information!, OK!)
		dw_1.SetItem(il_fila,"clpr_corint", '')
		RETURN True
	ELSE	
		RETURN False
	END IF
END IF
end function

on w_mant_deta_clienprove_casino.create
call super::create
end on

on w_mant_deta_clienprove_casino.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1]	= 	dw_1.Object.clpr_rut[il_fila]
ias_campo[2]	= 	dw_1.Object.clpr_nrorut[il_fila]
ias_campo[3]	= 	dw_1.Object.clpr_nombre[il_fila]
ias_campo[4]	= 	dw_1.Object.clpr_fantas[il_fila]
ias_campo[5]	= 	dw_1.Object.clpr_direcc[il_fila]
ias_campo[6]	= 	String(dw_1.Object.ciud_codigo[il_fila])
ias_campo[7]	= 	String(dw_1.Object.comu_codigo[il_fila])
ias_campo[8]	= 	dw_1.Object.clpr_telefo[il_fila]
ias_campo[9]	= 	dw_1.Object.clpr_nrofax[il_fila]
ias_campo[10]	= 	String(dw_1.Object.pais_codigo[il_fila])
ias_campo[11]	= 	String(dw_1.Object.clpr_corint[il_fila])
ias_campo[12]	= 	String(dw_1.Object.clpr_correo[il_fila])

is_rut = Fill("0",10 - Len(ias_campo[1]))+ias_campo[1]

IF IsNumber(is_rut) AND Long(is_rut) = 0 THEN is_rut = ''

IF istr_mant.agrega = False THEN
	dw_1.SetTabOrder("clpr_nrorut", 0)
	dw_1.SetTabOrder("clpr_rut", 0)
	dw_1.SetTabOrder("clpr_tipoan", 0)
	dw_1.Modify("clpr_rut.BackGround.Color = " + String(rgb(192,192,192)))
	dw_1.Modify("clpr_nrorut.BackGround.Color = " + String(rgb(192,192,192)))	
	dw_1.Object.buscadetalle.Enabled = True
	
	idwc_comunas.Retrieve(Integer(ias_campo[6]))	
ELSE
	IF Istr_Mant.Argumento[1] = '1' THEN
		
		dw_1.Object.clpr_tipoan[il_fila] = 1
		dw_1.SetTabOrder("clpr_tipoan", 0)
		dw_1.SetTabOrder("clpr_rut", 0)
		dw_1.Modify("clpr_rut.BackGround.Color = " + String(rgb(192,192,192)))
		dw_1.SetColumn("clpr_nrorut")
		dw_1.Object.buscadetalle.Enabled = False
		
	ELSEIF Istr_Mant.Argumento[1] = '5' THEN
		
		dw_1.Object.clpr_tipoan[il_fila] = 0
		dw_1.SetTabOrder("clpr_tipoan", 0)
		dw_1.SetTabOrder("clpr_nrorut", 0)
		dw_1.Modify("clpr_nrorut.BackGround.Color = " + String(rgb(192,192,192)))	
		dw_1.SetColumn("clpr_rut")
		dw_1.Object.buscadetalle.Enabled = False
		
	END IF	
END IF	

end event

event ue_deshace;call super::ue_deshace;dw_1.SetItem(il_fila, "clpr_rut", ias_campo[1])
dw_1.SetItem(il_fila, "clpr_nrorut", ias_campo[2])
dw_1.SetItem(il_fila, "clpr_nombre", ias_campo[3])
dw_1.SetItem(il_fila, "clpr_fantas", ias_campo[4])
dw_1.SetItem(il_fila, "clpr_direcc", ias_campo[5])
dw_1.SetItem(il_fila, "ciud_codigo", Integer(ias_campo[6]))
dw_1.SetItem(il_fila, "comu_codigo", Integer(ias_campo[7]))
dw_1.SetItem(il_fila, "clpr_telefo", ias_campo[8])
dw_1.SetItem(il_fila, "clpr_nrofax", ias_campo[9])
dw_1.SetItem(il_fila, "pais_codigo", integer(ias_campo[10]))
dw_1.SetItem(il_fila, "clpr_corint", integer(ias_campo[11]))
dw_1.SetItem(il_fila, "clpr_correo", integer(ias_campo[12]))
end event

event ue_antesguardar();call super::ue_antesguardar;String	ls_mensaje, ls_columna


IF Isnull(dw_1.GetItemString(il_fila, "clpr_rut")) or dw_1.GetItemString(il_fila, "clpr_rut") = "" THEN
	ls_mensaje = "Código Cliente Proveedor"
	ls_columna = "clpr_rut"
ELSEIF Istr_Mant.Argumento[1] = '1' THEN
	IF Isnull(dw_1.GetItemString(il_fila, "clpr_nrorut")) or dw_1.GetItemString(il_fila, "clpr_nrorut") = "" THEN
		ls_mensaje = "RUT Cliente Proveedor" 
		ls_columna = "clpr_nrorut"
	END IF
ELSEIF Isnull(dw_1.GetItemString(il_fila, "clpr_nombre")) or dw_1.GetItemString(il_fila, "clpr_nombre") = "" THEN
	ls_mensaje = "Nombre o Razón Social"								
	ls_columna = "clpr_nombre"
END IF

IF ls_columna <> "" THEN
	MessageBox("Error de Consistencia", "Falta el ingreso de " + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_columna)
	dw_1.SetFocus()
	Message.DoubleParm = -1
ELSE
	is_rut		= ''
	is_codigo	= ''
	is_rutrep	= ''
	is_rutrep2	= ''
END IF

end event

event open;x	= 100
y	= 450

This.Icon	=	Gstr_apl.Icono

PostEvent("ue_recuperadatos")

istr_mant = Message.PowerObjectParm

dw_1.GetChild("zona_codigo", idwc_zonas)
idwc_zonas.SetTransObject(sqlca)
idwc_zonas.Retrieve()

dw_1.GetChild("ciud_codigo", idwc_ciudades)
idwc_ciudades.SetTransObject(sqlca)
idwc_ciudades.Retrieve()

dw_1.GetChild("comu_codigo", idwc_comunas)
idwc_comunas.SetTransObject(sqlca)
idwc_comunas.InsertRow(0)

dw_1.SetTransObject(sqlca)
//istr_mant.dw.ShareData(dw_1)
end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_clienprove_casino
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_clienprove_casino
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_clienprove_casino
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_clienprove_casino
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_clienprove_casino
integer x = 2775
integer y = 364
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_clienprove_casino
integer x = 2775
integer y = 140
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_clienprove_casino
integer x = 2775
integer y = 588
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_clienprove_casino
integer x = 0
integer y = 0
integer width = 2619
integer height = 1468
string dataobject = "dw_mant_clienprove_detalle"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_Nula, ls_Columna
Integer  li_Nula

SetNull(ls_Nula)
SetNull(li_Nula)

ls_Columna	=	dwo.Name

CHOOSE CASE ls_Columna
			
	CASE "clpr_nrorut"
		is_rut = F_verrut(data, True)
		
		IF is_rut = ""  THEN
			This.SetItem(row, "clpr_nrorut", ls_Nula)
			RETURN 1
		ELSEIF This.Object.clpr_tipoan[1] = 1 THEN
			is_codigo	=	is_rut
			This.SetItem(row, "clpr_rut", is_rut)
		END IF
		
	CASE "clpr_rut"
		
		IF IsNumber(data) THEN
			is_codigo	=	String(Long(data), '000000')
		END IF
		
		This.SetItem(row, "clpr_rut", is_codigo)
		
	CASE "ciud_codigo"
		IF NoExisteCiudad(Integer(data)) THEN
		   This.SetItem(row, "ciud_codigo", Integer(ls_Nula))
		   RETURN 1
		ELSE	
			idwc_comunas.Retrieve(Integer(Data))
	   END IF
		
	CASE "comu_codigo"
		IF NoExisteComuna(Integer(data)) THEN
		   This.SetItem(row, "comu_codigo", Integer(ls_Nula))
		   RETURN 1			
	   END IF
		
	CASE "clpr_nomper", "clpr_apepat", "clpr_apemat"
		ArmaNombre(ls_Columna, data)
		
	CASE "clpr_rutrep"
		is_rutrep	=	F_verrut(data, True)
		
		IF is_rutrep = '' THEN
			This.SetItem(row, "clpr_rutrep", ls_Nula)
			RETURN 1
		END IF
		
	CASE "clpr_rutre2"
		
		is_rutrep2	=	F_verrut(data, True)
		
		IF is_rutrep2 = '' THEN
			This.SetItem(row, "clpr_rutre2", ls_Nula)
			RETURN 1
		END IF

	CASE "clpr_corint"
		if duplicadocorint(long(data)) then
			This.SetItem(row, "clpr_corint", li_Nula)
			RETURN 1
		end if
		
END CHOOSE

//HabilitaIngreso()
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;IF is_rut <> "" THEN
	IF dwo.Name = "clpr_nrorut" THEN
		This.Object.clpr_nrorut.EditMask.Mask = "XXXXXXXXXX"

		IF is_rut <> "" THEN
			This.SetItem(il_fila, "clpr_nrorut", String(Double(Mid(is_rut, 1, 9)), "#########") + Mid(is_rut, 10))
		END IF
	ELSE
		//This.Object.clpr_nrorut.EditMask.Mask = "###.###.###-!"
		This.SetItem(il_fila, "clpr_nrorut", is_rut)
	END IF
END IF


IF is_codigo <> "" THEN
	IF dwo.Name = "clpr_rut" THEN
		This.Object.clpr_rut.EditMask.Mask = "XXXXXXXXXX"

		IF is_codigo <> "" THEN
			This.SetItem(il_fila, "clpr_rut", String(Long(is_codigo), "######"))
		END IF
	ELSE
		//This.Object.clpr_nrorut.EditMask.Mask = "###.###.###-!"
		This.SetItem(il_fila, "clpr_rut", is_codigo)
	END IF	
//	IF dwo.Name = "clpr_rut" THEN
//		This.SetItem(il_fila, "clpr_rut", String(Long(is_codigo), "######"))
//	ELSE
//		This.SetItem(il_fila, "clpr_rut", is_codigo)
//	END IF
END IF

IF is_rutrep <> "" THEN
	IF dwo.Name = "clpr_rutrep" THEN
		IF is_rutrep <> "" THEN
			This.SetItem(il_fila, "clpr_rutrep", String(Double(Mid(is_rutrep, 1, 9)), "#########") + Mid(is_rutrep, 10))
		END IF
	ELSE
		This.SetItem(il_fila, "clpr_rutrep", is_rutrep)
	END IF	
END IF

IF is_rutrep2 <> "" THEN
	IF dwo.Name = "clpr_rutre2" THEN
		IF is_rutrep2 <> "" THEN
			This.SetItem(il_fila, "clpr_rutre2", String(Double(Mid(is_rutrep2, 1, 9)), "#########") + Mid(is_rutrep, 10))
		END IF
	ELSE
		This.SetItem(il_fila, "clpr_rutre2", is_rutrep2)
	END IF
END IF
end event

event dw_1::clicked;call super::clicked;String	ls_columna

ls_columna = dwo.name

CHOOSE CASE ls_columna
	CASE "buscacomuna"
		BuscaComuna()
	CASE "igualrut"	
		IgualRut()
END CHOOSE
end event

event dw_1::buttonclicked;String	ls_columna, ls_null

SetNull(ls_null)

ls_columna = dwo.name

CHOOSE CASE ls_columna
	CASE "buscadetalle"
		IF istr_mant.argumento[1] <> "" THEN
			istr_mant.argumento[2] = dw_1.Object.clpr_rut[row]
			istr_mant.argumento[1] = dw_1.Object.clpr_rut[row]
			istr_mant.argumento[3] = dw_1.Object.clpr_nombre[row]
			OpenWithParm(w_mant_mues_clienprovedire,istr_mant)
		END IF		
		
END CHOOSE
end event

