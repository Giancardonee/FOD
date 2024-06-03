program eje15; 
const
	valorFechaAlto = '999999999'; 
	valorAlto = 9999; 
	cantDetalles = 100; 
type 
	str20  = string[20]; 
	str10 = string[10]; 
	rMaestro = record
		fecha : str10; 
		codigoSemanario : integer;
		nombreSemanario : str20; 
		descripcion : str20; 
		precio : real; 
		totalEjemplares: integer; 
		totalVendidos : integer; 
	end; 
	
	rDetalle = record
		fecha : str10; 
		codigoSemanario : integer; 
		ejemplaresVendidos : integer; 
	end; 
	
	archivoMaestro = file of rMaestro; 
	archivoDetalle = file of rDetalle; 
	
	vecDetalles  = array [1..cantDetalles] of archivoDetalle; 
	vecRegDetalles = array [1..cantDetalles] of rDetalle; 
	
	procedure leerDetalle (var det : archivoDetalle; var dato : rDetalle); 
	begin
		if (not eof(det)) then 
			read(det,dato)
		else dato.fecha:= valorFechaAlto; 
	end; 
	
	procedure inicializarDetalles (var vecDet : vecDetalles; var vRegDet : vecRegDetalles); 
	var
		i : integer; 
		iString : string; 
	begin
		for i:= 1 to cantDetalles do 
			begin
				Str(i,iString); 
				assign(vecDet[i],'detalle'+iString); 
				reset(vecDet[i]); 
				leerDetalle(vecDet[i], vRegDet[i]);  
			end; 		
	end; 

	procedure cerrarDetalles (var vDet : vecDetalles); 
	var
		i : integer;
	begin
		for i:= 1 to cantDetalles do 
			close(vDet[i]); 
	end; 

	procedure minimo (var vDet : vecDetalles; var vRegDet : vecRegDetalles; var min : rDetalle); 
	var
		posMin,i : integer; 
	begin
		posMin:= -1; 
		min.fecha := valorFechaAlto; 
		min.codigoSemanario:=valorAlto; 
		for i:= 1 to cantDetalles do 
			begin
				if  (vRegDet[i].fecha < min.fecha) or ( ( vRegDet[i].fecha = min.fecha ) 
				and (vRegDet[i].codigoSemanario < min.codigoSemanario))  then begin
				posMin:= i; 
				min:= vRegDet[i]; 
				end;
			end; 
			if (min.fecha <> valorFechaAlto) then
				leerDetalle(vDet[posMin],vRegDet[posMin]); 
	end ;

procedure evaluarMinMaxTotal (var rMax,rMin : rDetalle; dato: rDetalle); 
begin
	if (dato.ejemplaresVendidos > rMax.ejemplaresVendidos ) then 
		rMax:= dato; 
	if (dato.ejemplaresVendidos < rMin.ejemplaresVendidos ) then 
		rMin:= dato; 
end; 

procedure inicializarRegistrosMinMaxVentas (var rMinVentas, rMaxVentas : rDetalle); 
begin
	rMinVentas.fecha:= valorFechaAlto; 
	rMaxVentas.fecha:= valorFechaAlto; 
	rMinVentas.codigoSemanario:= valorAlto; 
	rMaxVentas.codigoSemanario:= valorAlto; 
	rMinVentas.ejemplaresVendidos:=9999;
	rMaxVentas.ejemplaresVendidos:=0;
end; 

procedure buscarSemanarioEnMaestro (var maestro : archivoMaestro; var rMae : rMaestro; codSemanarioActual : integer); 
begin
	while (rMae.codigoSemanario <> codSemanarioActual) do 
		read(maestro,rMae); 
end; 

function ventasNoSuperaStock (totalVendidoSemanario,totalVendidoMaestro,totalEjemplares : integer): boolean; 
begin
	ventasNoSuperaStock:= (totalVendidoSemanario + totalVendidoMaestro) <= totalEjemplares; 
end; 

procedure actualizarMaestro_yMaxMin (var maestro : archivoMaestro; rMae : rMaestro; tVendidos : integer; var rMinVentas,rMaxVentas : rDetalle ; rActual : rDetalle); 
begin
	{para actualizar el maestro, le asignamos le sumamos la nueva cantidad vendida}
	rMae.totalVendidos:= rMae.totalVendidos + tVendidos; 
	{actualizamos el maestro con la nueva cantidad vendida (siempre es menor o igual al totalEjemplares)}
	seek(maestro,filePos(maestro)-1); 
	write(maestro,rMae); 
	
	{calculamos fecha y seminario que tuvo mas y menos ventas}
	rActual.ejemplaresVendidos:= tVendidos; 
	evaluarMinMaxTotal(rMaxVentas,rMinVentas,rActual); 
end; 

procedure actualizarMaestro (var maestro : archivoMaestro; var vDetalles : vecDetalles); 
var
	rMinVentas,rMaxVentas : rDetalle; 
	rMin,rDetActual : rDetalle; 
	rMae : rMaestro; 
	vRegDet : vecRegDetalles;
	totalVendidos: integer; 
begin
	inicializarRegistrosMinMaxVentas(rMinVentas,rMaxVentas); 
	inicializarDetalles(vDetalles,vRegDet); 
	assign (maestro,'maestro'); 
	reset(maestro); 
	minimo(vDetalles,vRegDet,rMin);
	read(maestro,rMae);  
	while (rMin.fecha <> valorFechaAlto) do 
		begin
			rDetActual.fecha:= rMin.fecha;
			 while (rDetActual.fecha = rMin.fecha) do 
				begin
					rDetActual.codigoSemanario:= rMin.codigoSemanario; 
					totalVendidos:=0;
					while ( ( rDetActual.fecha = rMin.fecha) and (rDetActual.codigoSemanario = rMin.codigoSemanario) ) do 
						begin
							totalVendidos:= totalVendidos + rMin.ejemplaresVendidos; 
							minimo(vDetalles,vRegDet,rMin);  
						end; {fin del semanario actual}; 
						buscarSemanarioEnMaestro (maestro,rMae,rDetActual.codigoSemanario); 
						{si no hay ejemplares para vender, no se realiza las ventas (no se actualiza el maestro) tampoco se chequea el min y max dia ejemplares vendidos}	
						if (ventasNoSuperaStock(totalVendidos,rMae.totalVendidos,rMae.totalEjemplares)) then begin
								actualizarMaestro_yMaxMin (maestro,rMae,totalVendidos,rMinVentas,rMaxVentas,rDetActual); 
						end; {end del if}
				end; {fin de la fecha actual}
		end; {fin del archivo detalle}
	cerrarDetalles(vDetalles); 
	close(maestro); 
end; 

procedure mostrarMaestro (var maestro : archivoMaestro); 
var
	rMae : rMaestro; 
begin
	assign(maestro,'maestro');
	reset(maestro); 
	while (not eof (maestro) ) do 
		begin
			read(maestro,rMae); 
			writeln ('Fecha: ',rMae.fecha, ' Codigo semanario: ',rMae.codigoSemanario);
			writeln( ' Total de ejemplares: ',rMae.totalEjemplares, ' ==> Total vendidos: ',rMae.totalVendidos );  
		end; 
	close(maestro); 
end; 

var
	maestro : archivoMaestro; 
	vDetalles : vecDetalles;  
begin
	// cargarMaestro(); // se dispone
	//cargarDetalle(); //se dispone
	actualizarMaestro(maestro,vDetalles);  
	mostrarMaestro (maestro); 
end.


{ PROCESO PARA CARGAR EL MAESTRO
procedure cargarMaestro (var maestro : archivoMaestro); 
var
	rMae : rMaestro; 
	archivoTxt : Text; 
begin
	assign(archivoTxt,'cargaMaestro.txt'); 
	reset(archivoTxt); 
	assign(maestro,'maestro'); 
	rewrite (maestro); 
	while (not eof (archivoTxt) ) do 	
		begin
			readln(archivoTxt,rMae.codigoSemanario,rMae.fecha); 
			readln(archivoTxt,rMae.nombreSemanario); 
			readln(archivoTxt,rMae.descripcion); 
			readln (archivoTxt,rMae.precio, rMae.totalEjemplares,rMae.totalVendidos); 
			write(maestro,rMae); 
		end; 
	close(maestro); 
	close(archivoTxt);
end;
* 
* 	PROCESO PARA CARGAR EL DETALLE
* 
* procedure cargarDetalle (var det : archivoDetalle); 
var 
	archivoTxt : Text; 
	rDet : rDetalle; 
begin
	assign(det,'detalle2'); 
	rewrite (det); 
	assign(archivoTxt,'cargaDetalle2.txt'); 
	reset(archivoTxt); 
	while (not eof(archivoTxt) ) do 
		begin
	readln(archivoTxt,rDet.fecha); 
	readln(archivoTxt,rDet.codigoSemanario,rDet.ejemplaresVendidos);
		write (det,rDet); 
	end; 
	close(det); 
	close(archivoTxt); 
end; 
* }

{}
