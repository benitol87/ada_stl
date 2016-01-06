with Ada.Unchecked_Deallocation;

package body Liste_Generique is

   procedure Liberer is new Ada.Unchecked_Deallocation(Cellule,Pointeur);
   	-- procedue que j'ai ajouté

   procedure Vider(L : in out Liste) is
   	-- pas encore testé mais ça va probablement buguer !!!
   	Cour : Pointeur ;
   	Precedent : Pointeur ; 
   begin
   	Cour := L.Debut ;
   	if Cour = null then
   		return ;
   		-- Cas où L est vide : rien à faire
   	end if;
   	while Cour /= null loop
   		Precedent := Cour ;
   		Cour := Cour.Suivant ;
   		Liberer(Precedent);
	end loop ;
	L.Debut := null ;
	L.Fin := null ;
	L.Taille := 0 ;
   end;

   procedure Insertion_Tete(L : in out Liste ; E : Element) is
   	Cour : Pointeur ;
   begin
      Cour := new Cellule'(E,L.Debut);
      if L.Debut = null then
      	L.Fin := Cour ;
      end if ;
      L.Debut := Cour ;
      L.Taille := L.Taille + 1 ;
   end;

   procedure Insertion_Queue(L : in out Liste ; E : Element) is
   	Cour : Pointeur ;
   begin
      	Cour := new Cellule'(E, null);
      	
      	if L.Debut = null then
   		L.Debut := Cour;
   	else
   		L.Fin.Suivant := Cour ;
   	end if;
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
   	while Cour.Suivant /= null loop
   		Traiter(Cour.Contenu, Cour.Suivant.Contenu);
   		Cour := Cour.Suivant ;
   	end loop ;
   end;

   procedure Fusion(L1 : in out Liste ; L2 : in out Liste) is
   -- concatène la queue de L1 à la tête de L2
   	Cour : Pointeur ;
   begin
   	-- Cas de L2 vide : rien à faire
   	if L2.Debut = null then
   		return ;
   	end if ;
   	-- Cas de L1 Vide
   	if L1.Debut = null then
   		L1.Debut := L2.Debut ;
   		L1.Fin := L2.Fin ;
   		L1.Taille := L2.Taille ;
   		return ;
   	end if ;
   	Cour := L1.Fin;
   	Cour.Suivant := L2.Debut ;
   	L1.Taille := L1.Taille + L2.Taille ;
   	L1.Fin := L2.Fin ;
   	L2.Debut := null ;
   	L2.Fin := null ;
   	L2.Taille := 0;
   	
   end;

   -- fin des procédures à compléter

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
