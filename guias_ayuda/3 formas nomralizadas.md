# Las 3 Formas Normales Aplicadas al Proyecto

## Primera Forma Normal (1FN)

El requisito de la 1FN es la **atomicidad**. Eliminamos las listas separadas por comas. Para lograrlo, decidimos estructurar un 'Detalle de Venta' donde cada producto comprado en una factura ocupe su propia fila individual. Con esto, cada intersección de fila y columna contiene un único valor atómico.

## Segunda Forma Normal (2FN)

La 2FN nos pide eliminar las **dependencias parciales**. Es decir, que los atributos que no forman parte de la clave primaria dependan de toda la clave, y no solo de una parte de ella. Identificamos que los datos del cliente, del vendedor y del producto no dependían de la transacción de venta en sí. Por ende, los extrajimos en sus propias tablas independientes: `clientes`, `vendedores` y `productos`, cada una con su propia Clave Primaria (PK).

## Tercera Forma Normal (3FN)

La 3FN nos exige eliminar las **dependencias transitivas** (atributos que dependen de otros atributos que no son clave). En la tabla de productos original, la columna 'categoría' dependía del producto, pero el nombre de la categoría no es una propiedad directa del producto, sino del tipo de producto. Por lo tanto, creamos la tabla independiente `categorias` y la relacionamos con la tabla `productos` mediante una llave foránea (`categoria_id`), logrando así la 3FN.
