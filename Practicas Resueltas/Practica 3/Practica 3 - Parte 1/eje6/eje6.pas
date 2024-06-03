
program eje6;
Uses Crt; 
const
	valorAlto = 9999;
type
	prenda = record
		codPrenda : integer;
		descripcion : string;
		colores : string[15]; 
		tipo_prenda : string[15];
		stock : integer;
		precioUnitario : real;	
	end;
	archivoPrendas = file of prenda; 
	archivoInteger = file of integer;
	{================================================================}
	{modulos de lectura}
	procedure leerMaestro (var arch : archivoPrendas ; var p : prenda); 
	begin
		if (not eof (arch)) then 
			read(arch,p)
		else p.codPrenda:= valorAlto;
	end;
	
	procedure leerPrenda(var p : prenda); 
	begin
		write ('ingrese el codigo de prenda: '); readln (p.codPrenda); 
		if (p.codPrenda > 0) then begin
			write ('ingrese la descripcion: '); readln (p.descripcion); 
			write ('ingrese los colores:  '); readln (p.colores);
			write ('ingrese el tipo de prenda: '); readln (p.tipo_prenda);  
			write ('ingrese el stock: '); readln(p.stock); 
			write ('ingrese el precio unitario: '); readln (p.precioUnitario);
		end;
	end;
	{================================================================}
	{modulos de carga de archivos}
	procedure cargarArchivoMaestro (var maestro : archivoPrendas); 
	var
		p : prenda;
	begin
		Writeln('==> Modulo de carga del archivo maestro. '); 
		Writeln('Ingrese -1 para terminar de cargar codigos de bajas.');
		writeln;
		assign(maestro,'maestro'); 
		rewrite(maestro);
		
		leerPrenda(p);
		while (p.codPrenda > 0) do begin
			write(maestro,p); 
			leerPrenda(p);
		end;
		
		close(maestro);
	end;
	
	procedure cargarArchivoCodBajas (var arch : archivoInteger); 
	var
		codBaja : integer;
	begin
		writeln('==> Modulo de carga del archivo con codigo de bajas.');
		Writeln('Ingrese -1 para terminar de cargar codigos de bajas.');
		writeln;
		assign(arch,'archivoCodigoBajas'); 
		rewrite(arch);
		write ('Ingrese el codigo de prenda para dar de baja: '); readln (codBaja);
		while (codBaja >0) do 
			begin
				write(arch,codBaja); 
				write ('Ingrese el codigo de prenda para dar de baja: '); readln (codBaja);
			end;
		close(arch);
	end; 
	{================================================================}
	procedure darBaja(var maestro : archivoPrendas; p : prenda);
	begin
			p.codPrenda:= -1; 
			seek(maestro,filePos(maestro)-1); 
			write(maestro,p); 
	end;
	
	procedure realizarBajasLogicas (var maestro : archivoPrendas; var archCodBajas : archivoInteger); 
	var
		codBaja : integer;
		p : prenda;
	begin
		reset(maestro);
		reset(archCodBajas); 
		while (not eof (archCodBajas)) do 
			begin
				read(archCodBajas,codBaja); 
				leerMaestro(maestro,p); 
				while ( (p.codPrenda <> valorAlto)  and (p.codPrenda <> codBaja) ) do  // busco en el maestro el mismo registro con codBaja
					leerMaestro(maestro,p); 
				if (p.codPrenda = codBaja) then {si se encontro el codigo de baja.}
					darBaja(maestro,p); 
				seek(maestro,0); // para volver a procesar el siguiente registro (si hay)
			end;
		close(maestro);
		close(archCodBajas);
	end;
	{==================================================================}
	procedure generarMaestroActualizado (var maestro : archivoPrendas; var maestroActualizado : archivoPrendas); 
	var
		p : prenda;
	begin
		reset(maestro); 
		assign(maestroActualizado, 'maestroActualizado'); 
		rewrite(maestroActualizado);
		leerMaestro(maestro,p); 
		while (p.codPrenda <> valorAlto) do 
			begin
			
				if (p.codPrenda > 0) then  {si el  registro no esta marcado como baja logica}
					write(maestroActualizado,p); {lo agregamos al archivo actualizado}
				
				leerMaestro(maestro,p); {volvemos a leer el maestro}
			end;
		close(maestro);
		close(maestroActualizado); 
		erase(maestro); 
		rename(maestroActualizado,'maestro'); 		
	end;
	
	procedure imprimirArchivoActualizado(var maestroActualizado : archivoPrendas); 
	var
		p : prenda;
	begin
		writeln;
		reset(maestroActualizado); 
		leerMaestro(maestroActualizado,p); 
		writeln('Informacion del archivo actualizado: '); 
		while (p.codPrenda<>valorAlto) do begin
			writeln ('==> Codigo de prenda: ',p.codPrenda, ' Descripcion: ',p.descripcion, ' Colores: ',p.colores); 
			writeln ('-- Tipo de prenda: ',p.tipo_prenda, ' Stock: ',p.stock,' Precio unitario: $',p.precioUnitario:2:2); 
			leerMaestro(maestroActualizado,p); 
		end;
		close(maestroActualizado); 
	end;
	
{programa principal}
var
	maestro , maestroActualizado : archivoPrendas;
	archivoCodBajas : archivoInteger;
begin
	Textcolor(LightCyan); 
	cargarArchivoMaestro(maestro); 
	imprimirArchivoActualizado(maestro);
	cargarArchivoCodBajas(archivoCodBajas);
	realizarBajasLogicas(maestro,archivoCodBajas); 
	generarMaestroActualizado(maestro,maestroActualizado); 
	imprimirArchivoActualizado(maestroActualizado);
end.
