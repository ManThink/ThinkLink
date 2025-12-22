ALTER TABLE "message_record" ALTER COLUMN "update_time" TYPE timestamptz(6);
 
UPDATE "system_base"."system_version" SET "type" = 'SYSTEM_VERSION', "version" = '2.00.003', "params" = NULL WHERE "id" = '1';