with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

package body Parseur is

	file : File_Type;

	procedure Lecture_En_Tete (filename : in String; Sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file, Sommets);
		--Put("Il y a ") ; Put(Sommets, Width => 0) ; Put(" Sommets.");
	end;

	procedure Lecture (filename : in String; Sommets : in Natural; Tableau : in out Table) is
		Nb_Liaisons : Integer ;
	begin
		for i in 1..Sommets loop
			Get(file, Tableau(i).all.Coord.all.X);
			Get(file, Tableau(i).all.Coord.all.Y);
			Get(file, Nb_Liaisons);
			Tableau(i).all.Connexions := Nb_Liaisons;
			Tableau(i).all.Liens := new Liaisons (1 .. Nb_Liaisons);
			for j in 1..Nb_Liaisons loop
				Get(file, Tableau(i).all.Liens.all(j));
			end loop;
		end loop;
	end;

end Parseur;
