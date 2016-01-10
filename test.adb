with Ada.Text_IO; use Ada.Text_IO;

package body Test is
	procedure Assert_Equals(Actual,Expected: Vecteur) is
	begin
		if Actual'Length /= Expected'Length then
			raise Assertion_Failed;
		end if;

		for I in Actual'Range loop
			Assert_Equals(Actual(I),Expected(I));
		end loop;
	end;

    procedure Assert_Equals(Actual,Expected: String) is
    begin
        if Actual /= Expected then
            Put_Line("Erreur de test: '" & Expected & "' attendu, '" & Actual & "' obtenu");
            raise Assertion_Failed;
        end if;
    end;

    procedure Assert_Equals(Actual,Expected: Natural) is
    begin
        if Actual /= Expected then
            Put_Line("Erreur de test: '" & Natural'Image(Expected) & "' attendu, '" & Natural'Image(Actual) & "' obtenu");
            raise Assertion_Failed;
        end if;
    end;

	procedure Assert_Equals(Actual,Expected: Float) is
	begin
		if (Actual - Expected > EPSILON) or else (Actual - Expected < -EPSILON) then
			Put_Line("Erreur de test: '" & Str_Float(Expected) & "' attendu, '" & Str_Float(Actual) & "' obtenu");
            raise Assertion_Failed;
		end if;
	end;

	function Str_Float(Nombre: Float) return String is
	begin
		return Trim(Float'Image(Nombre), Ada.Strings.Left);
	end;

	function Str_Integer(Nombre: Integer) return String is
	begin
		return Trim(Integer'Image(Nombre), Ada.Strings.Left);
	end;
end;
