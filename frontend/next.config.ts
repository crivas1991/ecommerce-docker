import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Genera .next/standalone: servidor mínimo + solo las dependencias que realmente usa
  // la app. Es lo que copia la imagen Docker de producción (ver Dockerfile).
  output: "standalone",
  // Metadata (title/description) bloqueante para todos los clientes: queda en el <head>
  // desde el primer byte y los auditores SEO (Lighthouse) la ven siempre.
  htmlLimitedBots: /.*/,
  images: {
    // Hosts de imágenes que usa la API (el seeder usa picsum.photos). Agrega más si hace falta.
    remotePatterns: [
      { protocol: "https", hostname: "picsum.photos" },
      { protocol: "https", hostname: "fastly.picsum.photos" },
    ],
  },
};

export default nextConfig;
