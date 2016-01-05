with liste_generique ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure test_liste is

	package liste_caractere is new liste_generique(Character);
	use liste_caractere ;
	
	function transforme (L : Liste) return string is 
		S : Unbounded_String ;
		procedure Concat(C: in out Character) is
		begin
			S := S & C;
		end;
		procedure Parcours is new Parcourir(Traiter=>Concat);
	begin
		S := To_Unbounded_String("");
		Parcours(L);
		return To_String(S) ;
	end ;
	
	L : Liste ;
	
begin
	
	Insertion_Tete(L, '!');
	Insertion_Tete(L, ' ');
	Insertion_Tete(L, 't');
	Insertion_Tete(L, 'i');
	Insertion_Tete(L, 'o');
	Insertion_Tete(L, 'n');
	Insertion_Tete(L, 'e');
	Insertion_Tete(L, 'B');
	Insertion_Tete(L, ' ');
	Put_Line(transforme(L));
	Insertion_Queue(L, 'S');
	Insertion_Queue(L, 'a');
	Insertion_Queue(L, 'l');
	Insertion_Queue(L, 'u');
	Insertion_Queue(L, 't');
	Put_Line(transforme(L));
	New_Line ;
	Put_Line("Ca marche jusqu'ici.");
	New_Line ;
	Vider(L) ;
	
	if  Taille(L) = 0 and transforme(L) = "" then
		Put_Line("Liste Correctement vidée.");
	else
		Put_Line("ERREUR : Liste mal vidée");
	end if ;
	
	
	
	
end;
