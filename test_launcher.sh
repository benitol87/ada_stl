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

# Test du package Fichier
echo " ** Début du test du package Fichier **"
gnatmake -q test_fichier.adb
./test_fichier
rm test_fichier fichier.svg
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
