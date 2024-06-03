{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}

program practicando; 
Uses crt;
Const 
	valorAlto = 9999;
type 
	producto = record
		codProducto : integer; 
		nombreComercial : string; 
		precioVenta : real; 
		stockActual : integer; 
		stockMinimo : integer
	end; 
	
	ventaProducto = record
		codProducto : integer;
		unidadesVendidas : integer;
	end; 
	
	archivoProductos = file of producto; 
	archivoVentaProductos = file of ventaProducto;
	
	{modulos para cargar el archivo detalle}
	 procedure leerVenta (var v : ventaProducto); 
	 begin
		write ('Ingrese el codigo de producto vendido: '); readln(v.codProducto); 
		if (v.codProducto > 0) then  begin
			write ('Ingrese la cantidad vendida:  '); readln (v.unidadesVendidas); 
			end;
	 end; 
	{modulos para cargar el archivo maestro}
	procedure leerProducto (var p : producto); 
	begin
		write ('Ingrese el codigo del producto: '); readln (p.codPRoducto); 
		if (p.codProducto > 0) then begin
			write ('Ingrese el nombre comercial: '); readln (p.nombreComercial); 
			p.precioVenta:= 100;  {todos los productos tendran el mismo precio}
			p.stockActual:= 100;  {todos los productos tendran el mismo stock actual}
			write ('Ingrese el stock minimo: '); readln (p.stockMinimo); 
		end; 
	end; 	 
	
	procedure cargarMaestro (var arch : archivoProductos); 
	var
		p : producto; 
	begin
		rewrite(arch); 
		writeln (' =======> Inicia la carga del archivo maestro');
		leerProducto(p); 
		while (p.codProducto > 0) do 
			begin
				write(arch,p); 
				leerProducto(p); 
			end; 
		writeln('Finaliza la carga del archivo maestro.'); 
		close(arch); 
	end; 
		
		procedure cargarDetalle (var arch : archivoVentaProductos); 
		var
			v : ventaProducto; 
		begin
			rewrite (arch);
			writeln (' =======> Inicia la carga del archivo detalle');
			leerVenta(v); 
			while (v.codProducto > 0) do 
				begin
					write (arch,v); 
					leerVenta(v); 
				end; 
			writeln('Finaliza la carga del archivo detalle.'); 
			close(arch); 
		end; 
	
	procedure leerDetalle (var det : archivoVentaProductos; var v : ventaProducto); 
	begin
		if (not eof (det)) then 
			read(det,v)
		else v.codProducto:= valorAlto; 
	end; 
	
	function stockActualMenorAlMinimo (stockActual : integer; stockMinimo : integer) : boolean; 
	begin
		stockActualMenorAlMinimo:= stockActual < stockMinimo; 
	end; 
	
	procedure actualizarMaestro (var m : archivoProductos; var d : archivoVentaProductos);
	var
		rMae : producto; 
		rDet : ventaProducto; 
		productoActual,unidadesVendidas : integer;		
		archivoTxt : Text; 
	begin
		assign(archivoTxt,'StockMenorAlMinimo.txt');
		rewrite(archivoTxt);
		reset(m); 
		reset(d); 
		read(m,rMae);
		leerDetalle(d,rDet); 
		while (rDet.codProducto <> valorAlto) do 
			begin
				productoActual:= rDet.codProducto;
				unidadesVendidas:= 0; 
				while (productoActual = rDet.codProducto) do 
					begin
						unidadesVendidas:= unidadesVendidas + rDet.unidadesVendidas; 
						leerDetalle(d,rDet);
					end; 
					{buscamos el maestro que coincida con el detalle}
					while (rMae.codProducto <> productoActual) do 
						read(m,rMae); 
					{conseguimos el registro del producto que veniamos procesando, ahora tenemos que actualizarlo}
					rMae.stockActual:= rMae.stockActual - unidadesVendidas; 
					seek(m,filepos(m)-1); 
					write(m,rMae); 
					{inciso b: Listar en un txt aquellos productos con stock actual menor al stock minimo}
					if (stockActualMenorAlMinimo(rMae.stockActual,rMae.stockMinimo)) then 
						writeln(archivoTxt,'codigo de producto: ',rMae.codProducto, 'Stock actual: ',rMae.stockActual, ' Stock minimo: ',rMae.stockMinimo ); 
			end; 
		close(m);
		close(d); 
		close(archivoTxt); 
	end; 
	
	{programa principal}
	var
		detalle : archivoVentaProductos; 
		maestro : archivoProductos; 
	begin
		TextColor (lightcyan); 
		assign (detalle,'archivoDetalle'); 
		assign (maestro,'archivoMaestro'); 
		cargarMaestro(maestro); 
		cargarDetalle(detalle); 
		actualizarMaestro(maestro,detalle); 
	end.
	
