with Ada.Text_IO;	use Ada.Text_IO;

package body fichier is
	procedure Ouvrir_Fichier_Ecriture(Fic: out File_Type; Nom_Fichier: String) is
	begin
		begin
			Open(Fic, Mode=>Out_File, Name=>Nom_Fichier);
		exception
			when Name_Error => -- Fichier non trouve
				Create(Fic, Mode=>Out_File, Name=>Nom_Fichier);
		end;
	end;

	procedure Ouvrir_Fichier_Lecture(Fic: out File_Type; Nom_Fichier: String) is
	begin
		Open(Fic, Mode=>In_File, Name=>Nom_Fichier);
	end;

	function Lire_Caractere_Fichier(Fic: File_Type) return Character is
		C : Character;
	begin
		Get(Fic, C);
		return C;
	end;

	function Lire_Float_Fichier(Fic: File_Type) return Float is
		Nombre: Float;
	begin
		Get(Fic, Nombre);
		return Nombre;
	end;

	procedure Ecrire_Fichier(Fic: File_Type; Donnees: String) is
	begin
		Put(Fic, Donnees);
	end;

	procedure Fermer_Fichier(Fic: in out File_Type) is
	begin
		Close(Fic);
	end;
end;
