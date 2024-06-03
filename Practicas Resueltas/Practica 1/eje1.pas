program eje1; 
type
	archivoNumeros = file of integer; 
	
	procedure cargarArchivo (var arch : archivoNumeros); 
	var
		numero : integer; 
	begin
		write ('Ingrese un numero: '); readln (numero); 
		while (numero <> 3000) do 
			begin
				write (arch,numero);
				write ('Ingrese un numero: '); readln (numero); 
			end; 
	end; 
var
	archNros : archivoNumeros; 
	nombreFisico : string; 
begin
	write ('Ingrese el nombre fisico del archivo: '); readln (nombreFisico); 
	assign (archNros,nombreFisico);  // conectamos el arch fisico con el arch logico (programa)
	rewrite (archNros); // creamos el archivo
	
	cargarArchivo(archNros);
	
	close(archNros); 
end.
