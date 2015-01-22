with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Geometry; use Geometry;

package body Parseur is

	file : File_Type;

	-- récupère le nombre de sommets
	procedure lectureEnTete (filename : in String; sommets : out Natural) is
	begin
		Open (File => file, Mode => In_File, Name => filename);
		Get(file, sommets);
	end;

	-- parcoure le fichier et récupère les données sur les points
	procedure lecture (filename : in String; sommets : in Natural; Figure : in out Graphe) is
	begin
	   -- pour tous les sommets du fichier..
		for i in 1..sommets loop

		   -- récupère les données du points 
			Get(file, Figure(i).all.Coord.all.X);
			Get(file, Figure(i).all.Coord.all.Y);
			Get(file, Figure(i).all.connexions);

			-- récupère les points adjacents à ce dernier
			Figure(i).all.Reseaux := new Liaisons (1 .. Figure(i).all.connexions);
			for j in 1..Figure(i).all.connexions loop
				Get(file, Figure(i).all.Reseaux.all(j).indVoisin);
			end loop;
		end loop;

		close (file);
	end;


	-- TODO : fusionner getMilieux et getCroix
	procedure getMilieux (sommets : in Natural ; Figure : in out Graphe) is
		p1, p2 : Point ;
	begin
	        -- pour tous les points du graphe...
		for i in 1..sommets loop
			p1 := Figure(i).all.Coord.all ; -- récupère les coordonnées du point

			-- pour tous les voisins de chaque point
			for j in 1..Figure(i).all.Connexions loop
			      -- récupère les coordonnées du voisin
				p2 := Figure(Figure(i).all.Reseaux.all(j).indVoisin).all.Coord.all ;

				-- créé une nouvelle arrète entre ces deux points
				-- TODO : si l'arrete existe déjà pour le "petit" voisin, ne pas la recréer
			        Figure(i).all.Reseaux.all(j).aretePtr := new Arete;
				if Figure(i).all.Reseaux.all(j).indVoisin > i then
					Figure(i).all.Reseaux.all(j).aretePtr.all.Milieu := (p1+p2)*0.5 ;
				end if;
			end loop;
		end loop;
	end ;

	procedure getCroix (sommets : in Natural ; Figure : in out Graphe) is
		barycentre : Point ;
		point1, point2 : Point ;
		P1t, P2i, P2t, P1i : Point ;
		milieuSegment : Point ;
	begin
	   -- pour tous les points du graphe...
		for i in 1..sommets loop
			point1 := Figure(i).all.Coord.all;
			
			-- pour tous les voisins de chaque point
			for j in 1..Figure(i).all.Connexions loop
			      -- récupère coordonnées voisins
				point2 := Figure(Figure(i).all.Reseaux.all(j).indVoisin).all.Coord.all;
				-- récupère milieu segment
				milieuSegment := Figure(i).all.Reseaux.all(j).aretePtr.all.Milieu ;

				-- si la croix n'a pas déjà été calculée..
				if Figure(i).all.Reseaux.all(j).indVoisin > i then
				        -- on calcule ses points
					barycentre := point1 * 0.25 + point2 * 0.75;
					P1t := Rotate (barycentre, 45.0, milieuSegment) ;
					P2i := Rotate (barycentre, 135.0, milieuSegment) ;
					P2t := Rotate (barycentre, -135.0, milieuSegment) ;
					P1i := Rotate (barycentre, -45.0, milieuSegment) ;

					-- et on les stockes
					Figure(i).all.Reseaux.all(j).aretePtr.all.cross := (P1t,P2i,P2t,P1i);
				end if;
			end loop;
		end loop;
	end ;
end Parseur;









