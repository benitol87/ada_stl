with Math; use Math;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package Test is	
	Assertion_Failed: Exception;
	Test_Failed: Exception;

	EPSILON: constant Float := 0.0001; -- Incertitude admise pour les nombres flottants

	-- Lance une exception si les deux vecteurs sont différents, admet une incertitude de EPSILON sur les valeurs à cause de l'utilisation de nombres flottants
	procedure Assert_Equals(Actual,Expected: Vecteur);	

	-- Lance une exception si la distance entre Actual et Expected est supérieure à EPSILON
	procedure Assert_Equals(Actual,Expected: Float);

    -- Test l'égalité entre deux chaines de caractères et lance une exception si celles-ci sont différentes
    procedure Assert_Equals(Actual,Expected: String);

    -- Test l'égalité entre deux caractères et lance une exception si ceux-ci sont différents
    procedure Assert_Equals(Actual,Expected: Character);

    -- Test l'égalité entre deux entiers relatifs et lance une exception si ceux-ci sont différents
    procedure Assert_Equals(Actual,Expected: Integer);
	
    -- Enlève l'espace super utile devant les nombres flottants convertis en chaines de caractères
	function Str_Float(Nombre: Float) return String;

	-- Enlève l'espace super utile devant les nombres relatifs convertis en chaines de caractères
	function Str_Integer(Nombre: Integer) return String;
end;
