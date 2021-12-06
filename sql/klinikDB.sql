SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(32) COLLATE utf8_bin NOT NULL,
  `Password` varchar(32) COLLATE utf8_bin NOT NULL,
  `Role` enum('ADMIN','MEDICAL','PHARMACY','CONS') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `userName` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `antenatal`;

CREATE TABLE `antenatal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `G` enum('0','1','2','3','4','5','6','7','8','9','10') COLLATE utf8_bin DEFAULT NULL COMMENT 'Gestations',
  `P` enum('0','1','2','3','4','5','6','7','8','9','10') COLLATE utf8_bin DEFAULT NULL COMMENT 'Paritus',
  `A` enum('0','1','2','3','4','5','6','7','8','9','10') COLLATE utf8_bin DEFAULT NULL COMMENT 'Abortus',
  `M` enum('0','1','2','3','4','5','6','7','8','9','10') COLLATE utf8_bin DEFAULT NULL COMMENT 'Mati',
  `date` date NOT NULL COMMENT 'visit date',
  `docID` int(11) DEFAULT NULL,
  `visit` enum('1','2','3','4','5','6','7','8','9','10') COLLATE utf8_bin DEFAULT NULL COMMENT 'visit number, this pregnancy',
  `tfu` decimal(4,1) DEFAULT NULL COMMENT 'fundus height, cm',
  `height` int(3) DEFAULT NULL COMMENT 'mother height, cm',
  `heart_m` int(3) DEFAULT NULL COMMENT 'mother heart rate, bpm',
  `heart_c` int(3) DEFAULT NULL COMMENT 'baby heart rate, bpm',
  `last_period` date DEFAULT NULL COMMENT 'Last period',
  `birth_date` date DEFAULT NULL COMMENT 'predicted labor date',
  `nextvisit` date DEFAULT NULL COMMENT 'next visit date',
  `risk` enum('bas','haut') COLLATE utf8_bin DEFAULT NULL COMMENT 'predicted risk',
  `tetanus` enum('0','1','2','3','4','5') COLLATE utf8_bin DEFAULT NULL COMMENT 'Number of anti-tetanus shots',
  `edema` tinyint(1) DEFAULT NULL,
  `bleeding` tinyint(1) DEFAULT NULL,
  `shrinking` tinyint(1) DEFAULT NULL,
  `stillfet` tinyint(1) DEFAULT NULL,
  `malaria` tinyint(1) DEFAULT NULL,
  `ultrasound` tinyint(1) DEFAULT NULL,
  `sti` tinyint(1) DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `visits` (`patientID`,`date`,`visit`),
  KEY `patientID` (`patientID`),
  KEY `docID` (`docID`),
  CONSTRAINT `docID` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`),
  CONSTRAINT `patientID` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_antenatal` BEFORE INSERT ON `antenatal` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New antenatal record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `crop`;

CREATE TABLE `crop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key1` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `diagnoses`;

CREATE TABLE `diagnoses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `date` date NOT NULL,
  `suspect` tinyint(1) NOT NULL DEFAULT 0,
  `docID` int(11) DEFAULT NULL,
  `icd10ID` int(11) NOT NULL,
  `note` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `patientID` (`patientID`),
  KEY `icd10ID` (`icd10ID`),
  KEY `docID` (`docID`),
  CONSTRAINT `diagnoses_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`),
  CONSTRAINT `diagnoses_ibfk_2` FOREIGN KEY (`icd10ID`) REFERENCES `icd10` (`id`),
  CONSTRAINT `diagnoses_ibfk_3` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_diagnosis` BEFORE INSERT ON `diagnoses` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New diagnosis record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `doc`;

CREATE TABLE `doc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `drug`;

CREATE TABLE `drug` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `genericID` int(11) NOT NULL,
  `format` enum('ampoule','inhalateur','capsule','solution','nébuliseur','sachet','sirop','sirop sec','vaporisateur','suppositoire','tablette','gouttes','tube','flacon','poudre') COLLATE utf8_bin NOT NULL,
  `size` decimal(10,2) DEFAULT NULL,
  `units` enum('g','mg','ug','L','mL','IU') COLLATE utf8_bin DEFAULT NULL,
  `conc` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `genericID_2` (`genericID`,`format`,`size`),
  KEY `genericID` (`genericID`),
  CONSTRAINT `drug_ibfk_1` FOREIGN KEY (`genericID`) REFERENCES `drugGeneric` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `drugDispense`;

CREATE TABLE `drugDispense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drugID` int(11) NOT NULL,
  `numberTot` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `dosage` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `patientID` int(11) NOT NULL,
  `docID` int(11) DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `drugID` (`drugID`),
  KEY `patientID` (`patientID`),
  KEY `docID` (`docID`),
  CONSTRAINT `drugDispense_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`),
  CONSTRAINT `drugDispense_ibfk_2` FOREIGN KEY (`drugID`) REFERENCES `drug` (`id`),
  CONSTRAINT `drugDispense_ibfk_3` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_drugDispense` BEFORE INSERT ON `drugDispense` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New drugDispense record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `drugGeneric`;

CREATE TABLE `drugGeneric` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nameEng` varchar(100) CHARACTER SET utf8 NOT NULL,
  `class` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nameEng` (`nameEng`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `drugManuf`;

CREATE TABLE `drugManuf` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `alamat` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `drugPackage`;

CREATE TABLE `drugPackage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unitID` int(11) NOT NULL,
  `container` enum('bouteille','boîte de conserve','boîte','individuel') COLLATE utf8_bin NOT NULL,
  `unitsPerCont` int(11) NOT NULL,
  `tradeName` varchar(100) COLLATE utf8_bin NOT NULL,
  `manufID` int(11) NOT NULL,
  `keepStocked` int(11) DEFAULT NULL,
  `oldestExpiry` date DEFAULT NULL,
  `inUse` enum('oui','non') COLLATE utf8_bin NOT NULL DEFAULT 'oui',
  PRIMARY KEY (`id`),
  UNIQUE KEY `manufID_2` (`manufID`,`unitID`,`unitsPerCont`,`container`),
  KEY `unitID` (`unitID`),
  KEY `manufID` (`manufID`),
  CONSTRAINT `drugPackage_ibfk_1` FOREIGN KEY (`unitID`) REFERENCES `drug` (`id`),
  CONSTRAINT `drugPackage_ibfk_2` FOREIGN KEY (`manufID`) REFERENCES `drugManuf` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `drugStock`;

CREATE TABLE `drugStock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `packageID` int(11) NOT NULL,
  `correction` tinyint(1) NOT NULL DEFAULT 0,
  `number` int(11) NOT NULL,
  `transDate` date NOT NULL,
  `costRp` int(11) DEFAULT NULL,
  `batch` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `supplID` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `packageID` (`packageID`),
  KEY `supplID` (`supplID`),
  CONSTRAINT `drugStock_ibfk_2` FOREIGN KEY (`supplID`) REFERENCES `drugSuppl` (`id`),
  CONSTRAINT `drugStock_ibfk_4` FOREIGN KEY (`packageID`) REFERENCES `drugPackage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `drugSuppl`;

CREATE TABLE `drugSuppl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `address` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `phone` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `contact` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `dusun`;

CREATE TABLE `dusun` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `villageID` int(11) NOT NULL,
  `sous` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dusun_key1` (`villageID`,`sous`),
  CONSTRAINT `villageID` FOREIGN KEY (`villageID`) REFERENCES `village` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `fp`;

CREATE TABLE `fp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'visit date',
  `docID` int(11) DEFAULT NULL,
  `newpat` enum('nouveau','ancien') COLLATE utf8_bin DEFAULT NULL,
  `type` enum('diu','injectable','pillule','implant') COLLATE utf8_bin NOT NULL,
  `grosesse` enum('negatif','positif') COLLATE utf8_bin DEFAULT NULL,
  `last_period` date DEFAULT NULL COMMENT 'last period',
  `nextvisit` date DEFAULT NULL COMMENT 'next visit date',
  `kidage` int(3) DEFAULT NULL COMMENT 'age last kid (months)',
  `nkids` int(3) DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fp_pat+date+type` (`patientID`,`date`,`type`),
  KEY `fp_patientID` (`patientID`),
  KEY `fp_docID` (`docID`),
  CONSTRAINT `fp_docID` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`),
  CONSTRAINT `fp_patientID` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_fp` BEFORE INSERT ON `fp` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New fp record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `general`;

CREATE TABLE `general` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'visit date',
  `docID` int(11) NOT NULL,
  `dusunID` int(11) NOT NULL COMMENT 'village of clinic visit',
  `bp_s` int(3) DEFAULT NULL,
  `bp_d` int(3) DEFAULT NULL,
  `weight` decimal(4,1) DEFAULT NULL COMMENT 'kg',
  `arm` decimal(4,1) DEFAULT NULL COMMENT 'cm',
  `refer` tinyint(1) DEFAULT NULL,
  `referto` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `notes` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pat+date` (`patientID`,`date`),
  KEY `patient` (`patientID`),
  KEY `doc` (`docID`),
  KEY `village` (`dusunID`),
  CONSTRAINT `doc` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`),
  CONSTRAINT `patient` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`),
  CONSTRAINT `village` FOREIGN KEY (`dusunID`) REFERENCES `dusun` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `icd10`;

CREATE TABLE `icd10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8_bin NOT NULL,
  `name` varchar(200) COLLATE utf8_bin NOT NULL,
  `common` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `icd10` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `monitoring`;

CREATE TABLE `monitoring` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `periodID` int(11) NOT NULL,
  `villageID` int(11) NOT NULL,
  `status` enum('red','green') COLLATE utf8_bin NOT NULL,
  `poachingFG` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `loggingFG` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `banditFG` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `poachingGERP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `loggingGERP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `banditGERP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `poachingMNP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `loggingMNP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `banditMNP` enum('non','oui') COLLATE utf8_bin NOT NULL DEFAULT 'non',
  `nPeopleEd` int(11) NOT NULL COMMENT '# participants educated by Forest Guardians',
  `nFG` int(11) NOT NULL COMMENT '# of active forest guardians',
  `nFGmeetings` int(11) NOT NULL COMMENT '# of forest guardians meetings',
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mon3` (`periodID`,`villageID`),
  KEY `mon1` (`villageID`),
  KEY `mon2` (`periodID`),
  CONSTRAINT `mon_fk1` FOREIGN KEY (`villageID`) REFERENCES `village` (`id`),
  CONSTRAINT `mon_fk2` FOREIGN KEY (`periodID`) REFERENCES `period` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `patient`;

CREATE TABLE `patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patrec` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `sex` enum('H','F') COLLATE utf8_bin NOT NULL,
  `fathername` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `mothername` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `child1name` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `birthdate` date NOT NULL,
  `approxdob` tinyint(1) NOT NULL DEFAULT 0,
  `birthvillage` int(11) DEFAULT NULL,
  `dusunID` int(11) NOT NULL,
  `notes` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `patrec` (`patrec`),
  KEY `dusunID` (`dusunID`),
  KEY `patient_ibfk_2` (`birthvillage`),
  CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`dusunID`) REFERENCES `dusun` (`id`),
  CONSTRAINT `patient_ibfk_2` FOREIGN KEY (`birthvillage`) REFERENCES `dusun` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `patient_birthdate` BEFORE INSERT ON `patient` FOR EACH ROW
BEGIN
  IF YEAR(NEW.birthdate) < 1900 AND NEW.birthdate != '1899-12-31'
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Birthdate must be after 1900';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `period`;

CREATE TABLE `period` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startDate` date NOT NULL COMMENT 'start of status period',
  `endDate` date NOT NULL COMMENT 'end of status period',
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `planting`;

CREATE TABLE `planting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `locn` varchar(200) COLLATE utf8_bin NOT NULL COMMENT 'description of location',
  `reserve` enum('MSR Area 1','MSR Area 2','Extérieur') COLLATE utf8_bin NOT NULL,
  `dusunID` int(11) DEFAULT NULL COMMENT 'responsible village, if any',
  `type` enum('sylviculture','agroforesterie') COLLATE utf8_bin NOT NULL,
  `ha` decimal(6,2) NOT NULL,
  `long` decimal(8,5) DEFAULT NULL,
  `lat` decimal(7,5) DEFAULT NULL,
  `nSdl` int(11) NOT NULL,
  `nSpp` int(11) DEFAULT NULL,
  `sppList` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `surv45d` decimal(4,1) DEFAULT NULL,
  `surv6m` decimal(4,1) DEFAULT NULL,
  `surv12m` decimal(4,1) DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plant1` (`dusunID`),
  CONSTRAINT `plant_fk1` FOREIGN KEY (`dusunID`) REFERENCES `dusun` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `plot`;

CREATE TABLE `plot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `trainingID` int(11) NOT NULL,
  `dusunID` int(11) DEFAULT NULL,
  `cropID` int(11) NOT NULL,
  `area` int(11) NOT NULL COMMENT 'area in m^2',
  `harvest_date` date DEFAULT NULL,
  `harvest_kg` int(11) DEFAULT NULL COMMENT 'harvest weight in kg',
  PRIMARY KEY (`id`),
  KEY `trainingID` (`trainingID`),
  KEY `cropID` (`cropID`),
  KEY `plot3` (`dusunID`),
  CONSTRAINT `plot1` FOREIGN KEY (`cropID`) REFERENCES `crop` (`id`),
  CONSTRAINT `plot2` FOREIGN KEY (`trainingID`) REFERENCES `training` (`id`),
  CONSTRAINT `plot3` FOREIGN KEY (`dusunID`) REFERENCES `dusun` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `species`;

CREATE TABLE `species` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sciname` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `localname` varchar(200) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sp2` (`localname`),
  UNIQUE KEY `sp1` (`sciname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `speciesPerPlanting`;

CREATE TABLE `speciesPerPlanting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `speciesID` int(11) NOT NULL,
  `plantingID` int(11) NOT NULL,
  `nSdl` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `spp3` (`speciesID`,`plantingID`),
  KEY `spp1` (`speciesID`),
  KEY `spp2` (`plantingID`),
  CONSTRAINT `spp_fk1` FOREIGN KEY (`speciesID`) REFERENCES `species` (`id`),
  CONSTRAINT `spp_fk2` FOREIGN KEY (`plantingID`) REFERENCES `planting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `training`;

CREATE TABLE `training` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `hours` int(11) NOT NULL COMMENT 'total hours',
  `grad_date` date NOT NULL COMMENT 'graduation date',
  PRIMARY KEY (`id`),
  UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `trainingParticipant`;

CREATE TABLE `trainingParticipant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personID` int(11) NOT NULL,
  `trainingID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_x_training` (`personID`,`trainingID`),
  KEY `personID` (`personID`),
  KEY `trainingID` (`trainingID`),
  CONSTRAINT `fk1` FOREIGN KEY (`personID`) REFERENCES `patient` (`id`),
  CONSTRAINT `fk2` FOREIGN KEY (`trainingID`) REFERENCES `training` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `vaxShot`;

CREATE TABLE `vaxShot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'visit date',
  `docID` int(11) DEFAULT NULL,
  `newvax` enum('nouveau','ancien') COLLATE utf8_bin DEFAULT NULL,
  `nextvisit` date DEFAULT NULL COMMENT 'next visit date',
  `notes` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `v_bcg` int(1) DEFAULT NULL,
  `v_polio1` int(1) DEFAULT NULL,
  `v_polio2` int(1) DEFAULT NULL,
  `v_polio3` int(1) DEFAULT NULL,
  `v_dtc1` int(1) DEFAULT NULL,
  `v_dtc2` int(1) DEFAULT NULL,
  `v_dtc3` int(1) DEFAULT NULL,
  `v_rota1` int(1) DEFAULT NULL,
  `v_rota2` int(1) DEFAULT NULL,
  `v_pcv1` int(1) DEFAULT NULL,
  `v_pcv2` int(1) DEFAULT NULL,
  `v_pcv3` int(1) DEFAULT NULL,
  `v_vpi` int(1) DEFAULT NULL,
  `v_var1` int(1) DEFAULT NULL,
  `v_var2` int(1) DEFAULT NULL,
  `v_tet1` int(1) DEFAULT NULL,
  `v_tet2` int(1) DEFAULT NULL,
  `v_tet3` int(1) DEFAULT NULL,
  `v_tet4` int(1) DEFAULT NULL,
  `v_tet5` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vaxShot_pat+date` (`patientID`,`date`),
  KEY `vaxShot_patientID` (`patientID`),
  KEY `vaxShot_docID` (`docID`),
  CONSTRAINT `vaxShot_docID` FOREIGN KEY (`docID`) REFERENCES `doc` (`id`),
  CONSTRAINT `vaxShot_patientID` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_vax` BEFORE INSERT ON `vaxShot` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New vaxShot record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `village`;

CREATE TABLE `village` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `village` varchar(200) COLLATE utf8_bin NOT NULL,
  `commune` varchar(200) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `village_key1` (`village`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `visit`;

CREATE TABLE `visit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patientID` int(11) NOT NULL,
  `visitTypeID` int(11) NOT NULL,
  `nSdl` int(11) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patientID` (`patientID`),
  KEY `visitTypeID` (`visitTypeID`),
  CONSTRAINT `visit_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`),
  CONSTRAINT `visit_ibfk_2` FOREIGN KEY (`visitTypeID`) REFERENCES `visitType` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DELIMITER ;;
CREATE  TRIGGER `sign_of_payment` BEFORE INSERT ON `visit` FOR EACH ROW
BEGIN
  DECLARE T VARCHAR(10);
  SET T = (SELECT `type` FROM visitType WHERE id = NEW.visitTypeID);
  IF (T = 'payment' AND NEW.amount > 0 ) OR
     (T = 'service' AND NEW.amount < 0 )
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payments must be negative and services must be positive';
  END IF;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  TRIGGER `visit_date` BEFORE INSERT ON `visit` FOR EACH ROW
BEGIN
  IF YEAR(NEW.`date`) < 2017  AND NEW.`date` != '1899-12-31'
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The date must be after 2017-01-01';
  END IF;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  TRIGGER `make_general_before_visit` BEFORE INSERT ON `visit` FOR EACH ROW
BEGIN
  DECLARE TEST INT(11);
  SET TEST = (SELECT count(*) FROM `general`
           WHERE `date` = NEW.`date` AND `patientID` = NEW.patientID);
  IF (TEST = 0) AND (NEW.amount > 0)
     THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
       'New visit _charge_ record requires prior `general` record';
  END IF;
END ;;
DELIMITER ;

DROP TABLE IF EXISTS `visitType`;

CREATE TABLE `visitType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(50) COLLATE utf8_bin NOT NULL,
  `type` enum('service','payment') COLLATE utf8_bin NOT NULL DEFAULT 'service',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


