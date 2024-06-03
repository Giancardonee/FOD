{creo que este ejercicio tiene varias formas de plantearse. Podria ir escalando cada vez mas. 
*Al leer esto: 
* Diariamente el servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a. Realice el procedimiento necesario para actualizar la información del log en un
día particular 
* 
* Al decir que diariamente el servidor genera un archivo (me hizo pensar en n archivos, 1 archivo por dia) con  emisor,receptor, y mensaje.C ada archivo representa los movimientos
*  del dia, me hizo pensar en un vector de 1 a 31 (cantDias), donde cada dia (posicion del vector) tenga un archivo detalle con esos movimientos del dia. 
* 
* Pero esto puede ir escalando cada vez mas. Es decir, se podria hacer por meses, por años. 
* 
* En este caso, lo plantee como si si se trataria de un mes (no importa el mes), sino lo importante  es que podamos acceder
* a los movimientos de un dia en particular en ese mes.
* 
* Para resolver esto, como dije antes. Tendre un vector de archivos, el vector iria de 1..cantDias y en cada dia (cada posicion) tendre un archivo detalle 
* De esta manera, podria actualizar un archivo maestro con cualquier archivo detalle de un dia del mes. 
* }

program eje12;
const
	valorAlto = 9999;
	cantDias = 31; 
type
	str20 = string[20];
	
	rMaestro = record
		nroUsuario : integer;
		nombreUsuario: str20; 
		nombre : str20; 
		apellido : str20; 
		cantMailsEnviados : integer; 
	end;
	
	rDetalle = record
		nroUsuario : integer;
		cuentaDestino : str20; 
		cuerpoMensaje : string; 
	end;
	
	archivoMaestro = file of rMaestro; 
	archivoDetalle = file of rDetalle; 
	
	detalleMes = array [1..cantDias] of archivoDetalle;
	
procedure leerDetalle (var archD : archivoDetalle; var dato : rDetalle); 
begin
	if (not eof (archD) ) then 
		read(archD,dato)
	else dato.nroUsuario:= valorAlto;
end;

procedure abrirDiaCorrespondiente(var vMes : detalleMes; var dia : integer); 
var
	diaString : string; 
begin
	{se asume que se va a ingresar un dia valido (entre 1 y cantDias)}
	write ('Ingrese un dia del detalle para actualizar el maestro: ') ; readln (dia); 
	Str(dia,diaString); 
	assign(vMes[dia],'detalleDia'+diaString); 
	reset(vMes[dia]);
	; 
end; 

procedure actualizarMaestro (var  maestro : archivoMaestro; var vMes : detalleMes);
var
	archivoTxt : text;
	datoM : rMaestro; 
	datoD : rDetalle; 
	dia : integer;
	nroUsuarioActual : integer;
	cantCorreos : integer;
begin
	assign (archivoTxt, 'DetalleTxtDiaDeterminado.txt'); 
	rewrite(archivoTxt); 
	assign(maestro,'maestro'); 
	reset(maestro); 
	abrirDiaCorrespondiente(vMes,dia); 
	read(maestro,datoM); 
	leerDetalle(vMes[dia],datoD); 
	while (datoD.nroUsuario <> valorAlto) do 
		begin
			nroUsuarioActual:= datoD.nroUsuario;
			cantCorreos:=0; 
			{contamos todos los mails de ese usuario,}
			while (nroUsuarioActual = datoD.nroUsuario) do 
				begin
					cantCorreos:= cantCorreos + 1; 
					leerDetalle(vMes[dia],datoD); 
				end;
			{lo exportamos al txt. Punto b, inciso ii}
			writeln (archivoTxt,'Nro Usuario: ',nroUsuarioActual, ' Cantidad de mensajes: ',cantCorreos ); 
			{buscamos al nroUsuarioActual en el maestro, para poder actualizarlo}
			while (datoM.nroUsuario <> nroUsuarioActual) do
					read(maestro,datoM); 
			{actualizamos el registro para luego poder escribirlo actualizado}
			datoM.cantMailsEnviados:= datoM.cantMailsEnviados + cantCorreos; 
			seek(maestro,filePos(maestro)-1); 
			write(maestro,datoM);
			if (not eof (maestro)) then read(maestro,datoM); 
		end;
	close(maestro); 
	close(archivoTxt);
	close(vMes[dia]);
end;

var
	maestro : archivoMaestro;
	vecMes : detalleMes; 
begin
	//cargarMaestro {se dispone}
	// cargar detalle {se dispone}
	actualizarMaestro(maestro,vecMes); 
end.

