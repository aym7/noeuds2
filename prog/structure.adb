with Ada.Command_Line;
use Ada.Command_Line;

with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

with svg;
use svg;

with Parseur;

procedure Structure is
	Nombre_Sommets : Natural;
begin

	if Argument_Count /= 1 then
		Put_Line(Standard_Error, "utilisation : ./structure graph.kn");
		return ;
	end if;

	Parseur.Get_Nombre_Sommets(Argument(1), Nombre_Sommets);

	end ;
