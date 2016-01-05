with Math; use Math;
with Fichier; use Fichier;

package Parser_Svg is
	use Liste_Points;

	NB_POINTS_BEZIER: Integer:= 10;

	--parse un fichier svg et retourne une liste de points (voir documentation)
	procedure Chargement_Bezier(Nom_Fichier : String; L : out Liste);
end;
