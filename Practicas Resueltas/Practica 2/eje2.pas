{Medio raro el enunciado este. Asumo que el archivo maestro se dispone con: 
* codigoAlumno, nombre, apellido cursadasAprobadas, finalesAprobados. 
* 
* Archivo detalle: Se dispone codigo de alumno y informacion si aprobo la cursada o el final
* puede haber mas de 1 registros por cada alumno en el archivo detalle. Debemos aprovechar
* que ambos archivos estan ordenados por codigo de alumno y recorrerlo y procesarlo por ese criterio.}

{entonces, por lo que entendi, se dispone el archivo maestro y el archivo detalle, pero tengo que actualizar
* la cantidad de cursadas o finales aprobados en el archivo maestro a traves del detalle. }
program eje2; 
Const 
	valorAlto = 9999; 
type
	str20 = string[20]; 
	rMaestro = record {rMaestro ==> registro maestro}
		codigoAlumno: integer; 
		apellido : str20;
		nombre : str20;  
		cursadasAprobadas : integer; 
		finalesAprobados : integer; 
	end; 
	archivoMaestro = file of rMaestro; 

	rDetalle = record {rDetalle ==> registro detalle}
		codigoAlumno : integer; 
		aproboFinal : boolean; {true: incremento finalesAprobados, false: incremento cursadas aprobadas}
	end; 
	archivoDetalle = file of rDetalle; 

{----------------------------------------------------------------------------------------------}	
{--------------- procedimientos ---------------------}	
{En algun momento cargaron el detalle y el maestro.  Solo tengo que actualizar el maestro}
//procedure cargarDetalle(var archD : archivoDetalle); {------> se dispone}
//procedure cargarMaestro (var archM : archivoMaestro); 	{------------> se dispone}
{----------------------------------------------------------------------------------------------}
procedure leer (var archD : archivoDetalle; var rDet : rDetalle); 
begin
	if (not eof(archD)) then read(archD,rDet)
	else rDet.codigoAlumno := valorAlto
end; 

{modulos para hacer los incisos que nos piden: }

{-----------------------------------------------------------------------------------------------------------------------------------------------------------------------}
{modulos para el inciso a)}

{esto lo hago asi, porque en el detalle, se tiene si aprobo el final o la cursada.
*  Si estaria la opcion de que desaprobó la cursada, lo encararia diferente}
procedure procesarAprobado (var cursadasAprobadas,finalesAprobados : integer; aproboFinal : boolean); 
begin
	if (aproboFinal) then 
		begin
			finalesAprobados:= finalesAprobados +1;
			cursadasAprobadas:= cursadasAprobadas -1; 
		end
		{si no aprobo el final aprobo la cursada}
	else cursadasAprobadas:= cursadasAprobadas +1; 
end;  

procedure actualizarMaestro (var archM : archivoMaestro; var archD : archivoDetalle); 
var
	rDet: rDetalle; 
	rMae : rMaestro;
	alumnoActual : integer;
	finalesAprobados,cursadasAprobadas: integer;
begin
	reset(archD); 
	reset(archM); 
	read(archM,rMae); 
	leer(archD,rDet);
	while (rDet.codigoAlumno <> valorAlto) do 
		begin
			
			finalesAprobados:=0; cursadasAprobadas:=0;
			alumnoActual:= rDet.codigoAlumno;
			{procesamos todos los registros del alumno actual} 
			while (alumnoActual = rDet.codigoAlumno) do 
				begin
					procesarAprobado(cursadasAprobadas,finalesAprobados,rDet.aproboFinal); 
					leer(archD,rDet); 
				end; 
				{buscamos el alumno actual en el archivo detalle}
				while (rMae.codigoAlumno <> alumnoActual) do 
					read(archM,rMae); 
				{sale del while porque encontró el alumno a actualizar}
				rMae.cursadasAprobadas:= rMae.cursadasAprobadas + cursadasAprobadas; 
				rMae.finalesAprobados:= rMae.finalesAprobados + finalesAprobados; 
				{volvemos al registro anterior donde se encontraba el alumno actual}
				seek(archM,filePos(archM)-1); 
				write(archM,rMae); 
				{se avanza en el maestro}
				if (not eof(archM)) then read (archM,rMae); 
		end; 
	close(archD); 
	close(archM); 
end; 
{-----------------------------------------------------------------------------------------------------------------------------------------------------------------------}
{modulo para inciso b}
procedure exportarTxtMasFinalesQueCursadas (var archMae : archivoMaestro); 
var
	rMae : rMaestro; 
	archivoTxt : Text; 
begin
	assign(archivoTxt,'AlumnosMasFinalesQueCursadas'); 
	rewrite (archivoTxt); 
	reset(archMae); 
	while (not eof (archMae) ) do 
		begin
			read (archMae,rMae); 
			if (rMae.finalesAprobados > rMae.cursadasAprobadas) then 
					writeln(archivoTxt, ' || CodAlumno: ',rMae.codigoAlumno, ' Nombre y apellido: ',
					rMae.nombre, ' ',rMae.Apellido, ' Cursadas Aprobadas: ',rMae.cursadasAprobadas, ' Finales Aprobados: ',rMae.finalesAprobados); 
		end; 
	close(archMae); 
	close (archivoTxt); 
end; 
{-----------------------------------------------------------------------------------------------------------------------------------------------------------------------}
procedure menuGeneral (var archDet : archivoDetalle;var archMae : archivoMaestro); 
var
	opcion : integer; 
begin
		repeat 
		writeln ('Opcion 1: Actualizar el archivo maestro. '); 
		writeln ('Opcion 2: Exportar a un archivo.txt aquellos alumnos que tengas mas finales aprobaos que cursadas aprobadas.'); 
		writeln ('Opcion 0: Cerrar programa. '); 
		write ('===> Ingrese su opcion aca: '); readln (opcion); 
		case opcion of 
			0 : ; 
			1 : actualizarMaestro(archMae,archDet); 
			2 : exportarTxtMasFinalesQueCursadas(archMae); 
			else writeln ('Opcion incorrecta paa.'); 
		end; 
	until (opcion = 0);
end; 
	
var
	archDet : archivoDetalle; 
	archMae : archivoMaestro; 
begin
	assign (archDet,'Detalle'); 
	assign (archMae,'Maestro');
	{se disponen la carga de los archivos}
	//cargarDetalle(archDet); 
	//cargarMaestro(archMae); 
	menuGeneral(archDet,archMae); 
end.
