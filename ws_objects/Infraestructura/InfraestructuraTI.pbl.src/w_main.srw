$PBExportHeader$w_main.srw
forward
global type w_main from w_principal
end type
end forward

global type w_main from w_principal
windowtype windowtype = mdi!
string icon = "AppIcon!"
windowanimationstyle openanimation = topslide!
end type
global w_main w_main

event open;call super::open;Integer	li_cantidad
Menu		m_menu

m_menu	= m_principal


//rbb_1.ImportFromXMLFile("\Desarrollo 19\RIOblanco.xml") //function "LoadFile" is deleted 


end event

on w_main.create
call super::create
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

