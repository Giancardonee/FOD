{Este parcial esta muy bueno para hacerlo en pc.
En hoja se re pica jajaja. Es full corte de control con varios contadores}


{el archivo esta ordenado por : año , codigo de torneo y codigo de equipo}


program parcial2; 
Const 
    valorAlto = 9999;
Type
    partido = record
        codigoEquipo : integer;
        nombreEquipo : string;
        anho : integer;
        codigoTorneo : integer;
        codigoEquipoRival : integer;
        golesAFavor : integer;
        golesEnContra : integer;
        puntosObtenidos : integer;
    end;

    archivoPartidos = file of partido;

procedure leer(var archivo: archivoPartidos; var p : partido);
begin
  if (not eof (archivo)) then 
    read(archivo,p)
  else p.anho := valorAlto;
end;

{cantGF: cant goles a favor
cantGC: cant goles en contra
cantPG: cant partidos ganados
cantPP: cant partidos perdidos
cantPE: cant partidos empatados
cantPuntos: cant puntos ganados}

procedure inicializarContadores(var gf,gc,pg,pp,pe,cantPuntos : integer);
begin
  gf:=0; gc:=0; pg:=0; pp:=0; pe:=0; cantPuntos:=0;
end;

procedure actualizarContadores(var gf,gc,pg,pp,pe,cantPuntos : integer; var partidoACtual : partido);
begin
  gf:= gf + partidoACtual.golesAFavor; 
  gc:= gc + partidoACtual.golesEnContra;
  case partidoACtual.puntosObtenidos of 
    0 : pp:= pp + 1 ;
    1 : pe:= pe + 1 ;
    3 : pg:= pg + 1;
  end;
  cantPuntos:= cantPuntos + partidoACtual.puntosObtenidos;
end;

procedure informarDatosEquipoProcesado(var gf,gc,pg,pp,pe,cantPuntos: integer);
begin
   writeln('Cantidad total de goles a favor: ',gf); 
   WriteLn('Cantidad total de goles en contra: ',gc);
   WriteLn('Diferencia de goles: ',(gf-gc));
   WriteLn('Cantidad de partidos ganados : ',pg);
   WriteLn('Cantidad de partidos perdidos: ',pp);
   WriteLn('Cantidad de partidos empatados: ',pe);
   WriteLn('Cantidad total de puntos: ',cantPuntos);
end;

procedure calcularCampeonTorneo(cantPuntos: integer; var maxPuntos: integer; var nombreEquipoMax: string ;nombreEquipoActual : string);
begin
  if (cantPuntos > maxPuntos) then begin
    maxPuntos:= cantPuntos;
    nombreEquipoMax:= nombreEquipoActual;
  end;
end;

procedure informeEnPantalla (var archivo : archivoPartidos); 
var
    pActual : partido;
    cantGF,cantGC,cantPG,cantPP,cantPE,cantPuntos : integer;
    maxPuntos : integer;
    nombreEquipoMax,nombreEquipoActual: string;
    anhoActual,codigoTorneoActual,codigoEquipoActual: integer;
begin
      maxPuntos:= -1; 
      nombreEquipoMax:= '';
      reset(archivo); 
      leer(archivo,pActual);
      while (pActual.anho <> valorAlto) do 
        begin
          anhoActual:= pActual.anho;      
          writeln('Anho : ',anhoActual);
          while (anhoActual = pActual.anho) do 
            begin
              codigoTorneoActual:= pActual.codigoTorneo;
              writeln('Codigo de torneo actual: ',codigoTorneoActual);
              while ( (anhoActual = pActual.anho) and (codigoTorneoActual = pActual.codigoTorneo)) do 
                begin
                  codigoEquipoActual:= pActual.codigoEquipo;
                  nombreEquipoActual:= pActual.nombreEquipo;
                  writeln('==> Codigo equipo: ',codigoTorneoActual, 'Nombre del equipo: ',nombreEquipoActual);
                  inicializarContadores(cantGF,cantGC,cantPG,cantPP,cantPE,cantPuntos);
                  while ( (anhoActual = pActual.anho) and (codigoTorneoActual = pActual.codigoTorneo) and (codigoEquipoActual = pActual.codigoEquipo)) do begin
                        actualizarContadores(cantGF,cantGC,cantPG,cantPP,cantPE,cantPuntos,pActual);
                        leer(archivo,pActual);
                  end;// fin del equipo actual
                    writeln('===============================');
                    informarDatosEquipoProcesado(cantGF,cantGC,cantPG,cantPP,cantPE,cantPuntos);
                    calcularCampeonTorneo(cantPuntos,maxPuntos,nombreEquipoMax,nombreEquipoActual)
                end;// fin del torneo actual
              WriteLn('El equipo ',nombreEquipoMax,'fue campeon del torneo ',codigoTorneoActual, 'del anho ',anhoActual);
              writeln('===============================');
            end;// fin del año actual
             writeln('===================================');
        end;// fin del archivo
    close(archivo); 
end;// fin del procedure
    
