with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

package body Parseur is

	file : File_Type;

	procedure lectureEnTete (filename : in String; sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file, sommets);
	--	Put("Il y a ") ; Put(sommets, Width => 0) ; Put(" Sommets.");
	end;

	procedure Lecture (filename : in String; sommets : in Natural; Figure : in out Graphe) is
	begin
		for i in 1..sommets loop
			Get(file, Figure(i).all.Coord.all.X);
			Get(file, Figure(i).all.Coord.all.Y);
			Get(file, Figure(i).all.connexions);

			Figure(i).all.Liens := new Liaisons (1 .. Figure(i).all.connexions);
			for j in 1..Figure(i).all.connexions loop
				Get(file, Figure(i).all.Liens.all(j));
			end loop;
		end loop;
	end;

end Parseur;
