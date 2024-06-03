program eje6; 
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
	procedure leerCelular (var c : celular); 
	begin
		write ('Ingrese el codigo: '); readln (c.codigoCelular); 
		if (c.codigoCelular <> 0) then 
			begin
				write ('Ingrese el precio: '); readln (c.precio); 
				write ('Ingrese la descripcion: '); readln(c.descripcion);
				write ('Ingrese el stock minimo: '); readln (c.stockMin); 
				write ('Ingrese el stock disponible: '); readln (c.stockDisp); 
				write ('Ingrese la marca: '); readln (c.marca); 
				write ('Ingrese el nombre: '); readln(c.nombre); 
			end; 
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
	procedure agregarCelulares (var arch : archivoCelulares); 
	var
		c : celular;
	begin
		reset(arch);
		seek(arch,fileSize(arch)); {nos paramos en la ultima posicion} 
		leerCelular(c); 
		while (c.codigoCelular <> 0) do 
			begin
				write(arch,c); 
				leerCelular(c); 
			end; 
		close(arch); 
	end;
	procedure buscarCelular (var arch : archivoCelulares; var encontre : boolean; nombreCelular : str15; var c : celular); 
	begin
		encontre:= false; 
		while (not eof(arch) and (encontre = false) ) do 
			begin
				read(arch,c); 
				if (c.nombre = nombreCelular) then 
					encontre:= true; 
			end; 
	end;  
	{es medio quilombo porque hay dos tipos de stock: stock minimo y stock disponible.
	* No aclara cual quiere que modifiquemos, asique voy a asumir que quiere modificar uno de los dos}
	procedure modificarStockCelular (var arch: archivoCelulares); 
	var 
		encontro : boolean; 
		nombreCelular : str15;
		celularAmodificar: celular;  
		nuevoStock ,opcion: integer;
	begin
		reset (arch); 
		write ('Ingrese el nombre del celular que quiera modificar el stock: '); readln (nombreCelular); 
		buscarCelular(arch,encontro,nombreCelular,celularAmodificar);
		if (encontro) then 
			begin
				seek(arch,filePos(arch)-1); {nos paramos en el celular a modificar el stock}
				writeln('Ingrese 1 si quiere modificar el stock minimo.');
				writeln ('Ingrese 2 si quiere modificar el stock disponible.'); 
				write ('==>  Ingrese la opcion aca: '); readln (opcion); 
				write ('Ingrese el nuevo stock: '); readln (nuevoStock); 
				{asumiendo que se ingresa un numero mayor o igual a 0}
				case opcion of 
					1: celularAmodificar.stockMin := nuevoStock; 
					2: celularAmodificar.stockDisp:= nuevoStock; 
				end;
				write(arch,celularAmodificar); 
			end 
		else
			writeln('==> Error. No se encontro el celular con nombre ',nombreCelular); 
		close(arch); 
	end; 
	procedure exportarTxtCelularesSinStock (var arch : archivoCelulares); 
	var
		archivoTxt : text;
		c : celular;
	begin
		reset(arch); 
		assign(archivoTxt,'sinStock.txt'); 
		rewrite (archivoTxt); 
		while (not eof(arch) ) do 
			begin
				read(arch,c); 
				if (c.stockDisp = 0) then 
					begin
						writeln('Nombre: ',c.nombre, ' Marca: ',c.marca); 
						writeln(archivoTxt, 'Codigo celuar: ',c.codigoCelular, ' Precio: ', c.precio);
						writeln(archivoTxt, 'Stock minimo: ',c.stockMin, ' Stock disponible: ',c.stockDisp, ' Descripcion: ',c.descripcion);
					end; 
			end; 
		close(archivoTxt); 
		close(arch); 
	end; 
	procedure elegirOpcion (var opcion : integer); 
	begin
		Writeln ('==> Ingrese 1 si : Desea cargar el archivo con los datos de ( cargaCelulares1.txt ))'); 
		Writeln ('==> Ingrese 2 si : Desea mostrar en pantalla aquellos celulares con stock menor al stock minimo.'); 
		Writeln ('==> Ingrese 3 si : Desea mostrar en pantalla aquellos celulares con una descripcion ingresada.'); 
		Writeln ('==> Ingrese 4 si : Exportar el archivo generado a un archivo de  texto llamado ( celulares.txt ).'); 
		Writeln ('==> Ingrese 5 si : Desea agregar uno o mas celulares al final del archivo.'); 
		Writeln ('==> Ingrese 6 si : Desea modificar el stock de un celular dado.'); 
		Writeln ('==> Ingrese 7 si : Desea exportar en un archivo txt aquellos celulares sin stock.'); 
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
				5: agregarCelulares(arch); 
				6: modificarStockCelular(arch); 
				7: exportarTxtCelularesSinStock(arch); 
				else
					writeln('Se ingreso una opcion incorrecta.'); 
				
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

