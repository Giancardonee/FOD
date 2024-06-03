{obviamente para poder probar este programa se debe cargar el archivo de accesos. No hice los modulos
* pero si lo quieren chequear pueden hacerlo. }

program parcial1; 
Const
	valorAlto = 9999;
type
	str4 = string[4]; 
	str2 = string[2]; 
	acceso = record
		anho : integer;  
		mes: integer; 
		dia : integer; 
		idUsuario : integer; 
		tiempoAcceso : real; 
	end;
	
	archivoAccesos = file of acceso; 
	
	procedure leerArchivo (var arch: archivoAccesos; var acc : acceso); 
	begin
		if (not eof(arch)) then 
			read(arch,acc)
		else acc.anho:= valorAlto; 
	end; 
	
	procedure procesarInforme (var arch: archivoAccesos; acc : acceso); 
	var
		anhoActual,diaActual,mesActual,usuarioActual : integer;
		tAccesoAnho,tAccesoMes,tAccesoDia,tAccesoUsuario : real;
	begin
		anhoActual:= acc.anho;
		tAccesoAnho:=0;
		while (acc.anho = anhoActual) do 
			begin
			mesActual:= acc.mes; 
			tAccesoMes:=0;
			while ( (acc.anho = anhoActual) and (acc.mes = mesActual)) do 
				begin
					diaActual:= acc.dia; 
					tAccesoDia:=0;
					while ( (acc.anho = anhoActual) and (acc.mes = mesActual) and (acc.dia = diaActual)) do 
					begin
						tAccesoUsuario:=0;
						usuarioActual:= acc.idUsuario; 
						while ( (acc.anho = anhoActual) and (acc.mes = mesActual) and (acc.dia = diaActual) and (acc.idUsuario = usuarioActual)) do
						begin
							tAccesoUsuario:= tAccesoUsuario + acc.tiempoAcceso;
							leerArchivo(arch,acc); 
						end; 
						writeln(usuarioActual, ' tiempo total de acceso en el dia ',diaActual, ' del mes ',mesActual, ':  ',tAccesoUsuario:2:2 ); 
						tAccesoDia:= tAccesoDia + tAccesoUsuario; 
					end;// fin del dia actual
					writeln('Tiempo total de acceso en el dia ',diaActual, ' del mes ',mesActual, ' : ',tAccesoDia:2:2 );
					tAccesoMes:= tAccesoMes+ tAccesoDia;
				end;// fin del mes actual
				writeln('Tiempo total de acceso del mes ',mesActual, ' : ',tAccesoMes:2:2 ); 
				tAccesoAnho:= tAccesoAnho + tAccesoMes;
			end;// fin del anho
			writeln ('Tiempo total de acceso del anho: ',tAccesoAnho:2:2); 
	end; 
	
	
	procedure informePantalla (var arch : archivoAccesos); 
	var
		anhoInforme :integer;
		acc : acceso; 
	begin
		write('Ingrese el anho para generar el informe por pantalla: '); 
		readln (anhoInforme); 
		reset(arch);
		
		{primero buscamos si existe el anho , tip:  sabemos que esta ordenado por año}
	    leerArchivo(arch,acc); 
	    while (acc.anho < anhoInforme) do 
			leerArchivo(arch,acc); 
		if (acc.anho = anhoInforme) then begin
			procesarInforme(arch,acc); 
		end
		else 
			writeln('anho no encontrado'); 	
			
		close(arch); 
	end; 
	
	var
		accesos : archivoAccesos; 
	begin
		assign (accesos,'archivoAccesos'); 
		informePantalla(accesos); 
	end.
	
