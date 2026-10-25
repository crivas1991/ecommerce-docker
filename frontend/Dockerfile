# syntax=docker/dockerfile:1
# =============================================================================
# Frontend Next.js — build multi-stage
#   1. deps    → instala TODAS las dependencias (incluye devDependencies para compilar)
#   2. builder → ejecuta `next build` y genera la salida standalone
#   3. runner  → imagen final: solo el servidor standalone + estáticos, usuario no root
# =============================================================================

ARG NODE_VERSION=20-alpine

# -----------------------------------------------------------------------------
# Etapa 1: dependencias
# Solo se copian package.json y package-lock.json: mientras no cambien, Docker
# reutiliza esta capa y `npm ci` no se vuelve a ejecutar aunque cambie el código.
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS deps
WORKDIR /app

# libc6-compat: compatibilidad glibc para binarios nativos (SWC, lightningcss) en Alpine/musl
RUN apk add --no-cache libc6-compat

COPY package.json package-lock.json ./
# Caché de npm montada en BuildKit: acelera rebuilds sin dejar la caché en la imagen
RUN --mount=type=cache,target=/root/.npm \
    npm ci --no-audit --no-fund

# -----------------------------------------------------------------------------
# Etapa 2: build de producción
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS builder
WORKDIR /app

ENV NEXT_TELEMETRY_DISABLED=1

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build

# -----------------------------------------------------------------------------
# Etapa 3: runtime
# Parte de una imagen limpia: no hay código fuente, ni devDependencies, ni npm cache.
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS runner
WORKDIR /app

ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000 \
    HOSTNAME=0.0.0.0

# Usuario sin privilegios para ejecutar la app
RUN addgroup -S -g 1001 nodejs \
 && adduser -S -u 1001 -G nodejs nextjs

# Servidor standalone (server.js + node_modules mínimos trazados por Next)
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# Assets estáticos y carpeta public (standalone no los incluye por defecto)
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO /dev/null http://127.0.0.1:3000/ || exit 1

# Equivalente de producción a `next start` para la salida standalone
CMD ["node", "server.js"]
