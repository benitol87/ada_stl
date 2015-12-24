with Ada.Text_IO;	use Ada.Text_IO;

package fichier is
	-- Contient des methodes pour g�rer les fichiers

	-- Procedure pour ouvrir un fichier en mode �criture seule. Si le fichier n'est pas trouv�, il sera cr��
	-- Requiert : Nom_Fichier ne doit pas etre vide 
	procedure Ouvrir_Fichier_Ecriture(Fic: out File_Type; Nom_Fichier: String);

	-- Procedure pour ouvrir un fichier en mode lecture seule
	-- Requiert :
	-- 	Nom_Fichier doit correspondre � un fichier existant,
	-- 	sinon une exception est lev�e
	procedure Ouvrir_Fichier_Lecture(Fic: out File_Type; Nom_Fichier: String);

	-- Fonction qui lit un caract�re dans Fic
	-- Avance �galement le curseur de lecture du fichier d'un caract�re
	-- Requiert : 
	--	End_Of_File(Fic) = False
	function Lire_Caractere_Fichier(Fic: File_Type) return Character;

	-- Fonction qui lit un nombre flottant dans Fic
	-- Place le curseur du fichier sur le caract�re qui suit le nombre lu
	-- Requiert :
	-- 
	function Lire_Float_Fichier(Fic: File_Type) return Float;

	-- Procedure pour ecrire dans un fichier
	-- Requiert : Fic doit avoir �t� ouvert en mode �criture
	procedure Ecrire_Fichier(Fic: File_Type; Donnees: String);

	-- Procedure pour fermer un fichier ouvert
	-- Cette procedure doit imperativement etre appelee pour que les
	-- modifications soient prises en compte
	procedure Fermer_Fichier(Fic: in out File_Type);

end;
