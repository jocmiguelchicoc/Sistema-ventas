# Mini Proyecto de Normalizacion de Sistema de Ventas

Instrumento y artefactos entregables para la actividad practica del
**Modulo 2: Normalizacion** del programa **Analisis y Desarrollo de
Software (ADSO)** — SENA.

---

> [!NOTE]
> Este proyecto contiene el diseno logico, fisico y las consultas de
> validacion en PostgreSQL del proceso de normalizacion de una base de
> datos desnormalizada (tabla cruda) hasta la Tercera Forma Normal (3FN).

---

## Tabla de contenidos

- [Estructura del entregable](#estructura-del-entregable)
- [Mapa del repositorio](#mapa-del-repositorio)
- [Modelo fisico normalizado](#modelo-fisico-normalizado)
- [Resumen de decisiones de normalizacion](#resumen-de-decisiones-de-normalizacion)
- [Consultas minimas de validacion](#consultas-minimas-de-validacion)
- [Instrucciones de ejecucion](#instrucciones-de-ejecucion)

---

## Estructura del entregable

El proyecto esta compuesto por los siguientes componentes obligatorios de
entrega:

| Entregable | Contenido minimo | Formato sugerido |
| --- | --- | --- |
| **Informe de normalizacion** | Diagnostico, dependencias y justificaciones. | LibreOffice Writer (`.odt`) |
| **Diagrama ER** | Entidades, atributos, llaves PK, FK y relaciones. | Imagen (`.png`) |
| **Script 00 - Tabla Cruda** | Creacion y datos de la tabla desnormalizada original. | SQL (`00_tabla_cruda.sql`) |
| **Script 01 - Modelo** | DDL para creacion del esquema, tablas y restricciones. | SQL (`01_modelo_normalizado.sql`) |
| **Script 02 - Datos** | DML con la insercion de datos de prueba normalizados. | SQL (`02_datos_normalizados.sql`) |
| **Script 03 - Validacion** | Consultas SQL solicitadas para comprobar el modelo. | SQL (`03_consultas_validacion.sql`) |
| **README** | Guia de ejecucion de scripts y decisiones de diseno. | Markdown (`README.md`) |

---

## Mapa del repositorio

```text
mini-proyecto-normalizacion-ventas/
│
├── README.md                              ← estas aqui (instrucciones y decisiones)
├── diagrama_er.png                        ← diagrama entidad-relacion final
├── informe_normalizacion.odt              ← reporte tecnico en formato de texto libre
│
└── sql/
    ├── 00_tabla_cruda.sql                 ← tabla desnormalizada original (ventas_crudas)
    ├── 01_modelo_normalizado.sql          ← estructura DDL (esquema, tablas y llaves)
    ├── 02_datos_normalizados.sql          ← carga de datos de prueba (DML)
    └── 03_consultas_validacion.sql        ← consultas de validacion SQL
```

---

## Modelo fisico normalizado

El diseno fisico consta de las siguientes 6 entidades dentro del esquema
`ventas_normalizacion`:

| Tabla | Clave Primaria (PK) | Atributos no clave | Relaciones (FK) |
| --- | --- | --- | --- |
| **`clientes`** | `cliente_id` (SERIAL) | `doc` (UQ), `nombre`, `email` (UQ), `telefono`, `direccion`, `ciudad` | Ninguna |
| **`vendedores`** | `vendedor_id` (VARCHAR) | `nombre`, `zona` | Ninguna |
| **`categorias`** | `categoria_id` (SERIAL) | `nombre` (UQ) | Ninguna |
| **`productos`** | `producto_id` (SERIAL) | `codigo` (UQ), `nombre` | `categoria_id` -> `categorias` |
| **`ventas`** | `venta_id` (VARCHAR) | `fecha`, `metodo_pago`, `entidad_pago` | `cliente_id` -> `clientes`, `vendedor_id` -> `vendedores` |
| **`detalle_venta`** | `(venta_id, producto_id)` | `cantidad`, `precio_unitario`, `descuento` | `venta_id` -> `ventas`, `producto_id` -> `productos` |

---

## Resumen de decisiones de normalizacion

* **1FN (Primera Forma Normal):** Se eliminaron los atributos multivaluados
  (productos, cantidades, precios y descuentos concatenados por comas)
  de la venta para asegurar la atomicidad de los datos.
* **2FN (Segunda Forma Normal):** Se eliminaron las dependencias parciales
  respecto a la clave compuesta original. Las entidades `clientes`,
  `vendedores` y `productos` se extrajeron a tablas propias con llaves
  primarias independientes.
* **3FN (Tercera Forma Normal):** Se elimino la dependencia transitiva que
  existia entre el producto y la categoria del mismo, creando la tabla
  `categorias` para evitar redundancia de nombres.

---

## Consultas minimas de validacion

El script **`sql/03_consultas_validacion.sql`** implementa las siguientes 5
consultas exigidas por la seccion 9 de la guia:

### 1. Reconstruye el total de cada venta desde el detalle

Permite calcular matematicamente la sumatoria del valor de cada producto por su
cantidad, restandole el descuento correspondiente.
* **Campos esperados:** `venta_id`, `total_calculado`.

### 2. Consulta productos mas vendidos por cantidad

Agrupa los detalles de venta para conocer el total de unidades vendidas de cada
producto en orden descendente.
* **Campos esperados:** `producto_codigo`, `producto_nombre`,
  `unidades_vendidas`.

### 3. Consulta ventas por vendedor

Calcula la cantidad de ventas individuales y el monto total facturado
acumulado por cada vendedor.
* **Campos esperados:** `vendedor_id`, `vendedor_nombre`, `cantidad_ventas`,
  `valor_total`.

### 4. Consulta historial de compras por cliente

Lista detalladamente cada uno de los productos que ha comprado cada cliente,
con su respectiva fecha y cantidad.
* **Campos esperados:** `cliente_doc`, `cliente_nombre`, `venta_id`,
  `fecha_venta`, `producto`, `cantidad`.

### 5. Verifica que no existan registros huerfanos en detalle venta

Control de integridad referencial para verificar que todas las filas de la
tabla de detalles esten correctamente asociadas a una venta y a un producto
existentes en sus respectivos catalogos.
* **Resultado esperado:** Cero (0) registros huerfanos.

---

## Instrucciones de ejecucion

Los scripts SQL deben ejecutarse en un orden especifico. Si desea comparar la
tabla cruda original antes del proceso, puede ejecutar el script
`00_tabla_cruda.sql` de forma opcional.

### Metodo 1: Desde un Cliente de Base de Datos (pgAdmin o DBeaver)

1. Conectese a PostgreSQL y abra el editor SQL en su base de datos.
2. *(Opcional)* Abra y ejecute **`sql/00_tabla_cruda.sql`** para registrar la
   tabla cruda original de ventas.
3. Abra y ejecute el archivo **`sql/01_modelo_normalizado.sql`** (creacion del
   esquema y las tablas normalizadas en 3FN).
4. Abra y ejecute el archivo **`sql/02_datos_normalizados.sql`** (carga de
   registros de prueba normalizados).
5. Abra y ejecute el archivo **`sql/03_consultas_validacion.sql`** (consultas
   de validacion de resultados).

### Metodo 2: Desde la Terminal (psql)

Ejecute los siguientes comandos en orden:

```bash
# 0. (Opcional) Cargar tabla cruda desnormalizada
psql -U su_usuario -d su_base_datos -f sql/00_tabla_cruda.sql

# 1. Crear estructura de base de datos normalizada
psql -U su_usuario -d su_base_datos -f sql/01_modelo_normalizado.sql

# 2. Insertar registros de prueba normalizados
psql -U su_usuario -d su_base_datos -f sql/02_datos_normalizados.sql

# 3. Ejecutar consultas y verificar resultados
psql -U su_usuario -d su_base_datos -f sql/03_consultas_validacion.sql
```

### Metodo 3: Ejecucion automatica con Docker Compose (Recomendado)

Si desea levantar la base de datos de manera automatica en un contenedor
Docker con pgAdmin preconfigurado:

1. Dirijase a la carpeta del entorno de base de datos:

   ```bash
   cd ../entorno-postgres
   ```

2. Encienda los servicios en segundo plano:

   ```bash
   docker compose up -d
   ```

   *Nota: Esto creara el contenedor PostgreSQL y cargara automaticamente todos
   los scripts SQL de la carpeta `sql/` en orden.*
3. Abra su navegador web e ingrese a pgAdmin en `http://localhost:8085` con el
   usuario `admin@ventas.com` y contrasena `admin123`.
