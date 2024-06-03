program eje6; 
const
	valorAlto = 9999; 
	cantDetalles = 5; 
type 
	str20 = string[20]; 
	rDetalle = record
		codigoUsuario : integer; 
		fecha : str20; // ej:  12032014  ==> dd mm yyyyy
		tiempoSesion : real; // puede ser 1.5 hs 
	end; 
	rMaestro = record
		codigoUsuario : integer; 
		fecha : str20; 
		tiempoTotalSesiones : real; 
	end; 
	archivoMaestro = file of rMaestro; 
	archivoDetalle = file of rDetalle; 
	arrayDetalles = array [1..cantDetalles] of archivoDetalle; 
	arrayRegDetalles = array [1..cantDetalles] of rDetalle; 


procedure imprimirMaestro (var maestro : archivoMaestro); 
var
	rMae : rMaestro; 
begin
	reset(maestro); 
	while (not eof(maestro) ) do 
		begin
			read(maestro,rMae); 
			writeln ('Codigo usuario: ',rMae.codigoUsuario, ' fecha: ',rMae.fecha, ' TiempoTotal: ',rMae.tiempoTotalSesiones:2:2, 'hs.'); 
		end; 
	close(maestro); 
end; 	

{==================================================================================}
{--------- procesos ---------------}	
procedure leer(var det : archivoDetalle; var regDet : rDetalle ); 
begin
	if (not eof(det) ) then 
		read(det,regDet)
	else
		regDet.codigoUsuario:= valorAlto; 
end; 

procedure mostrarDetalle(var archD : archivoDetalle); 
var
	dato : rDetalle; 
begin
	while not (eof(archD)) do 
		begin
			read(archD,dato); 
			writeln ('Usuario: ',dato.codigoUsuario, ' Fecha: ',dato.fecha, ' tiempo sesion: ',dato.tiempoSesion:2:2, ' hs.' ); 
		end;
end;

procedure inicializarDetalles (var vecDetalles : arrayDetalles; var vecRegDet : arrayRegDetalles); 
var
	i : integer;
	iString : string; 
begin
	for i:= 1 to cantDetalles do 
		begin
			Str(i,iString); 
			assign(vecDetalles[i],'detalle'+iString);  
			reset(vecDetalles[i]); 
			leer(vecDetalles[i],vecRegDet[i]); 
		end; 
end;

procedure cerrarDetalles (var vD : arrayDetalles); 
var
	i : integer;
begin
	for i:= 1 to cantDetalles do
		close(vD[i]); 
end; 

{buscamos el menor codigo de usuario con la menor fecha}
procedure minimo (var vDet : arrayDetalles; var vRegDet : arrayRegDetalles; var min : rDetalle);
var
	posMin,i : integer; 
begin
	min.fecha:= '28082025'; {ddmmyyyy ==> 01082024} 
	min.codigoUsuario:= valorAlto; 
	for i:= 1 to cantDetalles do 
		begin
			if (vRegDet[i].codigoUsuario <min.codigoUsuario)  or ( (vRegDet[i].codigoUsuario =min.codigoUsuario)  and (vRegDet[i].fecha < min.fecha) ) then  
				begin
							min := vRegDet[i]; 
						    posMin:= i;
				end;
		end; 
			leer(vDet[posMin],vRegDet[posMin]); 
end; 

procedure crearMaestro (var mae :archivoMaestro; var vDet : arrayDetalles; var vRegDet : arrayRegDetalles); 
var
	fechaActual : string; 
	min : rDetalle; 
	totalHoras : real; 
	usuarioActual : integer;
	rMae : rMaestro; 
begin
	assign(mae,'maestro');
	rewrite (mae); 
	minimo(vDet,vRegDet,min); 
		while (min.codigoUsuario <> valorAlto) do 
			begin
				usuarioActual:= min.codigoUsuario; 
				while (usuarioActual = min.codigoUsuario) do   
					begin
						totalHoras:= 0;
						fechaActual:= min.fecha; 
							while ( (usuarioActual = min.codigoUsuario) and (fechaActual = min.fecha) ) do 
								begin
									totalHoras:= totalHoras + min.tiempoSesion; 
									minimo(vDet,vRegDet,min); 
								end; 
					rMae.codigoUsuario:= usuarioActual; 
					rMae.fecha:= fechaActual; 
					rMae.tiempoTotalSesiones:= totalHoras; 
					write(mae,rMae); 
				end; 
			end;
	close(mae); 
	cerrarDetalles(vDet); 
end; 
var
		maestro : archivoMaestro; 
		vecDetalles : arrayDetalles; 
		vecRegDetalles : arrayRegDetalles; 
begin 
	//generarDetalles(vecDetalles,vecRegDetalles); 
	inicializarDetalles(vecDetalles,vecRegDetalles);  
	crearMaestro(maestro,vecDetalles,vecRegDetalles); 
	imprimirMaestro(maestro);
end.
	
	
{
*procesos para debugg
procedure imprimirDetalle (var archD : archivoDetalle); 
var
	rDet : rDetalle;
begin
	while (not eof (archD)) do 
		begin
			read (archD,rDet); 
			writeln ('Codigo usuario: ',rDet.codigoUsuario); 
			writeln ('Fecha: ',rDet.fecha);
			writeln ('Tiempo sesion: ',rDet.tiempoSesion:2:2); 
			writeln(); 
		end;
end;


procedure generarDetalles (var vD : arrayDetalles; var vR : arrayRegDetalles ); 
var
	rDet : rDetalle; 
	iString : string; 
	i,j : integer; 
begin
	for i:= 1 to cantDetalles do 
		begin
		writeln('Detalle ',i); 
			Str(i, iString); 
			assign(vD[i], 'detalle'+iString); 
			rewrite(vD[i]); 
			for j:= 1 to 2 do 
				begin
					rDet.codigoUsuario:= i;
					writeln ('Ingrese para el usuario ',i);
					write ('Ingrese una fecha: '); readln (rDet.fecha); 
					write ('Ingrese las horas: '); readln (rDet.tiempoSesion); 
					write (vD[i],rDet);  
				end;
			close(vD[i]); 
		end; 
end; 
* }
	

	
{que diferencias habria entre: 
* procedure actualizarMaestro (var mae :archivoMaestro; var vDet : arrayDetalles; var vRegDet : arrayRegDetalles); 
var
	fechaActual : string; 
	min : rDetalle; 
	totalHoras : real; 
	usuarioActual : integer;
	rMae : rMaestro; 
begin
	rewrite (mae); 
	minimo(vDet,vRegDet,min); 
	while (min.codigoUsuario <> valorAlto) do 
		begin
			usuarioActual:= min.codigoUsuario; 
			while (usuarioActual = min.codigoUsuario) do   
				begin
					totalHoras:= 0;
					fechaActual:= min.fecha; 
					while ( (usuarioActual = min.codigoUsuario) and (fechaActual = min.fecha) ) do 
						begin
						totalHoras:= totalHoras + min.tiempoSesion; 
						minimo(vDet,vRegDet,min); 
					end; 
				end; 
			rMae.codigoUsuario:= usuarioActual; 
			rMae.fecha:= fechaActual; 
			rMae.tiempoTotalSesiones:= totalHoras; 
			write(mae,rMae); 	
		end;
	close(mae); 
	cerrarDetalles(vDet); 
end; 
* 
* y 
* 
* procedure actualizarMaestro (var mae :archivoMaestro; var vDet : arrayDetalles; var vRegDet : arrayRegDetalles); 
var
	fechaActual : string; 
	min : rDetalle; 
	totalHoras : real; 
	usuarioActual : integer;
	rMae : rMaestro; 
begin
	rewrite (mae); 
	minimo(vDet,vRegDet,min); 
	while (min.codigoUsuario <> valorAlto) do 
		begin
			usuarioActual:= min.codigoUsuario; 
			totalHoras:= 0;
			fechaActual:= min.fecha; 
			while ( (usuarioActual = min.codigoUsuario) and (fechaActual = min.fecha) )  do   
				begin
						totalHoras:= totalHoras + min.tiempoSesion; 
						minimo(vDet,vRegDet,min);  
				end; 
			rMae.codigoUsuario:= usuarioActual; 
			rMae.fecha:= fechaActual; 
			rMae.tiempoTotalSesiones:= totalHoras; 
			write(mae,rMae); 	
		end;
	close(mae); 
	cerrarDetalles(vDet); 
end; 
* 
* 
* GPT dice: 
* 
* En resumen, el primer procedimiento calculará el tiempo total de sesiones para cada usuario y fecha por separado, 
* mientras que el segundo procedimiento calculará el tiempo total de sesiones para cada usuario, independientemente de la fecha. 
* La elección del procedimiento dependerá de cómo desees que se agreguen los tiempos de sesión en el archivo maestro.}	
	
	
	
