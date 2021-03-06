CREATE TABLE alias (address VARCHAR(255) NOT NULL, domain VARCHAR(255) DEFAULT NULL, active TINYINT(1) NOT NULL, created_at DATETIME NOT NULL, modified_at DATETIME NOT NULL, INDEX IDX_E16C6B94A7A91E0B (domain), PRIMARY KEY(address)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE alias_destination (alias VARCHAR(255) NOT NULL, destination VARCHAR(255) NOT NULL, created_at DATETIME NOT NULL, modified_at DATETIME NOT NULL, INDEX IDX_9AC1551DE16C6B94 (alias), PRIMARY KEY(alias, destination)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE domain (name VARCHAR(255) NOT NULL, active TINYINT(1) DEFAULT '1' NOT NULL, backup_mx TINYINT(1) DEFAULT '0' NOT NULL, default_mailbox_quota BIGINT DEFAULT '1073741824' NOT NULL, created_at DATETIME NOT NULL, modified_at DATETIME NOT NULL, PRIMARY KEY(name)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE domain_users (domain_name VARCHAR(255) NOT NULL, user_id INT NOT NULL, INDEX IDX_C7F88D3FF3FF5361 (domain_name), INDEX IDX_C7F88D3FA76ED395 (user_id), PRIMARY KEY(domain_name, user_id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE mailbox (username VARCHAR(255) NOT NULL, domain VARCHAR(255) NOT NULL, local_part VARCHAR(255) NOT NULL, name VARCHAR(255) DEFAULT NULL, active TINYINT(1) DEFAULT '1' NOT NULL, quota_mbytes BIGINT DEFAULT '0' NOT NULL COMMENT 'Quota in MegaBytes', quota_messages BIGINT DEFAULT '0' NOT NULL, created_at DATETIME NOT NULL, modified_at DATETIME NOT NULL, password VARCHAR(255) NOT NULL, INDEX IDX_A69FE20BA7A91E0B (domain), PRIMARY KEY(username)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE mailbox_usage (username VARCHAR(255) NOT NULL, domain VARCHAR(255) DEFAULT NULL, bytes BIGINT DEFAULT NULL, messages BIGINT DEFAULT NULL, INDEX IDX_5AD606B0A7A91E0B (domain), PRIMARY KEY(username)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE user (id INT AUTO_INCREMENT NOT NULL, username VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, active TINYINT(1) NOT NULL, super_admin TINYINT(1) NOT NULL, created_at DATETIME NOT NULL, modified_at DATETIME NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
ALTER TABLE alias ADD CONSTRAINT FK_E16C6B94A7A91E0B FOREIGN KEY (domain) REFERENCES domain (name) ON DELETE CASCADE;
ALTER TABLE alias_destination ADD CONSTRAINT FK_9AC1551DE16C6B94 FOREIGN KEY (alias) REFERENCES alias (address) ON DELETE CASCADE;
ALTER TABLE domain_users ADD CONSTRAINT FK_C7F88D3FF3FF5361 FOREIGN KEY (domain_name) REFERENCES domain (name);
ALTER TABLE domain_users ADD CONSTRAINT FK_C7F88D3FA76ED395 FOREIGN KEY (user_id) REFERENCES user (id);
ALTER TABLE mailbox ADD CONSTRAINT FK_A69FE20BA7A91E0B FOREIGN KEY (domain) REFERENCES domain (name) ON DELETE CASCADE;
ALTER TABLE mailbox_usage ADD CONSTRAINT FK_5AD606B0F85E0677 FOREIGN KEY (username) REFERENCES mailbox (username) ON DELETE CASCADE;
ALTER TABLE mailbox_usage ADD CONSTRAINT FK_5AD606B0A7A91E0B FOREIGN KEY (domain) REFERENCES domain (name) ON DELETE CASCADE;

DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_mailbox_usage` BEFORE INSERT ON `mailbox_usage` FOR EACH ROW BEGIN
    SET NEW.domain = SUBSTRING_INDEX(NEW.username, '@', -1);
END */;;
DELIMITER ;
