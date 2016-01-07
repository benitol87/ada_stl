with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Parser_Svg is
    Erreur_Chargement_Exception: Exception; 

    procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste) is
        Fic: File_Type;
        Caractere_Lu: Character;
        Chemin: Unbounded_String := To_Unbounded_String(""); -- Valeur de l'attribut d de la balise path (on utilise une chaine car le parcours de fichier dans les deux sens n'est pas très pratique dans ce langage)
        Commande: Character;
        Point_Courant: Point2D := (0.0,0.0);
        P1,P2,P3: Point2D;
        Liste_Temp: Liste;
        Indice: Integer; 
        X_Min, Y_Min: Float := 0.0;

        function Lire_Float(Chaine: String; Indice: in out Integer) return Float is
            Nombre: Unbounded_String := To_Unbounded_String("");
        begin
            while Chaine(Indice) /= ',' and then Chaine(Indice) /= ' ' loop
                Nombre := Nombre & Chaine(Indice);
                Indice := Indice+1;
            end loop;
            Indice := Indice+1; -- On passe l'espace ou la virgule
            return Float'Value(To_String(Nombre));
        end;

        -- Fonction servant à lire les coordonnées d'un point 2D dans un fichier ouvert en mode lecture
        function Lire_Point(Chaine: String;Indice: in out Integer) return Point2D is
            Res: Point2D;
        begin
            Res(1) := Lire_Float(Chaine,Indice);
            Res(2) := Lire_Float(Chaine,Indice);
            return Res;
        end;

    begin
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

        Indice := 1;

        -- Lecture du premier point
        Commande := Element(Chemin, Indice);
        Indice := Indice+2;
        Point_Courant := Lire_Point(To_String(Chemin),Indice);
        X_Min := Point_Courant(1);
        Y_Min := Point_Courant(2);

        while Indice<=Length(Chemin) loop
            if not (Element(Chemin, Indice) in '0'..'9') and then Element(Chemin, Indice) /= '-' then -- Ici Element(Chemin, Indice) est une lettre => nouvelle commande
                Commande := Element(Chemin, Indice);
                Put_Line("Commande : " & Commande);
                Indice := Indice + 2; -- Pour passer l'espace qui suit
            end if;

            case Commande is
                    -- les commandes L et M sont traitées indifféremment car on ne travaille qu'avec une seule liste de points
                    -- donc a priori la commande M n'est même pas censée apparaitre plus d'une fois
                when 'L' | 'M' =>
                    -- Line to, abs
                    Point_Courant := Lire_Point(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'l' | 'm' => 
                    -- Line to, rel
                    Point_Courant := Point_Courant + Lire_Point(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'H' =>
                    -- Déplacement horizontal (absolu)
                    Point_Courant(1) := Lire_Float(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'h' =>
                    -- Déplacement horizontal (relatif)
                    Point_Courant(1) := Point_Courant(1) + Lire_Float(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'V' =>
                    -- Déplacement vertical - abs
                    Point_Courant(2) := Lire_Float(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'v' =>
                    -- Déplacement vertical - rel
                    Point_Courant(2) := Point_Courant(2) + Lire_Float(To_String(Chemin),Indice);
                    Insertion_Tete(L,Point_Courant);
                when 'Q' =>
                    -- bezier quadra, rajoute N point - abs
                    P1 := Lire_Point(To_String(Chemin),Indice);
                    P2 := Lire_Point(To_String(Chemin),Indice);
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                when 'q' =>
                    -- bezier quadra, rajoute N point - rel
                    P1 := Lire_Point(To_String(Chemin),Indice) + Point_Courant;
                    P2 := Lire_Point(To_String(Chemin),Indice) + Point_Courant;
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                when 'C' =>
                    -- bezier quadra, rajoute N point - abs
                    P1 := Lire_Point(To_String(Chemin),Indice);
                    P2 := Lire_Point(To_String(Chemin),Indice);
                    P3 := Lire_Point(To_String(Chemin),Indice);
                    Put_Line("Points récupérés");
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Put_Line("Bezier fini");
                    Fusion(L,Liste_Temp);
                    Put_Line("Fusion finie");
                when 'c' =>
                    -- bezier cubique, rajoute N point - rel
                    P1 := Lire_Point(To_String(Chemin),Indice) + Point_Courant;
                    P2 := Lire_Point(To_String(Chemin),Indice) + Point_Courant;
                    P3 := Lire_Point(To_String(Chemin),Indice) + Point_Courant;
                    Bezier(Point_Courant,P1,P2,NB_POINTS_BEZIER,Liste_Temp);
                    Fusion(L,Liste_Temp);
                when others =>
                    Put_Line(Standard_Error, "Erreur, commande de path non reconnue : " & Element(Chemin, Indice));
                    raise Erreur_Chargement_Exception;
            end case;
        end loop;

        -- TODO translater de (-xmin,-ymin) 
    end;

end;
