with Liste_Generique;

package Math is

	type Vecteur is array(Positive range<>) of Float;
	subtype Point2D is Vecteur(1..2);
	subtype Point3D is Vecteur(1..3);
	package Liste_Points is new Liste_Generique(Point2D);
	use Liste_Points;

	-- Calcul des coordonnées d'un point d'une courbe de Bézier linéaire
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Lineaire(P0,P1: Point2D ; T: Float) return Point2D;

	-- Calcul des coordonnées d'un point d'une courbe de Bézier quadratique 
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Quadratique(P0,P1,P2: Point2D ; T: Float) return Point2D;

	-- Calcul des coordonnées d'un point d'une courbe de Bézier cubique 
	-- Requiert :
	--   * 0 <= T <= 1
	function Bezier_Cubique(P0,P1,P2,P3: Point2D ; T: Float) return Point2D;

	-- Convertit une courbe de Bezier cubique en segments
	-- P1 : Point de départ de la courbe
	-- C1 : Point de contrôle au début de la courbe
	-- C2 : Point de contrôle à la fin de la courbe
	-- P2 : Point final de la courbe
	-- Requiert : 
	--   * Nb_Points >= 2
	-- Assure :
	--   * Points contient Nb_Points points appartenant à la
	--   courbe de Bézier passée en paramètre
	procedure Bezier(P1, C1, C2, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste);

	-- Convertit une courbe de Bezier quadratique en segments
	-- P1 : Point de départ de la courbe
	-- C : Point de contrôle de la courbe
	-- P2 : Point final de la courbe
	-- Requiert : 
	--   * Nb_Points >= 2
	-- Assure :
	--   * Points contient Nb_Points points appartenant à la
	--   courbe de Bézier passée en paramètre
	procedure Bezier(P1, C, P2 : Point2D ; Nb_Points : Positive ;
		Points : out Liste);

	-- addition de 2 vecteurs
	-- requiert A'Length = B'Length
	function "+" (A : Vecteur ; B : Vecteur) return Vecteur;
	-- multiplication scalaire vecteur
	function "*" (Facteur : Float ; V : Vecteur) return Vecteur;

	-- Transforme un point à 2 coordonnées (x,y) en un point à 3 coordonnées (x,y,0)
	function To_Point3D(P: Point2D) return Point3D;

	-- Prend P et effectue une rotation autour de l'axe X de Angle degrés
	-- Renvoie le point obtenu après rotation
	function Rotation_Axe_X(P: Point3D; Angle: Float) return Point3D;
end;
