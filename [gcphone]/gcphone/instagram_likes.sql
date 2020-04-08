CREATE TABLE `instagram_likes` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `authorId` INT(11) NULL DEFAULT NULL,
    `picId` INT(11) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `FK_instagram_likes_instagram_accounts` (`authorId`),
    INDEX `FK_instagram_likes_instagram_pics` (`picId`),
    CONSTRAINT `FK_instagram_likes_instagram_accounts` FOREIGN KEY (`authorId`) REFERENCES `instagram_accounts` (`id`),
    CONSTRAINT `FK_instagram_likes_instagram_pics` FOREIGN KEY (`picId`) REFERENCES `instagram_pics` (`id`) ON DELETE CASCADE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;
