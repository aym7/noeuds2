package Svg is
	type Color is (Red, Green, Blue, Black);
	type Point is
		record
			X : Float;
			Y : Float;
		end record;
	--appeller Svg_Header avant toute autre operation
	procedure Svg_Header(Width, Height : Integer);
	procedure Svg_Line(P1, P2 : Point; C : Color);
	--appeller Svg_Footer lorsque l'image est terminee
	procedure Svg_Footer;
end Svg;
