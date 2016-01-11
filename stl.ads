with Liste_Generique;
with Math; use Math;
with Fichier; use Fichier;

package STL is
    type Facette is record
        P1, P2, P3 : Point3D;
    end record;

    NB_ROTATIONS: Integer := 16;

    package Liste_Facettes is new Liste_Generique(Facette);

    -- Prend une liste de segments et cree l'objet 3d par rotations
    -- Vide la liste de points "Segments" à la fin
    -- Requiert : Segments contient au moins deux points
    procedure Creation(Segments : in out Liste_Points.Liste ;
        Facettes :    out Liste_Facettes.Liste);

    -- Sauvegarde le fichier stl
    -- Vide la liste de facettes "Facettes" à la fin
    procedure Sauvegarder(Nom_Fichier : String ;
        Facettes : in out Liste_Facettes.Liste);
end;
