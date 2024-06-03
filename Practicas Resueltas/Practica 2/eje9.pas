program eje9;
const
	valorAlto = 9999;
type 
	voto = record
		codigoProvincia : integer;
		codigoLocalidad: integer; 
		numeroMesa : integer; 
		votosMesa : integer; 
	end; 
	archivoVotos = file of voto; 

procedure leer (var archV : archivoVotos; var dato : voto); 
begin
	if (not eof (archV) ) then 
		read(archV,dato)
	else dato.codigoProvincia:= valorAlto; 
		
end; 

procedure procesarVotos (var archV : archivoVotos); 
var
	dato : voto; 
	provinciaActual, localidadActual : integer;
	totalVotos,votosProvincia,votosLocalidad : integer;
begin
	assign(archV,'maestro'); 
	reset(archV); 
	totalVotos:=0;
	leer(archV,dato);  
	while (dato.codigoProvincia <> valorAlto) do 
		begin
			votosProvincia:=0; 
			provinciaActual:= dato.codigoProvincia; 
			writeln('|| Codigo provincia: ',provinciaActual); 
			while (provinciaActual = dato.codigoProvincia) do 
				begin
					localidadActual:= dato.codigoLocalidad;
					votosLocalidad:= 0;
					while ( (provinciaActual = dato.codigoProvincia) and (localidadActual = dato.codigoLocalidad) ) do 
						begin
							votosLocalidad:= votosLocalidad + dato.votosMesa;
							leer(archV,dato); 
						end; {fin de la localidad actual} 
					writeln ('|| Codigo de localidad: ',localidadActual, ' Total votos ==> ',votosLocalidad); 
					votosProvincia:= votosProvincia + votosLocalidad;
				end; {fin de la provincia actual}
			writeln ('|| Total de votos provincia: ',votosProvincia); 
			totalVotos:= totalVotos + votosProvincia; 
			writeln('--');
		end; {fin del archivo} 
		Writeln('==>  Total general de votos: ',totalVotos); 
	close(archV); 
end; 
var
	archV : archivoVotos; 
begin
	procesarVotos(archV); 
end.


{debuggg
* procedure leerVoto (var v : voto); 
begin
	write ('Ingrese el codigo de provincia: '); readln (v.codigoProvincia); 
	if (v.codigoProvincia <>0) then 
		begin
			write ('Ingrese el codigo de localidad: '); readln (v.codigoLocalidad); 
			write ('Ingrese el numero de mesa: '); readln(v.numeroMesa); 
			write ('Ingrese el numero de votos: '); readln (v.votosMesa); 
		end;
end; 
procedure cargarArchivo (var archV : archivoVotos); 
var
	dato : voto; 
begin
	assign(archV,'maestro'); 
	rewrite(archV); 
	leerVoto(dato); 
	while (dato.codigoProvincia <>0) do 
		begin
			write(archV,dato); 
			leerVoto(dato); 
		end; 
		close(archV); 
end; 

* }
