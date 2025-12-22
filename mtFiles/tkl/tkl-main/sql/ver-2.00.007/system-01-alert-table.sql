ALTER TABLE "system_base"."device" DROP CONSTRAINT "ed(name, tenant_code)";

CREATE TABLE IF NOT EXISTS "system_base"."device_upgrade_main_task" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamptz(6),
  "firmware_id" varchar(32) COLLATE "pg_catalog"."default",
  "upgrade_params" jsonb DEFAULT '{}'::jsonb,
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default",
  "status" varchar(255) COLLATE "pg_catalog"."default",
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "params" jsonb DEFAULT '{}'::jsonb,
  "start_time" timestamptz(6),
  "end_time" timestamptz(6),
  "eui_list" text[] COLLATE "pg_catalog"."default",
  CONSTRAINT "device_upgrade_main_task_pkey" PRIMARY KEY ("id")
)
;

CREATE TABLE IF NOT EXISTS "system_base"."device_upgrade_sub_task" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "update_time" timestamptz(6),
  "dev_eui" varchar(32) COLLATE "pg_catalog"."default",
  "main_task_id" varchar(32) COLLATE "pg_catalog"."default",
  "curr_attempts" int2,
  "before" jsonb DEFAULT '{}'::jsonb,
  "after" jsonb DEFAULT '{}'::jsonb,
  "start_time" timestamptz(6),
  "end_time" timestamptz(6),
  "status" varchar(32) COLLATE "pg_catalog"."default",
  "err_msg" text COLLATE "pg_catalog"."default",
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default",
  "task_params" jsonb DEFAULT '{}'::jsonb,
  "params" jsonb DEFAULT '{}'::jsonb,
  "packet_info" jsonb DEFAULT '{}'::jsonb,
  CONSTRAINT "device_upgrade_sub_task_pkey" PRIMARY KEY ("id")
)
;

DROP TABLE IF EXISTS "system_base"."end_device_fuota_subtask";
DROP TABLE IF EXISTS "system_base"."end_device_fuota_task";

UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.007', "params" = NULL WHERE "id" = '1';  