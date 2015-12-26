with Math; use Math;
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
			Put_Line(Standard_Error, "Error, test failed : Test_Rotation_Axe_X");
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
			Put_Line(Standard_Error, "Error, test failed : Test_To_Point3D");
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
			Put_Line(Standard_Error, "Error, test failed : Test_Mult_Float_Vecteur");
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
			Put_Line(Standard_Error, "Error, test failed : Test_Add_Vecteurs");
			raise Test_Failed;
	end;

	procedure Test_BezierCub is
	begin
		-- TODO
		-- SVG, line, path
		null;
	end;

	procedure Test_BezierQuad is
	begin
		-- TODO
		-- SVG, line, path
		null;
	end;

	procedure Test_Bezier_Cubique is
	begin
		-- TODO
		-- SVG, balises line, path
		null;
	end;

	procedure Test_Bezier_Quadratique is
	begin
		-- TODO
		-- SVG, balises line (actual), path (expected)
		null;
	end;

	procedure Test_Bezier_Lineaire is
	begin
		-- TODO
		-- SVG, faire des balises line (actual) et une path (expected)
		null;
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
