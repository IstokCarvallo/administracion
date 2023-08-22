$PBExportHeader$uo_empresa.sru
$PBExportComments$uo que Chequea la Existencia de Empresas
forward
global type uo_empresa from nonvisualobject
end type
end forward

global type uo_empresa from nonvisualobject
end type
global uo_empresa uo_empresa

type variables
Integer 		Codigo
String  		Rut, RazonSocial, Direccion, Nombre,  Abreviacion, ODBC, NombreBase, Usuario, Password, DBMS, Servidor, Provider
end variables

forward prototypes
public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_existeconexion (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public function boolean of_conecta (ref transaction at_tran)
public function boolean of_desconecta (ref transaction at_tran)
end prototypes

public function boolean existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	empr_codigo, empr_nrorut, empr_razsoc, empr_direcc
	INTO	:Codigo, :Rut, :RazonSocial, :Direccion
	FROM	dbo.Empresa
	WHERE	empr_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Empresas")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de empresa (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

public function boolean of_existeconexion (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

SELECT	empr_nombre, empr_abrevi, empr_idodbc, empr_nombas, empr_nomusu, empr_passwo, empr_nodbms, empr_nomser, empr_provider
	INTO	:Nombre, :Abreviacion, :ODBC, :NombreBase, :Usuario, :Password, :DBMS, :Servidor, :Provider
	FROM	dbo.EmpresaConexion
	WHERE	empr_codigo	=	:ai_codigo
	USING	at_Transaccion;

If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla Empresas")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then 
	If ab_Mensaje Then
		MessageBox("Atención", "Código de Conexion de Empresa (" + String(ai_codigo, '000') + "), no ha sido creado en tabla respectiva.~r~r" + &
						"Ingrese o seleccione otro(s) Código(s).")
	End If
	lb_Retorno	=	False
End If

RETURN lb_Retorno

end function

public function boolean of_conecta (ref transaction at_tran);SetPointer(HourGlass!)

String		ls_DbParm, ls_Provider
Boolean	lb_Retorno = True

at_Tran.SQLCode		=	1
ls_Provider				=	ProfileString(gstr_apl.ini, is_base, "Provider", "SQLNCLI10")
at_Tran.DBMS 			= 	DBMS
at_Tran.ServerName	=	Servidor
at_Tran.DataBase		=	NombreBase
	
If Dbms = "ODBC" Then
	at_Tran.DbParm	=	"ConnectString='DSN=" + ODBC + &
							";UID=" + Usuario + &
							";PWD=" + Password + "',DisableBind=1," + &
							"ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT'" + "// ;PBUseProcOwner = " + '"Yes"'
							
ElseIf Dbms = 'OLEDB' Then	
	at_Tran.LogId   	= Usuario
	at_Tran.LogPass  = Password
	at_Tran.Autocommit = True
	
	If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm
	ls_DBParm = "PROVIDER='" + ls_Provider +"',PROVIDERSTRING='database="+ NombreBase +"',"+&
				 "DATASOURCE='"+ Servidor  +"'"+ls_DbParm
			
	at_Tran.DbParm = ls_DbParm
ElseIf Mid(Dbms,1,3) = 'SNC' or Mid(Dbms,1,9) = 'TRACE SNC' Then
	at_Tran.LogId   	= Usuario
	at_Tran.LogPass  = Password
	at_Tran.Autocommit = True
		
	If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm
	ls_Dbparm = "Provider='"+ ls_Provider +"',Database='"+NombreBase+"'"+ls_DbParm+",TrimSpaces=1"
		
	at_Tran.DBParm = ls_Dbparm
ElseIf Mid(Dbms,1, 10) = 'MSOLEDBSQL'  Then
	at_Tran.LogPass 		= Password
	at_Tran.LogId 			= Usuario
	at_Tran.AutoCommit	= False
	at_Tran.DBParm = "Database='"+NombreBase+"'"+ls_DbParm+",TrimSpaces=1"
ElseIf	Dbms = "ADO.Net" Then
	at_Tran.LogId			=	Usuario
	at_Tran.LogPass		=	Password
	at_Tran.Autocommit	=	True
	at_Tran.DBParm 	= "DataSource='" + Servidor + "',Database='" +NombreBase + "',Namespace='System.Data.OleDb',Provider='" + ls_Provider + "'"
Else
	at_Tran.LogId			=	Usuario
	at_Tran.LogPass		=	Password
	at_Tran.Autocommit	=	True
End If

DO
	CONNECT Using at_Tran ; 

	If at_Tran.SQLDBCode <> 0 Then lb_Retorno = False
	
LOOP UNTIL at_Tran.SQLCode <> 0

Return lb_Retorno

SetPointer(Arrow!)
end function

public function boolean of_desconecta (ref transaction at_tran);SetPointer(HourGlass!)

DISCONNECT Using at_Tran ; 

SetPointer(Arrow!)

Return True
end function

on uo_empresa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_empresa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

