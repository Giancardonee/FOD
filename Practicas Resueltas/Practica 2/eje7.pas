{este me queda en bucle en la linea 130, me volvi loco queriendo encontrar el error. 
* PERO DESISTI.}
program eje7;
const 
	valorAlto = 9999;
const
	cantDetalles = 10; 
type
	rDetalle = record
		codigoLocalidad : integer;
		codigoCepa : integer;
		casosActivos : integer;
		casosNuevos : integer;
		casosRecuperados : integer;
		casosFallecidos : integer;
	end;
	
	rMaestro = record
		codigoLocalidad: integer;
		nombreLocalidad: string;
		codigoCepa: integer;
		nombreCepa: integer;
		casosActivos : integer;
		casosNuevos: integer;
		casosRecuperados: integer;
		casosFallecidos: integer;
	end;
	
	archivoMaestro = file of rMaestro;
	archivoDetalle = file of rDetalle;
	arrayDetalle = array [1..cantDetalles] of archivoDetalle;
	arrayRegDetalle = array [1..cantDetalles] of rDetalle;

{procesos}
{=====================================================================}
{=====================================================================}
procedure inicializarTotalCasos (var ta,tn,tr,tf : integer); 
begin
	ta:=0; tn:=0; tr:=0; tf:=0; 
end;
procedure actualizarTotalCasos (var ta,tn,tr,tf : integer; dato : rDetalle); 
begin
	ta:= ta + dato.casosActivos; 
	tn:= tn + dato.casosNuevos;
	tr := tr + dato.casosRecuperados; 
	tf := tf + dato.casosFallecidos; 
end;
procedure actualizarRegMaestro (var rMae: rMaestro; ta,tn,tr,tf : integer); 
begin
	rMae.casosActivos:= ta; 
	rMae.casosNuevos:= tn; 
	rMae.casosRecuperados:= tr;
	rMae.casosFallecidos:= tf; 
end;
{=====================================================================}
{=====================================================================}
procedure cerrarDetalles (var vD : arrayDetalle); 
var
 i : integer;
begin
	for i:= 1 to cantDetalles do 
		close(vD[i]); 
end;
procedure leer (var archD : archivoDetalle; var rD : rDetalle); 
begin
	if (not eof (archD) ) then 
		read(archD,rD)
	else
		rD.codigoLocalidad:= valorAlto;
end; 
{=====================================================================}
procedure inicializarDetalles(var vD : arrayDetalle; var vRegD : arrayRegDetalle) ; 
var
	i : integer;
	iString : string;
begin
	for i:= 1 to cantDetalles do 
		begin
			Str(i,iString); 
			assign(vD[i],'detalle'+iString); 
			reset(vD[i]); 
			leer(vD[i],vRegD[i]); 
		end; 
end;
{=====================================================================}
procedure minimo (var vD : arrayDetalle; vRegD: arrayRegDetalle; var min : rDetalle); 
var
	i,posMin : integer;
begin
	min.codigoLocalidad:= valorAlto; 
	min.codigoCepa:= valorAlto;
	for i:= 1 to cantDetalles do 
		begin
			if ( (vRegD[i].codigoLocalidad < min.codigoLocalidad) or ( (vRegD[i].codigoLocalidad = min.codigoLocalidad) and (vRegD[i].codigoCepa < min.codigoCepa) ) ) then 
				begin
					min:= vRegD[i]; 
					posMin:= i;
				end;
		end;
		leer(vD[posMin],vRegD[posMin]); 
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var vD : arrayDetalle; var vRegD : arrayRegDetalle);
var
	min : rDetalle; 
	rMae: rMaestro; 
	localidadActual,cepaActual : integer;
	totalNuevos,totalActivos,totalRecuperados,totalFallecidos : integer;
begin
	assign(maestro,'maestro'); 
	reset(maestro); 
	read(maestro,rMae);
	minimo(vD,vRegD,min); 
	writeln('codigo minimo del maestro: ',rMae.codigoLocalidad); 
	writeln('Codigo cepa del maestro: ',rMae.codigoCepa); 
	writeln ('codigo minimo del minimo: ',min.codigoLocalidad); 
	writeln ('codigo cepa del minimo: ',min.codigoCepa);
	while (min.codigoLocalidad <> valorAlto) do 
		begin
			localidadActual:= min.codigoLocalidad; 
			{procesamos por localidad}
			while (localidadActual = min.codigoLocalidad) do 
				begin
					cepaActual:= min.codigoCepa; 
					inicializarTotalCasos(totalActivos,totalNuevos,totalRecuperados,totalFallecidos); 
					{procesamos por localidad y cepa actual}
					while ( (localidadActual = min.codigoLocalidad) and (cepaActual = min.codigoCepa) ) do 
						begin
							actualizarTotalCasos(totalActivos,totalNuevos,totalRecuperados,totalFallecidos,min); 
							minimo(vD,vRegD,min); 
							{justo aca pasa un bucle infinito que no entiendo de donde es}
						end; 
					{cuando salga de aca es porque se leyo una cepa distinta, entonces debemos actualizar el maestro }
					{buscamos por localidad}
					while (rMae.codigoLocalidad <> localidadActual)  do 
						read(maestro,rMae); 
					{una vez que encontremos la localidad,buscamos la cepa}
					while (rMae.codigoCepa <> cepaActual) do 
						read(maestro,rMae); 
					{cuando salga de aca es porque encontro el registro en el maestro}
					actualizarRegMaestro(rMae,totalActivos,totalNuevos,totalRecuperados,totalFallecidos); 
					seek(maestro,filePos(maestro)-1); 
					write (maestro,rMae); 
				end;
		end;
		cerrarDetalles(vD);  
		close(maestro); 
 end;

procedure informarCantLocalidadesMas50CasosActivos(var m : archivoMaestro); 
var
	rMae : rMaestro;
	cant : integer;
begin
	reset(m);
	cant:= 0;
	while not eof (m) do 
		begin
			read(m,rMae); 
			if (rMae.casosActivos > 50) then 
				cant:= cant + 1;
		end;
	writeln ('La cantidad de localidades con mas de 50 casos activos son: ',cant); 
	close(m);
end;

var
	maestro : archivoMaestro; 
	vDetalle : arrayDetalle; 
	vRegDetalle: arrayRegDetalle;
begin
	inicializarDetalles(vDetalle,vRegDetalle); 
	actualizarMaestro(maestro,vDetalle,vRegDetalle); 
	informarCantLocalidadesMas50CasosActivos(maestro); 
end.







//crearMaestro(maestro); 
//imprimirMaestro(maestro);
//imprimirDetalle(vDetalle);


{procedure imprimirMaestro(var m : archivoMaestro); 
var
	dato : rMaestro;
begin
		assign(m,'maestro');
		reset(m);
		while (not eof (m)) do 
			begin
				read(m,dato); 
				writeln('codigo de localidad: ',dato.codigoLocalidad, ' Nombre de la localidad: ',dato.nombreLocalidad );
				writeln ('Codigo cepa: ',dato.codigoCepa, ' casos activos: ',dato.casosActivos, ' casos nuevos: ',dato.casosNuevos, ' casos recuperados: ',dato.casosRecuperados,
				 ' Casos fallecidos ',dato.casosFallecidos ); 
				 writeln;
			end;
		close(m);
end;
* }

{procedure imprimirMaestro(var m : archivoMaestro); 
var
	dato : rMaestro;
begin
		assign(m,'maestro');
		reset(m);
		while (not eof (m)) do 
			begin
				read(m,dato); 
				writeln('codigo de localidad: ',dato.codigoLocalidad, ' Nombre de la localidad: ',dato.nombreLocalidad );
				writeln ('Codigo cepa: ',dato.codigoCepa, ' casos activos: ',dato.casosActivos, ' casos nuevos: ',dato.casosNuevos, ' casos recuperados: ',dato.casosRecuperados,
				 ' Casos fallecidos ',dato.casosFallecidos ); 
			end;
		close(m);
end;
* }


{
* 
* procedure imprimirDetalle (var v : arrayDetalle);
var
	i : integer;
	iString : string; 
	dato : rDetalle; 
begin
	for i:= 1 to cantDetalles do 
		begin
			Str (i,iString); 
			assign(v[i],'detalle'+iString); 
			reset(v[i]); 
			writeln('Detalle ',i); 
			while not eof (v[i]) do 
				begin
					read(v[i],dato); 
					writeln ('Localidad: ',dato.codigoLocalidad, ' codigo cepa: ',dato.codigoCepa,
					 ' Casos activos: ',dato.casosActivos, ' casos nuevos: ',dato.casosNuevos, 
					 ' casos recuperados: ',dato.casosRecuperados, ' casos fallecidos: ',dato.casosFallecidos  ); 
				end; 
		end;
end;

* cargarTodosLosDetalles(vDetalle); 
* 
* 
* procedure leer_rDetalle (var dato : rDetalle); 
begin
	write ('Codigo de localidad: '); readln (dato.codigoLocalidad); 
	if (dato.codigoLocalidad <> 0) then 
		begin
			write ('Codigo cepa: '); readln (dato.codigoCepa); 
			write ('casos activos: '); readln (dato.casosActivos); 
			write ('casos nuevos: '); readln (dato.casosNuevos); 
			write ('casos recuperados: '); readln (dato.casosRecuperados);
			write ('casos fallecidos: '); readln (dato.casosFallecidos); 
			writeln('-----------------------------------------------'); 
		end;
end;

procedure generarDetalle(var det: archivoDetalle); 
var
	dato : rDetalle;
begin
	leer_rDetalle(dato);
	write(det,dato); 
end;

procedure cargarTodosLosDetalles(var vD : arrayDetalle); 
var
	i : integer;
	dato : rDetalle; 
	iString : string; 
begin
	for i:= 1 to cantDetalles do 
		begin
			Str (i, iString); 
			assign(vD[i],'detalle'+iString);
			rewrite(vD[i]); 
			leer_rDetalle(dato); 
			while (dato.codigoLocalidad <> 0) do 
				begin
					write(vD[i],dato); 
					leer_rDetalle(dato);
				end;
			close(vD[i]); 
		end;
end;
* 
* 
* }

{procedure leerRegMaestro (var dato : rMaestro); 
begin
	write ('Codigo de localidad: '); readln (dato.codigoLocalidad); 
	if (dato.codigoLocalidad <> 0) then 
		begin
			dato.nombreLocalidad:= 'aa'; 
			write ('Codigo cepa: '); readln (dato.codigoCepa); 
			write ('casos activos: '); readln (dato.casosActivos); 
			write ('casos nuevos: '); readln (dato.casosNuevos); 
			write ('casos recuperados: '); readln (dato.casosRecuperados);
			write ('casos fallecidos: '); readln (dato.casosFallecidos); 
			writeln('-----------------------------------------------'); 
		end;
end;

procedure crearMaestro(var m : archivoMaestro); 
var
	dato : rMaestro;
begin
		assign(m,'maestro');
		rewrite(m);
		leerRegMaestro(dato);
		while (dato.codigoLocalidad <> 0) do 
			begin
				write(m,dato); 
				leerRegMaestro(dato); 
			end;
		close(m);
end; }
