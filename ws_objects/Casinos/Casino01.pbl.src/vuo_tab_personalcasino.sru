$PBExportHeader$vuo_tab_personalcasino.sru
forward
global type vuo_tab_personalcasino from userobject
end type
type dw_2 from uo_dw within vuo_tab_personalcasino
end type
type dw_1 from uo_dw within vuo_tab_personalcasino
end type
end forward

global type vuo_tab_personalcasino from userobject
integer width = 2167
integer height = 1564
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_resize pbm_size
dw_2 dw_2
dw_1 dw_1
end type
global vuo_tab_personalcasino vuo_tab_personalcasino

type variables
Datawindow							dw_3, dw_4

w_maed_rgtopersonalcolacion	iw_me

uo_areas								iuo_area
uo_centrocosto						iuo_ccosto

Integer								ii_zona, ii_area
end variables

forward prototypes
public subroutine filtra ()
public subroutine referencias (window aw_me, integer ai_zona, integer ai_area)
end prototypes

event ue_resize;This.width		=	newwidth
This.Height		=	newheight

dw_1.width		=	newwidth  - 9
dw_1.Height		=	newheight - dw_2.Height - 9
end event

public subroutine filtra ();Integer	li_fila

dw_1.SetFilter("zona_codigo = " + String(ii_zona) + " AND " + &
					"caar_codigo = " + String(ii_area))					
dw_1.Filter()

dw_1.SetSort("zona_codigo asc, caar_codigo asc, cape_usuari asc")
dw_1.Sort()

dw_2.SetFilter("caar_codigo = " + String(ii_area))
dw_2.Filter()
IF dw_2.RowCount() = 0 THEN
	dw_2.InsertRow(0)
END IF

dw_2.Object.caar_codigo[1]	=	ii_area
dW_2.Object.zona_codigo[1]	=	ii_zona
end subroutine

public subroutine referencias (window aw_me, integer ai_zona, integer ai_area);iw_me	=	Create w_maed_rgtopersonalcolacion
iw_me	=	aw_me
ii_zona	=	ai_zona
ii_area	=	ai_area

iw_me.dw_1.Sharedata(dw_1)
iw_me.dw_5.Sharedata(dw_2)

end subroutine

on vuo_tab_personalcasino.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.dw_2,&
this.dw_1}
end on

on vuo_tab_personalcasino.destroy
destroy(this.dw_2)
destroy(this.dw_1)
end on

event constructor;dw_2.SetTransObject(sqlca)
dw_2.InsertRow(0)

iuo_area			=	Create uo_areas
iuo_ccosto		=	Create uo_centrocosto
end event

type dw_2 from uo_dw within vuo_tab_personalcasino
integer y = 8
integer width = 2066
integer height = 248
integer taborder = 10
string dragicon = "\Desarrollo\Bmp\Row.ico"
string dataobject = "dw_encab_casino_areas"
boolean vscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;Integer	li_nula, li_find, li_fila

SetNull(li_nula)

CHOOSE CASE dwo.name
	CASE "caar_codigo"
		IF iuo_area.Existe(ii_zona, Integer(data), False, sqlca) THEN
			FOR li_fila = 1 TO dw_1.FilteredCount()
				IF dw_1.Object.caar_codigo.Filter[li_fila] = Integer(data) THEN
					MessageBox("Advertencia", "El area ya ha sido ingresada", Exclamation!)
					This.Object.caar_codigo[row]	=	li_nula
					Return 1
				END IF
			NEXT
			
			This.SetFilter("caar_codigo = " + Data)
			This.Filter()
			
			ii_area									=	Integer(data)
		ELSE
			IF MessageBox("Advertencia", "El area ingresada no existe, desea Crearla?", Question!, YesNo!) = 1 THEN
				ii_area								=	Integer(data)
			ELSE
				This.Object.caar_codigo[row]	=	li_nula
				Return 1
			END IF
			
		END IF 
		
	CASE "ccos_codigo"
		IF NOT iuo_ccosto.Existe(Integer(data), True, sqlca) THEN
			This.Object.ccos_codigo[row]	=	li_nula
			Return 1
		END IF
		
END CHOOSE
end event

event itemerror;Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String	ls_nombre

IF row < 1 THEN RETURN

ls_nombre	=	This.Object.caar_nombre[row]

IF IsValid(iw_me) AND LEN(ls_nombre) > 0 THEN
	iw_me.rescatanombre(ls_nombre)
END IF
end event

event losefocus;call super::losefocus;String	ls_nombre

IF This.RowCount() < 1 THEN RETURN

ls_nombre	=	This.Object.caar_nombre[This.GetRow()]

IF IsValid(iw_me) AND LEN(ls_nombre) > 0 THEN
	iw_me.rescatanombre(ls_nombre)
END IF
end event

event getfocus;call super::getfocus;String	ls_nombre

IF This.RowCount() < 1 THEN RETURN

ls_nombre	=	This.Object.caar_nombre[This.GetRow()]

IF IsValid(iw_me) AND LEN(ls_nombre) > 0 THEN
	iw_me.rescatanombre(ls_nombre)
END IF
end event

type dw_1 from uo_dw within vuo_tab_personalcasino
event ue_mousemove pbm_mousemove
integer y = 260
integer width = 2158
integer height = 1280
integer taborder = 10
string dragicon = "\Desarrollo\Bmp\Row.ico"
boolean bringtotop = true
boolean titlebar = true
string title = "Personal Area"
string dataobject = "dw_mues_casino_personacolacion"
boolean hscrollbar = true
end type

event ue_mousemove;IF This.IsSelected(GetRow()) AND message.WordParm = 1 THEN
	This.Drag(begin!)
END IF
end event

event dragdrop;call super::dragdrop;DataWindow	ldw_Source
Long			ll_nueva, ll_source
String			ls_nombre, ls_codigo
Integer		li_fila

ll_nueva	=	0
If Source.typeof() = DataWindow! Then
	ldw_Source = Source
	
	If Source = iw_me.dw_6 Then
		ll_source	=	iw_me.dw_6.GetRow()
		If ii_area = 0 OR IsNull(ii_area) Then
			MessageBox("Error", "Debe ingresar datos del area antes de asignar personal.", Exclamation!)
			Return 
		End If

		FOR li_fila	=	1 TO This.RowCount()
			If This.Object.cape_codigo[li_fila]	=	iw_me.dw_6.Object.pers_rutemp[ll_source] Then
				MessageBox("Error", "El personal seleccionado ya pertenece a Este Grupo", Exclamation!)
				Return 
			End If
		NEXT
		
		FOR li_fila = 1 TO This.FilteredCount()
			ls_codigo	 =	This.GetItemString(li_fila, "cape_codigo", Filter!, True)
			
			If ls_codigo = iw_me.dw_6.Object.pers_rutemp[ll_source] Then 
				MessageBox("Error", "El personal seleccionado pertenece a Otro Grupo", Exclamation!)
				Return 
			End If
		NEXT
		
		ll_nueva	=	This.InsertRow(0)
		This.Object.cape_apepat[ll_nueva]	=	iw_me.dw_6.Object.pers_apepat[ll_source]
		This.Object.cape_apemat[ll_nueva]	=	iw_me.dw_6.Object.pers_apemat[ll_source]
		This.Object.cape_nombre[ll_nueva]	=	iw_me.dw_6.Object.pers_nombre[ll_source]
		This.Object.cape_codigo[ll_nueva]		=	iw_me.dw_6.Object.pers_codigo[ll_source]
		
		ls_Nombre		=	Mid(iw_me.dw_6.Object.pers_nombre[ll_source], 1, Pos(iw_me.dw_6.Object.pers_nombre[ll_source], ' ') - 1)
			
		This.Object.cape_usuari[ll_nueva]	=	Trim(ls_Nombre) + '.' +&
																  Trim(iw_me.dw_6.Object.pers_apepat[ll_source])
		This.Object.empr_codigo[ll_nueva]	=	iw_me.dw_6.Object.empr_codigo[ll_source]
		
		This.Object.cape_tipope[ll_nueva]		=	0
		This.Object.cape_invita[ll_nueva]		=	0
		This.Object.cape_topein[ll_nueva]		=	0
		This.Object.cape_pedcas[ll_nueva]	=	0
		This.Object.cape_ctacte[ll_nueva]		=	0
		
		This.Object.zona_codigo[ll_nueva]		=	ii_zona
		This.Object.caar_codigo[ll_nueva]		=	ii_area
		This.Object.control[ll_nueva]			=	0
		
		ldw_Source.DeleteRow(ldw_Source.GetRow())
		ldw_Source.SelectRow(ldw_Source.GetRow(), False)
		Return
	End If
Else
	Return
End If

end event

event clicked;call super::clicked;IF row > 0 THEN
	This.SetRow(row)
	This.SelectRow(0, False)
	This.SelectRow(row, True)
END IF
end event

