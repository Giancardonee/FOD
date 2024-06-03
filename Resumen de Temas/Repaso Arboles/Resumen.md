# Apuntes para Arbol B:
  - Cuando se elimina una clave que esta en un nodo NO hoja, se reemplaza con la clave menor del subarbol derecho
      
  - Cuando se fusiona,por convencion,siempre se agrupan las claves sobre el nodo izquierdo. Baja la clave padre y las claves del hermano adyacente, se agrupa en el nodo que produjo el underflow.

  - Cuando se redistribuye, baja la clave del nodo padre hacia el nodo que produjo underflow.  
    Y sube hacia el nodo padre, la clave del hermano adyacente que hizo el prestamo.

  
