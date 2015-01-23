-- implémentation du paquet GraphDrawer
with Ada.Text_IO; use Ada.Text_IO;
with Types; use Types;
with Geometry;
with SVG;

package body GraphDrawer is
  -- recherche les dimensions du graphe
  -- retourne ces dimensions sous la forme d'un rectangle représenté par
  -- deux coins (supérieur gauche et inférieur droit)
  procedure FindDimensions(G : in Graph;
                           P1, P2 : out Point) is
  begin -- FindDimensions
    P1 := Point'(0.0, 0.0);
    P2 := Point'(0.0, 0.0);

    for I in GraphVertices(G).all'Range loop
      declare
        P : Point := VertexLocation(GraphVertex(G, I));
      begin
        if P.X < P1.X then
          P1.X := P.X;
        end if;

        if P.Y < P1.Y then
          P1.Y := P.Y;
        end if;

        if P.X > P2.X then
          P2.X := P.X;
        end if;

        if P.Y > P2.Y then
          P2.Y := P.Y;
        end if;
      end;  
    end loop;
  end FindDimensions;

  procedure DrawGraph(G : in Graph;
                      File : in File_Access;
                      ShowIntermediate : in Boolean;
                      Mode : in NodeGraphMode;
                      ControlPointsLengthFactor : in Float) is
    -- instanciation du paquet SVG pour le fichier spécifié
    package Output is new SVG(Output => File);

    -- type commun pour représenter l'état des procédures de dessin
    type StateType is record
      A, B, C, Cat, Cai, Cbt, Cbi : Point;
    end record;

    -- déclaration de la procédure de création d'état pour le dessin
    procedure GraphCreateState(VA, VB : in Vertex;
                               A, B : in Point;
                               State : out StateType) is
    begin -- GraphCreateState
        -- stockage des extrémités de l'arête dans la structure State
        State.A := A;
        State.B := B;

        -- calcul des points de contrôle
        Geometry.ControlPoints(State.A, State.B, State.C, 
                               State.Cat, State.Cai,
                               State.Cbt, State.Cbi,
                               ControlPointsLengthFactor);
    end GraphCreateState;

    -- ces méthodes représentent les deux tâches principales devant être 
    -- réalisées par DrawGraph : dessin du graphe intermédiaire et du graphe
    -- final
    procedure DrawIntermediateGraph is
      -- déclaration de la procédure de dessin
      procedure GraphDrawPass(Edge, UnusedEdgeState : in StateType) is
      begin -- GraphDrawPass
        -- dessin de l'arête
        Output.Line(Edge.A, Edge.B);

        -- dessin de la croix de contrôle
        Output.Line(Edge.Cat, Edge.Cbt);
        Output.Line(Edge.Cai, Edge.Cbi);
      end GraphDrawPass;

      -- instanciation du paquet GraphWalker pour le dessin du graphe
      -- intermédiaire
      package GW is new GraphWalker(StateType => StateType,
                                    CreateState => GraphCreateState,
                                    DrawPass => GraphDrawPass,
                                    Mode => Mode);
    begin -- DrawIntermediateGraph
      -- création du groupe SVG pour le graphe intermédiaire
      Output.BeginGroup(Id => "aretes",
                        Style => "stroke:rgb(0,0,0);stroke-width:0.1",
                        Transform => "");

      -- parcours et dessin du graphe
      GW.SimpleWalkGraph(G);

      -- fin du groupe SVG
      Output.EndGroup;
    end DrawIntermediateGraph;

    procedure DrawFinalGraph is
      -- déclaration de la procédure de dessin
      procedure GraphDrawPass(FirstEdgeState, SecondEdgeState : in StateType) is
      begin -- GraphDrawPass
        -- tracé de la courbe
        Output.Bezier(FirstEdgeState.C, 
                      FirstEdgeState.Cat,
                      SecondEdgeState.Cai,
                      SecondEdgeState.C);
      end GraphDrawPass;

      -- instanciation du paquet GraphWalker pour le dessin du graphe
      -- intermédiaire
      package GW is new GraphWalker(StateType => StateType,
                                    CreateState => GraphCreateState,
                                    DrawPass => GraphDrawPass,
                                    Mode => Mode);
    begin -- DrawFinalGraph
      -- création du groupe SVG pour le graphe final
      Output.BeginGroup(Id => "noeud",
                        Style => "stroke:rgb(255,0,0);fill:none;stroke-width:0.1",
                        Transform => "");

      -- parcours et dessin du graphe
      GW.WalkGraph(G);

      -- fin du groupe SVG
      Output.EndGroup;
    end DrawFinalGraph;

    -- dimensions du graphe
    P1, P2, Dimensions : Point;
  begin -- DrawGraph
    -- recherche des dimensions du graphe
    FindDimensions(G, P1, P2);

    -- mise à l'échelle pour obtenir une petite marge
    Dimensions := 1.15 * (P2 - P1);

    -- création du document SVG 
    Output.Header(Width => Dimensions.X,
                  Height => Dimensions.Y);

    -- groupe all : contient une translation pour ramener le graphe au
    -- centre du document
    Output.BeginGroup(Id => "all",
                      Style => "",
                      Transform => Output.CenterRectangleTransform(P1, P2));

    if ShowIntermediate then
      DrawIntermediateGraph;
    end if;

    DrawFinalGraph;

    Output.EndGroup; -- fin groupe all
    Output.Footer;   -- fin document
  end DrawGraph;

  package body GraphWalker is
    procedure SimpleWalkGraph(G : in Graph) is
      CurrentState : StateType;
    begin -- SimpleWalkGraph
      for I in GraphVertices(G).all'Range loop
        declare
          VA : Vertex := GraphVertex(G, I);
        begin
          -- parcours de toutes les arêtes du sommet en cours
          -- qui n'ont pas encore été parcourues
          for EdgeIndex in VertexEdges(VA).all'Range loop
            declare
              J : Index := VertexEdge(VA, EdgeIndex);
            begin
              if I > J then -- en ne parcourant que les arêtes (i, j) telles que
                            -- I > J on s'assure de ne parcourir chaque arête
                            -- qu'une seule et unique fois (puisque I = J est
                            -- impossible)
                declare
                  VB : Vertex := GraphVertex(G, J);
                begin
                  -- création de l'état pour la nouvelle arête rencontrée
                  CreateState(VA, VB, VertexLocation(VA), VertexLocation(VB),
                              CurrentState);

                  -- appel de la procédure de dessin pour l'arête concernée
                  DrawPass(CurrentState,
                           CurrentState);
                end;
              end if;
            end;
          end loop;
        end;
      end loop;
    end SimpleWalkGraph;

    -- type de tableau permettant de garder trace des arêtes qui ont déjà été
    -- parcourues
    type SeenEdgesArray is array(Index range <>) of Boolean;

    -- retourne l'indice de l'arête dont l'angle est maximal/minimal par rapport
    -- à l'arrête (I, J), dans le graphe G, qui n'a pas encore été parcourue
    -- (le parcours d'une arête d'indice K est indiqué par une valeur True dans
    -- le tableau SeenEdges)
    function TargetAngleIndex(G : in Graph; I, J : in Index;
                              SeenEdges : in SeenEdgesArray) return Index is
      -- valeur de l'angle et indice de l'arête formant cet angle avec (I, J)
      TargetAngle : Float;
      TargetIndex : Index := Index'Last;

      -- sommet A de l'arête et position
      VA : Vertex := GraphVertex(G, I);
      A : Point := VertexLocation(VA);

      -- sommet B de l'arête et position
      VB : Vertex := GraphVertex(G, J);
      B : Point := VertexLocation(VB);
    begin -- TargetAngleIndex
      -- initialisation de la valeur de l'angle pour le calcul du max ou min
      if Mode = Minimum then
        TargetAngle := 360.0;
      else -- Mode = Maximum
        TargetAngle := -360.0;
      end if;

      -- on teste chaque arête du sommet I
      for L in VertexEdges(VA).all'Range loop
        if not SeenEdges(L) then -- on s'intéresse aux "nouvelles" arêtes
          declare
            -- sommet C de l'arête (A, C) considérée
            VC : Vertex := GraphVertex(G, VertexEdge(VA, L));
            C : Point := VertexLocation(VC);
            
            -- angle formé par (A, B) et (A, C)
            NewAngle : Float := Geometry.Angle(A, B, C);

            -- True si A = C (arête (A, C) = arête (A, B))
            IsSameEdge : Boolean := VertexEdge(VA, L) = J;

            -- True si un minimum n'a pas encore été trouvé
            IsFirstUnseenVertex : Boolean := TargetIndex = Index'Last;
          begin
            -- l'arête (A, B) formera toujours un angle minimum de 0° avec
            -- elle-même. il faut donc remplacer cette valeur par une valeur
            -- équivalente, afin de tester les autres arêtes possibles
            --
            -- cependant, dans certains cas seule l'arête (A, B) est disponible
            -- il ne faut donc pas tout simplement l'exclure des tests
            if Mode = Minimum and (IsSameEdge and IsFirstUnseenVertex) then
              NewAngle := 360.0;
            end if;

            -- mise à jour du min ou du max en tenant compte des remarques
            -- précédentes
            if (Mode = Minimum and ((IsSameEdge and IsFirstUnseenVertex) or
                                    (NewAngle < TargetAngle))) or
               (Mode = Maximum and (NewAngle > TargetAngle)) then
              TargetIndex := L;
              TargetAngle := NewAngle;
            end if;
          end;
        end if;
      end loop;

      -- retour de l'indice recherché (ou Index'Last si non trouvé)
      return TargetIndex;
    end TargetAngleIndex;

    procedure WalkGraph(G : in Graph) is
    begin -- WalkGraph
      -- on parcourt tous les sommets pour parcourir tous les couples d'arêtes
      for I in GraphVertices(G).all'Range loop
        declare
          -- sommet A de l'arête
          VA : Vertex := GraphVertex(G, I);

          -- K désigne l'indice de l'arête dans le sommet A
          K : Index := VertexEdges(VA).all'First;
          -- J désigne l'indice de l'autre sommet de l'arête dans le graphe
          J : Index := VertexEdge(VA, K);

          -- tableau des arêtes qui ont déjà été parcourues
          SeenEdges : SeenEdgesArray(VertexEdges(GraphVertex(G, I)).all'Range)
            := (others => False);

          -- état de dessin précédent
          PreviousEdgeState : StateType;
          -- True si l'état de dessin précédent est valide, False sinon
          PreviousEdgeStateValid : Boolean := False;
        begin
          -- cette boucle se terminera forcément, car tout sommet a un nombre
          -- fini de sommets adjacents, et chaque itération visite l'un de ces
          -- sommets avant de l'arête correspondante comme "visitée"
          -- 
          -- le nombre de sommets restants est donc strictement décroissant,
          -- supérieur à 0, ce qui assure la terminaison de la boucle
          loop
            declare
              -- indice de la prochaine arête devant être considérée
              Next : Index := TargetAngleIndex(G, I, J, SeenEdges);
            begin
              -- voir ci-dessus pour la condition de sortie de boucle
              exit when Next = Index'Last;

              declare
                -- état de dessin pour l'arête en cours
                CurrentEdgeState : StateType;

                -- sommets B et C pour les arêtes (A, B) et (A, C)
                VB : Vertex := GraphVertex(G, J);
                VC : Vertex := GraphVertex(G, VertexEdge(VA, Next));
              begin
                -- génération de l'état de dessin pour l'arête (A, B) (arête de
                -- départ du point de vue de l'algorithme) si nécessaire
                if not PreviousEdgeStateValid then
                  CreateState(VA, VB, VertexLocation(VA), VertexLocation(VB),
                              PreviousEdgeState);

                  PreviousEdgeStateValid := True;
                end if;

                -- génération de l'état de dessin pour l'arête (A, C) (arête 
                -- d'arrivée du point de vue de l'algorithme)
                CreateState(VA, VC, VertexLocation(VA), VertexLocation(VC),
                            CurrentEdgeState);

                -- exécution de la passe de dessin
                DrawPass(CurrentEdgeState, PreviousEdgeState);

                -- passage à l'arête suivane
                PreviousEdgeState := CurrentEdgeState;

                -- on marque l'arête comme visitée
                SeenEdges(Next) := True;

                K := Next;
                J := VertexEdge(VA, K);
              end;
            end;
          end loop;
        end;
      end loop;
    end WalkGraph;
  end GraphWalker;
end GraphDrawer;