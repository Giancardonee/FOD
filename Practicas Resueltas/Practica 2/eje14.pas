program eje14; 
const
	cantDetalles = 10;
	valorAlto = 9999;
type
	str20 = string[20];
	rMaestro = record
		codigoPcia : integer;
		nombrePcia : str20;
		codigoLocalidad : integer;
		nombreLocalidad : str20; 
		vSinLuz : integer;
		vSinGas : integer;	
		vSinAgua : integer;
		vSinSanitarios : integer;
		vDeChapa : integer;
	end;
	
	rDetalle  = record
		codigoPcia : integer; 
		codigoLocalidad: integer;
		vConLuz : integer;
		vConstruidas : integer;
		vConAgua : integer;
		vConGas : integer;
		entregaSanitarios : integer;
	end;
	{===========================================}
	archivoMaestro = file of rMaestro;
	{===========================================}
	archivoDetalle = file of rDetalle; 
	vecDetalles = array [1..cantDetalles] of archivoDetalle;
	vecRegDetalles = array [1..cantDetalles] of rDetalle; 
	{===========================================}
{==========================================================}
procedure leerDetalle(var det : archivoDetalle; var dato : rDetalle ); 
begin
	if (not eof (det) ) then 
		read(det,dato)
	else dato.codigoPcia:= valorAlto;
end; 		
procedure minimo (var vDet  : vecDetalles; var regDet : vecRegDetalles; var min : rDetalle); 
var 
	i,posMin : integer;
begin
	min.codigoPcia:= valorAlto; 
	min.codigoLocalidad:= valorAlto; 
	for i:= 1 to cantDetalles do 
		begin
			if ( ( regDet[i].codigoPcia < min.codigoPcia) or  
			( ( regDet[i].codigoPcia = min.codigoPcia) and (regDet[i].codigoLocalidad <= min.codigoLocalidad))  )then begin
				min:= regDet[i]; 
				posMin := i; 
			 end; 
		end ;
		leerDetalle(vDet[posMin],regDet[posMin]); 
end; 
procedure inicializarDetalles (var vDet : vecDetalles; var vRegDet : vecRegDetalles); 
var
	i : integer;
	iString : string; 
begin
	for i:= 1 to cantDetalles do 
		begin
			Str(i,iString); 
			assign(vDet[i],'detalle'+iString); 
			reset(vDet[i]); 
			leerDetalle(vDet[i],vRegDet[i]); 
		end; 
end;
procedure cerrarTodosLosDetalles (var vDet : vecDetalles); 
var
	i : integer; 
begin
	for i:= 1 to cantDetalles do 
		close(vDet[i]); 
end;
{==========================================================}
procedure inicializarContadores (var aux : rDetalle); 
begin
	with aux do begin 
		vConLuz:= 0; 
		vConstruidas:=0; 
		vConAgua:=0;
		vConGas:=0;
		entregaSanitarios:=0;
	end; 
end;
procedure actDatosLozalidad (det : rDetalle; var aux : rDetalle); 
begin
	aux.vConLuz:= aux.vConLuz + det.vConLuz;
	aux.vConstruidas:= aux.vConstruidas + det.vConstruidas; 
	aux.vConAgua:= aux.vConAgua + det.vConAgua; 
	aux.vConGas:= aux.vConGas + det.vConGas;
	aux.entregaSanitarios:= aux.entregaSanitarios + det.entregaSanitarios;  
end; 
procedure actualizarMaestro (var maestro : archivoMaestro; rMae : rMaestro; detAux : rDetalle); 
begin
	rMae.vSinLuz:= rMae.vSinLuz - detAux.vConLuz;
	rMae.vSinAgua:= rMae.vSinAgua - detAux.vConAgua; 
	rMae.vSinGas:= rMae.vSinGas - detAux.vConGas; 
	rMae.vSinSanitarios:= rMae.vSinSanitarios - detAux.entregaSanitarios;
	rMae.vDeChapa:= rMae.vDeChapa - detAux.vConstruidas;  
	seek(maestro,filePos(maestro)-1); 
	write(maestro,rMae); 
end; 

procedure actualizarMaestro (var maestro : archivoMaestro; var vecDet : vecDetalles);
var	
	rMae : rMaestro; 
	regDet : vecRegDetalles;
	min,detalleAux: rDetalle; 
begin
	assign(maestro,'maestro'); 
	reset(maestro); 
	inicializarDetalles(vecDet,regDet); 
	read(maestro,rMae); 
	minimo(vecDet,regDet,min); 
	while (min.codigoPcia <> valorAlto) do 
		begin
			detalleAux.codigoPcia:= min.codigoPcia; 
			{procesamos la provincia actual}
			while (detalleAux.codigoPcia = min.codigoPcia) do 
				begin
					inicializarContadores(detalleAux); 
					detalleAux.codigoLocalidad:= min.codigoLocalidad; 
					{procesamos la localidad de la misma provincia}
					while ( (detalleAux.codigoPcia = min.codigoPcia) and (detalleAux.codigoLocalidad = min.codigoLocalidad)  ) do
						begin
							actDatosLozalidad(min,detalleAux); 
							minimo(vecDet,regDet,min); 
						end; {fin de la provincia y localidad actual} 
						{buscamos la provincia y localidad en el maestro, para actualizarla}
						while ( (rMae.codigoPcia <> detalleAux.codigoPcia) and (rMae.codigoLocalidad <> detalleAux.codigoLocalidad) ) do 
								read(maestro,rMae); 
						{cuando salgo del while es porque encontre la provincia y la localidad actual en el maestro, 
						* tengo que actualizar el maestro}
						actualizarMaestro(maestro,rMae,detalleAux); 
				end; {fin de la provincia actual}
				if (not eof (maestro)) then read(maestro,rMae); 
		end;{fin de los detalles}
	cerrarTodosLosDetalles(vecDet); 
	close(maestro); 
end;

var
	maestro : archivoMaestro;
	vDetalles : vecDetalles;
begin
	//cargarMaestroTxt(maestro); {se dispone la info} 
	// cargarDetalles(vDetalles);  {se dispone la info}
	actualizarMaestro(maestro,vDetalles); 
end.



{procedure cargarMaestroTxt (var maestro : archivoMaestro) ;
var
	archivoTxt : text;
	dato : rMaestro; 
begin
	assign(archivoTxt,'cargaTxt.txt');
	reset(archivoTxt); 
	assign(maestro,'maestro'); 
	rewrite (maestro); 
	while (not eof (archivoTxt)) do 
		begin
			with dato do begin
				readln(archivoTxt, codigoPcia, codigoLocalidad,nombrePcia); 
				readln(archivoTxt,nombreLocalidad); 
				readln(archivoTxt,vSinLuz, vSinGas, vSinSanitarios,vDeChapa);
			end; 
			write(maestro,dato); 
		end;
	close(archivoTxt);
	close(maestro); 
end;}
