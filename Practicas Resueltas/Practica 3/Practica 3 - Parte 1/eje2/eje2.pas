program eje2; 
Uses crt;
type
	asistente = record
		nro : integer;
		apeYnom : string[30]; 
		email : string[25]; 
		telefono : string[10]; 
		dni : string[8]; 
	end; 
	archivoAsistentes = file of asistente; 

	
	procedure leerAsistente(var a : asistente); 
	begin
		write ('Ingrese el numero de asistente: '); readln (a.nro); 
		if (a.nro<>-1) then 
			begin
				write('Ingrese el apellido y nombre del asistente: '); readln(a.apeYnom); 
				write ('Ingrese el email del asistente: '); readln (a.email); 
				write ('Ingrese el telefono del asistente: '); readln (a.telefono); 
				write ('Ingrese el dni del asistente: '); readln (a.dni); 
			end; 
	end; 
	procedure cargarArchivo(var arch : archivoAsistentes); 
	var
		a : asistente; 
		nombreArch : string;
	begin
		write ('Ingrese un nombre para el archivo: '); readln (nombreArch); 
		assign(arch,nombreArch); 
		rewrite(arch); 
		leerAsistente(a); 
		while(a.nro <>-1) do 
			begin
				writeln('--------------------------------------------');
				write(arch,a); 
				leerAsistente(a); 
			end; 
		close(arch); 
	end; 
	procedure eliminarAsistentes(var arch : archivoAsistentes); 
	var
		a : asistente; 
	begin
		reset(arch); 
		while (not eof (arch)) do 
			begin
				read(arch,a); 
			{ponemos la marca de borrado logico}
				if (a.nro<1000) then begin
					seek(arch,filePos(arch)-1); 
					a.apeYnom:= '@'+a.apeYnom;
					write(arch,a);
				end; 
			end; 		
		close(arch); 
	end; 
	// ---- modulos extras
	procedure imprimirArchivo (var arch : archivoAsistentes); 
	var
		a : asistente;
	begin
		reset(arch); 
			while (not eof (arch) ) do 
				begin
					read(arch,a); 
					writeln ('==>Numero de asistente:  ',a.nro, 'Nombre: ',a.apeYnom, ' email: ',a.email );
					 writeln ('Telefono: ',a.telefono, ' Dni: ',a.dni); 
				end; 
		close(arch); 
	end; 
	{programa principal}
	var
		arch : archivoAsistentes; 
	begin
		Textcolor(LightMagenta ); 
		cargarArchivo(arch); 
		imprimirArchivo(arch); 
		eliminarAsistentes(arch); 
		imprimirArchivo(arch);
	end. 
	
