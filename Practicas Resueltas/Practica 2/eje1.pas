program eje1; 
Const 
	valorAlto = 9999; 
type
		empleado = record
			codigo : integer; 
			nombre : string[20]; 
			montoComision : real; 
		end; 
		archivoEmpleados = file of empleado;
procedure leer(var detalle : archivoEmpleados; var e : empleado); 
begin
	if ( not eof(detalle) ) then
		read(detalle,e)
	else
		e.codigo:= valorAlto; 
end; 

{eLectura Corresponde al registro para leer en el detalle. 
* eActual Corresponde al empleado que se va a escribir en el maestro.
* En el registro eActual se va almacenando la informacion del empleado a escribir.}
procedure generarMaestro (var detalle : archivoEmpleados; var maestro : archivoEmpleados); 
var
	eLectura, eActual : empleado;
	montoComision : real;   
begin
	reset (detalle) ; 
	rewrite(maestro);
	leer(detalle,eLectura); 
	while ( (eLectura.codigo <> valorAlto) ) do 
		begin
			eActual:= eLectura; // nos guardamos el empleado actual
			montoComision:= 0;   // inicializamos el monto de la comision en 0
			while   ( (eLectura.codigo = eActual.codigo) )  do 
				begin
					montoComision:= montoComision + eLectura.montoComision; 
					leer(detalle,eLectura); 
				end; 
			eActual.montoComision:= montoComision; 
			write(maestro,eActual); 
		end; 
	close(detalle); 
	close(maestro);  
end; 
var
	detalle, maestro : archivoEmpleados; 
begin
	assign(detalle, 'archDetalle'); 
	assign(maestro,'archMaestro'); 
	// cargarDetalle(detalle);  ==> Se dispone la informacion
	generarMaestro(detalle,maestro); 
end. 
