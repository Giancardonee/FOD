program eje3; 
uses Crt; 
Const
	valorAlto = 9999; 
type
	novela = record
		codigo : integer;
		genero : string[15]; 
		nombre : string[20]; 
		duracion : real; // 2.5 = 2:30 hs 
		director : string[15]; 
		precio : real;
	end; 
	archivoNovelas = file of novela; 
	
// modulos para cargar,leer y imprimir el archivo
	procedure leer(var arch : archivoNovelas; var n : novela) ;
	begin
		if (not eof (arch)) then 
			read(arch,n)
		else n.codigo:= valorAlto; 	end; 
	procedure leerNovela (var n : novela); 
	begin
		write ('Ingrese el codigo de novela: '); readln (n.codigo); 
		if (n.codigo >0) then 
			begin
				write ('Ingrese el genero de la novela: '); readln (n.genero);
				write ('Ingrese el nombre de la novela: '); readln (n.nombre); 
				write ('Ingrese la duracion de la novela (Ejemplo 2.5 = 2hs y 30 min): '); readln (n.duracion); 
				write ('Ingrese el director de la novela: '); readln (n.director); 
				write ('Ingrese el precio de la novela: $'); readln (n.precio); 
				writeln('--------------------------------------'); 
			end; 
	end; 
	
	procedure cargarArchivo(var arch : archivoNovelas); 
	var
		n : novela; 
		nombreArchivo : string; 
	begin
		write ('=> Ingrese el nombre del archivo a generar: '); readln (nombreArchivo); 
		assign(arch,nombreArchivo); 
		rewrite(arch);
		{ --cargamos el registro cabecera--} 
		n.codigo:=0; 
		write(arch,n); 
		{-----------------------------------------------------------}
		leerNovela(n); 
		while (n.codigo >0) do 
			begin
				write(arch,n);
				leerNovela(n);
			end;
		close(arch); 
	end; 
	
	procedure imprimirArchivo (var arch : archivoNovelas); 
	var
		n : novela; 
	begin
		reset(arch); 
		seek(arch,1); 
		leer(arch,n);
		while (n.codigo <> valorAlto) do 
			begin
					writeln('--------------------------------------------------------'); 
					if (n.codigo >0) then begin
						writeln(' ==> Codigo de novela: ',n.codigo, ' Genero: ',n.genero, ' Nombre: ',n.nombre);
						 writeln ('Duracion: ',n.duracion:2:2, ' Director: ',n.director, ' Precio: $',n.precio:2:2);
					end
					else Writeln ('Espacio Libre.  Codigo de novela: ',n.codigo, ' Indice de archivo: ',filePos(arch)-1);  
					leer(arch,n); 
			end; 
			close(arch); 
	end; 
// modulos para mantener el archivo
//-- metodo para dar de alta una novela
	procedure darAltaNovela (var arch : archivoNovelas); 
	var
		pos: integer;
		cabecera,nuevaNovela : novela; 
	begin
		reset(arch); 
		leerNovela(nuevaNovela); 
		read(arch,cabecera); 
		if (cabecera.codigo = 0)  then begin {no hay espacio para reasignar. Agregamos al final}
			seek(arch,fileSize(arch)); 
			write(arch,nuevaNovela); 
		end
		else begin
			pos:= cabecera.codigo * -1; {nos traemos el indice positivo de la cabecera}
			seek(arch,pos); 					   {nos posicionamos en el ultimo registro borrado (espacio reasignable) }
			read(arch,cabecera); 			   {traemos la ultima novela borrada, ahora va a ser nuestra nueva cabecera}
			seek(arch,filePos(arch)-1);  {ponemos el puntero en la posicion anterior para escribir el nuevo registro}
			write(arch,nuevaNovela);     {agregamos la nueva novela en ese espacio que estaba libre para reasignarse}
			seek(arch,0); 						   {volvemos a la primer posicion, para actualizar la cabecera}
			write(arch,cabecera); 		   {actualizamos la cabecera}
		end;
		close(arch); 
	end;
//--- metodos para modificar novela
	procedure auxModificar (var arch : archivoNovelas; n : novela); 
	var
		opcion : integer;
	begin
	repeat 
		Writeln ('Ingrese 1  si quiere modificar el genero. ');
		Writeln ('Ingrese 2  si quiere modificar el nombre. ');
		Writeln ('Ingrese 3  si quiere modificar la duracion. ');
		Writeln ('Ingrese 4  si quiere modificar el director. ');
		Writeln ('Ingrese 5  si quiere modificar el precio. ');
		writeln ('Ingrese 0 si quiere dejar de modificar la novela.'); 
		write('Ingrese la opcion aca: '); readln (opcion); 
			case opcion of 
					0: ; 
					1 : begin 
							write('Ingrese el nuevo genero: '); readln (n.genero);
						end;
					2: begin
							write ('Ingrese el nuevo nombre: '); readln (n.nombre); 
						end; 	
					3: begin
							write ('Ingrese la nueva duracion: '); readln (n.duracion); 
						end; 
					4: begin
							write('Ingrese el nuevo director: '); readln (n.director); 
						end;
					5: begin
							write ('Ingrese el nuevo precio: '); readln (n.precio); 
						end;
					else writeln ('Se ingreso una opcion no valida.');
			end; {end del case} 
	until (opcion = 0);
		seek(arch,filePos(arch)-1);  {vuelvo el puntero a la novela a modificar}
		write(arch,n); 
	end; 
	procedure modificarNovela (var arch : archivoNovelas); 
	var
		codigoNovelaModificar : integer;
		n : novela; 
	begin
		reset(arch); 
		write ('Por favor, ingrese el codigo de la novela a modificar: '); readln (codigoNovelaModificar); 
		leer(arch,n); 
		while ( (n.codigo <> valorAlto) and (n.codigo <> codigoNovelaModificar) ) do
			leer(arch,n); 
		if (n.codigo = codigoNovelaModificar) then 
			auxModificar(arch,n)
		else writeln ('No se encontro la novela que quiere modificar.');  
		close(arch); 
	end; 
	// modulo para dar de baja
	procedure darBajaNovela(var arch : archivoNovelas); 
	var
		n,cabecera : novela; 
		codigoBaja,posBorrar : integer; 
	begin
		write('Ingrese el codigo de novela que quiera eiminar: '); readln (codigoBaja); 
		reset(arch); 
		read(arch,cabecera); 
		leer(arch,n); 
		while ( (n.codigo <>valorAlto) and (n.codigo <> codigoBaja) ) do 
			leer(arch,n);
		if (n.codigo = codigoBaja) then begin
			posBorrar:= filePos(arch)-1; {me guardo el indice para borrar}
			seek(arch,posBorrar); 			{me posiciono en esa posicion}
			write(arch,cabecera); 			{pongo el registro cabecera en la pos borrada}
			n.codigo:= posBorrar * -1;  	{actualizo la pos, volviendola negativa}
			seek(arch,0); 							{me posiciono en la cabecera para actualizar}
			write(arch,n);							{actualizo la cabecera}
			writeln('Se elimino la novela correctamente.'); 
		end
		else writeln('No se encontro un codigo de novela que coincida con el ingresado. '); 
		close(arch); 
	end; 
	//-- listamos las novelas a txt
	procedure listarNovelasTxt(var arch : archivoNovelas); 
	var
		n : novela; 
		archTxt : Text; 
	begin
		reset(arch); 
		assign(archTxt,'ListaNovelas.txt'); 
		rewrite(archTxt); 
		seek(arch,1);  {para que no nos cargue lo que este en la cabecera}
		leer(arch,n); 
		while (n.codigo <> valorAlto) do 
			begin
				writeln (archTxt,'-----------------------------------------------------');
				if (n.codigo >0) then begin 
					Writeln(archTxt, '===>  Codigo de novela: ',n.codigo, ' Nombre: ',n.nombre); 
					Writeln(archTxt,'==> Duracion:  ',n.duracion:2:2, ' Genero: ',n.genero); 
					Writeln(archTxt, '=> Precio: $',n.precio:2:2, ' Director: ',n.director); 
				end
				else 
					Writeln(archTxt, 'Espacio Reasignable. Codigo de novela: ',n.codigo, ' Indice en el archivo: ',filePos(arch)-1); 
				leer(arch,n); 
			end; 
		close(arch); 
		close(archTxt); 
	end;
	procedure mantenerArchivo(var arch : archivoNovelas); 
	var
		opcion : integer;
		nombreArchivo : string; 
	begin
		write ('Ingrese el nombre del archivo que quiera abrir: '); readln (nombreArchivo); 
		assign(arch,nombreArchivo); 
		repeat
			Writeln ('Ingrese 1 si quiere: Dar de alta una novela. '); 
			Writeln ('Ingrese 2 si quiere: Modificar los datos de una novela.'); 
			Writeln('Ingrese 3 si quiere: Eliminar una novela.');
			Writeln ('Ingrese 4 si quiere: Listar todas las novelas en un archivo.txt'); 
			Writeln('Ingrese 5 si quiere: Imprimir el archivo.'); 
			Writeln ('Ingrese 0 si quiere: Volver al menu principal.');  
			write ('Ingrese la opcion aca: '); readln (opcion); 
			case opcion of 
				0 : ; 
				1 : darAltaNovela(arch); 
				2: modificarNovela(arch); 
				3: darBajaNovela(arch); 
				4: listarNovelasTxt(arch); 
				5: imprimirArchivo(arch); 
				else writeln ('Se ingreso una opcion no valida.'); 
			end; 
			writeln('--------------------------------------------------------');  
		until ( opcion = 0)
	end;
// Modulos de menu
	procedure menuPrincipal (var arch: archivoNovelas); 
	var 
		opcion : integer; 
	begin
		repeat
			Writeln ('Ingrese 1 si desea: Crear el archivo y cargarlo con datos de teclado. '); 
			Writeln ('Ingrese 2 si desea: Abrir el archivo existente y permitir su mantenimiento.'); 
			Writeln ('Ingrese 0 si desea: Cerrar el programa.');
			write ('Ingrese su opcion aca: '); readln (opcion); 
			case opcion of
				0 : writeln ('Programa finalizado exitosamente..'); 
				1 : cargarArchivo(arch); 
				2 : mantenerArchivo(arch); 
				else writeln('Por favor, ingrese una opcion valida.');
			end;
		until ( opcion = 0 )
	end; 
	{programa principal}
	var
		arch : archivoNovelas;
	begin
		Textcolor(LightMagenta); 
		menuPrincipal(arch); 
	end.
	
