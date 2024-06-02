{-----------------------------------------------------------------}
{Actualizar un archivo Maestro a partir de un archivo Detalle}
{Para usar este algoritmo, se debe tener como precondicion que los elementos en
el archivo detalle NO se repiten}
assign(archMae,"Maestro"); 
assign(archDet,"Detalle"); 
reset(archMae); reset (archDet); 
while (not EOF(archDetalle)) do 
    begin
      read(archMae,regMae); 
      read(archDet,regDet); 
     {se busca en el archivo maestro, el producto del detalle}
        while (regMae.cod <> regDet.cod) do 
            begin
                read(archMae,regMae); 
            end;    
     {cuando salga del while es porque se encontro el registro}
     regMae.stock:= regMae.stock - regDet.cantVendida; 
     seek(archMae,filePos(archMae)-1); {volvemos una pos atras en el maestro} 
     write (archMae,regMae); 
    end;
close(archMae); close (archDet); 
{-----------------------------------------------------------------}
{Actualizar un archivo Maestro a partir de un archivo Detalle}
{En este algoritmo, se tiene como precondicion que
en el archivo detalle pueden aparecer registros repetidos 
(Es decir, puede aparecer mas de una venta por codigo de producto)}

assign(archMae,"Maestro"); 
assign(archDet,"Detalle"); 
reset(archMae); reset (archDet); 
while (not EOF(archDetalle)) do 
    begin
      read(archMae,regMae); 
      read(archDet,regDet); 
     {se busca en el archivo maestro, el producto del detalle}
        while (regMae.cod <> regDet.cod) do 
            begin
                read(archMae,regMae); 
            end;    
     {cuando salga del while es porque se encontro el registro}
     cod_actual:= regDet.cod; 
     tot_vendido:=0;
     {procesamos todas las ventas de ese mismo codigo de producto}
        while (regDet.cod = cod_actual) do 
            begin
              tot_vendido:= tot_vendido + regDet.cantVendida;
              read(archDet,regDet); 
            end;
    {actualizamos el registro maestro, para luego posicionarnos y escribir el registro actualizado}
    regMae.stock := regMae.stock - tot_vendido;
    seek(archMae,filePos(archMae)-1)
     write (archMae,regMae); 
    end;
close(archMae); close (archDet); 
