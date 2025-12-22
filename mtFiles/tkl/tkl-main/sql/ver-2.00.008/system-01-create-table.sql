CREATE TABLE IF NOT EXISTS "system_base"."forwarder_emqx" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "update_time" timestamptz(6),
  "protocol" varchar(32) COLLATE "pg_catalog"."default",
  "host" varchar(255) COLLATE "pg_catalog"."default",
  "port" int4,
  "config" jsonb,
  "options" jsonb,
  "params" jsonb,
  "type" varchar(32) COLLATE "pg_catalog"."default",
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default",
  "status" varchar(32) COLLATE "pg_catalog"."default",
  "err_msg" text COLLATE "pg_catalog"."default",
  "enable" bool,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "path" varchar(255) COLLATE "pg_catalog"."default",
  CONSTRAINT "forwarder_emqx_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "system_base"."forwarder_script" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "from_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "to_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "from_params" jsonb,
  "to_params" jsonb,
  "script" text COLLATE "pg_catalog"."default",
  "update_time" timestamptz(6),
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default",
  "should_run" bool,
  "enable" bool,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  CONSTRAINT "forwarder_script_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS  "system_base"."multi_device_rpc" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamptz(6),
  "rpc_id" varchar(32) COLLATE "pg_catalog"."default",
  "euis" text[] COLLATE "pg_catalog"."default",
  "cron_task" varchar(32) COLLATE "pg_catalog"."default",
  "enable" bool,
  "params" jsonb,
  "device_interval_ms" int8,
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default",
  CONSTRAINT "multi_device_rpc_pkey" PRIMARY KEY ("id")
)
;

UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.008', "params" = NULL WHERE "id" = '1';  