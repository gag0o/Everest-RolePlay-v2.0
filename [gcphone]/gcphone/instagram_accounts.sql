CREATE TABLE `instagram_accounts` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
    `realUser` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    `avatar_url` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
    PRIMARY KEY (`id`)
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
AUTO_INCREMENT=340
;