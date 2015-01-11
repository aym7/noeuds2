package Parseur is
   
	type Point is record
		X : Float;
		Y : Float;
	end record;

	type Liaisons is array(Integer range <>) of Integer;

	type Sommet is record 
		connexions : Integer;
		Coord : access Point;
		Liens : access Liaisons; -- surement mieux de prendre une liste/pile
	end record ;

	type Graphe is array(Integer range <>) of access Sommet;

	procedure lectureEnTete (filename : in String; Sommets : out Natural);

	procedure Lecture (filename : in String; Sommets : in Natural; Figure : in out Graphe);

end ;
