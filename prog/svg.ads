with parseur; use parseur;
package Svg is
	type Color is (Red, Green, Blue, Black);
	procedure Svg_Header(Width, Height : Integer);
	procedure Svg_Line(P1, P2 : Point; C : Color);
	procedure TracerAretes(Figure : in Graphe; nbSommets : in Natural);
	procedure TracerCroix(Figure : in Graphe; nbSommets : in Natural);
	procedure Svg_Footer;
end Svg;
