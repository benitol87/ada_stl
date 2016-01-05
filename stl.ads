with Liste_Generique;
with Math; use Math;
with Fichier; use Fichier;

package STL is
	type Facette is record
		P1, P2, P3 : Point3D;
	end record;

	NB_ROTATIONS: Integer := 16;

	package Liste_Facettes is new Liste_Generique(Facette);

	--prend une liste de segments et cree l'objet 3d par rotations
	procedure Creation(Segments : in out Liste_Points.Liste ;
		Facettes :    out Liste_Facettes.Liste);

	--sauvegarde le fichier stl
	procedure Sauvegarder(Nom_Fichier : String ;
		Facettes : Liste_Facettes.Liste);
end;
