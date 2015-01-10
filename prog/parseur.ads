package Parseur is

	type Liaisons is array(Integer range <>) of Integer;

	type Point is record 
		X, Y : Float ;
	end record ;

	type Sommet is record 
		Connexions : Integer;
		Coord : access Point;
		Liens : access Liaisons;
	end record ;

	type Table is array(Integer range <>) of access Sommet;

	procedure Lecture_En_Tete (filename : in String; Sommets : out Natural);
	
	procedure Lecture (filename : in String; Sommets : in Natural; Tableau : in out Table);

	end ;
