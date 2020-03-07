-- Webtrees base 2.0.2
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `<DB_NAME>` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `<DB_NAME>`;

DROP TABLE IF EXISTS `wt_block`;
CREATE TABLE `wt_block` (
  `block_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `xref` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` enum('main','side') COLLATE utf8_unicode_ci DEFAULT NULL,
  `block_order` int(11) NOT NULL,
  `module_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`block_id`),
  KEY `wt_block_module_name_index` (`module_name`),
  KEY `wt_block_gedcom_id_index` (`gedcom_id`),
  KEY `wt_block_user_id_index` (`user_id`),
  CONSTRAINT `wt_block_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_block_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`),
  CONSTRAINT `wt_block_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_block_setting`;
CREATE TABLE `wt_block_setting` (
  `block_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`block_id`,`setting_name`),
  CONSTRAINT `wt_block_setting_block_id_foreign` FOREIGN KEY (`block_id`) REFERENCES `wt_block` (`block_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_change`;
CREATE TABLE `wt_change` (
  `change_id` int(11) NOT NULL AUTO_INCREMENT,
  `change_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('accepted','pending','rejected') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'pending',
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `old_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  `new_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`change_id`),
  KEY `wt_change_gedcom_id_status_xref_index` (`gedcom_id`,`status`,`xref`),
  KEY `wt_change_user_id_index` (`user_id`),
  CONSTRAINT `wt_change_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_change_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_dates`;
CREATE TABLE `wt_dates` (
  `d_day` tinyint(4) NOT NULL,
  `d_month` char(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `d_mon` tinyint(4) NOT NULL,
  `d_year` smallint(6) NOT NULL,
  `d_julianday1` mediumint(9) NOT NULL,
  `d_julianday2` mediumint(9) NOT NULL,
  `d_fact` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `d_gid` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `d_file` int(11) NOT NULL,
  `d_type` enum('@#DGREGORIAN@','@#DJULIAN@','@#DHEBREW@','@#DFRENCH R@','@#DHIJRI@','@#DROMAN@','@#DJALALI@') COLLATE utf8_unicode_ci NOT NULL,
  KEY `wt_dates_d_day_index` (`d_day`),
  KEY `wt_dates_d_month_index` (`d_month`),
  KEY `wt_dates_d_mon_index` (`d_mon`),
  KEY `wt_dates_d_year_index` (`d_year`),
  KEY `wt_dates_d_julianday1_index` (`d_julianday1`),
  KEY `wt_dates_d_julianday2_index` (`d_julianday2`),
  KEY `wt_dates_d_gid_index` (`d_gid`),
  KEY `wt_dates_d_file_index` (`d_file`),
  KEY `wt_dates_d_type_index` (`d_type`),
  KEY `wt_dates_d_fact_d_gid_index` (`d_fact`,`d_gid`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_default_resn`;
CREATE TABLE `wt_default_resn` (
  `default_resn_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_type` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resn` enum('none','privacy','confidential','hidden') COLLATE utf8_unicode_ci NOT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`default_resn_id`),
  UNIQUE KEY `wt_default_resn_gedcom_id_xref_tag_type_unique` (`gedcom_id`,`xref`,`tag_type`),
  CONSTRAINT `wt_default_resn_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_default_resn` (`default_resn_id`, `gedcom_id`, `xref`, `tag_type`, `resn`, `comment`, `updated`) VALUES
(1,	-1,	NULL,	'SSN',	'confidential',	NULL,	'2020-03-05 10:50:23'),
(2,	-1,	NULL,	'SOUR',	'privacy',	NULL,	'2020-03-05 10:50:23'),
(3,	-1,	NULL,	'REPO',	'privacy',	NULL,	'2020-03-05 10:50:23'),
(4,	-1,	NULL,	'SUBM',	'confidential',	NULL,	'2020-03-05 10:50:24'),
(5,	-1,	NULL,	'SUBN',	'confidential',	NULL,	'2020-03-05 10:50:24');

DROP TABLE IF EXISTS `wt_families`;
CREATE TABLE `wt_families` (
  `f_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `f_file` int(11) NOT NULL,
  `f_husb` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `f_wife` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `f_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  `f_numchil` int(11) NOT NULL,
  PRIMARY KEY (`f_id`,`f_file`),
  UNIQUE KEY `wt_families_f_file_f_id_unique` (`f_file`,`f_id`),
  KEY `wt_families_f_husb_index` (`f_husb`),
  KEY `wt_families_f_wife_index` (`f_wife`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_favorite`;
CREATE TABLE `wt_favorite` (
  `favorite_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `favorite_type` enum('INDI','FAM','SOUR','REPO','OBJE','NOTE','URL') COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`favorite_id`),
  KEY `wt_favorite_user_id_index` (`user_id`),
  KEY `wt_favorite_gedcom_id_user_id_index` (`gedcom_id`,`user_id`),
  CONSTRAINT `wt_favorite_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_favorite_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_gedcom`;
CREATE TABLE `wt_gedcom` (
  `gedcom_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`gedcom_id`),
  UNIQUE KEY `wt_gedcom_gedcom_name_unique` (`gedcom_name`),
  KEY `wt_gedcom_sort_order_index` (`sort_order`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_gedcom` (`gedcom_id`, `gedcom_name`, `sort_order`) VALUES
(-1,	'DEFAULT_TREE',	0);

DROP TABLE IF EXISTS `wt_gedcom_chunk`;
CREATE TABLE `wt_gedcom_chunk` (
  `gedcom_chunk_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) NOT NULL,
  `chunk_data` longblob,
  `imported` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`gedcom_chunk_id`),
  KEY `wt_gedcom_chunk_gedcom_id_imported_index` (`gedcom_id`,`imported`),
  CONSTRAINT `wt_gedcom_chunk_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_gedcom_setting`;
CREATE TABLE `wt_gedcom_setting` (
  `gedcom_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`gedcom_id`,`setting_name`),
  CONSTRAINT `wt_gedcom_setting_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_gedcom_setting` (`gedcom_id`, `setting_name`, `setting_value`) VALUES
(-1,	'ADVANCED_NAME_FACTS',	'NICK,_AKA'),
(-1,	'ADVANCED_PLAC_FACTS',	''),
(-1,	'CALENDAR_FORMAT',	'gregorian'),
(-1,	'CHART_BOX_TAGS',	''),
(-1,	'COMMON_NAMES_ADD',	''),
(-1,	'COMMON_NAMES_REMOVE',	''),
(-1,	'COMMON_NAMES_THRESHOLD',	'40'),
(-1,	'EXPAND_RELATIVES_EVENTS',	'0'),
(-1,	'EXPAND_SOURCES',	'0'),
(-1,	'FAM_FACTS_ADD',	'CENS,MARR,RESI,SLGS,MARR_CIVIL,MARR_RELIGIOUS,MARR_PARTNERS,RESN'),
(-1,	'FAM_FACTS_QUICK',	'MARR,DIV,_NMR'),
(-1,	'FAM_FACTS_UNIQUE',	'NCHI,MARL,DIV,ANUL,DIVF,ENGA,MARB,MARC,MARS,_NMR'),
(-1,	'FAM_ID_PREFIX',	'F'),
(-1,	'FORMAT_TEXT',	'markdown'),
(-1,	'FULL_SOURCES',	'0'),
(-1,	'GEDCOM_ID_PREFIX',	'I'),
(-1,	'GEDCOM_MEDIA_PATH',	''),
(-1,	'GENERATE_UIDS',	'0'),
(-1,	'HIDE_GEDCOM_ERRORS',	'1'),
(-1,	'HIDE_LIVE_PEOPLE',	'1'),
(-1,	'INDI_FACTS_ADD',	'AFN,BIRT,DEAT,BURI,CREM,ADOP,BAPM,BARM,BASM,BLES,CHRA,CONF,FCOM,ORDN,NATU,EMIG,IMMI,CENS,PROB,WILL,GRAD,RETI,DSCR,EDUC,IDNO,NATI,NCHI,NMR,OCCU,PROP,RELI,RESI,SSN,TITL,BAPL,CONL,ENDL,SLGC,_MILI,ASSO,RESN'),
(-1,	'INDI_FACTS_QUICK',	'BIRT,BURI,BAPM,CENS,DEAT,OCCU,RESI'),
(-1,	'INDI_FACTS_UNIQUE',	''),
(-1,	'KEEP_ALIVE_YEARS_BIRTH',	''),
(-1,	'KEEP_ALIVE_YEARS_DEATH',	''),
(-1,	'LANGUAGE',	'en-US'),
(-1,	'MAX_ALIVE_AGE',	'120'),
(-1,	'MEDIA_DIRECTORY',	'media/'),
(-1,	'MEDIA_ID_PREFIX',	'M'),
(-1,	'MEDIA_UPLOAD',	'1'),
(-1,	'META_DESCRIPTION',	''),
(-1,	'META_TITLE',	'webtrees'),
(-1,	'NO_UPDATE_CHAN',	'0'),
(-1,	'NOTE_FACTS_ADD',	'SOUR,RESN'),
(-1,	'NOTE_FACTS_QUICK',	''),
(-1,	'NOTE_FACTS_UNIQUE',	''),
(-1,	'NOTE_ID_PREFIX',	'N'),
(-1,	'PEDIGREE_ROOT_ID',	''),
(-1,	'PREFER_LEVEL2_SOURCES',	'1'),
(-1,	'QUICK_REQUIRED_FACTS',	'BIRT,DEAT'),
(-1,	'QUICK_REQUIRED_FAMFACTS',	'MARR'),
(-1,	'REPO_FACTS_ADD',	'PHON,EMAIL,FAX,WWW,RESN'),
(-1,	'REPO_FACTS_QUICK',	''),
(-1,	'REPO_FACTS_UNIQUE',	'NAME,ADDR'),
(-1,	'REPO_ID_PREFIX',	'R'),
(-1,	'REQUIRE_AUTHENTICATION',	'0'),
(-1,	'SAVE_WATERMARK_IMAGE',	'0'),
(-1,	'SHOW_AGE_DIFF',	'0'),
(-1,	'SHOW_COUNTER',	'1'),
(-1,	'SHOW_DEAD_PEOPLE',	'2'),
(-1,	'SHOW_EST_LIST_DATES',	'0'),
(-1,	'SHOW_FACT_ICONS',	'1'),
(-1,	'SHOW_GEDCOM_RECORD',	'0'),
(-1,	'SHOW_HIGHLIGHT_IMAGES',	'1'),
(-1,	'SHOW_LEVEL2_NOTES',	'1'),
(-1,	'SHOW_LIVING_NAMES',	'1'),
(-1,	'SHOW_MEDIA_DOWNLOAD',	'0'),
(-1,	'SHOW_NO_WATERMARK',	'1'),
(-1,	'SHOW_PARENTS_AGE',	'1'),
(-1,	'SHOW_PEDIGREE_PLACES',	'9'),
(-1,	'SHOW_PEDIGREE_PLACES_SUFFIX',	'0'),
(-1,	'SHOW_PRIVATE_RELATIONSHIPS',	'1'),
(-1,	'SHOW_RELATIVES_EVENTS',	'_BIRT_CHIL,_BIRT_SIBL,_MARR_CHIL,_MARR_PARE,_DEAT_CHIL,_DEAT_PARE,_DEAT_GPAR,_DEAT_SIBL,_DEAT_SPOU'),
(-1,	'SOUR_FACTS_ADD',	'NOTE,REPO,SHARED_NOTE,RESN'),
(-1,	'SOUR_FACTS_QUICK',	'TEXT,NOTE,REPO'),
(-1,	'SOUR_FACTS_UNIQUE',	'AUTH,ABBR,TITL,PUBL,TEXT'),
(-1,	'SOURCE_ID_PREFIX',	'S'),
(-1,	'SUBLIST_TRIGGER_I',	'200'),
(-1,	'SURNAME_LIST_STYLE',	'style2'),
(-1,	'SURNAME_TRADITION',	'paternal'),
(-1,	'THUMBNAIL_WIDTH',	'100'),
(-1,	'USE_RIN',	'0'),
(-1,	'USE_SILHOUETTE',	'1'),
(-1,	'WORD_WRAPPED_NOTES',	'0');

DROP TABLE IF EXISTS `wt_hit_counter`;
CREATE TABLE `wt_hit_counter` (
  `gedcom_id` int(11) NOT NULL,
  `page_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `page_parameter` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `page_count` int(11) NOT NULL,
  PRIMARY KEY (`gedcom_id`,`page_name`,`page_parameter`),
  CONSTRAINT `wt_hit_counter_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_individuals`;
CREATE TABLE `wt_individuals` (
  `i_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `i_file` int(11) NOT NULL,
  `i_rin` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `i_sex` enum('U','M','F') COLLATE utf8_unicode_ci NOT NULL,
  `i_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`i_id`,`i_file`),
  UNIQUE KEY `wt_individuals_i_file_i_id_unique` (`i_file`,`i_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_link`;
CREATE TABLE `wt_link` (
  `l_file` int(11) NOT NULL,
  `l_from` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `l_type` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `l_to` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`l_from`,`l_file`,`l_type`,`l_to`),
  UNIQUE KEY `wt_link_l_to_l_file_l_type_l_from_unique` (`l_to`,`l_file`,`l_type`,`l_from`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_log`;
CREATE TABLE `wt_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log_type` enum('auth','config','debug','edit','error','media','search') COLLATE utf8_unicode_ci NOT NULL,
  `log_message` longtext COLLATE utf8_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `wt_log_log_time_index` (`log_time`),
  KEY `wt_log_log_type_index` (`log_type`),
  KEY `wt_log_ip_address_index` (`ip_address`),
  KEY `wt_log_user_id_index` (`user_id`),
  KEY `wt_log_gedcom_id_index` (`gedcom_id`),
  CONSTRAINT `wt_log_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_log` (`log_id`, `log_time`, `log_type`, `log_message`, `ip_address`, `user_id`, `gedcom_id`) VALUES
(1,	'2020-03-05 10:49:16',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"1\"',	'172.17.0.1',	NULL,	NULL),
(2,	'2020-03-05 10:49:17',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"2\"',	'172.17.0.1',	NULL,	NULL),
(3,	'2020-03-05 10:49:17',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"3\"',	'172.17.0.1',	NULL,	NULL),
(4,	'2020-03-05 10:49:17',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"4\"',	'172.17.0.1',	NULL,	NULL),
(5,	'2020-03-05 10:49:18',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"5\"',	'172.17.0.1',	NULL,	NULL),
(6,	'2020-03-05 10:49:18',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"6\"',	'172.17.0.1',	NULL,	NULL),
(7,	'2020-03-05 10:49:18',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"7\"',	'172.17.0.1',	NULL,	NULL),
(8,	'2020-03-05 10:49:19',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"8\"',	'172.17.0.1',	NULL,	NULL),
(9,	'2020-03-05 10:49:19',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"9\"',	'172.17.0.1',	NULL,	NULL),
(10,	'2020-03-05 10:49:19',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"10\"',	'172.17.0.1',	NULL,	NULL),
(11,	'2020-03-05 10:49:20',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"11\"',	'172.17.0.1',	NULL,	NULL),
(12,	'2020-03-05 10:49:20',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"12\"',	'172.17.0.1',	NULL,	NULL),
(13,	'2020-03-05 10:49:20',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"13\"',	'172.17.0.1',	NULL,	NULL),
(14,	'2020-03-05 10:49:21',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"14\"',	'172.17.0.1',	NULL,	NULL),
(15,	'2020-03-05 10:49:21',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"15\"',	'172.17.0.1',	NULL,	NULL),
(16,	'2020-03-05 10:49:21',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"16\"',	'172.17.0.1',	NULL,	NULL),
(17,	'2020-03-05 10:49:22',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"17\"',	'172.17.0.1',	NULL,	NULL),
(18,	'2020-03-05 10:49:22',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"18\"',	'172.17.0.1',	NULL,	NULL),
(19,	'2020-03-05 10:49:22',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"19\"',	'172.17.0.1',	NULL,	NULL),
(20,	'2020-03-05 10:49:22',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"20\"',	'172.17.0.1',	NULL,	NULL),
(21,	'2020-03-05 10:49:23',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"21\"',	'172.17.0.1',	NULL,	NULL),
(22,	'2020-03-05 10:49:23',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"22\"',	'172.17.0.1',	NULL,	NULL),
(23,	'2020-03-05 10:49:23',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"23\"',	'172.17.0.1',	NULL,	NULL),
(24,	'2020-03-05 10:49:24',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"24\"',	'172.17.0.1',	NULL,	NULL),
(25,	'2020-03-05 10:49:24',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"25\"',	'172.17.0.1',	NULL,	NULL),
(26,	'2020-03-05 10:49:24',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"26\"',	'172.17.0.1',	NULL,	NULL),
(27,	'2020-03-05 10:49:25',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"27\"',	'172.17.0.1',	NULL,	NULL),
(28,	'2020-03-05 10:49:25',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"28\"',	'172.17.0.1',	NULL,	NULL),
(29,	'2020-03-05 10:49:25',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"29\"',	'172.17.0.1',	NULL,	NULL),
(30,	'2020-03-05 10:49:26',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"30\"',	'172.17.0.1',	NULL,	NULL),
(31,	'2020-03-05 10:49:26',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"31\"',	'172.17.0.1',	NULL,	NULL),
(32,	'2020-03-05 10:49:27',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"32\"',	'172.17.0.1',	NULL,	NULL),
(33,	'2020-03-05 10:49:27',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"33\"',	'172.17.0.1',	NULL,	NULL),
(34,	'2020-03-05 10:49:27',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"34\"',	'172.17.0.1',	NULL,	NULL),
(35,	'2020-03-05 10:49:27',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"35\"',	'172.17.0.1',	NULL,	NULL),
(36,	'2020-03-05 10:49:28',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"36\"',	'172.17.0.1',	NULL,	NULL),
(37,	'2020-03-05 10:49:28',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"37\"',	'172.17.0.1',	NULL,	NULL),
(38,	'2020-03-05 10:49:40',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"38\"',	'172.17.0.1',	NULL,	NULL),
(39,	'2020-03-05 10:49:44',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"39\"',	'172.17.0.1',	NULL,	NULL),
(40,	'2020-03-05 10:49:51',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"40\"',	'172.17.0.1',	NULL,	NULL),
(41,	'2020-03-05 10:49:57',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"41\"',	'172.17.0.1',	NULL,	NULL),
(42,	'2020-03-05 10:49:58',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"42\"',	'172.17.0.1',	NULL,	NULL),
(43,	'2020-03-05 10:50:05',	'config',	'Site preference \"WT_SCHEMA_VERSION\" set to \"43\"',	'172.17.0.1',	NULL,	NULL),
(44,	'2020-03-05 10:51:58',	'config',	'Site preference \"LATEST_WT_VERSION\" set to \"2.0.2|1.7.17|https://github.com/fisharebest/webtrees/releases/download/2.0.2/webtrees-2.0.2.zip\"',	'172.17.0.1',	1,	NULL),
(45,	'2020-03-05 10:51:58',	'config',	'Site preference \"LATEST_WT_VERSION_TIMESTAMP\" set to \"1583405518\"',	'172.17.0.1',	1,	NULL),
(46,	'2020-03-05 10:52:14',	'auth',	'Logout: admin/Admin',	'172.17.0.1',	1,	NULL),
(47,	'2020-03-05 10:52:25',	'auth',	'Login: admin/Admin',	'172.17.0.1',	1,	NULL),
(48,	'2020-03-05 10:52:31',	'auth',	'Logout: admin/Admin',	'172.17.0.1',	1,	NULL);

DROP TABLE IF EXISTS `wt_media`;
CREATE TABLE `wt_media` (
  `m_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `m_file` int(11) NOT NULL,
  `m_gedcom` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`m_file`,`m_id`),
  UNIQUE KEY `wt_media_m_id_m_file_unique` (`m_id`,`m_file`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_media_file`;
CREATE TABLE `wt_media_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `m_file` int(11) NOT NULL,
  `multimedia_file_refn` varchar(248) COLLATE utf8_unicode_ci NOT NULL,
  `multimedia_format` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `source_media_type` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `descriptive_title` varchar(248) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wt_media_file_m_id_m_file_index` (`m_id`,`m_file`),
  KEY `wt_media_file_m_file_m_id_index` (`m_file`,`m_id`),
  KEY `wt_media_file_m_file_multimedia_file_refn_index` (`m_file`,`multimedia_file_refn`),
  KEY `wt_media_file_m_file_multimedia_format_index` (`m_file`,`multimedia_format`),
  KEY `wt_media_file_m_file_source_media_type_index` (`m_file`,`source_media_type`),
  KEY `wt_media_file_m_file_descriptive_title_index` (`m_file`,`descriptive_title`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_message`;
CREATE TABLE `wt_message` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8_unicode_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `wt_message_user_id_index` (`user_id`),
  CONSTRAINT `wt_message_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_module`;
CREATE TABLE `wt_module` (
  `module_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('enabled','disabled') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'enabled',
  `tab_order` int(11) DEFAULT NULL,
  `menu_order` int(11) DEFAULT NULL,
  `sidebar_order` int(11) DEFAULT NULL,
  `footer_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`module_name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_module` (`module_name`, `status`, `tab_order`, `menu_order`, `sidebar_order`, `footer_order`) VALUES
('ahnentafel_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('ancestors_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('bdm_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('bing-webmaster-tools',	'disabled',	NULL,	NULL,	NULL,	NULL),
('birth_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('branches_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('british-monarchs',	'disabled',	NULL,	NULL,	NULL,	NULL),
('british-prime-ministers',	'disabled',	NULL,	NULL,	NULL,	NULL),
('british-social-history',	'disabled',	NULL,	NULL,	NULL,	NULL),
('calendar-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('cemetery_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('change_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('charts',	'enabled',	NULL,	NULL,	NULL,	NULL),
('charts-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('ckeditor',	'enabled',	NULL,	NULL,	NULL,	NULL),
('clippings',	'enabled',	NULL,	NULL,	NULL,	NULL),
('clouds',	'enabled',	NULL,	NULL,	NULL,	NULL),
('colors',	'enabled',	NULL,	NULL,	NULL,	NULL),
('compact-chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('contact-links',	'enabled',	NULL,	NULL,	NULL,	NULL),
('custom-css-js',	'disabled',	NULL,	NULL,	NULL,	NULL),
('czech-leaders',	'disabled',	NULL,	NULL,	NULL,	NULL),
('death_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('descendancy',	'enabled',	NULL,	NULL,	NULL,	NULL),
('descendancy_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('descendancy_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('extra_info',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fab',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fact_sources',	'enabled',	NULL,	NULL,	NULL,	NULL),
('family_book_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('family_group_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('family_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('family_nav',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fan_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('faq',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-add-death',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-add-marr-names',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-ceme-tag',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-duplicate-links',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-name-slashes-spaces',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-place-names',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-prim-tag',	'enabled',	NULL,	NULL,	NULL,	NULL),
('fix-search-and-replace',	'enabled',	NULL,	NULL,	NULL,	NULL),
('french-history',	'disabled',	NULL,	NULL,	NULL,	NULL),
('gedcom_block',	'enabled',	NULL,	NULL,	NULL,	NULL),
('gedcom_favorites',	'enabled',	NULL,	NULL,	NULL,	NULL),
('gedcom_news',	'enabled',	NULL,	NULL,	NULL,	NULL),
('gedcom_stats',	'enabled',	NULL,	NULL,	NULL,	NULL),
('GEDFact_assistant',	'enabled',	NULL,	NULL,	NULL,	NULL),
('google-analytics',	'disabled',	NULL,	NULL,	NULL,	NULL),
('google-webmaster-tools',	'disabled',	NULL,	NULL,	NULL,	NULL),
('hit-counter',	'enabled',	NULL,	NULL,	NULL,	NULL),
('hourglass_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('html',	'enabled',	NULL,	NULL,	NULL,	NULL),
('individual_ext_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('individual_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('individual_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-af',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-ar',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-bs',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-bu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-ca',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-cs',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-da',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-de',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-dv',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-el',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-en-AU',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-en-GB',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-en-US',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-es',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-et',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-fa',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-fi',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-fo',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-fr',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-fr-CA',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-gl',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-he',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-hi',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-hr',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-hu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-id',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-is',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-it',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-ja',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-jv',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ka',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-kk',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-ko',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ku',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ln',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-lt',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-lv',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-mi',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-mr',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ms',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-nb',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ne',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-nl',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-nn',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-oc',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-pl',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-pt',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-pt-BR',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ro',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ru',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-sk',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-sl',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-sq',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-sr',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-sr-Latn',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-su',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-sv',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-sw',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-ta',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-th',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-tr',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-tt',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-uk',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-vi',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-yi',	'disabled',	NULL,	NULL,	NULL,	NULL),
('language-zh-Hans',	'enabled',	NULL,	NULL,	NULL,	NULL),
('language-zh-Hant',	'enabled',	NULL,	NULL,	NULL,	NULL),
('lifespans_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('lightbox',	'enabled',	NULL,	NULL,	NULL,	NULL),
('lists-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('logged_in',	'enabled',	NULL,	NULL,	NULL,	NULL),
('login_block',	'enabled',	NULL,	NULL,	NULL,	NULL),
('marriage_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('matomo-analytics',	'disabled',	NULL,	NULL,	NULL,	NULL),
('media',	'enabled',	NULL,	NULL,	NULL,	NULL),
('media_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('minimal',	'enabled',	NULL,	NULL,	NULL,	NULL),
('missing_facts_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('note_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('notes',	'enabled',	NULL,	NULL,	NULL,	NULL),
('occupation_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('pedigree_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('pedigree_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('pedigree-map',	'enabled',	NULL,	NULL,	NULL,	NULL),
('personal_facts',	'enabled',	NULL,	NULL,	NULL,	NULL),
('places',	'enabled',	NULL,	NULL,	NULL,	NULL),
('places_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('powered-by-webtrees',	'enabled',	NULL,	NULL,	NULL,	NULL),
('privacy-policy',	'enabled',	NULL,	NULL,	NULL,	NULL),
('random_media',	'enabled',	NULL,	NULL,	NULL,	NULL),
('recent_changes',	'enabled',	NULL,	NULL,	NULL,	NULL),
('relationships_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('relative_ext_report',	'enabled',	NULL,	NULL,	NULL,	NULL),
('relatives',	'enabled',	NULL,	NULL,	NULL,	NULL),
('reports-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('repository_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('review_changes',	'enabled',	NULL,	NULL,	NULL,	NULL),
('search-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('sitemap',	'disabled',	NULL,	NULL,	NULL,	NULL),
('source_list',	'enabled',	NULL,	NULL,	NULL,	NULL),
('sources_tab',	'enabled',	NULL,	NULL,	NULL,	NULL),
('statcounter',	'disabled',	NULL,	NULL,	NULL,	NULL),
('statistics_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('stories',	'enabled',	NULL,	NULL,	NULL,	NULL),
('submitter_list',	'disabled',	NULL,	NULL,	NULL,	NULL),
('theme_select',	'enabled',	NULL,	NULL,	NULL,	NULL),
('timeline_chart',	'enabled',	NULL,	NULL,	NULL,	NULL),
('todays_events',	'enabled',	NULL,	NULL,	NULL,	NULL),
('todo',	'enabled',	NULL,	NULL,	NULL,	NULL),
('top10_givnnames',	'enabled',	NULL,	NULL,	NULL,	NULL),
('top10_pageviews',	'enabled',	NULL,	NULL,	NULL,	NULL),
('top10_surnames',	'enabled',	NULL,	NULL,	NULL,	NULL),
('tree',	'enabled',	NULL,	NULL,	NULL,	NULL),
('trees-menu',	'enabled',	NULL,	NULL,	NULL,	NULL),
('upcoming_events',	'enabled',	NULL,	NULL,	NULL,	NULL),
('us-presidents',	'disabled',	NULL,	NULL,	NULL,	NULL),
('user_blog',	'enabled',	NULL,	NULL,	NULL,	NULL),
('user_favorites',	'enabled',	NULL,	NULL,	NULL,	NULL),
('user_messages',	'enabled',	NULL,	NULL,	NULL,	NULL),
('user_welcome',	'enabled',	NULL,	NULL,	NULL,	NULL),
('webtrees',	'enabled',	NULL,	NULL,	NULL,	NULL),
('xenea',	'enabled',	NULL,	NULL,	NULL,	NULL),
('yahrzeit',	'enabled',	NULL,	NULL,	NULL,	NULL);

DROP TABLE IF EXISTS `wt_module_privacy`;
CREATE TABLE `wt_module_privacy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `gedcom_id` int(11) NOT NULL,
  `interface` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `access_level` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wt_module_privacy_ix1` (`gedcom_id`,`module_name`,`interface`),
  UNIQUE KEY `wt_module_privacy_ix2` (`module_name`,`gedcom_id`,`interface`),
  CONSTRAINT `wt_module_privacy_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_module_privacy_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_module_setting`;
CREATE TABLE `wt_module_setting` (
  `module_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`module_name`,`setting_name`),
  CONSTRAINT `wt_module_setting_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_name`;
CREATE TABLE `wt_name` (
  `n_file` int(11) NOT NULL,
  `n_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `n_num` int(11) NOT NULL,
  `n_type` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `n_sort` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `n_full` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `n_surname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_surn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_givn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_soundex_givn_std` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_soundex_surn_std` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_soundex_givn_dm` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `n_soundex_surn_dm` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`n_id`,`n_file`,`n_num`),
  KEY `wt_name_n_full_n_id_n_file_index` (`n_full`,`n_id`,`n_file`),
  KEY `wt_name_n_surn_n_file_n_type_n_id_index` (`n_surn`,`n_file`,`n_type`,`n_id`),
  KEY `wt_name_n_givn_n_file_n_type_n_id_index` (`n_givn`,`n_file`,`n_type`,`n_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_news`;
CREATE TABLE `wt_news` (
  `news_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `body` text COLLATE utf8_unicode_ci NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`news_id`),
  KEY `wt_news_user_id_updated_index` (`user_id`,`updated`),
  KEY `wt_news_gedcom_id_updated_index` (`gedcom_id`,`updated`),
  CONSTRAINT `wt_news_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_news_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_other`;
CREATE TABLE `wt_other` (
  `o_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `o_file` int(11) NOT NULL,
  `o_type` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `o_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`o_id`,`o_file`),
  UNIQUE KEY `wt_other_o_file_o_id_unique` (`o_file`,`o_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_placelinks`;
CREATE TABLE `wt_placelinks` (
  `pl_p_id` int(11) NOT NULL,
  `pl_gid` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `pl_file` int(11) NOT NULL,
  PRIMARY KEY (`pl_p_id`,`pl_gid`,`pl_file`),
  KEY `wt_placelinks_pl_p_id_index` (`pl_p_id`),
  KEY `wt_placelinks_pl_gid_index` (`pl_gid`),
  KEY `wt_placelinks_pl_file_index` (`pl_file`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_placelocation`;
CREATE TABLE `wt_placelocation` (
  `pl_id` int(11) NOT NULL,
  `pl_parent_id` int(11) NOT NULL,
  `pl_level` int(11) NOT NULL,
  `pl_place` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `pl_long` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pl_lati` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pl_zoom` int(11) DEFAULT NULL,
  `pl_icon` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`pl_id`),
  UNIQUE KEY `wt_placelocation_pl_parent_id_pl_place_unique` (`pl_parent_id`,`pl_place`),
  KEY `wt_placelocation_pl_place_index` (`pl_place`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_places`;
CREATE TABLE `wt_places` (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `p_place` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `p_parent_id` int(11) DEFAULT NULL,
  `p_file` int(11) NOT NULL,
  `p_std_soundex` longtext COLLATE utf8_unicode_ci,
  `p_dm_soundex` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`p_id`),
  UNIQUE KEY `wt_places_p_parent_id_p_file_p_place_unique` (`p_parent_id`,`p_file`,`p_place`),
  KEY `wt_places_p_file_p_place_index` (`p_file`,`p_place`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_session`;
CREATE TABLE `wt_session` (
  `session_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `session_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `session_data` longblob,
  PRIMARY KEY (`session_id`),
  KEY `wt_session_session_time_index` (`session_time`),
  KEY `wt_session_user_id_ip_address_index` (`user_id`,`ip_address`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `wt_site_setting`;
CREATE TABLE `wt_site_setting` (
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`setting_name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_site_setting` (`setting_name`, `setting_value`) VALUES
('ALLOW_CHANGE_GEDCOM',	'1'),
('INDEX_DIRECTORY',	'data/'),
('LATEST_WT_VERSION',	'2.0.2|1.7.17|https://github.com/fisharebest/webtrees/releases/download/2.0.2/webtrees-2.0.2.zip'),
('LATEST_WT_VERSION_TIMESTAMP',	'1583405518'),
('SMTP_ACTIVE',	'internal'),
('SMTP_AUTH',	'1'),
('SMTP_HOST',	'localhost'),
('SMTP_PORT',	'25'),
('SMTP_SSL',	'none'),
('USE_REGISTRATION_MODULE',	'1'),
('WT_SCHEMA_VERSION',	'43');

DROP TABLE IF EXISTS `wt_sources`;
CREATE TABLE `wt_sources` (
  `s_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `s_file` int(11) NOT NULL,
  `s_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `s_gedcom` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`s_id`,`s_file`),
  UNIQUE KEY `wt_sources_s_file_s_id_unique` (`s_file`,`s_id`),
  KEY `wt_sources_s_name_index` (`s_name`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_user`;
CREATE TABLE `wt_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `real_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `wt_user_user_name_unique` (`user_name`),
  UNIQUE KEY `wt_user_email_unique` (`email`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_user` (`user_id`, `user_name`, `real_name`, `email`, `password`) VALUES
(-1,	'DEFAULT_USER',	'DEFAULT_USER',	'DEFAULT_USER',	'DEFAULT_USER'),
(1,	'<WT_ADMIN_NAME>',	'Admin',	'<WT_ADMIN_MAIL>',	'<WT_ADMIN_PW>');

DROP TABLE IF EXISTS `wt_user_gedcom_setting`;
CREATE TABLE `wt_user_gedcom_setting` (
  `user_id` int(11) NOT NULL,
  `gedcom_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`gedcom_id`,`setting_name`),
  KEY `wt_user_gedcom_setting_gedcom_id_index` (`gedcom_id`),
  CONSTRAINT `wt_user_gedcom_setting_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_user_gedcom_setting_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `wt_user_setting`;
CREATE TABLE `wt_user_setting` (
  `user_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`setting_name`),
  CONSTRAINT `wt_user_setting_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `wt_user_setting` (`user_id`, `setting_name`, `setting_value`) VALUES
(1,	'canadmin',	'1'),
(1,	'language',	'de'),
(1,	'sessiontime',	'1583405545'),
(1,	'verified',	'1'),
(1,	'verified_by_admin',	'1'),
(1,	'visibleonline',	'1');

