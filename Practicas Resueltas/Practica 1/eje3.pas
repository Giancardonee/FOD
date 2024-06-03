program eje3;
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
