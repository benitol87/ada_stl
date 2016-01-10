with Liste_generique ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Integer_Text_Io ; use Ada.Integer_Text_Io ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Test; use Test;

procedure Test_liste is

	package Liste_caractere is new Liste_generique(Character);
	use Liste_caractere ;
	
	function Transforme (L : Liste) return String is 
		S : Unbounded_String ;

		procedure Concat(C: in out Character) is
		begin
			S := S & C;
		end;

		procedure Parcours is new Parcourir(Traiter=>Concat);
	begin
		S := To_Unbounded_String("");
		Parcours(L);
		return To_String(S) ;
	end ;
	
	function TransformeBis (L : Liste) return String is
		S : Unbounded_String ;

		procedure Affiche_Couple(C1,C2 : in Character) is
		begin
			S := S & C1 & C2;
		end;
		
		procedure ParcoursBis is new Parcourir_Par_Couples(Traiter=>Affiche_Couple);
	begin
		S := To_Unbounded_String("");
		ParcoursBis(L);
		return To_String(S) ;
	end ;
	
	L,M : Liste ;

    procedure Test_Vider is
    begin
        Vider(L);
        Assert_Equals(Taille(L),0);
    end;

    procedure Tester_Liste(T:Natural; Premier,Dernier: Character; L: Liste) is
    begin
        Assert_Equals(Taille(L),T);
        Assert_Equals(Tete(L),Premier);
        Assert_Equals(Queue(L),Dernier);
    end;

    procedure Test_Insertion_Tete is
    begin
        Insertion_Tete(L, 'i');
        Assert_Equals(Transforme(L),"i");
        Tester_Liste(1,'i','i',L);
        Insertion_Tete(L, 'h');
        Assert_Equals(Transforme(L),"hi");
        Assert_Equals(TransformeBis(L),"hi");
        Tester_Liste(2,'h','i',L);
        Insertion_Tete(L, 'g');
        Assert_Equals(Transforme(L),"ghi");
        Assert_Equals(TransformeBis(L),"ghhi");
        Tester_Liste(3,'g','i',L);
        Insertion_Tete(L, 'f');
        Assert_Equals(Transforme(L),"fghi");
        Assert_Equals(TransformeBis(L),"fgghhi");
        Tester_Liste(4,'f','i',L);
        Insertion_Tete(L, 'e');
        Assert_Equals(Transforme(L),"efghi");
        Insertion_Tete(L, 'd');
        Assert_Equals(Transforme(L),"defghi");
        Insertion_Tete(L, 'c');
        Assert_Equals(Transforme(L),"cdefghi");
        Insertion_Tete(L, 'b');
        Assert_Equals(Transforme(L),"bcdefghi");
        Insertion_Tete(L, 'a');
        Assert_Equals(Transforme(L),"abcdefghi");
        Vider(L);
        Assert_Equals(Transforme(L),"");
    end;

    procedure Test_Insertion_Queue is
    begin
        Insertion_Queue(L, 'j');
        Assert_Equals(Transforme(L),"j");
        Tester_Liste(1,'j','j',L);
        Insertion_Queue(L, 'k');
        Assert_Equals(Transforme(L),"jk");
        Assert_Equals(TransformeBis(L),"jk");
        Tester_Liste(2,'j','k',L);
        Insertion_Queue(L, 'l');
        Assert_Equals(Transforme(L),"jkl");
        Assert_Equals(TransformeBis(L),"jkkl");
        Tester_Liste(3,'j','l',L);
        Insertion_Queue(L, 'm');
        Assert_Equals(Transforme(L),"jklm");
        Assert_Equals(TransformeBis(L),"jkkllm");
        Insertion_Queue(L, 'n');
        Assert_Equals(Transforme(L),"jklmn");
        Assert_Equals(TransformeBis(L),"jkkllmmn");
        Vider(L);
        Assert_Equals(Transforme(L),"");
    end;

    procedure Test_Concatenation is
    begin
        Insertion_Queue(L,'a');
        Insertion_Queue(L,'b');
        Insertion_Queue(L,'c');
        Insertion_Queue(L,'d');
        Assert_Equals(Transforme(L),"abcd");
        Tester_Liste(4,'a','d',L);

        Insertion_Queue(M,'e');
        Insertion_Queue(M,'f');
        Insertion_Queue(M,'g');
        Insertion_Queue(M,'h');
        Insertion_Queue(M,'i');
        Insertion_Queue(M,'j');
        Assert_Equals(Transforme(M),"efghij");
        Tester_Liste(6,'e','j',M);

        Fusion(L,M);

        Assert_Equals(Transforme(L),"abcdefghij");
        Tester_Liste(10,'a','j',L);

        Assert_Equals(Transforme(M),"");
        Assert_Equals(Taille(M),0);
    end;
begin
    Test_Insertion_Tete;
    Test_Vider;
    Test_Insertion_Queue;
    Test_Vider; 
    Test_Concatenation;
end;
