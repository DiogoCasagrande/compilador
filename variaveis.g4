grammar variaveis;

@header { import java.util.*; }
@members {
	Variavel x = new Variavel();
	ControleVariavel cv = new ControleVariavel();
	String saida="";
	int escopo;
	int tipo;
	String nome;
}

inicio: {escopo = 0; saida+="public class Saida{\n\t";}
		declvar
		'inicio' {escopo = 1; saida+="\n\tpublic static void main(String args[]){\n\t\t";}
		declvar
		cmd
		'fim' {saida+="}\n}"; System.out.println(saida);}
		;

declvar:(	tipo
			ID {x = new Variavel($ID.text, tipo, escopo);
				boolean ret = cv.adiciona(x);
				if(!ret){
					System.out.println("Variavel "+$ID.text+" ja foi declarada!!!");
					System.exit(0);
				}
			}
			PV {saida+=$ID.text+";\n\t";}
		)*;

tipo: 	(	'int' {tipo = 0; saida+="int ";}
			| 'char' {tipo = 1; saida+="char ";}
			| 'double' {tipo = 2; saida+="double ";}
		);
		
cmd:	(cond | atrib)*;

cond:	'se' {saida+="if";}
		AP {saida+="(";}
		comp
		FP {saida+=")";}
		AC {saida+="{";}
		cmd
		FC {saida+="}";}
		('senao' {saida+="else"; }
		 AC {saida+="{"; }
		 cmd
		 FC {saida+="}"; }
		)? ;
		
comp:	(ID {	boolean ret = cv.jaExiste($ID.text);
				if(!ret){
					System.out.println("Variavel "+$ID.text+" não existe!!!");
					System.exit(0);
				}
				saida+=$ID.text+" ";
			}
		| NUM {saida+=$NUM.text+" ";}
		)
		OPREL {saida+=$OPREL.text+" ";}
		(ID {	boolean ret = cv.jaExiste($ID.text);
				if(!ret){
					System.out.println("Variavel "+$ID.text+" não existe!!!");
					System.exit(0);
				}
				saida+=$ID.text+" ";
			}
		| NUM {saida+=$NUM.text+" ";}
		);

atrib:	ID {boolean ret = cv.jaExiste($ID.text);
			if(!ret){
				System.out.println("Variavel "+$ID.text+" não existe!!!");
				System.exit(0);
			}
			saida+=$ID.text+" ";}
		Op_atrib {saida+="= ";}
		expr
		PV{saida+=";\n\t\t";};

expr: fator( (MAIS {saida+="+";} | MENOS {saida+="-";}) expr)*;

fator: termo( (VEZES {saida+="*";} | DIV {saida+="/";}) fator)*;

termo: ID { boolean ret = cv.jaExiste($ID.text);
			if(!ret){
				System.out.println("Variavel "+$ID.text+" não existe!!!");
				System.exit(0);
			}
			saida+=$ID.text;
		}| NUM {saida+=$NUM.text;} | CARAC {saida+=$CARAC.text;} | (AP {saida+="(";} expr FP {saida+=")";} ) ;


ID: [A-Za-z]+;
NUM: [0-9]+;
OPREL: '>' | '<' | '>=' | '<=' | '==' | '!=' ;
PV: ';' ;
AC: '{' ;
FC: '}' ;
AP: '(' ;
FP: ')' ;
Op_atrib: '=';
MAIS: '+';
MENOS: '-';
VEZES: '*';
DIV: '/';
CARAC: '\''[A-Za-z]'\'' ;
WS: [ \t\r\n]+ -> skip;
