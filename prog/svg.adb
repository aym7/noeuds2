with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

package body Svg is

   Display_Width, Display_Height : Float;

   procedure Svg_Line(P1, P2 : Point ; C : Color) is
   begin
      Put("<line x1=""");
      Put(P1.X);
      Put(""" y1=""");
      Put(P1.Y);
      Put(""" x2=""");
      Put(P2.X);
      Put(""" y2=""");
      Put(P2.Y);
      Put(""" style=""stroke:");
      case C is
	 when Red => Put("rgb(255,0,0)");
	 when Green => Put("rgb(0,255,0)");
	 when Blue => Put("rgb(0,0,255)");
	 when Black => Put("rgb(0,0,0)");
      end case;
      Put_Line(";stroke-width:0.2""/>");
   end Svg_Line;

   procedure Svg_Header(Width, Height : Integer) is
   begin
      Put("<svg width=""");
      Put(Width);
      Put(""" height=""");
      Put(Height);
      Put_Line(""">");
      Display_Width := Float(Width);
      Display_Height := Float(Height);
   end Svg_Header;

   procedure TracerAretes(Figure : in Graphe; nbSommets : in Natural) is
   begin
	   for i in 1..nbSommets loop
		   for j in 1..Figure(i).all.Connexions loop

			   if Figure(i).all.Reseaux.all(j).indVoisin > i then -- if the line hasn't been drawn yet
				   Svg_Line(Figure(i).all.Coord.all, 
				   Figure(Figure(i).all.Reseaux.all(j).indVoisin).all.Coord.all, 
				   Black);
			   end if;

		   end loop;
	   end loop;
   end TracerAretes;

   procedure TracerCroix(Figure : in Graphe; nbSommets : in Natural) is
	   p1, p2, p3, p4 : Point ;
   begin
	   for i in 1..nbSommets loop
		   for j in 1..Figure(i).all.Connexions loop
			   -- si la croix n'a pas déjà été tracée..
			   if Figure(i).all.Reseaux.all(j).indVoisin > i then 
				   p1 := Figure(i).all.Reseaux.all(j).aretePtr.all.cross.p1t ;
				   p2 := Figure(i).all.Reseaux.all(j).aretePtr.all.cross.p2i ;
				   p3 := Figure(i).all.Reseaux.all(j).aretePtr.all.cross.p2t ;
				   p4 := Figure(i).all.Reseaux.all(j).aretePtr.all.cross.p1i ;
				   Svg_Line(p1, p3, Red);
				   Svg_Line(p2, p4, Red);
			   end if;
		   end loop;
	   end loop;
   end TracerCroix;

   -- todo : proc tracerFigure parcourant les boucles une seule fois et appelant tracerAretes et tracerCroix

   procedure Tracer_Bezier (P1, P2, P3, P4 : in Point) is
   begin
	   Put("<path d=""M");
	   Put(P1.X); Put(P1.Y);
	   Put(" C");
	   Put(P2.X); Put(P2.Y);
	   Put(P3.X); Put(P3.Y);
	   Put(P4.X); Put(P4.Y);
	   Put(""" fill=""evenodd"" />");
   end Tracer_Bezier;

   procedure Svg_Footer is
   begin
	   Put_Line("</svg>");
   end Svg_Footer;

end Svg;
