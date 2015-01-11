package Parseur is

	type Point is record
		X : Float;
		Y : Float;
	end record;

	type Liaisons is array(Integer range <>) of Integer;

	type Sommet is record 
		Connexions : Integer;
		Coord : access Point;
		Liens : access Liaisons;
	end record ;

	type Table is array(Integer range <>) of access Sommet;

	procedure Lecture_En_Tete (filename : in String; Sommets : out Natural);

	procedure Lecture (filename : in String; Sommets : in Natural; Tableau : in out Table);

end ;
