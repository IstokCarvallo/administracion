$PBExportHeader$uo_coneccion.sru
$PBExportComments$Objeto de conecciones
forward
global type uo_coneccion from nonvisualobject
end type
end forward

global type uo_coneccion from nonvisualobject
end type
global uo_coneccion uo_coneccion

type variables
String		DBMS, ODBC, Usuario, Password, Servidor, Base, Provider, Empresa
Boolean	Conectado
end variables

forward prototypes
public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion)
public subroutine of_conecta (ref transaction at_tran, integer ia_codigo)
end prototypes

public function boolean of_existe (integer ai_codigo, boolean ab_mensaje, transaction at_transaccion);Boolean	lb_Retorno = True

Select empr_nodbms, empr_idodbc, empr_nomusu,
		empr_passwo, empr_nomser, empr_nombas, 
		empr_driver = IsNUll(empr_driver, 'SQLNCLI11'),
		empr_rutemp
	INTO	:DBMS, :ODBC, :Usuario, :Password, :Servidor, :Base, :Provider, :Empresa
	From dbo.contempresascons
	Where empr_codigo = :ai_codigo
	USING	at_Transaccion;
	
If at_Transaccion.SQLCode = -1 Then
	F_ErrorBaseDatos(at_Transaccion, "Lectura de Tabla de Conecciones")
	lb_Retorno	=	False
ElseIf at_Transaccion.SQLCode = 100 Then
	lb_Retorno	=	False

	If ab_Mensaje Then
		MessageBox("Atención", "No Existe el Coneccion " + String(ai_Codigo) + &
					", no ha sido Ingresado.~r~rIngrese o seleccione otro Código.")	
	End If
End If

Return lb_Retorno
end function

public subroutine of_conecta (ref transaction at_tran, integer ia_codigo);String		ls_DBParm

SetPointer(HourGlass!)

DISCONNECT USING at_Tran;			

If of_Existe(ia_Codigo, True, SQLCA) Then

	at_Tran.Dbms			=	DBMS
	at_Tran.ServerName	=	Servidor
	at_Tran.DataBase		=	Base
	
	If DBMS = "ODBC" Then
			at_Tran.DbParm		=	"Connectstring='DSN=" + ODBC + "; UID=" + Usuario  + "; PWD=" + Password + "'// ;" + &
											"ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT' PBUseProcOwner = "  + '"Yes"'
	ElseIf Dbms = 'OLEDB' Then
		at_Tran.LogId   		= Usuario
		at_Tran.LogPass 		= Password
		at_Tran.Autocommit	= True
		
		If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm

		ls_DBParm = "PROVIDER='" + Provider + "',PROVIDERSTRING='database="+Base + "'," + &
					 "DATASOURCE='"+ Servidor +"'" + ls_DbParm
				
		at_Tran.DbParm = ls_DbParm
	ElseIf Mid(Dbms,1,3) = 'SNC' or Mid(Dbms,1,9) = 'TRACE SNC' Then
		at_Tran.LogId  	 		= Usuario
		at_Tran.LogPass  		= Password
		at_Tran.Autocommit	= True
			
		If Len(Trim(ls_DBParm)) > 0 Then ls_DbParm = ","+ls_DbParm
		
		ls_Dbparm = "Provider='" + Provider + "',Database='"+ Base + "'" + ls_DbParm + ",TrimSpaces=1,"
			
		at_Tran.DBParm = ls_Dbparm
	ElseIf	Dbms = "ADO.Net" Then
		at_Tran.DBMS 			= "ADO.Net"
		at_Tran.LogId			=	Usuario
		at_Tran.LogPass		=	Password
		at_Tran.Autocommit	=	True
		at_Tran.DBParm 		= "DataSource='" + Servidor + "',Database='" + Base + "',Namespace='System.Data.OleDb',Provider='SQLNCLI10'"
	Else
		at_Tran.LogId			=	Usuario
		at_Tran.LogPass		=	Password
		at_Tran.Autocommit	=	True
	End If
		
	CONNECT USING at_Tran;
	
	If at_Tran.SQLCode = 0 Then
		Conectado	=	True
	Else
		Conectado	=	False
		F_ErrorBaseDatos(at_Tran, "")
	End If
Else
	Conectado	=	False
End If

SetPointer(Arrow!)

end subroutine

on uo_coneccion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_coneccion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

