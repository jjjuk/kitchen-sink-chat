DROP DATABASE IF EXISTS messenger;

CREATE DATABASE messenger;

USE messenger;

CREATE TABLE user (
  "id" INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "username" VARCHAR(34) NOT NULL,
  "password" VARCHAR(255) NOT NULL,
  "img" VARCHAR(255),
  "desc" TEXT(200)
);

CREATE TABLE chat (
  "id" INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "public" BOOLEAN NOT NULL DEFAULT FALSE,
  "owner_id" INT UNSIGNED,
  "title" VARCHAR(34),
  "img" VARCHAR(255),
  "desc" TEXT(200),
  --------------------------------
  FOREIGN KEY "chat_owner" ("owner_id") REFERENCES user ("id") ON DELETE CASCADE
);

CREATE TABLE subscriber (
  "chat_id" INT UNSIGNED NOT NULL,
  "user_id" INT UNSIGNED NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  --------------------------------
  UNIQUE KEY "subscriber_unique" ("chat_id", "user_id"),
  --------------------------------
  FOREIGN KEY "chat_subscriber" ("user_id") REFERENCES user ("id") ON DELETE CASCADE,
  FOREIGN KEY "user_subscription" ("chat_id") REFERENCES chat ("id") ON DELETE CASCADE
);

CREATE TABLE message (
  "user_id" INT UNSIGNED NOT NULL,
  "chat_id" INT UNSIGNED NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  "value" TEXT(500) NOT NULL,
  --------------------------------
  FOREIGN KEY "message_author" ("user_id") REFERENCES user ("id") ON DELETE CASCADE,
  FOREIGN KEY "message_chat" ("chat_id") REFERENCES chat ("id") ON DELETE CASCADE
);

CREATE INDEX chat_message_created_at ON message ("chat_id", "created_at") USING BTREE;

CREATE FULLTEXT INDEX message_text ON message ("value");

CREATE TABLE read (
  "author_id" INT UNSIGNED NOT NULL,
  "chat_id" INT UNSIGNED NOT NULL,
  "user_id" INT UNSIGNED NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  --------------------------------
  UNIQUE KEY "read_unique" ("chat_id", "seder_id", "user_id"),
  --------------------------------
  FOREIGN KEY "read_message_author" ("author_id") REFERENCES user ("id") ON DELETE CASCADE,
  FOREIGN KEY "read_chat_message" ("chat_id") REFERENCES chat ("id") ON DELETE CASCADE,
  FOREIGN KEY "read_by_user" ("user_id") REFERENCES user ("id") ON DELETE CASCADE
);