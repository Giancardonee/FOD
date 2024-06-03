program eje4;
Uses crt;
type
	str20 = string[20]; 
	str8 = string[8];
	empleado = record
		nro : integer;
		apellido : str20;
		nombre : str20;
		edad : integer;
		dni : str8; 
	end;
	archivoEmpleados = file of empleado;
	// ------- modulos que trabajan con el registro empleado -----------
	procedure leerEmpleado (var e : empleado); 
	begin
	writeln; 
		write('Ingrese el apellido del empleado: '); readln (e.apellido); 
		if ( e.apellido <> 'fin') then 
			begin
				write ('Ingrese el nombre del empleado: '); readln (e.nombre); 
				write ('Ingrese el numero de empleado: '); readln (e.nro);
				write ('Ingrese la edad del empleado: '); readln (e.edad); 
				write ('Ingrese el dni del empleado: '); readln (e.dni);
			end;
	end;
	procedure mostrarEmpleado (e : empleado);
	begin
		writeln ('==> Empleado: ',e.nombre, ' ',e.apellido);
		writeln ('Numero de empleado: ',e.nro, ' Edad: ',e.edad, ' Dni: ',e.dni );
		writeln; 
	end;
	// ---------------------------------------------------------------------------------------
	// ---------------------- modulos de opciones del menu 1 ----------------------------------------
	{opcion 1}
	procedure cargarArchivo (var arch : archivoEmpleados); 
	var 
		e : empleado;
		nombreArchivo : string; 
	begin
		writeln; 
		write ('Ingrese el nombre del archivo a generar: '); readln (nombreArchivo);
		assign (arch,nombreArchivo); 
		rewrite (arch); 
		writeln ('====> Carga de empleados'); 
		leerEmpleado(e); 
		while (e.apellido <> 'fin') do 
			begin
				write(arch,e);
				leerEmpleado(e); 
			end;
		close(arch); 
	end;
	procedure abrirArchivo (var arch: archivoEmpleados); 
	var 
		nombreArchivo : string;
	begin
		write ('Ingrese el nombre del archivo a abrir: '); readln (nombreArchivo); 
		assign(arch,nombreArchivo); 
		writeln; 
	end;
	// ---------------------- modulos de opciones del menu 2  ----------------------------------------
	{opcion 1}
	procedure mostrarEmpleadosDeterminados(var arch: archivoEmpleados);
	var 
		busqueda : string; 
		e : empleado;
	begin
		reset (arch); 
		write ('Ingrese el nombre o apellido de empleados que quiera buscar: '); readln (busqueda); 
		while (not eof(arch)) do 
			begin
				read(arch,e); 
				if ( (e.nombre = busqueda) or (e.apellido = busqueda) ) then 
						mostrarEmpleado(e); 
			end;
		close(arch); 
	end;
	{opcion 2}
	procedure mostrarTodosLosEmpleados (var arch: archivoEmpleados); 
	var
		e : empleado;
	begin
		reset (arch); 
		while (not eof (arch)) do 
			begin
				read(arch,e); 
				mostrarEmpleado(e); 
			end;
		close(arch);
	end;
	{opcion 3}
	procedure mostrarEmpleadosProxJubilarse (var arch : archivoEmpleados); 
	var 
		e : empleado;
	begin
		reset(arch);
		while (not eof (arch)) do 
			begin
				read (arch,e); 
				if (e.edad > 70) then 
					mostrarEmpleado(e); 
			end;
		close(arch);
	end; 
	{opcion 4}
	{Tengo entendido que: 
	* 1) Se debe leer un empleado 
	* 2) Se debe recorrer el archivo para ver si se encuentra ese numero de empleado
	* 3) 
	* 	Si no se encuentra ese numero de empleado ==> Guardamos al final del archivo
	* 	Si se encuentra ese numero de empleado ==> Mostramos un mensaje diciendo que nro de empleado ya existe.}
	procedure agregarEmpleadosFinalArchivo(var arch : archivoEmpleados); 
	var
		rLeer,rArchivo : empleado;
		existeEmpleado: boolean;
	begin
		reset(arch); 
		leerEmpleado(rLeer); 
		while (rLeer.apellido <>'fin') do 
			begin
			existeEmpleado := false;
			while (not eof(arch) and (existeEmpleado = false) ) do 
				begin
					read(arch,rArchivo); 
					if (rArchivo.nro = rLeer.nro) then 
						existeEmpleado := true;
				end;
				if (existeEmpleado) then 
					Writeln('ERROR: El numero de empleado ya existe.')
				else
						write (arch,rLeer); // escribimos el empleado
				seek(arch,0); // me posiciono en la primer posicion del archivo
				writeln('Ingrese ==> fin para dejar de leer empleados.'); 
				leerEmpleado(rLeer);
			end;
		close(arch);
	end;
	{opcion 5}
	procedure modifcarEdadEmpleados(var arch : archivoEmpleados); 
	var
		nroEmpleado,edad: integer;
		encontroEmpleado : boolean;
		e : empleado; 
	begin
		reset(arch);
		write ('Ingrese el numero de empleado que quiera modificar su edad: '); readln (nroEmpleado); 
		write ('Ingrese la edad que quisiera asignarle: '); readln (edad); 
		while (nroEmpleado <> 0) do 
			begin
				encontroEmpleado := false;
				// buscamos el empleado en el archivo
				while (not eof (arch) and (encontroEmpleado = false) ) do 	
					begin
						read(arch,e); 
						if (e.nro = nroEmpleado) then 
							encontroEmpleado:= true;
					end;
				// -- evaluamos modificar la edad o no (depende si se encontro el empleado) 
				if (encontroEmpleado) then 
					begin
					seek(arch,filePos(arch)-1); // me posiciono en el empleado que quiero modificar la edad
					e.edad := edad;
					write (arch,e);
					end
				else 
					writeln('No se encontro el empleado buscado.');
				// --- --- --- --- --- ---- ---- 
				writeln('Para salir del metodo, ingrese 0 como nro de empleado y como edad. '); 
				seek(arch,0); // me posiciono en la primer posicion del archivo.
				write ('Ingrese el numero de empleado que quiera modificar su edad: '); readln (nroEmpleado); 
				write ('Ingrese la edad que quisiera asignarle: '); readln (edad); 
			end;
		close(arch);
	end;
	{opcion 6}	
	procedure exportarArchivoTxt(var arch : archivoEmpleados); 
	var
		archivoTxt : text;
		e : empleado;
	begin
		assign(archivoTxt,'todos_empleados.txt'); 
		reset (arch); // abrimos el archivo de empleados
		rewrite(archivoTxt);  // creamos el archivo de solo escritura
		while (not eof(arch) ) do 
			begin
				read(arch,e); 
				writeln(archivoTxt, '|| Nombre: ',e.nombre, ' ',e.apellido, ' || Nro empleado: ',e.nro, ' || Edad: ',e.edad, ' || Dni: ',e.dni); 
				Writeln('Se exporto el archivo todos_empleados.txt correctamente.');
			end;
		close(arch); 
		close(archivoTxt); 
	end;
	{opcion 7}
	procedure exportarEmpleadosFaltaDni(var arch: archivoEmpleados); 
	var
		archivoTxt : text;
		e : empleado;
	begin
		assign(archivoTxt,'faltaDNIEmpleado.txt'); 
		reset (arch); 
		rewrite (archivoTxt); 
		while (not eof ( arch) ) do 
			begin
				read(arch,e); 
				if ( e.dni = '00' ) then 
					writeln(archivoTxt, '|| Nombre: ',e.nombre, ' ',e.apellido, ' || Nro empleado: ',e.nro, ' || Edad: ',e.edad, ' || Dni: ',e.dni); 			
					Writeln('Se exporto el archivo faltaDNIEmpleado.txt correctamente.');
			end;
		close (arch);
		close(archivoTxt); 
	end;
	//-------------------------------------------------------------------------------------------------------------
	
	// ---------------------- modulos para el menu 1 ----------------------------------------
	{modulo 1}
	procedure elegirOpcion1 (var opcion : integer); 
	begin
		writeln ('Ingrese 1 si: Desea generar el archivo de empleados.');
		writeln ('Ingrese 2 si: Desea abrir un archivo de empleados.');
		Write ('===> Por favor, ingrese su opcion aca: '); readln(opcion); 
		writeln; 
	end;
	{modulo 2 }
	procedure menu1 (var arch : archivoEmpleados); 
	var 
		opcion : integer;
	begin
	repeat
	elegirOpcion1(opcion); 
		case opcion of 
			1 : cargarArchivo(arch); 
			2:  abrirArchivo(arch); 
			else writeln ('No se ingreso una opcion valida,por favor intente nuevamente.'); 
		end;
		writeln; 
	until ( (opcion = 1) or (opcion = 2) )
	end;
	// ---------------------- modulos para el menu 2 ----------------------------------------
	{modulo 1}
	procedure elegirOpcion2 (var opcion : integer);
	begin
		Writeln ('Ingrese 1 si: Desea mostrar empleados con nombre o apellido determinado. ');
		Writeln ('Ingrese 2 si: Desea mostrar todos los empleados de a uno por linea. ');
		Writeln ('Ingrese 3 si: Desea mostrar empleados mayores a 70 anhos. ');   
		Writeln ('Ingrese 4 si: Desea agregar empleados al final del archivo.'); 
		Writeln ('Ingrese 5 si: Desea modificar la edad de empleados.'); 
		Writeln ('Ingrese 6 si: Desea exportar todos los empleados a un archivo llamado ( todos_empleados.txt ).'); 
		Writeln ('Ingrese 7 si: Desea exportar a un archivo llamado ( faltaDNIEmpleado.txt ) aquellos empleados con dni = 00.'); 
		Writeln ('Ingrese 0 si: Desea cerrar el programa.');
		Write ('===> Por favor, ingrese su opcion aca: '); readln(opcion); 
		writeln; 
	end;
	{modulo 2}
	procedure menu2 (var arch: archivoEmpleados); 
	var 
		opcion : integer;
	begin
	repeat
		elegirOpcion2(opcion);
				case opcion of 
					0: ;
					1: mostrarEmpleadosDeterminados(arch); 
					2: mostrarTodosLosEmpleados(arch); 
					3: mostrarEmpleadosProxJubilarse(arch); 
					4: agregarEmpleadosFinalArchivo(arch); 
					5: modifcarEdadEmpleados(arch);
					6: exportarArchivoTxt(arch);
					7: exportarEmpleadosFaltaDni(arch);
					else writeln ('No se ingreso una opcion valida,por favor intente nuevamente.'); 
				end;
			writeln;  
	 until (opcion = 0)
	end; 
	// ---------------------------------------------------------------------------------------
var
	archEmpleados : archivoEmpleados; 
begin
	Textcolor(green); 
	Writeln('==> Bienvenido/a al menu'); 
	menu1(archEmpleados);
	menu2(archEmpleados); 
	Writeln('Programa finalizado.'); 
end.



{
* procedure chequearExisteNroEmpleado (var arch: archivoEmpleados; var existeEmpleado : boolean; nroEmpleadoNuevo : integer); 
	var
		e : empleado;
	begin
		reset(arch);
		while (not eof(arch) and (existeEmpleado = false) ) do 
			begin
				read(arch,e); 
				if (e.nro = nroEmpleadoNuevo) then 
					existeEmpleado := true; 
			end; 
		close(arch); 
	end;
	* 
	* 
	procedure agregarAlFinal(var arch: archivoEmpleados; e : empleado); 
	begin
		reset(arch); 
		seek (arch,fileSize(arch)); 
		write(arch,e);
		close(arch); 
	end;
	* 
	* 
	procedure agregarEmpleadosFinalArchivo (var arch : archivoEmpleados);
	var
		e : empleado; 
		existeEmpleado : boolean; 
	begin
		reset(arch);
		leerEmpleado(e); 
		while (e.apellido <> 'fin') do 
			begin
				existeEmpleado := false; 
				chequearExisteNroEmpleado(arch,existeEmpleado,e.nro); 
				if (existeEmpleado = false) then 
					agregarAlFinal(arch,e); 
			end; 
		close(arch);
	end; 
	* }
