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

	procedure Assert_Equals(Actual,Expected: Float) is
	begin
		if (Actual - Expected > EPSILON) or else (Actual - Expected < -EPSILON) then
			raise Assertion_Failed;
		end if;
	end;

	function Str_Float(Nombre: Float) return String is
	begin
		return Trim(Float'Image(Nombre), Ada.Strings.Left);
	end;
end;
