ALTER TABLE IF EXISTS system_base.device_config_templete RENAME TO device_config_template;
ALTER TABLE system_base.device_config_template RENAME CONSTRAINT device_config_templete_pkey TO device_config_template_pkey;
ALTER TABLE IF EXISTS system_base.rpc RENAME templete TO template;

UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.002', "params" = NULL WHERE "id" = '1';