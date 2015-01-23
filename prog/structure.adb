with Ada.Command_Line;
use Ada.Command_Line;

with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

with Svg; use Svg;
with Parseur; use Parseur;


procedure Structure is
   nombreSommets : Natural;
begin

   if Argument_Count /= 1 then
      Put_Line(Standard_Error, "utilisation : ./structure graph.kn");
      return;
   end if;

   Parseur.lectureEnTete(Argument(1), nombreSommets);

   declare
      Figure : Graphe (1 .. nombreSommets);
   begin
      for i in 1..nombreSommets loop
	 Figure(i) := new Sommet;
	 Figure(i).Coord := new Point;
      end loop;
      Parseur.lecture(Argument(1), nombreSommets, Figure);
      Svg_Header(10,10);
      Svg.TracerAretes(Figure, nombreSommets);

      Parseur.getRef(nombreSommets, Figure);
      Svg.TracerCroix(Figure, nombreSommets);

      Svg_Footer;
   end ;

end Structure;
