{este programa tiene los modulos del eje4 y eje5, en un menu, para poder testearlos.}

program eje4_y_5;
Uses Crt;
Const
	valorAlto = 9999;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;

//------------------------------------------------------------------
{modulos para testear}
procedure leer(var a : tArchFlores; var r : reg_flor); 
	begin
		if (not eof (a)) then 
			read(a,r)
		else
			r.codigo:= valorAlto;
end;

procedure leerFlor(var f : reg_flor);
begin
	
	write ('Ingrese el codigo de la flor a agregar: '); readln (f.codigo); 
	if (f.codigo >0) then begin
	write ('Ingrese el nombre de la flor a agregar: '); readln (f.nombre); 
	end;
end;
{=========================================================}
// ----- modulos que nos pide en el ejercicio ------ 
{ 4 a) Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descrita anteriormente}

{no se porque pide que le pasemos los parametros asi, es mas facil pasarle el registro flor}
//procedure agregarFlor (var a: tArchFlores ; nombre: string[45]; codigo:integer);
procedure agregarFlor (var a: tArchFlores ; rAgregar : reg_flor);
var
	cabecera : reg_flor;
	pos : integer;
begin
	reset(a); 
	
	{leemos el registro cabecera}
	leer(a,cabecera); 
	
	if (cabecera.codigo = 0) then begin {se agrega al final porque no hay espacio para reasignar.}
		seek(a,fileSize(a));
		write(a,rAgregar);
	end
	else begin
		pos:= cabecera.codigo * -1; {pos = indice donde voy a tener el espacio para reasignar el registro.}
		seek(a,pos); 						  {vamos a la posicion donde hay espacio para reasignar}
		read(a,cabecera);                 {leemos el registro actual (eliminado) para poder pasarlo a la cabecera}
		seek(a,pos); 						   {vamos una pos atras}
		write(a,rAgregar); 				   {agregamos el registro en el lugar reasignable}
		seek(a,0); 								   {vamos a la cabecera}
		write(a,cabecera);				   {escribimos el registro que estaba en la pos que reasignamos, en la cabecera}
	end;
	close(a);
end;

{4 b) Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}
{tengo entendido que nos pide listar en pantalla, y no en un txt}
procedure listarArchivo (var a : tArchFlores); 
var
	f : reg_flor;
begin
	reset(a);
	leer(a,f);
	while (f.codigo <> valorAlto) do 
		begin
			if (f.codigo > 0) then 
				writeln('=> Nombre de la flor: ',f.nombre, ' Codigo: ',f.codigo); 
			leer(a,f); 
		end;
	close(a); 
end;
{5) Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}
procedure eliminarFlor (var a: tArchFlores; codigo: integer);
var
	cabecera,rBusqueda : reg_flor;
	posBorrar: integer;
begin
	reset(a);
	{leemos el registro cabecera}
	leer(a,cabecera);
	leer(a,rBusqueda);
	while (( rBusqueda.codigo <> valorAlto) and (rBusqueda.codigo <> codigo)) do 
		leer(a,rBusqueda); 
	if (rBusqueda.codigo = codigo) then 
		begin
			posBorrar:= filePos(a)-1; {me guardo la posicion a eliminar}
			seek(a,posBorrar);            {pongo el puntero en esa posicion}
			write(a,cabecera); 				{escribo el registro cabecera en la posicion borrada}
			rBusqueda.codigo:= posBorrar * -1; {paso a negativo el indice de la ultima pos borrada}
			seek(a,0); 								{vamos a la cabecera}	
			write(a,rBusqueda);			{escribimos el nuevo registro cabecera actualizado}
			writeln('Se elimino correctamente la flor.');
		end
	else writeln ('No se encontro la flor a eliminar.');
	close(a);
end; 
{=========================================================}

{modulos adicionales para probar el programa}

procedure cargarArchivo (var arch : tArchFlores); 
var
	f : reg_flor;
	nombreArchivo : string; 
begin
	write ('Ingrese el nombre del archivo: '); readln (nombreArchivo); 
	assign(arch,nombreArchivo);
	
	rewrite(arch);
	{cargamos el registro cabecera: }
	f.codigo:= 0;
	write(arch,f);
	{-------------------------------------------------}
	leerFlor(f);
	while (f.codigo>0 ) do 
		begin
			write(arch,f);
			leerFlor(f);
		end;
		
	close(arch);
end;

procedure opcionAgregar (var a : tArchFlores);
var 
	f : reg_flor;
begin
	leerFlor(f);
	agregarFlor(a,f); 
end;

procedure opcionEliminar(var a : tArchFlores); 
var
	codigo : integer;
begin
	write ('Ingrese el codigo de flor a eliminar: '); readln (codigo); 
	eliminarFlor(a,codigo);
end; 


{este menu no lo pide, pero lo hago para ver si todo esta bien}
procedure menu (var a : tArchFlores);
var 
	opcion : integer;
begin
	repeat
		writeln ('==> Ingrese 1 si quiere agregar una flor.');
		writeln ('==> Ingrese 2 si quiere eliminar una flor.');
		writeln ('==> Ingrese 3 si quiere listar el archivo, omitiendo las flores eliminadas.');
		writeln ('==> Ingrese 0 para cerrar el programa.');
		write('Ingrese su opcion aca: ') ; readln (opcion);
		
		case opcion of 
			0 : ; 
			1 : opcionAgregar(a);
			2 : opcionEliminar(a);
			3: listarArchivo(a);
			else writeln('Se ingreso una opcion no valida.'); 
		end;
	until opcion = 0;
end;
{=========================================================}
var
	arch : tArchFlores;	
begin
	Textcolor(LightCyan);
	cargarArchivo(arch);
	menu(arch); 
end.
