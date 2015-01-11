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

	procedure TracerAretes(Figure : in Graphe; Sommets : in Natural) is
	begin
		for i in 1..Sommets loop
			for j in 1..Figure(i).all.Connexions loop
				Svg_Line(Figure(i).all.Coord.all, Figure(Figure(i).all.Liens.all(j)).all.Coord.all, Black);
			end loop;
		end loop;
	end TracerAretes;

	procedure Svg_Footer is
	begin
		Put_Line("</svg>");
	end Svg_Footer;

end Svg;
