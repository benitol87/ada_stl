with Math; use Math;
with Stl; use Stl;
with Test; use Test;
with Ada.Text_IO; use Ada.Text_IO;

procedure Test_STL is
	Points: Liste_Points.Liste;
	Facettes: Liste_Facettes.Liste;
	Compteur: Integer:= 1;

	procedure Enregistrer is
	begin
		Creation(Points,Facettes);
		Sauvegarder("stl/test_stl" & Str_Integer(Compteur) & ".stl",Facettes);
		Compteur := Compteur + 1;
	end;

	procedure Ajouter_Point(X,Y: Float) is
		P: Point2D;
	begin
		P(1) := X;
		P(2) := Y;
		Liste_Points.Insertion_Queue(Points,P);
	end;
begin
	Ajouter_Point(0.0,0.0);
	Ajouter_Point(10.0,10.0);
	Enregistrer;
	Ajouter_Point(20.0,1.0);
	Enregistrer;
	Ajouter_Point(30.0,1.0);
	Ajouter_Point(30.0,50.0);
	Ajouter_Point(50.0,50.0);
	Ajouter_Point(50.0,10.0);
	Ajouter_Point(70.0,70.0);
	Enregistrer;
	Put_Line("Fichiers stl/test_stl 1.stl à stl/test_stl" & Str_Integer(Compteur-1) & ".stl crees");
end;
