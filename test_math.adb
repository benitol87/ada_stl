with Math; use Math;
with Fichier; use Fichier;
with Test; use Test;
with Ada.Text_IO; use Ada.Text_IO;

procedure Test_Math is
	procedure Test_Rotation_Axe_X is	
		Initial, Reel, Attendu: Point3D;
	begin
		Put_Line("Lancement du test : Test_Rotation_Axe_X");
		Initial := (1.2, 3.7, 0.0);
		Reel := Rotation_Axe_X(Initial,90.0);
		Attendu := (1.2, 0.0, 3.7);	
		Assert_Equals(Reel, Attendu);

		Reel := Rotation_Axe_X(Initial,-270.0);
		Attendu := (1.2, 0.0, 3.7);	
		Assert_Equals(Reel, Attendu);

		Reel := Rotation_Axe_X(Initial,180.0);
		Attendu := (1.2, -3.7, 0.0);	
		Assert_Equals(Reel, Attendu);

		Reel := Rotation_Axe_X(Initial,-180.0);
		Attendu := (1.2, -3.7, 0.0);	
		Assert_Equals(Reel, Attendu);

		Reel := Rotation_Axe_X(Initial,270.0);
		Attendu := (1.2, 0.0, -3.7);	
		Assert_Equals(Reel, Attendu);

		Reel := Rotation_Axe_X(Initial,-90.0);
		Attendu := (1.2, 0.0, -3.7);	
		Assert_Equals(Reel, Attendu);
	exception
		when Assertion_Failed =>
			Put_Line(Standard_Error, "Erreur, échec du test : Test_Rotation_Axe_X");
			raise Test_Failed;
	end;

	procedure Test_To_Point3D is
		Initial: Point2D;
		Reel, Attendu: Point3D;
	begin
		Put_Line("Lancement du test : Test_To_Point3D");
		Initial := (1.0, 3.1);
		Reel := To_Point3D(Initial);
		Attendu := (1.0, 3.1, 0.0);	
		Assert_Equals(Reel, Attendu);
	exception
		when Assertion_Failed =>
			Put_Line(Standard_Error, "Erreur, échec du test : Test_To_Point3D");
			raise Test_Failed;
	end;

	procedure Test_Mult_Float_Vecteur is
		Initial, Reel, Attendu: Point3D;
		Coef: Float;
	begin
		Put_Line("Lancement du test : Test_Mult_Float_Vecteur");
		Initial := (1.0, 3.1, -7.4);
		Coef := 2.0;
		Reel := Coef * Initial;
		Attendu := (2.0, 6.2, -14.8);	
		Assert_Equals(Reel, Attendu);

		Coef := 0.0;
		Reel := Coef * Initial;
		Attendu := (0.0, 0.0, 0.0);	
		Assert_Equals(Reel, Attendu);
	exception
		when Assertion_Failed =>
			Put_Line(Standard_Error, "Erreur, échec du test : Test_Mult_Float_Vecteur");
			raise Test_Failed;
	end;

	procedure Test_Add_Vecteurs is
		Initial1, Initial2, Reel, Attendu: Point3D;
	begin
		Put_Line("Lancement du test : Test_Add_Vecteurs");
		Initial1 := (1.0, 3.1, -7.4);
		Initial2 := (-0.6, 5.34, 5.0);
		Reel := Initial1 + Initial2;
		Attendu := (0.4, 8.44, -2.4);	
		Assert_Equals(Reel, Attendu);

		Initial1 := (1.0, 3.1, -7.4);
		Initial2 := (0.0, 0.0, 0.0);
		Reel := Initial1 + Initial2;
		Attendu := (1.0, 3.1, -7.4);	
		Assert_Equals(Reel, Attendu);
	exception
		when Assertion_Failed =>
			Put_Line(Standard_Error, "Erreur, échec du test  : Test_Add_Vecteurs");
			raise Test_Failed;
	end;

	procedure Test_BezierCub is
	begin
		-- TODO (nécessite le package listes)
		-- SVG, line, path
		null;
	end;

	procedure Test_BezierQuad is
	begin
		-- TODO (nécessite le package listes)
		-- SVG, line, path
		null;
	end;

	-- Compare une courbe de Bézier cubique avec les points
	-- dont les coordonnées sont calculées 
	procedure Test_Bezier_Cubique is
		Fic: File_Type;
		P0,P1,P2,P3,Res: Point2D;
		NB_POINTS: Integer:=20;
	begin
		Put_Line("Lancement du test : Test_Bezier_Cubique");

		P0 := (0.0,0.0);
		P1 := (20.0,30.0);
		P2 := (-30.0,30.0);
		P3 := (200.0,200.0);

		Ouvrir_Fichier_Ecriture(Fic, "bezier_cubique.svg");
		Ecrire_Fichier(Fic, "<svg width='200' height='200'>" & 
		"<path fill='none' stroke='green' stroke-width='2' " &
		"d='M " & Str_Float(P0(1)) & "," & Str_Float(P0(2)) &
		" C " & Str_Float(P1(1)) & "," & Str_Float(P1(2)) &
		" " & Str_Float(P2(1)) & "," & Str_Float(P2(2)) &
		" " & Str_Float(P3(1)) & "," & Str_Float(P3(2)) & "'/>");

		Ecrire_Fichier(Fic, "<path fill='none' stroke='red' stroke-width='1' d='M ");
		for T in 1..NB_POINTS loop
			Res := Bezier_Cubique(P0,P1,P2,P3,Float(T-1)/Float(NB_POINTS-1));
			Ecrire_Fichier(Fic," " & Str_Float(Res(1)) & "," & Str_Float(Res(2)));
		end loop;
		Ecrire_Fichier(Fic, "'/>");

		Ecrire_Fichier(Fic, "</svg>");

		Fermer_Fichier(Fic);	
	end;

	-- Même que Test_Bezier_Cubique mais avec une courbe de Bézier quadratique
	procedure Test_Bezier_Quadratique is
		Fic: File_Type;
		P0,P1,P2,Res: Point2D;
		NB_POINTS: Integer:=20;
	begin
		Put_Line("Lancement du test : Test_Bezier_Quadratique");

		P0 := (0.0,0.0);
		P1 := (20.0,80.0);
		P2 := (200.0,200.0);

		Ouvrir_Fichier_Ecriture(Fic, "bezier_quadratique.svg");
		Ecrire_Fichier(Fic, "<svg width='200' height='200'>" & 
		"<path fill='none' stroke='green' stroke-width='2' " &
		"d='M " & Str_Float(P0(1)) & "," & Str_Float(P0(2)) &
		" Q " & Str_Float(P1(1)) & "," & Str_Float(P1(2)) &
		" " & Str_Float(P2(1)) & "," & Str_Float(P2(2)) & "'/>");

		Ecrire_Fichier(Fic, "<path fill='none' stroke='red' stroke-width='1' d='M ");
		for T in 1..NB_POINTS loop
			Res := Bezier_Quadratique(P0,P1,P2,Float(T-1)/Float(NB_POINTS-1));
			Ecrire_Fichier(Fic," " & Str_Float(Res(1)) & "," & Str_Float(Res(2)));
		end loop;
		Ecrire_Fichier(Fic, "'/>");

		Ecrire_Fichier(Fic, "</svg>");

		Fermer_Fichier(Fic);	
	end;

	procedure Test_Bezier_Lineaire is
		Fic: File_Type;
		P0,P1,Res: Point2D;
		NB_POINTS: Integer:=20;
	begin
		Put_Line("Lancement du test : Test_Bezier_Lineaire");

		P0 := (0.0,0.0);
		P1 := (200.0,200.0);

		Ouvrir_Fichier_Ecriture(Fic, "bezier_lineaire.svg");
		Ecrire_Fichier(Fic, "<svg width='200' height='200'>" & 
		"<path fill='none' stroke='green' stroke-width='2' " &
		"d='M " & Str_Float(P0(1)) & "," & Str_Float(P0(2)) &
		" " & Str_Float(P1(1)) & "," & Str_Float(P1(2)) & "'/>");

		Ecrire_Fichier(Fic, "<path fill='none' stroke='red' stroke-width='1' d='M ");
		for T in 1..NB_POINTS loop
			Res := Bezier_Lineaire(P0,P1,Float(T-1)/Float(NB_POINTS-1));
			Ecrire_Fichier(Fic," " & Str_Float(Res(1)) & "," & Str_Float(Res(2)));
		end loop;
		Ecrire_Fichier(Fic, "'/>");

		Ecrire_Fichier(Fic, "</svg>");

		Fermer_Fichier(Fic);	
	end;

begin
	Test_Rotation_Axe_X;
	Test_To_Point3D;
	Test_Mult_Float_Vecteur;
	Test_Add_Vecteurs;
	Test_Bezier_Lineaire;
	Test_Bezier_Quadratique;
	Test_Bezier_Cubique;
	Test_BezierCub;
	Test_BezierQuad;
end;
