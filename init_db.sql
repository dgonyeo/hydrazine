BEGIN; 

DROP TABLE IF EXISTS "bootflags" CASCADE;
DROP TABLE IF EXISTS "defaultbootflags" CASCADE;
DROP TABLE IF EXISTS "cpios" CASCADE;
DROP TABLE IF EXISTS "boots" CASCADE;
DROP TABLE IF EXISTS "boxen" CASCADE;
DROP TABLE IF EXISTS "images" CASCADE;

CREATE TABLE "images" (
    id           SERIAL      NOT NULL,
    name         VARCHAR(16) UNIQUE NOT NULL,
    kernel_path  TEXT        UNIQUE NOT NULL,
    created      TIMESTAMP   NOT NULL,
    UNIQUE (name),
    PRIMARY KEY (id)
);

CREATE TABLE "cpios" (
    id SERIAL NOT NULL,
    image_id  INTEGER NOT NULL,
    ordering  INTEGER NOT NULL,
    cpio_path TEXT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (image_id) REFERENCES "images" (id) ON DELETE CASCADE
);

CREATE TABLE "boxen" (
    id           SERIAL      NOT NULL,
    name         VARCHAR(16) NOT NULL,
    mac          VARCHAR(12) NOT NULL,
    boot_image   INTEGER,
    boot_until   TIMESTAMP,
    boot_forever BOOLEAN     NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name),
    UNIQUE (mac),
    FOREIGN KEY (boot_image) REFERENCES "images" (id) ON DELETE CASCADE
);

CREATE TABLE "bootflags" (
    box_id INTEGER      NOT NULL,
    key    VARCHAR(256) NOT NULL,
    value  TEXT,
    FOREIGN KEY (box_id) REFERENCES "boxen" (id) ON DELETE CASCADE
);

CREATE TABLE "defaultbootflags" (
    image_id INTEGER      NOT NULL,
    key      VARCHAR(256) NOT NULL,
    value    TEXT,
    FOREIGN KEY (image_id) REFERENCES "images" (id) ON DELETE CASCADE
);

CREATE TABLE "boots" (
    box_id     INTEGER     NOT NULL,
    image_name VARCHAR(16) NOT NULL,
    boot_time  TIMESTAMP   NOT NULL,
    FOREIGN KEY (box_id) REFERENCES "boxen" (id) ON DELETE CASCADE
);

COMMIT;
