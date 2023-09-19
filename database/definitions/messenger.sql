DROP DATABASE IF EXISTS messenger;

CREATE DATABASE messenger;

USE messenger;

CREATE TABLE `user` (
  `id` INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `token` VARCHAR(34) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `img` VARCHAR(255),
  `desc` TEXT(200),
  FULLTEXT username_search (`token`)
);

CREATE TABLE `chat` (
  `id` INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `public` BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE `public_chat` (
  `chat_id` INT UNSIGNED NOT NULL UNIQUE,
  `owner_id` INT UNSIGNED NOT NULL,
  `token` VARCHAR(34) UNIQUE,
  `img` VARCHAR(255),
  `desc` TEXT(200),
  FOREIGN KEY `public_chat_id` (`chat_id`) REFERENCES chat (`id`) ON DELETE CASCADE,
  FOREIGN KEY `chat_owner` (`owner_id`) REFERENCES user (`id`) ON DELETE CASCADE,
  FULLTEXT public_chat_search (`token`, `desc`)
);

CREATE TABLE `subscriber` (
  `chat_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `subscriber_unique` (`chat_id`, `user_id`),
  FOREIGN KEY `chat_subscriber` (`user_id`) REFERENCES user (`id`) ON DELETE CASCADE,
  FOREIGN KEY `user_subscription` (`chat_id`) REFERENCES chat (`id`) ON DELETE CASCADE
);

CREATE TABLE `message` (
  `user_id` INT UNSIGNED NOT NULL,
  `chat_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `value` TEXT(500),
  FOREIGN KEY `message_author` (`user_id`) REFERENCES user (`id`) ON DELETE CASCADE,
  FOREIGN KEY `message_chat` (`chat_id`) REFERENCES chat (`id`) ON DELETE CASCADE,
  UNIQUE chat_message_created_at (`chat_id`, `created_at`) USING BTREE,
  FULLTEXT message_search (`value`)
);

CREATE TABLE `read` (
  `user_id` INT UNSIGNED NOT NULL,
  `chat_id` INT UNSIGNED NOT NULL,
  `read_by_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `read_unique` (`chat_id`, `user_id`, `read_by_id`),
  FOREIGN KEY `read_message_author` (`user_id`) REFERENCES user (`id`) ON DELETE CASCADE,
  FOREIGN KEY `read_chat_message` (`chat_id`) REFERENCES chat (`id`) ON DELETE CASCADE,
  FOREIGN KEY `read_by_user` (`read_by_id`) REFERENCES user (`id`) ON DELETE CASCADE
);