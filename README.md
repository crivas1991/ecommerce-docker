# Ecommerce Docker — Next.js + Laravel + MySQL

Ecosistema de producción de una tienda en línea, contenerizado con **builds multi-stage** y orquestado con **Docker Compose**. Se levanta completo con un solo comando.

## 👥 Grupo 4

| Integrante |
|---|
| Carlos Alberto Rivas Castro |
| Francisco Javier Chavez Hernandez |
| Roberto Antonio Gomez Solorzano |
| Estefania Elizabeth Hernandez Nunez |
| Elmer Alexander Lopez Caneles |

| Servicio | Tecnología | Imagen | Puerto |
|---|---|---|---|
| `frontend` | Next.js 16 (App Router) + React 19 + Tailwind 4 | `node:20-alpine` (multi-stage, standalone) | `3000` |
| `backend` | Laravel 12 + PHP 8.2 (PHP-FPM + Nginx), Sanctum, Stripe, Swagger | `php:8.2-fpm-alpine` (multi-stage) | `8000` |
| `db` | MySQL 8.0 | `mysql:8.0` (oficial) | `3306` solo interno |

Las dos aplicaciones se desarrollaron durante el bootcamp:
- Frontend: [crivas1991/ecommerce-frontend](https://github.com/crivas1991/ecommerce-frontend). Detalle funcional (rutas, autenticación, flujo de pago, evidencias) en [`frontend/README.md`](frontend/README.md).
- API: [crivas1991/ecommerce-api](https://github.com/crivas1991/ecommerce-api). Endpoints, validaciones y manejo de errores en [`backend/README.md`](backend/README.md).

> Los README de cada carpeta describen cómo correr cada app **sin Docker** (desarrollo). Este README describe el ecosistema contenerizado.

---

## Inicio rápido

Requisitos: Docker 24+ con Docker Compose v2.

```bash
git clone https://github.com/crivas1991/ecommerce-docker.git
cd ecommerce-docker

cp .env.example .env        # en PowerShell: Copy-Item .env.example .env
# (opcional) edita .env: contraseñas, APP_KEY, claves de Stripe

docker compose up -d --build
```

Cuando los tres servicios aparezcan como `healthy` (`docker compose ps`):

| URL | Qué es |
|---|---|
| http://localhost:3000 | Tienda (frontend) |
| http://localhost:8000/api/products | API REST |
| http://localhost:8000/api/documentation | Documentación Swagger |
| http://localhost:8000/up | Health check de Laravel |

**Usuario demo:** `test@example.com` / `password`

> **Pagos con Stripe:** para probar el checkout, coloca tus claves de **modo test** (`STRIPE_KEY`, `STRIPE_SECRET`, `STRIPE_WEBHOOK_SECRET`) en `.env` y recrea el backend con `docker compose up -d backend`. Tarjeta de prueba: `4242 4242 4242 4242`, cualquier fecha futura y cualquier CVC. Sin claves funciona todo excepto el botón de pago.

Comandos útiles:

```bash
docker compose ps                 # estado y health de cada servicio
docker compose logs -f backend    # logs de un servicio
docker compose down               # detener (los datos de MySQL se conservan)
docker compose down -v            # detener y borrar el volumen (reinicia la BD desde db/init)
```

---

## Arquitectura de contenedores

```
                         Host (navegador)
                 :3000 │                │ :8000
                       ▼                ▼
   ┌───────────── frontend-net ─────────────────────────┐
   │  ┌──────────────────┐    HTTP     ┌──────────────────────────┐
   │  │ frontend         │ ──────────▶ │ backend                  │
   │  │ Next.js (node)   │  backend:   │ Nginx :8000              │
   │  │ usuario: nextjs  │  8000/api   │   └─▶ PHP-FPM 127.0.0.1  │
   │  └──────────────────┘             │ usuario: www-data        │
   │                                   └────────────┬─────────────┘
   └────────────────────────────────────────────────┼─────────────┘
                                                    │ db:3306
   ┌───────────── backend-net (internal) ───────────┼─────────────┐
   │                                   ┌────────────▼─────────────┐
   │                                   │ db  MySQL 8.0            │
   │                                   │ volumen: db-data         │
   │                                   │ init: ./db/init/*.sql    │
   │                                   └──────────────────────────┘
   └──────────────────────────────────────────────────────────────┘
```

- **Dos redes aisladas.** `frontend-net` une frontend y backend. `backend-net` une backend y base de datos y es `internal`: no tiene salida a Internet ni acceso desde el host. El frontend **no puede** llegar a MySQL.
- **MySQL sin puertos publicados.** Solo la API accede a él, por `db:3306`.
- **El frontend llama a la API desde el servidor.** Todas las peticiones salen de Server Components y Server Actions de Next con `API_BASE_URL=http://backend:8000/api`, por la red interna de Docker. El token de sesión vive en una cookie httpOnly y nunca llega al JavaScript del navegador.
- **Orden de arranque con health checks.** `db` (healthy) → `backend` (healthy, después de cachear y migrar) → `frontend`.

### Estructura del repositorio

```
ecommerce-docker/
├── docker-compose.yml        # Orquestación de los 3 servicios
├── .env.example              # Variables documentadas (copiar a .env)
├── db/
│   └── init/01-ecommerce.sql # Esquema + catálogo + usuario demo (primer arranque)
├── frontend/                 # Código Next.js
│   ├── Dockerfile
│   └── .dockerignore
└── backend/                  # Código Laravel
    ├── Dockerfile
    ├── .dockerignore
    └── docker/
        ├── entrypoint.sh     # Cachés de Laravel, migraciones, arranque FPM + Nginx
        ├── nginx/nginx.conf  # Proxy inverso a PHP-FPM (no root, puerto 8000)
        └── php/              # opcache.ini, zz-fpm.conf
```

---

## Resultados de la optimización

Comparación con un Dockerfile "ingenuo" de una sola etapa (imagen completa, `COPY . .` al inicio, dependencias de desarrollo incluidas):

| Imagen | Ingenua (1 etapa) | Optimizada (multi-stage) | Reducción |
|---|---|---|---|
| frontend | 2.65 GB (`node:20`, todo `node_modules` + código fuente) | **262 MB** | **−90 %** |
| backend | 2.09 GB (`php:8.2-fpm` Debian + Node + Composer + dev deps) | **194 MB** | **−91 %** |

**Caché de capas.** Tiempo de rebuild después de cambiar una línea de código, sin tocar las dependencias:

| Imagen | Ingenua | Optimizada | Qué se reutiliza |
|---|---|---|---|
| frontend | 118 s | **58 s** | `npm ci` queda en caché; solo se repite `next build` |
| backend | 77 s | **15 s** | Extensiones PHP, `composer install` y `npm install` quedan en caché |

*Mediciones en Docker Desktop 28.3 (Windows 11). Los números varían según la máquina, pero la proporción se mantiene.*

---

## Decisiones técnicas

### Frontend — `frontend/Dockerfile`

Tres etapas: **`deps` → `builder` → `runner`**.

| Decisión | Por qué |
|---|---|
| Base `node:20-alpine` | Alpine pesa ~5 MB frente a ~350 MB de Debian y reduce la superficie de ataque. Next 16 exige Node ≥ 20.9. |
| `COPY package.json package-lock.json` antes que el código | Caché de capas: `npm ci` solo se repite si cambian las dependencias, no en cada cambio de código. |
| `npm ci` + caché de BuildKit (`--mount=type=cache`) | Instalación exacta y reproducible desde el lockfile. La caché de npm acelera los rebuilds sin quedar dentro de la imagen. |
| `output: "standalone"` en `next.config.ts` | `next build` traza qué archivos de `node_modules` usa de verdad la app y genera un `server.js` mínimo. La imagen final **no lleva** `node_modules` completo, ni devDependencies (TypeScript, ESLint, Tailwind), ni código fuente. |
| `CMD ["node", "server.js"]` | Es el equivalente de producción de `next start` para la salida standalone, y es como lo documenta Next.js para Docker. Ejecutar `node` directamente (sin `npm`) hace que las señales `SIGTERM` lleguen al proceso y el apagado sea limpio. |
| Se copian solo `.next/standalone`, `.next/static` y `public` | Son los únicos archivos necesarios para servir la app. |
| Usuario `nextjs` (UID 1001) | El proceso no corre como root. |
| `NEXT_TELEMETRY_DISABLED=1` | Sin telemetría en build ni en runtime. |
| `HEALTHCHECK` con `wget` | `wget` ya viene en Alpine (busybox), así que no hace falta instalar `curl`. |
| `API_BASE_URL` en runtime, no en build | No lleva prefijo `NEXT_PUBLIC_`: la misma imagen sirve para cualquier entorno, cambiando solo la variable. |

### Backend — `backend/Dockerfile`

Cuatro etapas: **`base` → `vendor` → `assets` → `runtime`**.

| Decisión | Por qué |
|---|---|
| Base `php:8.2-fpm-alpine` | Imagen oficial mínima con PHP-FPM. |
| Solo se instalan `pdo_mysql` y `opcache` | La imagen oficial ya trae compiladas `mbstring`, `openssl`, `tokenizer`, `xml`, `ctype` y `json`; el build lo **verifica** con `php -m`. `docker-php-ext-install` instala y elimina los compiladores en la misma capa. |
| Etapa `base` compartida | `vendor` y `runtime` parten de la misma base, así Composer resuelve contra exactamente las mismas extensiones y versión de PHP que producción. |
| Etapa `vendor`: `composer install --no-dev --no-scripts --no-autoloader` | Primero solo `composer.json/lock` para aprovechar la caché. Sin paquetes de desarrollo (PHPUnit, Pint, Sail, Collision…). Después, con el código presente, `dump-autoload --optimize` genera un classmap optimizado. |
| Composer **no** está en la imagen final | El binario se copia desde `composer:2` solo en la etapa `vendor`. A `runtime` llega únicamente la carpeta `vendor/`. |
| Etapa `assets` con `node:20-alpine` | Compila con Vite los assets de la vista de bienvenida de Laravel. A la imagen final solo llega `public/build`: ni Node ni `node_modules`. |
| Nginx + PHP-FPM en el mismo contenedor | Mantiene la arquitectura de 3 servicios del enunciado. FPM escucha solo en `127.0.0.1:9000`, así que no es accesible desde fuera del contenedor. Nginx corre en primer plano como PID 1 y FPM en segundo plano. Si FPM falla, `/up` responde 502 y el health check marca el contenedor como unhealthy. |
| `php.ini-production` + OPcache con `validate_timestamps=0` | Configuración endurecida de PHP. El código no cambia dentro de la imagen, así que OPcache no revisa los archivos en cada petición. |
| Todo corre como `www-data`, Nginx en el puerto 8000 | Al usar un puerto mayor que 1024 no hacen falta privilegios de root. El pid y los temporales de Nginx van a `/tmp`. |
| El código es propiedad de root; solo `storage/` y `bootstrap/cache/` pertenecen a `www-data` | Aunque una vulnerabilidad permitiera ejecutar código, no podría modificar la aplicación. |
| `server_tokens off`, `expose_php=Off`, solo se ejecuta `index.php` | No se filtran versiones y no se pueden ejecutar otros `.php`. |
| `config:cache`, `route:cache`, `view:cache` y `event:cache` en el **entrypoint** | Dependen de las variables de entorno, que solo existen en runtime. Así una misma imagen sirve para varios entornos. |
| `migrate --force` al arrancar (`RUN_MIGRATIONS`) | La base queda al día automáticamente. Si ya está al día, no hace nada. |
| Logs a `stderr`/`stdout` | Se ven con `docker compose logs` y no se acumulan archivos dentro del contenedor. |
| `.dockerignore` | Excluye `vendor`, `node_modules`, `.env`, `.git` y `tests`. El contexto de build es más pequeño y no se filtran secretos a la imagen. |

### Base de datos — `mysql:8.0`

| Decisión | Por qué |
|---|---|
| Imagen oficial, sin Dockerfile propio | No necesita personalización. Se configura con `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER` y `MYSQL_PASSWORD`. |
| Volumen con nombre `db-data` → `/var/lib/mysql` | Los datos sobreviven a `docker compose down` y a la recreación del contenedor. |
| `./db/init` → `/docker-entrypoint-initdb.d` (solo lectura) | En el primer arranque carga el esquema, el catálogo de 25 productos y la tabla `migrations`, de modo que Laravel no repite migraciones. El dump original se depuró para el repo público: se quitaron usuarios reales, tokens, sesiones, pedidos y pagos, y se dejó un usuario demo. |
| La API usa `MYSQL_USER`, no root | Principio de mínimo privilegio. |
| Sin `ports` | El 3306 no se expone al host, como se pide para producción. |
| Health check con `mysqladmin ping` por TCP | Durante la inicialización MySQL solo escucha por socket, así que el servicio no se marca healthy, y el backend no arranca, hasta que el script SQL termina de cargarse. |

### Docker Compose

- `depends_on` con `condition: service_healthy` en lugar del simple orden de arranque.
- `restart: unless-stopped` en todos los servicios.
- `security_opt: no-new-privileges` en los contenedores de aplicación.
- Las contraseñas obligatorias usan `${VAR:?mensaje}`: si falta alguna, Compose falla con un mensaje claro en lugar de arrancar con valores vacíos.
- `.gitattributes` fuerza finales de línea LF en scripts y configuraciones, para que `entrypoint.sh` funcione aunque el repo se clone en Windows.

---

## Variables de entorno

Todas están documentadas en [`.env.example`](.env.example). Las principales:

| Variable | Uso |
|---|---|
| `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD` | Contraseñas de MySQL (**obligatorias**) |
| `MYSQL_DATABASE`, `MYSQL_USER` | Base y usuario que usa la API |
| `APP_KEY` | Clave de Laravel. Si se deja vacía se genera una temporal en cada arranque |
| `APP_DEBUG` | `false` en producción |
| `STRIPE_KEY`, `STRIPE_SECRET`, `STRIPE_WEBHOOK_SECRET` | Pagos con Stripe (opcionales; sin ellas todo funciona menos el pago) |
| `COOKIE_SECURE` | `true` por defecto. `false` solo para probar por HTTP desde otra máquina de la red (junto con `FRONTEND_URL=http://<IP>:3000`) |
| `FRONTEND_PORT`, `BACKEND_PORT` | Puertos publicados en el host |

---

## Acceso a MySQL en desarrollo (opcional)

En producción el puerto 3306 no se publica. Para inspeccionar la base con DBeaver, Workbench o similares en local, crea un `docker-compose.override.yml`. Compose lo carga automáticamente y está en `.gitignore`:

```yaml
services:
  db:
    ports:
      - "127.0.0.1:3307:3306"   # solo accesible desde tu propia máquina
    networks: [backend-net, db-admin-net]

networks:
  db-admin-net:   # backend-net es "internal" y no permite publicar puertos
```

Después ejecuta `docker compose up -d db` y conéctate a `127.0.0.1:3307` con `MYSQL_USER` / `MYSQL_PASSWORD`. En DBeaver, si aparece *"Public Key Retrieval is not allowed"*, activa `allowPublicKeyRetrieval=true` en las propiedades del driver.

---

## Solución de problemas

| Síntoma | Causa / solución |
|---|---|
| `port is already allocated` | Otro programa usa el 3000 o el 8000. Cambia `FRONTEND_PORT` / `BACKEND_PORT` en `.env`. |
| `required variable MYSQL_PASSWORD is missing` | Falta el `.env`: ejecuta `cp .env.example .env`. |
| Cambié contraseñas de MySQL y el backend no conecta | MySQL solo las aplica al crear el volumen. Ejecuta `docker compose down -v` (borra los datos) y vuelve a levantar. |
| El login no se mantiene desde otra máquina de la red | Por HTTP los navegadores descartan la cookie `secure`. Pon `COOKIE_SECURE=false` y `FRONTEND_URL=http://<IP>:3000` en `.env` y ejecuta `docker compose up -d`. |
| No carga desde otra máquina | Firewall de Windows: permite la entrada TCP al puerto 3000 en redes privadas. |
| El botón de pago da error 500 | Faltan las claves de Stripe en `.env` (ver "Pagos con Stripe" arriba). |
