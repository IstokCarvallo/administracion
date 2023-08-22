$PBExportHeader$nvo_sizeof.sru
$PBExportComments$No visual user object que implementa la function SizeOf
forward
global type nvo_sizeof from nonvisualobject
end type
end forward

global type nvo_sizeof from nonvisualobject autoinstantiate
end type

type variables
Private:
CONSTANT Integer SIZE_BOOLEAN	= 1	// Boolean
CONSTANT Integer SIZE_CHAR		= 1	// Char
CONSTANT Integer SIZE_INT		= 2	// Signed integer
CONSTANT Integer SIZE_UINT		= 2	// Unsigned integer
CONSTANT Integer SIZE_LONG 	= 4	// Signed Long
CONSTANT Integer SIZE_ULONG 	= 4	// Unsigned Long
CONSTANT Integer SIZE_STRING 	= 4	// Assume as string pointer

// Supported DataTypes
integer 	INTEGER
uint 	UINT
long 	LONG
ulong 	ULONG
char 	CHAR
string 	STRING
boolean 	BOOLEAN

end variables

forward prototypes
public function long sizeof (long data)
public function long sizeof (ulong data)
public function long sizeof (integer data)
public function long sizeof (uint data)
public function long sizeof (character data)
public function long sizeof (string data)
public function long sizeof (boolean data)
public function long sizeof (powerobject data)
private function long sizeof (variabledefinition vardef[])
public function long sizeof (any data[])
end prototypes

public function long sizeof (long data);Return(SIZE_LONG)
end function

public function long sizeof (ulong data);Return(SIZE_ULONG)
end function

public function long sizeof (integer data);Return(SIZE_INT)
end function

public function long sizeof (uint data);Return(SIZE_UINT)
end function

public function long sizeof (character data);Return(SIZE_CHAR)
end function

public function long sizeof (string data);Return(SIZE_STRING)
end function

public function long sizeof (boolean data);Return(SIZE_BOOLEAN)
end function

public function long sizeof (powerobject data);ClassDefinition ClassDef
VariableDefinition VarDef[]

ClassDef = Data.ClassDefinition
VarDef	= ClassDef.VariableList

Return(SizeOf(VarDef))

end function

private function long sizeof (variabledefinition vardef[]);long ll_Index, ll_Count, ll_Size, ll_Array = 0
ClassDefinition TypeInfo
VariableDefinition VarList[]
VariableCardinalityDefinition VarCarDef
ArrayBounds ArrBounds[]

ll_Count = Upperbound(VarDef)

For ll_Index = 2 To ll_Count
	
	VarCarDef = VarDef[ll_Index].Cardinality
	ArrBounds = VarCarDef.ArrayDefinition
	
	If Upperbound(ArrBounds) > 0 Then 
		ll_Array = ArrBounds[1].UpperBound 
	Else 
		ll_Array = 1
	End If

	Choose Case VarDef[ll_Index].TypeInfo.DataTypeOf
		Case "long"
			ll_Size += SizeOf(LONG) * ll_Array
		Case "ulong","unsignedlong"
			ll_Size += SizeOf(ULONG) * ll_Array
		Case "int","integer"
			ll_Size += SizeOf(INTEGER) * ll_Array
		Case "uint","unsignedint","unsignedinteger"
			ll_Size += SizeOf(UINT) * ll_Array
		Case "char","character"
			ll_Size += SizeOf(CHAR)  * ll_Array
		Case "string"
			ll_Size += SizeOf(STRING) * ll_Array
		Case "structure"
			TypeInfo = VarDef[ll_Index].TypeInfo
			VarList  = TypeInfo.VariableList
			ll_Size += SizeOf(VarList)
		Case Else
			MessageBox("El tipo de error de SizeOf no Soporta","posiblemente el tipo clasificado o el objeto variable!",StopSign!,Ok!)
			Return(-1)
	End Choose
	
Next

Return(ll_Size)
end function

public function long sizeof (any data[]);long ll_Index, ll_Count, ll_Size = 0

ll_Count = UpperBound(Data)

FOR ll_Index = 1 TO ll_Count

	CHOOSE CASE ClassName(Data[ll_Index])
		CASE "long"
			ll_Size += SizeOf(LONG)
		CASE "unsignedlong","ulong"
			ll_Size += SizeOf(ULONG)
		CASE "int","integer"
			ll_Size += SizeOf(INTEGER) 
		CASE "uint","unsignedinteger","unsignedint"
			ll_Size += SizeOf(UINT)
		CASE "char", "character"
			ll_Size += SizeOf(CHAR)
		CASE "string"
			ll_Size += SizeOf(CHAR) * SizeOf(String(Data[ll_Index]))
		CASE "boolean"
			ll_Size += SizeOf(BOOLEAN) 
	END CHOOSE

NEXT

RETURN(ll_Size)
end function

on nvo_sizeof.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_sizeof.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

