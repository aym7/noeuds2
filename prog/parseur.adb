with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

package body Parseur is

	file : File_Type;

	procedure Lecture_En_Tete (filename : in String; Sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file, Sommets); Skip_Line ;
		Put("Il y a ") ; Put(Sommets, Width => 0) ; Put(" Sommets.");
	end;

	procedure Lecture (filename : in String; Sommets : in Natural; Tableau : in out Table) is
		Nb_Liaisons : Integer ;
	begin
		for i in 1..Sommets/3 loop
			Tableau(i) := new Sommet;
			Tableau(i).all.Coord := new Point;
			Get(file, Tableau(i).all.Coord.all.X); Skip_Line ;
			Get(file, Tableau(i).all.Coord.all.Y); Skip_Line ;
			Get(file, Nb_Liaisons); Skip_Line;
			Tableau(i).all.Connexions := Nb_Liaisons;
			Tableau(i).all.Liens := new Liaisons (i .. Nb_Liaisons);
			for j in i..Nb_Liaisons loop
				Get(file, Tableau(i).all.Liens.all(j));
			end loop;
		end loop;
	end;

end Parseur;
