program parcial; 
const 
    valorAlto = 9999;
type
    recordDinos = record
        codigo : integer;
        tipoDinosaurio : string[30]; 
        altura : real;
        pesoPromedio : real;
        descripcion : string[30]; 
        zonaGeografica : string[30]; 
    end;

    tArchDinos : file of recorDinos; 

procedure leer(var a : tArchDinos; reg : recordDinos);
begin
    if (not eof (a)) then 
        read(a,reg)
    else reg.codigo:= valorAlto;
end;

procedure agregarDinosaurios(var a : tArchDinos; registro : recordDinos);
var
    cabecera : recordDinos; 
begin
  reset(a); 
  leer(a,cabecera); {leo la cabecera}
  if (cabecera.codigo = 0) then { no hay espacio para reasiugnar, grego al final }
  begin
    seek(a,filePos(a)); 
    write(a,registro);
  end
  else begin
    seek(a,(cabecera.codigo)* -1); {voy a la posicion de la cabecera para reutilizar el espacio}
    read(a,cabecera);              {actualizo mi registro cabecera}
    seek(a,filePos(a)-1);        {vuelvo una pos atras para escribir el nuevo registro}
    write(a,registro);          {escribo el nuevo registro en el espacio a reutilizar}
    seek(a,0);                  {voy a la cabecera para actualizarla}
    write(a,cabecera);          {actualizo la cabecera en el archivo}
  end;
  close(a); 
end;

{eliminar mas de un elemento}
procedure eliminarDinosaurios (var a : tArchDinos);
var
    codigoEliminar : integer;
    rLectura,cabecera : recorDinos;
begin
    reset(a);
    write ('Ingrese el codigo a eliminar: '); 
        readln(codigoEliminar); 
    while (codigoEliminar <> -1) do 
    begin
        leer(a,cabecera);
        leer(a,reg);
        while ( (reg.codigo <> valorAlto) and (reg.codigo <> codigoEliminar) ) do 
            leer(a,reg);
         if (reg.codigo = codigoEliminar) then 
            begin
                seek(a,filePos(a)-1); {vuelvo a la posicion anterior}
                write(a,cabecera);    {escribo mi cabecera en la pos a borrar}
                cabecera.codigo := (filePos(a)-1) * -1; {me paso el indice a negativo}
                seek(a,0);
                write(a,cabecera); {actualizo la nueva cabecera}
                writeln('Se elimino correctamente.');
            end
        else writeln('El codigo no existe.');
        write ('Ingrese el codigo a eliminar: '); 
        readln(codigoEliminar); 
        seek(a,0);
    end;
    close(a);
end;

procedure listarDinosaurios (var a : tArchDinos); 
var
    rDino: recordDinos;
    archivoTxt : Text;
begin
  assign(archivoTxt,'archivoDinosauriosLocos.txt');
  rewrite(archivoTxt);
  reset(a)
  leer(a,rDino);
  while(rDino.codigo <> valorAlto) do 
    begin
        if (rDino.codigo > 0) then begin
          writeln(archivoTxt,'Dinosaurio: Codigo ',rDino.codigo, ' altura: ',rDino.altura, ' descripcion: ',rDino.descripcion); 
          writeln(archivoTxt,' Peso Promedio: ',rDino.pesoPromedio, ' tipo dinosaurio: ',rDino.tipoDinosaurio);
          writeln(archivoTxt, 'Zona geografica: ',rDino.zonaGeografica); 
        end;
        leer(a,rDino); 
    end;
  close(a);
  close(archivoTxt);
end;

{programa principal}
var
    archivoDino : tArchDinos;
    registroNuevo : recordDinos;;
begin
    assign(archivoDino,'archivo');
    // leerRegistro(registroNuevo);
    agregarDinosaurios(archivoDino,registroNuevo);
    eliminarDinosaurios(archivoDino); 
end.











{eliminar solo un elemento}
procedure eliminarDinosaurios (var a : tArchDinos);
var
    codigoEliminar : integer;
    rLectura,cabecera : recorDinos;
begin
    reset(a);
    leer(a,cabecera);
    write ('Ingrese el codigo a eliminar: '); 
    readln(codigoEliminar); 
    {busco si existe el codigo}
    while ( (reg.codigo <> valorAlto) and (reg.codigo <> codigoEliminar) ) do 
        leer(a,reg);
    if (reg.codigo = codigoEliminar) then 
    begin
        seek(a,filePos(a)-1); {vuelvo a la posicion anterior}
        write(a,cabecera);    {escribo mi cabecera en la pos a borrar}
        cabecera.codigo := (filePos(a)-1) * -1; {me paso el indice a negativo}
        seek(a,0);
        write(a,cabecera); {actualizo la nueva cabecera}
        writeln('Se elimino correctamente.');
    end
    else writeln('El codigo no existe.');
    close(a);
end;