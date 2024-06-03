program eje13; 
const
	valorAlto = '9999';
type 
	str20 = string[20]; 
	str10 = string[10]; 
	str5= string[5]; 
	rMaestro = record
		destino : str20;
		fecha : str10;  {dd/mm/yyyy}
		horaSalida : str5; {17:45}
		cantAsientosDisp : integer;
	end;
	
	rDetalle = record
		destino : str20; 
		fecha : str10; 
		horaSalida : str5; 
		asientosComprados : integer;
	end;
	
	lista = ^nodo; 
	nodo = record
		dato : rMaestro; 
		sig : lista; 
	end; 
	
	archivoMaestro = file of rMaestro;
	archivoDetalle = file of rDetalle; 
	
procedure leerDetalle (var det : archivoDetalle; var dato : rDetalle); 
begin
		if (not eof (det) ) then 
			read(det,dato)
		else dato.destino:= valorAlto; 
end;

procedure minimo (var archD1,archD2: archivoDetalle; var det1,det2,min : rDetalle); 
begin
	if ( (det1.destino < det2.destino) and (det1.fecha < det2.fecha)
	 and (det1.horaSalida < det2.horaSalida) )  then begin
			min:= det1; 
			leerDetalle(archD1,det1); 
	end
	else begin
		min:= det2; 
		leerDetalle(archD2,det2); 
	end; 
end; 

procedure inicializarVariablesVuelo (var dato : rDetalle; min : rDetalle); 
begin
	dato.destino:= min.destino; 
	dato.fecha:= min.fecha; 
	dato.horaSalida:= min.horaSalida; 
	dato.asientosComprados:=0; 
end; 

function seaMismoVuelo (actual ,min : rDetalle): boolean;
begin
	seaMismoVuelo:= ( (actual.destino = min.destino) and (actual.fecha = min.fecha) and (actual.horaSalida = min.horaSalida)) ; 
end;  

function noExcedeCapacidadAsientos (asientosVuelo,asientosVendidos : integer): boolean; 
begin
	noExcedeCapacidadAsientos:= (asientosVendidos <= asientosVuelo); 
end; 

{en este while no puedo usar la funcion seaMismo vuelo, porque espera recibir dos parametros de rDetalle
* y el registro del maestro es rMaestro, podria asignarle los datos del maestro a un registro aux detalle, 
* para poder usar la funcion anterior, pero asi tambien deberia andar. }
procedure buscarVueloEnMaestro (var maestro : archivoMaestro; var rMae : rMaestro;  vueloActual : rDetalle); 
begin
	while ( (rMae.destino <> vueloActual.destino) and (rMae.fecha <> vueloActual.fecha) and (rMae.horaSalida <> vueloActual.horaSalida) ) do 
			read(maestro,rMae); 	
end; 

procedure actualizarMaestro (var maestro : archivoMaestro; rMae : rMaestro; asientosComprados : integer); 
begin
	rMae.cantAsientosDisp:= rMae.cantAsientosDisp - asientosComprados; 
	write(maestro,rMae); {actualizamos}
	seek (maestro,filePos(maestro)-1); 
end;

function MenosCantidadAsientosDisponibles(asientosDisp,asientosEspecificos : integer) : boolean ;
begin
	MenosCantidadAsientosDisponibles:= (asientosEspecificos < asientosDisp); 
end;  

procedure agregarEnLaLista (dato : rMaestro; listaVuelos : lista); 
var
	nue : lista; 
begin
	new(nue); 
	nue^.dato:= dato; 
	nue^.sig:= listaVuelos; 
	listaVuelos:= nue; 
end; 

{aca tengo una duda, donde debo leer el maestro?? antes del while? dentro del while lo leo
* en el proceso buscarVueloEnMaestro, pero no se si deberia leerlo antes o despues de ese proceso}
procedure procesarMaestro (var maestro : archivoMaestro; var det1,det2 : archivoDetalle; var listaVuelos : lista) ;
var
	rDet1,rDet2,min:  rDetalle; 
	actual : rDetalle; 
	rMae : rMaestro; 
    asientosEspecificos : integer; 
begin
	listaVuelos:= nil; 
	write('Ingrese una cantidad de asientos para generar una lista con vuelos con capacidad menor a la ingresada: '); 
	readln (asientosEspecificos); 
	assign(maestro,'maestro');
	assign(det1,'detalle1'); 
	assign(det2,'detalle2');  
	reset(maestro); 
	reset(det1); reset (det2); 
	leerDetalle(det1,rDet1); 
	leerDetalle(det2,rDet2); 
	minimo(det1,det2,rDet1,rDet2,min); 
	while (min.destino <> valorAlto) do 
		begin
			{inicializamos los campos  para procesar el mismo vuelo}
			inicializarVariablesVuelo(actual,min); 
			while (seaMismoVuelo(actual,min)) do begin 
				actual.asientosComprados:= actual.asientosComprados + min.asientosComprados;
				minimo(det1,det2,rDet1,rDet2,min); 
			end; 
			{terminamos de procesar el vuelo, debemos buscar el maestro,
			* y depende si se vendieron menos o mas asientos que los disponibles, actualizamos
			* o no actualizamos el maestro.}
			buscarVueloEnMaestro(maestro,rMae,min); 
			{inciso a}
			if (noExcedeCapacidadAsientos(rMae.cantAsientosDisp,actual.asientosComprados)) then 
				actualizarMaestro(maestro,rMae,actual.asientosComprados); 
			{inciso b}
			if (MenosCantidadAsientosDisponibles(rMae.cantAsientosDisp,asientosEspecificos)) then
					agregarEnLaLista(rMae,listaVuelos); 	
			if (not eof (maestro)) then read(maestro,rMae); {preguntar si este read esta bien aca}
		end; 
	close(maestro); 
	close(det1); close (det2); 	
end;

var
	det1,det2 : archivoDetalle;
	maestro : archivoMaestro;
	listaVuelos : lista;    
begin
	//cargarMaestro (maestro); 
	//cargarDetalles(det1,det2); 
	procesarMaestro(maestro,det1,det2,listaVuelos); 
end.
