CREATE DATABASE  IF NOT EXISTS `test` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `test`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 192.168.56.101    Database: LocAwareNet
-- ------------------------------------------------------
-- Server version	5.7.22-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` varchar(10) NOT NULL,
  `lati_north` float NOT NULL,
  `longti_east` float NOT NULL,
  `lati_south` float NOT NULL,
  `longti_west` float NOT NULL,
  `delay_ms` float NOT NULL DEFAULT '0',
  `population` int(11) NOT NULL DEFAULT '0',
  `location` varchar(200) DEFAULT NULL,
  `ipv4_addr` int(11) DEFAULT NULL,
  `ipv6_addr` varbinary(16) DEFAULT NULL,
  `extra_info` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES ('s1',35.2625,126.765,35.1875,126.64,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s10',35.0875,126.915,35.0375,126.79,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s11',35.1375,126.965,35.0875,126.84,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s12',35.1875,127.04,35.0875,126.965,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s13',35.0875,127.04,35.0375,126.915,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s2',35.2625,126.865,35.1875,126.765,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s3',35.2625,126.965,35.1875,126.865,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s4',35.2625,127.04,35.1875,126.965,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s5',35.1875,126.965,35.1375,126.84,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s6',35.1875,126.84,35.1375,126.715,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s7',35.1375,126.84,35.0875,126.715,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s8',35.1875,126.715,35.0875,126.64,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37'),('s9',35.0875,126.79,35.0375,126.64,0,1,NULL,NULL,NULL,NULL,'2018-05-17 14:58:24','2018-07-25 03:21:37');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sw1` varchar(10) NOT NULL,
  `sw2` varchar(10) NOT NULL,
  `total_bw_mbps` int(11) NOT NULL DEFAULT '10',
  `bw12_mbps` int(11) NOT NULL DEFAULT '0',
  `bw21_mbps` int(11) NOT NULL DEFAULT '0',
  `delay_ms` float NOT NULL DEFAULT '0',
  `loss_rate` int(11) NOT NULL DEFAULT '0',
  `extra_info` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_links_sw1_idx` (`sw1`),
  KEY `fk_links_sw2_idx` (`sw2`),
  CONSTRAINT `fk_link_sw1_device` FOREIGN KEY (`sw1`) REFERENCES `devices` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_link_sw2_device` FOREIGN KEY (`sw2`) REFERENCES `devices` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links`
--

LOCK TABLES `links` WRITE;
/*!40000 ALTER TABLE `links` DISABLE KEYS */;
INSERT INTO `links` VALUES (1,'s1','s2',10,0,0,1,10,NULL,'2018-05-17 15:00:07','2018-07-27 06:36:41'),(2,'s1','s8',10,0,0,1,10,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(3,'s2','s3',10,0,0,1,5,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(4,'s3','s6',10,0,0,1,6,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(5,'s2','s6',10,0,0,1,5,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(6,'s4','s12',10,0,0,1,2,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(7,'s3','s4',10,0,0,1,6,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(8,'s5','s4',10,0,0,1,0,NULL,'2018-05-17 15:15:27','2018-07-25 08:36:29'),(9,'s5','s6',10,0,0,1,0,NULL,'2018-05-17 15:15:27','2018-07-25 08:36:29'),(10,'s5','s11',10,0,0,1,2,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(11,'s6','s7',10,0,0,1,1,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(12,'s7','s8',10,0,0,1,1,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(13,'s7','s10',10,0,0,1,5,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(14,'s7','s11',10,0,0,1,3,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(15,'s8','s9',10,0,0,1,2,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(16,'s9','s10',10,0,0,1,1,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(17,'s10','s11',10,0,0,1,0,NULL,'2018-05-17 15:15:27','2018-07-25 08:36:29'),(18,'s10','s13',10,0,0,1,1,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(19,'s11','s12',10,0,0,1,5,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(20,'s12','s13',10,0,0,1,2,NULL,'2018-05-17 15:15:27','2018-07-27 06:36:41'),(21,'s6','s10',10,0,0,1,3,NULL,'2018-07-24 07:56:16','2018-07-27 06:36:41');
/*!40000 ALTER TABLE `links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links_of_path`
--

DROP TABLE IF EXISTS `links_of_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links_of_path` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path_id` int(11) NOT NULL,
  `link_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_path_id_idx` (`path_id`),
  KEY `fk_link_id_idx` (`link_id`),
  CONSTRAINT `fk_link_id` FOREIGN KEY (`link_id`) REFERENCES `links` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_path_id` FOREIGN KEY (`path_id`) REFERENCES `paths` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links_of_path`
--

LOCK TABLES `links_of_path` WRITE;
/*!40000 ALTER TABLE `links_of_path` DISABLE KEYS */;
/*!40000 ALTER TABLE `links_of_path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paths`
--

DROP TABLE IF EXISTS `paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subnet_id` int(11) NOT NULL,
  `link_id` varchar(10) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `extra` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_flows_link_idx` (`link_id`),
  KEY `fk_flow_subnet_idx` (`subnet_id`),
  CONSTRAINT `fk_flow_subnet` FOREIGN KEY (`subnet_id`) REFERENCES `subnets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flows_link` FOREIGN KEY (`link_id`) REFERENCES `links` (`sw1`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paths`
--

LOCK TABLES `paths` WRITE;
/*!40000 ALTER TABLE `paths` DISABLE KEYS */;
/*!40000 ALTER TABLE `paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regions` (
  `id` int(11) NOT NULL,
  `lati_north` float NOT NULL,
  `longti_east` float NOT NULL,
  `lati_south` float NOT NULL,
  `longti_west` float NOT NULL,
  `ipv4_addr` int(11) DEFAULT NULL,
  `ipv6_addr` varbinary(16) DEFAULT NULL,
  `device_id` varchar(10) DEFAULT NULL,
  `extra_info` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_region_device_idx` (`device_id`),
  CONSTRAINT `fk_region_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (20,35.0875,126.74,35.0625,126.74,NULL,'','s9','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(24,35.0875,126.84,35.0625,126.84,NULL,'','s10','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(25,35.0875,126.865,35.0625,126.865,NULL,'','s10','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(29,35.0875,126.965,35.0625,126.965,NULL,'','s3','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(37,35.1125,126.765,35.0875,126.765,NULL,'','s7','NULL','2018-05-15 14:13:16','2018-05-15 14:13:16'),(45,35.1125,126.965,35.0875,126.965,NULL,'','s11','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(72,35.1625,126.84,35.1375,126.84,NULL,'','s6','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(76,35.1625,126.94,35.1375,126.94,NULL,'','s5','NULL','2018-05-15 14:13:16','2018-07-24 07:44:30'),(101,35.2125,126.765,35.1875,126.765,NULL,'','s1','NULL','2018-05-15 14:13:16','2018-05-15 14:13:16'),(109,35.2125,126.965,35.1875,126.965,NULL,'','s3','NULL','2018-05-15 14:13:16','2018-05-15 14:13:16'),(117,35.2375,126.765,35.2125,126.765,NULL,'','s1','NULL','2018-05-15 14:13:16','2018-05-15 14:13:16'),(125,35.2375,126.965,35.2125,126.965,NULL,'','s3','NULL','2018-05-15 14:13:16','2018-05-15 14:13:16');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions_of_request`
--

DROP TABLE IF EXISTS `regions_of_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regions_of_request` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usr_request_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_regions_of_request_2_idx` (`region_id`),
  KEY `fk_regions_of_request_1_idx` (`usr_request_id`),
  CONSTRAINT `fk_regions_of_request_1` FOREIGN KEY (`usr_request_id`) REFERENCES `user_requests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_regions_of_request_2` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions_of_request`
--

LOCK TABLES `regions_of_request` WRITE;
/*!40000 ALTER TABLE `regions_of_request` DISABLE KEYS */;
INSERT INTO `regions_of_request` VALUES (1,1,20),(2,1,29),(3,1,37),(4,1,45),(5,1,76),(6,1,117);
/*!40000 ALTER TABLE `regions_of_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_status`
--

DROP TABLE IF EXISTS `request_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `request_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `desc` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_status`
--

LOCK TABLES `request_status` WRITE;
/*!40000 ALTER TABLE `request_status` DISABLE KEYS */;
INSERT INTO `request_status` VALUES (1,'Success',NULL),(2,'Error',NULL),(3,'New',''),(4,'Processing',NULL);
/*!40000 ALTER TABLE `request_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subnets`
--

DROP TABLE IF EXISTS `subnets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subnets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subnets`
--

LOCK TABLES `subnets` WRITE;
/*!40000 ALTER TABLE `subnets` DISABLE KEYS */;
/*!40000 ALTER TABLE `subnets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_requests`
--

DROP TABLE IF EXISTS `user_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `request_type` varchar(100) NOT NULL DEFAULT 'test',
  `bw_mbps` int(11) DEFAULT '1' COMMENT 'Default is 1 Mbps',
  `delay_ms` float DEFAULT NULL,
  `subnet_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '3',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_requests_status` (`status`),
  KEY `fk_user_requests_subnet_idx` (`subnet_id`),
  CONSTRAINT `fk_user_requests_status` FOREIGN KEY (`status`) REFERENCES `request_status` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_requests_subnet` FOREIGN KEY (`subnet_id`) REFERENCES `subnets` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_requests`
--

LOCK TABLES `user_requests` WRITE;
/*!40000 ALTER TABLE `user_requests` DISABLE KEYS */;
INSERT INTO `user_requests` VALUES (1,'test',1,4,NULL,3,'2018-07-25 01:43:39','2018-07-25 01:43:39');
/*!40000 ALTER TABLE `user_requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-27 15:40:32
