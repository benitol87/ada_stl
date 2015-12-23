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

	procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste) is
	begin
		null;
	end;

	procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste) is
	begin
		null;
	end;
end;
