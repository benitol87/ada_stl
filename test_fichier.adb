with Fichier; use Fichier;
with Ada.Text_IO; use Ada.Text_IO;

procedure Test_Fichier is
    Fic: File_Type;
    NOM_FICHIER: String:="fichier.svg";
    Echec_Test: Boolean:=False;
begin
    -- Ecriture
    Ouvrir_Fichier_Ecriture(Fic, NOM_FICHIER);
    Ecrire_Fichier(Fic, "<svg width='200' height='200'>" &
    " <path d=""M 10,10 20.0,20.0""/>" &
    "</svg>");
    Fermer_Fichier(Fic);

    -- Lecture
    Ouvrir_Fichier_Lecture(Fic,NOM_FICHIER);

    Echec_Test := Echec_Test or not Trouver_Chaine_Fichier(Fic, "<svg");
    Echec_Test := Echec_Test or Lire_Caractere_Fichier(Fic)/=' ';
    Echec_Test := Echec_Test or not Trouver_Chaine_Fichier(Fic, "width='");
    Echec_Test := Echec_Test or Lire_Float_Fichier(Fic)/=200.0;
    Echec_Test := Echec_Test or Lire_Caractere_Fichier(Fic)/=''';
    Echec_Test := Echec_Test or not Trouver_Chaine_Fichier(Fic,"='");
    Echec_Test := Echec_Test or not Trouver_Chaine_Fichier(Fic,"</svg>");
    Echec_Test := Echec_Test or not End_Of_File(Fic);
    Fermer_Fichier(Fic);

    if Echec_Test then
        Put_Line(Standard_Error, "Erreur, échec du test du package fichier");
    else
        Put_Line("Test du package fichier reussi");
    end if;
end;
