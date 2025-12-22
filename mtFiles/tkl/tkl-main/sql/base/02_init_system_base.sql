CREATE TABLE IF NOT EXISTS system_base.api
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    parent_id character varying(32) COLLATE pg_catalog."default",
    name character varying(255) COLLATE pg_catalog."default",
    update_time timestamp(6) with time zone,
    api text COLLATE pg_catalog."default",
    remark text COLLATE pg_catalog."default",
    method character varying(255) COLLATE pg_catalog."default",
    query jsonb,
    body jsonb,
    CONSTRAINT api_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS system_base.app_download
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    type character varying(255) COLLATE pg_catalog."default",
    version character varying(32) COLLATE pg_catalog."default",
    name character varying(255) COLLATE pg_catalog."default",
    path character varying(255) COLLATE pg_catalog."default",
    remark character varying(255) COLLATE pg_catalog."default",
    file_name character varying(255) COLLATE pg_catalog."default",
    update_time timestamp(6) with time zone,
    CONSTRAINT app_download_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS system_base.cron_task
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp with time zone,
    cron character varying(255) COLLATE pg_catalog."default",
    type character varying(32) COLLATE pg_catalog."default",
    period integer,
    params jsonb,
    enabled boolean,
    remark character varying(255) COLLATE pg_catalog."default",
    tenant_code character varying(32) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT cron_task_pkey PRIMARY KEY (id),
    CONSTRAINT "cron_task(name, tenant_code)" UNIQUE (name, tenant_code)
);

CREATE TABLE IF NOT EXISTS system_base.device
(
    "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "eui" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamptz(6),
  "active_time" timestamptz(6),
  "device_type" varchar(32) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'NORMAL'::character varying,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "params" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "client_attrs" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "shared_attrs" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "server_attrs" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "other_attrs" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "mac_attrs" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "telemetry_data" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "location_id" varchar(32) COLLATE "pg_catalog"."default",
  "creator_id" varchar(32) COLLATE "pg_catalog"."default",
  "things_board" varchar(32) COLLATE "pg_catalog"."default",
  "home_assistant" varchar(32) COLLATE "pg_catalog"."default",
  "bacnet" varchar(32) COLLATE "pg_catalog"."default",
  "modbus_tcp" varchar(32) COLLATE "pg_catalog"."default",
  "condition" varchar(32) COLLATE "pg_catalog"."default",
  "real_time_storage" bool NOT NULL DEFAULT true,
  "thing_model" text[] COLLATE "pg_catalog"."default" DEFAULT '{}'::character varying[],
  "tags" text[] COLLATE "pg_catalog"."default" DEFAULT '{}'::text[],
  "tenant_roles" text[] COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::character varying[],
  "rpc" text[] COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::character varying[],
  "trigger" text[] COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::character varying[],
  "alarm" text[] COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::character varying[],
  "mcp" text[] COLLATE "pg_catalog"."default",
  "data_from" varchar(16) COLLATE "pg_catalog"."default",
  "heart_period" int4 DEFAULT 900,
  "system_params" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "cron_task" varchar(32) COLLATE "pg_catalog"."default",
  "third_party" varchar(32) COLLATE "pg_catalog"."default",
  "parent" varchar(32) COLLATE "pg_catalog"."default",
  CONSTRAINT "end_devices_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "eui,tenant_code" UNIQUE ("eui", "tenant_code")
);

CREATE TABLE IF NOT EXISTS system_base.device_config_template
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    things_board character varying(32) COLLATE pg_catalog."default",
    home_assistant character varying(32) COLLATE pg_catalog."default",
    bacnet character varying(32) COLLATE pg_catalog."default",
    modbus_tcp character varying(32) COLLATE pg_catalog."default",
    location_id character varying(32) COLLATE pg_catalog."default",
    tenant_code character varying(32) COLLATE pg_catalog."default",
    client_attrs jsonb DEFAULT '{}'::jsonb,
    shared_attrs jsonb DEFAULT '{}'::jsonb,
    server_attrs jsonb DEFAULT '{}'::jsonb,
    other_attrs jsonb DEFAULT '{}'::jsonb,
    mac_attrs jsonb DEFAULT '{}'::jsonb,
    telemetry_data jsonb,
    thing_model text[] COLLATE pg_catalog."default",
    trigger text[] COLLATE pg_catalog."default",
    alarm text[] COLLATE pg_catalog."default",
    rpc text[] COLLATE pg_catalog."default",
    condition character varying(32) COLLATE pg_catalog."default",
    real_time_storage boolean,
    heart_period bigint,
    tags text[] COLLATE pg_catalog."default",
    update_time timestamp with time zone,
    third_party character varying(32) COLLATE pg_catalog."default",
    cron_task character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT device_config_template_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS system_base.device_relation
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    to_eui character varying(32) COLLATE pg_catalog."default" NOT NULL,
    from_eui character varying(32) COLLATE pg_catalog."default" NOT NULL,
    params jsonb DEFAULT '{}'::jsonb,
    tenant_code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    notify_fields text[] COLLATE pg_catalog."default" DEFAULT '{}'::text[],
    CONSTRAINT virtual_device_relation_pkey PRIMARY KEY (id),
    CONSTRAINT "device_relation(from, to)" UNIQUE (to_eui, from_eui, tenant_code)
);

CREATE TABLE IF NOT EXISTS system_base.end_device_fuota_firmware
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    obin jsonb NOT NULL,
    creator_id character varying(32) COLLATE pg_catalog."default",
    status integer,
    remark text COLLATE pg_catalog."default",
    tenant_code character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT end_device_fuota_firmware_pkey PRIMARY KEY (id)
);

-- CREATE TABLE IF NOT EXISTS system_base.end_device_fuota_task
-- (
--     id character varying(32) COLLATE pg_catalog."default" NOT NULL,
--     update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
--     firmware_id character varying(32) COLLATE pg_catalog."default",
--     repeat_max_times integer,
--     check_delay_time integer,
--     dev_eui_list text[] COLLATE pg_catalog."default" NOT NULL,
--     ota_mode character varying(32) COLLATE pg_catalog."default",
--     appeui character varying(16) COLLATE pg_catalog."default",
--     interval_time integer,
--     tx_counts integer,
--     swtime integer,
--     device_interval_time integer,
--     creator_id character varying(32) COLLATE pg_catalog."default",
--     data_clear character varying(255) COLLATE pg_catalog."default",
--     tenant_code character varying(32) COLLATE pg_catalog."default",
--     check_timeout integer,
--     bconfirmed boolean,
--     status character varying(255) COLLATE pg_catalog."default",
--     name character varying(255) COLLATE pg_catalog."default",
--     remark character varying(255) COLLATE pg_catalog."default",
--     advanced boolean,
--     CONSTRAINT end_device_fuota_task_pkey PRIMARY KEY (id),
--     CONSTRAINT fk_task_firmware FOREIGN KEY (firmware_id)
--         REFERENCES system_base.end_device_fuota_firmware (id) MATCH SIMPLE
--         ON UPDATE RESTRICT
--         ON DELETE RESTRICT
-- );

-- CREATE TABLE IF NOT EXISTS system_base.end_device_fuota_subtask
-- (
--     id character varying(32) COLLATE pg_catalog."default" NOT NULL,
--     update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
--     dev_eui character varying(16) COLLATE pg_catalog."default" NOT NULL,
--     fuota_task_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
--     repeat_times integer NOT NULL DEFAULT 0,
--     creator_id character varying(32) COLLATE pg_catalog."default",
--     status character varying(32) COLLATE pg_catalog."default" NOT NULL,
--     tenant_code character varying(255) COLLATE pg_catalog."default" NOT NULL,
--     failed_message character varying(255) COLLATE pg_catalog."default",
--     task_param jsonb DEFAULT '{}'::jsonb,
--     before_info jsonb DEFAULT '{}'::jsonb,
--     after_info jsonb DEFAULT '{}'::jsonb,
--     CONSTRAINT end_device_fuota_subtask_pkey PRIMARY KEY (id),
--     CONSTRAINT fk_fuota_task FOREIGN KEY (fuota_task_id)
--         REFERENCES system_base.end_device_fuota_task (id) MATCH SIMPLE
--         ON UPDATE NO ACTION
--         ON DELETE CASCADE
-- );

CREATE TABLE IF NOT EXISTS system_base.gateway
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
    eui character varying(16) COLLATE pg_catalog."default" NOT NULL,
    name character varying(32) COLLATE pg_catalog."default",
    version character varying(16) COLLATE pg_catalog."default",
    ip character varying(32) COLLATE pg_catalog."default",
    total_online_time bigint DEFAULT 0,
    latitude real,
    longitude real,
    device_handle character varying(32) COLLATE pg_catalog."default",
    hardware_version character varying(16) COLLATE pg_catalog."default",
    firmware_version character varying(16) COLLATE pg_catalog."default",
    lora_standard character varying(32) COLLATE pg_catalog."default",
    lora_version character varying(32) COLLATE pg_catalog."default",
    rx_packets bigint,
    tx_packets bigint,
    ftime timestamp(6) with time zone,
    utime timestamp(6) with time zone,
    htime timestamp(6) with time zone,
    group_id bigint,
    operator_id bigint,
    active_time timestamp(6) with time zone,
    create_time timestamp(6) with time zone,
    status integer,
    progress real,
    error text COLLATE pg_catalog."default",
    location_id character varying(32) COLLATE pg_catalog."default",
    info jsonb,
    remark text COLLATE pg_catalog."default",
    tenant_code character varying(32) COLLATE pg_catalog."default" NOT NULL,
    heart_period integer DEFAULT 60,
    type character varying(255) COLLATE pg_catalog."default",
    pin_code character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT gateway_pkey PRIMARY KEY (id),
    CONSTRAINT "gateway(eui, tenant_code)" UNIQUE (eui, tenant_code)
);

CREATE TABLE IF NOT EXISTS system_base.gw_firmware
(
    id bigint NOT NULL,
    update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
    url character varying(511) COLLATE pg_catalog."default" NOT NULL,
    name character varying(127) COLLATE pg_catalog."default" NOT NULL,
    version character varying(32) COLLATE pg_catalog."default" NOT NULL,
    signature character varying(255) COLLATE pg_catalog."default" NOT NULL,
    algorithm character varying(32) COLLATE pg_catalog."default" NOT NULL,
    creator_id bigint NOT NULL,
    eui character varying(16) COLLATE pg_catalog."default",
    status integer,
    remark character varying(511) COLLATE pg_catalog."default",
    tenant_code character varying(32) COLLATE pg_catalog."default" NOT NULL
);

CREATE TABLE IF NOT EXISTS system_base.mqtt_acl
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp with time zone,
    ipaddress character varying(60) COLLATE pg_catalog."default" DEFAULT ''::character varying,
    username character varying(255) COLLATE pg_catalog."default" DEFAULT ''::character varying,
    clientid character varying(255) COLLATE pg_catalog."default" DEFAULT ''::character varying,
    action character varying COLLATE pg_catalog."default",
    permission character varying COLLATE pg_catalog."default",
    topic character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT mqtt_acl_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS system_base.mqtt_user
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp with time zone,
    tenant_code character varying(255) COLLATE pg_catalog."default",
    is_superuser boolean,
    username character varying(100) COLLATE pg_catalog."default",
    password_hash character varying(100) COLLATE pg_catalog."default",
    salt character varying(40) COLLATE pg_catalog."default",
    CONSTRAINT mqtt_user_pkey PRIMARY KEY (id),
    CONSTRAINT "mqtt_user(tenant_code)" UNIQUE (tenant_code),
    CONSTRAINT "mqtt_user(username)" UNIQUE (username)
);

CREATE TABLE "system_base"."rpc" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "template" jsonb,
  "rpc_script" text COLLATE "pg_catalog"."default",
  "params" jsonb,
  "tenant_code" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "translate" jsonb DEFAULT '{}'::jsonb,
  "update_time" timestamptz(6),
  "id_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "tags" text[] COLLATE "pg_catalog"."default",
  "inherit" bool,
  CONSTRAINT "rpc_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "rpc(id_name, tenant_code)" UNIQUE ("tenant_code", "id_name")
)
;

CREATE TABLE IF NOT EXISTS system_base.system_service
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    config jsonb,
    status character varying(32) COLLATE pg_catalog."default",
    err_msg text COLLATE pg_catalog."default",
    type character varying(32) COLLATE pg_catalog."default",
    enabled boolean,
    tenant_code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp with time zone,
    CONSTRAINT system_service_pkey PRIMARY KEY (id),
    CONSTRAINT "ss(name, tenant_code)" UNIQUE (name, tenant_code)
);

CREATE TABLE IF NOT EXISTS system_base.system_version
(
    id character varying COLLATE pg_catalog."default" NOT NULL,
    type character varying(255) COLLATE pg_catalog."default",
    version character varying(255) COLLATE pg_catalog."default",
    params jsonb,
    CONSTRAINT system_version_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS system_base.tenant
(
    id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    email character varying(255) COLLATE pg_catalog."default",
    remark text COLLATE pg_catalog."default",
    active_time timestamp(6) with time zone,
    update_time timestamp(6) with time zone,
    owner_id character varying(32) COLLATE pg_catalog."default",
    create_time timestamp with time zone,
    code character varying(32) COLLATE pg_catalog."default",
    license text COLLATE pg_catalog."default",
    CONSTRAINT tenant_pkey PRIMARY KEY (id),
    CONSTRAINT name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS system_base.tenant_user_relation
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    user_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    tenant_code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    extra jsonb,
    update_time timestamp with time zone,
    CONSTRAINT tenant_user_relation_pkey PRIMARY KEY (user_id, tenant_code)
);

CREATE TABLE "system_base"."thing_model" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "payload_parser" text COLLATE "pg_catalog"."default",
  "tenant_code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "outer_forward" text COLLATE "pg_catalog"."default",
  "inner_forward_enabled" bool,
  "outer_forward_enabled" bool,
  "update_time" timestamptz(6),
  "tags" text[] COLLATE "pg_catalog"."default",
  "params" jsonb,
  "system_params" jsonb,
  "telemetry_config" jsonb DEFAULT '{}'::jsonb,
  "translate" jsonb DEFAULT '{}'::jsonb,
  "bacnet_config" jsonb DEFAULT '{}'::jsonb,
  "payload_parser_type" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "ha_config" jsonb DEFAULT '{}'::jsonb,
  "id_name" varchar(32) COLLATE "pg_catalog"."default",
  "apply_to" varchar(32) COLLATE "pg_catalog"."default" DEFAULT 'ANY'::character varying,
  CONSTRAINT "things_model_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "tm(id_name, tenant_code)" UNIQUE ("tenant_code", "id_name")
)
;

CREATE TABLE "system_base"."trigger" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "trigger_script" text COLLATE "pg_catalog"."default",
  "params" jsonb,
  "tenant_code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(32) COLLATE "pg_catalog"."default",
  "update_time" timestamptz(6),
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "tags" text[] COLLATE "pg_catalog"."default",
  "inherit" bool,
  CONSTRAINT "trigger_script_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "trigger(name, tenant_code)" UNIQUE ("tenant_code", "name")
)
;

CREATE TABLE IF NOT EXISTS system_base."user"
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    account character varying(255) COLLATE pg_catalog."default",
    password character varying(255) COLLATE pg_catalog."default",
    wx_union_id character varying(255) COLLATE pg_catalog."default",
    google_sub character varying(255) COLLATE pg_catalog."default",
    apple_account character varying(255) COLLATE pg_catalog."default",
    email character varying(255) COLLATE pg_catalog."default",
    phone character varying(255) COLLATE pg_catalog."default",
    birthday timestamp(6) with time zone,
    sex character varying(16) COLLATE pg_catalog."default",
    type character varying(255) COLLATE pg_catalog."default" DEFAULT 'CUSTOMER'::character varying,
    params jsonb,
    last_login_tenant character varying(255) COLLATE pg_catalog."default",
    create_time timestamp with time zone,
    update_time timestamp with time zone,
    active boolean,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT "user(account)" UNIQUE (account),
    CONSTRAINT "user(apple_account)" UNIQUE (apple_account),
    CONSTRAINT "user(email)" UNIQUE (email),
    CONSTRAINT "user(google_sub)" UNIQUE (google_sub),
    CONSTRAINT "user(phone)" UNIQUE (phone),
    CONSTRAINT "user(wx_union_id)" UNIQUE (wx_union_id)
);

CREATE TABLE IF NOT EXISTS system_base.user_invitation
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    from_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    to_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone,
    message text COLLATE pg_catalog."default",
    status character varying(32) COLLATE pg_catalog."default",
    tenant_code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    extra jsonb,
    role_ids text[] COLLATE pg_catalog."default",
    CONSTRAINT "user_invation(id)" UNIQUE (id)
);

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
);

CREATE TABLE IF NOT EXISTS "system_base"."auto_increment" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "val" varchar(15) COLLATE "pg_catalog"."default",
  "params" jsonb,
  CONSTRAINT "auto_increment_pkey" PRIMARY KEY ("id")
)
;

--SELECT public.create_hypertable('system_base.user_invitation', 'update_time');