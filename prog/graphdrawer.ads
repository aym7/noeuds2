-- paquet implémentant le tracé des graphes
with Ada.Text_IO; use Ada.Text_IO;
with Types; use Types;
with SVG;

package GraphDrawer is
  -- énumération représentant les types de graphes possibles
  -- comme défini dans le sujet :
  --   Minimum correspond à un graphe ou les angles entre arêtes sont minimums
  --   Maximum correspond à un graphe ou les angles entre arêtes sont maximums
  type NodeGraphMode is (Minimum, Maximum);

  -- dessine le graphe fourni en entrée
  -- paramètres :
  --   G                : graphe à dessiner
  --   File             : flux de sortie
  --   ShowIntermediate : True s'il faut afficher les graphes intermédiaires,
  --                      False sinon
  --   Mode             : type de graphe à réaliser (utilisant l'angle minimal
  --                      ou l'angle maximal)
  --   ControlPointsLengthFactor : facteur entre le diamètre des croix de 
  --                               contrôle et la longueur de l'arête considérée
  procedure DrawGraph(G : in Graph;
                      File : in File_Access;
                      ShowIntermediate : in Boolean;
                      Mode : in NodeGraphMode;
                      ControlPointsLengthFactor : in Float);
private
  -- le paquet GraphWalker offre des procédures permettant de parcourir toutes
  -- les arêtes et couples d'arêtes du graphe
  generic
    -- type stockant l'état généré par un appel à DrawPass
    type StateType is private;

    -- mode de dessin utilisé
    Mode : NodeGraphMode;

    -- procédure générant un état de type StateType pour une arête donnée
    with procedure CreateState(VA, VB : in Vertex;
                               A, B : in Point;
                               State : out StateType);

    -- procédure réalisant le dessin pour un couple d'arêtes
    with procedure DrawPass(FirstEdgeState, SecondEdgeState : in StateType);
  package GraphWalker is
    -- parcourt les arêtes dans l'ordre où elles sont rencontrées
    -- ici le parcours se fait sur les arêtes seulement
    -- seul le paramètre FirstEdgeState de DrawState sera utilisé
    -- 
    -- garantit : chaque arête est parcourue une seule et unique fois
    procedure SimpleWalkGraph(G : in Graph);

    -- partcourt les couples d'arêtes du graphe de façon à minimiser l'angle
    -- entre celles-ci
    --
    -- garantit : chaque couple est parcouru une seule et unique fois
    procedure WalkGraph(G : in Graph);
  end GraphWalker;
end GraphDrawer;