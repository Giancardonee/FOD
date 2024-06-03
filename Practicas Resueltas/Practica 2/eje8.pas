program eje8;
const 
	valorAlto = 9999;
type
	str30 = string[30]; 
	cliente = record
		codigo : integer;
		nombreYapellido: str30
	end;
	
	rMaestro = record
		cli : cliente;
		anho : integer;
		mes : 1..12;
		dia : 1..31;
		montoVenta : real; 
	end;
	
	archivoMaestro = file of rMaestro; 

procedure leer (var m : archivoMaestro; var dato : rMaestro); 
begin
	if (not eof (m)) then 
		read(m,dato)
	else
		dato.cli.codigo:= valorAlto;
end;


procedure procesarMaestro (var maestro : archivoMaestro); 
var
	clienteActual,anhoAct,mesAct : integer;
	dato : rMaestro;
	totalEmpresa,totalAnho,totalMensual: real; 
begin
	assign(maestro,'maestro');
	reset(maestro); 
	leer(maestro,dato); 
	totalEmpresa:=0;
	{el dato.cli.codigo <> 0 no tendria que estar como condicion. pasa que cargue
	* el archivo maestro por error con un codigo 0 que lo proceso, asique es para que evite eso jeje}
	while ( (dato.cli.codigo<>valorAlto) and (dato.cli.codigo <> 0))  do 
		begin
			clienteActual:= dato.cli.codigo;
			writeln ('|| codigo de cliente: ',dato.cli.codigo, ' nombre y apellido: ',dato.cli.nombreYapellido ); 
			while (dato.cli.codigo = clienteActual ) do 
				begin
				anhoAct:= dato.anho;
				totalAnho:=0;
				while ( (clienteActual = dato.cli.codigo) and (dato.anho = anhoAct ) ) do 
					begin
						mesAct:= dato.mes; 
						totalMensual:=0;
						while  ((dato.cli.codigo = clienteActual ) and (dato.anho = anhoAct ) and (dato.mes = mesAct ) )do 
							begin
								totalMensual:= totalMensual + dato.montoVenta; 
								leer(maestro,dato); 
							end;{fin del mes actual}
							writeln ('==> Total mensual del mes ',dato.mes, ' es: ',totalMensual:2:2); 
							totalAnho:= totalAnho + totalMensual;
					end;{fin del anho actual}
					writeln ('==> Total anual del anho ',dato.anho, ' es: ',totalAnho:2:2); 
					totalEmpresa:= totalEmpresa + totalAnho; 
					writeln; 
				end; {fin del cliente actual}
		end;
		writeln('-------- El monto total de ventas obtenidas de la empresa es:  $',totalEmpresa:2:2); 
		close(maestro);
end;

procedure imprimirMaestro(var maestro : archivoMaestro);
var
	dato : rMaestro;
begin
	assign(maestro,'maestro');
	reset(maestro);
	while (not eof (maestro)) do 
		begin
			read(maestro,dato); 
			writeln ('Codigo: ',dato.cli.codigo, ' nombre: ',dato.cli.nombreYapellido, ' dia, mes,anho: '
			,dato.dia, '/',dato.mes, '/',dato.anho, ' monto venta: ',dato.montoVenta:2:2   );
			
			writeln ('------------------------');  
		end;
	close(maestro);
end;

{programa principal}
var
	maestro : archivoMaestro; 
begin
	procesarMaestro(maestro);
end.

//cargarMaestro(maestro); 
{procedure leerCliente (var dato : rMaestro); 
begin
	write ('Ingrese el codigo de cliente: '); readln (dato.cli.codigo); 
	if (dato.cli.codigo<>0) then 
		begin
			write ('Ingrese el nombre: '); readln (dato.cli.nombreYapellido); 
			write ('Ingrese el dia,mes anho: '); readln  (dato.dia); readln (dato.mes) ; readln (dato.anho); 
			write ('Ingrese el precio: '); readln (dato.montoVenta);
		end;
end; 

procedure cargarMaestro (var m : archivoMaestro);
var 
	dato : rMaestro; 
begin
	assign(m,'maestro');
	rewrite(m); 
	leerCliente(dato);
	while (dato.cli.codigo <> 0) do 
		begin
			leerCliente(dato);
			write(m,dato); 
		end;
	close(m); 
end;}
