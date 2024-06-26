-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: zabbix
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `acknowledges`
--

DROP TABLE IF EXISTS `acknowledges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acknowledges` (
  `acknowledgeid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `message` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `action` int NOT NULL DEFAULT '0',
  `old_severity` int NOT NULL DEFAULT '0',
  `new_severity` int NOT NULL DEFAULT '0',
  `suppress_until` int NOT NULL DEFAULT '0',
  `taskid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`acknowledgeid`),
  KEY `acknowledges_1` (`userid`),
  KEY `acknowledges_2` (`eventid`),
  KEY `acknowledges_3` (`clock`),
  CONSTRAINT `c_acknowledges_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_acknowledges_2` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `actionid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `eventsource` int NOT NULL DEFAULT '0',
  `evaltype` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `esc_period` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '1h',
  `formula` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `pause_suppressed` int NOT NULL DEFAULT '1',
  `notify_if_canceled` int NOT NULL DEFAULT '1',
  `pause_symptoms` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`actionid`),
  UNIQUE KEY `actions_2` (`name`),
  KEY `actions_1` (`eventsource`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `alertid` bigint unsigned NOT NULL,
  `actionid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `userid` bigint unsigned DEFAULT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `mediatypeid` bigint unsigned DEFAULT NULL,
  `sendto` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `message` text COLLATE utf8mb4_bin NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `retries` int NOT NULL DEFAULT '0',
  `error` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `esc_step` int NOT NULL DEFAULT '0',
  `alerttype` int NOT NULL DEFAULT '0',
  `p_eventid` bigint unsigned DEFAULT NULL,
  `acknowledgeid` bigint unsigned DEFAULT NULL,
  `parameters` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`alertid`),
  KEY `alerts_1` (`actionid`),
  KEY `alerts_2` (`clock`),
  KEY `alerts_3` (`eventid`),
  KEY `alerts_4` (`status`),
  KEY `alerts_5` (`mediatypeid`),
  KEY `alerts_6` (`userid`),
  KEY `alerts_7` (`p_eventid`),
  KEY `alerts_8` (`acknowledgeid`),
  CONSTRAINT `c_alerts_1` FOREIGN KEY (`actionid`) REFERENCES `actions` (`actionid`) ON DELETE CASCADE,
  CONSTRAINT `c_alerts_2` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_alerts_3` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_alerts_4` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE,
  CONSTRAINT `c_alerts_5` FOREIGN KEY (`p_eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_alerts_6` FOREIGN KEY (`acknowledgeid`) REFERENCES `acknowledges` (`acknowledgeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auditlog`
--

DROP TABLE IF EXISTS `auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditlog` (
  `auditid` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `userid` bigint unsigned DEFAULT NULL,
  `username` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `clock` int NOT NULL DEFAULT '0',
  `ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `action` int NOT NULL DEFAULT '0',
  `resourcetype` int NOT NULL DEFAULT '0',
  `resourceid` bigint unsigned DEFAULT NULL,
  `resource_cuid` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `resourcename` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `recordsetid` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `details` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`auditid`),
  KEY `auditlog_1` (`userid`,`clock`),
  KEY `auditlog_2` (`clock`),
  KEY `auditlog_3` (`resourcetype`,`resourceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `autoreg_host`
--

DROP TABLE IF EXISTS `autoreg_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autoreg_host` (
  `autoreg_hostid` bigint unsigned NOT NULL,
  `proxy_hostid` bigint unsigned DEFAULT NULL,
  `host` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `listen_ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `listen_port` int NOT NULL DEFAULT '0',
  `listen_dns` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host_metadata` text COLLATE utf8mb4_bin NOT NULL,
  `flags` int NOT NULL DEFAULT '0',
  `tls_accepted` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`autoreg_hostid`),
  KEY `autoreg_host_1` (`host`),
  KEY `autoreg_host_2` (`proxy_hostid`),
  CONSTRAINT `c_autoreg_host_1` FOREIGN KEY (`proxy_hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `changelog` (
  `changelogid` bigint unsigned NOT NULL AUTO_INCREMENT,
  `object` int NOT NULL DEFAULT '0',
  `objectid` bigint unsigned NOT NULL,
  `operation` int NOT NULL DEFAULT '0',
  `clock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`changelogid`),
  KEY `changelog_1` (`clock`)
) ENGINE=InnoDB AUTO_INCREMENT=80729 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conditions` (
  `conditionid` bigint unsigned NOT NULL,
  `actionid` bigint unsigned NOT NULL,
  `conditiontype` int NOT NULL DEFAULT '0',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value2` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`conditionid`),
  KEY `conditions_1` (`actionid`),
  CONSTRAINT `c_conditions_1` FOREIGN KEY (`actionid`) REFERENCES `actions` (`actionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `configid` bigint unsigned NOT NULL,
  `work_period` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '1-5,09:00-18:00',
  `alert_usrgrpid` bigint unsigned DEFAULT NULL,
  `default_theme` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT 'blue-theme',
  `authentication_type` int NOT NULL DEFAULT '0',
  `discovery_groupid` bigint unsigned DEFAULT NULL,
  `max_in_table` int NOT NULL DEFAULT '50',
  `search_limit` int NOT NULL DEFAULT '1000',
  `severity_color_0` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '97AAB3',
  `severity_color_1` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '7499FF',
  `severity_color_2` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'FFC859',
  `severity_color_3` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'FFA059',
  `severity_color_4` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'E97659',
  `severity_color_5` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'E45959',
  `severity_name_0` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Not classified',
  `severity_name_1` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Information',
  `severity_name_2` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Warning',
  `severity_name_3` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Average',
  `severity_name_4` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'High',
  `severity_name_5` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Disaster',
  `ok_period` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '5m',
  `blink_period` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '2m',
  `problem_unack_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'CC0000',
  `problem_ack_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT 'CC0000',
  `ok_unack_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '009900',
  `ok_ack_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '009900',
  `problem_unack_style` int NOT NULL DEFAULT '1',
  `problem_ack_style` int NOT NULL DEFAULT '1',
  `ok_unack_style` int NOT NULL DEFAULT '1',
  `ok_ack_style` int NOT NULL DEFAULT '1',
  `snmptrap_logging` int NOT NULL DEFAULT '1',
  `server_check_interval` int NOT NULL DEFAULT '10',
  `hk_events_mode` int NOT NULL DEFAULT '1',
  `hk_events_trigger` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `hk_events_internal` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1d',
  `hk_events_discovery` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1d',
  `hk_events_autoreg` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1d',
  `hk_services_mode` int NOT NULL DEFAULT '1',
  `hk_services` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `hk_audit_mode` int NOT NULL DEFAULT '1',
  `hk_audit` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `hk_sessions_mode` int NOT NULL DEFAULT '1',
  `hk_sessions` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `hk_history_mode` int NOT NULL DEFAULT '1',
  `hk_history_global` int NOT NULL DEFAULT '0',
  `hk_history` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '90d',
  `hk_trends_mode` int NOT NULL DEFAULT '1',
  `hk_trends_global` int NOT NULL DEFAULT '0',
  `hk_trends` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `default_inventory_mode` int NOT NULL DEFAULT '-1',
  `custom_color` int NOT NULL DEFAULT '0',
  `http_auth_enabled` int NOT NULL DEFAULT '0',
  `http_login_form` int NOT NULL DEFAULT '0',
  `http_strip_domains` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `http_case_sensitive` int NOT NULL DEFAULT '1',
  `ldap_auth_enabled` int NOT NULL DEFAULT '0',
  `ldap_case_sensitive` int NOT NULL DEFAULT '1',
  `db_extension` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `autoreg_tls_accept` int NOT NULL DEFAULT '1',
  `compression_status` int NOT NULL DEFAULT '0',
  `compress_older` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '7d',
  `instanceid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `saml_auth_enabled` int NOT NULL DEFAULT '0',
  `saml_case_sensitive` int NOT NULL DEFAULT '0',
  `default_lang` varchar(5) COLLATE utf8mb4_bin NOT NULL DEFAULT 'en_US',
  `default_timezone` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'system',
  `login_attempts` int NOT NULL DEFAULT '5',
  `login_block` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '30s',
  `show_technical_errors` int NOT NULL DEFAULT '0',
  `validate_uri_schemes` int NOT NULL DEFAULT '1',
  `uri_valid_schemes` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT 'http,https,ftp,file,mailto,tel,ssh',
  `x_frame_options` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT 'SAMEORIGIN',
  `iframe_sandboxing_enabled` int NOT NULL DEFAULT '1',
  `iframe_sandboxing_exceptions` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `max_overview_table_size` int NOT NULL DEFAULT '50',
  `history_period` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '24h',
  `period_default` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1h',
  `max_period` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '2y',
  `socket_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '3s',
  `connect_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '3s',
  `media_type_test_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '65s',
  `script_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '60s',
  `item_test_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '60s',
  `session_key` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `report_test_timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '60s',
  `dbversion_status` text COLLATE utf8mb4_bin NOT NULL,
  `hk_events_service` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1d',
  `passwd_min_length` int NOT NULL DEFAULT '8',
  `passwd_check_rules` int NOT NULL DEFAULT '8',
  `auditlog_enabled` int NOT NULL DEFAULT '1',
  `ha_failover_delay` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1m',
  `geomaps_tile_provider` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `geomaps_tile_url` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `geomaps_max_zoom` int NOT NULL DEFAULT '0',
  `geomaps_attribution` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `vault_provider` int NOT NULL DEFAULT '0',
  `ldap_userdirectoryid` bigint unsigned DEFAULT NULL,
  `server_status` text COLLATE utf8mb4_bin NOT NULL,
  `jit_provision_interval` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '1h',
  `saml_jit_status` int NOT NULL DEFAULT '0',
  `ldap_jit_status` int NOT NULL DEFAULT '0',
  `disabled_usrgrpid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`configid`),
  KEY `config_1` (`alert_usrgrpid`),
  KEY `config_2` (`discovery_groupid`),
  KEY `config_3` (`ldap_userdirectoryid`),
  KEY `config_4` (`disabled_usrgrpid`),
  CONSTRAINT `c_config_1` FOREIGN KEY (`alert_usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`),
  CONSTRAINT `c_config_2` FOREIGN KEY (`discovery_groupid`) REFERENCES `hstgrp` (`groupid`),
  CONSTRAINT `c_config_3` FOREIGN KEY (`ldap_userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`),
  CONSTRAINT `c_config_4` FOREIGN KEY (`disabled_usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_autoreg_tls`
--

DROP TABLE IF EXISTS `config_autoreg_tls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_autoreg_tls` (
  `autoreg_tlsid` bigint unsigned NOT NULL,
  `tls_psk_identity` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tls_psk` varchar(512) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`autoreg_tlsid`),
  UNIQUE KEY `config_autoreg_tls_1` (`tls_psk_identity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `connector`
--

DROP TABLE IF EXISTS `connector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `connector` (
  `connectorid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `protocol` int NOT NULL DEFAULT '0',
  `data_type` int NOT NULL DEFAULT '0',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `max_records` int NOT NULL DEFAULT '0',
  `max_senders` int NOT NULL DEFAULT '1',
  `max_attempts` int NOT NULL DEFAULT '1',
  `timeout` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '5s',
  `http_proxy` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `authtype` int NOT NULL DEFAULT '0',
  `username` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `token` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `verify_peer` int NOT NULL DEFAULT '1',
  `verify_host` int NOT NULL DEFAULT '1',
  `ssl_cert_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `tags_evaltype` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`connectorid`),
  UNIQUE KEY `connector_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_insert` AFTER INSERT ON `connector` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (17,new.connectorid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_update` AFTER UPDATE ON `connector` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (17,old.connectorid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_delete` BEFORE DELETE ON `connector` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (17,old.connectorid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `connector_tag`
--

DROP TABLE IF EXISTS `connector_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `connector_tag` (
  `connector_tagid` bigint unsigned NOT NULL,
  `connectorid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`connector_tagid`),
  KEY `connector_tag_1` (`connectorid`),
  CONSTRAINT `c_connector_tag_1` FOREIGN KEY (`connectorid`) REFERENCES `connector` (`connectorid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_tag_insert` AFTER INSERT ON `connector_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (18,new.connector_tagid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_tag_update` AFTER UPDATE ON `connector_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (18,old.connector_tagid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `connector_tag_delete` BEFORE DELETE ON `connector_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (18,old.connector_tagid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `corr_condition`
--

DROP TABLE IF EXISTS `corr_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_condition` (
  `corr_conditionid` bigint unsigned NOT NULL,
  `correlationid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`corr_conditionid`),
  KEY `corr_condition_1` (`correlationid`),
  CONSTRAINT `c_corr_condition_1` FOREIGN KEY (`correlationid`) REFERENCES `correlation` (`correlationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corr_condition_group`
--

DROP TABLE IF EXISTS `corr_condition_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_condition_group` (
  `corr_conditionid` bigint unsigned NOT NULL,
  `operator` int NOT NULL DEFAULT '0',
  `groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`corr_conditionid`),
  KEY `corr_condition_group_1` (`groupid`),
  CONSTRAINT `c_corr_condition_group_1` FOREIGN KEY (`corr_conditionid`) REFERENCES `corr_condition` (`corr_conditionid`) ON DELETE CASCADE,
  CONSTRAINT `c_corr_condition_group_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corr_condition_tag`
--

DROP TABLE IF EXISTS `corr_condition_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_condition_tag` (
  `corr_conditionid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`corr_conditionid`),
  CONSTRAINT `c_corr_condition_tag_1` FOREIGN KEY (`corr_conditionid`) REFERENCES `corr_condition` (`corr_conditionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corr_condition_tagpair`
--

DROP TABLE IF EXISTS `corr_condition_tagpair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_condition_tagpair` (
  `corr_conditionid` bigint unsigned NOT NULL,
  `oldtag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `newtag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`corr_conditionid`),
  CONSTRAINT `c_corr_condition_tagpair_1` FOREIGN KEY (`corr_conditionid`) REFERENCES `corr_condition` (`corr_conditionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corr_condition_tagvalue`
--

DROP TABLE IF EXISTS `corr_condition_tagvalue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_condition_tagvalue` (
  `corr_conditionid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`corr_conditionid`),
  CONSTRAINT `c_corr_condition_tagvalue_1` FOREIGN KEY (`corr_conditionid`) REFERENCES `corr_condition` (`corr_conditionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corr_operation`
--

DROP TABLE IF EXISTS `corr_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `corr_operation` (
  `corr_operationid` bigint unsigned NOT NULL,
  `correlationid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`corr_operationid`),
  KEY `corr_operation_1` (`correlationid`),
  CONSTRAINT `c_corr_operation_1` FOREIGN KEY (`correlationid`) REFERENCES `correlation` (`correlationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `correlation`
--

DROP TABLE IF EXISTS `correlation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `correlation` (
  `correlationid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `evaltype` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `formula` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`correlationid`),
  UNIQUE KEY `correlation_2` (`name`),
  KEY `correlation_1` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dashboard`
--

DROP TABLE IF EXISTS `dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard` (
  `dashboardid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `userid` bigint unsigned DEFAULT NULL,
  `private` int NOT NULL DEFAULT '1',
  `templateid` bigint unsigned DEFAULT NULL,
  `display_period` int NOT NULL DEFAULT '30',
  `auto_start` int NOT NULL DEFAULT '1',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`dashboardid`),
  KEY `dashboard_1` (`userid`),
  KEY `dashboard_2` (`templateid`),
  CONSTRAINT `c_dashboard_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`),
  CONSTRAINT `c_dashboard_2` FOREIGN KEY (`templateid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dashboard_page`
--

DROP TABLE IF EXISTS `dashboard_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_page` (
  `dashboard_pageid` bigint unsigned NOT NULL,
  `dashboardid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `display_period` int NOT NULL DEFAULT '0',
  `sortorder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`dashboard_pageid`),
  KEY `dashboard_page_1` (`dashboardid`),
  CONSTRAINT `c_dashboard_page_1` FOREIGN KEY (`dashboardid`) REFERENCES `dashboard` (`dashboardid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dashboard_user`
--

DROP TABLE IF EXISTS `dashboard_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_user` (
  `dashboard_userid` bigint unsigned NOT NULL,
  `dashboardid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `permission` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`dashboard_userid`),
  UNIQUE KEY `dashboard_user_1` (`dashboardid`,`userid`),
  KEY `c_dashboard_user_2` (`userid`),
  CONSTRAINT `c_dashboard_user_1` FOREIGN KEY (`dashboardid`) REFERENCES `dashboard` (`dashboardid`) ON DELETE CASCADE,
  CONSTRAINT `c_dashboard_user_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dashboard_usrgrp`
--

DROP TABLE IF EXISTS `dashboard_usrgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_usrgrp` (
  `dashboard_usrgrpid` bigint unsigned NOT NULL,
  `dashboardid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  `permission` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`dashboard_usrgrpid`),
  UNIQUE KEY `dashboard_usrgrp_1` (`dashboardid`,`usrgrpid`),
  KEY `c_dashboard_usrgrp_2` (`usrgrpid`),
  CONSTRAINT `c_dashboard_usrgrp_1` FOREIGN KEY (`dashboardid`) REFERENCES `dashboard` (`dashboardid`) ON DELETE CASCADE,
  CONSTRAINT `c_dashboard_usrgrp_2` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dbversion`
--

DROP TABLE IF EXISTS `dbversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dbversion` (
  `dbversionid` bigint unsigned NOT NULL,
  `mandatory` int NOT NULL DEFAULT '0',
  `optional` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`dbversionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dchecks`
--

DROP TABLE IF EXISTS `dchecks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dchecks` (
  `dcheckid` bigint unsigned NOT NULL,
  `druleid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `key_` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `snmp_community` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ports` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `snmpv3_securityname` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `snmpv3_securitylevel` int NOT NULL DEFAULT '0',
  `snmpv3_authpassphrase` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `snmpv3_privpassphrase` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uniq` int NOT NULL DEFAULT '0',
  `snmpv3_authprotocol` int NOT NULL DEFAULT '0',
  `snmpv3_privprotocol` int NOT NULL DEFAULT '0',
  `snmpv3_contextname` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host_source` int NOT NULL DEFAULT '1',
  `name_source` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`dcheckid`),
  KEY `dchecks_1` (`druleid`,`host_source`,`name_source`),
  CONSTRAINT `c_dchecks_1` FOREIGN KEY (`druleid`) REFERENCES `drules` (`druleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `dchecks_insert` AFTER INSERT ON `dchecks` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (10,new.dcheckid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `dchecks_update` AFTER UPDATE ON `dchecks` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (10,old.dcheckid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `dchecks_delete` BEFORE DELETE ON `dchecks` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (10,old.dcheckid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dhosts`
--

DROP TABLE IF EXISTS `dhosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dhosts` (
  `dhostid` bigint unsigned NOT NULL,
  `druleid` bigint unsigned NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `lastup` int NOT NULL DEFAULT '0',
  `lastdown` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`dhostid`),
  KEY `dhosts_1` (`druleid`),
  CONSTRAINT `c_dhosts_1` FOREIGN KEY (`druleid`) REFERENCES `drules` (`druleid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drules`
--

DROP TABLE IF EXISTS `drules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drules` (
  `druleid` bigint unsigned NOT NULL,
  `proxy_hostid` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `iprange` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `delay` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '1h',
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`druleid`),
  UNIQUE KEY `drules_2` (`name`),
  KEY `drules_1` (`proxy_hostid`),
  CONSTRAINT `c_drules_1` FOREIGN KEY (`proxy_hostid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `drules_insert` AFTER INSERT ON `drules` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (9,new.druleid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `drules_update` AFTER UPDATE ON `drules` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (9,old.druleid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `drules_delete` BEFORE DELETE ON `drules` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (9,old.druleid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dservices`
--

DROP TABLE IF EXISTS `dservices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dservices` (
  `dserviceid` bigint unsigned NOT NULL,
  `dhostid` bigint unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `port` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `lastup` int NOT NULL DEFAULT '0',
  `lastdown` int NOT NULL DEFAULT '0',
  `dcheckid` bigint unsigned NOT NULL,
  `ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `dns` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`dserviceid`),
  UNIQUE KEY `dservices_1` (`dcheckid`,`ip`,`port`),
  KEY `dservices_2` (`dhostid`),
  CONSTRAINT `c_dservices_1` FOREIGN KEY (`dhostid`) REFERENCES `dhosts` (`dhostid`) ON DELETE CASCADE,
  CONSTRAINT `c_dservices_2` FOREIGN KEY (`dcheckid`) REFERENCES `dchecks` (`dcheckid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `escalations`
--

DROP TABLE IF EXISTS `escalations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escalations` (
  `escalationid` bigint unsigned NOT NULL,
  `actionid` bigint unsigned NOT NULL,
  `triggerid` bigint unsigned DEFAULT NULL,
  `eventid` bigint unsigned DEFAULT NULL,
  `r_eventid` bigint unsigned DEFAULT NULL,
  `nextcheck` int NOT NULL DEFAULT '0',
  `esc_step` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `itemid` bigint unsigned DEFAULT NULL,
  `acknowledgeid` bigint unsigned DEFAULT NULL,
  `servicealarmid` bigint unsigned DEFAULT NULL,
  `serviceid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`escalationid`),
  UNIQUE KEY `escalations_1` (`triggerid`,`itemid`,`serviceid`,`escalationid`),
  KEY `escalations_2` (`eventid`),
  KEY `escalations_3` (`nextcheck`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_recovery`
--

DROP TABLE IF EXISTS `event_recovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_recovery` (
  `eventid` bigint unsigned NOT NULL,
  `r_eventid` bigint unsigned NOT NULL,
  `c_eventid` bigint unsigned DEFAULT NULL,
  `correlationid` bigint unsigned DEFAULT NULL,
  `userid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`eventid`),
  KEY `event_recovery_1` (`r_eventid`),
  KEY `event_recovery_2` (`c_eventid`),
  CONSTRAINT `c_event_recovery_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_recovery_2` FOREIGN KEY (`r_eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_recovery_3` FOREIGN KEY (`c_eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_suppress`
--

DROP TABLE IF EXISTS `event_suppress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_suppress` (
  `event_suppressid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `maintenanceid` bigint unsigned DEFAULT NULL,
  `suppress_until` int NOT NULL DEFAULT '0',
  `userid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`event_suppressid`),
  UNIQUE KEY `event_suppress_1` (`eventid`,`maintenanceid`),
  KEY `event_suppress_2` (`suppress_until`),
  KEY `event_suppress_3` (`maintenanceid`),
  KEY `c_event_suppress_3` (`userid`),
  CONSTRAINT `c_event_suppress_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_suppress_2` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_suppress_3` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_symptom`
--

DROP TABLE IF EXISTS `event_symptom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_symptom` (
  `eventid` bigint unsigned NOT NULL,
  `cause_eventid` bigint unsigned NOT NULL,
  PRIMARY KEY (`eventid`),
  KEY `event_symptom_1` (`cause_eventid`),
  CONSTRAINT `c_event_symptom_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_symptom_2` FOREIGN KEY (`cause_eventid`) REFERENCES `events` (`eventid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_tag`
--

DROP TABLE IF EXISTS `event_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_tag` (
  `eventtagid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`eventtagid`),
  KEY `event_tag_1` (`eventid`),
  CONSTRAINT `c_event_tag_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `eventid` bigint unsigned NOT NULL,
  `source` int NOT NULL DEFAULT '0',
  `object` int NOT NULL DEFAULT '0',
  `objectid` bigint unsigned NOT NULL DEFAULT '0',
  `clock` int NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '0',
  `acknowledged` int NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  `name` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `severity` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventid`),
  KEY `events_1` (`source`,`object`,`objectid`,`clock`),
  KEY `events_2` (`source`,`object`,`clock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressions`
--

DROP TABLE IF EXISTS `expressions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressions` (
  `expressionid` bigint unsigned NOT NULL,
  `regexpid` bigint unsigned NOT NULL,
  `expression` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `expression_type` int NOT NULL DEFAULT '0',
  `exp_delimiter` varchar(1) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `case_sensitive` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`expressionid`),
  KEY `expressions_1` (`regexpid`),
  CONSTRAINT `c_expressions_1` FOREIGN KEY (`regexpid`) REFERENCES `regexps` (`regexpid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `functions`
--

DROP TABLE IF EXISTS `functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `functions` (
  `functionid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `triggerid` bigint unsigned NOT NULL,
  `name` varchar(12) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `parameter` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  PRIMARY KEY (`functionid`),
  KEY `functions_1` (`triggerid`),
  KEY `functions_2` (`itemid`,`name`,`parameter`),
  CONSTRAINT `c_functions_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`),
  CONSTRAINT `c_functions_2` FOREIGN KEY (`triggerid`) REFERENCES `triggers` (`triggerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `functions_insert` AFTER INSERT ON `functions` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (7,new.functionid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `functions_update` AFTER UPDATE ON `functions` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (7,old.functionid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `functions_delete` BEFORE DELETE ON `functions` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (7,old.functionid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `globalmacro`
--

DROP TABLE IF EXISTS `globalmacro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `globalmacro` (
  `globalmacroid` bigint unsigned NOT NULL,
  `macro` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`globalmacroid`),
  UNIQUE KEY `globalmacro_1` (`macro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `globalvars`
--

DROP TABLE IF EXISTS `globalvars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `globalvars` (
  `globalvarid` bigint unsigned NOT NULL,
  `snmp_lastsize` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`globalvarid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `graph_discovery`
--

DROP TABLE IF EXISTS `graph_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph_discovery` (
  `graphid` bigint unsigned NOT NULL,
  `parent_graphid` bigint unsigned NOT NULL,
  `lastcheck` int NOT NULL DEFAULT '0',
  `ts_delete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`graphid`),
  KEY `graph_discovery_1` (`parent_graphid`),
  CONSTRAINT `c_graph_discovery_1` FOREIGN KEY (`graphid`) REFERENCES `graphs` (`graphid`) ON DELETE CASCADE,
  CONSTRAINT `c_graph_discovery_2` FOREIGN KEY (`parent_graphid`) REFERENCES `graphs` (`graphid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `graph_theme`
--

DROP TABLE IF EXISTS `graph_theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graph_theme` (
  `graphthemeid` bigint unsigned NOT NULL,
  `theme` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `backgroundcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `graphcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `gridcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `maingridcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `gridbordercolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `textcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `highlightcolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `leftpercentilecolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `rightpercentilecolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `nonworktimecolor` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `colorpalette` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`graphthemeid`),
  UNIQUE KEY `graph_theme_1` (`theme`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `graphs`
--

DROP TABLE IF EXISTS `graphs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graphs` (
  `graphid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `width` int NOT NULL DEFAULT '900',
  `height` int NOT NULL DEFAULT '200',
  `yaxismin` double NOT NULL DEFAULT '0',
  `yaxismax` double NOT NULL DEFAULT '100',
  `templateid` bigint unsigned DEFAULT NULL,
  `show_work_period` int NOT NULL DEFAULT '1',
  `show_triggers` int NOT NULL DEFAULT '1',
  `graphtype` int NOT NULL DEFAULT '0',
  `show_legend` int NOT NULL DEFAULT '1',
  `show_3d` int NOT NULL DEFAULT '0',
  `percent_left` double NOT NULL DEFAULT '0',
  `percent_right` double NOT NULL DEFAULT '0',
  `ymin_type` int NOT NULL DEFAULT '0',
  `ymax_type` int NOT NULL DEFAULT '0',
  `ymin_itemid` bigint unsigned DEFAULT NULL,
  `ymax_itemid` bigint unsigned DEFAULT NULL,
  `flags` int NOT NULL DEFAULT '0',
  `discover` int NOT NULL DEFAULT '0',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`graphid`),
  KEY `graphs_1` (`name`),
  KEY `graphs_2` (`templateid`),
  KEY `graphs_3` (`ymin_itemid`),
  KEY `graphs_4` (`ymax_itemid`),
  CONSTRAINT `c_graphs_1` FOREIGN KEY (`templateid`) REFERENCES `graphs` (`graphid`) ON DELETE CASCADE,
  CONSTRAINT `c_graphs_2` FOREIGN KEY (`ymin_itemid`) REFERENCES `items` (`itemid`),
  CONSTRAINT `c_graphs_3` FOREIGN KEY (`ymax_itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `graphs_items`
--

DROP TABLE IF EXISTS `graphs_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graphs_items` (
  `gitemid` bigint unsigned NOT NULL,
  `graphid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `drawtype` int NOT NULL DEFAULT '0',
  `sortorder` int NOT NULL DEFAULT '0',
  `color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '009600',
  `yaxisside` int NOT NULL DEFAULT '0',
  `calc_fnc` int NOT NULL DEFAULT '2',
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`gitemid`),
  KEY `graphs_items_1` (`itemid`),
  KEY `graphs_items_2` (`graphid`),
  CONSTRAINT `c_graphs_items_1` FOREIGN KEY (`graphid`) REFERENCES `graphs` (`graphid`) ON DELETE CASCADE,
  CONSTRAINT `c_graphs_items_2` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_discovery`
--

DROP TABLE IF EXISTS `group_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_discovery` (
  `groupid` bigint unsigned NOT NULL,
  `parent_group_prototypeid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `lastcheck` int NOT NULL DEFAULT '0',
  `ts_delete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupid`),
  KEY `c_group_discovery_2` (`parent_group_prototypeid`),
  CONSTRAINT `c_group_discovery_1` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE,
  CONSTRAINT `c_group_discovery_2` FOREIGN KEY (`parent_group_prototypeid`) REFERENCES `group_prototype` (`group_prototypeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_prototype`
--

DROP TABLE IF EXISTS `group_prototype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_prototype` (
  `group_prototypeid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `groupid` bigint unsigned DEFAULT NULL,
  `templateid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`group_prototypeid`),
  KEY `group_prototype_1` (`hostid`),
  KEY `c_group_prototype_2` (`groupid`),
  KEY `c_group_prototype_3` (`templateid`),
  CONSTRAINT `c_group_prototype_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE,
  CONSTRAINT `c_group_prototype_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`),
  CONSTRAINT `c_group_prototype_3` FOREIGN KEY (`templateid`) REFERENCES `group_prototype` (`group_prototypeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ha_node`
--

DROP TABLE IF EXISTS `ha_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ha_node` (
  `ha_nodeid` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `address` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `port` int NOT NULL DEFAULT '10051',
  `lastaccess` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `ha_sessionid` varchar(25) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`ha_nodeid`),
  UNIQUE KEY `ha_node_1` (`name`),
  KEY `ha_node_2` (`status`,`lastaccess`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `value` double NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`,`ns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_log`
--

DROP TABLE IF EXISTS `history_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_log` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `timestamp` int NOT NULL DEFAULT '0',
  `source` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `severity` int NOT NULL DEFAULT '0',
  `value` text COLLATE utf8mb4_bin NOT NULL,
  `logeventid` int NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`,`ns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_str`
--

DROP TABLE IF EXISTS `history_str`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_str` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`,`ns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_text`
--

DROP TABLE IF EXISTS `history_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_text` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `value` text COLLATE utf8mb4_bin NOT NULL,
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`,`ns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_uint`
--

DROP TABLE IF EXISTS `history_uint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history_uint` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `value` bigint unsigned NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`,`ns`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host_discovery`
--

DROP TABLE IF EXISTS `host_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_discovery` (
  `hostid` bigint unsigned NOT NULL,
  `parent_hostid` bigint unsigned DEFAULT NULL,
  `parent_itemid` bigint unsigned DEFAULT NULL,
  `host` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `lastcheck` int NOT NULL DEFAULT '0',
  `ts_delete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostid`),
  KEY `c_host_discovery_2` (`parent_hostid`),
  KEY `c_host_discovery_3` (`parent_itemid`),
  CONSTRAINT `c_host_discovery_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE,
  CONSTRAINT `c_host_discovery_2` FOREIGN KEY (`parent_hostid`) REFERENCES `hosts` (`hostid`),
  CONSTRAINT `c_host_discovery_3` FOREIGN KEY (`parent_itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host_inventory`
--

DROP TABLE IF EXISTS `host_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_inventory` (
  `hostid` bigint unsigned NOT NULL,
  `inventory_mode` int NOT NULL DEFAULT '0',
  `type` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type_full` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `alias` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `os` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `os_full` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `os_short` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `serialno_a` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `serialno_b` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tag` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `asset_tag` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `macaddress_a` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `macaddress_b` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `hardware` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `hardware_full` text COLLATE utf8mb4_bin NOT NULL,
  `software` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `software_full` text COLLATE utf8mb4_bin NOT NULL,
  `software_app_a` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `software_app_b` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `software_app_c` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `software_app_d` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `software_app_e` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `contact` text COLLATE utf8mb4_bin NOT NULL,
  `location` text COLLATE utf8mb4_bin NOT NULL,
  `location_lat` varchar(16) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `location_lon` varchar(16) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `notes` text COLLATE utf8mb4_bin NOT NULL,
  `chassis` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `model` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `hw_arch` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `vendor` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `contract_number` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `installer_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `deployment_status` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url_a` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url_b` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url_c` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host_networks` text COLLATE utf8mb4_bin NOT NULL,
  `host_netmask` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host_router` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `oob_ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `oob_netmask` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `oob_router` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `date_hw_purchase` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `date_hw_install` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `date_hw_expiry` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `date_hw_decomm` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_address_a` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_address_b` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_address_c` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_city` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_state` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_country` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_zip` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_rack` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `site_notes` text COLLATE utf8mb4_bin NOT NULL,
  `poc_1_name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_email` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_phone_a` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_phone_b` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_cell` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_screen` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_1_notes` text COLLATE utf8mb4_bin NOT NULL,
  `poc_2_name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_email` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_phone_a` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_phone_b` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_cell` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_screen` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `poc_2_notes` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`hostid`),
  CONSTRAINT `c_host_inventory_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host_rtdata`
--

DROP TABLE IF EXISTS `host_rtdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_rtdata` (
  `hostid` bigint unsigned NOT NULL,
  `active_available` int NOT NULL DEFAULT '0',
  `lastaccess` int NOT NULL DEFAULT '0',
  `version` int NOT NULL DEFAULT '0',
  `compatibility` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostid`),
  CONSTRAINT `c_host_rtdata_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host_tag`
--

DROP TABLE IF EXISTS `host_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_tag` (
  `hosttagid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `automatic` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hosttagid`),
  KEY `host_tag_1` (`hostid`),
  CONSTRAINT `c_host_tag_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `host_tag_insert` AFTER INSERT ON `host_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (2,new.hosttagid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `host_tag_update` AFTER UPDATE ON `host_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (2,old.hosttagid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `host_tag_delete` BEFORE DELETE ON `host_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (2,old.hosttagid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `hostmacro`
--

DROP TABLE IF EXISTS `hostmacro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hostmacro` (
  `hostmacroid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `macro` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `automatic` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostmacroid`),
  UNIQUE KEY `hostmacro_1` (`hostid`,`macro`),
  CONSTRAINT `c_hostmacro_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hosts` (
  `hostid` bigint unsigned NOT NULL,
  `proxy_hostid` bigint unsigned DEFAULT NULL,
  `host` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '0',
  `ipmi_authtype` int NOT NULL DEFAULT '-1',
  `ipmi_privilege` int NOT NULL DEFAULT '2',
  `ipmi_username` varchar(16) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ipmi_password` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `maintenanceid` bigint unsigned DEFAULT NULL,
  `maintenance_status` int NOT NULL DEFAULT '0',
  `maintenance_type` int NOT NULL DEFAULT '0',
  `maintenance_from` int NOT NULL DEFAULT '0',
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `flags` int NOT NULL DEFAULT '0',
  `templateid` bigint unsigned DEFAULT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `tls_connect` int NOT NULL DEFAULT '1',
  `tls_accept` int NOT NULL DEFAULT '1',
  `tls_issuer` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tls_subject` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tls_psk_identity` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tls_psk` varchar(512) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `proxy_address` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `auto_compress` int NOT NULL DEFAULT '1',
  `discover` int NOT NULL DEFAULT '0',
  `custom_interfaces` int NOT NULL DEFAULT '0',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `name_upper` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `vendor_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `vendor_version` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`hostid`),
  KEY `hosts_1` (`host`),
  KEY `hosts_2` (`status`),
  KEY `hosts_3` (`proxy_hostid`),
  KEY `hosts_4` (`name`),
  KEY `hosts_5` (`maintenanceid`),
  KEY `hosts_6` (`name_upper`),
  KEY `c_hosts_3` (`templateid`),
  CONSTRAINT `c_hosts_1` FOREIGN KEY (`proxy_hostid`) REFERENCES `hosts` (`hostid`),
  CONSTRAINT `c_hosts_2` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`),
  CONSTRAINT `c_hosts_3` FOREIGN KEY (`templateid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `hosts_name_upper_insert` BEFORE INSERT ON `hosts` FOR EACH ROW set new.name_upper=upper(new.name) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `hosts_insert` AFTER INSERT ON `hosts` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (1,new.hostid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `hosts_name_upper_update` BEFORE UPDATE ON `hosts` FOR EACH ROW begin
if new.name<>old.name
then
set new.name_upper=upper(new.name);
end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `hosts_update` AFTER UPDATE ON `hosts` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (1,old.hostid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `hosts_delete` BEFORE DELETE ON `hosts` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (1,old.hostid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `hosts_groups`
--

DROP TABLE IF EXISTS `hosts_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hosts_groups` (
  `hostgroupid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`hostgroupid`),
  UNIQUE KEY `hosts_groups_1` (`hostid`,`groupid`),
  KEY `hosts_groups_2` (`groupid`),
  CONSTRAINT `c_hosts_groups_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE,
  CONSTRAINT `c_hosts_groups_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hosts_templates`
--

DROP TABLE IF EXISTS `hosts_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hosts_templates` (
  `hosttemplateid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `templateid` bigint unsigned NOT NULL,
  `link_type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hosttemplateid`),
  UNIQUE KEY `hosts_templates_1` (`hostid`,`templateid`),
  KEY `hosts_templates_2` (`templateid`),
  CONSTRAINT `c_hosts_templates_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE,
  CONSTRAINT `c_hosts_templates_2` FOREIGN KEY (`templateid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `housekeeper`
--

DROP TABLE IF EXISTS `housekeeper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `housekeeper` (
  `housekeeperid` bigint unsigned NOT NULL,
  `tablename` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `field` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` bigint unsigned NOT NULL,
  PRIMARY KEY (`housekeeperid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hstgrp`
--

DROP TABLE IF EXISTS `hstgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hstgrp` (
  `groupid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `flags` int NOT NULL DEFAULT '0',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupid`),
  UNIQUE KEY `hstgrp_1` (`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `httpstep`
--

DROP TABLE IF EXISTS `httpstep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httpstep` (
  `httpstepid` bigint unsigned NOT NULL,
  `httptestid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `no` int NOT NULL DEFAULT '0',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `timeout` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '15s',
  `posts` text COLLATE utf8mb4_bin NOT NULL,
  `required` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status_codes` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `follow_redirects` int NOT NULL DEFAULT '1',
  `retrieve_mode` int NOT NULL DEFAULT '0',
  `post_type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`httpstepid`),
  KEY `httpstep_1` (`httptestid`),
  CONSTRAINT `c_httpstep_1` FOREIGN KEY (`httptestid`) REFERENCES `httptest` (`httptestid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_insert` AFTER INSERT ON `httpstep` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (14,new.httpstepid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_update` AFTER UPDATE ON `httpstep` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (14,old.httpstepid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_delete` BEFORE DELETE ON `httpstep` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (14,old.httpstepid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `httpstep_field`
--

DROP TABLE IF EXISTS `httpstep_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httpstep_field` (
  `httpstep_fieldid` bigint unsigned NOT NULL,
  `httpstepid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`httpstep_fieldid`),
  KEY `httpstep_field_1` (`httpstepid`),
  CONSTRAINT `c_httpstep_field_1` FOREIGN KEY (`httpstepid`) REFERENCES `httpstep` (`httpstepid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_field_insert` AFTER INSERT ON `httpstep_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (15,new.httpstep_fieldid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_field_update` AFTER UPDATE ON `httpstep_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (15,old.httpstep_fieldid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstep_field_delete` BEFORE DELETE ON `httpstep_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (15,old.httpstep_fieldid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `httpstepitem`
--

DROP TABLE IF EXISTS `httpstepitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httpstepitem` (
  `httpstepitemid` bigint unsigned NOT NULL,
  `httpstepid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`httpstepitemid`),
  UNIQUE KEY `httpstepitem_1` (`httpstepid`,`itemid`),
  KEY `httpstepitem_2` (`itemid`),
  CONSTRAINT `c_httpstepitem_1` FOREIGN KEY (`httpstepid`) REFERENCES `httpstep` (`httpstepid`),
  CONSTRAINT `c_httpstepitem_2` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstepitem_insert` AFTER INSERT ON `httpstepitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (16,new.httpstepitemid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstepitem_update` AFTER UPDATE ON `httpstepitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (16,old.httpstepitemid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httpstepitem_delete` BEFORE DELETE ON `httpstepitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (16,old.httpstepitemid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `httptest`
--

DROP TABLE IF EXISTS `httptest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httptest` (
  `httptestid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `delay` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '1m',
  `status` int NOT NULL DEFAULT '0',
  `agent` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Zabbix',
  `authentication` int NOT NULL DEFAULT '0',
  `http_user` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `http_password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `hostid` bigint unsigned NOT NULL,
  `templateid` bigint unsigned DEFAULT NULL,
  `http_proxy` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `retries` int NOT NULL DEFAULT '1',
  `ssl_cert_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `verify_peer` int NOT NULL DEFAULT '0',
  `verify_host` int NOT NULL DEFAULT '0',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`httptestid`),
  UNIQUE KEY `httptest_2` (`hostid`,`name`),
  KEY `httptest_3` (`status`),
  KEY `httptest_4` (`templateid`),
  CONSTRAINT `c_httptest_2` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`),
  CONSTRAINT `c_httptest_3` FOREIGN KEY (`templateid`) REFERENCES `httptest` (`httptestid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_insert` AFTER INSERT ON `httptest` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (11,new.httptestid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_update` AFTER UPDATE ON `httptest` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (11,old.httptestid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_delete` BEFORE DELETE ON `httptest` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (11,old.httptestid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `httptest_field`
--

DROP TABLE IF EXISTS `httptest_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httptest_field` (
  `httptest_fieldid` bigint unsigned NOT NULL,
  `httptestid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`httptest_fieldid`),
  KEY `httptest_field_1` (`httptestid`),
  CONSTRAINT `c_httptest_field_1` FOREIGN KEY (`httptestid`) REFERENCES `httptest` (`httptestid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_field_insert` AFTER INSERT ON `httptest_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (12,new.httptest_fieldid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_field_update` AFTER UPDATE ON `httptest_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (12,old.httptest_fieldid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptest_field_delete` BEFORE DELETE ON `httptest_field` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (12,old.httptest_fieldid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `httptest_tag`
--

DROP TABLE IF EXISTS `httptest_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httptest_tag` (
  `httptesttagid` bigint unsigned NOT NULL,
  `httptestid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`httptesttagid`),
  KEY `httptest_tag_1` (`httptestid`),
  CONSTRAINT `c_httptest_tag_1` FOREIGN KEY (`httptestid`) REFERENCES `httptest` (`httptestid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `httptestitem`
--

DROP TABLE IF EXISTS `httptestitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `httptestitem` (
  `httptestitemid` bigint unsigned NOT NULL,
  `httptestid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`httptestitemid`),
  UNIQUE KEY `httptestitem_1` (`httptestid`,`itemid`),
  KEY `httptestitem_2` (`itemid`),
  CONSTRAINT `c_httptestitem_1` FOREIGN KEY (`httptestid`) REFERENCES `httptest` (`httptestid`),
  CONSTRAINT `c_httptestitem_2` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptestitem_insert` AFTER INSERT ON `httptestitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (13,new.httptestitemid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptestitem_update` AFTER UPDATE ON `httptestitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (13,old.httptestitemid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `httptestitem_delete` BEFORE DELETE ON `httptestitem` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (13,old.httptestitemid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `icon_map`
--

DROP TABLE IF EXISTS `icon_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `icon_map` (
  `iconmapid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `default_iconid` bigint unsigned NOT NULL,
  PRIMARY KEY (`iconmapid`),
  UNIQUE KEY `icon_map_1` (`name`),
  KEY `icon_map_2` (`default_iconid`),
  CONSTRAINT `c_icon_map_1` FOREIGN KEY (`default_iconid`) REFERENCES `images` (`imageid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `icon_mapping`
--

DROP TABLE IF EXISTS `icon_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `icon_mapping` (
  `iconmappingid` bigint unsigned NOT NULL,
  `iconmapid` bigint unsigned NOT NULL,
  `iconid` bigint unsigned NOT NULL,
  `inventory_link` int NOT NULL DEFAULT '0',
  `expression` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sortorder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`iconmappingid`),
  KEY `icon_mapping_1` (`iconmapid`),
  KEY `icon_mapping_2` (`iconid`),
  CONSTRAINT `c_icon_mapping_1` FOREIGN KEY (`iconmapid`) REFERENCES `icon_map` (`iconmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_icon_mapping_2` FOREIGN KEY (`iconid`) REFERENCES `images` (`imageid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ids`
--

DROP TABLE IF EXISTS `ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ids` (
  `table_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `field_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `nextid` bigint unsigned NOT NULL,
  PRIMARY KEY (`table_name`,`field_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `imageid` bigint unsigned NOT NULL,
  `imagetype` int NOT NULL DEFAULT '0',
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `image` longblob NOT NULL,
  PRIMARY KEY (`imageid`),
  UNIQUE KEY `images_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interface`
--

DROP TABLE IF EXISTS `interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interface` (
  `interfaceid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `main` int NOT NULL DEFAULT '0',
  `type` int NOT NULL DEFAULT '1',
  `useip` int NOT NULL DEFAULT '1',
  `ip` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '127.0.0.1',
  `dns` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `port` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '10050',
  `available` int NOT NULL DEFAULT '0',
  `error` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `errors_from` int NOT NULL DEFAULT '0',
  `disable_until` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`interfaceid`),
  KEY `interface_1` (`hostid`,`type`),
  KEY `interface_2` (`ip`,`dns`),
  KEY `interface_3` (`available`),
  CONSTRAINT `c_interface_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interface_discovery`
--

DROP TABLE IF EXISTS `interface_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interface_discovery` (
  `interfaceid` bigint unsigned NOT NULL,
  `parent_interfaceid` bigint unsigned NOT NULL,
  PRIMARY KEY (`interfaceid`),
  KEY `c_interface_discovery_2` (`parent_interfaceid`),
  CONSTRAINT `c_interface_discovery_1` FOREIGN KEY (`interfaceid`) REFERENCES `interface` (`interfaceid`) ON DELETE CASCADE,
  CONSTRAINT `c_interface_discovery_2` FOREIGN KEY (`parent_interfaceid`) REFERENCES `interface` (`interfaceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interface_snmp`
--

DROP TABLE IF EXISTS `interface_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interface_snmp` (
  `interfaceid` bigint unsigned NOT NULL,
  `version` int NOT NULL DEFAULT '2',
  `bulk` int NOT NULL DEFAULT '1',
  `community` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `securityname` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `securitylevel` int NOT NULL DEFAULT '0',
  `authpassphrase` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `privpassphrase` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `authprotocol` int NOT NULL DEFAULT '0',
  `privprotocol` int NOT NULL DEFAULT '0',
  `contextname` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `max_repetitions` int NOT NULL DEFAULT '10',
  PRIMARY KEY (`interfaceid`),
  CONSTRAINT `c_interface_snmp_1` FOREIGN KEY (`interfaceid`) REFERENCES `interface` (`interfaceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_condition`
--

DROP TABLE IF EXISTS `item_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_condition` (
  `item_conditionid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `operator` int NOT NULL DEFAULT '8',
  `macro` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`item_conditionid`),
  KEY `item_condition_1` (`itemid`),
  CONSTRAINT `c_item_condition_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_discovery`
--

DROP TABLE IF EXISTS `item_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_discovery` (
  `itemdiscoveryid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `parent_itemid` bigint unsigned NOT NULL,
  `key_` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `lastcheck` int NOT NULL DEFAULT '0',
  `ts_delete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemdiscoveryid`),
  UNIQUE KEY `item_discovery_1` (`itemid`,`parent_itemid`),
  KEY `item_discovery_2` (`parent_itemid`),
  CONSTRAINT `c_item_discovery_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE,
  CONSTRAINT `c_item_discovery_2` FOREIGN KEY (`parent_itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_parameter`
--

DROP TABLE IF EXISTS `item_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_parameter` (
  `item_parameterid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`item_parameterid`),
  KEY `item_parameter_1` (`itemid`),
  CONSTRAINT `c_item_parameter_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_preproc`
--

DROP TABLE IF EXISTS `item_preproc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_preproc` (
  `item_preprocid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `step` int NOT NULL DEFAULT '0',
  `type` int NOT NULL DEFAULT '0',
  `params` text COLLATE utf8mb4_bin NOT NULL,
  `error_handler` int NOT NULL DEFAULT '0',
  `error_handler_params` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`item_preprocid`),
  KEY `item_preproc_1` (`itemid`,`step`),
  CONSTRAINT `c_item_preproc_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_preproc_insert` AFTER INSERT ON `item_preproc` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (8,new.item_preprocid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_preproc_update` AFTER UPDATE ON `item_preproc` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (8,old.item_preprocid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_preproc_delete` BEFORE DELETE ON `item_preproc` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (8,old.item_preprocid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `item_rtdata`
--

DROP TABLE IF EXISTS `item_rtdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_rtdata` (
  `itemid` bigint unsigned NOT NULL,
  `lastlogsize` bigint unsigned NOT NULL DEFAULT '0',
  `state` int NOT NULL DEFAULT '0',
  `mtime` int NOT NULL DEFAULT '0',
  `error` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`itemid`),
  CONSTRAINT `c_item_rtdata_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_tag`
--

DROP TABLE IF EXISTS `item_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_tag` (
  `itemtagid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`itemtagid`),
  KEY `item_tag_1` (`itemid`),
  CONSTRAINT `c_item_tag_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_tag_insert` AFTER INSERT ON `item_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (4,new.itemtagid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_tag_update` AFTER UPDATE ON `item_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (4,old.itemtagid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `item_tag_delete` BEFORE DELETE ON `item_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (4,old.itemtagid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `itemid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `snmp_oid` varchar(512) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `hostid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `key_` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `delay` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `history` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '90d',
  `trends` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  `status` int NOT NULL DEFAULT '0',
  `value_type` int NOT NULL DEFAULT '0',
  `trapper_hosts` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `units` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `formula` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `logtimefmt` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `templateid` bigint unsigned DEFAULT NULL,
  `valuemapid` bigint unsigned DEFAULT NULL,
  `params` text COLLATE utf8mb4_bin NOT NULL,
  `ipmi_sensor` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `authtype` int NOT NULL DEFAULT '0',
  `username` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `publickey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `privatekey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `flags` int NOT NULL DEFAULT '0',
  `interfaceid` bigint unsigned DEFAULT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `inventory_link` int NOT NULL DEFAULT '0',
  `lifetime` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '30d',
  `evaltype` int NOT NULL DEFAULT '0',
  `jmx_endpoint` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `master_itemid` bigint unsigned DEFAULT NULL,
  `timeout` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '3s',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `query_fields` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `posts` text COLLATE utf8mb4_bin NOT NULL,
  `status_codes` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '200',
  `follow_redirects` int NOT NULL DEFAULT '1',
  `post_type` int NOT NULL DEFAULT '0',
  `http_proxy` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `headers` text COLLATE utf8mb4_bin NOT NULL,
  `retrieve_mode` int NOT NULL DEFAULT '0',
  `request_method` int NOT NULL DEFAULT '0',
  `output_format` int NOT NULL DEFAULT '0',
  `ssl_cert_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_file` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `ssl_key_password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `verify_peer` int NOT NULL DEFAULT '0',
  `verify_host` int NOT NULL DEFAULT '0',
  `allow_traps` int NOT NULL DEFAULT '0',
  `discover` int NOT NULL DEFAULT '0',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `name_upper` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`itemid`),
  KEY `items_1` (`hostid`,`key_`(764)),
  KEY `items_3` (`status`),
  KEY `items_4` (`templateid`),
  KEY `items_5` (`valuemapid`),
  KEY `items_6` (`interfaceid`),
  KEY `items_7` (`master_itemid`),
  KEY `items_8` (`key_`(768)),
  KEY `items_9` (`hostid`,`name_upper`),
  CONSTRAINT `c_items_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`),
  CONSTRAINT `c_items_2` FOREIGN KEY (`templateid`) REFERENCES `items` (`itemid`),
  CONSTRAINT `c_items_3` FOREIGN KEY (`valuemapid`) REFERENCES `valuemap` (`valuemapid`),
  CONSTRAINT `c_items_4` FOREIGN KEY (`interfaceid`) REFERENCES `interface` (`interfaceid`),
  CONSTRAINT `c_items_5` FOREIGN KEY (`master_itemid`) REFERENCES `items` (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `items_name_upper_insert` BEFORE INSERT ON `items` FOR EACH ROW set new.name_upper=upper(new.name) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `items_insert` AFTER INSERT ON `items` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (3,new.itemid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `items_name_upper_update` BEFORE UPDATE ON `items` FOR EACH ROW begin
if new.name<>old.name
then
set new.name_upper=upper(new.name);
end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `items_update` AFTER UPDATE ON `items` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (3,old.itemid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `items_delete` BEFORE DELETE ON `items` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (3,old.itemid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `lld_macro_path`
--

DROP TABLE IF EXISTS `lld_macro_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_macro_path` (
  `lld_macro_pathid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `lld_macro` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `path` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`lld_macro_pathid`),
  UNIQUE KEY `lld_macro_path_1` (`itemid`,`lld_macro`),
  CONSTRAINT `c_lld_macro_path_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override`
--

DROP TABLE IF EXISTS `lld_override`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override` (
  `lld_overrideid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `step` int NOT NULL DEFAULT '0',
  `evaltype` int NOT NULL DEFAULT '0',
  `formula` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `stop` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_overrideid`),
  UNIQUE KEY `lld_override_1` (`itemid`,`name`),
  CONSTRAINT `c_lld_override_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_condition`
--

DROP TABLE IF EXISTS `lld_override_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_condition` (
  `lld_override_conditionid` bigint unsigned NOT NULL,
  `lld_overrideid` bigint unsigned NOT NULL,
  `operator` int NOT NULL DEFAULT '8',
  `macro` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`lld_override_conditionid`),
  KEY `lld_override_condition_1` (`lld_overrideid`),
  CONSTRAINT `c_lld_override_condition_1` FOREIGN KEY (`lld_overrideid`) REFERENCES `lld_override` (`lld_overrideid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_opdiscover`
--

DROP TABLE IF EXISTS `lld_override_opdiscover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_opdiscover` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `discover` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_opdiscover_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_operation`
--

DROP TABLE IF EXISTS `lld_override_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_operation` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `lld_overrideid` bigint unsigned NOT NULL,
  `operationobject` int NOT NULL DEFAULT '0',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`lld_override_operationid`),
  KEY `lld_override_operation_1` (`lld_overrideid`),
  CONSTRAINT `c_lld_override_operation_1` FOREIGN KEY (`lld_overrideid`) REFERENCES `lld_override` (`lld_overrideid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_ophistory`
--

DROP TABLE IF EXISTS `lld_override_ophistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_ophistory` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `history` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '90d',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_ophistory_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_opinventory`
--

DROP TABLE IF EXISTS `lld_override_opinventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_opinventory` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `inventory_mode` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_opinventory_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_opperiod`
--

DROP TABLE IF EXISTS `lld_override_opperiod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_opperiod` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `delay` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_opperiod_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_opseverity`
--

DROP TABLE IF EXISTS `lld_override_opseverity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_opseverity` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `severity` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_opseverity_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_opstatus`
--

DROP TABLE IF EXISTS `lld_override_opstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_opstatus` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_opstatus_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_optag`
--

DROP TABLE IF EXISTS `lld_override_optag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_optag` (
  `lld_override_optagid` bigint unsigned NOT NULL,
  `lld_override_operationid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`lld_override_optagid`),
  KEY `lld_override_optag_1` (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_optag_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_optemplate`
--

DROP TABLE IF EXISTS `lld_override_optemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_optemplate` (
  `lld_override_optemplateid` bigint unsigned NOT NULL,
  `lld_override_operationid` bigint unsigned NOT NULL,
  `templateid` bigint unsigned NOT NULL,
  PRIMARY KEY (`lld_override_optemplateid`),
  UNIQUE KEY `lld_override_optemplate_1` (`lld_override_operationid`,`templateid`),
  KEY `lld_override_optemplate_2` (`templateid`),
  CONSTRAINT `c_lld_override_optemplate_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_lld_override_optemplate_2` FOREIGN KEY (`templateid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lld_override_optrends`
--

DROP TABLE IF EXISTS `lld_override_optrends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lld_override_optrends` (
  `lld_override_operationid` bigint unsigned NOT NULL,
  `trends` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '365d',
  PRIMARY KEY (`lld_override_operationid`),
  CONSTRAINT `c_lld_override_optrends_1` FOREIGN KEY (`lld_override_operationid`) REFERENCES `lld_override_operation` (`lld_override_operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenance_tag`
--

DROP TABLE IF EXISTS `maintenance_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_tag` (
  `maintenancetagid` bigint unsigned NOT NULL,
  `maintenanceid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '2',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`maintenancetagid`),
  KEY `maintenance_tag_1` (`maintenanceid`),
  CONSTRAINT `c_maintenance_tag_1` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenances`
--

DROP TABLE IF EXISTS `maintenances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenances` (
  `maintenanceid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `maintenance_type` int NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `active_since` int NOT NULL DEFAULT '0',
  `active_till` int NOT NULL DEFAULT '0',
  `tags_evaltype` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`maintenanceid`),
  UNIQUE KEY `maintenances_2` (`name`),
  KEY `maintenances_1` (`active_since`,`active_till`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenances_groups`
--

DROP TABLE IF EXISTS `maintenances_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenances_groups` (
  `maintenance_groupid` bigint unsigned NOT NULL,
  `maintenanceid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`maintenance_groupid`),
  UNIQUE KEY `maintenances_groups_1` (`maintenanceid`,`groupid`),
  KEY `maintenances_groups_2` (`groupid`),
  CONSTRAINT `c_maintenances_groups_1` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE,
  CONSTRAINT `c_maintenances_groups_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenances_hosts`
--

DROP TABLE IF EXISTS `maintenances_hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenances_hosts` (
  `maintenance_hostid` bigint unsigned NOT NULL,
  `maintenanceid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  PRIMARY KEY (`maintenance_hostid`),
  UNIQUE KEY `maintenances_hosts_1` (`maintenanceid`,`hostid`),
  KEY `maintenances_hosts_2` (`hostid`),
  CONSTRAINT `c_maintenances_hosts_1` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE,
  CONSTRAINT `c_maintenances_hosts_2` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenances_windows`
--

DROP TABLE IF EXISTS `maintenances_windows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenances_windows` (
  `maintenance_timeperiodid` bigint unsigned NOT NULL,
  `maintenanceid` bigint unsigned NOT NULL,
  `timeperiodid` bigint unsigned NOT NULL,
  PRIMARY KEY (`maintenance_timeperiodid`),
  UNIQUE KEY `maintenances_windows_1` (`maintenanceid`,`timeperiodid`),
  KEY `maintenances_windows_2` (`timeperiodid`),
  CONSTRAINT `c_maintenances_windows_1` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE,
  CONSTRAINT `c_maintenances_windows_2` FOREIGN KEY (`timeperiodid`) REFERENCES `timeperiods` (`timeperiodid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `mediaid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `mediatypeid` bigint unsigned NOT NULL,
  `sendto` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `active` int NOT NULL DEFAULT '0',
  `severity` int NOT NULL DEFAULT '63',
  `period` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '1-7,00:00-24:00',
  PRIMARY KEY (`mediaid`),
  KEY `media_1` (`userid`),
  KEY `media_2` (`mediatypeid`),
  CONSTRAINT `c_media_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_media_2` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media_type`
--

DROP TABLE IF EXISTS `media_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_type` (
  `mediatypeid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `name` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `smtp_server` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `smtp_helo` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `smtp_email` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `exec_path` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `gsm_modem` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `username` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `passwd` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '1',
  `smtp_port` int NOT NULL DEFAULT '25',
  `smtp_security` int NOT NULL DEFAULT '0',
  `smtp_verify_peer` int NOT NULL DEFAULT '0',
  `smtp_verify_host` int NOT NULL DEFAULT '0',
  `smtp_authentication` int NOT NULL DEFAULT '0',
  `maxsessions` int NOT NULL DEFAULT '1',
  `maxattempts` int NOT NULL DEFAULT '3',
  `attempt_interval` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '10s',
  `content_type` int NOT NULL DEFAULT '1',
  `script` text COLLATE utf8mb4_bin NOT NULL,
  `timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '30s',
  `process_tags` int NOT NULL DEFAULT '0',
  `show_event_menu` int NOT NULL DEFAULT '0',
  `event_menu_url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `event_menu_name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `provider` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`mediatypeid`),
  UNIQUE KEY `media_type_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media_type_message`
--

DROP TABLE IF EXISTS `media_type_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_type_message` (
  `mediatype_messageid` bigint unsigned NOT NULL,
  `mediatypeid` bigint unsigned NOT NULL,
  `eventsource` int NOT NULL,
  `recovery` int NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `message` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`mediatype_messageid`),
  UNIQUE KEY `media_type_message_1` (`mediatypeid`,`eventsource`,`recovery`),
  CONSTRAINT `c_media_type_message_1` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media_type_param`
--

DROP TABLE IF EXISTS `media_type_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_type_param` (
  `mediatype_paramid` bigint unsigned NOT NULL,
  `mediatypeid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sortorder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`mediatype_paramid`),
  KEY `media_type_param_1` (`mediatypeid`),
  CONSTRAINT `c_media_type_param_1` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module` (
  `moduleid` bigint unsigned NOT NULL,
  `id` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `relative_path` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '0',
  `config` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`moduleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opcommand`
--

DROP TABLE IF EXISTS `opcommand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcommand` (
  `operationid` bigint unsigned NOT NULL,
  `scriptid` bigint unsigned NOT NULL,
  PRIMARY KEY (`operationid`),
  KEY `opcommand_1` (`scriptid`),
  CONSTRAINT `c_opcommand_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opcommand_2` FOREIGN KEY (`scriptid`) REFERENCES `scripts` (`scriptid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opcommand_grp`
--

DROP TABLE IF EXISTS `opcommand_grp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcommand_grp` (
  `opcommand_grpid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`opcommand_grpid`),
  KEY `opcommand_grp_1` (`operationid`),
  KEY `opcommand_grp_2` (`groupid`),
  CONSTRAINT `c_opcommand_grp_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opcommand_grp_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opcommand_hst`
--

DROP TABLE IF EXISTS `opcommand_hst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcommand_hst` (
  `opcommand_hstid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`opcommand_hstid`),
  KEY `opcommand_hst_1` (`operationid`),
  KEY `opcommand_hst_2` (`hostid`),
  CONSTRAINT `c_opcommand_hst_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opcommand_hst_2` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opconditions`
--

DROP TABLE IF EXISTS `opconditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opconditions` (
  `opconditionid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `conditiontype` int NOT NULL DEFAULT '0',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`opconditionid`),
  KEY `opconditions_1` (`operationid`),
  CONSTRAINT `c_opconditions_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operations`
--

DROP TABLE IF EXISTS `operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operations` (
  `operationid` bigint unsigned NOT NULL,
  `actionid` bigint unsigned NOT NULL,
  `operationtype` int NOT NULL DEFAULT '0',
  `esc_period` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `esc_step_from` int NOT NULL DEFAULT '1',
  `esc_step_to` int NOT NULL DEFAULT '1',
  `evaltype` int NOT NULL DEFAULT '0',
  `recovery` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`operationid`),
  KEY `operations_1` (`actionid`),
  CONSTRAINT `c_operations_1` FOREIGN KEY (`actionid`) REFERENCES `actions` (`actionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opgroup`
--

DROP TABLE IF EXISTS `opgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opgroup` (
  `opgroupid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`opgroupid`),
  UNIQUE KEY `opgroup_1` (`operationid`,`groupid`),
  KEY `opgroup_2` (`groupid`),
  CONSTRAINT `c_opgroup_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opgroup_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opinventory`
--

DROP TABLE IF EXISTS `opinventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opinventory` (
  `operationid` bigint unsigned NOT NULL,
  `inventory_mode` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`operationid`),
  CONSTRAINT `c_opinventory_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opmessage`
--

DROP TABLE IF EXISTS `opmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opmessage` (
  `operationid` bigint unsigned NOT NULL,
  `default_msg` int NOT NULL DEFAULT '1',
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `message` text COLLATE utf8mb4_bin NOT NULL,
  `mediatypeid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`operationid`),
  KEY `opmessage_1` (`mediatypeid`),
  CONSTRAINT `c_opmessage_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opmessage_2` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opmessage_grp`
--

DROP TABLE IF EXISTS `opmessage_grp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opmessage_grp` (
  `opmessage_grpid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  PRIMARY KEY (`opmessage_grpid`),
  UNIQUE KEY `opmessage_grp_1` (`operationid`,`usrgrpid`),
  KEY `opmessage_grp_2` (`usrgrpid`),
  CONSTRAINT `c_opmessage_grp_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opmessage_grp_2` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `opmessage_usr`
--

DROP TABLE IF EXISTS `opmessage_usr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opmessage_usr` (
  `opmessage_usrid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  PRIMARY KEY (`opmessage_usrid`),
  UNIQUE KEY `opmessage_usr_1` (`operationid`,`userid`),
  KEY `opmessage_usr_2` (`userid`),
  CONSTRAINT `c_opmessage_usr_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_opmessage_usr_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `optemplate`
--

DROP TABLE IF EXISTS `optemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `optemplate` (
  `optemplateid` bigint unsigned NOT NULL,
  `operationid` bigint unsigned NOT NULL,
  `templateid` bigint unsigned NOT NULL,
  PRIMARY KEY (`optemplateid`),
  UNIQUE KEY `optemplate_1` (`operationid`,`templateid`),
  KEY `optemplate_2` (`templateid`),
  CONSTRAINT `c_optemplate_1` FOREIGN KEY (`operationid`) REFERENCES `operations` (`operationid`) ON DELETE CASCADE,
  CONSTRAINT `c_optemplate_2` FOREIGN KEY (`templateid`) REFERENCES `hosts` (`hostid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `problem` (
  `eventid` bigint unsigned NOT NULL,
  `source` int NOT NULL DEFAULT '0',
  `object` int NOT NULL DEFAULT '0',
  `objectid` bigint unsigned NOT NULL DEFAULT '0',
  `clock` int NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  `r_eventid` bigint unsigned DEFAULT NULL,
  `r_clock` int NOT NULL DEFAULT '0',
  `r_ns` int NOT NULL DEFAULT '0',
  `correlationid` bigint unsigned DEFAULT NULL,
  `userid` bigint unsigned DEFAULT NULL,
  `name` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `acknowledged` int NOT NULL DEFAULT '0',
  `severity` int NOT NULL DEFAULT '0',
  `cause_eventid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`eventid`),
  KEY `problem_1` (`source`,`object`,`objectid`),
  KEY `problem_2` (`r_clock`),
  KEY `problem_3` (`r_eventid`),
  KEY `c_problem_3` (`cause_eventid`),
  CONSTRAINT `c_problem_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_problem_2` FOREIGN KEY (`r_eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_problem_3` FOREIGN KEY (`cause_eventid`) REFERENCES `events` (`eventid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problem_tag`
--

DROP TABLE IF EXISTS `problem_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `problem_tag` (
  `problemtagid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`problemtagid`),
  KEY `problem_tag_1` (`eventid`,`tag`,`value`),
  CONSTRAINT `c_problem_tag_1` FOREIGN KEY (`eventid`) REFERENCES `problem` (`eventid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `profileid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `idx` varchar(96) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `idx2` bigint unsigned NOT NULL DEFAULT '0',
  `value_id` bigint unsigned NOT NULL DEFAULT '0',
  `value_int` int NOT NULL DEFAULT '0',
  `value_str` text COLLATE utf8mb4_bin NOT NULL,
  `source` varchar(96) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`profileid`),
  KEY `profiles_1` (`userid`,`idx`,`idx2`),
  KEY `profiles_2` (`userid`,`profileid`),
  CONSTRAINT `c_profiles_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxy_autoreg_host`
--

DROP TABLE IF EXISTS `proxy_autoreg_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxy_autoreg_host` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clock` int NOT NULL DEFAULT '0',
  `host` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `listen_ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `listen_port` int NOT NULL DEFAULT '0',
  `listen_dns` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `host_metadata` text COLLATE utf8mb4_bin NOT NULL,
  `flags` int NOT NULL DEFAULT '0',
  `tls_accepted` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `proxy_autoreg_host_1` (`clock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxy_dhistory`
--

DROP TABLE IF EXISTS `proxy_dhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxy_dhistory` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clock` int NOT NULL DEFAULT '0',
  `druleid` bigint unsigned NOT NULL,
  `ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `port` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '0',
  `dcheckid` bigint unsigned DEFAULT NULL,
  `dns` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `proxy_dhistory_1` (`clock`),
  KEY `proxy_dhistory_2` (`druleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxy_history`
--

DROP TABLE IF EXISTS `proxy_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxy_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `timestamp` int NOT NULL DEFAULT '0',
  `source` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `severity` int NOT NULL DEFAULT '0',
  `value` longtext COLLATE utf8mb4_bin NOT NULL,
  `logeventid` int NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  `state` int NOT NULL DEFAULT '0',
  `lastlogsize` bigint unsigned NOT NULL DEFAULT '0',
  `mtime` int NOT NULL DEFAULT '0',
  `flags` int NOT NULL DEFAULT '0',
  `write_clock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `proxy_history_1` (`clock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regexps`
--

DROP TABLE IF EXISTS `regexps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regexps` (
  `regexpid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `test_string` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`regexpid`),
  UNIQUE KEY `regexps_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `reportid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '0',
  `dashboardid` bigint unsigned NOT NULL,
  `period` int NOT NULL DEFAULT '0',
  `cycle` int NOT NULL DEFAULT '0',
  `weekdays` int NOT NULL DEFAULT '0',
  `start_time` int NOT NULL DEFAULT '0',
  `active_since` int NOT NULL DEFAULT '0',
  `active_till` int NOT NULL DEFAULT '0',
  `state` int NOT NULL DEFAULT '0',
  `lastsent` int NOT NULL DEFAULT '0',
  `info` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`reportid`),
  UNIQUE KEY `report_1` (`name`),
  KEY `c_report_1` (`userid`),
  KEY `c_report_2` (`dashboardid`),
  CONSTRAINT `c_report_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_report_2` FOREIGN KEY (`dashboardid`) REFERENCES `dashboard` (`dashboardid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_param`
--

DROP TABLE IF EXISTS `report_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_param` (
  `reportparamid` bigint unsigned NOT NULL,
  `reportid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`reportparamid`),
  KEY `report_param_1` (`reportid`),
  CONSTRAINT `c_report_param_1` FOREIGN KEY (`reportid`) REFERENCES `report` (`reportid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_user`
--

DROP TABLE IF EXISTS `report_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_user` (
  `reportuserid` bigint unsigned NOT NULL,
  `reportid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `exclude` int NOT NULL DEFAULT '0',
  `access_userid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`reportuserid`),
  KEY `report_user_1` (`reportid`),
  KEY `c_report_user_2` (`userid`),
  KEY `c_report_user_3` (`access_userid`),
  CONSTRAINT `c_report_user_1` FOREIGN KEY (`reportid`) REFERENCES `report` (`reportid`) ON DELETE CASCADE,
  CONSTRAINT `c_report_user_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_report_user_3` FOREIGN KEY (`access_userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_usrgrp`
--

DROP TABLE IF EXISTS `report_usrgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_usrgrp` (
  `reportusrgrpid` bigint unsigned NOT NULL,
  `reportid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  `access_userid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`reportusrgrpid`),
  KEY `report_usrgrp_1` (`reportid`),
  KEY `c_report_usrgrp_2` (`usrgrpid`),
  KEY `c_report_usrgrp_3` (`access_userid`),
  CONSTRAINT `c_report_usrgrp_1` FOREIGN KEY (`reportid`) REFERENCES `report` (`reportid`) ON DELETE CASCADE,
  CONSTRAINT `c_report_usrgrp_2` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE,
  CONSTRAINT `c_report_usrgrp_3` FOREIGN KEY (`access_userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights` (
  `rightid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  `permission` int NOT NULL DEFAULT '0',
  `id` bigint unsigned NOT NULL,
  PRIMARY KEY (`rightid`),
  KEY `rights_1` (`groupid`),
  KEY `rights_2` (`id`),
  CONSTRAINT `c_rights_1` FOREIGN KEY (`groupid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE,
  CONSTRAINT `c_rights_2` FOREIGN KEY (`id`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `roleid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` int NOT NULL DEFAULT '0',
  `readonly` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`roleid`),
  UNIQUE KEY `role_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_rule`
--

DROP TABLE IF EXISTS `role_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_rule` (
  `role_ruleid` bigint unsigned NOT NULL,
  `roleid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value_int` int NOT NULL DEFAULT '0',
  `value_str` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value_moduleid` bigint unsigned DEFAULT NULL,
  `value_serviceid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`role_ruleid`),
  KEY `role_rule_1` (`roleid`),
  KEY `role_rule_2` (`value_moduleid`),
  KEY `role_rule_3` (`value_serviceid`),
  CONSTRAINT `c_role_rule_1` FOREIGN KEY (`roleid`) REFERENCES `role` (`roleid`) ON DELETE CASCADE,
  CONSTRAINT `c_role_rule_2` FOREIGN KEY (`value_moduleid`) REFERENCES `module` (`moduleid`) ON DELETE CASCADE,
  CONSTRAINT `c_role_rule_3` FOREIGN KEY (`value_serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scim_group`
--

DROP TABLE IF EXISTS `scim_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scim_group` (
  `scim_groupid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`scim_groupid`),
  UNIQUE KEY `scim_group_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `script_param`
--

DROP TABLE IF EXISTS `script_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `script_param` (
  `script_paramid` bigint unsigned NOT NULL,
  `scriptid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`script_paramid`),
  UNIQUE KEY `script_param_1` (`scriptid`,`name`),
  CONSTRAINT `c_script_param_1` FOREIGN KEY (`scriptid`) REFERENCES `scripts` (`scriptid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scripts`
--

DROP TABLE IF EXISTS `scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scripts` (
  `scriptid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `command` text COLLATE utf8mb4_bin NOT NULL,
  `host_access` int NOT NULL DEFAULT '2',
  `usrgrpid` bigint unsigned DEFAULT NULL,
  `groupid` bigint unsigned DEFAULT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `confirmation` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` int NOT NULL DEFAULT '5',
  `execute_on` int NOT NULL DEFAULT '2',
  `timeout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '30s',
  `scope` int NOT NULL DEFAULT '1',
  `port` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `authtype` int NOT NULL DEFAULT '0',
  `username` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `publickey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `privatekey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `menu_path` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `new_window` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`scriptid`),
  UNIQUE KEY `scripts_3` (`name`,`menu_path`),
  KEY `scripts_1` (`usrgrpid`),
  KEY `scripts_2` (`groupid`),
  CONSTRAINT `c_scripts_1` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`),
  CONSTRAINT `c_scripts_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_alarms`
--

DROP TABLE IF EXISTS `service_alarms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_alarms` (
  `servicealarmid` bigint unsigned NOT NULL,
  `serviceid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '-1',
  PRIMARY KEY (`servicealarmid`),
  KEY `service_alarms_1` (`serviceid`,`clock`),
  KEY `service_alarms_2` (`clock`),
  CONSTRAINT `c_service_alarms_1` FOREIGN KEY (`serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_problem`
--

DROP TABLE IF EXISTS `service_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_problem` (
  `service_problemid` bigint unsigned NOT NULL,
  `eventid` bigint unsigned NOT NULL,
  `serviceid` bigint unsigned NOT NULL,
  `severity` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`service_problemid`),
  KEY `service_problem_1` (`eventid`),
  KEY `service_problem_2` (`serviceid`),
  CONSTRAINT `c_service_problem_1` FOREIGN KEY (`eventid`) REFERENCES `problem` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_service_problem_2` FOREIGN KEY (`serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_problem_tag`
--

DROP TABLE IF EXISTS `service_problem_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_problem_tag` (
  `service_problem_tagid` bigint unsigned NOT NULL,
  `serviceid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`service_problem_tagid`),
  KEY `service_problem_tag_1` (`serviceid`),
  CONSTRAINT `c_service_problem_tag_1` FOREIGN KEY (`serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_status_rule`
--

DROP TABLE IF EXISTS `service_status_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_status_rule` (
  `service_status_ruleid` bigint unsigned NOT NULL,
  `serviceid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `limit_value` int NOT NULL DEFAULT '0',
  `limit_status` int NOT NULL DEFAULT '0',
  `new_status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`service_status_ruleid`),
  KEY `service_status_rule_1` (`serviceid`),
  CONSTRAINT `c_service_status_rule_1` FOREIGN KEY (`serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_tag`
--

DROP TABLE IF EXISTS `service_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_tag` (
  `servicetagid` bigint unsigned NOT NULL,
  `serviceid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`servicetagid`),
  KEY `service_tag_1` (`serviceid`),
  CONSTRAINT `c_service_tag_1` FOREIGN KEY (`serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `serviceid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '-1',
  `algorithm` int NOT NULL DEFAULT '0',
  `sortorder` int NOT NULL DEFAULT '0',
  `weight` int NOT NULL DEFAULT '0',
  `propagation_rule` int NOT NULL DEFAULT '0',
  `propagation_value` int NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `created_at` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`serviceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services_links`
--

DROP TABLE IF EXISTS `services_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services_links` (
  `linkid` bigint unsigned NOT NULL,
  `serviceupid` bigint unsigned NOT NULL,
  `servicedownid` bigint unsigned NOT NULL,
  PRIMARY KEY (`linkid`),
  UNIQUE KEY `services_links_2` (`serviceupid`,`servicedownid`),
  KEY `services_links_1` (`servicedownid`),
  CONSTRAINT `c_services_links_1` FOREIGN KEY (`serviceupid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE,
  CONSTRAINT `c_services_links_2` FOREIGN KEY (`servicedownid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `sessionid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `userid` bigint unsigned NOT NULL,
  `lastaccess` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `secret` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`sessionid`),
  KEY `sessions_1` (`userid`,`status`,`lastaccess`),
  CONSTRAINT `c_sessions_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sla`
--

DROP TABLE IF EXISTS `sla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sla` (
  `slaid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `period` int NOT NULL DEFAULT '0',
  `slo` double NOT NULL DEFAULT '99.9',
  `effective_date` int NOT NULL DEFAULT '0',
  `timezone` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'UTC',
  `status` int NOT NULL DEFAULT '1',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`slaid`),
  UNIQUE KEY `sla_1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sla_excluded_downtime`
--

DROP TABLE IF EXISTS `sla_excluded_downtime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sla_excluded_downtime` (
  `sla_excluded_downtimeid` bigint unsigned NOT NULL,
  `slaid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `period_from` int NOT NULL DEFAULT '0',
  `period_to` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`sla_excluded_downtimeid`),
  KEY `sla_excluded_downtime_1` (`slaid`),
  CONSTRAINT `c_sla_excluded_downtime_1` FOREIGN KEY (`slaid`) REFERENCES `sla` (`slaid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sla_schedule`
--

DROP TABLE IF EXISTS `sla_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sla_schedule` (
  `sla_scheduleid` bigint unsigned NOT NULL,
  `slaid` bigint unsigned NOT NULL,
  `period_from` int NOT NULL DEFAULT '0',
  `period_to` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`sla_scheduleid`),
  KEY `sla_schedule_1` (`slaid`),
  CONSTRAINT `c_sla_schedule_1` FOREIGN KEY (`slaid`) REFERENCES `sla` (`slaid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sla_service_tag`
--

DROP TABLE IF EXISTS `sla_service_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sla_service_tag` (
  `sla_service_tagid` bigint unsigned NOT NULL,
  `slaid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '0',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`sla_service_tagid`),
  KEY `sla_service_tag_1` (`slaid`),
  CONSTRAINT `c_sla_service_tag_1` FOREIGN KEY (`slaid`) REFERENCES `sla` (`slaid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_element_trigger`
--

DROP TABLE IF EXISTS `sysmap_element_trigger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_element_trigger` (
  `selement_triggerid` bigint unsigned NOT NULL,
  `selementid` bigint unsigned NOT NULL,
  `triggerid` bigint unsigned NOT NULL,
  PRIMARY KEY (`selement_triggerid`),
  UNIQUE KEY `sysmap_element_trigger_1` (`selementid`,`triggerid`),
  KEY `c_sysmap_element_trigger_2` (`triggerid`),
  CONSTRAINT `c_sysmap_element_trigger_1` FOREIGN KEY (`selementid`) REFERENCES `sysmaps_elements` (`selementid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmap_element_trigger_2` FOREIGN KEY (`triggerid`) REFERENCES `triggers` (`triggerid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_element_url`
--

DROP TABLE IF EXISTS `sysmap_element_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_element_url` (
  `sysmapelementurlid` bigint unsigned NOT NULL,
  `selementid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`sysmapelementurlid`),
  UNIQUE KEY `sysmap_element_url_1` (`selementid`,`name`),
  CONSTRAINT `c_sysmap_element_url_1` FOREIGN KEY (`selementid`) REFERENCES `sysmaps_elements` (`selementid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_shape`
--

DROP TABLE IF EXISTS `sysmap_shape`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_shape` (
  `sysmap_shapeid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `x` int NOT NULL DEFAULT '0',
  `y` int NOT NULL DEFAULT '0',
  `width` int NOT NULL DEFAULT '200',
  `height` int NOT NULL DEFAULT '200',
  `text` text COLLATE utf8mb4_bin NOT NULL,
  `font` int NOT NULL DEFAULT '9',
  `font_size` int NOT NULL DEFAULT '11',
  `font_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '000000',
  `text_halign` int NOT NULL DEFAULT '0',
  `text_valign` int NOT NULL DEFAULT '0',
  `border_type` int NOT NULL DEFAULT '0',
  `border_width` int NOT NULL DEFAULT '1',
  `border_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '000000',
  `background_color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `zindex` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`sysmap_shapeid`),
  KEY `sysmap_shape_1` (`sysmapid`),
  CONSTRAINT `c_sysmap_shape_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_url`
--

DROP TABLE IF EXISTS `sysmap_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_url` (
  `sysmapurlid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `elementtype` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`sysmapurlid`),
  UNIQUE KEY `sysmap_url_1` (`sysmapid`,`name`),
  CONSTRAINT `c_sysmap_url_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_user`
--

DROP TABLE IF EXISTS `sysmap_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_user` (
  `sysmapuserid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `permission` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`sysmapuserid`),
  UNIQUE KEY `sysmap_user_1` (`sysmapid`,`userid`),
  KEY `c_sysmap_user_2` (`userid`),
  CONSTRAINT `c_sysmap_user_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmap_user_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmap_usrgrp`
--

DROP TABLE IF EXISTS `sysmap_usrgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmap_usrgrp` (
  `sysmapusrgrpid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  `permission` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`sysmapusrgrpid`),
  UNIQUE KEY `sysmap_usrgrp_1` (`sysmapid`,`usrgrpid`),
  KEY `c_sysmap_usrgrp_2` (`usrgrpid`),
  CONSTRAINT `c_sysmap_usrgrp_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmap_usrgrp_2` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmaps`
--

DROP TABLE IF EXISTS `sysmaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmaps` (
  `sysmapid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `width` int NOT NULL DEFAULT '600',
  `height` int NOT NULL DEFAULT '400',
  `backgroundid` bigint unsigned DEFAULT NULL,
  `label_type` int NOT NULL DEFAULT '2',
  `label_location` int NOT NULL DEFAULT '0',
  `highlight` int NOT NULL DEFAULT '1',
  `expandproblem` int NOT NULL DEFAULT '1',
  `markelements` int NOT NULL DEFAULT '0',
  `show_unack` int NOT NULL DEFAULT '0',
  `grid_size` int NOT NULL DEFAULT '50',
  `grid_show` int NOT NULL DEFAULT '1',
  `grid_align` int NOT NULL DEFAULT '1',
  `label_format` int NOT NULL DEFAULT '0',
  `label_type_host` int NOT NULL DEFAULT '2',
  `label_type_hostgroup` int NOT NULL DEFAULT '2',
  `label_type_trigger` int NOT NULL DEFAULT '2',
  `label_type_map` int NOT NULL DEFAULT '2',
  `label_type_image` int NOT NULL DEFAULT '2',
  `label_string_host` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `label_string_hostgroup` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `label_string_trigger` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `label_string_map` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `label_string_image` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `iconmapid` bigint unsigned DEFAULT NULL,
  `expand_macros` int NOT NULL DEFAULT '0',
  `severity_min` int NOT NULL DEFAULT '0',
  `userid` bigint unsigned NOT NULL,
  `private` int NOT NULL DEFAULT '1',
  `show_suppressed` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`sysmapid`),
  UNIQUE KEY `sysmaps_1` (`name`),
  KEY `sysmaps_2` (`backgroundid`),
  KEY `sysmaps_3` (`iconmapid`),
  KEY `c_sysmaps_3` (`userid`),
  CONSTRAINT `c_sysmaps_1` FOREIGN KEY (`backgroundid`) REFERENCES `images` (`imageid`),
  CONSTRAINT `c_sysmaps_2` FOREIGN KEY (`iconmapid`) REFERENCES `icon_map` (`iconmapid`),
  CONSTRAINT `c_sysmaps_3` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmaps_element_tag`
--

DROP TABLE IF EXISTS `sysmaps_element_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmaps_element_tag` (
  `selementtagid` bigint unsigned NOT NULL,
  `selementid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `operator` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`selementtagid`),
  KEY `sysmaps_element_tag_1` (`selementid`),
  CONSTRAINT `c_sysmaps_element_tag_1` FOREIGN KEY (`selementid`) REFERENCES `sysmaps_elements` (`selementid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmaps_elements`
--

DROP TABLE IF EXISTS `sysmaps_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmaps_elements` (
  `selementid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `elementid` bigint unsigned NOT NULL DEFAULT '0',
  `elementtype` int NOT NULL DEFAULT '0',
  `iconid_off` bigint unsigned DEFAULT NULL,
  `iconid_on` bigint unsigned DEFAULT NULL,
  `label` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `label_location` int NOT NULL DEFAULT '-1',
  `x` int NOT NULL DEFAULT '0',
  `y` int NOT NULL DEFAULT '0',
  `iconid_disabled` bigint unsigned DEFAULT NULL,
  `iconid_maintenance` bigint unsigned DEFAULT NULL,
  `elementsubtype` int NOT NULL DEFAULT '0',
  `areatype` int NOT NULL DEFAULT '0',
  `width` int NOT NULL DEFAULT '200',
  `height` int NOT NULL DEFAULT '200',
  `viewtype` int NOT NULL DEFAULT '0',
  `use_iconmap` int NOT NULL DEFAULT '1',
  `evaltype` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`selementid`),
  KEY `sysmaps_elements_1` (`sysmapid`),
  KEY `sysmaps_elements_2` (`iconid_off`),
  KEY `sysmaps_elements_3` (`iconid_on`),
  KEY `sysmaps_elements_4` (`iconid_disabled`),
  KEY `sysmaps_elements_5` (`iconid_maintenance`),
  CONSTRAINT `c_sysmaps_elements_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmaps_elements_2` FOREIGN KEY (`iconid_off`) REFERENCES `images` (`imageid`),
  CONSTRAINT `c_sysmaps_elements_3` FOREIGN KEY (`iconid_on`) REFERENCES `images` (`imageid`),
  CONSTRAINT `c_sysmaps_elements_4` FOREIGN KEY (`iconid_disabled`) REFERENCES `images` (`imageid`),
  CONSTRAINT `c_sysmaps_elements_5` FOREIGN KEY (`iconid_maintenance`) REFERENCES `images` (`imageid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmaps_link_triggers`
--

DROP TABLE IF EXISTS `sysmaps_link_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmaps_link_triggers` (
  `linktriggerid` bigint unsigned NOT NULL,
  `linkid` bigint unsigned NOT NULL,
  `triggerid` bigint unsigned NOT NULL,
  `drawtype` int NOT NULL DEFAULT '0',
  `color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '000000',
  PRIMARY KEY (`linktriggerid`),
  UNIQUE KEY `sysmaps_link_triggers_1` (`linkid`,`triggerid`),
  KEY `sysmaps_link_triggers_2` (`triggerid`),
  CONSTRAINT `c_sysmaps_link_triggers_1` FOREIGN KEY (`linkid`) REFERENCES `sysmaps_links` (`linkid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmaps_link_triggers_2` FOREIGN KEY (`triggerid`) REFERENCES `triggers` (`triggerid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysmaps_links`
--

DROP TABLE IF EXISTS `sysmaps_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sysmaps_links` (
  `linkid` bigint unsigned NOT NULL,
  `sysmapid` bigint unsigned NOT NULL,
  `selementid1` bigint unsigned NOT NULL,
  `selementid2` bigint unsigned NOT NULL,
  `drawtype` int NOT NULL DEFAULT '0',
  `color` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '000000',
  `label` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`linkid`),
  KEY `sysmaps_links_1` (`sysmapid`),
  KEY `sysmaps_links_2` (`selementid1`),
  KEY `sysmaps_links_3` (`selementid2`),
  CONSTRAINT `c_sysmaps_links_1` FOREIGN KEY (`sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmaps_links_2` FOREIGN KEY (`selementid1`) REFERENCES `sysmaps_elements` (`selementid`) ON DELETE CASCADE,
  CONSTRAINT `c_sysmaps_links_3` FOREIGN KEY (`selementid2`) REFERENCES `sysmaps_elements` (`selementid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_filter`
--

DROP TABLE IF EXISTS `tag_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_filter` (
  `tag_filterid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  `groupid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`tag_filterid`),
  KEY `c_tag_filter_1` (`usrgrpid`),
  KEY `c_tag_filter_2` (`groupid`),
  CONSTRAINT `c_tag_filter_1` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE,
  CONSTRAINT `c_tag_filter_2` FOREIGN KEY (`groupid`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `taskid` bigint unsigned NOT NULL,
  `type` int NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `clock` int NOT NULL DEFAULT '0',
  `ttl` int NOT NULL DEFAULT '0',
  `proxy_hostid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`taskid`),
  KEY `task_1` (`status`,`proxy_hostid`),
  KEY `c_task_1` (`proxy_hostid`),
  CONSTRAINT `c_task_1` FOREIGN KEY (`proxy_hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_acknowledge`
--

DROP TABLE IF EXISTS `task_acknowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_acknowledge` (
  `taskid` bigint unsigned NOT NULL,
  `acknowledgeid` bigint unsigned NOT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_acknowledge_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_check_now`
--

DROP TABLE IF EXISTS `task_check_now`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_check_now` (
  `taskid` bigint unsigned NOT NULL,
  `itemid` bigint unsigned NOT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_check_now_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_close_problem`
--

DROP TABLE IF EXISTS `task_close_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_close_problem` (
  `taskid` bigint unsigned NOT NULL,
  `acknowledgeid` bigint unsigned NOT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_close_problem_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_data`
--

DROP TABLE IF EXISTS `task_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_data` (
  `taskid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `data` text COLLATE utf8mb4_bin NOT NULL,
  `parent_taskid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_data_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_remote_command`
--

DROP TABLE IF EXISTS `task_remote_command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_remote_command` (
  `taskid` bigint unsigned NOT NULL,
  `command_type` int NOT NULL DEFAULT '0',
  `execute_on` int NOT NULL DEFAULT '0',
  `port` int NOT NULL DEFAULT '0',
  `authtype` int NOT NULL DEFAULT '0',
  `username` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `password` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `publickey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `privatekey` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `command` text COLLATE utf8mb4_bin NOT NULL,
  `alertid` bigint unsigned DEFAULT NULL,
  `parent_taskid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_remote_command_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_remote_command_result`
--

DROP TABLE IF EXISTS `task_remote_command_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_remote_command_result` (
  `taskid` bigint unsigned NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `parent_taskid` bigint unsigned NOT NULL,
  `info` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`taskid`),
  CONSTRAINT `c_task_remote_command_result_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_result`
--

DROP TABLE IF EXISTS `task_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_result` (
  `taskid` bigint unsigned NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `parent_taskid` bigint unsigned NOT NULL,
  `info` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`taskid`),
  KEY `task_result_1` (`parent_taskid`),
  CONSTRAINT `c_task_result_1` FOREIGN KEY (`taskid`) REFERENCES `task` (`taskid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timeperiods`
--

DROP TABLE IF EXISTS `timeperiods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeperiods` (
  `timeperiodid` bigint unsigned NOT NULL,
  `timeperiod_type` int NOT NULL DEFAULT '0',
  `every` int NOT NULL DEFAULT '1',
  `month` int NOT NULL DEFAULT '0',
  `dayofweek` int NOT NULL DEFAULT '0',
  `day` int NOT NULL DEFAULT '0',
  `start_time` int NOT NULL DEFAULT '0',
  `period` int NOT NULL DEFAULT '0',
  `start_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`timeperiodid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `tokenid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `token` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `lastaccess` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `expires_at` int NOT NULL DEFAULT '0',
  `created_at` int NOT NULL DEFAULT '0',
  `creator_userid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`tokenid`),
  UNIQUE KEY `token_2` (`userid`,`name`),
  UNIQUE KEY `token_3` (`token`),
  KEY `token_1` (`name`),
  KEY `token_4` (`creator_userid`),
  CONSTRAINT `c_token_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_token_2` FOREIGN KEY (`creator_userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trends`
--

DROP TABLE IF EXISTS `trends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trends` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `num` int NOT NULL DEFAULT '0',
  `value_min` double NOT NULL DEFAULT '0',
  `value_avg` double NOT NULL DEFAULT '0',
  `value_max` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trends_uint`
--

DROP TABLE IF EXISTS `trends_uint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trends_uint` (
  `itemid` bigint unsigned NOT NULL,
  `clock` int NOT NULL DEFAULT '0',
  `num` int NOT NULL DEFAULT '0',
  `value_min` bigint unsigned NOT NULL DEFAULT '0',
  `value_avg` bigint unsigned NOT NULL DEFAULT '0',
  `value_max` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`itemid`,`clock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_depends`
--

DROP TABLE IF EXISTS `trigger_depends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_depends` (
  `triggerdepid` bigint unsigned NOT NULL,
  `triggerid_down` bigint unsigned NOT NULL,
  `triggerid_up` bigint unsigned NOT NULL,
  PRIMARY KEY (`triggerdepid`),
  UNIQUE KEY `trigger_depends_1` (`triggerid_down`,`triggerid_up`),
  KEY `trigger_depends_2` (`triggerid_up`),
  CONSTRAINT `c_trigger_depends_1` FOREIGN KEY (`triggerid_down`) REFERENCES `triggers` (`triggerid`) ON DELETE CASCADE,
  CONSTRAINT `c_trigger_depends_2` FOREIGN KEY (`triggerid_up`) REFERENCES `triggers` (`triggerid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_discovery`
--

DROP TABLE IF EXISTS `trigger_discovery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_discovery` (
  `triggerid` bigint unsigned NOT NULL,
  `parent_triggerid` bigint unsigned NOT NULL,
  `lastcheck` int NOT NULL DEFAULT '0',
  `ts_delete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`triggerid`),
  KEY `trigger_discovery_1` (`parent_triggerid`),
  CONSTRAINT `c_trigger_discovery_1` FOREIGN KEY (`triggerid`) REFERENCES `triggers` (`triggerid`) ON DELETE CASCADE,
  CONSTRAINT `c_trigger_discovery_2` FOREIGN KEY (`parent_triggerid`) REFERENCES `triggers` (`triggerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_queue`
--

DROP TABLE IF EXISTS `trigger_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_queue` (
  `trigger_queueid` bigint unsigned NOT NULL,
  `objectid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `clock` int NOT NULL DEFAULT '0',
  `ns` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`trigger_queueid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_tag`
--

DROP TABLE IF EXISTS `trigger_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_tag` (
  `triggertagid` bigint unsigned NOT NULL,
  `triggerid` bigint unsigned NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`triggertagid`),
  KEY `trigger_tag_1` (`triggerid`),
  CONSTRAINT `c_trigger_tag_1` FOREIGN KEY (`triggerid`) REFERENCES `triggers` (`triggerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `trigger_tag_insert` AFTER INSERT ON `trigger_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (6,new.triggertagid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `trigger_tag_update` AFTER UPDATE ON `trigger_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (6,old.triggertagid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `trigger_tag_delete` BEFORE DELETE ON `trigger_tag` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (6,old.triggertagid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `triggers`
--

DROP TABLE IF EXISTS `triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triggers` (
  `triggerid` bigint unsigned NOT NULL,
  `expression` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `status` int NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '0',
  `priority` int NOT NULL DEFAULT '0',
  `lastchange` int NOT NULL DEFAULT '0',
  `comments` text COLLATE utf8mb4_bin NOT NULL,
  `error` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `templateid` bigint unsigned DEFAULT NULL,
  `type` int NOT NULL DEFAULT '0',
  `state` int NOT NULL DEFAULT '0',
  `flags` int NOT NULL DEFAULT '0',
  `recovery_mode` int NOT NULL DEFAULT '0',
  `recovery_expression` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `correlation_mode` int NOT NULL DEFAULT '0',
  `correlation_tag` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `manual_close` int NOT NULL DEFAULT '0',
  `opdata` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `discover` int NOT NULL DEFAULT '0',
  `event_name` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url_name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`triggerid`),
  KEY `triggers_1` (`status`),
  KEY `triggers_2` (`value`,`lastchange`),
  KEY `triggers_3` (`templateid`),
  CONSTRAINT `c_triggers_1` FOREIGN KEY (`templateid`) REFERENCES `triggers` (`triggerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `triggers_insert` AFTER INSERT ON `triggers` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (5,new.triggerid,1,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `triggers_update` AFTER UPDATE ON `triggers` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (5,old.triggerid,2,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zabbix`@`localhost`*/ /*!50003 TRIGGER `triggers_delete` BEFORE DELETE ON `triggers` FOR EACH ROW insert into changelog (object,objectid,operation,clock)
values (5,old.triggerid,3,unix_timestamp()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_scim_group`
--

DROP TABLE IF EXISTS `user_scim_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_scim_group` (
  `user_scim_groupid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  `scim_groupid` bigint unsigned NOT NULL,
  PRIMARY KEY (`user_scim_groupid`),
  KEY `user_scim_group_1` (`userid`),
  KEY `user_scim_group_2` (`scim_groupid`),
  CONSTRAINT `c_user_scim_group_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE,
  CONSTRAINT `c_user_scim_group_2` FOREIGN KEY (`scim_groupid`) REFERENCES `scim_group` (`scim_groupid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory`
--

DROP TABLE IF EXISTS `userdirectory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory` (
  `userdirectoryid` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `idp_type` int NOT NULL DEFAULT '1',
  `provision_status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`userdirectoryid`),
  KEY `userdirectory_1` (`idp_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory_idpgroup`
--

DROP TABLE IF EXISTS `userdirectory_idpgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory_idpgroup` (
  `userdirectory_idpgroupid` bigint unsigned NOT NULL,
  `userdirectoryid` bigint unsigned NOT NULL,
  `roleid` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`userdirectory_idpgroupid`),
  KEY `userdirectory_idpgroup_1` (`userdirectoryid`),
  KEY `userdirectory_idpgroup_2` (`roleid`),
  CONSTRAINT `c_userdirectory_idpgroup_1` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`) ON DELETE CASCADE,
  CONSTRAINT `c_userdirectory_idpgroup_2` FOREIGN KEY (`roleid`) REFERENCES `role` (`roleid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory_ldap`
--

DROP TABLE IF EXISTS `userdirectory_ldap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory_ldap` (
  `userdirectoryid` bigint unsigned NOT NULL,
  `host` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `port` int NOT NULL DEFAULT '389',
  `base_dn` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `search_attribute` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `bind_dn` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `bind_password` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `start_tls` int NOT NULL DEFAULT '0',
  `search_filter` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group_basedn` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group_name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group_member` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user_ref_attr` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group_filter` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `group_membership` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user_username` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user_lastname` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`userdirectoryid`),
  CONSTRAINT `c_userdirectory_ldap_1` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory_media`
--

DROP TABLE IF EXISTS `userdirectory_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory_media` (
  `userdirectory_mediaid` bigint unsigned NOT NULL,
  `userdirectoryid` bigint unsigned NOT NULL,
  `mediatypeid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `attribute` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`userdirectory_mediaid`),
  KEY `userdirectory_media_1` (`userdirectoryid`),
  KEY `userdirectory_media_2` (`mediatypeid`),
  CONSTRAINT `c_userdirectory_media_1` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`) ON DELETE CASCADE,
  CONSTRAINT `c_userdirectory_media_2` FOREIGN KEY (`mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory_saml`
--

DROP TABLE IF EXISTS `userdirectory_saml`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory_saml` (
  `userdirectoryid` bigint unsigned NOT NULL,
  `idp_entityid` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sso_url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `slo_url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `username_attribute` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sp_entityid` varchar(1024) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `nameid_format` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `sign_messages` int NOT NULL DEFAULT '0',
  `sign_assertions` int NOT NULL DEFAULT '0',
  `sign_authn_requests` int NOT NULL DEFAULT '0',
  `sign_logout_requests` int NOT NULL DEFAULT '0',
  `sign_logout_responses` int NOT NULL DEFAULT '0',
  `encrypt_nameid` int NOT NULL DEFAULT '0',
  `encrypt_assertions` int NOT NULL DEFAULT '0',
  `group_name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user_username` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `user_lastname` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `scim_status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`userdirectoryid`),
  CONSTRAINT `c_userdirectory_saml_1` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdirectory_usrgrp`
--

DROP TABLE IF EXISTS `userdirectory_usrgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdirectory_usrgrp` (
  `userdirectory_usrgrpid` bigint unsigned NOT NULL,
  `userdirectory_idpgroupid` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  PRIMARY KEY (`userdirectory_usrgrpid`),
  UNIQUE KEY `userdirectory_usrgrp_1` (`userdirectory_idpgroupid`,`usrgrpid`),
  KEY `userdirectory_usrgrp_2` (`usrgrpid`),
  KEY `userdirectory_usrgrp_3` (`userdirectory_idpgroupid`),
  CONSTRAINT `c_userdirectory_usrgrp_1` FOREIGN KEY (`userdirectory_idpgroupid`) REFERENCES `userdirectory_idpgroup` (`userdirectory_idpgroupid`) ON DELETE CASCADE,
  CONSTRAINT `c_userdirectory_usrgrp_2` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userid` bigint unsigned NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `name` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `surname` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `passwd` varchar(60) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(2048) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `autologin` int NOT NULL DEFAULT '0',
  `autologout` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '15m',
  `lang` varchar(7) COLLATE utf8mb4_bin NOT NULL DEFAULT 'default',
  `refresh` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '30s',
  `theme` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT 'default',
  `attempt_failed` int NOT NULL DEFAULT '0',
  `attempt_ip` varchar(39) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `attempt_clock` int NOT NULL DEFAULT '0',
  `rows_per_page` int NOT NULL DEFAULT '50',
  `timezone` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'default',
  `roleid` bigint unsigned DEFAULT NULL,
  `userdirectoryid` bigint unsigned DEFAULT NULL,
  `ts_provisioned` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`),
  UNIQUE KEY `users_1` (`username`),
  KEY `users_2` (`userdirectoryid`),
  KEY `c_users_1` (`roleid`),
  CONSTRAINT `c_users_1` FOREIGN KEY (`roleid`) REFERENCES `role` (`roleid`) ON DELETE CASCADE,
  CONSTRAINT `c_users_2` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `id` bigint unsigned NOT NULL,
  `usrgrpid` bigint unsigned NOT NULL,
  `userid` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_groups_1` (`usrgrpid`,`userid`),
  KEY `users_groups_2` (`userid`),
  CONSTRAINT `c_users_groups_1` FOREIGN KEY (`usrgrpid`) REFERENCES `usrgrp` (`usrgrpid`) ON DELETE CASCADE,
  CONSTRAINT `c_users_groups_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usrgrp`
--

DROP TABLE IF EXISTS `usrgrp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usrgrp` (
  `usrgrpid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `gui_access` int NOT NULL DEFAULT '0',
  `users_status` int NOT NULL DEFAULT '0',
  `debug_mode` int NOT NULL DEFAULT '0',
  `userdirectoryid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`usrgrpid`),
  UNIQUE KEY `usrgrp_1` (`name`),
  KEY `usrgrp_2` (`userdirectoryid`),
  CONSTRAINT `c_usrgrp_2` FOREIGN KEY (`userdirectoryid`) REFERENCES `userdirectory` (`userdirectoryid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `valuemap`
--

DROP TABLE IF EXISTS `valuemap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valuemap` (
  `valuemapid` bigint unsigned NOT NULL,
  `hostid` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `uuid` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`valuemapid`),
  UNIQUE KEY `valuemap_1` (`hostid`,`name`),
  CONSTRAINT `c_valuemap_1` FOREIGN KEY (`hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `valuemap_mapping`
--

DROP TABLE IF EXISTS `valuemap_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valuemap_mapping` (
  `valuemap_mappingid` bigint unsigned NOT NULL,
  `valuemapid` bigint unsigned NOT NULL,
  `value` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `newvalue` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `type` int NOT NULL DEFAULT '0',
  `sortorder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`valuemap_mappingid`),
  UNIQUE KEY `valuemap_mapping_1` (`valuemapid`,`value`,`type`),
  CONSTRAINT `c_valuemap_mapping_1` FOREIGN KEY (`valuemapid`) REFERENCES `valuemap` (`valuemapid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `widget`
--

DROP TABLE IF EXISTS `widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `widget` (
  `widgetid` bigint unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `x` int NOT NULL DEFAULT '0',
  `y` int NOT NULL DEFAULT '0',
  `width` int NOT NULL DEFAULT '1',
  `height` int NOT NULL DEFAULT '2',
  `view_mode` int NOT NULL DEFAULT '0',
  `dashboard_pageid` bigint unsigned NOT NULL,
  PRIMARY KEY (`widgetid`),
  KEY `widget_1` (`dashboard_pageid`),
  CONSTRAINT `c_widget_1` FOREIGN KEY (`dashboard_pageid`) REFERENCES `dashboard_page` (`dashboard_pageid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `widget_field`
--

DROP TABLE IF EXISTS `widget_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `widget_field` (
  `widget_fieldid` bigint unsigned NOT NULL,
  `widgetid` bigint unsigned NOT NULL,
  `type` int NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value_int` int NOT NULL DEFAULT '0',
  `value_str` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `value_groupid` bigint unsigned DEFAULT NULL,
  `value_hostid` bigint unsigned DEFAULT NULL,
  `value_itemid` bigint unsigned DEFAULT NULL,
  `value_graphid` bigint unsigned DEFAULT NULL,
  `value_sysmapid` bigint unsigned DEFAULT NULL,
  `value_serviceid` bigint unsigned DEFAULT NULL,
  `value_slaid` bigint unsigned DEFAULT NULL,
  `value_userid` bigint unsigned DEFAULT NULL,
  `value_actionid` bigint unsigned DEFAULT NULL,
  `value_mediatypeid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`widget_fieldid`),
  KEY `widget_field_1` (`widgetid`),
  KEY `widget_field_2` (`value_groupid`),
  KEY `widget_field_3` (`value_hostid`),
  KEY `widget_field_4` (`value_itemid`),
  KEY `widget_field_5` (`value_graphid`),
  KEY `widget_field_6` (`value_sysmapid`),
  KEY `widget_field_7` (`value_serviceid`),
  KEY `widget_field_8` (`value_slaid`),
  KEY `widget_field_9` (`value_userid`),
  KEY `widget_field_10` (`value_actionid`),
  KEY `widget_field_11` (`value_mediatypeid`),
  CONSTRAINT `c_widget_field_1` FOREIGN KEY (`widgetid`) REFERENCES `widget` (`widgetid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_10` FOREIGN KEY (`value_actionid`) REFERENCES `actions` (`actionid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_11` FOREIGN KEY (`value_mediatypeid`) REFERENCES `media_type` (`mediatypeid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_2` FOREIGN KEY (`value_groupid`) REFERENCES `hstgrp` (`groupid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_3` FOREIGN KEY (`value_hostid`) REFERENCES `hosts` (`hostid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_4` FOREIGN KEY (`value_itemid`) REFERENCES `items` (`itemid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_5` FOREIGN KEY (`value_graphid`) REFERENCES `graphs` (`graphid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_6` FOREIGN KEY (`value_sysmapid`) REFERENCES `sysmaps` (`sysmapid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_7` FOREIGN KEY (`value_serviceid`) REFERENCES `services` (`serviceid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_8` FOREIGN KEY (`value_slaid`) REFERENCES `sla` (`slaid`) ON DELETE CASCADE,
  CONSTRAINT `c_widget_field_9` FOREIGN KEY (`value_userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-20 14:27:05
