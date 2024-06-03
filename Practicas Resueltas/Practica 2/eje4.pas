program eje4; 
const 
	corte = 'fin'; 
type
	rMaestro = record
		provincia : string[20]; 
		personasAlfabetizadas : integer; 
		totalEncuestados : integer; 
	end; 
	rDetalle = record
		provincia : string[20]; 
		codigoLocalidad : integer; 
		personasAlfabetizadas : integer; 
		totalEncuestados : integer;
	end;
	archivoMaestro = file of rMaestro; 
	archivoDetalle = file of rDetalle; 

{procesos que se disponen y procesos para debugg}
procedure leer_rMaestro (var dato : rMaestro); 
begin
	write ('Ingrese la provincia: '); readln (dato.provincia); 
	dato.personasAlfabetizadas:= 1000; 
	dato.totalEncuestados:= 2000; 
end; 
procedure cargarMaestro (var archM : archivoMaestro); 
var
	dato : rMaestro; 
begin
	rewrite(archM); 
	leer_rMaestro(dato); 
	while (dato.provincia <> 'fin') do 
		begin
			write(archM,dato); 
			leer_rMaestro(dato); 
		end;
	close(archM); 
end;

procedure leer_rDetalle (var dato : rDetalle); 
begin
	write ('Provincia: '); readln (dato.provincia); 
	if (dato.provincia <> 'fin') then 
		begin
		write ('Codigo localidad: '); readln (dato.codigoLocalidad); 
		write ('Cant alfabetizados: '); readln (dato.personasAlfabetizadas); 
		write ('Total encuestados: '); readln(dato.totalEncuestados); 	
		end; 
end; 	
procedure cargarDetalle (var archD : archivoDetalle); 
var
	dato : rDetalle; 
begin
	rewrite (archD); 
	leer_rDetalle(dato); 
	while (dato.provincia <> 'fin') do 
		begin
			write (archD,dato); 
			leer_rDetalle(dato); 
		end; 
	close(archD); 
end; 

procedure imprimirMaestro (var mae : archivoMaestro); 
var
	rMae : rMaestro; 
begin
	reset(mae); 
	while (not eof(mae)) do 
		begin
			read(mae,rMae); 
			writeln('Provincia: ',rMae.provincia, ' Alfabetizados: ',rMae.personasAlfabetizadas, ' Encuestados: ',rMae.totalEncuestados ); 
		end; 
	close(mae); 
end; 
{---------------------------------------------------------------------------------------------------------------------}
{procesos}
procedure leer(var archD : archivoDetalle; var dato : rDetalle); 
begin
	if (not eof(archD) ) then 
		read(archD,dato)
	else
		dato.provincia:= corte; 
end; 

procedure minimo (var r1,r2, min: rDetalle; var det1,det2 : archivoDetalle); 
begin
	if (r1.provincia < r2.provincia) then begin
		min:= r1; leer(det1,r1)
		end
	else begin 
		min:= r2; leer (det2,r2); 
	end;  
end; 

procedure actualizarMaestro (var archM : archivoMaestro; var det1,det2: archivoDetalle); 
var
	rDet1,rDet2, min : rDetalle; 
	rMae : rMaestro; 
	provinciaActual : string[20]; 
	alfabetizados,encuestados : integer;
begin
	reset(archM); 
	reset(det1); 
	reset(det2); 
	read(archM,rMae);
	leer(det1,rDet1); leer (det2,rDet2); 
	minimo (rDet1,rDet2,min,det1,det2); 
	while (min.provincia <> corte) do 
		begin
			provinciaActual:= min.provincia; 
			alfabetizados:=0; encuestados:=0; 
		{contamos todo de la prov actual}	
			while (provinciaActual = min.provincia) do 
				begin
					alfabetizados:= alfabetizados + min.personasAlfabetizadas; 
					encuestados:= encuestados + min.totalEncuestados; 
					minimo(rDet1,rDet2,min,det1,det2) ; 
				end;
		 {buscamos la provincia actual en el maestro}
		 while (rMae.provincia <> provinciaActual) do 
			read(archM,rMae); 
		rMae.personasAlfabetizadas:= rMae.personasAlfabetizadas + alfabetizados;
		rMae.totalEncuestados:= rMae.totalEncuestados + encuestados;
		seek(archM, filePos(archM)-1); 
		write (archM,rMae); 
		if (not eof (archM)) then read(archM,rMae); 
		end; 
	close(archM); 
	close(det1); 
	close(det2); 
end; 

var
	maestro : archivoMaestro; 
	detalle1,detalle2 : archivoDetalle; 
begin
assign(detalle1,'detalle1'); 
assign(detalle2,'detalle2'); 
assign(maestro,'maestro'); 
cargarMaestro(maestro); {se dispone. lo hice por debbug}
cargarDetalle(detalle1);  {se dispone. lo hice por debbug}
cargarDetalle(detalle2);  {se dispone. lo hice por debbug}
actualizarMaestro(maestro,detalle1,detalle2); 
imprimirMaestro(maestro); {por debugg} 
end.
