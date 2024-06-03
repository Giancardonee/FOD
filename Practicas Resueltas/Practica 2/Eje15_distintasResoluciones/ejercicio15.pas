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

procedure leerDetalle (var det : archivoDetalle; var rDet : rDetalle); 
begin
    if (not eof (det) ) then 
        read(det,rDet)
    else rDet.fecha:= valorFechaAlto; 
end; 

procedure minimo (var vecDet : vecDetalles; var vecRegDet : vecRegDetalles; var min : rDetalle);
var
    i,posMin : integer;
begin
    min.fecha:= valorFechaAlto; 
    min.codigoSemanario:= valorAlto; 
    for i:= 1 to cantDetalles do 
        begin
            if  (vecRegDet[i].fecha < min.fecha) or ( (vecRegDet[i].fecha = min.fecha) and (vecRegDet[i].codigoSemanario < min.codigoSemanario) ) then 
                begin 
                    min:= vecRegDet[i]; 
                    posMin:= i;  
                end; 
        end; 
        if (min.fecha <> valorFechaAlto) then
            read(vecDet[posMin],vecRegDet[posMin]); 
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

    procedure inicializarRegistrosMinMaxVentas (var rMinVentas, rMaxVentas : rDetalle); 
    begin
        rMinVentas.fecha:= valorFechaAlto; 
        rMaxVentas.fecha:= valorFechaAlto; 
        rMinVentas.codigoSemanario:= valorAlto; 
        rMaxVentas.codigoSemanario:= valorAlto; 
        rMinVentas.ejemplaresVendidos:=9999;
        rMaxVentas.ejemplaresVendidos:=0;
    end; 

    procedure actualizarMaxMin(var rMin, rMax : rDetalle; dato : rDetalle); 
    begin
        if (dato.ejemplaresVendidos > rMax.ejemplaresVendidos) then 
            rMax:= dato; 
        if (dato.ejemplaresVendidos < rMin.ejemplaresVendidos) then 
            rMin:= dato; 
    end; 

    procedure actualizarMaestro (var maestro : archivoMaestro; var vecDet : vecDetalles; var rMin,rMax : rDetalle); 
    var
		rMae : rMaestro; 
        totalVendidosDetalle: integer;
        rActual,min : rDetalle; 
        vecRegDet : vecRegDetalles; 
    begin
        inicializarDetalles(vecDet,vecRegDet); 
        inicializarRegistrosMinMaxVentas(rMin,rMax); 
        assign(maestro,'maestro'); 
        reset(maestro); 
        minimo(vecDet,vecRegDet,min);                 
        while (min.fecha <> valorFechaAlto) do
          begin
            rActual.fecha := min.fecha; 
            {procesamos la fecha actual}
            while (rActual.fecha = min.fecha) do 
                begin
                    rActual.codigoSemanario := min.codigoSemanario; 
                    totalVendidosDetalle:=0; 
                    while ( (rActual.fecha = min.fecha) and (rActual.codigoSemanario = min.codigoSemanario)) do
                        begin
                          totalVendidosDetalle:= totalVendidosDetalle + min.ejemplaresVendidos; 
                          minimo(vecDet,vecRegDet,min); 
                        end; {fin del semanario de la fecha actual} 
                    {cuando salga es porque termine de leer las ventas del semanario o de la fecha actual}
                    {buscamos en el maestro, el registro que corresponda con fecha y seminario actual}
                    read(maestro,rMae); 
                    while ( ( rMae.fecha <> rActual.fecha) and ( rMae.codigoSemanario <> rActual.codigoSemanario)) do 
                        read(maestro,rMae); 
                    {si no se realizo ninguna venta por fuera del stock, se actualiza en el maestro y se calcula el maximo}
                    if (rMae.totalEjemplares >= (totalVendidosDetalle + rMae.totalVendidos) ) then 
                        begin 
                            rMae.totalVendidos:= rMae.totalVendidos + totalVendidosDetalle;
                            seek(maestro,filePos(maestro)-1); 
                            write(maestro,rMae); 
                            rActual.ejemplaresVendidos:= totalVendidosDetalle; 
                            {calculamos los maximos y los minimos}
                            actualizarMaxMin(rMin,rMax,rActual); 
                        end; {fin del if para actualizar el maestro}
                end; {fin de la fecha actual y el semanario actual}
          end;  {fin del registro}
        cerrarDetalles(vecDet); 
        close(maestro); 
    end;    

    var
        vecDet: vecDetalles; 
        maestro : archivoMaestro; 
        rMin,rMax : rDetalle; 
    begin
        actualizarMaestro(maestro,vecDet,rMin,rMax); 
        {rMin y rMax tienen la fecha y codigo semanario en el que se vendieron mas autos (rMax) y menos autos (rMin)}
    end.
