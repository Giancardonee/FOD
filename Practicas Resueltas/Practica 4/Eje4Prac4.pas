program Eje4;
const
	M=10;
type
	alumno=record
		nombreCompleto:string[20];
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	arc_alumno=file of alumno;
	
	Nodo = record
		clave: integer;
		NRR: integer; //posición relativa del registro
	end;
	
	arbol=record
		dato:array[1...M-1] of Nodo;
		hijos:array[1...M] of ^arbol;
		cantHijos:integer;
	end;
	
