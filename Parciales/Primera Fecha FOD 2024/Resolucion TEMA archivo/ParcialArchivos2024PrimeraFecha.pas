


{Este parcial me lo tomaron en primer fecha. La parte de archivos la resolvi tal cual esta aca.}

{declare const, type y el modulo. No hice el main porque el enunciado no lo pedia.}
const   
    valorAlto = 9999;
type
    prestamo = record
        nroSucursal : integer;
        dniEmpleado : integer;
        nroPrestamo : integer;
        fecha : string; 
        monto : real;
    end;

    archivoPrestamos = file of prestamo;


// function extraerAnho (......): .....; Se dispone


    procedure Leer(var archivo : archivoPrestamos; var p : prestamo);
    begin
      if (not eof (archivo) ) then 
        read(archivo,p)
     else p.nroSucursal:= valorAlto;
    end;

    procedure GenerarInforme (var archivo : archivoPrestamos); 
    var
        archivoTxt : Text; 
        p : prestamo;
        tVEmpresa,tVSucursal,tVEmpleado,tVAnho,sucursalActual,empleadoActual,anhoActual : integer;
        tMontoEmpresa,tMontoSucursal,tMontoEmpleado,tMontoAnho : real;
    begin
        assign(archivo,'archivoDatos'); 
        assign(archivoTxt,'informe.txt');
        reset(archivo);
        rewrite(archivoTxt);
        tVEmpresa:=0; {total cantidad de ventas de empressa}
        tMontoEmpresa:=0;
        leer(archivo,p); 
        writeln(archivoTxt,'Informe de ventas de la empresa.');
        while (p.nroSucursal <> valorAlto) do 
        begin
          sucursalActual := p.nroSucursal;
          tMontoSucursal:=0; tVSucursal:=0;
          writeln(archivoTxt,'Sucursal: ',sucursalActual); 
          while (sucursalActual = p.nroSucursal) do 
            begin
              empleadoActual:= p.dniEmpleado;
              tVEmpleado:=0; tMontoEmpleado:=0; 
              writeln(archivoTxt,'Empleado: DNI ',empleadoActual);
              while ( (sucursalActual = p.nroSucursal) and (empleadoActual = p.dniEmpleado))do 
                begin
                    anhoActual:= extraerAnho(p.fecha);
                    tVAnho:=0;  tMontoAnho:=0;
                    while ( (sucursalActual = p.nroSucursal) and (empleadoActual = p.dniEmpleado) and (anhoActual = extraerAnho(p.fecha)))do 
                        begin
                          tVAnho:= tVAnho + 1; 
                          tMontoAnho:= tMontoAnho + p.monto;
                          leer(archivo,p);
                        end;// fin del año actual
                    writeln(archivoTxt,'Año: ',anhoActual, 'Cantidad de ventas: ',tVAnho, ' Monto venta: ',tMontoAnho);
                    tVEmpleado:= tVEmpleado + tVAnho; 
                    tMontoEmpleado:= tMontoEmpleado + tMontoAnho;
                end;// fin del empleado actual
                writeln(archivoTxt,'Totales:   Ventas: ',tVEmpleado, ' Monto: ',tMontoEmpleado);
                tVSucursal:= tVSucursal + tVEmpleado;
                tMontoSucursal:= tMontoSucursal + tMontoEmpleado;
            end;// fin de la sucursal actual
            writeln(archivoTxt,'Cantidad total de ventas sucursal: ',tVSucursal); 
            writeln(archivoTxt,'Monto total vendido por sucursal: ',tMontoSucursal);
            tMontoEmpresa:= tMontoEmpresa + tMontoSucursal;
            tVEmpresa:= tVEmpresa + tVSucursal;
        end;// fin del archivo
        writeln(archivoTxt,'Cantidad de ventas de la empresa: ',tVEmpresa);
        writeln(archivoTxt,'Monto total vendido por la empresa: ',tMontoEmpresa); 
        close(archivo);
        close(archivoTxt);
    end;// fin del procedure :) 
