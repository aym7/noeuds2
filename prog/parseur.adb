with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Geometry; use Geometry;

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

			Figure(i).all.Reseaux := new Liaisons (1 .. Figure(i).all.connexions);
			for j in 1..Figure(i).all.connexions loop
				Get(file, Figure(i).all.Reseaux.all(j).Numero);
			end loop;
		end loop;
	end;

	procedure GetMilieux (sommets : in Natural ; Figure : in out Graphe) is
		P1, P2 : Point ;
	begin
		for i in 1..sommets loop
			P1 := Figure(i).all.Coord.all ;
			for j in 1..Figure(i).all.Connexions loop
				P2 := Figure(Figure(i).all.Reseaux.all(j).Numero).all.Coord.all ;
					Figure(i).all.Reseaux.all(j).Pointeur := new Arete;
				if Figure(i).all.Reseaux.all(j).Numero > i then
					Figure(i).all.Reseaux.all(j).Pointeur.all.Milieu := (P1+P2)*0.5 ;
				end if;
			end loop;
		end loop;
	end ;

	procedure GetCroix (sommets : in Natural ; Figure : in out Graphe) is
		Barycentre : Point ;
		Point1, Point2 : Point ;
		P1, P2, P3, P4 : Point ;
		MilieuSegment : Point ;
	begin
		for i in 1..sommets loop
			Point1 := Figure(i).all.Coord.all;
			for j in 1..Figure(i).all.Connexions loop
				Point2 := Figure(Figure(i).all.Reseaux.all(j).Numero).all.Coord.all;
				MilieuSegment := Figure(i).all.Reseaux.all(j).Pointeur.all.Milieu ;
				if Figure(i).all.Reseaux.all(j).Numero > i then
					Barycentre := Point1 * 0.25 + Point2 * 0.75;
					P1 := Rotate (Barycentre, 45.0, MilieuSegment) ;
					P2 := Rotate (Barycentre, 135.0, MilieuSegment) ;
					P3 := Rotate (Barycentre, -135.0, MilieuSegment) ;
					P4 := Rotate (Barycentre, -45.0, MilieuSegment) ;
					Figure(i).all.Reseaux.all(j).Pointeur.all.Cr := (P1,P2,P3,P4);
				end if;
			end loop;
		end loop;
	end ;
end Parseur;
