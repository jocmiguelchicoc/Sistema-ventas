# Guía: Cómo subir tu proyecto a GitHub

Esta guía te explica de forma sencilla y directa los comandos que debes ejecutar en la terminal para subir tu carpeta `Sistema-ventas` a tu repositorio de GitHub.

---

## 🚀 Paso a Paso en la Terminal

### Paso 1: Abrir la terminal en la raíz del proyecto

Asegúrate de que tu terminal esté ubicada en la carpeta principal de tu repositorio local:
`/media/hackboy/SENA1/00 SENA/CUARTO TRIMESTRE/5. VIERNES`

### Paso 2: Verificar el estado de tus archivos

Antes de agregar nada, es una buena práctica ver qué archivos han cambiado o no están siendo rastreados por Git. Ejecuta:

```bash
git status
```

*Aquí deberías ver la carpeta `Sistema-ventas/` resaltada en rojo como **"Archivos sin seguimiento"**.*

### Paso 3: Agregar la carpeta del proyecto

Para preparar la carpeta de tu sistema de ventas y todas sus guías para el commit, ejecuta:

```bash
git add Sistema-ventas/
```

*(Si usas `git status` nuevamente después de esto, verás que la carpeta y sus archivos ahora aparecen en verde, listos para confirmarse).*

### Paso 4: Guardar los cambios localmente (Commit)

Crea una confirmación con un mensaje claro que describa lo que estás subiendo:

```bash
git commit -m "feat: agregar mini-proyecto de normalizacion de ventas y guias de apoyo"
```

### Paso 5: Enviar los cambios a GitHub (Push)

Como tu repositorio ya está enlazado a la rama principal (`main`) en GitHub, ejecuta:

```bash
git push origin main
```

---

## 🔑 Solución a problemas comunes

### 1. Error de autenticación (Username/Password)

Desde hace un tiempo, GitHub ya no permite usar tu contraseña directamente en la terminal. Si al hacer `git push` te pide usuario y contraseña, y te da error, debes usar un **Token de Acceso Personal (PAT)**:

1. Ve a GitHub: **Settings** -> **Developer Settings** -> **Personal Access Tokens** -> **Tokens (classic)**.
2. Genera un nuevo token con permisos de `repo` y cópialo.
3. En la terminal, cuando te pida `Password`, pega el token en lugar de tu contraseña normal.

### 2. Verificar que todo se subió correctamente

Una vez terminado el `git push`, ve en tu navegador a:
`https://github.com/jocmiguelchicoc/mini_proyecto_4toTrimestre_VIERNES`

Ahí deberías ver reflejada tu carpeta `Sistema-ventas` con todos sus archivos actuales.
