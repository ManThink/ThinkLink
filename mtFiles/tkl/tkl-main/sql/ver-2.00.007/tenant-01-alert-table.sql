ALTER TABLE "ns_data" RENAME COLUMN "mtype" TO "ftype_code";

ALTER TABLE "ns_data" RENAME COLUMN "port" TO "fport";

ALTER TABLE "ns_data" RENAME COLUMN "devAddr" TO "dev_addr";

ALTER TABLE "ns_data" RENAME COLUMN "devEui" TO "dev_eui";

ALTER TABLE "ns_data" DROP COLUMN "fcnt", ADD COLUMN "parsed_content" jsonb, ALTER COLUMN "ftype_code" TYPE int4 USING "ftype_code"::int4;



 