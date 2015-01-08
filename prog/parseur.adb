with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

package body Parseur is

	file : File_Type;

	procedure Get_Nombre_Sommets (filename : in String; Nombre_Sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file,Nombre_Sommets);
	end ;

end Parseur ;
