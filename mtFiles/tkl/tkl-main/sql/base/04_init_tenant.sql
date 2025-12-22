CREATE TABLE IF NOT EXISTS alarm
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    level character varying(255) COLLATE pg_catalog."default",
    alarm_script text COLLATE pg_catalog."default",
    sms jsonb,
    email jsonb,
    is_repeated boolean,
    repeat_interval bigint,
    CONSTRAINT alarm_pkey PRIMARY KEY (id),
    CONSTRAINT name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS alarm_history
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    device_type character varying(32) COLLATE pg_catalog."default" NOT NULL,
    device_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    create_time timestamp(6) with time zone,
    last_trigger_time timestamp(6) with time zone,
    alarm_type character varying(255) COLLATE pg_catalog."default" NOT NULL,
    level character varying(255) COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    status character varying(255) COLLATE pg_catalog."default",
    handler_id character varying(32) COLLATE pg_catalog."default",
    update_time timestamp(6) with time zone,
    end_time timestamp(6) with time zone,
    title character varying(255) COLLATE pg_catalog."default"
);

CREATE TABLE IF NOT EXISTS alarm_result
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    device_type character varying(32) COLLATE pg_catalog."default" NOT NULL,
    device_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    create_time timestamp(6) with time zone,
    last_trigger_time timestamp(6) with time zone,
    alarm_type character varying(255) COLLATE pg_catalog."default" NOT NULL,
    level character varying(255) COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    status character varying(255) COLLATE pg_catalog."default",
    end_time timestamp(6) with time zone,
    update_time timestamp(6) with time zone,
    title character varying(255) COLLATE pg_catalog."default",
    handle_id character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT last_alarm_pkey PRIMARY KEY (device_type, device_id, alarm_type)
);

CREATE TABLE IF NOT EXISTS api_role_relation
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    api_id character varying(32) COLLATE pg_catalog."default",
    role_id character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT api_role_relation_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS bacnet_object
(
    id character varying(19) COLLATE pg_catalog."default" NOT NULL,
    object_type character varying(255) COLLATE pg_catalog."default" NOT NULL,
    object_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    units character varying(255) COLLATE pg_catalog."default",
    eui character varying(32) COLLATE pg_catalog."default" NOT NULL,
    thing_model character varying(255) COLLATE pg_catalog."default" NOT NULL,
    field_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    object_id integer NOT NULL,
    update_time timestamp(6) with time zone,
    cov_increment real DEFAULT 1,
    default_value real DEFAULT 0.0,
    rpcs text[] COLLATE pg_catalog."default",
    CONSTRAINT bacnet_object_pkey PRIMARY KEY (id),
    CONSTRAINT bacnet_object_eui_thing_model_field_name_key UNIQUE (eui, thing_model, field_name),
    CONSTRAINT bacnet_object_object_id_object_type_key UNIQUE (object_id, object_type),
    CONSTRAINT bacnet_object_object_name_key UNIQUE (object_name)
);

CREATE TABLE IF NOT EXISTS cron_task
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    cron character varying(32) COLLATE pg_catalog."default" NOT NULL,
    period integer,
    extra jsonb,
    CONSTRAINT cron_task_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS dashboard
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    update_time timestamp with time zone,
    is_carousel boolean DEFAULT false,
    params jsonb DEFAULT '{}'::jsonb,
    remark character varying(32) COLLATE pg_catalog."default",
    type character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT easy_dashboard_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS end_device_data_record
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone NOT NULL,
    eui character varying(32) COLLATE pg_catalog."default" NOT NULL,
    thing_model_id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    content jsonb,
    extra jsonb DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS gateway_beats
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone NOT NULL DEFAULT now(),
    eui character varying(16) COLLATE pg_catalog."default" NOT NULL
);

CREATE TABLE IF NOT EXISTS location
(
    id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    parent_code character varying(255) COLLATE pg_catalog."default",
    name character varying(255) COLLATE pg_catalog."default",
    address1 text COLLATE pg_catalog."default",
    address2 text COLLATE pg_catalog."default",
    address3 text COLLATE pg_catalog."default",
    zip_code character varying(255) COLLATE pg_catalog."default",
    phone character varying(255) COLLATE pg_catalog."default",
    extra jsonb,
    latitude double precision,
    longitude double precision,
    update_time timestamp(6) with time zone,
    CONSTRAINT location_pkey PRIMARY KEY (id),
    CONSTRAINT "location(code)" UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS message_record
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    update_time timestamp(6) with time zone NOT NULL,
    gw_eui text[] COLLATE pg_catalog."default",
    dev_eui character varying(32) COLLATE pg_catalog."default",
    port integer,
    content jsonb,
    msg_type smallint,
    seq_num bigint,
    msg_from smallint,
    if character varying(32) COLLATE pg_catalog."default"
);


CREATE TABLE IF NOT EXISTS ns_data
(
    "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
    "update_time" timestamptz(6) NOT NULL,
    "gw_eui" varchar(32) COLLATE "pg_catalog"."default",
    "token" int4,
    "type" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
    "content" jsonb,
    "ftype_code" int4,
    "fport" int4,
    "dev_addr" varchar(255) COLLATE "pg_catalog"."default",
    "dev_eui" varchar(255) COLLATE "pg_catalog"."default",
    "parsed_content" jsonb
);

CREATE TABLE IF NOT EXISTS role
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    remark character varying(255) COLLATE pg_catalog."default",
    is_admin boolean,
    route_ids text[] COLLATE pg_catalog."default",
    params jsonb,
    update_time timestamp with time zone,
    CONSTRAINT role_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS user_role_relation
(
    id character varying(32) COLLATE pg_catalog."default" NOT NULL,
    role_id character varying COLLATE pg_catalog."default" DEFAULT '[]'::jsonb,
    user_id character varying(32) COLLATE pg_catalog."default",
    CONSTRAINT user_role_relation_pkey PRIMARY KEY (id),
    CONSTRAINT "urr(user_id, role_id)" UNIQUE (role_id, user_id)
);

SELECT public.create_hypertable('alarm_history', 'update_time');
SELECT public.add_retention_policy('alarm_history', INTERVAL '1 months');
SELECT public.create_hypertable('end_device_data_record', 'update_time');
SELECT public.add_retention_policy('end_device_data_record', INTERVAL '1 year');
SELECT public.create_hypertable('gateway_beats', 'update_time');
SELECT public.add_retention_policy('gateway_beats', INTERVAL '1 months');
SELECT public.create_hypertable('message_record', 'update_time',  chunk_time_interval => INTERVAL '1 day');
SELECT public.add_retention_policy('message_record', INTERVAL '7 days');

SELECT public.create_hypertable('ns_data', 'update_time', chunk_time_interval => INTERVAL '1 day');
SELECT public.add_retention_policy('ns_data', INTERVAL '1 day');