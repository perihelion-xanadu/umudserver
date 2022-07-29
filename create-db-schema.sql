CREATE DATABASE  IF NOT EXISTS `umudserver` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `umudserver`;
-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: umudserver
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `shortname` varchar(100) NOT NULL,
  `description` mediumtext,
  `requiredskillpkid` int DEFAULT NULL,
  `requiredskillxplevel` int DEFAULT NULL,
  `modlevel` int NOT NULL DEFAULT '0',
  `param1` varchar(255) DEFAULT NULL,
  `param2` varchar(255) DEFAULT NULL,
  `param3` varchar(255) DEFAULT NULL,
  `categoryid` int DEFAULT NULL,
  PRIMARY KEY (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `actions_categories`
--

DROP TABLE IF EXISTS `actions_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions_categories` (
  `id` int NOT NULL,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attributes` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `attr_slot` varchar(45) NOT NULL,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `rangemin` decimal(10,2) NOT NULL,
  `rangemax` decimal(10,2) NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(512) NOT NULL,
  `playerpkid` int NOT NULL,
  `currentroompkid` int NOT NULL,
  `modlevel` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characters_inventory`
--

DROP TABLE IF EXISTS `characters_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters_inventory` (
  `characterpkid` int NOT NULL,
  `itempkid` int NOT NULL,
  `itemcount` int NOT NULL,
  PRIMARY KEY (`characterpkid`,`itempkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characters_skills`
--

DROP TABLE IF EXISTS `characters_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters_skills` (
  `characterpkid` int NOT NULL AUTO_INCREMENT,
  `skillpkid` int NOT NULL,
  `xplevel` int NOT NULL,
  PRIMARY KEY (`characterpkid`,`skillpkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `characters_storage`
--

DROP TABLE IF EXISTS `characters_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters_storage` (
  `resourcepkid` int NOT NULL,
  `characterpkid` int NOT NULL,
  `resourcecount` decimal(10,4) NOT NULL,
  `regionpkid` int NOT NULL,
  PRIMARY KEY (`resourcepkid`,`characterpkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  `categoryid` int NOT NULL,
  `stacksizebase` int NOT NULL,
  `groupid` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `items_categories`
--

DROP TABLE IF EXISTS `items_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `description` mediumtext,
  `sortorder` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `items_recipes`
--

DROP TABLE IF EXISTS `items_recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `itempkid` int NOT NULL,
  `resource1pkid` int NOT NULL,
  `resource1count` int NOT NULL,
  `resource2pkid` int DEFAULT NULL,
  `resource2count` int DEFAULT NULL,
  `resource3pkid` int DEFAULT NULL,
  `resource3count` int DEFAULT NULL,
  `resource4pkid` int DEFAULT NULL,
  `resource4count` int DEFAULT NULL,
  `outputcount` int NOT NULL DEFAULT '1',
  `craftingtimebase` decimal(10,4) DEFAULT '1.0000',
  `requireditempkid` int DEFAULT NULL,
  `requiredskillpkid` int DEFAULT NULL,
  `requiredskillxplevel` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobs`
--

DROP TABLE IF EXISTS `mobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobs` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `type` int NOT NULL,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `hp_max` int NOT NULL,
  `hp_current` int NOT NULL,
  `attr_1` decimal(10,2) DEFAULT NULL,
  `attr_2` decimal(10,2) DEFAULT NULL,
  `attr_3` decimal(10,2) DEFAULT NULL,
  `attr_4` decimal(10,2) DEFAULT NULL,
  `attr_5` decimal(10,2) DEFAULT NULL,
  `attr_6` decimal(10,2) DEFAULT NULL,
  `attr_7` decimal(10,2) DEFAULT NULL,
  `attr_8` decimal(10,2) DEFAULT NULL,
  `currentroompkid` int NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobs_types`
--

DROP TABLE IF EXISTS `mobs_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobs_types` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  `attr_1` int DEFAULT NULL,
  `attr_2` int DEFAULT NULL,
  `attr_3` int DEFAULT NULL,
  `attr_4` int DEFAULT NULL,
  `attr_5` int DEFAULT NULL,
  `attr_6` int DEFAULT NULL,
  `attr_7` int DEFAULT NULL,
  `attr_8` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `modlevel` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions_rooms`
--

DROP TABLE IF EXISTS `regions_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions_rooms` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `regionpkid` int NOT NULL,
  `templatepkid` int DEFAULT NULL,
  `param1` varchar(255) DEFAULT NULL,
  `param2` varchar(255) DEFAULT NULL,
  `param3` varchar(255) DEFAULT NULL,
  `param4` varchar(255) DEFAULT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `status` tinyint NOT NULL,
  `maptileicon` varchar(45) NOT NULL,
  `maptileiconcolor` varchar(45) NOT NULL,
  `maptilebgcolor` varchar(45) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions_rooms_links`
--

DROP TABLE IF EXISTS `regions_rooms_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions_rooms_links` (
  `room1pkid` int NOT NULL,
  `room2pkid` int NOT NULL,
  `oneway` tinyint DEFAULT '0',
  PRIMARY KEY (`room1pkid`,`room2pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions_roomtemplates`
--

DROP TABLE IF EXISTS `regions_roomtemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions_roomtemplates` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `categoryid` int DEFAULT NULL,
  `defaultmaptile` varchar(45) NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions_roomtemplates_categories`
--

DROP TABLE IF EXISTS `regions_roomtemplates_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions_roomtemplates_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `modlevel` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `stacksizebase` int NOT NULL,
  `categoryid` int NOT NULL,
  `groupid` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resources_categories`
--

DROP TABLE IF EXISTS `resources_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `description` mediumtext,
  `sortorder` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resources_objecttypes`
--

DROP TABLE IF EXISTS `resources_objecttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources_objecttypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resources_worldobjects`
--

DROP TABLE IF EXISTS `resources_worldobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources_worldobjects` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  `typeid` int NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-29 12:32:48
