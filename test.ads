with Math; use Math;

package Test is	
	Assertion_Failed: Exception;
	Test_Failed: Exception;

	EPSILON: constant Float := 0.0001; -- Incertitude admise pour les nombres flottants

	-- Lance une exception si les deux vecteurs sont différents, admet une incertitude de EPSILON sur les valeurs à cause de l'utilisation de nombres flottants
	procedure Assert_Equals(Actual,Expected: Vecteur);	
	-- Lance une exception si la distance entre Actual et Expected est supérieure à EPSILON
	procedure Assert_Equals(Actual,Expected: Float);
end;
