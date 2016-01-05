with Ada.Unchecked_Deallocation;

package body Liste_Generique is

   procedure Liberer is new Ada.Unchecked_Deallocation(Cellule,Liste);
   	-- procedue que j'ai ajouté

   procedure Vider(L : in out Liste) is
   	-- pas encore testé mais ça va probablement buguer !!!
   	Cour : Pointeur ; 
   begin
   	Cour := L.Debut ;
   	if Cour = null then
   		return ;
   		-- Cas où L est vide : rien à faire
   	L.Debut := null ;
   	Liberer(Cour,L) ;
   	end if ;
   	while Cour.Suivant /= null loop
   		Cour := Cour.Suivant ;
   		Liberer(Cour,L);
	end loop ;
	L.Fin := null ;
	L.Taille := 0 ;
   end;

   procedure Insertion_Tete(L : in out Liste ; E : Element) is
   begin
      Cour := new Cellule(E,L.Debut);
      L.Debut := Cour ;
      L.Taille := L.Taille + 1 ;
   end;

   procedure Insertion_Queue(L : in out Liste ; E : Element) is
   	Cour1 : Pointeur ;
   begin
      	Cour1 := L.Fin ;
      	Cour := new Cellule(E, null);
      	Cour1.Suivant := Cour ;
      	L.Fin := Cour ;
      	L.Taille := L.Taille + 1 ;
   end;

   procedure Parcourir (L : Liste) is
   	Cour : Pointeur ;
   begin
      	Cour := L.Debut ;
      	while Cour /= null loop
      		Traiter(Cour.Contenu);
      		Cour := Cour.Suivant ;
      	end loop ;
   end;

   procedure Parcourir_Par_Couples(L : Liste) is
   	Cour : Pointeur ;
   begin
   	if L.Taille < 2 then
   		return ;
   	end if ;
   	Cour := L.Debut ;
   	while Cour.Suiv /= null loop
   		Traiter(Cour, Cour.Suiv);
   		Cour := Cour.Suiv ;
   	end loop ;
   end;

   procedure Fusion(L1 : in out Liste ; L2 : in out Liste) is
   -- concatène la queue de L1 à la tête de L2
   	Cour : Pointeur ;
   begin
   	-- Cas de L2 vide : rien à faire
   	if L2.Tete = null then
   		return ;
   	end if ;
   	-- Cas de L1 Vide
   	if L1.Tete = null then
   		L1.Debut := L2.Debut ;
   		L1.Fin := L2.Fin ;
   		L1.Taille := L2.Taille ;
   		Vider(L2);
   		return ;
   	end if ;
   	Cour := L1.Fin;
   	Cour.Suiv := L2.Debut ;
   	L1.Taille := L1.Taille + L2.Taille ;
   	L1.Fin := L2.Fin ;
   	Vider(L2);
   	
   end;

   -- fin des prodésures à compléter

   function Taille(L : Liste) return Natural is
   begin
      return L.Taille;
   end;

   function Tete(L : Liste) return Element is
   begin
      return L.Debut.Contenu;
   end;

   function Queue(L : Liste) return Element is
   begin
      return L.Fin.Contenu;
   end;

end;
