{consultar este ejercicio}
{consultar si la baja y la compactacion sobre el mismo archivo estan bien planteadas}

{Que pasa si la ultima posicion esta marcada como borrada? 
* o si las ultimas 3 posiciones estan marcadas como borradas? 
* creo que eso lo arregle con la linea 111. consultar }
program eje7;
Uses Crt;
Const 
	valorAlto = 9999;
type 
	str15 = string[15];
	ave = record
		codigo : integer;
		nombre : str15; 
		familiaDeAve : str15;
		descripcion : string[40];
		zonaGeografica : str15;  
	end;
	
	archivoAves = file of ave;
	
	
	
	procedure leer(var arch : archivoAves; var a : ave); 
	begin
		if (not eof (arch)) then 
			read(arch,a)
		else a.codigo := valorAlto; 
	end;
	{=======================================================================}
	{dice que se cuenta con el archivo, pero vamos a crearlo para ver si funciona todo bien}
	procedure leerAve (var a : ave);
	begin
		write ('=> Ingrese el codigo de ave: '); readln (a.codigo);
		if (a.codigo>0) then {asi solo leemos aquellas aves validas. Y aparte lo usamos como condicion de corte}
			begin
				write('ingrese el nombre del ave: '); readln (a.nombre); 
				write('ingrese la familia de ave: '); readln (a.familiaDeAve); 
				write ('ingrese la descripcion: '); readln (a.descripcion); 
				write ('ingrese la zona geografica: '); readln (a.zonaGeografica); 
			end;
	end;
	
	procedure cargarArchivoAves(var arch : archivoAves); 
	var
		a : ave;
	begin
		assign(arch,'maestro'); 
		rewrite(arch);
		leerAve(a); 
		while (a.codigo>0) do 
			begin
				writeln; // salto de linea 
				write(arch,a);
				leerAve(a); 
			end;
		close(arch);
	end;
	{=======================================================================}
	{modulos para eliminar aves de forma logica en el archivo}
	{marcamos el codigo de ave que recibimos por parametro ( si existe )}
	procedure bajaLogica (var arch : archivoAves; codigoBorrar : integer); 
	var
		a : ave;
		encontre : boolean;
	begin
		encontre := false;
		reset(arch);
		leer(arch,a); 
		while ( (a.codigo <> valorAlto) and (not encontre) )  do 
			begin
				if (a.codigo = codigoBorrar) then begin
						a.codigo:= -1;
						seek(arch,filePos(arch)-1); 
						write(arch,a);
						encontre := true;
				end
				else leer(arch,a);			
			end;
		close(arch); 
	end; 
	{Nota: Las bajas deben finalizar al recibir el código 500000 || 
	*ese numero se va de rango con el dato integer. Lo voy a hacer con el 5000  }
	procedure realizarBajasLogicas(var arch : archivoAves); 
	var
		codigoBaja : integer;
	begin
		write ('Ingrese un codigo de ave para borrarla: '); readln (codigoBaja); 
		while (codigoBaja >0) do 
			begin
				bajaLogica(arch,codigoBaja); 
				write ('Ingrese un codigo de ave para borrarla: '); readln (codigoBaja); 
			end;
	end;
	{=======================================================================}
	{preguntar, es medio resbucado pero siempre queda el archivo perfecto,  sin aves marcadas para eliminar}
	procedure compactarArchivo (var arch : archivoAves); 
	var
		a : ave; 
		posBorrar : integer;
	begin
		reset(arch);
		leer(arch,a); 
		while (a.codigo<> valorAlto) do 
			begin
				if (a.codigo = -1) then 
					begin
						posBorrar:= filePos(arch)-1;
						seek(arch,fileSize(arch)-1);
						read(arch,a); 
						{si las ultimas posiciones estan marcadas,las borramos fisicamente, con el truncate}
						while (a.codigo = -1) do 
							begin
								seek(arch,fileSize(arch)-1);  {vamos a la ultima pos}
								truncate(arch); {cortamos el archivo en esa posicion}
								seek(arch,fileSize(arch)-1); {vamos a la nueva ultima posicion }
								read(arch,a);  
							end;
						{cuando salimos del while vamos a encontrar un registro valido para sobreescribir.}
						seek(arch,posBorrar); 
						write(arch,a); 
						{de esta linea hasta el seek, no entiendo bien porque tengo que hacerlo devuelta}
						{se que se vuelve a truncar otra vez la ultima posicion, 
						* y se posiciona en posBorrar para seguir procesando el resto de registros}
						seek(arch,fileSize(arch)-1); 
						truncate(arch); 
						seek(arch,posBorrar);
					end;			
				leer(arch,a);
			end;
		close(arch);
	end;
	
	procedure imprimirArchivo(var arch : archivoAves); 
	var
		a : ave;
	begin
		reset(arch);
		leer(arch,a);
		while (a.codigo<> valorAlto) do begin
			writeln ('=== Codigo: ',a.codigo, ' nombre: ',a.nombre, ' familia de ave: ',a.familiaDeAve); 
			//writeln('   Descripcion: ',a.descripcion, ' zona geografica: ',a.zonaGeografica );
			leer(arch,a);
		end;
		close(arch);
	end;
	{programa principal} 
	var
		archAves : archivoAves;
	begin
		TextColor(LightCyan); 
		cargarArchivoAves(archAves); 
		imprimirArchivo(archAves); 
		
		writeln;
		realizarBajasLogicas(archAves); 
		writeln ('==== ARCHIVO CON LAS BAJAS LOGICAS ===='); 
		imprimirArchivo(archAves);
		
		compactarArchivo(archAves); 
		writeln ('==== ARCHIVO COMPACTADO ===='); 
		imprimirArchivo(archAves);
	end.
	
