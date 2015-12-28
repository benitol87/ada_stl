with Ada.Text_IO;	use Ada.Text_IO;

package Fichier is
	-- Contient des methodes pour gérer les fichiers

	-- Procedure pour ouvrir un fichier en mode écriture seule. Si le fichier n'est pas trouvé, il sera créé
	-- Requiert :
	-- 	Nom_Fichier ne doit pas etre vide 
	procedure Ouvrir_Fichier_Ecriture(Fic: out File_Type; Nom_Fichier: String);

	-- Procedure pour ouvrir un fichier en mode lecture seule
	-- Requiert :
	-- 	Nom_Fichier doit correspondre à un fichier existant,
	-- 	sinon une exception est levée
	procedure Ouvrir_Fichier_Lecture(Fic: out File_Type; Nom_Fichier: String);

	-- Fonction qui lit un caractère dans Fic
	-- Avance également le curseur de lecture du fichier d'un caractère
	-- Requiert :
	-- 	Fic a été ouvert en mode lecture 
	--	End_Of_File(Fic) = False
	function Lire_Caractere_Fichier(Fic: File_Type) return Character;

	-- Fonction qui lit un nombre flottant dans Fic
	-- Place le curseur du fichier sur le caractère qui suit le nombre lu
	-- Requiert :
	-- 	Fic a été ouvert en mode lecture
	function Lire_Float_Fichier(Fic: File_Type) return Float;

	-- Procedure pour ecrire dans un fichier
	-- Requiert : Fic doit avoir été ouvert en mode écriture
	procedure Ecrire_Fichier(Fic: File_Type; Donnees: String);

	-- Procedure pour fermer un fichier ouvert
	-- Cette procedure doit imperativement etre appelee pour que les
	-- modifications soient prises en compte
	procedure Fermer_Fichier(Fic: in out File_Type);

	-- Parcourt Fic caractère par caractère jusqu'à trouver la chaine passée
	-- en paramètre ou jusqu'à la fin du fichier
	-- Commence à partir de la position actuelle du curseur du fichier
	-- Renvoie True si la chaine a été trouvée, False sinon
	-- Le curseur du fichier est placé de telle sorte que le prochain
	-- caractère lu est celui qui suit la chaine passée en paramètre si
	-- celle-ci est trouvée
	-- Requiert : 
	-- 	* Fic doit avoir été ouvert en mode lecture
	--	* Chaine ne doit pas être vide
	function Trouver_Chaine_Fichier(Fic: File_Type; Chaine: String) return Boolean;
end;
