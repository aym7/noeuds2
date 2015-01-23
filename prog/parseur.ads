package Parseur is
   
	type Point is record
		X : Float;
		Y : Float;
	end record;

	type Croix is record
		P1t : Point ;
		P2i : Point ;
		P2t : Point ;
		P1i : Point ;
	end record;

	type Arete is record
		Milieu : Point ;
		cross : Croix ;
	end record;

	type Liens is record
		indVoisin : Integer ;
		aretePtr : access Arete ;
	end record;

	type Liaisons is array(Integer range <>) of Liens ;

	type Sommet is record 
		connexions : Integer;
		Coord : access Point;
		Reseaux : access Liaisons; 
	end record ;

	type Graphe is array(Integer range <>) of access Sommet;


	procedure lectureEnTete (filename : in String; Sommets : out Natural);

	procedure Lecture (filename : in String; Sommets : in Natural; Figure : in out Graphe);

	procedure getMilieux (sommets : in Natural ; Figure : in out Graphe ; p1, p2 : in Point ; i,j : Natural);

	procedure getCroix (sommets : in Natural ; Figure : in out Graphe ; p1, p2 : in Point ; i,j : Natural);

	procedure getRef (sommets : in Natural ; Figure : in out Graphe);

end ;
