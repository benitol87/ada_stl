with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;
with Ada.Strings.Unbounded_String; use Ada.Strings.Unbounded_String;

package body Parser_Svg is
	Erreur_Chargement_Exception: Exception;

	-- Fonction servant à lire les coordonnées d'un point 2D dans un fichier ouvert en mode lecture
	function Lire_Point(Fic: File_Type) return Point2D is
		Res: Point2D;
	begin
		Res(1) := Lire_Float_Fichier(Fic);
		Lire_Caractere_Fichier(Fic); -- On passe la virgule
		Res(2) := Lire_Float_Fichier(Fic);

		return Res;
	end;	

	procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
		Fic: File_Type;
		Caractere_Lu: Character;
		Commande_Precedente: Character;
		Point_Courant: Point2D := (0.0,0.0);
		P1,P2,P3: Point2D;
		Liste_Temp: Liste;
	begin
		Ouvrir_Fichier_Lecture(Fic,Nom_Fichier);
		
		-- On parcourt le fichier et on s'arrête après la première balise path puis on cherche l'attribut d
		if not Trouver_Chaine_Fichier(Fic,"<path") or else Trouver_Chaine_Fichier(Fic,"d=""")  then
			Put_Line(Standard_Error, "Erreur, pas de balises path dans le fichier SVG ou bien pas d'attribut d");
			raise Erreur_Chargement_Exception;
		end if;

		Caractere_Lu := Lire_Caractere_Fichier(Fic);
		-- On suppose que le fichier est normalement constitué, ie il reste bien un guillemet à
		-- lire avant la fin du fichier
		while Caractere_Lu /= '"' loop
			case Caractere_Lu is
				when '0'..'9' =>
					-- Répéter la commande précédente 
					-- while not virgule etc
					-- TODO
					null;
				when 'M' =>
					-- changer point courant (absolu)
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant := Lire_Point(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'L'; -- exception pour la commande M
				when 'm' =>
					-- changer point courant (relatif)
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant := Point_Courant + Lire_Point(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'l'; -- exception pour la commande m
				when 'L' =>
					-- Line to, abs
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant := Lire_Point(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'L';
				when 'l' =>
					-- Line to, rel
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant := Point_Courant + Lire_Point(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'l';
				when 'H' =>
					-- Déplacement horizontal (absolu)
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant(1) := Lire_Float_Fichier(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'H';
				when 'h' =>
					-- changer point courant (relatif)
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant(1) := Point_Courant(1) + Lire_Float_Fichier(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'h';
				when 'V' =>
					-- Line to, rajoute 1 point - abs
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant(2) := Lire_Float_Fichier(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'V';
				when 'v' =>
					-- Line to, rajoute 1 point - rel
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					Point_Courant(2) := Point_Courant(2) + Lire_Float_Fichier(Fic);
					Insertion_Tete(L,Point_Courant);
					Commande_Precedente := 'v';
				when 'Q' =>
					-- bezier quadra, rajoute N point - abs
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P1 := Lire_Point(Fic);
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P2 := Lire_Point(Fic);
					Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER);
					Fusion(L,Liste_Temp);
					Commande_Precedente := 'Q';
				when 'q' =>
					-- bezier quadra, rajoute N point - rel
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P1 := Lire_Point(Fic) + Point_Courant;
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P2 := Lire_Point(Fic) + Point_Courant;
					Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER);
					Fusion(L,Liste_Temp);
					Commande_Precedente := 'q';
				when 'C' =>
					-- bezier quadra, rajoute N point - abs
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P1 := Lire_Point(Fic);
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P2 := Lire_Point(Fic);
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P3 := Lire_Point(Fic);
					Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER);
					Fusion(L,Liste_Temp);
					Commande_Precedente := 'C';
				when 'c' =>
					-- bezier cubique, rajoute N point - rel
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P1 := Lire_Point(Fic) + Point_Courant;
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P2 := Lire_Point(Fic) + Point_Courant;
					Lire_Caractere_Fichier(Fic); --passer l'espace qui suit
					P3 := Lire_Point(Fic) + Point_Courant;
					Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER);
					Fusion(L,Liste_Temp);
					Commande_Precedente := 'c';
				when others =>
					Put_Line(Standard_Error, "Erreur, commande path non reconnue : " & Caractere_Lu);
			end case;
			Lire_Caractere_Fichier(Fic); -- passer l'espace
			Caractere_Lu := Lire_Caractere_Fichier(Fic);
		end loop;
		
		-- translater de (-xmin,-ymin)

		Fermer_Fichier(Fic);
	end;

end;
