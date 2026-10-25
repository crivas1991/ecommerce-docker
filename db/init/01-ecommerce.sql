-- =====================================================================
-- Script de inicialización de MySQL (se ejecuta solo la primera vez,
-- cuando el volumen de datos está vacío).
--
-- Origen: dump de la base local del proyecto, depurado para un repo
-- público:
--   * Se conservan: estructura completa, catálogo de productos y la
--     tabla `migrations` (así `php artisan migrate` no repite nada).
--   * Se eliminan: usuarios reales, tokens, sesiones, pedidos y pagos.
--   * Usuario demo: test@example.com / password
-- =====================================================================

-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_08_29_023211_create_personal_access_tokens_table',1),(5,'2026_08_29_030834_create_products_table',1),(6,'2026_08_29_030836_create_orders_table',1),(7,'2026_08_29_030837_create_order_items_table',1),(8,'2026_08_29_030838_create_payments_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_product_id_foreign` (`product_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(3) NOT NULL DEFAULT 'usd',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_user_id_foreign` (`user_id`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `stripe_payment_intent_id` varchar(255) DEFAULT NULL,
  `stripe_checkout_session_id` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `amount` decimal(10,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'usd',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payments_stripe_payment_intent_id_unique` (`stripe_payment_intent_id`),
  UNIQUE KEY `payments_stripe_checkout_session_id_unique` (`stripe_checkout_session_id`),
  KEY `payments_order_id_foreign` (`order_id`),
  CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(10) unsigned NOT NULL DEFAULT 0,
  `image_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `deleted_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_slug_unique` (`slug`),
  KEY `products_created_by_foreign` (`created_by`),
  KEY `products_updated_by_foreign` (`updated_by`),
  KEY `products_deleted_by_foreign` (`deleted_by`),
  CONSTRAINT `products_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_deleted_by_foreign` FOREIGN KEY (`deleted_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Wireless Bluetooth Headphones','wireless-bluetooth-headphones','High quality wireless bluetooth headphones, perfect for everyday use.',59.99,31,'https://picsum.photos/seed/wireless-bluetooth-headphones/640/480',1,NULL,3,NULL,'2026-08-30 10:29:12','2026-10-04 10:43:34',NULL),(2,'Mechanical Keyboard RGB','mechanical-keyboard-rgb','High quality mechanical keyboard rgb, perfect for everyday use.',89.99,24,'https://picsum.photos/seed/mechanical-keyboard-rgb/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-10-05 08:59:04',NULL),(3,'Wireless Mouse','wireless-mouse','High quality wireless mouse, perfect for everyday use.',24.99,56,'https://picsum.photos/seed/wireless-mouse/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-10-04 22:38:12',NULL),(4,'27-inch 4K Monitor','27-inch-4k-monitor','High quality 27-inch 4k monitor, perfect for everyday use.',349.99,15,'https://picsum.photos/seed/27-inch-4k-monitor/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(5,'USB-C Hub 7-in-1','usb-c-hub-7-in-1','High quality usb-c hub 7-in-1, perfect for everyday use.',34.99,50,'https://picsum.photos/seed/usb-c-hub-7-in-1/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(6,'Portable SSD 1TB','portable-ssd-1tb','High quality portable ssd 1tb, perfect for everyday use.',99.99,29,'https://picsum.photos/seed/portable-ssd-1tb/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-10-05 08:59:04',NULL),(7,'Smartphone Stand','smartphone-stand','High quality smartphone stand, perfect for everyday use.',14.99,100,'https://picsum.photos/seed/smartphone-stand/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(8,'Noise Cancelling Earbuds','noise-cancelling-earbuds','High quality noise cancelling earbuds, perfect for everyday use.',79.99,45,'https://picsum.photos/seed/noise-cancelling-earbuds/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(9,'Webcam Full HD 1080p','webcam-full-hd-1080p','High quality webcam full hd 1080p, perfect for everyday use.',44.99,35,'https://picsum.photos/seed/webcam-full-hd-1080p/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(10,'Laptop Backpack','laptop-backpack','High quality laptop backpack, perfect for everyday use.',39.99,55,'https://picsum.photos/seed/laptop-backpack/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(11,'Smartwatch Series X','smartwatch-series-x','High quality smartwatch series x, perfect for everyday use.',199.99,20,'https://picsum.photos/seed/smartwatch-series-x/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(12,'Portable Bluetooth Speaker','portable-bluetooth-speaker','High quality portable bluetooth speaker, perfect for everyday use.',49.99,39,'https://picsum.photos/seed/portable-bluetooth-speaker/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-10-05 08:59:04',NULL),(13,'Ergonomic Office Chair','ergonomic-office-chair','High quality ergonomic office chair, perfect for everyday use.',249.99,10,'https://picsum.photos/seed/ergonomic-office-chair/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(14,'Standing Desk Converter','standing-desk-converter','High quality standing desk converter, perfect for everyday use.',179.99,12,'https://picsum.photos/seed/standing-desk-converter/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(15,'Wireless Charging Pad','wireless-charging-pad','High quality wireless charging pad, perfect for everyday use.',19.99,70,'https://picsum.photos/seed/wireless-charging-pad/640/480',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(16,'Minima nulla dignissimos','minima-nulla-dignissimos-333','Maxime eum animi voluptatibus illo. Assumenda mollitia et ut autem quaerat corrupti excepturi.',231.21,39,'https://via.placeholder.com/640x480.png/0022ff?text=products+unde',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(17,'Delectus consequatur explicabo','delectus-consequatur-explicabo-671','Labore et quisquam consequatur beatae possimus officiis possimus. Ipsam sint voluptatem accusamus id sed molestias et. Eum et consequatur qui dicta quidem dolores.',124.55,35,'https://via.placeholder.com/640x480.png/00ff55?text=products+voluptas',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(18,'Nobis sint possimus','nobis-sint-possimus-739','Sit sed omnis enim voluptates maiores ipsam. Sapiente consequuntur at ut reprehenderit quaerat molestiae natus. Ex neque magni fugiat qui molestias eos. Ipsum ea velit sed assumenda aut aliquid.',53.76,83,'https://via.placeholder.com/640x480.png/00ddbb?text=products+labore',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(19,'Architecto officiis eum','architecto-officiis-eum-876','Ab ut quisquam non voluptate. Sit eos eos rerum aut. Corrupti sed esse accusantium aliquam nulla.',270.95,87,'https://via.placeholder.com/640x480.png/00bb22?text=products+doloremque',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(20,'Ut consequatur quia','ut-consequatur-quia-126','Cum qui molestiae aut. Reprehenderit culpa quia voluptas ea laudantium. Totam ut dicta maiores culpa aliquam.',184.87,30,'https://via.placeholder.com/640x480.png/00ffbb?text=products+asperiores',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(21,'Ut quia et','ut-quia-et-460','Aliquid corrupti rem ut corporis alias qui ducimus tenetur. Aut quo eveniet repellendus sed. Qui et sint voluptas eligendi qui cumque.',294.51,26,'https://via.placeholder.com/640x480.png/00dd44?text=products+totam',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(22,'Sequi doloribus odit','sequi-doloribus-odit-066','Nostrum eius id adipisci sed veritatis rerum. Adipisci molestias quia doloremque delectus laborum omnis. Voluptates minima et error adipisci.',366.31,77,'https://via.placeholder.com/640x480.png/0033ff?text=products+eos',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(23,'Dicta rerum itaque','dicta-rerum-itaque-329','Est impedit ea repellat mollitia quae. Nihil illo sit repellendus fugit voluptas ex. Libero natus dicta ut et alias porro. Nemo quidem earum ut dolores et molestias provident. Perferendis sint provident neque voluptas voluptas nulla.',318.73,27,'https://via.placeholder.com/640x480.png/00ff33?text=products+quibusdam',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(24,'Est sed vero','est-sed-vero-690','Rerum architecto voluptas facilis quod laudantium. Hic ut voluptatem et cumque voluptate voluptatibus odio commodi. Optio quis hic mollitia recusandae nulla. Eos consequatur voluptatem earum praesentium.',189.21,65,'https://via.placeholder.com/640x480.png/0055cc?text=products+ipsum',1,NULL,NULL,NULL,'2026-08-30 10:29:12','2026-08-30 10:29:12',NULL),(25,'Odio omnis et','odio-omnis-et-982','Impedit odio alias hic necessitatibus aut aliquid. Voluptates laboriosam magnam repudiandae earum.',470.90,92,'https://via.placeholder.com/640x480.png/000022?text=products+enim',1,NULL,3,NULL,'2026-08-30 10:29:12','2026-08-30 10:48:30',NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Test User','test@example.com','2026-08-30 10:29:11','$2y$12$WCleP/jv1ZWLy994tD5lrecNOoJusD5Kr0hlBsXVbmpm9lYWuAHki',1,NULL,'2026-08-30 10:29:11','2026-08-30 10:29:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ecommerce'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

