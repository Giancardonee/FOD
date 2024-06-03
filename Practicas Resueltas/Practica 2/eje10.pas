program eje10; 
const
	cantCategorias = 15; 
	valorAlto = 'zzz'; 
type
	rangoCategorias = 1..cantCategorias;
	str20 = string[20]; 
	rEmpleado = record
		departamento : str20;
		division : char; 
		numeroEmpleado : integer;
		categoria : rangoCategorias; 
		horasExtras : integer; 
	end;
	
	archivoEmpleados = file of rEmpleado; 
	valoresHsCategoria = array [rangoCategorias] of real; 
{=================================================}	
procedure cargarValoresHoras (var v : valoresHsCategoria); 
var
	archivoTxt : Text;
	i : integer;
	valorHora : real; 
begin
	assign(archivoTxt, 'valorHoraExtra_Categorias.txt'); 
	reset(archivoTxt); 
	for i:= 1 to cantCategorias do 
		begin
			readln(archivoTxt, valorHora); {leemos el precio de la hora}
			v[i]:= valorHora; {lo ingresamos en el vector}
		end; 
	close(archivoTxt); 
end; 
{=================================================}	
procedure leer (var archE : archivoEmpleados; var dato : rEmpleado); 
begin
	if (not eof(archE)) then 
		read(archE,dato)
	else dato.departamento := valorAlto;  
end; 

function calcularMontoEmpleado (hsTrabajadas : integer; precioHora : real): real; 
begin
	calcularMontoEmpleado:= (hsTrabajadas * precioHora); 
end; 

procedure procesarEmpleados (var archE : archivoEmpleados; vPrecioHora : valoresHsCategoria); 
var
	categoriaEmpleado : integer;
	totalHsEmpleado,totalHsDivision,totalHsDepartamento: integer; 
	montoEmpleado,montoDivision,montoDepartamento : real; 
	departamentoActual : str20; 
	divisionActual : char; 
	empleadoActual : integer; 
	dato : rEmpleado; 
begin
	assign(archE,'maestro'); 
	reset(archE); 
	leer(archE,dato); 
	{mientras no se termine el archivo}
	while (dato.departamento <> valorAlto) do 
		begin
			departamentoActual:= dato.departamento; 
			totalHsDepartamento:=0; 
			montoDepartamento:=0; 
			writeln ('======> Departamento ',departamentoActual);
			{procesamos todo el departamento actual}
			while (departamentoActual = dato.departamento) do
				begin
					divisionActual:= dato.division; 
					totalHsDivision:=0; 
					montoDivision:=0; 
					writeln('===>  Division: ',divisionActual ); 
						{procesamos toda la division del departamento actual}
						while( (departamentoActual = dato.departamento)and (divisionActual = dato.division) ) do 
							begin
								empleadoActual:= dato.numeroEmpleado; 
								montoEmpleado:=0; 
								totalHsEmpleado:=0;
								categoriaEmpleado:= dato.categoria;  
								{procesamos todos los empleados, de una misma division del departamento actual}
								while (( departamentoActual = dato.departamento)  and (divisionActual = dato.division)
								 and (empleadoActual = dato.numeroEmpleado)) do 
									begin
										totalHsEmpleado:= totalHsEmpleado + dato.horasExtras;
										leer(archE,dato); 
									end; {fin del empleado actual}
								montoEmpleado:= calcularMontoEmpleado(totalHsEmpleado,vPrecioHora[categoriaEmpleado]); 
								Writeln('-- Empleado: ',empleadoActual, ' Total Hs: ',totalHsEmpleado, ' Importe a cobrar: ',montoEmpleado:2:2 );
								montoDivision:= montoDivision + montoEmpleado; 
								totalHsDivision:= totalHsDivision + totalHsEmpleado; 
							end;{fin de la division actual}
					writeln ('Total de horas de la division: ',totalHsDivision); 
					writeln ('Monto total por division: ',montoDivision:2:2); 
					totalHsDepartamento:=totalHsDepartamento + totalHsDivision; 		
					montoDepartamento:= montoDepartamento + montoDivision; 
				end; {fin del departamento actual}
			writeln ('Total de horas del departamento: ',totalHsDepartamento); 
			writeln ('Monto total del departamento: ',montoDepartamento:2:2);
		end; {fin del archivo}
	close(archE); 
end; 

var
	vecValorCategoria : valoresHsCategoria;
	archEmpleados : archivoEmpleados; 
begin
	//cargarArchEmpleados(archEmpleados); {se dispone}
	cargarValoresHoras(vecValorCategoria);
	procesarEmpleados(archEmpleados,vecValorCategoria); 
end.


{procedure cargarArchEmpleados (var arch: archivoEmpleados); 
var
	archivoTxt : Text; 
	dato : rEmpleado;
begin
	assign (archivoTxt,'cargaArchivo.txt'); 
	reset(archivoTxt); 
	assign (arch,'maestro'); 
	rewrite(arch); 
	while (not eof (archivoTxt) ) do
		begin
			readln(archivoTxt,dato.departamento); 
			readln(archivoTxt,dato.division); 
			readln(archivoTxt,dato.numeroEmpleado, dato.categoria, dato.horasExtras ); 
			write(arch,dato); 
		end; 
	close(arch); 
	close(archivoTxt); 
end;}
