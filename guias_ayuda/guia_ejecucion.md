# Guia de Ejecucion y Docker: Sistema de Ventas (pgAdmin)

Esta guia contiene el paso a paso detallado para verificar el entorno, levantar la base de datos y administrar el proyecto desde la interfaz grafica de pgAdmin.

---

## 1. Verificar Instalacion de Docker

Asegurate de tener Docker activo en tu computadora corriendo estos comandos:

```bash
docker --version
docker compose version
```

---

## 2. Limpieza Preventiva (Liberar puertos)

Si tienes problemas al encender el contenedor (como el error de "puerto ocupado"), sigue estos pasos para limpiar y liberar el puerto `5435`:

```bash
cd "/media/hackboy/SENA1/00 SENA/CUARTO TRIMESTRE/5. VIERNES/Sistema-ventas/entorno-postgres"
docker compose down -v
```

---

## 3. Control del Servidor (Docker Compose)

El entorno lee tu carpeta `sql/` y carga las tablas y datos de forma automatica en PostgreSQL al iniciar.

### Iniciar el Servidor

```bash
cd "/media/hackboy/SENA1/00 SENA/CUARTO TRIMESTRE/5. VIERNES/Sistema-ventas/entorno-postgres"
docker compose up -d
```

### Detener el Servidor (Sin borrar datos)

```bash
cd "/media/hackboy/SENA1/00 SENA/CUARTO TRIMESTRE/5. VIERNES/Sistema-ventas/entorno-postgres"
docker compose down
```

### Reiniciar y Cargar Cambios SQL Automaticamente

Si haces cambios en tus scripts `.sql` y quieres que la base de datos se actualice sola con los nuevos datos, ejecuta:

```bash
cd "/media/hackboy/SENA1/00 SENA/CUARTO TRIMESTRE/5. VIERNES/Sistema-ventas/entorno-postgres"
docker compose down -v
docker compose up -d
```

*Nota: La bandera `-v` elimina la base de datos anterior para que PostgreSQL se vuelva a crear desde cero con tus scripts actualizados.*

---

## 4. Conectar con pgAdmin (Interfaz Grafica)

* **Navegador:** Accede a [pgAdmin](http://localhost:8085)
* **Email de pgAdmin:** `admin@ventas.com`
* **Contrasena de pgAdmin:** `admin123`

### Datos de Conexion del Servidor

| Campo | Valor |
| --- | --- |
| **Name** | `Ventas Normalizadas` |
| **Host name/address** | `postgres` |
| **Port** | `5432` |
| **Maintenance database** | `ventas_db` |
| **Username** | `ventas_user` |
| **Password** | `ventas_pass` |

*Nota: Una vez conectado, despliega las bases de datos para ver `ventas_db` y el esquema `ventas_normalizacion` con todas tus tablas cargadas.*

### Visualizacion de datos en pgAdmin

Por defecto, la pantalla derecha de pgAdmin se muestra vacia. Para visualizar la informacion de tus tablas, utiliza cualquiera de estos dos metodos:

* **Metodo Visual:** Haz clic derecho sobre la tabla que deseas consultar (como `clientes` o `ventas_crudas`), selecciona **View/Edit Data** y luego **All Rows** para ver la cuadricula.
* **Metodo SQL:** Haz clic derecho sobre la base de datos `ventas_db`, elige **Query Tool**, escribe la consulta `SELECT * FROM ventas_normalizacion.clientes;` y presiona la tecla **F5** para ejecutar.

---

## 5. Resolucion de Errores Comunes

### Error de permisos de Docker

Si te aparece un error de permisos en la terminal al correr Docker:

```text
permission denied while trying to connect to the Docker API at unix:///var/run/docker.sock
```

**Solucion:**

```bash
sudo usermod -aG docker $USER
newgrp docker
docker ps
```

*Nota: Si sigue fallando, cierra sesion en tu sistema operativo y vuelve a ingresar.*

### Error de puerto ocupado

Si te sale un error de puerto ocupado:

```text
Error: ports are not available: listen tcp 0.0.0.0:5435: bind: address already in use
```

**Solucion:**

Abre el archivo `docker-compose.yml` en la carpeta `entorno-postgres` y cambia el puerto izquierdo (`5435`) por otro libre (ejemplo: `5436`):

```yaml
ports:
  - "5436:5432"
```
