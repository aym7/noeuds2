-- implémentation du paquet SVG
with Ada.Text_IO; use Ada.Text_IO;
with Types; use Types;
with Geometry; use Geometry;

package body SVG is
  IndentLevel : Integer := 0;
  DocumentWidth : Float;
  DocumentHeight : Float;

  -- retourne une chaîne représentant un nombre flottant, dont le format est
  -- conforme à la spécification SVG
  function FloatImage(F : in Float) return String is
    FloatString : String := Float'Image(F);
  begin -- FloatImage
    -- suppression de l'espace en tête, si présent
    if FloatString(FloatString'First) = ' ' then
      return FloatString((FloatString'First + 1) .. FloatString'Last);
    end if;

    return FloatString;
  end FloatImage;

  -- ajoute l'indentation nécessaire pour obtenir un document SVG lisible
  procedure IndentLine is
  begin -- IndentLine
    for I in 1 .. IndentLevel loop
      Put(Output.all, "  ");
    end loop;
  end IndentLine;

  -- vérifie que le niveau dans la structure du SVG est correct, lève une
  -- exception sinon
  procedure CheckIndentLevel is
  begin -- CheckIndentLevel
    if IndentLevel < 1 then
      raise InvalidSVGStructure;
    end if;
  end CheckIndentLevel;

  procedure Header(Width, Height : in Float) is
  begin -- Header
    if IndentLevel /= 0 then
      raise InvalidSVGStructure;
    end if;

    DocumentHeight := Height;
    DocumentWidth := Width;

    Put(Output.all, "<svg width=""");
    Put(Output.all, FloatImage(Width));
    Put(Output.all, """ height=""");
    Put(Output.all, FloatImage(Height));
    Put_Line(Output.all, """>");

    IndentLevel := IndentLevel + 1;
  end Header;

  procedure Footer is
  begin -- Footer
    IndentLevel := IndentLevel - 1;

    Put_Line(Output.all, "</svg>");

    if IndentLevel /= 0 then
      raise InvalidSVGStructure;
    end if;
  end Footer;

  procedure BeginGroup(Id, Style, Transform : in String) is
  begin -- BeginGroup
    CheckIndentLevel;

    IndentLine;
    
    Put(Output.all, "<g id=""");
    Put(Output.all, Id);
    Put(Output.all, """");

    if Style /= "" then
      Put(Output.all, " style=""");
      Put(Output.all, Style);
      Put(Output.all, """");
    end if;

    if Transform /= "" then
      Put(Output.all, " transform=""");
      Put(Output.all, Transform);
      Put(Output.all, """");
    end if;

    Put_Line(Output.all, ">");

    IndentLevel := IndentLevel + 1;
  end BeginGroup;

  procedure EndGroup is
  begin -- EndGroup
    CheckIndentLevel;

    IndentLevel := IndentLevel - 1;
    IndentLine;
    Put_Line(Output.all, "</g>");

    -- si IndentLevel devient inférieur à 1, la structure est forcément
    -- incorrecte, car le niveau minimum à l'intérieur d'un document
    -- SVG est de 1 (imposé par le noeud racine svg)
    if IndentLevel < 1 then
      raise InvalidSVGStructure;
    end if;
  end EndGroup;

  procedure Line(P1, P2 : in Point) is
  begin -- Line
    CheckIndentLevel;

    IndentLine;
    Put(Output.all, "<line x1=""");
    Put(Output.all, FloatImage(P1.X));
    Put(Output.all, """ y1=""");
    Put(Output.all, FloatImage(P1.Y));
    Put(Output.all, """ x2=""");
    Put(Output.all, FloatImage(P2.X));
    Put(Output.all, """ y2=""");
    Put(Output.all, FloatImage(P2.Y));
    Put_Line(Output.all, """ />");
  end Line;

  procedure Bezier(P1, P2, P3, P4 : in Point) is
    procedure PutPoint(P : in Point) is
    begin -- PutPoint
      Put(Output.all, " ");
      Put(Output.all, FloatImage(P.X));
      Put(Output.all, " ");
      Put(Output.all, FloatImage(P.Y));
    end PutPoint;
  begin -- Bezier
    CheckIndentLevel;
    
    IndentLine;
    Put(Output.all, "<path d=""M");
    PutPoint(P1);
    Put(Output.all, " C");
    PutPoint(P2);
    PutPoint(P3);
    PutPoint(P4);
    Put_Line(Output.all, """ />");
  end Bezier;

  function CenterRectangleTransform(P1, P2 : in Point) return String is
    RectangleCenter : Point := Center(P1, P2);
  begin -- CenterRectangleTransform
    return "translate(" &
        FloatImage(DocumentWidth / 2.0 - RectangleCenter.X) &
        "," &
        FloatImage(DocumentHeight / 2.0 - RectangleCenter.Y) &
        ")";
  end CenterRectangleTransform;
end SVG;
