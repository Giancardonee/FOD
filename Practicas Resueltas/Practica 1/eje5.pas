program eje5; 
uses crt; 
type
	str15 = string [15];
	str25 = string [25]; 
	celular = record
		codigoCelular : integer; 
		nombre : str15;
		descripcion : str25; 
		marca : str15; 
		precio : real; 
		stockMin : integer;
		stockDisp : integer;
	end; 
	archivoCelulares = file of celular;
	procedure cargarArchivoConTxt (var arch : archivoCelulares); 
	var
		celularesTxt : text; 
		c : celular; 
	begin
		assign(celularesTxt,'cargaCelulares1.txt'); 
		reset (celularesTxt); 
		rewrite(arch); 
		while (not eof (celularesTxt)) do
			begin
				readln(celularesTxt, c.codigoCelular, c.precio, c.marca); 
				writeln('lei la primer linea'); 
				readln (celularesTxt , c.stockMin , c.stockDisp , c.descripcion); 
				writeln('lei la segunda linea'); 
				readln (celularesTxt,c.nombre); 
				writeln('lei la tercer linea'); 
				write(arch,c); // escribimos los datos traidos en el archivo binario
			end; 
		close (celularesTxt);
		close(arch);  
	end; 
	procedure mostrarCelular (c : celular); 
	begin
		writeln('|| Codigo de celular: ',c.codigoCelular, ' Precio: ',c.precio:2:2, ' Marca: ',c.marca);
		writeln ('  	Stock Minimo: ',c.stockMin, ' Stock Disponible: ',c.stockDisp, ' Descripcion: ',c.descripcion); 
		writeln ('	Nombre: ',c.nombre); 
	end; 
	procedure mostrarCelularesStockMenorMin (var arch : archivoCelulares); 
	var 
		c : celular; 
	begin
		reset (arch); 
		while (not eof (arch) ) do 
			begin
				read (arch,c); 
				if (c.stockDisp < c.stockMin) then 
					mostrarCelular(c); 
			end; 
		close(arch); 
	end; 
	procedure mostrarCelularesConDescripcion (var arch : archivoCelulares); 
	var
		c : celular;
		descripcionBuscada : str25; 
	begin
		write ('Ingrese la descripcion de los celulares que quiera mostrar: '); readln (descripcionBuscada); 
		reset(arch); 
		while (not eof (arch) ) do 
			begin
				read(arch,c); 
				if (c.descripcion = descripcionBuscada) then 
					mostrarCelular(c); 
			end; 
		close(arch); 
	end; 
	procedure exportarArchivoTxt (var archB : archivoCelulares); 
	var
		c : celular; 
		archTxt : text; 
	begin
		reset(archB); 
		assign(archTxt,'celulares.txt'); 
		rewrite(archTxt); 
		while (not eof (archB) ) do 
			begin
				read (archB,c); // leemos el dato en el archivo binario
				// cargamos en el archivo txt, con el formato que dice la nota 2
				writeln(archTxt,c.codigoCelular, ' ',c.precio:2:2, ' ',c.marca); 
				writeln(archTxt, c.stockDisp, ' ',c.stockMin, ' ',c.descripcion); 
				writeln(archTxt,c.nombre); 
			end; 
		close(archTxt); 
		close(archB); 
	end; 
	procedure elegirOpcion (var opcion : integer); 
	begin
		Writeln ('==> Ingrese 1 si : Desea cargar el archivo con los datos de ( cargaCelulares1.txt ))'); 
		Writeln ('==> Ingrese 2 si : Desea mostrar en pantalla aquellos celulares con stock menor al stock minimo.'); 
		Writeln ('==> Ingrese 3 si : Desea mostrar en pantalla aquellos celulares con una descripcion ingresada.'); 
		Writeln ('==> Ingrese 4 si : Exportar el archivo generado a un archivo de  texto llamado ( celulares.txt ).'); 
		Writeln ('==> Ingrese 0 si : Desea cerrar el programa..'); 
		write ('Ingrese su opcion aca: '); readln (opcion);
	end; 
	procedure mostrarMenu (var arch : archivoCelulares); 
	var 
		opcion : integer;
	begin
		Writeln('---- ANTES DE REALIZAR ALGUNA OPERACION, SE DEBE ELEGIR LA OPCION 1 PARA CARGAR EL ARCHIVO ---');
		repeat 
			elegirOpcion(opcion); 
			case opcion of 
				1: cargarArchivoConTxt(arch); 
				2: mostrarCelularesStockMenorMin(arch); 
				3: mostrarCelularesConDescripcion(arch); 
				4: exportarArchivoTxt(arch); 
			end; 
		until (opcion = 0);
	end; 
var
	archCelu : archivoCelulares; 
	nombreArchivoB : string; 
begin
	Textcolor(green); 
	write ('Ingrese el nombre del archivo binario a crear: '); 
	readln (nombreArchivoB); 
	assign (archCelu,nombreArchivoB); 
	mostrarMenu(archCelu); 
end.
