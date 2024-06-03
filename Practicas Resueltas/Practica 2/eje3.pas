program eje3; 
const 
	valorAlto = 9999; 
type
	producto = record
		codigo : integer;
		nombre : string[20]; 
		precio : real; 
		stockActual : integer;
		stockMin : integer;
	end;
	
	venta = record
		codigo : integer;
		cantVendida: integer;
	end;
	
	archivoProductos = file of producto; 
	archivoVentas = file of venta; 
{---------------------------------------------------------------------------------}
		{se disponen}	
//procedure cargarMaestro(var archM : archivoProducto);
//procedure cargarDetalle  (var archD : archivoProducto); 
{---------------------------------------------------------------------------------------------}
procedure leer (var archD : archivoVentas; var v : venta); 
begin
	if (not eof(archD)) then 
		read(archD,v)
	else
		v.codigo := valorAlto; 
end;
{---------------------------------------------------------------------------------}
 { inciso a }
 procedure actualizarMaestro (var archM : archivoProductos; var archD : archivoVentas); 
 var
	rVenta : venta; 
	codActual,unidadesVendidas : integer; 
	rProducto : producto;
 begin
	reset(archM); 
	reset(archD);
	read(archM,rProducto); 
	leer(archD,rVenta); 
	while (rVenta.codigo <> valorAlto) do 
		begin
			codActual:= rVenta.codigo;
			unidadesVendidas:=0; 
			{procesamos todas las ventas de ese codigo de producto.}
			while (codActual = rVenta.codigo) do 
				begin
					unidadesVendidas:= unidadesVendidas + rVenta.cantVendida; 
				     leer(archD,rVenta); 
				end;
			{buscamos en el maestro, el codigo de producto que se estuvo procesando}
			while (rProducto.codigo <> codActual) do 
				begin
					read(archM,rProducto); 
				end; 
			{cuando salga es porque se encontro el producto en el maestro}
			rProducto.stockActual:= rProducto.stockActual - unidadesVendidas; 
			seek(archM, filePos(archM)-1); 
			write(archM,rProducto); 
			if (not eof(archM) ) then read (archM,rProducto); 
		end;
	close(archM);
	close(archD);
 end;
 {---------------------------------------------------------------------------------}
	{inciso b}
 procedure exportarStockMenorAlMinimo (var archM : archivoProductos); 
 var
	archivoTxt : Text; 
	prod : producto; 
 begin
	assign(archivoTxt, 'stock_minimo'); 
	rewrite(archivoTxt); 
	reset(archM); 
	while (not eof(archM) ) do 
		begin
			read(archM,prod); 
			if (prod.stockActual < prod.stockMin) then begin 
				writeln(archivoTxt, 'Codigo de producto:  ',prod.codigo, ' Nombre comercial: ',prod.nombre, ' precio: ',prod.precio:2:2, 
				' Stock actual: ' ,prod.stockActual, ' Stock minimo: ',prod.stockMin);
			end; 
		end; 
	close(archivoTxt);
	close(archM);  
 end; 
 procedure menuGeneral (var archMaestro: archivoProductos; var archDetalle : archivoVentas); 
 var
	opcion : integer;
 begin
	repeat
		writeln ('Ingrese 1 si: Quiere actualizar el archivo maestro con las ventas realizadas en el dia.'); 
		writeln ('Ingrese 2 si: Quiere exportar un archivo de texto con aquellos productos con stockActual menor al stockMinimo.');
		writeln ('Ingrese 0 si: Quiere cerrar el programa.'); 
		write('==> Ingrese su opcion aca: '); readln (opcion); 
		case opcion of
			0: ; 
			1: actualizarMaestro(archMaestro,archDetalle); 
			2 : exportarStockMenorAlMinimo(archMaestro); 
			else writeln ('Se ingreso una opcion no valida.'); 
		end; 
	until (opcion = 0); 
 end; 
 {---------------------------------------------------------------------------------}
{programa principal}
var
	archMaestro : archivoProductos; 
	archDetalle : archivoVentas;
begin
	assign(archMaestro, 'maestro');
	assign (archDetalle, 'detalle'); 
	//cargarMaestro(archMaestro); 
	//cargarDetalle(archDetalle);
	menuGeneral(archMaestro,archDetalle); 
end.



{modulos para debugg. No se deben implementar en el programa porque ya la informacion se dispone :)  
procedure leerProducto (var p : producto); 
begin
	write('Codigo: '); readln (p.codigo); 
	if (p.codigo <> 0) then 
		begin
			p.nombre:= 'unNombreProducto';
			write('precio: '); readln (p.precio);
			write('Stock actual: '); readln (p.stockActual); 
			p.stockMin:= 4;  
		end; 
end; 
procedure cargarMaestro(var archM : archivoProductos); 
var
	prod : producto; 
begin
	rewrite(archM);
	leerProducto(prod); 
	while (prod.codigo <> 0) do 
		begin
			write(archM,prod); 
			leerProducto(prod); 
		end;
	close(archM); 
end; 
---------------------------------------------------------------------------------------------------------------
procedure cargarDetalle (var archD : archivoVentas); 
var 
	v : venta; 
begin
	rewrite(archD); 
	write('cod prod: '); readln (v.codigo); 
	if (v.codigo <> 0) then 
	write ('unidades vendidas: '); readln (v.cantVendida);
	while (v.codigo <> 0) do 
		begin
			write(archD,v); 
			write('cod prod: '); readln (v.codigo); 
			if (v.codigo <> 0) then 
			write ('unidades vendidas: '); readln (v.cantVendida);
		end; 
	close(archD); 
end; 
---------------------------------------------------------------------------------}


