# Guia de Sustentacion Personal de SQL

Esta guia esta escrita en primera persona para que la leas como si estuvieras
hablando tu mismo frente al profesor y te acuerdes de lo que hiciste en cada
etapa del proyecto.

---

## 1. Que hice en cada uno de mis scripts SQL

### Script 00 Tabla Cruda

Cree una tabla llamada `ventas_crudas` que guarda los datos originales del
negocio antes de organizarlos. La use como punto de partida para mostrar los
problemas que tenia la informacion desnormalizada, como celdas que tenian
listas separadas por comas. Por ejemplo, la venta V1001 tenia en el campo
`producto_codigos` los valores P001 y P002 al mismo tiempo, lo que hizo
imposible saber que cantidad correspondia a cual producto.

### Script 01 Modelo Normalizado

Aqui cree el esquema limpio llamado `ventas_normalizacion` con las 6 tablas
que diseñe al llegar a la Tercera Forma Normal. Primero borre las tablas si ya
existian para poder crearlas desde cero limpiamente usando `DROP TABLE IF
EXISTS`. Luego cree cada tabla en el orden correcto para que las llaves
foraneas funcionen: primero las que no dependen de nadie (`categorias`,
`clientes`, `vendedores`), luego `productos`, despues `ventas` y al final
`detalle_venta`. A cada tabla le puse su llave primaria, sus llaves foraneas
para conectarlas entre si, restricciones `NOT NULL` para campos obligatorios,
`UNIQUE` para campos que no pueden repetirse como el documento del cliente o el
codigo del producto, y `CHECK` para validar que la cantidad sea mayor a cero y
que el precio y el descuento no sean negativos.

### Script 02 Datos Normalizados

Aqui inserte los datos de prueba dentro de mis 6 tablas ya normalizadas. Lo
que hice fue repartir toda la informacion de la tabla cruda en sus nuevas
tablas correspondientes sin duplicar nada. Por ejemplo, Maria Gomez aparecia
en dos ventas distintas con los mismos datos, entonces la inserte una sola vez
en `clientes` y sus ventas solo guardan su `cliente_id` como referencia.

### Script 03 Consultas de Validacion

Aqui escribi las 5 consultas SQL que exigio el proyecto para demostrar que mi
modelo funciona. Calcule el total de cada venta, consulte los productos mas
vendidos, calcule las ventas por vendedor, liste el historial de compras de
cada cliente y verifique que no existieran registros huerfanos en la tabla de
detalle.

---

## 2. Como aplique la Normalizacion paso a paso

### Como diagnostique la tabla cruda

Al revisar la tabla `ventas_crudas` identifique tres tipos de problemas:

* **Anomalia de insercion:** No podia agregar un producto nuevo al catalogo si
  no estaba dentro de una venta. Un producto sin venta simplemente no podia
  existir.
* **Anomalia de actualizacion:** Maria Gomez aparecia en V1001 y V1003 con el
  mismo telefono. Si ella cambia de numero y solo se actualiza en una fila,
  la tabla queda con dos telefonos distintos para la misma persona.
* **Anomalia de eliminacion:** Diana Mora y Laura Rojas solo apareicen en la
  venta V1004. Si esa venta se borra, sus datos desaparecen con ella aunque
  ellas sigan existiendo.

### Como aplique la Primera Forma Normal (1FN)

La tabla cruda tenia campos multivaluados donde se guardaban varios valores
separados por comas en una sola celda. Para aplicar la 1FN separe cada valor
en su propia fila. La venta V1001 que antes ocupaba una fila con dos productos,
paso a ocupar dos filas: una para el Mouse USB y otra para el Teclado mecanico.
La tabla paso de 4 filas a 9 filas. Propuse la clave compuesta provisional de
`venta_id + producto_codigo` para identificar de forma unica cada fila.

### Como aplique la Segunda Forma Normal (2FN)

Revise que campos no dependian de la clave compuesta completa sino solo de una
parte. Los datos del cliente no tenian nada que ver con el producto, solo
dependian de `cliente_doc`. Los del vendedor tampoco dependian del producto.
Entonces saque clientes a su propia tabla `clientes`, vendedores a `vendedores`
y productos a `productos`. Asi elimine las dependencias parciales.

### Como aplique la Tercera Forma Normal (3FN)

Al revisar la tabla de productos me di cuenta que el campo `categoria` no
dependia de `producto_id` sino de la categoria misma. Si la categoria cambia de
nombre, tocaria actualizarla en todos los productos que la tengan. Para
eliminar esa dependencia transitiva cree una tabla separada llamada `categorias`
y en la tabla `productos` reemplace el campo de texto por `categoria_id` como
llave foranea que apunta a esa nueva tabla.

---

## 3. Por que tome ciertas decisiones de diseno

### Por que guarde precio unitario en detalle venta si ya existe en productos

Guarde el precio cobrado directamente en `detalle_venta` para registrar el
valor historico de la compra. Si dejara el precio solo en la tabla `productos`
y cambiara hoy el precio de un articulo, se danarian todos los totales
facturados de ventas del ano pasado.

### Por que no cree tablas separadas para metodo de pago ni ciudades

Decidi no crear tablas para metodos de pago ni para ciudades porque el proyecto
no define reglas de negocio que obliguen a manejarlos como catalogo. Los deje
como campos de texto directamente en las tablas donde aparecen.

### Que hace ON DELETE RESTRICT y ON DELETE CASCADE

* **ON DELETE RESTRICT:** Impide borrar un cliente o producto si ya tiene
  ventas asociadas, evitando dejar registros sin referencia.
* **ON DELETE CASCADE:** Si borro una venta, el sistema borra
  automaticamente todos sus renglones en `detalle_venta` sin dejar datos
  sueltos.

### Que hace CHECK en cantidad

Evalua una condicion antes de insertar datos. `CHECK (cantidad > 0)` impide
que se registre una venta con cantidad en cero o valores negativos.

---

## 4. Mis dependencias funcionales documentadas

Estas son las dependencias que identifique y aplique en el proyecto:

| Dependencia | Tipo | Accion tomada |
| --- | --- | --- |
| `cliente_doc` -> datos del cliente | Funcional completa | Se saco a la tabla `clientes` con `cliente_id` como PK y `doc` como UNIQUE |
| `vendedor_id` -> nombre, zona | Funcional completa | Se saco a la tabla `vendedores` con `vendedor_id` como PK |
| `producto_codigo` -> nombre, categoria | Transitiva | Se saco a `productos`. La categoria se separo a su propia tabla `categorias` |
| `venta_id` -> fecha, cliente, vendedor, pago | Parcial | Se saco a la tabla `ventas` con `venta_id` como PK |
| `venta_id + producto_codigo` -> cantidad, precio, descuento | Funcional completa | Se mantuvo en `detalle_venta` con clave compuesta |

---

## 5. Como funcionan mis consultas de validacion

### Como calcule el total de cada venta con descuentos

Aplique la formula: `SUM(cantidad * precio_unitario - descuento)`. Multiplique
las unidades de cada fila por su costo, reste el descuento especifico de ese
producto y sume todos los renglones de la venta agrupando por `venta_id`.

### Para que use GROUP BY e INNER JOIN

* Use `INNER JOIN` para cruzar mis tablas usando las llaves en comun (PK y FK)
  y mostrar nombres reales en lugar de codigos.
* Use `GROUP BY` para agrupar las filas y aplicar funciones de agregacion como
  `SUM` (suma) y `COUNT` (conteo). Por ejemplo, agrupar por vendedor para
  saber cuanto vendio cada uno en total.

### Como verifique que no existan registros huerfanos

Escribi una subconsulta que cuenta cuantos registros en `detalle_venta` no
tienen una venta o un producto correspondiente. El resultado esperado es cero,
lo que confirma que la integridad referencial del modelo funciona correctamente.

---

## 6. Explicacion detallada de cada linea de mis scripts SQL

Esta seccion explica bloque por bloque que hice en cada archivo y por que.

---

### Archivo 00 tabla cruda

**Por que lo hice:**
Cree esta tabla para dejar evidencia de como estaba la informacion antes de
normalizarla. Sirve de comparacion para que el instructor vea el problema de
origen.

**`CREATE SCHEMA IF NOT EXISTS ventas_normalizacion`**
Cree un espacio de trabajo llamado `ventas_normalizacion` dentro de la base de
datos para que todas mis tablas queden agrupadas y no se mezclen con las de
otros proyectos. El `IF NOT EXISTS` significa que si el esquema ya existe no
da error, solo lo ignora.

**`SET search_path TO ventas_normalizacion`**
Le indique a PostgreSQL que de aqui en adelante cuando escriba el nombre de
una tabla, la busque dentro de ese esquema sin necesidad de escribir la ruta
completa cada vez.

**`DROP TABLE IF EXISTS ventas_crudas`**
Borre la tabla si ya existia de una ejecucion anterior para poder crearla
desde cero limpiamente.

**Campos con tipo TEXT como `productos_codigos` y `cantidades`**
Estos campos son de tipo TEXT y no VARCHAR porque en la tabla cruda guardaban
listas de valores separados por comas de longitud variable, como
`"P001,P002"` o `"2,1"`. Eso es exactamente el problema que vine a resolver
con la normalizacion.

**Los 4 INSERT INTO ventas_crudas**
Inserte las 4 ventas originales del negocio con sus datos reales mezclados.
Cada fila tiene multiples productos en las mismas celdas, que es el
punto de partida del ejercicio.

---

### Archivo 01 modelo normalizado

**Por que lo hice:**
Aqui cree la estructura definitiva de mi base de datos en 3FN. Es el corazon
del proyecto. Defini las 6 tablas, sus tipos de dato, sus restricciones y sus
relaciones.

**Orden de DROP TABLE (al reves de las dependencias)**
Borre primero `detalle_venta`, luego `ventas`, luego `productos`, etc. porque
no puedo borrar una tabla que otra tabla esta referenciando. Tuve que respetar
el orden inverso de las llaves foraneas.

**Tabla `clientes`**

* Use `SERIAL` para `cliente_id` porque queria que la base de datos asignara
  el numero de forma automatica sin yo tener que escribirlo en cada INSERT.
* Puse `NOT NULL` en `doc`, `nombre`, `email` y `ciudad` porque son datos
  obligatorios que un cliente siempre debe tener.
* Puse `UNIQUE (doc)` porque dos clientes no pueden tener el mismo numero de
  documento. Si alguien intenta insertar un duplicado, el sistema lo rechaza.
* Puse `UNIQUE (email)` porque el correo electronico identifica de forma unica
  a una persona y no puede repetirse en el sistema.
* `telefono` y `direccion` no tienen `NOT NULL` porque hay clientes que tal
  vez no dan esos datos al registrarse.

**Tabla `vendedores`**

* Aqui no use `SERIAL` para `vendedor_id` porque los vendedores ya tenian
  codigos propios en el negocio (VEN01, VEN02, VEN03) y no necesitaba que
  la base de datos generara uno nuevo.

**Tabla `categorias`**

* Use `SERIAL` para `categoria_id` y `UNIQUE (nombre)` para que no se pueda
  repetir el nombre de una categoria. Si alguien intenta insertar "Perifericos"
  dos veces, el sistema lo rechaza.

**Tabla `productos`**

* Tiene `categoria_id INT NOT NULL` como llave foranea. El `NOT NULL`
  significa que todo producto debe pertenecer obligatoriamente a una categoria.
  No puede existir un producto sin categoria.
* `FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
  ON DELETE RESTRICT` significa que si intento borrar una categoria que tiene
  productos asociados, el sistema me lo impide. Asi protejo la integridad.

**Tabla `ventas`**

* Tiene dos llaves foraneas: `cliente_id` apunta a `clientes` y `vendedor_id`
  apunta a `vendedores`. Ambas con `ON DELETE RESTRICT` para evitar borrar
  un cliente o vendedor que tenga ventas registradas.

**Tabla `detalle_venta`**

* La clave primaria es compuesta: `PRIMARY KEY (venta_id, producto_id)`. Esto
  significa que una misma venta no puede tener el mismo producto dos veces.
* `FOREIGN KEY (venta_id) REFERENCES ventas(venta_id) ON DELETE CASCADE`:
  si se borra una venta, todos sus renglones de detalle se borran
  automaticamente con ella.
* `FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
  ON DELETE RESTRICT`: no se puede borrar un producto si ya fue vendido.
* `CHECK (cantidad > 0)`: valida que la cantidad vendida sea siempre mayor
  a cero. Impide errores de datos como cantidades en cero o negativas.
* `CHECK (precio_unitario >= 0)`: el precio no puede ser negativo.
* `CHECK (descuento >= 0)`: el descuento tampoco puede ser negativo.

---

### Archivo 02 datos normalizados

**Por que lo hice:**
Aqui cargue los datos reales del negocio distribuidos correctamente en las 6
tablas del modelo, sin duplicar informacion.

**`TRUNCATE TABLE ... RESTART IDENTITY CASCADE`**
Borre todos los datos existentes antes de insertar para evitar duplicados al
ejecutar el script varias veces. El `RESTART IDENTITY` reinicia los contadores
de los campos `SERIAL` a 1. El `CASCADE` borra en cascada las tablas que
dependen entre si.

**Por que inserto clientes, vendedores y categorias primero**
Las tablas que no tienen llaves foraneas se deben insertar antes porque las
demas las necesitan para poder referenciarlas. No puedo insertar un producto
si su categoria no existe todavia.

**Por que Maria Gomez aparece una sola vez en clientes**
En la tabla cruda aparecia en dos ventas (V1001 y V1003) con los mismos datos
repetidos. Aqui la inserte solo una vez con `cliente_id = 1` y las ventas V1001
y V1003 la referencian con ese mismo ID. Ese es el resultado de aplicar la 2FN.

**Por que uso numeros (1, 2, 3) en lugar de codigos al insertar productos**
Porque `categoria_id` es un numero entero generado por `SERIAL`. La categoria
"Perifericos" quedo con `categoria_id = 1`, "Pantallas" con 2, y asi. Entonces
al insertar los productos puse el numero que le corresponde a cada categoria.

**Por que guardo el precio en detalle_venta y no solo en productos**
Para conservar el precio historico de la compra. En el INSERT del
`detalle_venta` guardo el precio exacto que se cobro en ese momento. Si el
precio del producto cambia manana en la tabla `productos`, las ventas pasadas
no se alteran.

---

### Archivo 03 consultas de validacion

**Por que lo hice:**
Escribi estas consultas para demostrar que el modelo relacional funciona y
puede responder preguntas reales del negocio haciendo JOINs entre las tablas.

**Consulta 1: total por venta**
Uso `SUM(cantidad * precio_unitario - descuento)` para calcular el valor
total de cada venta. Agrupo por `venta_id` con `GROUP BY` para que la suma
aplique a todos los renglones de cada venta por separado.

**Consulta 2: productos mas vendidos**
Hago un `JOIN` entre `detalle_venta` y `productos` para reemplazar el
`producto_id` numerico por el nombre real del producto. Uso `SUM(cantidad)`
para contar el total de unidades y `ORDER BY DESC` para ordenar de mayor a
menor.

**Consulta 3: ventas por vendedor**
Cruzo `vendedores`, `ventas` y `detalle_venta` con dos JOINs encadenados.
Uso `COUNT(DISTINCT venta_id)` para contar cuantas ventas hizo cada vendedor
sin repetirlas, y `SUM` para el valor total acumulado.

**Consulta 4: historial de compras por cliente**
Cruzo cuatro tablas: `clientes`, `ventas`, `detalle_venta` y `productos`.
Esto me permite mostrar el nombre del cliente, la fecha de la venta y el
nombre del producto en una sola fila sin guardar listas separadas por comas.
Eso demuestra que el modelo cumple con la 1FN.

**Consulta 5: verificacion de huerfanos**
Uso dos subconsultas anidadas con `NOT IN` para contar cuantos registros de
`detalle_venta` no tienen una venta o un producto correspondiente. El
resultado debe ser cero, lo que confirma que todas las llaves foraneas estan
funcionando correctamente y no hay datos rotos en la base de datos.
