with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Parser_Svg is
    Erreur_Chargement_Exception: Exception;

    -- Cherche les minima pour x et y et fait une translation de (-xmin,-ymin)
    procedure Translater_Liste(L: in out liste) is
        X_Min,Y_Min: Float;
        Premier_Point: Boolean := True;

        procedure Test_Point(P: in out Point2D) is
        begin
            if Premier_Point then
                Premier_Point := False;
                X_Min := P(1);
                Y_Min := P(2);
                return;
            end if;

            if P(1) < X_Min then
                X_Min := P(1);
            end if;

            if P(2) < Y_Min then
                Y_Min := P(2);
            end if;
        end;

        procedure Translater_Point(P: in out Point2D) is
        begin
            P(1) := P(1) - X_Min;
            P(2) := P(2) - Y_Min;
        end;

        procedure Chercher_Minima is new Parcourir(Traiter=>Test_Point);
        procedure Translater is new Parcourir(Traiter=>Translater_Point);
    begin
        Chercher_Minima(L);
        Translater(L);
    end;

    procedure Lire_Float(Chaine: String; Indice: in out Integer; F: out Float) is
        Nombre: Unbounded_String := To_Unbounded_String("");
    begin
        while Indice <= Chaine'Last and then Chaine(Indice) /= ',' and then Chaine(Indice) /= ' ' loop
            Nombre := Nombre & Chaine(Indice);
            Indice := Indice+1;
        end loop;
        Indice := Indice+1; -- On passe l'espace ou la virgule
        F := Float'Value(To_String(Nombre));
    end;

    procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
        Fic: File_Type;
        Caractere_Lu: Character;
        Chemin: Unbounded_String := To_Unbounded_String(""); -- Valeur de l'attribut d de la balise path (on utilise une chaine car le parcours de fichier dans les deux sens n'est pas très pratique dans ce langage)
        Commande: Character;
        Point_Courant: Point2D := (0.0,0.0);
        P1,P2,P3: Point2D;
		F: Float;
        Liste_Temp: Liste;
        Indice: Integer; 

        -- Fonction servant à lire les coordonnées d'un point 2D dans un fichier ouvert en mode lecture
        procedure Lire_Point(Chaine: String;Indice: in out Integer; P: out Point2D) is
			F: Float;
		begin
            Lire_Float(Chaine,Indice,F);
			P(1) := F;
            Lire_Float(Chaine,Indice,F);
			P(2) := F;
        end;

    begin
        -- ********* A mettre dans une fonction à part ******************
        Ouvrir_Fichier_Lecture(Fic,Nom_Fichier);

        -- On parcourt le fichier et on s'arrête après la première balise path puis on cherche l'attribut d
        if not Trouver_Chaine_Fichier(Fic,"<path") or else not Trouver_Chaine_Fichier(Fic,"d=""")  then
            Put_Line(Standard_Error, "Erreur, pas de balise path dans le fichier SVG ou bien pas d'attribut d dans la balise path");
            raise Erreur_Chargement_Exception;
        end if;

        -- On suppose que le fichier est normalement constitué, ie il reste bien un guillemet à
        -- lire avant la fin du fichier
        Caractere_Lu := Lire_Caractere_Fichier(Fic);
        while Caractere_Lu /= '"' loop
            Chemin := Chemin & Caractere_Lu;
            Caractere_Lu := Lire_Caractere_Fichier(Fic);
        end loop;

        -- On a lu ce qu'on voulait lire
        Fermer_Fichier(Fic);
        -- ************* Fin du truc à mettre à part *****************

        Indice := 1;
        while Indice<=Length(Chemin) loop
            if not (Element(Chemin, Indice) in '0'..'9') and then Element(Chemin, Indice) /= '-' then -- Ici Element(Chemin, Indice) est une lettre => nouvelle commande
                Commande := Element(Chemin, Indice);
                Indice := Indice + 2; -- Pour passer l'espace qui suit
            end if;

            case Commande is
                    -- les commandes L et M sont traitées indifféremment car on ne travaille qu'avec une seule liste de points
                    -- donc a priori la commande M n'est même pas censée apparaitre plus d'une fois
                when 'L' | 'M' =>
                    -- Line to, abs
                    Lire_Point(To_String(Chemin),Indice,Point_Courant);
                    Insertion_Tete(L,Point_Courant);
                when 'l' | 'm' => 
                    -- Line to, rel
					Lire_Point(To_String(Chemin),Indice,P1);
                    Point_Courant := Point_Courant + P1; 
                    Insertion_Tete(L,Point_Courant);
                when 'H' =>
                    -- Déplacement horizontal (absolu)
					Lire_Float(To_String(Chemin),Indice,F);
                    Point_Courant(1) := F;
                    Insertion_Tete(L,Point_Courant);
                when 'h' =>
                    -- Déplacement horizontal (relatif)
					Lire_Float(To_String(Chemin),Indice,F);
                    Point_Courant(1) := Point_Courant(1) + F;
                    Insertion_Tete(L,Point_Courant);
                when 'V' =>
                    -- Déplacement vertical - abs
					Lire_Float(To_String(Chemin),Indice,F);
                    Point_Courant(2) := F;
                    Insertion_Tete(L,Point_Courant);
                when 'v' =>
                    -- Déplacement vertical - rel
					Lire_Float(To_String(Chemin),Indice,F);
                    Point_Courant(2) := Point_Courant(2) + F;
                    Insertion_Tete(L,Point_Courant);
                when 'Q' =>
                    -- bezier quadra, rajoute N point - abs
                    Lire_Point(To_String(Chemin),Indice,P1);
                    Lire_Point(To_String(Chemin),Indice,P2);
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                    Point_Courant := P2;
                when 'q' =>
                    -- bezier quadra, rajoute N point - rel
                    Lire_Point(To_String(Chemin),Indice,P1);
					P1 := P1 + Point_Courant;
                    Lire_Point(To_String(Chemin),Indice,P2);
				    P2 := P2 + Point_Courant;
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                    Point_Courant := P2;
                when 'C' =>
                    -- bezier quadra, rajoute N point - abs
                    Lire_Point(To_String(Chemin),Indice,P1);
                    Lire_Point(To_String(Chemin),Indice,P2);
                    Lire_Point(To_String(Chemin),Indice,P3);
                    Bezier(Point_Courant,P1,P2,P3,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                    Point_Courant := P3;
                when 'c' =>
                    -- bezier cubique, rajoute N point - rel
                    Lire_Point(To_String(Chemin),Indice,P1);
				    P1 := P1 + Point_Courant;
                    Lire_Point(To_String(Chemin),Indice,P2);
				    P2 := P2 + Point_Courant;
                    Lire_Point(To_String(Chemin),Indice,P3);
					P3 := P3 + Point_Courant;
                    Bezier(Point_Courant,P1,P2,P3,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                    Point_Courant := P3;
                when others =>
                    Put_Line(Standard_Error, "Erreur, commande de path non reconnue : " & Element(Chemin, Indice));
                    raise Erreur_Chargement_Exception;
            end case;
        end loop;

        Translater_Liste(L);
    end;

end;
