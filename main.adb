with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed,Ada.Strings; use Ada.Strings.Fixed,Ada.Strings;
with Fichier; use Fichier;
with Math; use Math;
with STL; use STL;
with Parser_Svg; use Parser_Svg;

procedure Main is
    Segments : Liste_Points.Liste;
    Facettes : Liste_Facettes.Liste;
    FICHIER_CONFIG: String := "config.txt";

    procedure Charger_Config is
        Fic: File_Type;

        procedure Config(Cle,Valeur: String) is
            Val: Integer;
        begin
            if Cle = "nbRotations" then
                begin
                    Val := Integer'Value(Valeur);
                exception
                    when Constraint_Error => Put_Line(Standard_Error, "La valeur de nbRotations doit être un entier");
                end;

                if Val > 2 then
                    NB_ROTATIONS:=Val; -- On modifie la valeur si celle passée en config vaut au moins 3
                else
                    Put_Line(Standard_Error, "La valeur de nbRotations doit être strictement supérieure à 2 (valeur par défaut conservée)");
                end if;
            elsif Cle = "nbPointsBezier" then
                begin
                    Val := Integer'Value(Valeur);
                exception
                    when Constraint_Error => Put_Line(Standard_Error, "La valeur de nbPointsBezier doit être un entier");
                end;

                if Val > 1 then
                    NB_POINTS_BEZIER := Val; -- On modifie la valeur si celle passée en config vaut au moins 2
                else
                    Put_Line(Standard_Error, "La valeur de nbPointsBezier doit être strictement supérieure à 1 (valeur par défaut conservée)");
                end if;
            else
                Put_Line(Standard_Error,"Erreur lors de la lecture du fichier de configuration, clé non reconnue : " & Cle);
            end if;
        end;
    begin
        Ouvrir_Fichier_Lecture(Fic,FICHIER_CONFIG);

        while not End_Of_File (Fic) loop
            declare
                Ligne : String := Trim(Get_Line (Fic),Both);
                Indice: Integer := Ligne'First;
            begin
                while Indice<Ligne'Last and then Ligne(Indice) /= '=' loop
                    Indice:=Indice+1;
                end loop;

                if Indice /= Ligne'First and then Indice /= Ligne'Last then
                    Config(
                        Trim(Ligne(Ligne'First..Indice-1),Both), -- clé
                        Trim(Ligne(Indice+1..Ligne'Last) ,Both)  -- valeur
                        );
                end if;
            end;
        end loop;

        Fermer_Fichier(Fic);
    end;
begin

    if Argument_Count /= 2 then
        Put_Line(Standard_Error,
        "usage : " & Command_Name &
        " fichier_entree.svg fichier_sortie.stl");
        Set_Exit_Status(Failure);
        return;
    end if;

    -- Chargement de la configuration
    Charger_Config;
    --on charge la courbe de bezier et la convertit en segments
    Chargement_Bezier(Argument(1), Segments);
    --on convertit en facettes par rotation
    Creation(Segments, Facettes);
    --on sauvegarde le modele obtenu
    Sauvegarder(Argument(2), Facettes);
exception
    when Name_Error =>
        Put_Line(Standard_Error, "Erreur : Fichier SVG non trouvé");
        Set_Exit_Status(Failure);
end;
