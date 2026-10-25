# syntax=docker/dockerfile:1
# =============================================================================
# Backend Laravel — build multi-stage
#   1. base    → php:8.2-fpm-alpine + extensiones PHP (compartida por build y runtime)
#   2. vendor  → Composer instala dependencias de producción (sin require-dev)
#   3. assets  → Node compila los assets de Vite (public/build)
#   4. runtime → base + Nginx + código + vendor/ + public/build, usuario no root
# =============================================================================

# -----------------------------------------------------------------------------
# Etapa 1: base con extensiones
# La imagen oficial ya trae compiladas mbstring, openssl, tokenizer, xml, ctype
# y json; solo falta pdo_mysql (driver de MySQL) y opcache (rendimiento).
# docker-php-ext-install instala y elimina las herramientas de compilación
# en la misma capa, así no quedan en la imagen.
# -----------------------------------------------------------------------------
FROM php:8.2-fpm-alpine AS base

RUN docker-php-ext-install -j"$(nproc)" pdo_mysql opcache \
 && php -m | grep -qiE '^(pdo_mysql|mbstring|openssl|tokenizer|xml|ctype|json)$'

WORKDIR /var/www/html

# -----------------------------------------------------------------------------
# Etapa 2: dependencias de Composer
# Primero solo composer.json/lock → la capa de `composer install` se reutiliza
# mientras las dependencias no cambien.
# -----------------------------------------------------------------------------
FROM base AS vendor

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./
RUN --mount=type=cache,target=/root/.composer/cache \
    composer install \
      --no-dev \
      --no-interaction \
      --no-progress \
      --no-scripts \
      --no-autoloader \
      --prefer-dist

# Con el código ya presente se genera el autoloader optimizado (classmap)
COPY . .
RUN composer dump-autoload --no-dev --optimize --no-scripts

# -----------------------------------------------------------------------------
# Etapa 3: assets front de Laravel (Vite + Tailwind)
# -----------------------------------------------------------------------------
FROM node:20-alpine AS assets
WORKDIR /app

COPY package.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm install --no-audit --no-fund

COPY vite.config.js ./
COPY resources ./resources
RUN npm run build

# -----------------------------------------------------------------------------
# Etapa 4: runtime
# -----------------------------------------------------------------------------
FROM base AS runtime

# Nginx como proxy inverso hacia PHP-FPM dentro del mismo contenedor +
# configuración de producción de PHP (una sola capa)
RUN apk add --no-cache nginx \
 && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY docker/php/opcache.ini      $PHP_INI_DIR/conf.d/opcache.ini
COPY docker/php/zz-fpm.conf      /usr/local/etc/php-fpm.d/zz-fpm.conf
COPY docker/nginx/nginx.conf     /etc/nginx/nginx.conf
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh

# De las etapas de build solo se traen los artefactos: vendor/ y public/build.
# Van antes que el código porque cambian con menos frecuencia (mejor caché).
COPY --from=vendor /var/www/html/vendor ./vendor
COPY --from=assets /app/public/build    ./public/build

# Código de la aplicación: solo lo que Laravel necesita en runtime.
# Quedan fuera package.json, vite.config.js, resources/js|css (ya compilados
# en public/build) y la carpeta docker/. Propiedad de root: www-data solo lee.
COPY artisan composer.json ./
COPY app             ./app
COPY bootstrap       ./bootstrap
COPY config          ./config
COPY database        ./database
COPY public          ./public
COPY resources/views ./resources/views
COPY routes          ./routes
COPY storage         ./storage

# Descubrimiento de paquetes de producción + enlace de storage.
# Solo storage/ y bootstrap/cache/ quedan escribibles para www-data.
RUN php artisan package:discover --ansi \
 && php artisan storage:link \
 && chown -R www-data:www-data storage bootstrap/cache

USER www-data

EXPOSE 8000

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO /dev/null http://127.0.0.1:8000/up || exit 1

# SIGQUIT = apagado ordenado de Nginx (termina las peticiones en curso)
STOPSIGNAL SIGQUIT

ENTRYPOINT ["entrypoint.sh"]
