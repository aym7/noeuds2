with Ada.Command_Line;
use Ada.Command_Line;

with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

with svg;
use svg;

with Parseur; use Parseur;

procedure Structure is
	NombreSommets : Natural;
begin

	if Argument_Count /= 1 then
		Put_Line(Standard_Error, "utilisation : ./structure graph.kn");
		return;
	end if;

	Parseur.Lecture_En_Tete(Argument(1), NombreSommets);

	declare
		Graphe : Table (1 .. NombreSommets);
	begin
		for i in 1..NombreSommets loop
			Graphe(i) := new Sommet;
			Graphe(i).all.Coord := new Point;
		end loop;

		Parseur.Lecture(Argument(1), NombreSommets, Graphe);

		Svg_Header(10,10);
		Svg.TracerAretes(Graphe, NombreSommets);
		Svg_Footer;

	end ;

end Structure;
