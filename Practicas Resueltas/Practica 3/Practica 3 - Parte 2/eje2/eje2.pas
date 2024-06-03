{Para este eje voy a manejar dos archivos: 
* 
* 
* Tengo entendido que el primer archivo seria como un detalle, con elementos repetidos.
* 	Con elementos repetidos me refiero, a en este caso codigo de localidades repetidas. 
* 
* 
* Primer archivo, tengo:   codigo de localidad, numero de mesa y cantidad de votos 
* 	En este archivo esta toda la informacion desordenada. 
* 
* Segundo archivo (seria como un archivo maestro): Genero un archivo en el cual cada localidad aparece una sola vez
* 
*	Este archivo se usa a partir de los siguientes criterios:  
* 		Si la localidad del primer archivo no se encuentra en este archivo, se crea la localidad y se establece la cantidad de votos
* 		Si la localidad se encuentra: sumo la cantidad de votos a la localidad actual
* 			
* 			La idea es crear este segundo archivo para tener una especie de contador por localidad, es decir para agrupar los votos por cada localidad. 
*	
* 		De esta manera, una vez que termine de recorrer el primer archivo (que tiene toda la informacion desordenada), puedo tener el segundo archivo
* 		con el total de votos de cada localidad, y lo imprimo en pantalla :) 
* }
program eje2; 
Uses Crt;
Const
	valorAlto = 9999;
type
	rVoto = record
		codigoLocalidad: integer;
		numeroMesa : integer;
		cantVotos : integer;
	end;
	
	rMaestro = record
		codigoLocalidad:  integer;
		cantVotos: integer;
	end;

	archivoVotos = file of rVoto; 
	archivoMaestro = file of rMaestro; 


	procedure leerMaestro(var m : archivoMaestro; var rMae : rMaestro); 
	begin
		if (not eof(m) ) then 
			read(m,rMae)
		else rMae.codigoLocalidad:= valorAlto;
	end;
	
	procedure leerVotos (var v : rVoto); 
	begin
		write ('Ingrese el codigo de localidad: '); readln (v.codigoLocalidad); 
		if (v.codigoLocalidad >0) then begin
			//write ('Ingrese el numero de mesa: '); readln (v.numeroMesa); 
			write ('Ingrese la cantidad de votos: '); readln (v.cantVotos); 
		end;
	end;
	
	procedure cargarArchivoVotos (var a : archivoVotos); 
	var
		v : rVoto; 
	begin
		writeln ('||| ======== Creando archivo de votos: ');
		assign(a,'informacionDeVotos'); 
		rewrite(a);
		leerVotos(v); 
		while (v.codigoLocalidad > 0) do begin
			write (a,v);
			leerVotos(v); 
		end;
		writeln; 
		close(a);
	end;
	
	procedure generarMaestro (var mae : archivoMaestro; var votos : archivoVotos); 
	var
		v : rVoto;
		rMae : rMaestro; 
	begin
		writeln ('===== Un momento, estamos trabajando para contar los votos de cada localidad.');
		assign(mae,'maestroVotos'); 
		rewrite(mae); 
		reset(votos);
		while (not eof (votos)) do begin
				read(votos,v);
				leerMaestro(mae,rMae);
						{buscamos si existe la localidad en el "maestro"}
				while ( (rMae.codigoLocalidad <> valorAlto) and (rMae.codigoLocalidad <> v.codigoLocalidad) ) do 
					leerMaestro(mae,rMae);
					
				if (rMae.codigoLocalidad = valorAlto) then begin {la localidad no existe,debemos agregarla al archivo}
					rMae.codigoLocalidad := v.codigoLocalidad; 
					rMae.cantVotos:= v.cantVotos; 
					write(mae,rMae); 
				end
				else begin {la localidad existe, debo actualizar la cantidad de votos}
					rMae.cantVotos:= rMae.cantVotos + v.cantVotos;
					seek(mae,filePos(mae)-1); 
					write(mae,rMae); 
				end;
				seek(mae,0); 
		end;
		writeln; 
		close(mae); 
		close(votos);
	end;
	
	procedure imprimirVotos (var mae : archivoMaestro); 
	var
		rMae : rMaestro;
		totalVotos : integer;
	begin
		writeln('======    INFORME DE VOTOS POR LOCALIDAD ===========');
		totalVotos:=0;
		reset(mae); 
		leerMaestro(mae,rMae); 
		while (rMae.codigoLocalidad <> valorAlto) do begin
			writeln ('Codigo de Localidad: ',rMae.codigoLocalidad,'         Total de votos: ',rMae.cantVotos); 
			totalVotos:= totalVotos + rMae.cantVotos;
			leerMaestro(mae,rMae); 
		end;
		writeln('|||==> Total General de Votos: ',totalVotos);
		close(mae); 
	end;
	
	{programa principal}
	var
		archVotos : archivoVotos;
		maestro : archivoMaestro;
	begin
		Textcolor (LightCyan); 
		cargarArchivoVotos(archVotos); 
		generarMaestro(maestro,archVotos);
		imprimirVotos(maestro); 
	end.
