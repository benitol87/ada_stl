cd $(dirname $0)

# Début des tests
TESTS="tests"
SVG="$TESTS/svg"
STL="$TESTS/stl"
mkdir -p $TESTS $SVG $STL

# Test du package Math
echo " ** Début du test du package Math **"
gnatmake -q test_math.adb
./test_math
rm test_math
echo ""

# Test du package Liste
echo " ** Début du test du package Liste **"
gnatmake -q test_liste.adb
./test_liste
if [ $? -ne 0 ]
then
    echo "Echec du test"
else
    echo "Test réussi"
fi
rm test_liste
echo ""

# Test du package Fichier
echo " ** Début du test du package Fichier **"
gnatmake -q test_fichier.adb
./test_fichier
rm test_fichier fichier.svg
echo ""

# Test du package STL
echo " ** Début du test du package STL **"
gnatmake -q test_stl.adb
./test_stl
rm test_stl
echo ""

# Test du package Parser_SVG
echo " ** Début du test du package Parser_SVG **"
gnatmake -q test_parser.adb
./test_parser
rm test_parser
echo ""

# Test du programme principal
echo " ** Début du test du programme **"
gnatmake -q main.adb
for fic in $(cd svg && ls *.svg)
do
	fic="${fic%.svg}"
	./main "svg/${fic}.svg" "stl/${fic}.stl"
	echo "Fichier stl/${fic}.stl créé"
done
rm main
echo ""

# Fin des tests
rm *.o *.ali

for svg in $(ls *.svg 2>/dev/null)
do
	mv "$svg" "$SVG/$svg"
done

for stl in $(ls *.stl 2>/dev/null)
do
	mv "$stl" "$STL/$stl"
done
