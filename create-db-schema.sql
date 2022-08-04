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
  `command1` varchar(45) DEFAULT NULL,
  `command2` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
INSERT INTO `actions` VALUES ('createCharacter','Add a new Character to a Player account.',0,0,0,'name','playerpkid','chardata',1,NULL,NULL),('createPlayer','Add a new Player account.',0,0,0,'name',NULL,NULL,1,NULL,NULL),('globalSay','Speak with other players in the server.',0,0,0,'origincharacter','regionpkid',NULL,2,'gsay $message',NULL),('interactWithNPC','Attempt to interact with an NPC.',0,0,0,'npcpkid','actions',NULL,2,'npctalk $npcpkid',NULL),('interactWithObject','Interact with a world object.',0,0,0,'objectpkid','actions',NULL,2,'touch $objectpkid',NULL),('joinChannel','Join a built-in or custom Chat Channel.',0,0,0,'channelname',NULL,NULL,2,'join $channelname',NULL),('leaveChannel','Leave a built-in or custom Chat Channel',0,0,0,'channelname',NULL,NULL,2,'leave $channelname',NULL),('localSay','Speak with other players in the same room.',0,0,0,'origincharacter','roompkid',NULL,2,'say $message',NULL),('loginCharacter','Log in a character.',0,0,0,'pkid',NULL,NULL,1,NULL,NULL),('loginPlayer','Log in with a player account.',0,0,0,'pkid',NULL,NULL,1,NULL,NULL),('look','Look around and obtain information about your surroundings.',0,0,0,'roompkid',NULL,NULL,2,'look','l'),('moveDown','Attempt to move from your current room to the room immediately Down.',0,0,0,'destxyz',NULL,NULL,3,'down','d'),('moveEast','Attempt to move from your current room to the room immediately East.',0,0,0,'destxyz',NULL,NULL,3,'east','e'),('moveNorth','Attempt to move from your current room to the room immediately North.',0,0,0,'destxyz',NULL,NULL,3,'north','n'),('moveSouth','Attempt to move from your current room to the room immediately South.',0,0,0,'destxyz',NULL,NULL,3,'south','s'),('moveUp','Attempt to move from your current room to the room immediately Up.',0,0,0,'destxyz',NULL,NULL,3,'up','u'),('moveWest','Attempt to move from your current room to the room immediately West.',0,0,0,'destxyz',NULL,NULL,3,'west','w'),('openInventory','Open or unhide the Inventory screen, display Inventory.',0,0,0,'characterpkid','items','itemactions',2,'inventory','i'),('registerStart','Start the registration process.',0,0,0,NULL,NULL,NULL,1,NULL,NULL),('viewCharacterStatus','Retrieve or display the current status information for your character.',0,0,0,'characterpkid','statusitems','statusactions',2,'status',NULL);
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions_categories`
--

DROP TABLE IF EXISTS `actions_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shortname` varchar(45) NOT NULL,
  `longname` varchar(255) NOT NULL,
  `description` mediumtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions_categories`
--

LOCK TABLES `actions_categories` WRITE;
/*!40000 ALTER TABLE `actions_categories` DISABLE KEYS */;
INSERT INTO `actions_categories` VALUES (1,'system','system','built-in actions'),(2,'general','general','generic actions'),(3,'movement','movement','movement actions');
/*!40000 ALTER TABLE `actions_categories` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `attributes`
--

LOCK TABLES `attributes` WRITE;
/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
UNLOCK TABLES;

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
  `title` varchar(45) DEFAULT NULL,
  `tag` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES (1,'Perihelion',1,1,NULL,'Founder','<ADMIN>');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `characters_equipment`
--

DROP TABLE IF EXISTS `characters_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters_equipment` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `character_pkid` int NOT NULL,
  `item_pkid` int NOT NULL,
  `location` int NOT NULL,
  `attr_1` varchar(45) DEFAULT NULL,
  `attr_1_value` varchar(45) DEFAULT NULL,
  `attr_2` varchar(45) DEFAULT NULL,
  `attr_2_value` varchar(45) DEFAULT NULL,
  `attr_3` varchar(45) DEFAULT NULL,
  `attr_3_value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`pkid`,`character_pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters_equipment`
--

LOCK TABLES `characters_equipment` WRITE;
/*!40000 ALTER TABLE `characters_equipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters_equipment` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `characters_inventory`
--

LOCK TABLES `characters_inventory` WRITE;
/*!40000 ALTER TABLE `characters_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters_inventory` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `characters_skills`
--

LOCK TABLES `characters_skills` WRITE;
/*!40000 ALTER TABLE `characters_skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters_skills` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `characters_storage`
--

LOCK TABLES `characters_storage` WRITE;
/*!40000 ALTER TABLE `characters_storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters_storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `flag_type` varchar(45) NOT NULL,
  `flag_name` varchar(20) NOT NULL,
  `effect_1_field` varchar(45) NOT NULL,
  `effect_1_modifier` varchar(45) NOT NULL,
  `effect_2_field` varchar(45) DEFAULT NULL,
  `effect_2_modifier` varchar(45) DEFAULT NULL,
  `effect_3_field` varchar(45) DEFAULT NULL,
  `effect_3_modifier` varchar(45) DEFAULT NULL,
  `expires` datetime NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags_definitions`
--

DROP TABLE IF EXISTS `flags_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags_definitions` (
  `flag_name` varchar(20) NOT NULL,
  `default_expire` int NOT NULL DEFAULT '-1',
  `effect_1_field` varchar(45) NOT NULL,
  `effect_1_modifier` varchar(45) NOT NULL,
  `effect_2_field` varchar(45) DEFAULT NULL,
  `effect_2_modifier` varchar(45) DEFAULT NULL,
  `effect_3_field` varchar(45) DEFAULT NULL,
  `effect_3_modifier` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`flag_name`),
  UNIQUE KEY `flag_name_UNIQUE` (`flag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags_definitions`
--

LOCK TABLES `flags_definitions` WRITE;
/*!40000 ALTER TABLE `flags_definitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `flags_definitions` ENABLE KEYS */;
UNLOCK TABLES;

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
  `attr_1` varchar(45) DEFAULT NULL,
  `attr_1_value` varchar(45) DEFAULT NULL,
  `attr_2` varchar(45) DEFAULT NULL,
  `attr_2_value` varchar(45) DEFAULT NULL,
  `attr_3` varchar(45) DEFAULT NULL,
  `attr_3_value` varchar(45) DEFAULT NULL,
  `size1` int DEFAULT NULL,
  `size2` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `items_categories`
--

LOCK TABLES `items_categories` WRITE;
/*!40000 ALTER TABLE `items_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `items_categories` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `items_recipes`
--

LOCK TABLES `items_recipes` WRITE;
/*!40000 ALTER TABLE `items_recipes` DISABLE KEYS */;
/*!40000 ALTER TABLE `items_recipes` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `mobs`
--

LOCK TABLES `mobs` WRITE;
/*!40000 ALTER TABLE `mobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobs` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `mobs_types`
--

LOCK TABLES `mobs_types` WRITE;
/*!40000 ALTER TABLE `mobs_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobs_types` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (1,'Perihelion',3);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_advancement`
--

DROP TABLE IF EXISTS `preset_advancement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_advancement` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `field1` varchar(45) NOT NULL,
  `value1` int DEFAULT NULL,
  `field2` varchar(45) DEFAULT NULL,
  `value2` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_advancement`
--

LOCK TABLES `preset_advancement` WRITE;
/*!40000 ALTER TABLE `preset_advancement` DISABLE KEYS */;
/*!40000 ALTER TABLE `preset_advancement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_attributes`
--

DROP TABLE IF EXISTS `preset_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_attributes` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `fieldname` varchar(45) NOT NULL,
  `fieldvalue1` decimal(10,2) NOT NULL,
  `fieldvalue2` decimal(10,2) DEFAULT NULL,
  `fieldvalue3` decimal(10,2) DEFAULT NULL,
  `fieldvalue4` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_attributes`
--

LOCK TABLES `preset_attributes` WRITE;
/*!40000 ALTER TABLE `preset_attributes` DISABLE KEYS */;
INSERT INTO `preset_attributes` VALUES (1,1,'Strength',1.00,10.00,NULL,NULL),(2,1,'Perception',1.00,10.00,NULL,NULL),(3,1,'Endurance',1.00,10.00,NULL,NULL),(4,1,'Charisma',1.00,10.00,NULL,NULL),(5,1,'Intelligence',1.00,10.00,NULL,NULL),(6,1,'Agility',1.00,10.00,NULL,NULL),(7,1,'Luck',1.00,10.00,NULL,NULL),(8,2,'Health',0.00,100.00,NULL,NULL),(9,2,'Hunger',0.00,100.00,NULL,NULL),(10,2,'Thirst',0.00,100.00,NULL,NULL),(11,2,'BodyTemp',0.00,100.00,NULL,NULL),(12,2,'Energy',0.00,100.00,NULL,NULL),(19,3,'Strength',3.00,18.00,0.00,40.00),(20,3,'Dexterity',3.00,18.00,0.00,40.00),(21,3,'Constitution',3.00,18.00,0.00,40.00),(22,3,'Intelligence',3.00,18.00,0.00,40.00),(23,3,'Wisdom',3.00,18.00,0.00,40.00),(24,3,'Charisma',3.00,18.00,0.00,40.00);
/*!40000 ALTER TABLE `preset_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_classes`
--

DROP TABLE IF EXISTS `preset_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_classes` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `class_name` varchar(45) NOT NULL,
  `class_notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_classes`
--

LOCK TABLES `preset_classes` WRITE;
/*!40000 ALTER TABLE `preset_classes` DISABLE KEYS */;
INSERT INTO `preset_classes` VALUES (1,11,'N/A','N/A'),(2,12,'Warrior','Basic fighter class.'),(3,12,'Thief','Basic thief/rogue class.'),(4,12,'Wizard','Basic wizard/mage class.'),(5,12,'Cleric','Basic cleric/healer class.');
/*!40000 ALTER TABLE `preset_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_equipment`
--

DROP TABLE IF EXISTS `preset_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_equipment` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `location_name` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_equipment`
--

LOCK TABLES `preset_equipment` WRITE;
/*!40000 ALTER TABLE `preset_equipment` DISABLE KEYS */;
INSERT INTO `preset_equipment` VALUES (1,4,'Armor','armor'),(2,4,'Weapon','weapon'),(3,5,'Right Hand','hand'),(4,5,'Left Hand','hand'),(5,5,'Left Arm','arm'),(6,5,'Right Arm','arm'),(7,5,'Left Leg','leg'),(8,5,'Right Leg','leg'),(9,5,'Left Foot','foot'),(10,5,'Right Foot','foot'),(11,5,'Body','body'),(12,5,'Head','head'),(13,5,'Shirt','body_under'),(14,5,'Pants','legs_under'),(15,5,'Neck','jewelry_neck'),(16,5,'Right Ring Finger','jewelry_ring'),(17,5,'Left Ring Finger','jewelry_ring'),(18,5,'Belt','waist'),(19,5,'Backpack','backpack'),(20,5,'Back','back'),(21,6,'custom_name','custom_type');
/*!40000 ALTER TABLE `preset_equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_inventory`
--

DROP TABLE IF EXISTS `preset_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_inventory` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `item_type` varchar(45) DEFAULT NULL,
  `size1` int DEFAULT NULL,
  `size2` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_inventory`
--

LOCK TABLES `preset_inventory` WRITE;
/*!40000 ALTER TABLE `preset_inventory` DISABLE KEYS */;
INSERT INTO `preset_inventory` VALUES (3,7,'Hotbar Item Slot','quickslot',1,1),(4,8,'Hotbar Item Slot','quickslot',1,1),(5,8,'Inventory Slot','slot',1,100),(6,9,'Inventory Space','shape',1,100),(7,10,'Resource','slot',1,1);
/*!40000 ALTER TABLE `preset_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_races`
--

DROP TABLE IF EXISTS `preset_races`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preset_races` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `race_name` varchar(255) NOT NULL,
  `race_notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_races`
--

LOCK TABLES `preset_races` WRITE;
/*!40000 ALTER TABLE `preset_races` DISABLE KEYS */;
INSERT INTO `preset_races` VALUES (1,19,'Human','Default single race, customizable.');
/*!40000 ALTER TABLE `preset_races` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'default','default zone',NULL);
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `regions_rooms`
--

LOCK TABLES `regions_rooms` WRITE;
/*!40000 ALTER TABLE `regions_rooms` DISABLE KEYS */;
INSERT INTO `regions_rooms` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,0,0,0,1,'&#0058;','black','rgba(34,139,34,1)','Example Room Title','This is an example room description. It may contain variable text based on saved parameters, or may be completely created from scratch. Either way, you can see plenty of opportunities for growth nearby!'),(2,1,NULL,NULL,NULL,NULL,NULL,1,0,0,1,'&#0058;','black','rgba(34,139,34,1)','Example Room Title','This is an example room description. It may contain variable text based on saved parameters, or may be completely created from scratch. Either way, you can see plenty of opportunities for growth nearby!'),(3,1,NULL,NULL,NULL,NULL,NULL,-1,0,0,1,'&#0058;','black','rgba(34,139,34,1)','Example Room Title','This is an example room description. It may contain variable text based on saved parameters, or may be completely created from scratch. Either way, you can see plenty of opportunities for growth nearby!'),(4,1,NULL,NULL,NULL,NULL,NULL,0,-1,0,1,'&#0058;','black','rgba(34,139,34,1)','Example Room Title','This is an example room description. It may contain variable text based on saved parameters, or may be completely created from scratch. Either way, you can see plenty of opportunities for growth nearby!'),(5,1,NULL,NULL,NULL,NULL,NULL,0,1,0,1,'&#0058;','black','rgba(34,139,34,1)','Example Room Title','This is an example room description. It may contain variable text based on saved parameters, or may be completely created from scratch. Either way, you can see plenty of opportunities for growth nearby!'),(6,1,NULL,NULL,NULL,NULL,NULL,1,1,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(7,1,NULL,NULL,NULL,NULL,NULL,-1,1,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(8,1,NULL,NULL,NULL,NULL,NULL,1,-1,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(9,1,NULL,NULL,NULL,NULL,NULL,-1,-1,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(10,1,NULL,NULL,NULL,NULL,NULL,0,-2,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(11,1,NULL,NULL,NULL,NULL,NULL,0,2,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(12,1,NULL,NULL,NULL,NULL,NULL,-2,0,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??'),(13,1,NULL,NULL,NULL,NULL,NULL,2,0,0,1,'&#0053;','DarkSlateGray','rgba(139,69,19,1)','IMPASSABLE','How did you get here??');
/*!40000 ALTER TABLE `regions_rooms` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `regions_rooms_links`
--

LOCK TABLES `regions_rooms_links` WRITE;
/*!40000 ALTER TABLE `regions_rooms_links` DISABLE KEYS */;
INSERT INTO `regions_rooms_links` VALUES (1,2,0),(1,3,0),(1,4,0),(1,5,0),(2,1,0),(3,1,0),(4,1,0),(5,1,0);
/*!40000 ALTER TABLE `regions_rooms_links` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `regions_roomtemplates`
--

LOCK TABLES `regions_roomtemplates` WRITE;
/*!40000 ALTER TABLE `regions_roomtemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions_roomtemplates` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `regions_roomtemplates_categories`
--

LOCK TABLES `regions_roomtemplates_categories` WRITE;
/*!40000 ALTER TABLE `regions_roomtemplates_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions_roomtemplates_categories` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `resources_categories`
--

LOCK TABLES `resources_categories` WRITE;
/*!40000 ALTER TABLE `resources_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `resources_categories` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `resources_objecttypes`
--

LOCK TABLES `resources_objecttypes` WRITE;
/*!40000 ALTER TABLE `resources_objecttypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `resources_objecttypes` ENABLE KEYS */;
UNLOCK TABLES;

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
  `roomid` int DEFAULT NULL,
  `action` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `shortname_UNIQUE` (`shortname`),
  UNIQUE KEY `longname_UNIQUE` (`longname`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources_worldobjects`
--

LOCK TABLES `resources_worldobjects` WRITE;
/*!40000 ALTER TABLE `resources_worldobjects` DISABLE KEYS */;
INSERT INTO `resources_worldobjects` VALUES (1,'registerStone','Registration Stone','A glowing stone hovers in the air, beckoning you to touch it.',0,1,'registerStart');
/*!40000 ALTER TABLE `resources_worldobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_preset_equipmentslots`
--

DROP TABLE IF EXISTS `server_preset_equipmentslots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_preset_equipmentslots` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `location_name` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_preset_equipmentslots`
--

LOCK TABLES `server_preset_equipmentslots` WRITE;
/*!40000 ALTER TABLE `server_preset_equipmentslots` DISABLE KEYS */;
INSERT INTO `server_preset_equipmentslots` VALUES (1,4,'Armor','armor'),(2,4,'Weapon','weapon'),(3,5,'Right Hand','hand'),(4,5,'Left Hand','hand'),(5,5,'Left Arm','arm'),(6,5,'Right Arm','arm'),(7,5,'Left Leg','leg'),(8,5,'Right Leg','leg'),(9,5,'Left Foot','foot'),(10,5,'Right Foot','foot'),(11,5,'Body','body'),(12,5,'Head','head'),(13,5,'Shirt','body_under'),(14,5,'Pants','legs_under'),(15,5,'Neck','jewelry_neck'),(16,5,'Right Ring Finger','jewelry_ring'),(17,5,'Left Ring Finger','jewelry_ring'),(18,5,'Belt','waist'),(19,5,'Backpack','backpack'),(20,5,'Back','back'),(21,6,'custom_name','custom_type');
/*!40000 ALTER TABLE `server_preset_equipmentslots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_preset_inventory`
--

DROP TABLE IF EXISTS `server_preset_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_preset_inventory` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `item_type` varchar(45) DEFAULT NULL,
  `size1` int DEFAULT NULL,
  `size2` int DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_preset_inventory`
--

LOCK TABLES `server_preset_inventory` WRITE;
/*!40000 ALTER TABLE `server_preset_inventory` DISABLE KEYS */;
INSERT INTO `server_preset_inventory` VALUES (3,7,'Hotbar Item Slot','quickslot',1,1),(4,8,'Hotbar Item Slot','quickslot',1,1),(5,8,'Inventory Slot','slot',1,100),(6,9,'Inventory Space','shape',1,100),(7,10,'Resource','slot',1,1);
/*!40000 ALTER TABLE `server_preset_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_preset_options`
--

DROP TABLE IF EXISTS `server_preset_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_preset_options` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `preset_pkid` int NOT NULL,
  `fieldname` varchar(45) NOT NULL,
  `fieldvalue1` decimal(10,2) NOT NULL,
  `fieldvalue2` decimal(10,2) DEFAULT NULL,
  `fieldvalue3` decimal(10,2) DEFAULT NULL,
  `fieldvalue4` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_preset_options`
--

LOCK TABLES `server_preset_options` WRITE;
/*!40000 ALTER TABLE `server_preset_options` DISABLE KEYS */;
INSERT INTO `server_preset_options` VALUES (1,1,'Strength',1.00,10.00,NULL,NULL),(2,1,'Perception',1.00,10.00,NULL,NULL),(3,1,'Endurance',1.00,10.00,NULL,NULL),(4,1,'Charisma',1.00,10.00,NULL,NULL),(5,1,'Intelligence',1.00,10.00,NULL,NULL),(6,1,'Agility',1.00,10.00,NULL,NULL),(7,1,'Luck',1.00,10.00,NULL,NULL),(8,2,'Health',0.00,100.00,NULL,NULL),(9,2,'Hunger',0.00,100.00,NULL,NULL),(10,2,'Thirst',0.00,100.00,NULL,NULL),(11,2,'BodyTemp',0.00,100.00,NULL,NULL),(12,2,'Energy',0.00,100.00,NULL,NULL),(19,3,'Strength',3.00,18.00,0.00,40.00),(20,3,'Dexterity',3.00,18.00,0.00,40.00),(21,3,'Constitution',3.00,18.00,0.00,40.00),(22,3,'Intelligence',3.00,18.00,0.00,40.00),(23,3,'Wisdom',3.00,18.00,0.00,40.00),(24,3,'Charisma',3.00,18.00,0.00,40.00);
/*!40000 ALTER TABLE `server_preset_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_preset_types`
--

DROP TABLE IF EXISTS `server_preset_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_preset_types` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_preset_types`
--

LOCK TABLES `server_preset_types` WRITE;
/*!40000 ALTER TABLE `server_preset_types` DISABLE KEYS */;
INSERT INTO `server_preset_types` VALUES (2,'advancement_system'),(1,'attribute_system'),(3,'character_equipment'),(4,'character_inventory'),(5,'class_system'),(7,'race_system');
/*!40000 ALTER TABLE `server_preset_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_presets`
--

DROP TABLE IF EXISTS `server_presets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_presets` (
  `pkid` int NOT NULL AUTO_INCREMENT,
  `type` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `incompatible_presets` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `pkid_UNIQUE` (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_presets`
--

LOCK TABLES `server_presets` WRITE;
/*!40000 ALTER TABLE `server_presets` DISABLE KEYS */;
INSERT INTO `server_presets` VALUES (1,1,'S.P.E.C.I.A.L.','System made famous by the Fallout franchise.',NULL),(2,1,'Survivalist','Attribute system for wilderness survival-style games.',NULL),(3,1,'d20 Standard','Standardized attribute system used by the d20 tabletop games.',NULL),(4,3,'Minimalist','Very minimal equipment loadout - armor, weapon.',NULL),(5,3,'Standard','Bipedal body armor locations, two hands, optional jewelry slots.',NULL),(6,3,'Standard Multirace','Custom body armor locations and limbs based on race, optional jewelry slots.',NULL),(7,4,'Minimalist','Limited hotbar-style inventory system with configurable number of slots.',NULL),(8,4,'Standard Numerical','Full-featured inventory with configurable slots, stack sizes, and numeric-based limits (such as weight).',NULL),(9,4,'Standard Shaped','Diablo-style inventory with variable slot sizes, optional stack sizes.',NULL),(10,4,'Static','Pre-defined inventory items which are added to or subtracted from, similar to strategy and city-building games.',NULL),(11,5,'Class-less','Do not use character classes.','17'),(12,5,'Single Class','Character class is selected at character creation or as a result of gameplay.  Configurable option to change Class.',NULL),(13,5,'Multi Class (d20 Core)','Multiple classes can be chosen, either during character creation or as a result of gameplay, chosen from the d20 Core Classes.',NULL),(14,5,'Single Class Heroic','Character starts with a single class but can re-class once one or more requirements have been met.',NULL),(15,5,'Professions','Character can select one or more professions (configurable) either during or after character creation.',NULL),(16,2,'Character Levels','Character gains levels through experience, each level provides points and/or static increases for skills, attributes, etc.',NULL),(17,2,'Class Levels','Character gains levels in their chosen Class(es), each level provides points and/or static increases for skills, attributes, etc.','11'),(18,2,'Skill Levels','Character gains skill levels through experience, unlocking additional skills, feats, etc.',NULL),(19,7,'Single Race','All player characters are part of the same race.  NPCs and mobs can still be assigned specific races.',NULL),(20,7,'Multi Race (d20 Core)','Players may choose a race at character creation based on the d20 Core races.',NULL),(21,7,'Multi Race (d20 Extended)','Players may choose a race at character creation based on the d20 Core races as well as Featured races.',NULL),(22,5,'Multi Class (d20 Extended)','Multiple classes can be chosen, either during character creation or as a result of gameplay, chosen from the d20 Core, Base, and Hybrid Classes.',NULL),(23,5,'Multi Class (d20 Complete)','Multiple classes can be chosen, either during character creation or as a result of gameplay, chosen from the d20 Core, Base, Alternate, Hybrid, Unchained, and Prestige Classes.',NULL);
/*!40000 ALTER TABLE `server_presets` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-03 21:10:53
