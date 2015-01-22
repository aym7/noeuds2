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
	 for j in 1..Figure(i).Connexions loop

	    if Figure(i).Reseaux(j).indVoisin > i then -- if the line hasn't been drawn yet
	       Svg_Line(Figure(i).Coord.all, 
	       Figure(Figure(i).Reseaux(j).indVoisin).Coord.all, 
	       Black);
	    end if;

	 end loop;
      end loop;
   end TracerAretes;



   procedure TracerCroix(Figure : in Graphe; nbSommets : in Natural) is
      p1, p2, p3, p4 : Point ;
   begin
      for i in 1..nbSommets loop
	 for j in 1..Figure(i).Connexions loop
	    -- si la croix n'a pas déjà été tracée..
	    if Figure(i).Reseaux(j).indVoisin > i then 
	       p1 := Figure(i).Reseaux(j).aretePtr.cross.p1 ;
	       p2 := Figure(i).Reseaux(j).aretePtr.cross.p2 ;
	       p3 := Figure(i).Reseaux(j).aretePtr.cross.p3 ;
	       p4 := Figure(i).Reseaux(j).aretePtr.cross.p4 ;
	       Svg_Line(p1, p3, Red);
	       Svg_Line(p2, p4, Red);
	    end if;
	 end loop;
      end loop;
   end TracerCroix;

   -- todo : proc tracerFigure parcourant les boucles une seule fois et appelant tracerAretes et tracerCroix


   procedure tracerBoucles (Figure : in Graphe; nbSommets : in Natural) is
   begin

      for i in 1..nbSommets loop
	 for j in 1..Figure(i).connexions loop

	    new_line;

	 end loop;
      end loop;

   end tracerBoucles;


   -- étant donné une arête et un point donné, calcule l'angle que font les autres arête avec ce dernier et renvoie le point de contrôle vers lequel on se dirige
   procedure milieuSuivant(coordOrigin, coordEnd : Point) is
   begin

      new_line;

   end milieuSuivant;



   procedure Svg_Footer is
   begin
      Put_Line("</svg>");
   end Svg_Footer;

end Svg;
