# Bienvenido/a

Este proyecto fue desarrollado para la asignatura ISY1102 - Calidad y seguridad en el desarrollo de software. En este repositorio se incluye un Frontend y Backend asociados al Caso A de la asignatura llamado "Sistema de Gestión Cuidarte+".

Cuidarte+ permitirá a médicos registrar pacientes y exámenes médicos, a pacientes visualizar su información clínica y a administradores supervisar, auditar y administrar usuarios y datos del sistema, adicionalmente se debe garantizar el cumplimiento de normativa de protección de datos y estándares de seguridad.

Este proyecto está pensando para ser utilizado de las siguientes maneras:
 - Podrás inicializar el backend y frontend por separado y según tu lo requieras
 - Podrás efectuar análisis de código estático para frontend y backend.
 - Podrás efectuar análisis de código dinámico al levantar ambos servicios.
 - Utilizar docker en lugar de levantar manualmente cada servicio ya que se incluye una imagen para el proyecto completo que inicializa y configura cada elemento del software construido.
 

## Estructura

Abre el proyecto mediante terminal o editor de código de preferencia Visual Studio Code. El software tiene la siguiente estructura de carpetas y archivos
 
```
root
	|/BACKEND
	|/FRONTEND
	|.env
	|.gitignore
	|docker-compose.yml
	|package.json
	|README.md
```
En el archivo `.env` local se definen las variables de entorno que utilizará Docker. No compartas ni subas ese archivo al repositorio.

1. `JWT_SECRET`: llave aleatoria y exclusiva del ambiente para firmar tokens; nunca publiques su valor ni reutilices credenciales académicas en producción.
2. PORT_POSTGRES: `15442` Puerto expuesto que utilizará tu equipo para permitir acceder a la conexión a la base de datos
3. PORT_BACKEND: `4444` Puerto expuesto que utilizará tu equipo para acceder a la API
4. PORT_FRONTEND: `3333` Puerto expuesto que utilizará tu equipo para acceder al cliente - frontend

## Inicialización con Docker
Abre la terminal y situate en la raíz del proyecto y ejecuta el comando:

1. Ejecuta `docker-compose up -d` para levantar todos los servicios
2. El frontend estará disponible en `http://localhost:3333` (o el puerto configurado en .env)
3. El backend estará disponible en `http://localhost:4444` (o el puerto configurado en .env)
4. La base de datos estará disponible para conectarse mediante:
	4.1 Host: `localhost`
	4.2 Port: `15442 `(o el configurado en .env)
	4.3 Database: `cuidarteplus`
	4.4 Nombre de usuario: `postgres`
	4.5 Contraseña: `postgres`
## Inicialización local

Desde la raíz del proyecto, instala las dependencias y luego inicia ambos servicios:

```bash
npm run install
npm start
```

El backend queda disponible en `http://localhost:3000` y Vite en `http://localhost:5173`.
Para conectar el backend a PostgreSQL, configura `DATABASE_URL` y `JWT_SECRET` en el entorno
antes de iniciar el proyecto. El inicio con Docker mantiene su configuración de puertos
independiente.

## CI/CD en GitHub

El workflow de `.github/workflows/ci-cd.yml` valida cada pull request ejecutando
`npm ci`, ESLint y la compilación del frontend, además de revisar la sintaxis del backend,
ejecutar `npm test` con base de datos simulada y construir ambas imágenes Docker. Al hacer push a la rama predeterminada o publicar una etiqueta `v*`, publica
las imágenes del backend y frontend en GitHub Container Registry (GHCR). La publicación usa
`GITHUB_TOKEN`; no requiere un token personal. En la configuración del repositorio, habilita
Actions con permiso de escritura de paquetes si la política de la organización lo exige.

Las imágenes se etiquetan como `latest` (rama predeterminada), por SHA y, para etiquetas de
versión como `v1.2.3`, como `1.2.3` y `1.2`. El nombre es
`ghcr.io/<propietario>/<repositorio>-backend` o `-frontend`. Define la variable de Actions
`VITE_API_URL` con la URL pública de la API antes de publicar para que el frontend apunte al
backend correcto; si no se define, se usa `http://localhost:4444`. Este CD entrega imágenes
en GHCR, pero no despliega automáticamente en un servidor de producción.

Las pruebas de API se ejecutan sin una base PostgreSQL real mediante un adaptador simulado.
Ejecuta `npm.cmd test` dentro de `BACKEND`; esto no sustituye pruebas end-to-end con Docker.
Las imágenes de GHCR son privadas inicialmente;
ajusta su visibilidad en GitHub Packages si necesitas descargarlas públicamente.
