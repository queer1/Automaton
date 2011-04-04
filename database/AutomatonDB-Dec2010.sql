-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: AutomatonDB
-- ------------------------------------------------------
-- Server version	5.1.49-1ubuntu8.1

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
-- Table structure for table `filehash`
--

DROP TABLE IF EXISTS `filehash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filehash` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `md5` text NOT NULL,
  `sha1` text NOT NULL,
  `sha512` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filehash`
--

LOCK TABLES `filehash` WRITE;
/*!40000 ALTER TABLE `filehash` DISABLE KEYS */;
INSERT INTO `filehash` VALUES (1,'b1fdaf7dcd6b8d1c920b5334e4abdc85','','');
/*!40000 ALTER TABLE `filehash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filename`
--

DROP TABLE IF EXISTS `filename`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filename` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `lastmod` datetime DEFAULT NULL,
  `filestore_id` int(19) unsigned NOT NULL,
  `filehash_id` int(19) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filename`
--

LOCK TABLES `filename` WRITE;
/*!40000 ALTER TABLE `filename` DISABLE KEYS */;
INSERT INTO `filename` VALUES (1,'VersionChecks ','2010-11-09 04:36:59',1,1);
/*!40000 ALTER TABLE `filename` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filestore`
--

DROP TABLE IF EXISTS `filestore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filestore` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `content` longblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filestore`
--

LOCK TABLES `filestore` WRITE;
/*!40000 ALTER TABLE `filestore` DISABLE KEYS */;
INSERT INTO `filestore` VALUES (1,'mulk02.unity.bahai.org.uk -- Checking application versions\n\nssh version: OpenSSH_4.3p2, OpenSSL 0.9.8e-fips-rhel5 01 Jul 2008 \n\nPerl Version: This is perl, v5.8.8 built for i386-linux-thread-multi \n\nApache Version: /opt/vFats/test-data-gather.sh: line 59: httpd: command not found\ndone\n\n -- General Security tests now\n\nIs inetd being used ? the list below should be empty\nChecking Inetd: \ndone\n\nChecking Cron: ls: /var/spool/cron/*: No such file or directory\ndone\n\nChecking /etc/cron* : \n-rw-r--r--  1 root root     298 Mar 28  2007 anacrontab\ndrwx------  2 root root    4096 Jan  6  2010 cron.d\ndrwxr-xr-x  2 root root    4096 Sep 26 03:58 cron.daily\n-rw-r--r--  1 root root       0 Jul 15 17:39 cron.deny\ndrwxr-xr-x  2 root root    4096 Jan  6  2007 cron.hourly\ndrwxr-xr-x  2 root root    4096 Jul 15 17:38 cron.monthly\n-rw-r--r--  1 root root     255 Jan  6  2007 crontab\ndrwxr-xr-x  2 root root    4096 Jul 15 17:39 cron.weekly\n/etc/cron.d:\n/etc/cron.daily:\n-rwxr-xr-x 1 root root  379 Mar 28  2007 0anacron\n-rwxr-xr-x 1 root root  418 Jan  6  2007 makewhatis.cron\n-rwxr-xr-x 1 root root  137 Sep  3  2009 mlocate.cron\n/etc/cron.hourly:\n/etc/cron.monthly:\n-rwxr-xr-x 1 root root 381 Mar 28  2007 0anacron\n/etc/cron.weekly:\n-rwxr-xr-x 1 root root  380 Mar 28  2007 0anacron\n-rwxr-xr-x 1 root root  414 Jan  6  2007 makewhatis.cron\n-rw------- 1 root root   297 Jan  6  2010 crond\n-rwxr-xr-x 1 root root  1441 Mar 28  2007 anacron\n-rwxr-xr-x 1 root root  1904 Jan  6  2010 crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 K05anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 K60crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 K05anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 K60crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 S90crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 S95anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 S90crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 S95anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 S90crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 S95anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 S90crond -> ../init.d/crond\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 S95anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 17 Jul 15 17:38 K05anacron -> ../init.d/anacron\nlrwxrwxrwx 1 root root 15 Jul 15 17:39 K60crond -> ../init.d/crond\n-rw-r--r-- 1 root root  512 Jan  6  2010 crond\n@@@/etc/anacrontab@@@\n# /etc/anacrontab: configuration file for anacron\n# See anacron(8) and anacrontab(5) for details.\nSHELL=/bin/sh\nPATH=/sbin:/bin:/usr/sbin:/usr/bin\nMAILTO=root\n1	65	cron.daily		run-parts /etc/cron.daily\n7	70	cron.weekly		run-parts /etc/cron.weekly\n30	75	cron.monthly		run-parts /etc/cron.monthly\n@@@/etc/cron.deny@@@\n@@@/etc/crontab@@@\nSHELL=/bin/bash\nPATH=/sbin:/bin:/usr/sbin:/usr/bin\nMAILTO=root\nHOME=/\n# run-parts\n01 * * * * root run-parts /etc/cron.hourly\n02 4 * * * root run-parts /etc/cron.daily\n22 4 * * 0 root run-parts /etc/cron.weekly\n42 4 1 * * root run-parts /etc/cron.monthly\ndone\n\nChecking lsof: /opt/vFats/test-data-gather.sh: line 71: lsof: command not found\ndone\n\n');
/*!40000 ALTER TABLE `filestore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanhw`
--

DROP TABLE IF EXISTS `scanhw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scanhw` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `uptime` text,
  `cpuinfo` text,
  `meminfo` text,
  `hddinfo` text,
  `interfaces` text,
  `sysinfo_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanhw`
--

LOCK TABLES `scanhw` WRITE;
/*!40000 ALTER TABLE `scanhw` DISABLE KEYS */;
INSERT INTO `scanhw` VALUES (1,'Uptime:  10:08:32 up 12 days,  5:23,  3 users,  load average: 0.50, 0.40, 0.30\r\n','Processor Info: ACPI: SSDT (v001 VBOX   VBOXCPUT 0x00000002 INTL 0x20090521) @ 0x3fff0240\r\nInitializing CPU#0\r\nCPU 0 irqstacks, hard=c0768000 soft=c0748000\r\nCPU: After generic identify, caps: 078bfbff 20100800 00000000 00000000 00000209 00000000 00000001\r\nCPU: After vendor identify, caps: 078bfbff 20100800 00000000 00000000 00000209 00000000 00000001\r\nCPU: L2 cache: 6144K\r\nCPU: After all inits, caps: 078bf3ff 20100800 00000000 00000140 00000209 00000000 00000001\r\nIntel machine check reporting enabled on CPU#0.\r\nCPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b\r\nBrought up 1 CPUs\r\nprocessor       : 0\r\ncpu MHz         : 3569.313\r\n','memory/Ethernet Info: Memory for crash kernel (0x0 to 0x0) notwithin permissible range\r\nMemory: 1031252k/1048512k available (2179k kernel code, 16440k reserved, 907k data, 228k init, 131008k highmem)\r\nFreeing initrd memory: 3243k freed\r\nTotal HugeTLB memory allocated, 0\r\nNon-volatile memory driver v1.2\r\nFreeing unused kernel memory: 228k freed\r\n             total       used       free     shared    buffers     cached\r\nMem:       1035108     555484     479624          0     137628     358676\r\n-/+ buffers/cache:      59180     975928\r\nSwap:      2097144          0    2097144','/dev/VolGroup00/LogVol00 /                       ext3    defaults        1 1\r\nLABEL=/boot             /boot                   ext3    defaults        1 2\r\ntmpfs                   /dev/shm                tmpfs   defaults        0 0\r\ndevpts                  /dev/pts                devpts  gid=5,mode=620  0 0\r\nsysfs                   /sys                    sysfs   defaults        0 0\r\nproc                    /proc                   proc    defaults        0 0\r\n/dev/VolGroup00/LogVol01 swap                    swap    defaults        0 0\r\n','Checking the ip address(es) of this Machine: \r\nInterface info: eth0      Link encap:Ethernet  HWaddr 08:00:27:F5:D7:8B  \r\n          inet addr:10.19.95.22  Bcast:10.19.95.255  Mask:255.255.255.0\r\n          inet6 addr: fe80::a00:27ff:fef5:d78b/64 Scope:Link\r\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\r\n          RX packets:49261 errors:0 dropped:0 overruns:0 frame:0\r\n          TX packets:27677 errors:0 dropped:0 overruns:0 carrier:0\r\n          collisions:0 txqueuelen:1000 \r\n          RX bytes:13109926 (12.5 MiB)  TX bytes:3424923 (3.2 MiB)\r\n\r\nlo        Link encap:Local Loopback  \r\n          inet addr:127.0.0.1  Mask:255.0.0.0\r\n          inet6 addr: ::1/128 Scope:Host\r\n          UP LOOPBACK RUNNING  MTU:16436  Metric:1\r\n          RX packets:426 errors:0 dropped:0 overruns:0 frame:0\r\n          TX packets:426 errors:0 dropped:0 overruns:0 carrier:0\r\n          collisions:0 txqueuelen:0 \r\n          RX bytes:59192 (57.8 KiB)  TX bytes:59192 (57.8 KiB)\r\n\r\nsit0      Link encap:IPv6-in-IPv4  \r\n          NOARP  MTU:1480  Metric:1\r\n          RX packets:0 errors:0 dropped:0 overruns:0 frame:0\r\n          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0\r\n          collisions:0 txqueuelen:0 \r\n          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)\r\n',0);
/*!40000 ALTER TABLE `scanhw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanloc`
--

DROP TABLE IF EXISTS `scanloc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scanloc` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `location` varchar(255) DEFAULT NULL,
  `limit` int(19) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanloc`
--

LOCK TABLES `scanloc` WRITE;
/*!40000 ALTER TABLE `scanloc` DISABLE KEYS */;
INSERT INTO `scanloc` VALUES (1,'/home/$user',500),(2,'/var/tmp',NULL),(3,'/tmp',NULL),(4,'/usr/bin',NULL),(5,'/usr/sbin',NULL),(6,'/bin',NULL),(7,'/sbin',NULL),(8,'/var/lib',100),(9,'/var/log',NULL),(10,'/usr/local',100),(11,'/opt',NULL);
/*!40000 ALTER TABLE `scanloc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scansw`
--

DROP TABLE IF EXISTS `scansw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scansw` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `version` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scansw`
--

LOCK TABLES `scansw` WRITE;
/*!40000 ALTER TABLE `scansw` DISABLE KEYS */;
INSERT INTO `scansw` VALUES (1,'rmt','0.4b41-4.el5',NULL),(2,'telnet','0.17-39.el5',NULL);
/*!40000 ALTER TABLE `scansw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scantype`
--

DROP TABLE IF EXISTS `scantype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scantype` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scantype`
--

LOCK TABLES `scantype` WRITE;
/*!40000 ALTER TABLE `scantype` DISABLE KEYS */;
INSERT INTO `scantype` VALUES (2,'filescan'),(1,'genericscan'),(4,'mailscan'),(3,'stegscan'),(5,'webscan');
/*!40000 ALTER TABLE `scantype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysinfo`
--

DROP TABLE IF EXISTS `sysinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysinfo` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `system_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysinfo`
--

LOCK TABLES `sysinfo` WRITE;
/*!40000 ALTER TABLE `sysinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysinfo_filename`
--

DROP TABLE IF EXISTS `sysinfo_filename`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysinfo_filename` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `sysinfo_id` int(19) unsigned NOT NULL,
  `filename_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysinfo_filename`
--

LOCK TABLES `sysinfo_filename` WRITE;
/*!40000 ALTER TABLE `sysinfo_filename` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysinfo_filename` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysinfo_scanloc`
--

DROP TABLE IF EXISTS `sysinfo_scanloc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysinfo_scanloc` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `sysinfo_id` int(19) unsigned NOT NULL,
  `scanloc_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysinfo_scanloc`
--

LOCK TABLES `sysinfo_scanloc` WRITE;
/*!40000 ALTER TABLE `sysinfo_scanloc` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysinfo_scanloc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysinfo_scansw`
--

DROP TABLE IF EXISTS `sysinfo_scansw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysinfo_scansw` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `sysinfo_id` int(19) unsigned NOT NULL,
  `scansw_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysinfo_scansw`
--

LOCK TABLES `sysinfo_scansw` WRITE;
/*!40000 ALTER TABLE `sysinfo_scansw` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysinfo_scansw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysinfo_scantype`
--

DROP TABLE IF EXISTS `sysinfo_scantype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysinfo_scantype` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `sysinfo_id` int(19) unsigned NOT NULL,
  `scantype_id` int(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysinfo_scantype`
--

LOCK TABLES `sysinfo_scantype` WRITE;
/*!40000 ALTER TABLE `sysinfo_scantype` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysinfo_scantype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysos`
--

DROP TABLE IF EXISTS `sysos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysos` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `os` varchar(255) NOT NULL,
  `distrib` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysos`
--

LOCK TABLES `sysos` WRITE;
/*!40000 ALTER TABLE `sysos` DISABLE KEYS */;
INSERT INTO `sysos` VALUES (1,'Linux','Debian',NULL),(2,'Linux','Ubuntu',NULL),(3,'Linux','RedHat',NULL),(4,'Linux','CentOS',NULL),(5,'Linux','SLES',NULL),(6,'FreeBSD',NULL,NULL),(7,'OpenBSD',NULL,NULL),(8,'NetBSD',NULL,NULL),(9,'SunSolaris',NULL,'8'),(10,'OpenSolaris',NULL,'2009.06'),(11,'OracleSolaris',NULL,'11');
/*!40000 ALTER TABLE `sysos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysrole`
--

DROP TABLE IF EXISTS `sysrole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysrole` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysrole`
--

LOCK TABLES `sysrole` WRITE;
/*!40000 ALTER TABLE `sysrole` DISABLE KEYS */;
INSERT INTO `sysrole` VALUES (10,'Auth-Server'),(2,'Desktop'),(6,'DNS-Server'),(5,'File-Server'),(1,'Generic'),(7,'LDAP-Server'),(8,'Log-Server'),(4,'Mail-Server'),(9,'VPN-Server'),(3,'Web-Server');
/*!40000 ALTER TABLE `sysrole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `ipaddress` varchar(255) NOT NULL,
  `cidr` tinyint(3) unsigned DEFAULT NULL,
  `sysos_id` tinyint(3) unsigned NOT NULL,
  `sysrole_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ipaddress` (`ipaddress`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system`
--

LOCK TABLES `system` WRITE;
/*!40000 ALTER TABLE `system` DISABLE KEYS */;
INSERT INTO `system` VALUES (1,'10.19.95.22',32,3,1),(3,'10.19.95.23',32,1,1);
/*!40000 ALTER TABLE `system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useracc`
--

DROP TABLE IF EXISTS `useracc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `useracc` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `vfatsuser` tinyint(1) unsigned NOT NULL,
  `userole_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useracc`
--

LOCK TABLES `useracc` WRITE;
/*!40000 ALTER TABLE `useracc` DISABLE KEYS */;
INSERT INTO `useracc` VALUES (1,'root',NULL,NULL,0,1),(2,'adm',NULL,NULL,0,1),(3,'bin',NULL,NULL,0,1),(4,'daemon',NULL,NULL,0,1),(5,'sys',NULL,NULL,0,1),(6,'sync',NULL,NULL,0,1),(7,'lp',NULL,NULL,0,1),(8,'shutdown',NULL,NULL,0,1),(9,'halt',NULL,NULL,0,1),(10,'mail',NULL,NULL,0,1),(11,'news',NULL,NULL,0,1),(12,'uucp',NULL,NULL,0,1),(13,'operator',NULL,NULL,0,1),(14,'games',NULL,NULL,0,1),(15,'gopher',NULL,NULL,0,1),(16,'ftp',NULL,NULL,0,1),(17,'nobody',NULL,NULL,0,1),(18,'nscd',NULL,NULL,0,1),(19,'vcsa',NULL,NULL,0,1),(20,'rpc',NULL,NULL,0,1),(21,'mailnull',NULL,NULL,0,1),(22,'smmsp',NULL,NULL,0,1),(23,'pcap',NULL,NULL,0,1),(24,'dbus',NULL,NULL,0,1),(25,'avahi',NULL,NULL,0,1),(26,'sshd',NULL,NULL,0,1),(27,'rpcuser',NULL,NULL,0,1),(28,'nfsnobody',NULL,NULL,0,1),(29,'haldaemon',NULL,NULL,0,1),(30,'avahi-autoipd ',NULL,NULL,0,1),(52,'oprofile',NULL,NULL,0,1),(53,'xfs',NULL,NULL,0,1),(54,'vboxadd',NULL,NULL,0,1),(55,'apache',NULL,NULL,0,1),(56,'bind',NULL,NULL,0,1),(57,'postfix',NULL,NULL,0,1),(58,'mysql',NULL,NULL,0,1),(59,'rtkit',NULL,NULL,0,1),(60,'man',NULL,NULL,0,1),(61,'www-data',NULL,NULL,0,1),(62,'backup',NULL,NULL,0,1),(63,'gnats',NULL,NULL,0,1),(64,'host',NULL,NULL,0,1),(65,'hplip',NULL,NULL,0,1),(66,'irc',NULL,NULL,0,1),(67,'kernoops',NULL,NULL,0,1),(68,'libuuid',NULL,NULL,0,1),(69,'list',NULL,NULL,0,1),(70,'messagebus',NULL,NULL,0,1),(72,'proxy',NULL,NULL,0,1),(73,'saned',NULL,NULL,0,1),(74,'syslog',NULL,NULL,0,1),(76,'usbmux',NULL,NULL,0,1),(92,'vamegh','Vamegh','Hedayati',1,2),(93,'automaton','vFats','Account',0,2);
/*!40000 ALTER TABLE `useracc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userdate`
--

DROP TABLE IF EXISTS `userdate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userdate` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `validfrom` datetime NOT NULL,
  `expires` datetime NOT NULL,
  `useracc_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdate`
--

LOCK TABLES `userdate` WRITE;
/*!40000 ALTER TABLE `userdate` DISABLE KEYS */;
INSERT INTO `userdate` VALUES (1,'2010-11-01 01:33:56','2015-11-30 01:33:59',92);
/*!40000 ALTER TABLE `userdate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userkey`
--

DROP TABLE IF EXISTS `userkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userkey` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `keyfile` mediumtext NOT NULL,
  `filehash_id` int(19) unsigned DEFAULT NULL,
  `useracc_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userkey`
--

LOCK TABLES `userkey` WRITE;
/*!40000 ALTER TABLE `userkey` DISABLE KEYS */;
INSERT INTO `userkey` VALUES (1,'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAmSh8kcqlKkdHg6hCnDodQwZnFFbgAX+KhHjC7Tbtickv44oi6b4nMuIFpp5eExA8VTEOddUH3didfkxU9ublLOpkZBWud0bBmTaNIMqTw4vvZfPosu8bxAyjDhQY8oRLR2RpUTSvO+LnE1h7ZYwIloeahrC3n7wnAXbn8zx14zbQpnP9V32+/Mr3KI1gb1nOsuJDsHo5SXgg8TtehzldL2EmF67A5cNH0YVnYZBH/q7x2VyyQqRESmE/WhnCnZx+9k2GjI6yB1aUrOf/uaixCIIHvd9G8BDS4wDUwh0TQU+DNWCJQkkVvljxpvPQayrNtzTj3Vm7YxkrcblJZbI4Q3fnpT0MQNzHU0a/Ery4qgY+DznbpaAaNTJkIJ+nmg5ujJ7eGRHLq0R9EyS22hL+jmcQGCOmyTxPYrlos6s/bU+NdLOq6krPwZRgpWMGZA76SAoc6wirpEzyRZKimQk+xzjAc63rnjSzPqtr6zHvFUdj60goigFzjmNEPnPCVBey1FuK8T0TwGlskoD6w5WizMMKXKKr0iXG0iMn1nVthx42oUCJ+F+j/1G8BxWuKlFSUxHSaKjF5anqVwk5D3D2UnUKq9NUWyUpl8YhKm6TEwaAgSiWsi5NobNrCsJSJrd2elEJ1r1DpnGrdNL4MEO9OPhgthYGkI/Nv7ZwkyQx62c= host@fr1ght\r\n',1,92);
/*!40000 ALTER TABLE `userkey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlink`
--

DROP TABLE IF EXISTS `userlink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userlink` (
  `id` int(19) NOT NULL AUTO_INCREMENT,
  `system_id` int(19) NOT NULL,
  `useracc_id` int(19) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlink`
--

LOCK TABLES `userlink` WRITE;
/*!40000 ALTER TABLE `userlink` DISABLE KEYS */;
INSERT INTO `userlink` VALUES (1,1,1),(2,1,92),(3,1,93);
/*!40000 ALTER TABLE `userlink` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userole`
--

DROP TABLE IF EXISTS `userole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userole` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userole`
--

LOCK TABLES `userole` WRITE;
/*!40000 ALTER TABLE `userole` DISABLE KEYS */;
INSERT INTO `userole` VALUES (1,'system'),(2,'admin'),(3,'staff'),(4,'user'),(5,'guest');
/*!40000 ALTER TABLE `userole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userpass`
--

DROP TABLE IF EXISTS `userpass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userpass` (
  `id` int(19) unsigned NOT NULL AUTO_INCREMENT,
  `passwd` varchar(255) DEFAULT NULL,
  `filehash_id` int(19) unsigned DEFAULT NULL,
  `useracc_id` int(19) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userpass`
--

LOCK TABLES `userpass` WRITE;
/*!40000 ALTER TABLE `userpass` DISABLE KEYS */;
INSERT INTO `userpass` VALUES (1,'$6$j029c61.$d4fW9m06kKNI3irC7AMt3qAkba9pTEBK.lt1VXB2h6zjKprHF9r4YnabSAg8JGAK/hAmDDDM7IXKtmwqyyv7H0:14736',0,92);
/*!40000 ALTER TABLE `userpass` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-12-15 22:59:27
