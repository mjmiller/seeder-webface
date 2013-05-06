SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `th_algorithm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_algorithm` ;

CREATE  TABLE IF NOT EXISTS `th_algorithm` (
  `th_algorithm_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  PRIMARY KEY (`th_algorithm_id`) ,
  INDEX `th_algorithm_id` (`th_algorithm_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_user` ;

CREATE  TABLE IF NOT EXISTS `th_user` (
  `th_userId` INT NOT NULL AUTO_INCREMENT ,
  `cms_user_id` INT NOT NULL ,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`th_userId`) ,
  INDEX `cms_user_id` (`cms_user_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 112
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_source_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_source_type` ;

CREATE  TABLE IF NOT EXISTS `th_source_type` (
  `th_source_type_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  PRIMARY KEY (`th_source_type_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_source` ;

CREATE  TABLE IF NOT EXISTS `th_source` (
  `th_source_id` INT NOT NULL AUTO_INCREMENT ,
  `th_source_type_id` INT NOT NULL ,
  `th_user_id` INT NOT NULL ,
  `th_algorithm_id` INT NULL ,
  `external_ref_id` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`th_source_id`) ,
  INDEX `th_source_type_id` (`th_source_type_id` ASC) ,
  INDEX `th_algorithm_id` (`th_algorithm_id` ASC) ,
  INDEX `th_user_id` (`th_user_id` ASC) ,
  CONSTRAINT `th_source_ibfk_3`
    FOREIGN KEY (`th_user_id` )
    REFERENCES `th_user` (`th_userId` ),
  CONSTRAINT `th_source_ibfk_1`
    FOREIGN KEY (`th_source_type_id` )
    REFERENCES `th_source_type` (`th_source_type_id` ),
  CONSTRAINT `th_source_ibfk_2`
    FOREIGN KEY (`th_algorithm_id` )
    REFERENCES `th_algorithm` (`th_algorithm_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_editor_action`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_editor_action` ;

CREATE  TABLE IF NOT EXISTS `th_editor_action` (
  `th_editor_action_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  PRIMARY KEY (`th_editor_action_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_mod_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_mod_info` ;

CREATE  TABLE IF NOT EXISTS `th_mod_info` (
  `th_mod_info_id` INT NOT NULL AUTO_INCREMENT ,
  `th_source_id` INT NOT NULL ,
  `th_editor_action_id` INT NOT NULL ,
  `mod_datetime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`th_mod_info_id`) ,
  INDEX `th_source_id` (`th_source_id` ASC, `th_editor_action_id` ASC) ,
  INDEX `th_editor_action_id` (`th_editor_action_id` ASC) ,
  CONSTRAINT `th_mod_info_ibfk_1`
    FOREIGN KEY (`th_source_id` )
    REFERENCES `th_source` (`th_source_id` ),
  CONSTRAINT `th_mod_info_ibfk_2`
    FOREIGN KEY (`th_editor_action_id` )
    REFERENCES `th_editor_action` (`th_editor_action_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 1000
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_part_of_speech`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_part_of_speech` ;

CREATE  TABLE IF NOT EXISTS `th_part_of_speech` (
  `th_part_of_speech_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL ,
  `abbr` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`th_part_of_speech_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `th_definition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_definition` ;

CREATE  TABLE IF NOT EXISTS `th_definition` (
  `th_definition_id` INT NOT NULL AUTO_INCREMENT ,
  `definition` VARCHAR(2000) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  `th_part_of_speech_id` INT NULL ,
  PRIMARY KEY (`th_definition_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  INDEX `fk_th_definition_th_part_of_speech1_idx` (`th_part_of_speech_id` ASC) ,
  CONSTRAINT `th_definition_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ),
  CONSTRAINT `fk_th_definition_th_part_of_speech1`
    FOREIGN KEY (`th_part_of_speech_id` )
    REFERENCES `th_part_of_speech` (`th_part_of_speech_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2018
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_domain`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_domain` ;

CREATE  TABLE IF NOT EXISTS `th_domain` (
  `th_domain_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  PRIMARY KEY (`th_domain_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_metadata_key`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_metadata_key` ;

CREATE  TABLE IF NOT EXISTS `th_metadata_key` (
  `th_metadata_key_id` INT NOT NULL AUTO_INCREMENT ,
  `key` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_metadata_key_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_metadata_key_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_sort_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_sort_type` ;

CREATE  TABLE IF NOT EXISTS `th_sort_type` (
  `th_sort_type_id` INT NOT NULL AUTO_INCREMENT ,
  `label` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  `th_metadata_key_id` INT NULL ,
  PRIMARY KEY (`th_sort_type_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  INDEX `th_sort_type_ibfk_2_idx` (`th_metadata_key_id` ASC) ,
  CONSTRAINT `th_sort_type_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `th_sort_type_ibfk_2`
    FOREIGN KEY (`th_metadata_key_id` )
    REFERENCES `th_metadata_key` (`th_metadata_key_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_sort_direction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_sort_direction` ;

CREATE  TABLE IF NOT EXISTS `th_sort_direction` (
  `th_sort_direction_id` INT NOT NULL AUTO_INCREMENT ,
  `label` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_sort_direction_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_sort_direction_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_sort_type_direction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_sort_type_direction` ;

CREATE  TABLE IF NOT EXISTS `th_sort_type_direction` (
  `th_sort_type_direction_id` INT NOT NULL AUTO_INCREMENT ,
  `th_sort_type_id` INT NOT NULL ,
  `th_sort_direction_asc_id` INT NOT NULL ,
  `th_sort_direction_desc_id` INT NOT NULL ,
  PRIMARY KEY (`th_sort_type_direction_id`) ,
  INDEX `th_sort_type_id` (`th_sort_type_id` ASC) ,
  INDEX `th_sort_direction_id` (`th_sort_direction_asc_id` ASC) ,
  INDEX `th_sort_type_direction_ibfk_2_idx` (`th_sort_direction_desc_id` ASC) ,
  CONSTRAINT `th_sort_type_direction_ibfk_1`
    FOREIGN KEY (`th_sort_type_id` )
    REFERENCES `th_sort_type` (`th_sort_type_id` ),
  CONSTRAINT `th_sort_type_direction_ibfk_2`
    FOREIGN KEY (`th_sort_direction_asc_id` )
    REFERENCES `th_sort_direction` (`th_sort_direction_id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `th_sort_type_direction_ibfk_3`
    FOREIGN KEY (`th_sort_direction_desc_id` )
    REFERENCES `th_sort_direction` (`th_sort_direction_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_sequence` ;

CREATE  TABLE IF NOT EXISTS `th_sequence` (
  `th_sequence_id` INT NOT NULL AUTO_INCREMENT ,
  `th_sort_type_direction_id` INT NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  `th_part_of_speech_id` INT NULL ,
  PRIMARY KEY (`th_sequence_id`) ,
  INDEX `th_sort_type_direction_id` (`th_sort_type_direction_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  INDEX `fk_th_sequence_th_part_of_speech1_idx` (`th_part_of_speech_id` ASC) ,
  CONSTRAINT `th_sequence_ibfk_1`
    FOREIGN KEY (`th_sort_type_direction_id` )
    REFERENCES `th_sort_type_direction` (`th_sort_type_direction_id` ),
  CONSTRAINT `th_sequence_ibfk_2`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ),
  CONSTRAINT `fk_th_sequence_th_part_of_speech1`
    FOREIGN KEY (`th_part_of_speech_id` )
    REFERENCES `th_part_of_speech` (`th_part_of_speech_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_entry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_entry` ;

CREATE  TABLE IF NOT EXISTS `th_entry` (
  `th_entry_id` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(200) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `th_sequence_default_id` INT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_entry_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  INDEX `th_sequence_default_id` (`th_sequence_default_id` ASC) ,
  CONSTRAINT `th_entry_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ),
  CONSTRAINT `th_entry_ibfk_2`
    FOREIGN KEY (`th_sequence_default_id` )
    REFERENCES `th_sequence` (`th_sequence_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_entry_label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_entry_label` ;

CREATE  TABLE IF NOT EXISTS `th_entry_label` (
  `th_entry_label_id` INT NOT NULL AUTO_INCREMENT ,
  `th_entry_id` INT NOT NULL ,
  `name` VARCHAR(50) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  `label_datetime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`th_entry_label_id`) ,
  INDEX `th_entry_id` (`th_entry_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_entry_label_ibfk_1`
    FOREIGN KEY (`th_entry_id` )
    REFERENCES `th_entry` (`th_entry_id` ),
  CONSTRAINT `th_entry_label_ibfk_2`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_entry_sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_entry_sequence` ;

CREATE  TABLE IF NOT EXISTS `th_entry_sequence` (
  `th_entry_sequence_id` INT NOT NULL AUTO_INCREMENT ,
  `th_entry_id` INT NOT NULL ,
  `th_sequence_id` INT NOT NULL ,
  PRIMARY KEY (`th_entry_sequence_id`) ,
  UNIQUE INDEX `th_entry_sequence_id` (`th_entry_sequence_id` ASC) ,
  INDEX `th_entry_id` (`th_entry_id` ASC) ,
  INDEX `th_sequence_id` (`th_sequence_id` ASC) ,
  CONSTRAINT `th_entry_sequence_ibfk_1`
    FOREIGN KEY (`th_entry_id` )
    REFERENCES `th_entry` (`th_entry_id` ),
  CONSTRAINT `th_entry_sequence_ibfk_2`
    FOREIGN KEY (`th_sequence_id` )
    REFERENCES `th_sequence` (`th_sequence_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_example`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_example` ;

CREATE  TABLE IF NOT EXISTS `th_example` (
  `th_example_id` INT NOT NULL AUTO_INCREMENT ,
  `th_definition_id` INT NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  `example` VARCHAR(100) NOT NULL ,
  `ordinality` INT NOT NULL ,
  PRIMARY KEY (`th_example_id`) ,
  INDEX `th_definition_id` (`th_definition_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_example_ibfk_1`
    FOREIGN KEY (`th_definition_id` )
    REFERENCES `th_definition` (`th_definition_id` ),
  CONSTRAINT `th_example_ibfk_2`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_phrase`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_phrase` ;

CREATE  TABLE IF NOT EXISTS `th_phrase` (
  `th_phrase_id` INT NOT NULL AUTO_INCREMENT ,
  `lemma` VARCHAR(100) NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_phrase_id`) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_phrase_ibfk_1`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 1018
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_phrase_definition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_phrase_definition` ;

CREATE  TABLE IF NOT EXISTS `th_phrase_definition` (
  `th_phrase_definition_id` INT NOT NULL AUTO_INCREMENT ,
  `th_phrase_id` INT NOT NULL ,
  `th_definition_id` INT NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_phrase_definition_id`) ,
  INDEX `th_phrase_id` (`th_phrase_id` ASC) ,
  INDEX `th_definition_id` (`th_definition_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_phrase_definition_ibfk_1`
    FOREIGN KEY (`th_phrase_id` )
    REFERENCES `th_phrase` (`th_phrase_id` ),
  CONSTRAINT `th_phrase_definition_ibfk_2`
    FOREIGN KEY (`th_definition_id` )
    REFERENCES `th_definition` (`th_definition_id` ),
  CONSTRAINT `th_phrase_definition_ibfk_3`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_member` ;

CREATE  TABLE IF NOT EXISTS `th_member` (
  `th_member_id` INT NOT NULL AUTO_INCREMENT ,
  `th_sequence_id` INT NOT NULL ,
  `th_phrase_definition_id` INT NOT NULL ,
  `ordinality` INT NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_member_id`) ,
  INDEX `th_sequence_id` (`th_sequence_id` ASC) ,
  INDEX `th_phrase_definition_id` (`th_phrase_definition_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_member_ibfk_1`
    FOREIGN KEY (`th_sequence_id` )
    REFERENCES `th_sequence` (`th_sequence_id` ),
  CONSTRAINT `th_member_ibfk_2`
    FOREIGN KEY (`th_phrase_definition_id` )
    REFERENCES `th_phrase_definition` (`th_phrase_definition_id` ),
  CONSTRAINT `th_member_ibfk_3`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_metadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_metadata` ;

CREATE  TABLE IF NOT EXISTS `th_metadata` (
  `th_metadata_id` INT NOT NULL AUTO_INCREMENT ,
  `th_phrase_definition_id` INT NOT NULL ,
  `th_metadata_key_id` INT NOT NULL ,
  `value` VARCHAR(1000) NOT NULL ,
  PRIMARY KEY (`th_metadata_id`) ,
  INDEX `th_phrase_definition_id` (`th_phrase_definition_id` ASC) ,
  INDEX `th_metadata_key_id` (`th_metadata_key_id` ASC) ,
  CONSTRAINT `th_metadata_ibfk_3`
    FOREIGN KEY (`th_metadata_key_id` )
    REFERENCES `th_metadata_key` (`th_metadata_key_id` ),
  CONSTRAINT `th_metadata_ibfk_2`
    FOREIGN KEY (`th_phrase_definition_id` )
    REFERENCES `th_phrase_definition` (`th_phrase_definition_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_thesortus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_thesortus` ;

CREATE  TABLE IF NOT EXISTS `th_thesortus` (
  `th_thesortus_id` INT NOT NULL AUTO_INCREMENT ,
  `th_thesortus_parent_id` INT NULL ,
  `th_domain_id` INT NOT NULL ,
  `th_mod_info_id` INT NOT NULL ,
  PRIMARY KEY (`th_thesortus_id`) ,
  INDEX `th_thesortus_parent_id` (`th_thesortus_parent_id` ASC) ,
  INDEX `th_domain_id` (`th_domain_id` ASC) ,
  INDEX `th_mod_info_id` (`th_mod_info_id` ASC) ,
  CONSTRAINT `th_thesortus_ibfk_1`
    FOREIGN KEY (`th_thesortus_parent_id` )
    REFERENCES `th_thesortus` (`th_thesortus_id` ),
  CONSTRAINT `th_thesortus_ibfk_2`
    FOREIGN KEY (`th_domain_id` )
    REFERENCES `th_domain` (`th_domain_id` ),
  CONSTRAINT `th_thesortus_ibfk_3`
    FOREIGN KEY (`th_mod_info_id` )
    REFERENCES `th_mod_info` (`th_mod_info_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `th_thesortus_entry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `th_thesortus_entry` ;

CREATE  TABLE IF NOT EXISTS `th_thesortus_entry` (
  `th_thesortus_entry_id` INT NOT NULL AUTO_INCREMENT ,
  `th_thesortus_id` INT NOT NULL ,
  `th_entry_id` INT NOT NULL ,
  PRIMARY KEY (`th_thesortus_entry_id`) ,
  INDEX `th_thesortus_id` (`th_thesortus_id` ASC) ,
  INDEX `th_entry_id` (`th_entry_id` ASC) ,
  CONSTRAINT `th_thesortus_entry_ibfk_1`
    FOREIGN KEY (`th_thesortus_id` )
    REFERENCES `th_thesortus` (`th_thesortus_id` ),
  CONSTRAINT `th_thesortus_entry_ibfk_2`
    FOREIGN KEY (`th_entry_id` )
    REFERENCES `th_entry` (`th_entry_id` ))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- procedure ANALYZE_INVALID_FOREIGN_KEYS
-- -----------------------------------------------------
DROP procedure IF EXISTS `ANALYZE_INVALID_FOREIGN_KEYS`;

DELIMITER $$
CREATE PROCEDURE `ANALYZE_INVALID_FOREIGN_KEYS`(
        checked_database_name VARCHAR(200), 
        checked_table_name VARCHAR(200), 
        temporary_result_table ENUM('Y', 'N'))
    READS SQL DATA
BEGIN
        DECLARE TABLE_SCHEMA_VAR VARCHAR(200);
        DECLARE TABLE_NAME_VAR VARCHAR(200);
        DECLARE COLUMN_NAME_VAR VARCHAR(200); 
        DECLARE CONSTRAINT_NAME_VAR VARCHAR(200);
        DECLARE REFERENCED_TABLE_SCHEMA_VAR VARCHAR(200);
        DECLARE REFERENCED_TABLE_NAME_VAR VARCHAR(200);
        DECLARE REFERENCED_COLUMN_NAME_VAR VARCHAR(200);
        DECLARE KEYS_SQL_VAR VARCHAR(1024);

        DECLARE done INT DEFAULT 0;

        DECLARE foreign_key_cursor CURSOR FOR
            SELECT
                `TABLE_SCHEMA`,
                `TABLE_NAME`,
                `COLUMN_NAME`,
                `CONSTRAINT_NAME`,
                `REFERENCED_TABLE_SCHEMA`,
                `REFERENCED_TABLE_NAME`,
                `REFERENCED_COLUMN_NAME`
            FROM 
                information_schema.KEY_COLUMN_USAGE 
            WHERE 
                `CONSTRAINT_SCHEMA` LIKE checked_database_name AND
                `TABLE_NAME` LIKE checked_table_name AND
                `REFERENCED_TABLE_SCHEMA` IS NOT NULL;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        IF temporary_result_table = 'N' THEN
            DROP TEMPORARY TABLE IF EXISTS INVALID_FOREIGN_KEYS;
            DROP TABLE IF EXISTS INVALID_FOREIGN_KEYS;

            CREATE TABLE INVALID_FOREIGN_KEYS(
                `TABLE_SCHEMA` VARCHAR(200), 
                `TABLE_NAME` VARCHAR(200), 
                `COLUMN_NAME` VARCHAR(200), 
                `CONSTRAINT_NAME` VARCHAR(200),
                `REFERENCED_TABLE_SCHEMA` VARCHAR(200),
                `REFERENCED_TABLE_NAME` VARCHAR(200),
                `REFERENCED_COLUMN_NAME` VARCHAR(200),
                `INVALID_KEY_COUNT` INT,
                `INVALID_KEY_SQL` VARCHAR(1024),
                `INVALID_KEY_DELETE_SQL` VARCHAR(1024)
            );
        ELSEIF temporary_result_table = 'Y' THEN
            DROP TEMPORARY TABLE IF EXISTS INVALID_FOREIGN_KEYS;
            DROP TABLE IF EXISTS INVALID_FOREIGN_KEYS;

            CREATE TEMPORARY TABLE INVALID_FOREIGN_KEYS(
                `TABLE_SCHEMA` VARCHAR(200), 
                `TABLE_NAME` VARCHAR(200), 
                `COLUMN_NAME` VARCHAR(200), 
                `CONSTRAINT_NAME` VARCHAR(200),
                `REFERENCED_TABLE_SCHEMA` VARCHAR(200),
                `REFERENCED_TABLE_NAME` VARCHAR(200),
                `REFERENCED_COLUMN_NAME` VARCHAR(200),
                `INVALID_KEY_COUNT` INT,
                `INVALID_KEY_SQL` VARCHAR(1024),
                `INVALID_KEY_DELETE_SQL` VARCHAR(1024)
            );
        END IF;


        OPEN foreign_key_cursor;
        foreign_key_cursor_loop: LOOP
            FETCH foreign_key_cursor INTO 
            TABLE_SCHEMA_VAR, 
            TABLE_NAME_VAR, 
            COLUMN_NAME_VAR, 
            CONSTRAINT_NAME_VAR, 
            REFERENCED_TABLE_SCHEMA_VAR, 
            REFERENCED_TABLE_NAME_VAR, 
            REFERENCED_COLUMN_NAME_VAR;
            IF done THEN
                LEAVE foreign_key_cursor_loop;
            END IF;


            SET @from_part = CONCAT('FROM ', '`', TABLE_SCHEMA_VAR, '`.`', TABLE_NAME_VAR, '`', ' AS REFERRING ', 
                 'LEFT JOIN `', REFERENCED_TABLE_SCHEMA_VAR, '`.`', REFERENCED_TABLE_NAME_VAR, '`', ' AS REFERRED ', 
                 'ON (REFERRING', '.`', COLUMN_NAME_VAR, '`', ' = ', 'REFERRED', '.`', REFERENCED_COLUMN_NAME_VAR, '`', ') ', 
                 'WHERE REFERRING', '.`', COLUMN_NAME_VAR, '`', ' IS NOT NULL ',
                 'AND REFERRED', '.`', REFERENCED_COLUMN_NAME_VAR, '`', ' IS NULL');
            SET @full_query = CONCAT('SELECT COUNT(*) ', @from_part, ' INTO @invalid_key_count;');
            PREPARE stmt FROM @full_query;

            EXECUTE stmt;
            IF @invalid_key_count > 0 THEN
                INSERT INTO 
                    INVALID_FOREIGN_KEYS 
                SET 
                    `TABLE_SCHEMA` = TABLE_SCHEMA_VAR, 
                    `TABLE_NAME` = TABLE_NAME_VAR, 
                    `COLUMN_NAME` = COLUMN_NAME_VAR, 
                    `CONSTRAINT_NAME` = CONSTRAINT_NAME_VAR, 
                    `REFERENCED_TABLE_SCHEMA` = REFERENCED_TABLE_SCHEMA_VAR, 
                    `REFERENCED_TABLE_NAME` = REFERENCED_TABLE_NAME_VAR, 
                    `REFERENCED_COLUMN_NAME` = REFERENCED_COLUMN_NAME_VAR, 
                    `INVALID_KEY_COUNT` = @invalid_key_count,
                    `INVALID_KEY_SQL` = CONCAT('SELECT ', 
                        'REFERRING.', '`', COLUMN_NAME_VAR, '` ', 'AS "Invalid: ', COLUMN_NAME_VAR, '", ', 
                        'REFERRING.* ', 
                        @from_part, ';'),
                    `INVALID_KEY_DELETE_SQL` = CONCAT('DELETE ', '`', TABLE_SCHEMA_VAR, '`.`', TABLE_NAME_VAR, '` ',
                        'FROM ', '`', TABLE_SCHEMA_VAR, '`.`', TABLE_NAME_VAR, '`', ' ', 
                        'LEFT JOIN `', REFERENCED_TABLE_SCHEMA_VAR, '`.`', REFERENCED_TABLE_NAME_VAR, '`', ' ', 
                        'ON (', '`', TABLE_SCHEMA_VAR, '`.`', TABLE_NAME_VAR, '`', '.`', COLUMN_NAME_VAR, '`', ' = ', '`', REFERENCED_TABLE_SCHEMA_VAR, '`.`', REFERENCED_TABLE_NAME_VAR, '`', '.`', REFERENCED_COLUMN_NAME_VAR, '`', ') ', 
                        'WHERE ', '`', TABLE_SCHEMA_VAR, '`.`', TABLE_NAME_VAR, '`', '.`', COLUMN_NAME_VAR, '`', ' IS NOT NULL ',
                        'AND ', '`', REFERENCED_TABLE_SCHEMA_VAR, '`.`', REFERENCED_TABLE_NAME_VAR, '`', '.`', REFERENCED_COLUMN_NAME_VAR, '`', ' IS NULL', ';');
            END IF;
            DEALLOCATE PREPARE stmt; 

        END LOOP foreign_key_cursor_loop;
    END
$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
