# Correr Docker desde la Terminal

## Verificar instalacion

```bash
docker --version
docker compose version
```

---

## Correr un proyecto con docker-compose.yml

```bash
# Pararte en la carpeta del proyecto
cd /ruta/de/tu/proyecto

# Levantar los servicios en segundo plano
docker compose up -d
```

---

## Ver contenedores corriendo

```bash
docker ps
```

---

## Ver los logs en vivo

```bash
docker logs -f nombre-del-contenedor
```

---

## Bajar los servicios

```bash
docker compose down
```

---

## Comandos de emergencia

```bash
# Detener un contenedor
docker stop nombre-del-contenedor

# Eliminar un contenedor
docker rm nombre-del-contenedor

# Limpiar todo lo que no se usa
docker system prune
```

---

## Error de permisos al conectar con Docker

Si al correr `docker compose up -d` aparece este error:

```text
permission denied while trying to connect to the Docker API at unix:///var/run/docker.sock
```

**Por que pasa**

Docker usa un socket Unix (`/var/run/docker.sock`) que por defecto solo puede usar `root`. Tu usuario normal no tiene acceso.

**Solucion paso a paso**

```bash
# 1. Agrega tu usuario al grupo docker
sudo usermod -aG docker $USER

# 2. Aplica el cambio sin cerrar sesion
newgrp docker

# 3. Verifica que ya tienes acceso
docker ps
```

> Si despues del `newgrp docker` aun falla, reinicia la sesion completa (cierra y vuelve a entrar al sistema).

Una vez resuelto, ya no necesitaras `sudo` para ningun comando de Docker.

---

## Error de puerto ya en uso

Si al levantar los servicios aparece:

```text
Error: ports are not available: listen tcp 0.0.0.0:5433: bind: address already in use
```

**Por que pasa**

Otro proceso (o contenedor de un proyecto anterior) ya esta usando ese puerto.

**Solucion cambiar el puerto externo en docker-compose.yml**

```yaml
ports:
  - "5434:5432"   # cambia el numero de la izquierda
```

> El formato es `puerto_de_tu_pc:puerto_dentro_del_contenedor`. El de la derecha **no lo cambies**.

---

## Conectar con PostgreSQL desde la terminal

```bash
psql -h localhost -p 5434 -U biblioteca_user -d biblioteca_db
```

Cuando pida contrasena: `biblioteca_pass`

> Cambia el puerto `-p` si lo modificaste en `docker-compose.yml`.

---

## Conectar con pgAdmin

1. Abre el navegador en **http://localhost:8082**
2. Inicia sesion:
   * Email: `admin@biblioteca.com`
   * Password: `admin123`
3. Clic en **Add New Server** y completa:

| Campo | Valor |
| --- | --- |
| Host | `postgres` |
| Port | `5432` |
| Database | `biblioteca_db` |
| Username | `biblioteca_user` |
| Password | `biblioteca_pass` |

> El Host dentro de pgAdmin es `postgres` (nombre del servicio), **no** `localhost`.

---

## Ver y eliminar imagenes de Docker

```bash
# Ver todas las imagenes descargadas
docker images

# Eliminar una imagen
docker rmi nombre-de-la-imagen

# Eliminar imagenes sin usar
docker image prune
```

---

## Reiniciar un servicio especifico

```bash
docker compose restart nombre-del-servicio

# Ejemplo:
docker compose restart postgres
```

---

## Ver todos los contenedores

```bash
docker ps -a
```
