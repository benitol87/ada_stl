with Parser_Svg; use Parser_Svg;
with Ada.Text_IO; use Ada.Text_IO;
with Fichier; use Fichier;
with Test; use Test;
with Math; use Math;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Test_Parser is
	Fic: File_Type;
	L: Liste_Points.Liste;
	Chaine: Unbounded_String;
	Compteur: Integer:=1;

	procedure Ecrire_SVG(Nom_Fichier,Courbe: String) is
	begin	
		Ouvrir_Fichier_Ecriture(Fic, Nom_Fichier);
		Ecrire_Fichier(Fic, "<svg width='200' height='200'>" &
		"<path fill='none' stroke='green' stroke-width='2' " &
		"d=""" & Courbe & """/></svg>");
		Fermer_Fichier(Fic);
	end;

	procedure Traiter_Point(P: in out Point2D) is
	begin
		Chaine := Chaine & To_Unbounded_String(Str_Float(P(1)) & "," & Str_Float(P(2)) & " ");
	end;

	procedure Parcourir_Liste is new Liste_Points.Parcourir(Traiter=>Traiter_Point);

	procedure Test(Courbe: String) is
	begin
		Chaine:=To_Unbounded_String("M ");
		Ecrire_SVG("svg/parser_expected" & Str_Integer(Compteur) & ".svg",Courbe);
		Chargement_Bezier("svg/parser_expected" & Str_Integer(Compteur) & ".svg", L);

		Parcourir_Liste(L);
		Liste_Points.Vider(L);

		Ecrire_SVG("svg/parser_actual" & Str_Integer(Compteur) & ".svg",To_String(Chaine));
		Compteur:=Compteur+1;
	end;
begin
	Test("M 0,0 20,30 40,50 60,10 10,15 0,0");
	Test("m 0,0 20,30 20,20 20,-40 -50,5 100,50");
	Test("M 0,0 10,10 H 20 40 10 15 0");
	Test("M 0,0 10,10 h 20 50 60 10 0");
	Test("M 0,0 10,10 V 30 40 10 15 0");
	Test("M 0,0 10,10 v 30 50 60 10 0");
	Test("M 10,20 C 30,10 20,-20 50,10 60,100 10,-20 150,150");
	Test("M 0,0 10,10 c 30,10 20,-20 50,0 60,10 10,-20 10,10");
	Test("M 0,0 10,30 Q 30,10 20,0 50,0 60,100 10,-20 150,150");
	Test("M 0,0 10,30 q 30,10 20,-20 50,0 60,10 10,-20 10,10");
	Test("M 0,0 10,50 q 30,10 20,-20 50,0 60,10 h 20 50 60 10 0 Q 30,10 20,-20 V 30 40 10 15 0 c 30,10 20,-20 50,0 60,10 10,-20 10,10 v 30 50 60 10 0 C 30,10 20,-20 50,10 60,100 10,-20 150,150 H 20 40 10 15 0");

	Put_Line("Fichiers svg/parser_expected1.svg à svg/parser_expected" & Str_Integer(Compteur) & ".svg et svg/parser_actual1.svg à svg/parser_actual" & Str_Integer(Compteur) & ".svg");
end;
