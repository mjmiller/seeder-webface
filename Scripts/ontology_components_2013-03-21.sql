# Sequel Pro dump
# Version 1630
# http://code.google.com/p/sequel-pro
#
# Host: localhost (MySQL 5.1.42)
# Database: thesortus_t2_080
# Generation Time: 2013-03-21 16:56:26 +0000
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table ontol_tool_kit_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ontol_tool_kit_types`;

CREATE TABLE `ontol_tool_kit_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `ontolToolKitParentId` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

LOCK TABLES `ontol_tool_kit_types` WRITE;
/*!40000 ALTER TABLE `ontol_tool_kit_types` DISABLE KEYS */;
INSERT INTO `ontol_tool_kit_types` (`id`,`name`,`category`,`ontolToolKitParentId`,`created_at`,`updated_at`)
VALUES
	(1,'lexical',NULL,NULL,'2013-03-14 20:36:41','2013-03-14 20:36:41');

/*!40000 ALTER TABLE `ontol_tool_kit_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ontol_tool_kits
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ontol_tool_kits`;

CREATE TABLE `ontol_tool_kits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `ontologyId` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `version` varchar(255) DEFAULT NULL,
  `otk_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

LOCK TABLES `ontol_tool_kits` WRITE;
/*!40000 ALTER TABLE `ontol_tool_kits` DISABLE KEYS */;
INSERT INTO `ontol_tool_kits` (`id`,`name`,`description`,`ontologyId`,`created_at`,`updated_at`,`version`,`otk_type`)
VALUES
	(1,'ruby-wordnet','The ruby-wordnet gem, using it\'s default DB',1,'2013-03-14 20:36:41','2013-03-14 20:40:00','1.0',1);

/*!40000 ALTER TABLE `ontol_tool_kits` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ontologies
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ontologies`;

CREATE TABLE `ontologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `ontology_type` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `version` varchar(255) DEFAULT NULL,
  `classname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

LOCK TABLES `ontologies` WRITE;
/*!40000 ALTER TABLE `ontologies` DISABLE KEYS */;
INSERT INTO `ontologies` (`id`,`name`,`description`,`ontology_type`,`location`,`created_at`,`updated_at`,`version`,`classname`)
VALUES
	(1,'Wordnet','The WordNet 3.0 default DB',NULL,NULL,'2013-03-14 20:36:41','2013-03-20 20:13:13','3.0 DefaultDB','WordNet::Lexicon');

/*!40000 ALTER TABLE `ontologies` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ontology_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ontology_types`;

CREATE TABLE `ontology_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `ontologyTypeParentId` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

LOCK TABLES `ontology_types` WRITE;
/*!40000 ALTER TABLE `ontology_types` DISABLE KEYS */;
INSERT INTO `ontology_types` (`id`,`name`,`category`,`ontologyTypeParentId`,`created_at`,`updated_at`)
VALUES
	(1,'lexicon','english',NULL,'2013-03-14 20:36:41','2013-03-14 20:36:41');

/*!40000 ALTER TABLE `ontology_types` ENABLE KEYS */;
UNLOCK TABLES;





/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
