package Parseur is
   
	type Point is record
		X : Float;
		Y : Float;
	end record;

	type Croix is record
		pgt : Point ; -- point gauche, sens trigo 
		pgi : Point ; -- point gauche, sens trigo-inverse
		pdt : Point ;
		pdi : Point ;
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

	procedure GetMilieux (sommets : in Natural ; Figure : in out Graphe);

	procedure GetCroix (sommets : in Natural ; Figure : in out Graphe);

end ;
