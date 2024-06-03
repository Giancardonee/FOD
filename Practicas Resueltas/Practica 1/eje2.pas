program eje2;
const 
	valorBuscado = 1500;
type
	archivoNumeros = file of integer;



procedure procesarArchivo (var arch : archivoNumeros;var cantMenores:integer; var promedioNros : real); 
var
	sumaNumeros,numeroActual: integer;
	cantNumeros: integer;
begin
	reset (arch); 
	cantMenores:= 0; sumaNumeros:=0;
	cantNumeros:= (FileSize(arch)-1); 
	read(arch,numeroActual);
	while (not eof (arch)) do 
		begin
			sumaNumeros:= sumaNumeros + numeroActual;
			if (numeroActual < valorBuscado) then 
				cantMenores:= cantMenores + 1;
			read(arch,numeroActual); 
		end;
		promedioNros:= (sumaNumeros/cantNumeros); 
	close(arch);
end; 

var
	archNumero : archivoNumeros; 
	nombreArch : string;
	cantMenores : integer;
	promedioNumeros : real;
begin
	write ('Ingrese el nombre del archivo a procesar: ');  readln(nombreArch); 
	assign (archNumero , nombreArch); 
	procesarArchivo(archNumero,cantMenores,promedioNumeros); 
	writeln('===> Cantidad de numeros menores a 1500: ',cantMenores);
	writeln('===> Promedio de los numeros ingresados: ',promedioNumeros:2:2); 
end.
