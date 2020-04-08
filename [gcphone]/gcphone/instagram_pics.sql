CREATE TABLE `instagram_pics` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `authorId` INT(11) NOT NULL,
    `realUser` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    `message` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
    `pic` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
    `time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    `likes` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `FK_instagram_pics_instagram_accounts` (`authorId`),
    CONSTRAINT `FK_instagram_pics_instagram_accounts` FOREIGN KEY (`authorId`) REFERENCES `instagram_accounts` (`id`)
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=98
;