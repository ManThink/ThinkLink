ALTER TABLE "system_base"."rpc" ADD COLUMN "tags" text[], ADD COLUMN "inherit" bool;
ALTER TABLE "system_base"."trigger" ADD COLUMN "tags" text[],  ADD COLUMN "inherit" bool;

CREATE TABLE IF NOT EXISTS "system_base"."auto_increment" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "val" varchar(15) COLLATE "pg_catalog"."default",
  "params" jsonb,
  CONSTRAINT "auto_increment_pkey" PRIMARY KEY ("id")
)
;

UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.009', "params" = NULL WHERE "id" = '1';  