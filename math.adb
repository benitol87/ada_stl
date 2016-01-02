with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Math is

	function "+" (A : Vecteur ; B : Vecteur) return Vecteur is
		R : Vecteur(A'Range);
	begin
		for I in R'Range loop
			R(I) := A(I) + B(I);
		end loop;

		return R;
	end;

	function "*" (Facteur : Float ; V : Vecteur) return Vecteur is
		R : Vecteur(V'Range);
	begin
		for I in R'Range loop
			R(I) := Facteur * V(I);
		end loop;
		
		return R;
	end;

	-- Calcul des coordonnées d'un point d'une courbe de Bézier linéaire
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Lineaire(P0,P1: Point2D ; T: Float) return Point2D is
	begin
		return (1.0-T)*P0 + T*P1;
	end;

	-- Calcul des coordonnées d'un point d'une courbe de Bézier quadratique 
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Quadratique(P0,P1,P2: Point2D ; T: Float) return Point2D is
	begin
		return (1.0-T)*Bezier_Lineaire(P0,P1,T) + T*Bezier_Lineaire(P1,P2,T);
	end;
	
	-- Calcul des coordonnées d'un point d'une courbe de Bézier cubique 
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Cubique(P0,P1,P2,P3: Point2D ; T: Float) return Point2D is
	begin
		return (1.0-T)*Bezier_Quadratique(P0,P1,P2,T) + T*Bezier_Quadratique(P1,P2,P3,T);
	end;

	procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste) is
	begin
		for T in 0..Nb_Points-1 loop
			Insertion_Tete(Points, Bezier_Cubique(P1,C1,C2,P2, Float(T)/Float(Nb_Points-1) ));
		end loop;
	end;

	procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste) is
	begin
		for T in 0..Nb_Points-1 loop
			Insertion_Tete(Points, Bezier_Quadratique(P1,C,P2, Float(T)/Float(Nb_Points-1) ));
		end loop;
	end;

	function To_Point3D(P: Point2D) return Point3D is
		Res: Point3D;
	begin
		Res(1) := P(1);
		Res(2) := P(2);
		Res(3) := 0.0;
		return Res;
	end;

	function Rotation_Axe_X(P: Point3D; Angle: Float) return Point3D is
		Res: Point3D;
	begin
		Res(1) := P(1);
		Res(2) := Cos(X=>Angle,Cycle=>360.0)*P(2) - Sin(X=>Angle,Cycle=>360.0)*P(3);
		Res(3) := Sin(X=>Angle,Cycle=>360.0)*P(2) + Cos(X=>Angle,Cycle=>360.0)*P(3);
		return Res;
	end;

end;
