$PBExportHeader$w_mant_deta_empresasconexion.srw
forward
global type w_mant_deta_empresasconexion from w_mant_detalle
end type
end forward

global type w_mant_deta_empresasconexion from w_mant_detalle
integer width = 2574
integer height = 1628
string title = "Conexiones Personal"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
end type
global w_mant_deta_empresasconexion w_mant_deta_empresasconexion

type variables
String	is_cuenta

DataWindowChild	ddlb_empresas


end variables

forward prototypes
public subroutine habilitacolumnas (boolean habilita)
public function boolean noexistecuenta (string ls_cuenta)
public function boolean noexistemoneda (string ls_codigo)
public function boolean noexistegrupo (integer zona_grupo)
public function boolean duplicado (string columna, string valor)
end prototypes

public subroutine habilitacolumnas (boolean habilita);IF Habilita THEN
	dw_1.SetTabOrder("item_descom",40)
	dw_1.SetTabOrder("pcta_cuenta",50)
	dw_1.SetTabOrder("item_codbar",60)
	dw_1.SetTabOrder("mone_codigo",70)
	dw_1.SetTabOrder("unme_codexi",80)
	dw_1.SetTabOrder("unme_codcom",90)
	dw_1.SetTabOrder("item_codara",100)
	dw_1.SetTabOrder("item_faccom",110)
	dw_1.SetTabOrder("item_compon",120)
	dw_1.SetTabOrder("item_tipmer",130)
	dw_1.Modify("item_descom.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("pcta_cuenta.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("plancuenta_pcta_descri.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("item_codbar.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("mone_codigo.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("unme_codexi.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("unme_codcom.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("item_codara.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("item_faccom.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("item_compon.BackGround.Color = " + String(rgb(255,255,255)))
	dw_1.Modify("item_tipmer.BackGround.Color = " + String(rgb(255,255,255)))
ELSE
	dw_1.SetTabOrder("item_descom",0)
	dw_1.SetTabOrder("pcta_cuenta",0)
	dw_1.SetTabOrder("item_codbar",0)
	dw_1.SetTabOrder("mone_codigo",0)
	dw_1.SetTabOrder("unme_codexi",0)
	dw_1.SetTabOrder("unme_codcom",0)
	dw_1.SetTabOrder("item_codara",0)
	dw_1.SetTabOrder("item_faccom",0)
	dw_1.SetTabOrder("item_compon",0)
	dw_1.SetTabOrder("item_tipmer",0)
	dw_1.Modify("item_descom.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("pcta_cuenta.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("plancuenta_pcta_descri.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("item_codbar.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("mone_codigo.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("unme_codexi.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("unme_codcom.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("item_codara.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("item_faccom.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("item_compon.BackGround.Color = " + String(Rgb(192,220,192)))
	dw_1.Modify("item_tipmer.BackGround.Color = " + String(Rgb(192,220,192)))
END IF
end subroutine

public function boolean noexistecuenta (string ls_cuenta);String	ls_nombre

SELECT	pcta_descri
INTO		:ls_nombre
	FROM	dbo.PLANCUENTA 
	WHERE	pcta_cuenta = :ls_cuenta ;
	
IF sqlca.SQLCode = -1 THEN
	F_ErrorBaseDatos(sqlca,'Lectura de la Tabla plancuenta')
	RETURN True
ELSEIF sqlca.SQLCode = 100 THEN
	MessageBox('Atención', 'Código de Item no ha sido creado, Ingrese otro Codigo.', Exclamation!, OK!)
	RETURN True
ELSE
	dw_1.SetItem(il_fila,"pcta_cuenta", ls_cuenta)
	dw_1.SetItem(il_fila,"plancuenta_pcta_descri", ls_nombre)
	RETURN False
END IF
end function

public function boolean noexistemoneda (string ls_codigo);Integer	li_codigo
String	ls_nombre

li_codigo = Integer(ls_codigo)

SELECT	mone_nombre
INTO		:ls_nombre
	FROM	dbo.MONEDAS
	WHERE	mone_codigo = :li_codigo ;
	
IF sqlca.SQLCode = -1 THEN
	F_ErrorBaseDatos(sqlca,"Lectura de la Tabla monedas")
	RETURN True
ELSEIF sqlca.SQLCode = 100 THEN
	MessageBox("Atención", "Código de Moneda no ha sido creado, Ingrese otro Codigo.", Exclamation!, OK!)
	RETURN True
ELSE
	dw_1.SetItem(il_fila,"mone_codigo", li_codigo)
	RETURN False
END IF
end function

public function boolean noexistegrupo (integer zona_grupo);String	zona_nombre

IF IsNull(zona_grupo) = False AND zona_grupo > 0 THEN
	SELECT	zona_nombre INTO :zona_nombre
		FROM	dbo.ZONAS
		WHERE	zona_codigo = :zona_grupo ;
		
	IF sqlca.SQLCode =-1 THEN
		F_ErrorBaseDatos(sqlca,"Lectura de la Tabla zonas")
		RETURN False
	ELSEIF sqlca.SQLCode = 100 THEN
		MessageBox("Atención","Codigo de Grupo no ha sido Creado. Ingrese otro Codigo.",	Exclamation!, OK!)
		RETURN True
	ELSE
		RETURN False
	END IF
ELSE
	RETURN False
END IF


end function

public function boolean duplicado (string columna, string valor);Long     ll_Fila                              
Integer	li_Empresa

li_Empresa	=	Integer(valor)

ll_fila  = istr_mant.dw.Find("empr_codigo = " + String(li_Empresa), 1,istr_mant.dw.RowCount())
						  

If ll_fila > 0 and ll_fila <> il_FilaAnc Then 
	MessageBox("Error","Código de Empresa ya fue ingresado",Information!, OK!)
	Return True
Else	
	Return False
End If

end function

on w_mant_deta_empresasconexion.create
call super::create
end on

on w_mant_deta_empresasconexion.destroy
call super::destroy
end on

event ue_recuperadatos;call super::ue_recuperadatos;ias_campo[1]	= String(dw_1.Object.empr_codigo[il_fila])
ias_campo[2]	= dw_1.Object.empr_nombre[il_fila]
ias_campo[3]	= dw_1.Object.empr_abrevi[il_fila]

If istr_mant.Agrega = False Then 
	dw_1.Object.empr_codigo.Protect = 1
	dw_1.Object.empr_codigo.BackGround.Color = 553648127
	dw_1.Object.empr_codigo.Color = RGB(255,255,255)
End If

dw_1.Setfocus()
end event

event ue_deshace;call super::ue_deshace;IF UpperBound(ias_campo) > 0 THEN

   dw_1.SetItem(il_fila, "empr_codigo",   Integer(ias_campo[1]))
	dw_1.SetItem(il_fila, "empr_nombre",   ias_campo[2])
   dw_1.SetItem(il_fila, "empr_abrevi",   ias_campo[3])

END IF
end event

event ue_antesguardar;call super::ue_antesguardar;Integer	li_cont
String	ls_mensaje, ls_colu[]

IF Isnull(dw_1.Object.empr_codigo[il_fila]) OR dw_1.Object.empr_codigo[il_fila] = 0 THEN
	li_cont ++
	ls_mensaje 			= ls_mensaje + "~nCódigo de Empresa"
	ls_colu[li_cont]	= "empr_codigo"
END IF

IF Isnull(dw_1.Object.empr_nombre[il_fila]) OR dw_1.Object.empr_nombre[il_fila] = "" THEN
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nNombre de la Empresa"
	ls_colu[li_cont]	= "empr_nombre"
END IF

IF Isnull(dw_1.Object.empr_abrevi[il_fila]) OR dw_1.Object.empr_abrevi[il_fila] = "" THEN
	li_cont ++
	ls_mensaje			= ls_mensaje + "~nAbreaviación"
	ls_colu[li_cont]	= "empr_abrevi"
END IF

IF li_cont > 0 THEN
	MessageBox("Error de Consistencia", "Falta el ingreso de :" + ls_mensaje + ".", StopSign!, Ok!)
	dw_1.SetColumn(ls_colu[1])
	dw_1.SetFocus()
	Message.DoubleParm = -1
END IF

end event

type pb_ultimo from w_mant_detalle`pb_ultimo within w_mant_deta_empresasconexion
end type

type pb_siguiente from w_mant_detalle`pb_siguiente within w_mant_deta_empresasconexion
end type

type pb_anterior from w_mant_detalle`pb_anterior within w_mant_deta_empresasconexion
end type

type pb_primero from w_mant_detalle`pb_primero within w_mant_deta_empresasconexion
end type

type pb_cancela from w_mant_detalle`pb_cancela within w_mant_deta_empresasconexion
integer x = 2190
integer y = 324
end type

type pb_acepta from w_mant_detalle`pb_acepta within w_mant_deta_empresasconexion
integer x = 2190
integer y = 108
end type

type pb_salir from w_mant_detalle`pb_salir within w_mant_deta_empresasconexion
integer x = 2190
integer y = 580
end type

type dw_1 from w_mant_detalle`dw_1 within w_mant_deta_empresasconexion
integer x = 91
integer y = 96
integer width = 1989
integer height = 1372
string dataobject = "dw_mant_empresasconexion"
end type

event dw_1::itemchanged;call super::itemchanged;String	ls_columna

ls_columna = dwo.Name

CHOOSE CASE ls_columna
	CASE "empr_codigo"
		IF Duplicado(ls_columna, data) THEN
			This.SetItem(il_fila, ls_columna, Integer(ias_campo[1]))
			RETURN 1
		END IF

END CHOOSE
end event

