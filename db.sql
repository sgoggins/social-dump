CREATE ROLE "social-dump" LOGIN
  ENCRYPTED PASSWORD 'md55bebfe1fcb25d54e5af094cc749fa552'
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

CREATE DATABASE "social-dump"
  WITH ENCODING='UTF8'
       OWNER="social-dump"
       CONNECTION LIMIT=-1;

CREATE TABLE users
(
  user_id bigint NOT NULL,
  name character varying(256) NOT NULL,
  description character varying(256),
  CONSTRAINT users_primary PRIMARY KEY (user_id)
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE users OWNER TO "social-dump";

CREATE TABLE groups
(
  group_id bigint NOT NULL,
  owner_id bigint,
  "name" character varying(128) NOT NULL,
  description text,
  CONSTRAINT groups_primary PRIMARY KEY (group_id)
  CONSTRAINT groups_owner FOREIGN KEY (owner_id)
    REFERENCES users (user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE groups OWNER TO "social-dump";

CREATE TABLE pages
(
  page_id bigint NOT NULL,
  "name" character varying(256) NOT NULL,
  likes integer NOT NULL DEFAULT 0,
  description text,
  CONSTRAINT pages_primary PRIMARY KEY (page_id)
)
WITH (
  OIDS = FALSE
);
ALTER TABLE pages OWNER TO "social-dump";


CREATE TABLE posts
(
  feed_id bigint NOT NULL,
  feed_type character varying(8) NOT NULL,
  post_id bigint NOT NULL,
  poster_id bigint NOT NULL,
  "content" text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  CONSTRAINT posts_primary PRIMARY KEY (post_id),
  CONSTRAINT posts_poster FOREIGN KEY (poster_id)
    REFERENCES users (user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE posts OWNER TO "social-dump";

CREATE TABLE comments
(
  post_id bigint NOT NULL,
  comment_id bigint NOT NULL,
  commenter_id bigint NOT NULL,
  "content" character varying(8000) NOT NULL,
  created_at timestamp without time zone NOT NULL,
  CONSTRAINT comments_primary PRIMARY KEY (comment_id),
  CONSTRAINT comments_post FOREIGN KEY (post_id)
    REFERENCES posts (post_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT comments_commenter FOREIGN KEY (commenter_id)
    REFERENCES users (user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE comments OWNER TO "social-dump";

CREATE TABLE likes
(
  post_id bigint NOT NULL,
  comment_id bigint NOT NULL,
  user_id bigint NOT NULL,
  CONSTRAINT likes_primary PRIMARY KEY (post_id, comment_id, user_id),
  CONSTRAINT likes_comment FOREIGN KEY (comment_id)
    REFERENCES comments (comment_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT likes_post FOREIGN KEY (post_id)
    REFERENCES posts (post_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT likes_user FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS = FALSE
);
ALTER TABLE likes OWNER TO "social-dump";

CREATE TABLE targets
(
  target_id bigint NOT NULL,
  target_type character varying(10) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  scanned_at timestamp with time zone,
  CONSTRAINT targets_primary PRIMARY KEY (target_id)
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE targets OWNER TO "social-dump";
