CREATE TABLE IF NOT EXISTS "system_base"."eb_compile" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "script" text COLLATE "pg_catalog"."default" NOT NULL,
  "update_time" timestamptz(6),
  "params" jsonb DEFAULT '{}'::jsonb,
  "mcp_params" jsonb DEFAULT '{}'::jsonb,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  CONSTRAINT "eb_compile_pkey" PRIMARY KEY ("id")
);

UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.001', "params" = NULL WHERE "id" = '1';