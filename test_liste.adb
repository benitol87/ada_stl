with liste_generique ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Integer_Text_Io ; use Ada.Integer_Text_Io ;
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
	
	function transformebis (L : Liste) return string is
		S : Unbounded_String ;
		procedure affichecouple(C1,C2 : in Character) is
		begin
			S := S & C1 & C2 & ';' ;
		end;
		
		procedure ParcoursBis is new Parcourir_Par_Couples(Traiter=>affichecouple);
	
	begin
		S := To_Unbounded_String("");
		ParcoursBis(L);
		return To_String(S) ;
	end ;
	
	L : Liste ;
	M : Liste ;
	
begin
	
	Insertion_Tete(L, 'i');
	Insertion_Tete(L, 'h');
	Insertion_Tete(L, 'g');
	Insertion_Tete(L, 'f');
	Insertion_Tete(L, 'e');
	Insertion_Tete(L, 'd');
	Insertion_Tete(L, 'c');
	Insertion_Tete(L, 'b');
	Insertion_Tete(L, 'a');
	Put_Line(transforme(L));
	Insertion_Queue(L, 'j');
	Insertion_Queue(L, 'k');
	Insertion_Queue(L, 'l');
	Insertion_Queue(L, 'm');
	Insertion_Queue(L, 'n');
	Put_Line(transforme(L));
	New_Line ;
	Put_Line("Ca marche jusqu'ici.");
	New_Line ;
	Put_Line(transformebis(L));
	New_Line ;
	Put_Line("Ca marche une deuxième fois.");
	New_Line ;
	Vider(L) ;
	
	if  Taille(L) = 0 and transforme(L) = "" then
		Put_Line("Liste Correctement vidée.");
	else
		Put_Line("ERREUR : Liste mal vidée");
	end if ;
	
	Insertion_Queue(L,'a');
	Insertion_Queue(L,'b');
	Insertion_Queue(L,'c');
	Insertion_Queue(L,'d');
	Insertion_Queue(M,'e');
	Insertion_Queue(M,'f');
	Insertion_Queue(M,'g');
	Insertion_Queue(M,'h');
	Insertion_Queue(M,'i');
	Insertion_Queue(M,'j');
	New_Line ;
	Put_Line("Test de concaténation :");
	
	Put_Line("Liste 1 : " & transforme(L));
	Put_Line("Sa taille : ");
	Put(Taille(L));
	New_Line ;
	Put_Line("Liste 2 : " & transforme(M));
	Put_Line("Sa taille : ");
	Put(Taille(M));
	Fusion(L,M);
	New_Line ;
	Put_Line(transforme(L));
	Put_Line("Sa taille : ");
	Put(Taille(L));
	New_Line ;
	Put_Line("Liste correctement concaténée.");
	New_Line ;
	if Taille(M) = 0 then
		Put_Line("La deuxième liste est vide, comme convenu.");
	else
		Put_Line("ERREUR : Deuxième liste mal vidée.");
	end if;
	
	
end;
