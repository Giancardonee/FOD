program eje7; 
uses crt; 
type 
	str20 = string[20]; 
	novela = record
		codigo : integer;
		nombre : str20; 
		genero : str20; 
		precio : real; 
	end; 
	archivoNovelas = file of novela;
	{cargamos el archivo con informacion de novelas.txt}
	procedure cargarArchivo(var arch: archivoNovelas); 
	var
		nov : novela; 
		nombreArchivoB: string; 
		novelasTxt : text; 
	begin
		{operaciones sobre el archivo novelas.txt}
		assign (novelasTxt,'novelas.txt'); 
		reset(novelasTxt); 
		{operaciones sobre el archivoBinario}
		write ('Ingrese el nombre del archivo binario: '); readln (nombreArchivoB); 
		assign(arch,nombreArchivoB); 
		rewrite(arch); 
		while (not eof (novelasTxt) ) do 
			begin
				{leemos desde el txt}
				readln(novelasTxt,nov.codigo,nov.precio,nov.genero); 
				readln(novelasTxt,nov.nombre); 
				{escribimos en el archivo binario}
				write(arch,nov); 
			end;
		close(novelasTxt); 
		close(arch); 
	end;
	procedure leerNovela(var n : novela); 
	begin
		write('Ingree el codigo de la novela:'); readln (n.codigo); 
		if (n.codigo <>0) then 
			begin
				write ('Ingrese el nombre de la novela: '); readln (n.nombre); 
				write ('Ingrese el genero de la novela: '); readln (n.genero); 
				write ('Ingrese el precio de la novela: '); readln (n.precio); 
			end; 
	end; 
	procedure agregarNovela(var arch : archivoNovelas); 
	var
		n : novela; 
	begin
		reset(arch); 
		seek(arch,fileSize(arch)); {me paro en la ultima posicion del archivo} 
		leerNovela(n); 
		while (n.codigo <> 0) do 
			begin
				write (arch,n); 
				leerNovela(n); 
			end; 
		close(arch); 
	end; 
	procedure actualizarNovela(var arch : archivoNovelas);
	var 
		n : novela; 
	begin
		writeln; 
		writeln('Tener en cuenta que se van a sobreescribir todos los datos ingresados. '); 
		leerNovela(n); 
		seek(arch,filePos(arch)-1); {volvemos el puntero a la novela anterior ( novela a modificar ) }
		write(arch,n); 
	end; 
	{este modulo modifica de una novela.}
	procedure modificarNovela (var arch : archivoNovelas); 
	var
		codigoNovela : integer;
		n : novela; 
		encontre: boolean; 
	begin
		encontre:= false; 
		reset(arch); 
		write ('Ingrese el codigo de la novela que quiera modificar: '); readln (codigoNovela); 
		while (not eof (arch) and (encontre = false )  )do
			begin
				read (arch,n); 
				encontre:= (n.codigo = codigoNovela); {si los codigos coinciden devuelve true, caso contrario devuelve false }
			end;
		if (encontre) then actualizarNovela(arch) 
		else writeln('No se encontro la novela que se quiere modificar.'); 
		close(arch);
	end; 
	procedure realizarAccion (var arch : archivoNovelas; opcion : integer); 
	begin
		case opcion of 
			1: cargarArchivo(arch); 
			2: agregarNovela(arch); 
			3: modificarNovela(arch);  
			else writeln('Se ingreso una opcion no valida. ');  			
		end; 
	end; 
	procedure mostrarMenu (var arch : archivoNovelas); 
	var
		opcion : integer;
	begin
		writeln('Se debe seleccionar la opcion 1 para cargar el archivo antes de realizar operaciones con el. '); 
		repeat 
			Writeln('==> Ingrese 1 si:  Desea cargar el archivo con datos de ( novelas.txt ) '); 
			Writeln('==> Ingrese 2 si : Desea agregar una nueva novela. ');
			Writeln('==> Ingrese 3 si:  Desea modificar una novela existente.');
			Writeln('==> Ingrese 0 si : Desea cerrar el programa. ');
			Write('Ingrese su opcion aca: '); readln (opcion);   
			realizarAccion(arch,opcion); 
		until (opcion = 0); 
	end; 
var
	arch : archivoNovelas; 
begin
	Textcolor(green); 
	mostrarMenu(arch); 
end.
