with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

package body Parseur is

	file : File_Type;

	procedure Lecture_En_Tete (filename : in String; Sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file,Sommets);
		Put("Il y a ") ; Put(Sommets) ; Put(" Sommets.");
	end;

	procedure Lecture (filename : in String; Sommets : in Natural; Tableau : in out Table) is
		X, Y : Float ;
	begin
		--for i in 1..NombreSommets/3 loop
		Tableau(1) := new Sommet;
		Tableau(1).all.Coord := new Point;
		Get(file, X);
		Get(file, Y);	
		--Table(1).all.Coord.all.X := X;
		--end loop;
	end;

end Parseur;
