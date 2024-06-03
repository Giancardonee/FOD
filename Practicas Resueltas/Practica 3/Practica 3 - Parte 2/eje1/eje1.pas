{para el inciso a)  hay dos formas de hacerlo, como los archivos estan desordenados podemos: 
* opcion 1: Leer UN SOLO registro en el DETALLE, buscarlo en el MAESTRO y actualizar.
* Luego seguimos avanzando en el detalle, pero seguimos de la misma manera: Leemos un registro detalle ,Actualizamos maestro
* 
* opcion 2: Leer un registro del MAESTRO , y recorrer todo el DETALLE en busca de las ocurrencias de ese registro. 
* (tener en cuenta que puede existir 0, 1 o mas registros del maestro en el detalle. ) 
* Si no hay ninguna ocurrencia en el detalle, basicamente lo recorrimos alpedo. 
*
* 
* Las dos formas son ineficientes, porque se esta trabajando con archivos desordenados. 
* 
* }

{inciso a)
* Conclusion: Manejar archivos desordenados es recontra ineficiente. Lo ideal es usar indices para ver al archivo ordenado
* aunque no este ordenado, o mantener el archivo ordenado, aunque ordenar el archivo es costoso.
* 
* inciso b) 
* 	El cambio que realizaria, si se que cada registro del maestro puede ser actualizado por 0 o 1 detalle, teniendo en cuenta
* que ambos archivos estan desordenados. Podemos buscar el registro en el detalle, y despues buscarlo en el maestro.
* De esta manera nos aseguramos que los registros que esten en el detalle se actualizan. Ya que si buscamos primero en el maestro
* no nos aseguramos 100% que se encuentre el registro en el detalle. 
* 
* Ahora, si en el detalle puede haber mas de 1 registro,  me quedaria con alguna opcion explicada en el inciso a) .
* }

program eje1; 
Uses Crt; 
Const
	valorAlto = 9999; 
Type
	{para archivo maestro}
	producto = record
		codigo : integer;
		nombre : string[20]; 
		precio : real; 
		stockActual : integer;
		stockMinimo : integer; 
	end; 
	{para archivo detalle}
	ventaProducto  = record
		codigo : integer; 
		unidadesVendidas : integer;
	end; 
	
	archivoMaestro = file of producto; 
	archivoDetalle = file of ventaProducto; 
	{============================================}
	procedure leerMaestro (var mae : archivoMaestro; var rMae : producto); 
	begin
		if (not eof (mae)) then 
			read (mae,rMae)
		else rMae.codigo:= valorAlto;
	end;
	{============================================}
	{cargamos el archivo de productos}
	procedure leerProducto (var p : producto); 
	begin
		write ('Ingrese el codigo del producto: '); readln (p.codigo); 
		if (p.codigo >0) then begin
			//write ('Ingrese el nombre del producto: '); readln (p.nombre); 
			//write ('Ingrese el precio del producto: '); readln (p.precio); 
			write ('Ingrese el stock actual: '); readln (p.stockActual); 
			//write ('Ingrese el stock minimo: '); readln (p.stockMinimo); 
		end
	end;  
	procedure cargarArchivoMaestro (var mae : archivoMaestro); 
	var
		p : producto; 
	begin
		writeln ('======== Cargando archivo maestro. ');
		assign(mae,'maestro'); 
		rewrite(mae); 
		leerProducto(p); 
		while (p.codigo >0) do begin
			write(mae,p);
			leerProducto(p); 
		end; 
		close(mae); 
	end; 
	procedure imprimirMaestro (var mae : archivoMaestro); 
	var
		rMae : producto;
	begin
		writeln ('============= Datos del archivo maestro: ');
		reset(mae); 
		leerMaestro(mae,rMae); 
		while (rMae.codigo <> valorAlto) do begin
			writeln ('||| => Codigo producto: ',rMae.codigo, ' stock actual: ',rMae.stockActual); 
			leerMaestro(mae,rMae); 
		end;
		writeln; 
		close(mae); 
	end;
	{============================================}
	{cargamos el archivo detalle}
	procedure leerVenta (var v : ventaProducto); 
	begin
		write ('Ingrese el codigo de producto: '); readln (v.codigo); 
		if (v.codigo > 0) then  begin
			write ('Ingrese las unidades vendidas: '); readln (v.unidadesVendidas); 
		end;
	end;
	procedure cargarArchivoDetalle (var det : archivoDetalle); 
	var
		v : ventaProducto;
	begin
		writeln ('======== Cargando archivo detalle. ');
		assign(det,'detalle'); 
		rewrite(det); 
		leerVenta(v); 
		while (v.codigo > 0) do begin
			write(det,v); 
			leerVenta(v);
		end;
		writeln; 
		close(det); 
	end;
	
	procedure imprimirDetalle (var det : archivoDetalle); 
	var
		rDet : ventaProducto;
	begin
		writeln ('============= Datos del archivo detalle: ');
		reset(det);
		while (not eof (det)) do begin
			read(det,rDet); 
			writeln('Codigo : ',rDet.codigo, ' Unidades vendidas: ',rDet.unidadesVendidas); 
		end;
		writeln; 
		close(det); 
	end;
	{============================================}
	{opcion 1: Leemos el detalle, buscamos en el maestro en el registro detalle y actualizamos. Esto lo hacemos por cada registro del detalle
	* RECONTRA INEFICIENTE TRABAJAR CON ARCHIVOS DESORDENADOS, O SIN UNA ESTRUCTURA QUE PERMITA VER AL ARCHIVO ORDENADO}
	procedure actualizarArchivo (var mae : archivoMaestro ; var det : archivoDetalle); 
	var
		rMae : producto;
		rDet : ventaProducto; 
	begin
		writeln ('Un momento, estamos actualizando el stock....'); 
		reset(mae); reset (det); 
		while (not eof(det)) do begin
			read(det,rDet);  {tenemos el registro del detalle}
			read(mae,rMae); {como lo que esta en el detalle, esta si o si en el maestro, no controlamos mientras no sea eof}
			while (rDet.codigo <> rMae.codigo)  do {buscamos el registro en el maestro y lo actualizamos}
				read(mae,rMae); 
			rMae.stockActual:= rMae.stockActual - rDet.unidadesVendidas;
			seek(mae,filePos(mae)-1); 
			write (mae,rMae); 			{actualizamos el stock}
			seek(mae,0); 
		end;		
		close (mae); close (det); 
	end; 
	{prog principal}
	var
		maestro : archivoMaestro; 
		detalle : archivoDetalle; 
	begin
		Textcolor (LightCyan); 
		cargarArchivoMaestro(maestro);
		cargarArchivoDetalle(detalle); 

		imprimirMaestro(maestro);
		imprimirDetalle(detalle); 
		
		actualizarArchivo(maestro,detalle); 
		imprimirMaestro(maestro); 
	end.
{
* ============= Datos del archivo maestro:
||| => Codigo producto: 1 stock actual: 100
||| => Codigo producto: 2 stock actual: 100
||| => Codigo producto: 3 stock actual: 100

============= Datos del archivo detalle:
Codigo : 1 Unidades vendidas: 40
Codigo : 3 Unidades vendidas: 20
Codigo : 1 Unidades vendidas: 20
Codigo : 3 Unidades vendidas: 40
Codigo : 2 Unidades vendidas: 60

Un momento, estamos actualizando el stock....
============= Datos del archivo maestro:
||| => Codigo producto: 1 stock actual: 40
||| => Codigo producto: 2 stock actual: 40
||| => Codigo producto: 3 stock actual: 40
* }
