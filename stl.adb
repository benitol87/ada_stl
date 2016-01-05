with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics;
use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Characters.Latin_1;

package body STL is
	CRLF: constant String := Ada.Characters.Latin_1.CR & Ada.Characters.Latin_1.LF;
    TAB: constant Character := Ada.Characters.Latin_1.HT;

	procedure Creation(Segments : in out Liste_Points.Liste ;
		Facettes :    out Liste_Facettes.Liste) is
		procedure Traiter_Segment(P1,P2: in Point2D) is
			F: Facette;
			Haut,Bas,Haut_Suiv,Bas_Suiv: Point3D;
			Angle: Float := 360.0 / Float(NB_ROTATIONS);
		begin
			-- Initialisation des points de référence
			Haut := To_Point3D(P1);
			Bas := To_Point3D(P2);

			-- Un rectangle par tour de boucle
			for I in 1..NB_ROTATIONS loop
				-- Calcul des points suivants
				Haut_Suiv := Rotation_Axe_X(Haut,Angle);
				Bas_Suiv := Rotation_Axe_X(Bas,Angle);

				-- Première triangle
				F.P1 := Haut;
				F.P2 := Bas;
				F.P3 := Haut_Suiv;
				Liste_Facettes.Insertion_Queue(Facettes,F);

				-- Deuxième triangle
				F.P1 := Haut_Suiv;
				--F.P2 := Bas;
				F.P3 := Bas_Suiv;
				Liste_Facettes.Insertion_Queue(Facettes,F);

				-- Changement des points servant de référence
				Haut := Haut_Suiv;
				Bas := Bas_Suiv;
			end loop;
		end;
        
        procedure Parcours is new Liste_Points.Parcourir_Par_Couples(Traiter=>Traiter_Segment);
	begin
		Parcours(Segments);	
	end;

	procedure Sauvegarder(Nom_Fichier : String ;
		Facettes : Liste_Facettes.Liste) is
		Fic: File_Type;
		
        procedure Traiter_Facette(F: in out Facette) is
			procedure Ecrire_Point(P:Point3D) is
			begin
				Ecrire_Fichier(Fic, TAB & TAB & Tab & "vertex " & Float'Image(P(1)) & " " & Float'Image(P(2)) & " " & Float'Image(P(3)) & CRLF);
			end;
		begin
			Ecrire_Fichier(Fic, TAB & "facet" & CRLF);
			Ecrire_Fichier(Fic, TAB & TAB & "outer loop" & CRLF);
			Ecrire_Point(F.P1);
			Ecrire_Point(F.P2);
			Ecrire_Point(F.P3);
			Ecrire_Fichier(Fic, TAB & TAB & "endloop" & CRLF);
			Ecrire_Fichier(Fic, TAB & "endfacet" & CRLF);

		end;
        
        procedure Parcours is new Liste_Facettes.Parcourir(Traiter=>Traiter_Facette);
	begin
		Ouvrir_Fichier_Ecriture(Fic, Nom_Fichier);
		Ecrire_Fichier(Fic,"solid s" & CRLF);
		Parcours(Facettes);
		Ecrire_Fichier(Fic,"endsolid s");
		Fermer_Fichier(Fic);
	end;
end;
