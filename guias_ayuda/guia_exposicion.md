# Guía de Exposición: Proyecto de Normalización de Ventas (SENA - ADSO)

Esta guía te ayudará a estructurar tu exposición ante el profesor para que puedas explicar con total seguridad cada parte de tu trabajo. Está redactada en primera persona y dividida en pasos secuenciales.

---

## 📋 Estructura de la Exposición

1. **Introducción y Contexto (¿Por qué normalizar?)**
2. **El Problema Inicial: La Tabla Cruda**
3. **El Proceso de Normalización paso a paso (1FN, 2FN, 3FN)**
4. **El Modelo Físico Resultante (Las 6 Tablas)**
5. **Carga de Datos e Integridad Referencial**
6. **Validación del Modelo mediante Consultas SQL (Explicación línea a línea)**
7. **Posibles Preguntas del Instructor y cómo responderlas**

---

### Paso 1: Introducción y Contexto (1 - 2 minutos)

> **Qué decir:**
> *"Buenos días/tardes instructor. Hoy voy a presentar el proyecto de normalización para el módulo de bases de datos. El objetivo principal de este proyecto es tomar una base de datos de ventas desnormalizada y transformarla en una estructura relacional óptima bajo el estándar de la **Tercera Forma Normal (3FN)**. Esto garantiza que no tengamos redundancia, que ahorremos espacio de almacenamiento y, sobre todo, que mantengamos la integridad referencial de los datos, evitando anomalías al insertar, actualizar o eliminar información."*

---

### Paso 2: El Problema Inicial - La Tabla Cruda (2 minutos)

Muestra o haz referencia al archivo [00_tabla_cruda.sql](file:///media/hackboy/SENA1/00%20SENA/CUARTO%20TRIMESTRE/5.%20VIERNES/Sistema-ventas/mini-proyecto-normalizacion-ventas/sql/00_tabla_cruda.sql).

> **Qué decir:**
> *"Comenzamos analizando la tabla original llamada `ventas_crudas`. Como se puede observar en el script `00_tabla_cruda.sql`, esta tabla tiene graves problemas de diseño:*
> 1. **Atributos multivaluados:** *Campos como `productos_codigos`, `productos_nombres`, `cantidades` y `precios_unitarios` contienen listas de elementos separados por comas dentro de una sola celda (por ejemplo: 'P001,P002'). Esto rompe la atomicidad de los datos y hace imposible realizar consultas eficientes.*
> 2. **Redundancia extrema:** *Los datos del cliente (nombre, email, teléfono, dirección, ciudad) y del vendedor (nombre, zona) se repiten textualmente en cada factura. Si un cliente cambia de teléfono, tendríamos que actualizar decenas de filas, corriendo el riesgo de dejar datos inconsistentes."*

---

### Paso 3: El Proceso de Normalización Paso a Paso (3 - 4 minutos)

Aquí debes explicar los tres pasos lógicos que aplicaste. Es la parte clave de la materia de Normalización:

> **Qué decir:**
> *"Para resolver esto, aplicamos las tres formas normales secuencialmente:*
> 
> *   **Primera Forma Normal (1FN):** *El requisito de la 1FN es la **atomicidad**. Eliminamos las listas separadas por comas. Para lograrlo, decidimos estructurar un 'Detalle de Venta' donde cada producto comprado en una factura ocupe su propia fila individual. Con esto, cada intersección de fila y columna contiene un único valor atómico.*
> *   **Segunda Forma Normal (2FN):** *La 2FN nos pide eliminar las **dependencias parciales**. Es decir, que los atributos que no forman parte de la clave primaria dependan de toda la clave, y no solo de una parte de ella. Identificamos que los datos del cliente, del vendedor y del producto no dependían de la transacción de venta en sí. Por ende, los extrajimos en sus propias tablas independientes:* `clientes`, `vendedores` *y* `productos`, *cada una con su propia Clave Primaria (PK).*
> *   **Tercera Forma Normal (3FN):** *La 3FN nos exige eliminar las **dependencias transitivas** (atributos que dependen de otros atributos que no son clave). En la tabla de productos original, la columna 'categoría' dependía del producto, pero el nombre de la categoría no es una propiedad directa del producto, sino del tipo de producto. Por lo tanto, creamos la tabla independiente* `categorias` *y la relacionamos con la tabla* `productos` *mediante una llave foránea (`categoria_id`), logrando así la 3FN."*

---

### Paso 4: El Modelo Físico Normalizado (2 - 3 minutos)

Muestra o haz referencia al archivo [01_modelo_normalizado.sql](file:///media/hackboy/SENA1/00%20SENA/CUARTO%20TRIMESTRE/5.%20VIERNES/Sistema-ventas/mini-proyecto-normalizacion-ventas/sql/01_modelo_normalizado.sql) y abre la imagen del diagrama si la tienes a mano (`diagrama_er.png`).

> **Qué decir:**
> *"Como resultado del proceso, nuestro diseño lógico y físico quedó compuesto por **6 tablas relacionadas** dentro del esquema `ventas_normalizacion`:*
> 
> 1.  **`clientes`**: *Almacena el catálogo de clientes. Definimos `cliente_id` as clave primaria autoincremental (`SERIAL`), y colocamos restricciones `UNIQUE` sobre el documento y el email para evitar duplicados.*
> 2.  **`vendedores`**: *Almacena la información de los asesores de ventas con su zona.*
> 3.  **`categorias`**: *Un catálogo simple para agrupar los tipos de productos.*
> 4.  **`productos`**: *Contiene los artículos de tecnología. Se relaciona con `categorias` mediante la FK `categoria_id`.*
> 5.  **`ventas`**: *Representa el encabezado de la factura. Registra la fecha, el método de pago, la entidad, y está enlazada con el cliente (`cliente_id`) y el vendedor (`vendedor_id`).*
> 6.  **`detalle_venta`**: *Esta es una tabla intermedia con una **clave primaria compuesta** por `(venta_id, producto_id)`. Aquí se almacena la cantidad de unidades vendidas, el precio unitario cobrado y el descuento específico aplicado.*
> 
> **Restricciones de Integridad:** *Para garantizar que la base de datos sea robusta, aplicamos reglas DDL estrictas:*
> *   *Restricciones `CHECK` para evitar cantidades negativas o precios inválidos.*
> *   *Restricciones `FOREIGN KEY` con políticas `ON DELETE RESTRICT` en catálogos (para no borrar un cliente que ya tiene compras) y `ON DELETE CASCADE` en los detalles de venta (si se borra una factura, se eliminan sus detalles automáticamente)."*

---

### Paso 5: La Carga de Datos y Consistencia (1 minuto)

Muestra o haz referencia al archivo [02_datos_normalizados.sql](file:///media/hackboy/SENA1/00%20SENA/CUARTO%20TRIMESTRE/5.%20VIERNES/Sistema-ventas/mini-proyecto-normalizacion-ventas/sql/02_datos_normalizados.sql).

> **Qué decir:**
> *"En el script `02_datos_normalizados.sql` realizamos la inserción del conjunto de datos de prueba original. Sin embargo, en lugar de meter la información en una sola fila desordenada, distribuimos los registros de manera jerárquica: primero los catálogos (`clientes`, `vendedores`, `categorias`), luego los `productos`, después los encabezados de las `ventas`, y finalmente los `detalles_venta`. Usamos `TRUNCATE ... RESTART IDENTITY CASCADE` para limpiar de forma segura las tablas antes de cada prueba."*

---

### Paso 6: Validación del Modelo mediante Consultas SQL (3 - 4 minutos)

Muestra o haz referencia al archivo [03_consultas_validacion.sql](file:///media/hackboy/SENA1/00%20SENA/CUARTO%20TRIMESTRE/5.%20VIERNES/Sistema-ventas/mini-proyecto-normalizacion-ventas/sql/03_consultas_validacion.sql).

> **Qué decir:**
> *"Para demostrar la efectividad del modelo normalizado, ejecutamos las 5 consultas de validación solicitadas por la guía. A continuación, explicaré qué hace exactamente cada instrucción y cada parte de las consultas.*
> 
> *Antes de detallar cada consulta, quiero aclarar que en SQL usamos la palabra clave **`AS`** para definir **Alias** (apodos temporales) con dos propósitos:*
> 1.  **Renombrar columnas:** *Para que los resultados de cálculos como `SUM` o `COUNT` aparezcan en el reporte final con un nombre claro y profesional en lugar de llamarse genéricamente 'sum' o 'count'.*
> 2.  **Renombrar tablas:** *Para acortar los nombres largos de las tablas en los cruces de datos y hacer que las consultas sean más legibles (por ejemplo, llamar simplemente `dv` a la tabla `detalle_venta` o `p` a `productos`)."*

#### 1. Total calculado por cada venta desde el detalle

```sql
SELECT 
    venta_id,
    SUM(cantidad * precio_unitario - descuento) AS total_calculado
FROM ventas_normalizacion.detalle_venta
GROUP BY venta_id
ORDER BY venta_id;
```

*   **`SELECT venta_id`**: Trae la columna que identifica de forma única a cada venta o factura.
*   **`SUM(cantidad * precio_unitario - descuento) AS total_calculado`**: Realiza la operación matemática (cantidad × precio menos descuento) y suma todo lo de cada factura. Usa **`AS total_calculado`** para darle un alias a esta columna resultante, evitando que se llame simplemente 'sum'.
*   **`FROM ventas_normalizacion.detalle_venta`**: Le indica al motor que busque esta información en la tabla `detalle_venta` dentro del esquema `ventas_normalizacion`.
*   **`GROUP BY venta_id`**: Agrupa los resultados por cada número de factura. Esto evita que sume todo el almacén y calcula el valor de forma independiente para cada venta.
*   **`ORDER BY venta_id`**: Ordena el resultado final del listado por el código de venta de menor a mayor.

#### 2. Productos más vendidos por cantidad total

```sql
SELECT 
    p.codigo AS producto_codigo,
    p.nombre AS producto_nombre,
    SUM(dv.cantidad) AS unidades_vendidas
FROM ventas_normalizacion.detalle_venta dv
JOIN ventas_normalizacion.productos p ON dv.producto_id = p.producto_id
GROUP BY p.codigo, p.nombre
ORDER BY unidades_vendidas DESC;
```

*   **`SELECT p.codigo AS producto_codigo, p.nombre AS producto_nombre`**: Selecciona el código y nombre del producto. Usa **`AS producto_codigo`** y **`AS producto_nombre`** para renombrar estas columnas con títulos más claros y descriptivos para el reporte.
*   **`SUM(dv.cantidad) AS unidades_vendidas`**: Suma las cantidades y usa **`AS unidades_vendidas`** para renombrar el total sumado con un nombre profesional.
*   **`FROM ventas_normalizacion.detalle_venta dv`**: Define la tabla de origen y usa el alias **`dv`** (escribir `dv` es un atajo de `AS dv`) para abreviar la tabla y no escribir su nombre largo cada vez.
*   **`JOIN ventas_normalizacion.productos p ON dv.producto_id = p.producto_id`**: Cruza con la tabla de productos y usa el alias **`p`** (atajo de `AS p`) para abreviar la tabla.
*   **`GROUP BY p.codigo, p.nombre`**: Agrupa la sumatoria de las unidades para que se calcule por producto.
*   **`ORDER BY unidades_vendidas DESC`**: Ordena la lista de productos de mayor a menor (`DESC`) cantidad vendida para tener al más vendido al principio.

#### 3. Ventas por vendedor

```sql
SELECT 
    ve.vendedor_id,
    ve.nombre AS vendedor_nombre,
    COUNT(DISTINCT v.venta_id) AS cantidad_ventas,
    SUM(dv.cantidad * dv.precio_unitario - dv.descuento) AS valor_total
FROM ventas_normalizacion.vendedores ve
JOIN ventas_normalizacion.ventas v ON ve.vendedor_id = v.vendedor_id
JOIN ventas_normalizacion.detalle_venta dv ON v.venta_id = dv.venta_id
GROUP BY ve.vendedor_id, ve.nombre
ORDER BY valor_total DESC;
```

*   **`SELECT ve.vendedor_id, ve.nombre AS vendedor_nombre`**: Trae los datos del vendedor y usa **`AS vendedor_nombre`** para renombrar la columna del nombre.
*   **`COUNT(DISTINCT v.venta_id) AS cantidad_ventas`**: Cuenta las facturas únicas del vendedor y usa **`AS cantidad_ventas`** para asignarle ese título al conteo.
*   **`SUM(dv.cantidad * dv.precio_unitario - dv.descuento) AS valor_total`**: Calcula el dinero acumulado y usa **`AS valor_total`** para etiquetar la columna final del total.
*   **`FROM ventas_normalizacion.vendedores ve`**: Usa el alias **`ve`** (atajo de `AS ve`) para abreviar la tabla `vendedores`.
*   **`JOIN ventas_normalizacion.ventas v ON ve.vendedor_id = v.vendedor_id`**: Cruza con ventas usando el alias **`v`** (atajo de `AS v`) para abreviar.
*   **`JOIN ventas_normalizacion.detalle_venta dv ON v.venta_id = dv.venta_id`**: Cruza con los detalles usando el alias **`dv`** (atajo de `AS dv`) para abreviar.
*   **`GROUP BY ve.vendedor_id, ve.nombre`**: Agrupa las métricas anteriores para cada vendedor individualmente.
*   **`ORDER BY valor_total DESC`**: Ordena los vendedores según quién acumuló más dinero facturado (de mayor a menor).

#### 4. Historial de compras de un cliente específico

```sql
SELECT 
    c.doc AS cliente_doc,
    c.nombre AS cliente_nombre,
    v.venta_id,
    v.fecha AS fecha_venta,
    p.nombre AS producto,
    dv.cantidad
FROM ventas_normalizacion.clientes c
JOIN ventas_normalizacion.ventas v ON c.cliente_id = v.cliente_id
JOIN ventas_normalizacion.detalle_venta dv ON v.venta_id = dv.venta_id
JOIN ventas_normalizacion.productos p ON dv.producto_id = p.producto_id
WHERE c.doc = 'CC101'
ORDER BY v.fecha DESC, p.nombre;
```

*   **`SELECT c.doc AS cliente_doc, c.nombre AS cliente_nombre, v.venta_id, v.fecha AS fecha_venta, p.nombre AS producto, dv.cantidad`**: Selecciona las columnas del reporte y usa **`AS`** (en `cliente_doc`, `cliente_nombre`, `fecha_venta` y `producto`) para darles nombres bonitos y ordenados a los encabezados de la tabla resultante.
*   **`FROM ventas_normalizacion.clientes c`**: Inicia en la tabla de clientes y usa el alias **`c`** (atajo de `AS c`) para abreviarla.
*   **`JOIN ventas_normalizacion.ventas v... JOIN ventas_normalizacion.detalle_venta dv... JOIN ventas_normalizacion.productos p...`**: Cruza las tablas usando los alias **`v`**, **`dv`** y **`p`** (atajos de `AS v`, `AS dv` y `AS p`) para hacer el código mucho más corto y legible.
*   **`WHERE c.doc = 'CC101'`**: Filtra la consulta completa para mostrar únicamente los datos del cliente con cédula `'CC101'`.
*   **`ORDER BY v.fecha DESC, p.nombre`**: Ordena por fecha de forma descendente (compras recientes primero) y luego por orden alfabético del producto.

#### 5. Control de integridad: detalles sin venta o sin producto

```sql
SELECT 
    (
        SELECT COUNT(*) 
        FROM ventas_normalizacion.detalle_venta 
        WHERE venta_id NOT IN (SELECT venta_id FROM ventas_normalizacion.ventas)
    ) AS huerfanos_sin_venta,
    (
        SELECT COUNT(*) 
        FROM ventas_normalizacion.detalle_venta 
        WHERE producto_id NOT IN (SELECT producto_id FROM ventas_normalizacion.productos)
    ) AS huerfanos_sin_producto;
```

*   Esta consulta ejecuta dos conteos independientes y usa **`AS huerfanos_sin_venta`** y **`AS huerfanos_sin_producto`** para renombrar las columnas del resultado, mostrando de forma clara cuántos registros rotos o inválidos existen en cada auditoría.
*   *Explicación para el profesor:* *"El conteo de ambas subconsultas arroja cero (0). Esto es una demostración técnica de que no hay registros huérfanos y que la base de datos posee 100% de integridad referencial gracias a las claves foráneas definidas con `ON DELETE RESTRICT`"*.

---

### Paso 7: Posibles Preguntas del Instructor y Respuestas Sugeridas

> [!IMPORTANT]
> Prepárate para estas preguntas típicas de sustentación:

1.  **¿Por qué el campo `vendedor_id` y `venta_id` los definiste como `VARCHAR(10)` en lugar de un `SERIAL` autoincremental?**
    *   *Respuesta:* "Porque el enunciado original ya nos entregaba códigos de negocio estructurados (como 'VEN01', 'VEN02' o 'V1001'). En el caso de los clientes, como venían representados por su cédula (CC101), preferimos crear una clave subrogada autoincremental `cliente_id SERIAL` como PK del sistema y dejar el documento de identidad como un índice único (`UQ`), que es la mejor práctica de diseño físico."
2.  **¿Qué pasa si borro un producto que ya fue vendido?**
    *   *Respuesta:* "El sistema lo impedirá inmediatamente. En la definición de la llave foránea `fk_detalle_venta_productos` aplicamos la política `ON DELETE RESTRICT`. Esto protege el histórico de ventas y evita que tengamos registros huérfanos o que se alteren los informes contables del negocio."
3.  **¿Cuál es la diferencia técnica entre la tabla `ventas` y `detalle_venta`?**
    *   *Respuesta:* "`ventas` representa la cabecera del documento comercial (una sola fila por factura con datos generales como fecha, cliente y vendedor). `detalle_venta` almacena los renglones de esa factura (relación de muchos a muchos entre ventas y productos), permitiendo que una venta tenga múltiples productos y que un producto aparezca en múltiples ventas."
4.  **¿Por qué es importante tener una tabla `categorias` separada de `productos`? (Pregunta clásica de 3FN)**
    *   *Respuesta:* "Si dejamos la categoría en la tabla de productos, estaríamos repitiendo el nombre de la categoría por cada producto asociado (por ejemplo, escribir 'Periféricos' muchas veces). Si decidimos corregir el nombre de una categoría o agregarle descripciones, tendríamos que cambiarlo en miles de productos. Al tener la tabla `categorias`, sólo lo modificamos en un único lugar, evitando inconsistencias."
