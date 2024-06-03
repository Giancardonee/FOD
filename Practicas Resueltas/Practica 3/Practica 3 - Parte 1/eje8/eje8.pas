{Puntos importantes de este ejercicio: 
* 	- El nombre de las distribuciones no puede repetirse 
*  - Debe ser mantenido usando bajas logicas, utilizando la tecnica de lista invertida }

program eje8;
Uses Crt;
Const 
	valorAlto = 9999;
type
	distribucion = record
		nombre : string[25];
		anhoLanzamiento : integer;
		version : integer;
		cantDesarrolladores : integer;
		descripcion : string[30];
	end;
	
	archivoDistribuciones = file of distribucion; 
{===============================================}
	{modulos para crear el archivo}
	procedure leerDistribucion (var d : distribucion); 
	begin
		write ('==> Ingrese el nombre de la distribucion: '); readln (d.nombre); 
		if (d.nombre <> 'fin') then begin
			write ('Ingrese el anho de lanzamiento: '); readln (d.anhoLanzamiento);
			write ('Ingrese la version: '); readln (d.version); 
			write ('Ingrese la cantidad de desarrolladores: '); readln (d.cantDesarrolladores); 
			write ('Ingrese la descripcion: '); readln (d.descripcion); 
		end;
		writeln; 
	end; 
	
	procedure leer(var arch : archivoDistribuciones ; var d : distribucion); 
	begin
		if (not eof (arch)) then 
			read(arch,d)
		else d.version:= 9999;
	end; 
	
	{tener en cuenta, que como usamos lista invertida, la cabecera del archivo
	* se usa como registro auxiliar para saber que espacios estan libres.}
	
	{otro detalle a tener en cuenta es que como disponemos del archivo, no hay registros con el mismo nombre, por lo tanto
	* en este modulo ,para probar el programa, deberiamos cargar el archivo sin nombres duplicados}
	procedure cargarArchivo (var arch : archivoDistribuciones); 
	var
		d : distribucion;
	begin
		assign(arch,'maestro'); 
		rewrite (arch); 
		d.version := -1; 
		write(arch,d); {escribimos el registro cabecera}
		leerDistribucion(d); 
		while (d.nombre<> 'fin') do begin
			write(arch,d); 
			leerDistribucion(d); 
		end;
		close(arch);
	end;
	{===============================================}
	procedure imprimirArchivo (var arch : archivoDistribuciones); 
	var
		d : distribucion;
	begin
		reset(arch); 
		leer(arch,d); {leemos la cabecera (en este caso no la necesitamos imprimir)}
		leer(arch,d); {leemos el siguiente registro de la cabecera}
		while (d.version <> valorAlto) do begin
			if (d.version >0 )then begin 
				writeln ('==> Nombre: ',d.nombre, ' Version: ',d.version, ' Anho de lanzamiento ',d.anhoLanzamiento); 
				writeln('== Cantidad de desarrolladores: ',d.cantDesarrolladores, ' Descripcion: ',d.descripcion);  
			end
			else writeln('Posicion: ',filePos(arch)-1, ' libre, con espacio reasignable.' );
			leer(arch,d);
			writeln; 
		end;
		close(arch); 
	end;
	{===============================================}
	{inciso a) }
	function ExisteDistribucion (var arch : archivoDistribuciones; nombreBuscado : string): boolean;
	var
		existe : boolean;
		d : distribucion; 
	begin
		existe:= false;
		reset(arch); 
		leer(arch,d); {leemos el registro cabecera}
		leer(arch,d);  {leemos el registro despues de la cabecera}
		while ( (d.version <> valorAlto) and (not existe) ) do begin
			if ( (d.nombre = nombreBuscado)  and (d.version>0) ) then  {si es una version negativa es una baja logica, por lo tanto dejo de existir logicamente}
				existe:= true
			else
				leer(arch,d); 
		end;
		close(arch);
		ExisteDistribucion:= existe;
	end;
	{===============================================}
	{inciso b}
	procedure AltaDistribucion (var arch : archivoDistribuciones); 
	var
		pos : integer;
		d,cabecera : distribucion; 
	begin
		writeln ('Por favor, ingrese los siguientes datos para dar de alta una distribucion: '); 
		leerDistribucion(d); 
		if (not ExisteDistribucion(arch,d.nombre)) then begin
		reset(arch); 
		leer(arch,cabecera); {leemos el registro cabecera}
		if (cabecera.version = -1) then begin {agrego al final}
			seek(arch,fileSize(arch)-1); 
			write(arch,d); 
		end
		else
			begin
			pos:= cabecera.version * -1; {me traigo el indice a escribir el archivo, pero lo paso a positivo}
			seek(arch,pos); 			{vamos a la pos a reasignar el espacio}
			read(arch,cabecera);  {leemos en el registro a poner en la cabecera}
			seek(arch,pos); 			 {volvemos a la pos (en este caso seria la pos anterior)}
			write(arch,d); 				{escribimos el registro que leimos, en esa posicion que estaba como baja logica}
			seek(arch,0);				{voy a la cabecera}
			write(arch,cabecera);{escribo el archivo que estaba en pos, ahora es nuestra nueva cabecera}	
			end;
		close(arch);
		end
		else writeln ('Ya existe la distribucion.  No se pueden tener distribuciones con mismo nombre.');
		writeln;
	end;
	{===============================================}
	{inciso c)}
	procedure BajaDistribucion(var arch : archivoDistribuciones); 
	var
		posBorrar : integer;
		d,cabecera : distribucion;
		nombreBaja : string;
	begin
		write ('Ingrese el nombre para dar de baja: '); readln (nombreBaja); 
		if (ExisteDistribucion(arch,nombreBaja)) then begin
			reset(arch);
			leer(arch,cabecera); 
			leer(arch,d);
			while (d.nombre <> nombreBaja) do  {aca no chequeamos por el valorAlto, porque si entra es porque se encuentra}
				leer(arch,d);
			{sale del archivo con el registro a dar de baja.}
			posBorrar:= filePos(arch)-1; 	{nos guardamos la posicion para hacer el borrado logico}
			seek(arch,posBorrar); 				{vamos a la posicion a borrar}
			write(arch,cabecera); 				{escribimos nuestro registro cabecera en la posicion que dimos baja logica}
			seek(arch,0);								{vamos a la cabecera, para actualizar el registro}
			d.version:= posBorrar * -1; 		{pasamos la posicion a negativo, para indicar que hay espacio en ese indice}
			write(arch,d); 								{escribimos (actualizamos) el registro cabecera}
			close(arch);
		end
		else writeln('Distribucion no existente.');
	end;
	
	procedure menu (var arch : archivoDistribuciones); 
	var
		opcion : integer;
	begin
		Writeln('Se debe cargar el archivo. La lectura de distribuciones finaliza con el nombre de distribucion fin');
		cargarArchivo(arch); 
		repeat
			writeln('Ingrese 1 para realizar una baja logica. ');
			writeln ('Ingrese 2 para realizar alta.'); 
			writeln ('Ingrese 3 para imprimir el archivo.');
			writeln ('Ingrese 0 para cerrar el programa.'); 
			write ('===> Por favor, ingrese su opcion aca: '); readln (opcion);
				case opcion of 
					0 : ; 
					1 : BajaDistribucion(arch); 
					2:  AltaDistribucion(arch);
					3: imprimirArchivo(arch);
					else writeln ('Opcion incorrecta.'); 
				end;
			
		until opcion = 0
	end;
	{programa principal}
	var
		maestro : archivoDistribuciones; 
	begin
		TextColor(LightCyan); 
		menu(maestro); 
	end.
	
