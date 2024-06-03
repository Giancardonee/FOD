{Este punto lo pense asi: 
* 	Abro detalle por detalle, es decir primero abro el detalle 1, lo recorro todo  mientras lo recorro
* voy chequeando si encuentro el registro en el archivo, Y asi sucesivamente hasta el detalle n
* 	Si encuentro el registro en el archivo solo actualizo: le sumo  las horas a ese codigo de usuario
* 	Si el registro no existe: Debo crear un nuevo registro con el codigo de usuario, y con las horas que tenga
* }
program eje3; 
Uses Crt; 
Const
	valorAlto = 9999;
	cantDetalles = 5; 
Type
	rDetalle = record
		codUsuario: integer;
		fecha : string; 
		tiempo_sesion : real; 
	end; 
	rMaestro = record
		codUsuario : integer;
		fecha : string; 
		tiempoTotal : real; 
	end; 

	archivoDetalle = file of rDetalle; 
	vecDetalles = array [1..cantDetalles] of archivoDetalle; 
	//vecRegDetalles = array [1..cantDetalles] of rDetalle; no lo usamos  
	archivoMaestro = file of rMaestro; 	
	
	procedure leerDetalle (var det : archivoDetalle; var rDet : rDetalle); 
	begin
		if (not eof (det)) then 
			read (det,rDet)
		else rDet.codUsuario:= valorAlto; 
	end; 
	
	procedure leerMaestro (var mae : archivoMaestro; var rMae : rMaestro); 
	begin
		if (not eof (mae)) then 
			read(mae,rMae)
		else rMae.codUsuario:= valorAlto; 
	end; 
	
	{ || Modulos para cargar detalles.}
	procedure leerSesion (var s : rDetalle); 
	begin
		write ('Ingrese el codigo de usuario: '); readln (s.codUsuario); 
		if (s.codUsuario > 0) then begin
			//write ('Ingrese la fecha: '); readln (s.fecha);
			write ('Ingrese el tiempo de sesion: '); readln (s.tiempo_sesion); 
		end; 	
	end; 
	
	procedure cargarDetalles (var vDet : vecDetalles);
	var	
		rDet : rDetalle; 
		i : integer; 
		iString : string; 
	begin
		for i := 1 to cantDetalles do begin
			Writeln(' ====== Cargando Detalle: ',i); 
			Str(i,IString);
			assign(vDet[i],'detalle'+iString); 
			rewrite (vDet[i]); 
			leerSesion(rDet); 	
			while (rDet.codUsuario > 0) do begin
				write(vDet[i],rDet); 
				leerSesion(rDet); 
			end; 
			writeln; 
			close(vDet[i]); 
		end; 
	end; 

	procedure generarMaestro (var maestro : archivoMaestro; var vecDet : vecDetalles); 
	var
		i : integer;
		rDet : rDetalle; 
		rMae : rMaestro; 
	begin
		writeln('==== Cargando archivo maestro.'); 
		assign(maestro,'maestro'); 
		rewrite(maestro); 
		for i:= 1 to cantDetalles do begin
		reset(vecDet[i]); {abrimos el archivo detalle}
		leerDetalle(vecDet[i],rDet); 
		while (rDet.codUsuario <> valorAlto) do begin
			leerMaestro(maestro,rMae); 
			{buscamos si existe el registro o no existe}
			while ( ( rMae.codUsuario<> valorAlto) and (rDet.codUsuario <> rMae.codUsuario) ) do 
				leerMaestro(maestro,rMae); 
			{si en el maesro el codUsuario = valorAlto significa que no existe y tengo que agregar el archivo}
			if (rMae.codUsuario = valorAlto) then begin
				//seek(maestro,filePos(maestro)-1); 
				rMae.codUsuario := rDet.codUsuario; 
				rMae.tiempoTotal:= rDet.tiempo_sesion;
				write(maestro,rMae);  
			end
			{sino, es porque encontre el registro, tengo que actualizarlo}	
			else begin
				seek(maestro,filePos(maestro)-1); 
				rMae.tiempoTotal:= rMae.tiempoTotal + rDet.tiempo_sesion; 
				write(maestro,rMae); 
			end; 
			seek(maestro,0); 
			leerDetalle(vecDet[i],rDet); 
		end; 	
		close(vecDet[i]); {cerramos el archivo detalle}
		end; 
		close(maestro); 
	end; 

	procedure imprimirMaestro (var maestro : archivoMaestro); 
	var
		rMae : rMaestro; 
	begin
		Writeln ('=== Datos del archivo maestro'); 
		reset(maestro); 
		leerMaestro(maestro,rMae); 
		while (rMae.codUsuario <> valorAlto) do begin
			writeln ('Codigo de usuario: ',rMae.codUsuario, ' Tiempo total de sesion: ',rMae.tiempoTotal:2:2);
			leerMaestro(maestro,rMae); 
		end; 
		close(maestro);
	end;

	{programa principal}
	var
		maestro: archivoMaestro; 
		vecDet : vecDetalles; 
	begin
		Textcolor(LightCyan); 
		cargarDetalles(vecDet); 
		generarMaestro(maestro,vecDet);
		imprimirMaestro(maestro); 
	end.
