with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Geometry is

	function "+" (P1, P2 : Point) return Point is
		P : Point;
	begin
		P.X := P1.X + P2.X;
		P.Y := P1.Y + P2.Y;
		return P;
	end;

	function "-" (P1, P2 : Point) return Point is
		P : Point;
	begin
		P.X := P1.X - P2.X;
		P.Y := P1.Y - P2.Y;
		return P;
	end;

	function "*" (P : Point ; F : Float) return Point is
		R : Point;
	begin
		R.X := P.X * F;
		R.Y := P.Y * F;
		return R;
	end;

	-- tourne par rapport à un point P0 donné
	function Rotate(P : Point ; Angle : Float ; P0 : Point) return Point is
		R : Point;
	begin
		R.X := (P.X - P0.X) * Cos(Angle, 360.0) - (P.Y - P0.Y) * Sin(Angle, 360.0) + P0.X;
		R.Y := (P.X - P0.X) * Sin(Angle, 360.0) + (P.Y - P0.Y) * Cos(Angle, 360.0) + P0.Y;
		return R;
	end Rotate;

	function Distance(P1, P2 : Point) return Float is
		Tmp : Point;
	begin
		Tmp := P2 - P1;
		return Sqrt(Tmp.X*Tmp.X+Tmp.Y*Tmp.Y);
	end Distance;

	-- calcule l'angle entre (p1;p2) et (p1;p3)
	function angleBetween(p1, p2, p3 : Point) return Float is
	begin
	   return 1.0;
	end angleBetween;
end Geometry;
