#!/bin/sh
# Arranque del contenedor backend: prepara Laravel con la configuración del
# entorno (variables de docker compose) y lanza PHP-FPM + Nginx.
set -e

cd /var/www/html

if [ -z "$APP_KEY" ]; then
  echo "[entrypoint] AVISO: APP_KEY vacío; se genera una clave temporal." >&2
  echo "[entrypoint] Define APP_KEY en .env para que sea estable entre reinicios." >&2
  APP_KEY="base64:$(head -c 32 /dev/urandom | base64)"
  export APP_KEY
fi

# Las cachés se generan aquí (no en el build) porque dependen de las variables
# de entorno que llegan en tiempo de ejecución.
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
  php artisan migrate --force
fi

# PHP-FPM en segundo plano (escucha en 127.0.0.1:9000) y Nginx en primer plano
php-fpm -D
exec nginx -e /dev/stderr -g 'daemon off;'
