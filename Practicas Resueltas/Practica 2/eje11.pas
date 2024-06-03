program eje11; 
const 
	valorAlto = '9999'; 
type
	str4 = string[4]; 
	str2 = string[2]; 
	rAccesos = record
		anho : str4; 
		mes : str2; 
		dia : str2; 
		idUsuario : integer; 
		tiempoAcceso : integer;
	end; 
	
	archivoAccesos = file of rAccesos; 
	
procedure leer (var arch : archivoAccesos; var dato : rAccesos); 
begin
	if (not eof (arch)) then 
		read(arch,dato)
	else dato.anho:= valorAlto; 
end; 
	
procedure buscarAnho (var arch: archivoAccesos; var dato : rAccesos; anhoBuscado : str4; var cumple : boolean);  
begin
	leer(arch,dato); 
	while ( (dato.anho <> valorAlto) and (dato.anho <> anhoBuscado) ) do
		leer(arch,dato);
		if (dato.anho = anhoBuscado) then 
			cumple:= true 
end; 

procedure corteControl (var arch : archivoAccesos; dato : rAccesos);
var
	anhoAct : str4; 
	mesAct, diaAct: str2;
	usuarioAct : integer;
	totalDia, totalMes,totalAnho,totalUsuario : integer;
begin
	totalAnho:=0;
	anhoAct:= dato.anho;
	Writeln('====> Anho ',anhoAct); 
{no creo que sea necesario agregar la condicion de que sea dato.anho<> valorAlto}
	while (anhoAct = dato.anho )do 
		begin
			mesAct:= dato.mes;
			totalMes:=0;
			writeln ('===> Mes: ',mesAct); 
			{procesamos todo un mes del mismo anho}
			while ( (anhoAct = dato.anho) and (mesAct = dato.mes) ) do 
				begin
					totalDia:=0; 
					diaAct:=dato.dia; 
					writeln ('==> Dia: ',diaAct); 
					{procesamos todo un dia del mismo mes del anho}
					while ( (anhoAct = dato.anho) and (mesAct = dato.mes) and (diaAct = dato.dia)) do 
						begin
							usuarioAct:= dato.idUsuario; 
							totalUsuario:= 0;
							{procesamos los accesos de un usuario en especifico del mismo dia, en el mismo mes y anho}
								while ( (anhoAct = dato.anho) and (mesAct = dato.mes) and (diaAct = dato.dia) and (usuarioAct = dato.idUsuario) ) do 
									begin
										totalUsuario:= totalUsuario + dato.tiempoAcceso; 
										leer(arch,dato); 
									end;{fin del usuario actual}
								totalDia:= totalDia + totalUsuario; 
								writeln ('- idUsuario :',usuarioAct, ' tiempo total de acceso: ',totalUsuario); 
						end;{fin del dia actual}
							writeln ('==> El iempo total de acceso del dia: ',diaAct, ' del mes: ',mesAct, ' fue:',totalDia );
							totalMes:= totalMes + totalDia;
				end;{fin del mes actual}
					writeln ('===> Tiempo total de acceso del mes: ',mesAct, ' : ',totalMes); 
					totalAnho:= totalAnho + totalMes; 
					writeln; {salto de linea por mes}
		end; {se termino de procesar el anho}
		writeln ('====> Tiempo total de acceso del anho: ',totalAnho); 
end;

procedure generarInforme (var arch : archivoAccesos); 
var
		encontroAnho : boolean; 
		dato : rAccesos; 
		anhoBuscado : str4;
begin
	encontroAnho:= false; 
	assign(arch,'archivoAccesos'); 
	reset(arch); 
	
	Write ('Ingrese el anho que quisiera procesar: '); readln (anhoBuscado); 
	
	buscarAnho(arch,dato,anhoBuscado,encontroAnho); 
	if (encontroAnho) then begin
		corteControl(arch,dato)
		end
	else writeln ('anho no encontrado.');
	
	close(arch); 
end; 

var
	archAcces : archivoAccesos; 
begin
	//cargarArchAcces(archAcces); 
	generarInforme(archAcces); 
end.


{procedure cargarArchAcces (var archAcc : archivoAccesos); 
var
	archivoTxt : text; 
	dato : rAccesos;
begin
	assign(archivoTxt,'archivoCarga.txt'); 
	reset(archivoTxt); 
	assign(archAcc,'archivoAccesos');
	rewrite(archAcc); 
	while (not eof (archivoTxt)) do 
		begin
			readln(archivoTxt,dato.anho); 
			readln(archivoTxt,dato.mes); 
			readln(archivoTxt,dato.dia); 
			readln(archivoTxt,dato.idUsuario, dato.tiempoAcceso); 
			write (archAcc,dato); 
		end;
	close(archAcc); 
	close(archivoTxt);
end; }
