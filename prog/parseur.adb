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
	 Get(file, Figure(i).Coord.X);
	 Get(file, Figure(i).Coord.Y);
	 Get(file, Figure(i).connexions);

	 -- récupère les points adjacents à ce dernier
	 Figure(i).Reseaux := new Liaisons (1 .. Figure(i).connexions);
	 for j in 1..Figure(i).connexions loop
	    Get(file, Figure(i).Reseaux(j).indVoisin);
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
	 p1 := Figure(i).Coord.all ; -- récupère les coordonnées du point

	 -- pour tous les voisins de chaque point
	 for j in 1..Figure(i).Connexions loop
	    -- récupère les coordonnées du voisin
	    p2 := Figure(Figure(i).Reseaux(j).indVoisin).Coord.all ;

	    -- créé une nouvelle arrète entre ces deux points
	    -- TODO : si l'arrete existe déjà pour le "petit" voisin, ne pas la recréer
	    Figure(i).Reseaux(j).aretePtr := new Arete;
	    if Figure(i).Reseaux(j).indVoisin > i then
	       Figure(i).Reseaux(j).aretePtr.Milieu := (p1+p2)*0.5 ;
	    end if;
	 end loop;
      end loop;
   end ;



   procedure getCroix (sommets : in Natural ; Figure : in out Graphe) is
      barycentre : Point ;
      pointGauche, pointDroite : Point ;
      pgt, pgi, pdt, pdi : Point ;
      milieuSegment : Point ;
   begin
      -- pour tous les points du graphe...
      for i in 1..sommets loop
	 pointGauche := Figure(i).Coord.all;

	 -- pour tous les voisins de chaque point
	 for j in 1..Figure(i).Connexions loop
	    -- récupère coordonnées voisins
	    pointDroite := Figure(Figure(i).Reseaux(j).indVoisin).Coord.all;
	    -- récupère milieu segment
	    milieuSegment := Figure(i).Reseaux(j).aretePtr.Milieu ;

	    -- si la croix n'a pas déjà été calculée..
	    if Figure(i).Reseaux(j).indVoisin > i then
	       -- on calcule ses points
	       barycentre := pointGauche * 0.25 + pointDroite * 0.75;
	       pgi := Rotate (barycentre, 45.0, milieuSegment) ; -- gauche
	       pgt := Rotate (barycentre, -135.0, milieuSegment) ; -- gauche
	       pdi := Rotate (barycentre, 135.0, milieuSegment) ; -- droite
	       pdt := Rotate (barycentre, -45.0, milieuSegment) ; -- droite

	       -- et on les stockes
	       Figure(i).Reseaux(j).aretePtr.cross := (pgt, pgi, pdt, pdi);
	    end if;
	 end loop;
      end loop;
   end ;
end Parseur;









