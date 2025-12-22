-- BACnet、ha配置初始化
INSERT INTO "system_base"."system_service" ("id", "name", "config", "status", "err_msg", "type", "enabled", "tenant_code", "update_time") VALUES ('1', 'BACnet', '{"ip": "0.0.0.0", "port": 47808, "params": {"location": "CN", "modelName": "thinklink-edge", "utcOffset": -480, "vendorName": "manthink", "systemStatus": "operational", "protocolVersion": "1", "databaseRevision": 3, "firmwareRevision": "1.0.0", "protocolRevision": "19", "deviceAddressBinding": [], "daylightSavingsStatus": false, "applicationSoftwareVersion": "1.0", "protocolObjectTypesSupported": ["analogInput", "analogOutput", "analogValue", "binaryInput", "binaryOutput", "binaryValue"]}, "device_id": 1, "deivce_name": "ThinkLink", "vendor_identifier": 99, "segmentation_supported": "segmentedBoth", "max_adpu_length_accepted": 1024}', 'ERROR', NULL, NULL, NULL, 'mtfac', now());
INSERT INTO system_base.system_service (id, name, config, status, err_msg, type, enabled, tenant_code, update_time) VALUES ('2', 'HomeAssistant', '{"manufacturer": "ManThink", "discovery_prefix": "/v32/mtfac/ha"}', NULL, NULL, NULL, NULL, 'mtfac', now());

-- 租户mtfac默认MQTT用户初始化
INSERT INTO system_base.mqtt_user (id, update_time, tenant_code, is_superuser, username, password_hash, salt) VALUES ('1', now(), 'mtfac', NULL, 'mtfac', 'MTfac_0801', NULL);

-- 租户mtfac默认ACL权限初始化
INSERT INTO system_base.mqtt_acl (id, update_time, ipaddress, username, clientid, action, permission, topic) VALUES ('1', now(), '', 'mtfac', '', 'all', 'allow', '/v32/mtfac/as/#');
INSERT INTO system_base.mqtt_acl (id, update_time, ipaddress, username, clientid, action, permission, topic) VALUES ('2', now(), '', 'mtfac', '', 'all', 'allow', '/v32/mtfac/tkl/#');
INSERT INTO system_base.mqtt_acl (id, update_time, ipaddress, username, clientid, action, permission, topic) VALUES ('3', now(), '', 'mtfac', '', 'all', 'allow', '/v32/mtfac/ha/#');

-- 系统版本初始化
INSERT INTO system_base.system_version (id, type, version, params) VALUES ('1', 'SYSTEM_VERSION', '2.00.012', NULL);

-- 租户mtfac初始化
INSERT INTO system_base.tenant (id, name, email, remark, active_time, update_time, owner_id, create_time, code, license) VALUES ('1', '门思科技', NULL, NULL, NULL, now(), '1', now(), 'mtfac', NULL);

-- 用户admin初始化
INSERT INTO "system_base"."user" ("id", "name", "account", "password", "wx_union_id", "google_sub", "apple_account", "email", "phone", "birthday", "sex", "type", "params", "last_login_tenant", "create_time", "update_time", "active") VALUES ('1', 'admin', 'admin', '$2b$10$srIh9ULE4y0NKfVD1VxUVueQKWxqz24HW2OKFF6gQijkT2.lWfD7S', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SYSADMIN', NULL, 'mtfac', '2025-10-10 17:50:26.930713+08', '2025-10-10 17:54:58.652+08', 'f');
INSERT INTO "system_base"."user" ("id", "name", "account", "password", "wx_union_id", "google_sub", "apple_account", "email", "phone", "birthday", "sex", "type", "params", "last_login_tenant", "create_time", "update_time", "active") VALUES ('2', 'user', 'user', '$2b$10$ymAbmyG4DdaEGKgDWbaOFu8V5xcalkh7p0/LTEEn/igPmJ.1SBQN.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTOMER', NULL, 'mtfac', '2025-10-10 17:50:26.930713+08', '2025-10-10 17:54:58.652+08', 'f');

-- 租户mtfac的默认用户admin关联关系初始化
INSERT INTO system_base.tenant_user_relation (id, user_id, tenant_code, extra, update_time) VALUES ('1', '1', 'mtfac', NULL, now());
INSERT INTO system_base.tenant_user_relation (id, user_id, tenant_code, extra, update_time) VALUES ('2', '2', 'mtfac', NULL, now());




-- 基础的内置RPC 和 物模型 以及设备模板

-- 物模型
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('39409523395399685', 'MT-KS53', '
let payload = Buffer.from(msg?.userdata?.payload, "base64");
let preTelemetry = device.telemetry_data[thingModelId];
let port =msg?.userdata?.port
if(port!=11 || payload[0]!=0x82||payload[1]!=0x21||payload[2]!=0x05){
  return null
}
let telemetry_data = {};
telemetry_data.status ="normal"
if(payload[3]!=0) { telemetry_data.status ="fault" }
telemetry_data.temperatrue = Number(((payload.readUInt16LE(4)-1000)/10.00).toFixed(2))
let vbat=payload.readUInt8(6)
telemetry_data.vbat=Number(((vbat*1.6)/254 +2.0).toFixed(2))
telemetry_data.rssi=msg.gwrx[0].rssi
telemetry_data.snr=msg.gwrx[0].lsnr
return {
  sub_device: null,
  telemetry_data:telemetry_data ,
  server_attrs: null,
  shared_attrs: null,
}
  ', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.685+00', '{}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"snr": {"icon": "<svg t=\"1758435259426\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5839\" width=\"200\" height=\"200\"><path d=\"M298.666667 789.333333V234.666667h42.666666v554.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5840\"></path><path d=\"M300.906667 478.869333l-106.666667-213.333333 38.186667-19.072 106.666666 213.333333-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5841\"></path><path d=\"M339.093333 478.869333l106.666667-213.333333-38.186667-19.072-106.666666 213.333333 38.186666 19.072zM682.666667 789.333333V362.666667h42.666666v426.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5842\"></path><path d=\"M684.906667 559.936l-85.333334-170.666667 38.186667-19.072 85.333333 170.666667-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5843\"></path><path d=\"M723.093333 559.936l85.333334-170.666667-38.186667-19.072-85.333333 170.666667 38.186666 19.072zM533.333333 128v768h-42.666666V128h42.666666z\" fill=\"#1296db\" p-id=\"5844\"></path><path d=\"M128 149.333333a21.333333 21.333333 0 0 1 21.333333-21.333333h725.333334a21.333333 21.333333 0 0 1 21.333333 21.333333v725.333334a21.333333 21.333333 0 0 1-21.333333 21.333333H149.333333a21.333333 21.333333 0 0 1-21.333333-21.333333V149.333333z m42.666667 21.333334v682.666666h682.666666V170.666667H170.666667z\" fill=\"#1296db\" p-id=\"5845\"></path></svg>", "name": "SNR", "type": "number", "unit": "dB", "order": 4, "field_name": "snr"}, "rssi": {"icon": "<svg t=\"1758435292502\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6054\" width=\"200\" height=\"200\"><path d=\"M34.048 648.704h132.1472v207.616H34.048zM241.92 535.4496h132.1472v320.8704H241.92z\" fill=\"#1296db\" p-id=\"6055\"></path><path d=\"M449.7408 412.8768h132.1472v443.4432H449.7408zM657.6128 290.304h132.096v566.016h-132.096z\" fill=\"#1296db\" p-id=\"6056\"></path><path d=\"M865.4336 167.7312h132.096v688.5888h-132.096z\" fill=\"#1296db\" p-id=\"6057\"></path></svg>", "name": "RSSI", "type": "number", "unit": "dBm", "order": 3, "field_name": "rssi"}, "vbat": {"icon": "<svg t=\"1758355813974\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5140\" width=\"200\" height=\"200\"><path d=\"M229.437808 137.515153l565.137325 0 0 869.673988-565.137325 0 0-869.673988Z\" fill=\"#1296db\" p-id=\"5141\"></path><path d=\"M756.488638 1024H267.524303A54.949119 54.949119 0 0 1 212.626949 969.115588V175.614589A54.949119 54.949119 0 0 1 267.511362 120.730177h488.977276a54.949119 54.949119 0 0 1 54.884413 54.884412v793.500999a54.949119 54.949119 0 0 1-54.884413 54.884412z m-488.977276-869.661047a21.301519 21.301519 0 0 0-21.236813 21.275636v793.500999a21.301519 21.301519 0 0 0 21.275637 21.275636h488.938452a21.301519 21.301519 0 0 0 21.275637-21.275636V175.614589a21.301519 21.301519 0 0 0-21.275637-21.275636H267.524303z\" fill=\"#1296db\" p-id=\"5142\"></path><path d=\"M307.021409 256.912368l409.970123 0 0 630.8925-409.970123 0 0-630.8925Z\" fill=\"#1296db\" p-id=\"5143\"></path><path d=\"M678.905038 904.602785H345.094962a54.949119 54.949119 0 0 1-54.819705-54.87147V294.998863a54.949119 54.949119 0 0 1 54.884412-54.884413h333.745369a54.949119 54.949119 0 0 1 54.884412 54.884413V849.731315a54.949119 54.949119 0 0 1-54.884412 54.87147zM345.094962 273.710285a21.301519 21.301519 0 0 0-21.275636 21.275636V849.731315a21.301519 21.301519 0 0 0 21.275636 21.275636h333.810076a21.301519 21.301519 0 0 0 21.275636-21.275636V294.998863a21.301519 21.301519 0 0 0-21.275636-21.288578H345.094962z\" fill=\"#1296db\" p-id=\"5144\"></path><path d=\"M374.018957 16.797917l275.987969 0 0 120.717236-275.987969 0 0-120.717236Z\" fill=\"#1296db\" p-id=\"5145\"></path><path d=\"M611.920431 154.326012H412.092511a54.949119 54.949119 0 0 1-54.884413-54.884413V54.884412A54.949119 54.949119 0 0 1 412.092511 0h199.82792a54.949119 54.949119 0 0 1 54.884412 54.884412v44.557187a54.949119 54.949119 0 0 1-54.884412 54.884413zM412.092511 33.608776a21.301519 21.301519 0 0 0-21.275637 21.275636v44.557187a21.301519 21.301519 0 0 0 21.275637 21.275637h199.82792a21.301519 21.301519 0 0 0 21.301519-21.275637V54.884412a21.301519 21.301519 0 0 0-21.275637-21.275636H412.092511z\" fill=\"#1296db\" p-id=\"5146\"></path><path d=\"M503.601041 525.74375l-13.433157-136.751611 124.327882 157.936658-94.083866 63.516316 31.926396 141.60463-142.821121-181.528802 94.083866-44.777191z\" fill=\"#1296db\" p-id=\"5147\"></path><path d=\"M552.338296 768.860602a16.8238 16.8238 0 0 1-13.213154-6.470692L396.304021 580.912873a16.8238 16.8238 0 0 1 5.97892-25.559234l83.407224-39.704169-12.281374-125.000834a16.8238 16.8238 0 0 1 29.920481-12.035487l124.340824 157.884892a16.8238 16.8238 0 0 1-3.804767 24.316862l-84.546066 57.136213 29.402826 130.410333a16.8238 16.8238 0 0 1-16.383793 20.499153zM435.710538 576.668099l83.886055 106.624068-15.529662-69.145818a16.8238 16.8238 0 0 1 6.988348-17.613225l79.058919-53.383211-77.648308-98.587468 7.764831 79.563632a16.8238 16.8238 0 0 1-9.498977 16.8238z\" fill=\"#1296db\" p-id=\"5148\"></path></svg>", "name": "baterry voltage\t", "type": "number", "unit": "v", "order": 2, "field_name": "vbat"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 5, "field_name": "status"}, "temperatrue": {"icon": "<svg t=\"1758077725642\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6151\" width=\"200\" height=\"200\"><path d=\"M613.14042 610.221648V118.112778c0-56.482882-45.952284-102.438363-102.435166-102.438363-56.489276 0-102.444757 45.955481-102.444756 102.438363v492.10887c-67.051844 37.087272-109.637788 108.461328-109.637789 185.685717 0 116.939515 95.139833 212.076151 212.082545 212.076151 116.936318 0 212.072954-95.136636 212.072955-212.076151 0-77.230783-42.582748-148.601642-109.637789-185.685717zM510.705254 963.226874c-92.262621 0-167.325903-75.060086-167.325903-167.319509 0-64.75327 37.963223-124.298786 96.719104-151.699441a22.378321 22.378321 0 0 0 12.918685-20.281153v-214.250045h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-16.633487c0-31.805988 25.87893-57.681721 57.688114-57.68172 31.802791 0 57.678524 25.875733 57.678524 57.68172v505.813993a22.371927 22.371927 0 0 0 12.921882 20.281153c58.752683 27.394262 96.715906 86.939777 96.715907 151.699441 0 92.262621-75.060086 167.322706-167.316313 167.322706z\" fill=\"#009FE8\" p-id=\"6152\"></path><path d=\"M622.884581 777.151135a22.378321 22.378321 0 0 0-22.378321 22.378321c0 49.520027-40.287372 89.807399-89.8074 89.807399s-89.807399-40.287372-89.807399-89.807399c0-34.756729 20.380257-66.719366 51.917705-81.428316a22.378321 22.378321 0 0 0-18.912878-40.565503c-47.237439 22.029859-77.761469 69.913072-77.761469 121.990622 0 74.196922 60.363922 134.564041 134.564041 134.564041s134.564041-60.363922 134.564042-134.564041a22.378321 22.378321 0 0 0-22.378321-22.375124z\" fill=\"#009FE8\" p-id=\"6153\"></path></svg>", "name": "temperatrue", "type": "number", "unit": "℃", "order": 1, "field_name": "temperatrue"}}}', '{}', '{}', 'CUSTOMER', '{}', 'mt_ks53', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('38295099091718149', 'MT-Frequencies', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port || null;
    function parseFreqSharedAttrs(payload) {
        if (port==214) {
            if (payload.length < 5) { return null; }
            if (payload[0] != 0x22) { return null}
        }else {
            return null;
        }
        let system_info = {};
        system_info.content = payload.toString(''hex'');
        let size = payload.length - 4;
        let startAddress = payload[2];
        let index=4
        let regAddress=startAddress
        for (let i = 0; i < size; i++) {
            regAddress = startAddress + i;
            switch (regAddress) {
                // Version Information (0-7)
                case 0:
                    if (size < (4 + i)) { break; }
                    system_info.dn2Freq = payload.readUInt32LE(index + i);
                    break;
                case 4:
                    if (size < (1 + i)) { break; }
                    //system_info.fuota_copy_bytes = (payload[index + i] & 0x0F) * 4;
                    system_info.DLSetting = payload[index+i].toString(16);
                    break;
                case 5:
                    if (size < (2 + i)) { break; }
                    system_info.channelMap = payload.readUInt16LE(index + i).toString(16);
                    break;
                case 7:
                    if (size < (1 + i)) { break; }
                    system_info.power = payload.readInt8(index + i);
                    break;
                case 8:
                    if (size < (4 + i)) { break; }
                    system_info.Freq1 = payload.readUInt32LE(index+i);
                    break;
                case 12:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange1 = payload.readUInt8(index + i);
                    break;
                case 13:
                    if (size < (4 + i)) { break; }
                    system_info.Freq2 = payload.readUInt32LE(index+i);
                    break;
                case 17:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange2 = payload.readUInt8(index + i);
                    break;
                case 18:
                    if (size < (4 + i)) { break; }
                    system_info.Freq3 = payload.readUInt32LE(index+i);
                    break;
                case 22:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange3 = payload.readUInt8(index + i);
                    break;
                case 23:
                    if (size < (4 + i)) { break; }
                    system_info.Freq4 = payload.readUInt32LE(index+i);
                    break;
                case 27:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange4 = payload.readUInt8(index + i);
                    break;
                case 28:
                    if (size < (4 + i)) { break; }
                    system_info.Freq5 = payload.readUInt32LE(index+i);
                    break;
                case 32:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange5 = payload.readUInt8(index + i);
                    break;
                case 33:
                    if (size < (4 + i)) { break; }
                    system_info.Freq6 = payload.readUInt32LE(index+i);
                    break;
                case 37:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange6 = payload.readUInt8(index + i);
                    break;
                case 38:
                    if (size < (4 + i)) { break; }
                    system_info.Freq7 = payload.readUInt32LE(index+i);
                    break;
                case 42:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange7 = payload.readUInt8(index + i);
                    break;
                case 43:
                    if (size < (4 + i)) { break; }
                    system_info.Freq8 = payload.readUInt32LE(index+i);
                    break;
                case 47:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange8 = payload.readUInt8(index + i);
                    break;
                case 48:
                    if (size < (4 + i)) { break; }
                    system_info.Freq9 = payload.readUInt32LE(index+i);
                    break;
                case 52:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange9 = payload.readUInt8(index + i);
                    break;
                case 53:
                    if (size < (4 + i)) { break; }
                    system_info.Freq10 = payload.readUInt32LE(index+i);
                    break;
                case 57:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange10 = payload.readUInt8(index + i);
                    break;
                case 58:
                    if (size < (4 + i)) { break; }
                    system_info.Freq11 = payload.readUInt32LE(index+i);
                    break;
                case 62:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange11 = payload.readUInt8(index + i);
                    break;
                case 63:
                    if (size < (4 + i)) { break; }
                    system_info.Freq12 = payload.readUInt32LE(index+i);
                    break;
                case 67:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange12 = payload.readUInt8(index + i);
                    break;
                case 68:
                    if (size < (4 + i)) { break; }
                    system_info.Freq13 = payload.readUInt32LE(index+i);
                    break;
                case 72:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange13 = payload.readUInt8(index + i);
                    break;
                case 73:
                    if (size < (4 + i)) { break; }
                    system_info.Freq14 = payload.readUInt32LE(index+i);
                    break;
                case 77:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange14 = payload.readUInt8(index + i);
                    break;
                case 78:
                    if (size < (4 + i)) { break; }
                    system_info.Freq15 = payload.readUInt32LE(index+i);
                    break;
                case 82:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange15 = payload.readUInt8(index + i);
                    break;
                case 83:
                    if (size < (4 + i)) { break; }
                    system_info.Freq16 = payload.readUInt32LE(index+i);
                    break;
                case 87:
                    if (size < (1 + i)) { break; }
                    system_info.DRRange16 = payload.readUInt8(index + i);
                    break;
                default:
                    break;
            }
        }
        if (Object.keys(system_info).length < 1) { return null; }
        return system_info;
    }

    let sdata=null
    sdata=parseFreqSharedAttrs(payload)
    if (sdata===null) {sdata={}}
    sdata.class_mode=msg?.userdata?.class
    return {
        telemetry_data: null,
        server_attrs: null,
        shared_attrs: sdata
    }
  ', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,Frequencies}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{}', '{}', '{}', 'CUSTOMER', '{}', 'mt_freqencies', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('34669502880813061', 'M-Bus DTU', '  let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port || null;
    function tolittleEndianstr(payload,start){
        let strhex=Buffer.alloc(7)
        if (payload.length<7){
            return ""
        }
        for (let i=0; i<7; i++){
            strhex[i]=payload[start+6-i]
        }
        return strhex.toString(''hex'');
    }
    function parse213SharedAttrs(payload) {
        if (port!=213) { return null}
        if (payload.length < 28) { return null; }
        let head=payload.readBigUint64BE(0)
        if (head!= 0x8100000000000000) { return null}
        let system_info = {};
        system_info.content = payload.toString(''hex'');
        system_info.BzType = payload.readUInt16LE(12);
        system_info.BzVersion = payload[14]; //6+8
        if (Object.keys(system_info).length < 1) { return null; }
        return system_info;
    }
    function parse201SharedAttrs(payload) {
        if (port!=201) { return null}
        if (payload.length !=28) { return null; }
        if (payload[0]!= 0x81) { return null}
        if (payload[7]!=0x00) { return null} //fuota failed
        let system_info = {};
        system_info.FuotaVersion = payload[8] & 0x0F;
        let hw_type_low = (payload[8] >> 4) & 0x0F;
        let hw_type_high = payload[9];
        let hw_type=(hw_type_high<<4)|(hw_type_low&0x0F)
        if (hw_type==40) {
            system_info.HwType="OM422"
        }else if (hw_type==51) {
            system_info.HwType="OM822"
        }
        system_info.HwVersion = (payload[10] >> 4) & 0x0F;
        system_info.SwVersion = payload[11];
        system_info.BzType = payload.readUInt16LE(12);
        system_info.BzVersion = payload[14];
        system_info.FilterMask = payload[15] & 0x07;
        system_info.BaudRate = payload[16]*1200;
        system_info.DataBits = payload[17] & 0x0F;
        system_info.StopBits = (payload[17] >> 4) & 0x03;
        let check= (payload[17] >> 6) & 0x03;
        if (system_info.DataBits>8) {
            system_info.DataBits=8
        }
        if (check==1) {
            system_info.Checkbit="odd"
        }else if (check==2){
            system_info.Checkbit="even"
        }else {
            system_info.Checkbit="none"
        }
        system_info.KeepRx = (payload[18] & 0x01)>0 ? true : false;
        system_info.Battery = ((payload[18] >> 1) & 0x01)>0?true:false;
        system_info.Uart1Used = ((payload[18] >> 2) & 0x01)>0?true:false;
        system_info.TransparentBit = ((payload[18] >> 3) & 0x01)>0?true:false;
        system_info.SwUp = ((payload[18] >> 4) & 0x01)>0?true:false;
        system_info.JoinRst = ((payload[18] >> 5) & 0x01)>0?true:false;
        system_info.PowerCtrl = ((payload[18] >> 6) & 0x01)>0?true:false;
        system_info.Wait60s = ((payload[18] >> 7) & 0x01)?true:false;
        system_info.ConfirmDuty = payload[19];
        system_info.portPara = payload[20];
        system_info.portTransparent = payload[21];
        system_info.RstHours = payload.readUInt16LE(22);
        system_info.TimeOffset = payload.readUInt32LE(24);
        if (Object.keys(system_info).length < 1) { return null; }
        return system_info;
    }
    function parse214SharedAttrs(payload) {
        if (port==214) {
            if (payload.length < 5) { return null; }
            if (payload[0] != 0x2F) { return null}
        }else {
            return null;
        }
        let system_info = {};
        system_info.content = payload.toString(''hex'');
        let size = payload.length - 4;
        let startAddress = payload[2];
        let index=4
        let regAddress=startAddress
        for (let i = 0; i < size; i++) {
            regAddress = startAddress + i;
            switch (regAddress) {
                // Version Information (0-7)
                case 0:
                    if (size < (2 + i)) { break; }
                    system_info.FuotaVersion = payload[index + i] & 0x0F;
                    let hw_type_low = (payload[index + i] >> 4) & 0x0F;
                    let hw_type_high = payload[index + i+1];
                    let hw_type=(hw_type_high<<4)|(hw_type_low&0x0F)
                    if (hw_type==40) {
                        system_info.HwType="OM422"
                    }else if (hw_type==51) {
                        system_info.HwType="OM822"
                    }
                    break;
                case 2:
                    if (size < (1 + i)) { break; }
                    //system_info.fuota_copy_bytes = (payload[index + i] & 0x0F) * 4;
                    system_info.HwVersion = (payload[index + i] >> 4) & 0x0F;
                    break;
                case 3:
                    if (size < (1 + i)) { break; }
                    system_info.SwVersion = payload[index + i];
                    break;
                case 4:
                    if (size < (2 + i)) { break; }
                    system_info.BzType = payload.readUInt16LE(index + i);
                    break;
                case 6:
                    if (size < (1 + i)) { break; }
                    system_info.BzVersion = payload[index + i];
                    break;
                case 7:
                    if (size < (1 + i)) { break; }
                    system_info.FilterMask = payload[index + i] & 0x07;
                    system_info.OtaMask = (payload[index + i] >> 4) & 0x07;
                    break;
                // Runtime Parameters (8-23)
                case 8:
                    if (size < (1 + i)) { break; }
                    system_info.field_mode = (payload[index + i] & 0x01)?true:false;
                    system_info.relay_enable = ((payload[index + i] >> 1) & 0x01)?true:false;
                    break;
                case 11:
                    if (size < (1 + i)) { break; }
                    system_info.WakeupIn = (payload[index + i] & 0x01)?true:false;
                    system_info.WakeupOut = ((payload[index + i] >> 1) & 0x01)?true:false;
                    let backhaul= (payload[index + i] >> 4) & 0x07;
                    if (backhaul==0){
                        system_info.BackHaul="bh_lorawan"
                    }else if (backhaul==1){
                        system_info.BackHaul="bh_4g"
                    }
                    break;
                case 12:
                    if (size < (1 + i)) { break; }
                    system_info.BaudRate = payload[index + i]*1200;
                    break;
                case 13:
                    if (size < (1 + i)) { break; }
                    system_info.DataBits = payload[index + i] & 0x0F;
                    system_info.StopBits = (payload[index + i] >> 4) & 0x03;
                     let check= (payload[index + i] >> 6) & 0x03;
                     if (system_info.DataBits>8) {
                         system_info.DataBits=8
                     }
                     if (check==1) {
                         system_info.Checkbit="odd"
                     }else if (check==2){
                         system_info.Checkbit="even"
                     }else {
                         system_info.Checkbit="none"
                    }
                    break;
                case 14:
                    if (size < (1 + i)) { break; }
                    system_info.KeepRx = (payload[index + i] & 0x01)>0 ? true : false;
                    system_info.Battery = ((payload[index + i] >> 1) & 0x01)>0?true:false;
                    system_info.Uart1Used = ((payload[index + i] >> 2) & 0x01)>0?true:false;
                    system_info.TransparentBit = ((payload[index + i] >> 3) & 0x01)>0?true:false;
                    system_info.SwUp = ((payload[index + i] >> 4) & 0x01)>0?true:false;
                    system_info.JoinRst = ((payload[index + i] >> 5) & 0x01)>0?true:false;
                    system_info.PowerCtrl = ((payload[index + i] >> 6) & 0x01)>0?true:false;
                    system_info.Wait60s = ((payload[index + i] >> 7) & 0x01)?true:false;
                    break;
                case 15:
                    if (size < (1 + i)) { break; }
                    system_info.ConfirmDuty = payload[index + i];
                    break;
                case 16:
                    if (size < (1 + i)) { break; }
                    system_info.portPara = payload[index + i];
                    break;
                case 17:
                    if (size < (1 + i)) { break; }
                    system_info.portTransparent = payload[index + i];
                    break;
                case 18:
                    if (size < (2 + i)) { break; }
                    system_info.RstHours = payload.readUInt16LE(index + i);
                    break;
                case 20:
                    if (size < (4 + i)) { break; }
                    system_info.TimeOffset = payload.readUInt32LE(index + i);
                    break;

                // System Information (24-43)
                case 24:
                    if (size < (1 + i)) { break; }
                    system_info.battery_base = payload[index + i];
                    break;
                case 25:
                    if (size < (4 + i)) { break; }
                    system_info.utc_seconds = payload.readUInt32LE(index + i);
                    break;
                case 29:
                    if (size < (2 + i)) { break; }
                    let temp_raw = payload.readUInt16LE(index + i);
                    system_info.chip_temperature = ((temp_raw - 1000) / 10).toFixed(1);
                    break;
                case 31:
                    if (size < (1 + i)) { break; }
                    system_info.chip_voltage = (payload[index + i] / 254 * 1.6 + 2).toFixed(2);
                    break;
                case 32:
                    if (size < (2 + i)) { break; }
                    let timeout = payload.readUInt16LE(index + i);
                    let timeout_unit = (timeout >> 14) & 0x03;
                    let timeout_value = timeout & 0x3FFF;
                    if (timeout_unit==0) {
                        timeout_value=timeout_value*1000
                    }else if (timeout_unit==1) {
                        timeout_unit=timeout_value*60000
                    }else if (timeout_unit==2) {
                        timeout_value=timeout_value*3600000
                    }else  {
                        timeout_value=timeout_value
                    }
                    system_info.query_timeout = timeout_value;
                    break;
                case 34:
                    if (size < (1 + i)) { break; }
                    system_info.retries = payload[index + i];
                    break;
                case 35:
                    if (size < (1 + i)) { break; }
                    system_info.uart_calibration = payload[index + i] & 0x01;
                    system_info.calibration_method = (payload[index + i] >> 1) & 0x03;
                    break;
                case 36:
                    if (size < (1 + i)) { break; }
                    system_info.calibration_groups = payload[index + i];
                    break;
                case 37:
                    if (size < (1 + i)) { break; }
                    system_info.periodic_join_interval = payload[index + i];
                    break;
                case 38:
                    if (size < (2 + i)) { break; }
                    system_info.peripheral_power_delay = payload.readUInt16LE(index + i);
                    break;
                case 58:
                    if (size < (2 + i)) { break; }
                    system_info.period_heart = payload.readUInt16LE(index + i);
                    break;
                case 60:
                    if (size < (1 + i)) { break; }
                    system_info.sub_device_counts = payload[index + i];
                case 61 :
                    if (size < (2 + i)) { break; }
                    system_info.period_data = payload.readUInt16LE(index + i);
                    break;
                case 63 :
                    if (size < (2 + i)) { break; }
                    system_info.period_warn = payload.readUInt16LE(index + i);
                    break;
                case 120:
                    if (size < (1 + i)) { break; }
                    system_info.query_index = payload[index + i];
                case 121:
                    if (size < (1 + i)) { break; }
                    system_info.sub_addr_size = payload[index + i];
                case 122:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr1 =tolittleEndianstr(payload,index + i);
                case 129:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model1 = payload.slice(index + i,index + i+5).toString("hex");
                case 134:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr2 = tolittleEndianstr(payload,index + i);
                case 141:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model2 = payload.slice(index + i,index + i+5).toString("hex");
                case 146:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr3 = tolittleEndianstr(payload,index + i);
                case 153:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model3 = payload.slice(index + i,index + i+5).toString("hex");
                case 158:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr4 = tolittleEndianstr(payload,index + i);
                case 165:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model4 = payload.slice(index + i,index + i+5).toString("hex");
                case 170:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr5 = tolittleEndianstr(payload,index + i);
                case 177:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model5 = payload.slice(index + i,index + i+5).toString("hex");
                case 182:
                    if (size < (7 + i)) { break; }
                    system_info.sub_addr6 = tolittleEndianstr(payload,index + i);
                case 189:
                    if (size < (5 + i)) { break; }
                    system_info.sub_model6 = payload.slice(index + i,index + i+5).toString("hex");
                default:
                    break;
            }
        }
        if (Object.keys(system_info).length < 1) { return null; }
        return system_info;
    }
    function parseTelemetry(payload){
        if (port!=51){  return null}
        let telemetry_data = {};
        telemetry_data.payload =payload.toString(''hex'')
        telemetry_data.rssi=msg.gwrx[0].rssi
        telemetry_data.snr=msg.gwrx[0].lsnr
        return telemetry_data
    }
    let tdata=parseTelemetry(payload)
    let sdata
    if (port==214){
        sdata=parse214SharedAttrs(payload)
    }else if (port==213){
        sdata=parse213SharedAttrs(payload)
    }else if (port==201){
        sdata=parse201SharedAttrs(payload)
    }
    if (sdata===null) {sdata={}}
    sdata.class_mode=msg?.userdata?.class
    if (tdata?.period_data!=null){
        sdata.period_data = tdata.period_data
    }
    return {
        telemetry_data: tdata,
        server_attrs: null,
        shared_attrs: sdata
    }', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{}', '{}', '{}', 'CUSTOMER', '{}', 'mt_dtu_mbus', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('24570740992905221', 'MT-DTU-MULTIDEVICE', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port || null;
    function parseSharedAttrs(payload) {
        if (port != 214 || payload[0] != 0x2F) { return null; }
        let system_info = {};
        system_info.content = payload.toString(''hex'');
        if (payload.length < 6) { return null; }
        let regAddress = payload[2];
        if (regAddress!=120) { return null; }
        system_info.query_index=payload[4] //120
        system_info.sub_addr_size=payload[5] //121
        let size = payload.length - 6;
        for (let i = 0; i < 6; i++) {
            if (size<i*system_info.sub_addr_size) { break}
            const subBuf = payload.subarray(6+i*system_info.sub_addr_size, 6+i*system_info.sub_addr_size+system_info.sub_addr_size);
            switch (i) {
                case 0: system_info.sub_addr1 = subBuf.toString(''hex''); break;
                case 1: system_info.sub_addr2 = subBuf.toString(''hex''); break;
                case 2: system_info.sub_addr3 =subBuf.toString(''hex'');break;
                case 3: system_info.sub_addr4 = subBuf.toString(''hex''); break;
                case 4: system_info.sub_addr5 = subBuf.toString(''hex''); break;
                case 5: system_info.sub_addr6 =subBuf.toString(''hex'');break;
                default: break;
            }
        }
        if (Object.keys(system_info).length < 1) { return null; }
        return system_info;
    }
    let sdata=parseSharedAttrs(payload)
    return {
        telemetry_data: null,
        server_attrs: null,
        shared_attrs: sdata
    }', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{}', '{}', '{}', 'CUSTOMER', '{}', 'mt_dtu_multi_device', 'MASTER_DEVICE');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('24220289923551238', 'MT-DTU', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
let port = msg?.userdata?.port || null;

function parse213SharedAttrs(payload) {
    if (port != 213) {
        return null
    }
    if (payload.length < 28) {
        return null;
    }
    let head = payload.readBigUint64BE(0)
    if (head != 0x8100000000000000) {
        return null
    }
    let system_info = {};
    system_info.content = payload.toString(''hex'');
    system_info.BzType = payload.readUInt16LE(12);
    system_info.BzVersion = payload[14]; //6+8
    if (Object.keys(system_info).length < 1) {
        return null;
    }
    return system_info;
}

function parse209SharedAttrs(payload) {
    if (port != 209) {
        return null
    }
    if (payload.length < 20) {
        return null;
    }
    if (payload[0] != 0x81) {
        return null
    }
    if (payload[1] != 0x21) {
        return null
    }
    if (payload[2] != 0x03) {
        return null
    }
    let system_info = {};
    system_info.content = payload.toString(''hex'');
    let size = payload.length - 4;
    let startAddress = 0;
    let index = 3;
    let regAddress = startAddress
    for (let i = 0; i < size; i++) {
        regAddress = startAddress + i;
        switch (regAddress) {
            case 0:
                if (size < (2 + i)) {
                    break;
                }
                system_info.FuotaVersion = payload[index + i] & 0x0F;
                let hw_type_low = (payload[index + i] >> 4) & 0x0F;
                let hw_type_high = payload[index + i + 1];
                let hw_type = (hw_type_high << 4) | (hw_type_low & 0x0F)
                if (hw_type == 40) {
                    system_info.HwType = "OM422"
                } else if (hw_type == 51) {
                    system_info.HwType = "OM822"
                }
                break;
            case 2:
                if (size < (1 + i)) {
                    break;
                }
                //system_info.fuota_copy_bytes = (payload[index + i] & 0x0F) * 4;
                system_info.HwVersion = (payload[index + i] >> 4) & 0x0F;
                break;
            case 3:
                if (size < (1 + i)) {
                    break;
                }
                system_info.SwVersion = payload[index + i];
                break;
            case 4:
                if (size < (2 + i)) {
                    break;
                }
                system_info.BzType = payload.readUInt16LE(index + i);
                break;
            case 6:
                if (size < (1 + i)) {
                    break;
                }
                system_info.BzVersion = payload[index + i];
                startAddress = 22
                break;
            case 29:
                if (size < (2 + i)) {
                    break;
                }
                let temp_raw = payload.readUInt16LE(index + i);
                system_info.chip_temperature = ((temp_raw - 1000) / 10).toFixed(1);
                break;
            case 31:
                if (size < (1 + i)) {
                    break;
                }
                system_info.chip_voltage = (payload[index + i] / 254 * 1.6 + 2).toFixed(2);
                startAddress = 48
                break;
            case 58:
                if (size < (2 + i)) {
                    break;
                }
                system_info.period_heart = payload.readUInt16LE(index + i);
                break;
            case 60:
                if (size < (1 + i)) {
                    break;
                }
                system_info.sub_device_counts = payload[index + i];
            case 61 :
                if (size < (2 + i)) {
                    break;
                }
                system_info.period_data = payload.readUInt16LE(index + i);
                break;
            case 63 :
                if (size < (2 + i)) {
                    break;
                }
                system_info.period_warning = payload.readUInt16LE(index + i);
                break;
            default:
                break;
        }
    }
    if (Object.keys(system_info).length < 1) {
        return null;
    }
    return system_info;
}

function parse201SharedAttrs(payload) {
    if (port != 201) {
        return null
    }
    if (payload.length != 28) {
        return null;
    }
    if (payload[0] != 0x81) {
        return null
    }
    if (payload[7] != 0x00) {
        return null
    } //fuota failed
    let system_info = {};
    system_info.FuotaVersion = payload[8] & 0x0F;
    let hw_type_low = (payload[8] >> 4) & 0x0F;
    let hw_type_high = payload[9];
    let hw_type = (hw_type_high << 4) | (hw_type_low & 0x0F)
    if (hw_type == 40) {
        system_info.HwType = "OM422"
    } else if (hw_type == 51) {
        system_info.HwType = "OM822"
    }
    system_info.HwVersion = (payload[10] >> 4) & 0x0F;
    system_info.SwVersion = payload[11];
    system_info.BzType = payload.readUInt16LE(12);
    system_info.BzVersion = payload[14];
    system_info.FilterMask = payload[15] & 0x07;
    system_info.BaudRate = payload[16] * 1200;
    system_info.DataBits = payload[17] & 0x0F;
    system_info.StopBits = (payload[17] >> 4) & 0x03;
    let check = (payload[17] >> 6) & 0x03;
    if (system_info.DataBits > 8) {
        system_info.DataBits = 8
    }
    if (check == 1) {
        system_info.Checkbit = "odd"
    } else if (check == 2) {
        system_info.Checkbit = "even"
    } else {
        system_info.Checkbit = "none"
    }
    system_info.KeepRx = (payload[18] & 0x01) > 0 ? true : false;
    system_info.Battery = ((payload[18] >> 1) & 0x01) > 0 ? true : false;
    system_info.Uart1Used = ((payload[18] >> 2) & 0x01) > 0 ? true : false;
    system_info.TransparentBit = ((payload[18] >> 3) & 0x01) > 0 ? true : false;
    system_info.SwUp = ((payload[18] >> 4) & 0x01) > 0 ? true : false;
    system_info.JoinRst = ((payload[18] >> 5) & 0x01) > 0 ? true : false;
    system_info.PowerCtrl = ((payload[18] >> 6) & 0x01) > 0 ? true : false;
    system_info.Wait60s = ((payload[18] >> 7) & 0x01) ? true : false;
    system_info.ConfirmDuty = payload[19];
    system_info.portPara = payload[20];
    system_info.portTransparent = payload[21];
    system_info.RstHours = payload.readUInt16LE(22);
    system_info.TimeOffset = payload.readUInt32LE(24);
    if (Object.keys(system_info).length < 1) {
        return null;
    }
    return system_info;
}

function parse214SharedAttrs(payload) {
    if (port != 214) {  return null }
    if (payload.length < 5) {   return null;    }
    let system_info = {};
    system_info.content = payload.toString(''hex'');
    let size = payload.length - 4;
    let startAddress = payload[2];
    let index = 4
    let regAddress = startAddress
    if (payload[0] == 0x29) {
        for (let i = 0; i < size; i++) {
            regAddress = startAddress + i;
            switch (regAddress) {
                case 0:
                    if (size < (2 + i)) {
                        break;
                    }
                    //system_info.window1Enable=(payload[index+i]&0x01)==0x01?true:false
                    //system_info.window2Enable=(payload[index+i]&0x02)==0x02?true:false
                    //system_info.mulPingEnable=(payload[index+i]&0x04)==0x04?true:false
                    system_info.sleepWakeEnable=(payload[index+i]&0x08)==0x08?true:false
                    let standard=payload[index+i]>>4
                    if (standard==0){
                        system_info.standard="EU433/CN470/EU868"
                    }else if(standard==1){
                        system_info.standard="US902"
                    }else if (standard==2){
                        system_info.standard="KR923"
                    }else if(standard==3){
                        system_info.standard="AS923"
                    }else if(standard==4){
                        system_info.standard="AU915"
                    }
                    system_info.Tmode=(payload[index+i+1]&0x01)==0x01?true:false
                    //system_info.RssiEnable=(payload[index+i+1]&0x02)==0x02?true:false
                    //system_info.SNREnable=(payload[index+i+1]&0x04)==0x04?true:false
                    //system_info.RelayEnable=(payload[index+i+1]&0x08)==0x08?true:false
                    //system_info.DwellTime=(payload[index+i+1]&0x01)==0x01?true:false
                    //system_info.aliLowDR=(payload[index+i+1]&0x02)==0x02?true:false
                    system_info.SWRXON=(payload[index+i+1]&0x04)==0x04?true:false
                    system_info.SWTXF=(payload[index+i+1]&0x08)==0x08?true:false
                case 2:
                    if (size < (4 + i)) {
                        break;
                    }
                    let mulDevAddrBuf=Buffer.alloc(4)
                    mulDevAddrBuf[0] = payload[index+i+3];
                    mulDevAddrBuf[1] = payload[index+i+2];
                    mulDevAddrBuf[2] = payload[index+i+1];
                    mulDevAddrBuf[3] = payload[index+i];
                    system_info.mulDevAddr= mulDevAddrBuf.toString(''hex'')
                    break;
                case 6:
                    if (size < (16 + i)) {
                        break;
                    }
                    const mulNSkey = payload.subarray(index+i, index+i + 16);
                    system_info.mulNSkey=mulNSkey.toString(''hex'')
                    break;
                case 22:
                    if (size < (16 + i)) {
                        break;
                    }
                    const mulASkey = payload.subarray(index+i, index+i + 16);
                    system_info.mulASkey=mulASkey.toString(''hex'')
                    break;
                case 60:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.swSF=payload[index+i]
                    break;
                case 61:
                    if (size < (1 + i)) {
                        break;
                    }
                    if (payload[index+i]==9){
                        system_info.swBW="500kHz"
                    }else if(payload[index+i]==8){
                        system_info.swBW="250kHz"
                    }else if(payload[index+i]==7){
                        system_info.swBW="125kHz"
                    }else if(payload[index+i]==6){
                        system_info.swBW="62.5kHz"
                    }else {
                        system_info.swBW=payload[index+i].toString(10)
                    }
                    break
                case 62:
                    if (size < (4 + i)) {
                        break;
                    }
                    system_info.swFreq=payload.readUInt32LE(index+i)
                    break
                case 66:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.swPeriod=payload.readUInt8(index+i)
                    system_info.swPeriod=system_info.swPeriod*50
                case 67:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.upRepeat=payload[index+i]
                    break;
            }
        }
    }else if(payload[0]==0x21){
        for (let i = 0; i < size; i++) {
            regAddress = startAddress + i;
            switch (regAddress) {
                // Version Information (0-7)
                case 79:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.reTx=payload[index+i]
                case 80:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.globalDutyRate=payload[index+i]
                case 81:
                    if (size < (2 + i)) { break;}
                    system_info.dutyBand1=payload.readUInt16LE(index+i)
                case 83:
                    if (size < (2 + i)) { break;}
                    system_info.dutyBand2=payload.readUInt16LE(index+i)
                case 85:
                    if (size < (2 + i)) { break;}
                    system_info.dutyBand3=payload.readUInt16LE(index+i)
                case 87:
                    if (size < (2 + i)) { break;}
                    system_info.dutyBand4=payload.readUInt16LE(index+i)
                case 89:
                    if (size < (1 + i)) { break;}
                    system_info.devTimeReqDuty=payload.readUInt8(index+i)
                case 90:
                    if (size < (1 + i)) { break;}
                   if( payload[index+i]&0x01==0x01){
                       system_info.swPublic=true
                   }else {
                       system_info.swPublic=false
                   }
            }
        }
    } else if (payload[0] == 0x2F) {
        for (let i = 0; i < size; i++) {
            regAddress = startAddress + i;
            switch (regAddress) {
                // Version Information (0-7)
                case 0:
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.FuotaVersion = payload[index + i] & 0x0F;
                    let hw_type_low = (payload[index + i] >> 4) & 0x0F;
                    let hw_type_high = payload[index + i + 1];
                    let hw_type = (hw_type_high << 4) | (hw_type_low & 0x0F)
                    if (hw_type == 40) {
                        system_info.HwType = "OM422"
                    } else if (hw_type == 51) {
                        system_info.HwType = "OM822"
                    }
                    break;
                case 2:
                    if (size < (1 + i)) {
                        break;
                    }
                    //system_info.fuota_copy_bytes = (payload[index + i] & 0x0F) * 4;
                    system_info.HwVersion = (payload[index + i] >> 4) & 0x0F;
                    break;
                case 3:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.SwVersion = payload[index + i];
                    break;
                case 4:
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.BzType = payload.readUInt16LE(index + i);
                    break;
                case 6:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.BzVersion = payload[index + i];
                    break;
                case 7:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.FilterMask = payload[index + i] & 0x07;
                    system_info.OtaMask = (payload[index + i] >> 4) & 0x07;
                    //system_info.check_ok = ((payload[index + i] >> 7) & 0x01)?true:false;
                    break;

                // Runtime Parameters (8-23)
                case 8:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.field_mode = (payload[index + i] & 0x01) ? true : false;
                    system_info.relay_enable = ((payload[index + i] >> 1) & 0x01) ? true : false;
                    break;
                case 11:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.WakeupIn = (payload[index + i] & 0x01) ? true : false;
                    system_info.WakeupOut = ((payload[index + i] >> 1) & 0x01) ? true : false;
                    let backhaul = (payload[index + i] >> 4) & 0x07;
                    if (backhaul == 0) {
                        system_info.BackHaul = "bh_lorawan"
                    } else if (backhaul == 1) {
                        system_info.BackHaul = "bh_4g"
                    }
                    break;
                case 12:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.BaudRate = payload[index + i] * 1200;
                    break;
                case 13:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.DataBits = payload[index + i] & 0x0F;
                    system_info.StopBits = (payload[index + i] >> 4) & 0x03;
                    let check = (payload[index + i] >> 6) & 0x03;
                    if (system_info.DataBits > 8) {
                        system_info.DataBits = 8
                    }
                    if (check == 1) {
                        system_info.Checkbit = "odd"
                    } else if (check == 2) {
                        system_info.Checkbit = "even"
                    } else {
                        system_info.Checkbit = "none"
                    }
                    break;
                case 14:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.KeepRx = (payload[index + i] & 0x01) > 0 ? true : false;
                    system_info.Battery = ((payload[index + i] >> 1) & 0x01) > 0 ? true : false;
                    system_info.Uart1Used = ((payload[index + i] >> 2) & 0x01) > 0 ? true : false;
                    system_info.TransparentBit = ((payload[index + i] >> 3) & 0x01) > 0 ? true : false;
                    system_info.SwUp = ((payload[index + i] >> 4) & 0x01) > 0 ? true : false;
                    system_info.JoinRst = ((payload[index + i] >> 5) & 0x01) > 0 ? true : false;
                    system_info.PowerCtrl = ((payload[index + i] >> 6) & 0x01) > 0 ? true : false;
                    system_info.Wait60s = ((payload[index + i] >> 7) & 0x01) ? true : false;
                    break;
                case 15:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.ConfirmDuty = payload[index + i];
                    break;
                case 16:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.portPara = payload[index + i];
                    break;
                case 17:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.portTransparent = payload[index + i];
                    break;
                case 18:
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.RstHours = payload.readUInt16LE(index + i);
                    break;
                case 20:
                    if (size < (4 + i)) {
                        break;
                    }
                    system_info.TimeOffset = payload.readUInt32LE(index + i);
                    break;

                // System Information (24-43)
                case 24:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.battery_base = payload[index + i];
                    break;
                case 25:
                    if (size < (4 + i)) {
                        break;
                    }
                    system_info.utc_seconds = payload.readUInt32LE(index + i);
                    break;
                case 29:
                    if (size < (2 + i)) {
                        break;
                    }
                    let temp_raw = payload.readUInt16LE(index + i);
                    system_info.chip_temperature = ((temp_raw - 1000) / 10).toFixed(1);
                    break;
                case 31:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.chip_voltage = (payload[index + i] / 254 * 1.6 + 2).toFixed(2);
                    break;
                case 32:
                    if (size < (2 + i)) {
                        break;
                    }
                    let timeout = payload.readUInt16LE(index + i);
                    let timeout_unit = (timeout >> 14) & 0x03;
                    let timeout_value = timeout & 0x3FFF;
                    if (timeout_unit == 0) {
                        timeout_value = timeout_value * 1000
                    } else if (timeout_unit == 1) {
                        timeout_unit = timeout_value * 60000
                    } else if (timeout_unit == 2) {
                        timeout_value = timeout_value * 3600000
                    } else {
                        timeout_value = timeout_value
                    }
                    system_info.query_timeout = timeout_value;
                    break;
                case 34:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.retries = payload[index + i];
                    break;
                case 35:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.uart_calibration = payload[index + i] & 0x01;
                    system_info.calibration_method = (payload[index + i] >> 1) & 0x03;
                    break;
                case 36:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.calibration_groups = payload[index + i];
                    break;
                case 37:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.periodic_join_interval = payload[index + i];
                    break;
                case 38:
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.peripheral_power_delay = payload.readUInt16LE(index + i);
                    break;
                case 58:
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.period_heart = payload.readUInt16LE(index + i);
                    break;
                case 60:
                    if (size < (1 + i)) {
                        break;
                    }
                    system_info.sub_device_counts = payload[index + i];
                case 61 :
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.period_data = payload.readUInt16LE(index + i);
                    break;
                case 63 :
                    if (size < (2 + i)) {
                        break;
                    }
                    system_info.period_warning = payload.readUInt16LE(index + i);
                    break;
                default:
                    break;
            }
        }
    }
    if (Object.keys(system_info).length < 1) {
        return null;
    }
    return system_info;
}

function parseTelemetry(payload) {
    if (port != 51) {
        return null
    }
    let telemetry_data = {};
    telemetry_data.payload = payload.toString(''hex'')
    telemetry_data.rssi = msg.gwrx[0].rssi
    telemetry_data.snr = msg.gwrx[0].lsnr
    return telemetry_data
}

let tdata = parseTelemetry(payload)
let sdata = null
if (port == 214) {
    sdata = parse214SharedAttrs(payload)
} else if (port == 213) {
    sdata = parse213SharedAttrs(payload)
} else if (port == 201) {
    sdata = parse201SharedAttrs(payload)
} else if (port == 209) {
    sdata = parse209SharedAttrs(payload)
}
if (sdata === null) {
    sdata = {}
}
sdata.class_mode = msg?.userdata?.class
if (tdata?.period_data != null) {
    sdata.period_data = tdata.period_data
}
return {
    telemetry_data: tdata,
    server_attrs: null,
    shared_attrs: sdata
}', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,DTU}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"snr": {"icon": "<svg t=\"1758435259426\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5839\" width=\"200\" height=\"200\"><path d=\"M298.666667 789.333333V234.666667h42.666666v554.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5840\"></path><path d=\"M300.906667 478.869333l-106.666667-213.333333 38.186667-19.072 106.666666 213.333333-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5841\"></path><path d=\"M339.093333 478.869333l106.666667-213.333333-38.186667-19.072-106.666666 213.333333 38.186666 19.072zM682.666667 789.333333V362.666667h42.666666v426.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5842\"></path><path d=\"M684.906667 559.936l-85.333334-170.666667 38.186667-19.072 85.333333 170.666667-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5843\"></path><path d=\"M723.093333 559.936l85.333334-170.666667-38.186667-19.072-85.333333 170.666667 38.186666 19.072zM533.333333 128v768h-42.666666V128h42.666666z\" fill=\"#1296db\" p-id=\"5844\"></path><path d=\"M128 149.333333a21.333333 21.333333 0 0 1 21.333333-21.333333h725.333334a21.333333 21.333333 0 0 1 21.333333 21.333333v725.333334a21.333333 21.333333 0 0 1-21.333333 21.333333H149.333333a21.333333 21.333333 0 0 1-21.333333-21.333333V149.333333z m42.666667 21.333334v682.666666h682.666666V170.666667H170.666667z\" fill=\"#1296db\" p-id=\"5845\"></path></svg>", "name": "SNR", "type": "number", "unit": "dB", "order": 3, "field_name": "snr"}, "rssi": {"icon": "<svg t=\"1758435292502\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6054\" width=\"200\" height=\"200\"><path d=\"M34.048 648.704h132.1472v207.616H34.048zM241.92 535.4496h132.1472v320.8704H241.92z\" fill=\"#1296db\" p-id=\"6055\"></path><path d=\"M449.7408 412.8768h132.1472v443.4432H449.7408zM657.6128 290.304h132.096v566.016h-132.096z\" fill=\"#1296db\" p-id=\"6056\"></path><path d=\"M865.4336 167.7312h132.096v688.5888h-132.096z\" fill=\"#1296db\" p-id=\"6057\"></path></svg>", "name": "RSSI", "type": "number", "unit": "dBm", "order": 2, "field_name": "rssi"}, "payload": {"icon": "<svg t=\"1758942392194\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5749\" width=\"200\" height=\"200\"><path d=\"M896 0H128A128 128 0 0 0 0 128v768A128 128 0 0 0 128 1024h768A128 128 0 0 0 1024 896V128A128 128 0 0 0 896 0z m74.605714 896a74.605714 74.605714 0 0 1-74.605714 74.605714H128a74.605714 74.605714 0 0 1-74.605714-74.605714V128c0-41.252571 33.353143-74.605714 74.605714-74.605714h768c41.252571 0 74.605714 33.353143 74.605714 74.605714v768zM729.453714 250.002286H294.619429a26.697143 26.697143 0 1 0 0 53.394285h190.683428v443.245715a26.697143 26.697143 0 1 0 53.394286 0v-443.245715h190.683428a26.697143 26.697143 0 0 0 0-53.394285z\" fill=\"#1296db\" p-id=\"5750\"></path></svg>", "name": "payload", "type": "string", "unit": "", "order": 1, "field_name": "payload"}}}', '{}', '{"fields": {}}', 'CUSTOMER', '{"fields": {}}', 'mt_dtu', 'MASTER_DEVICE');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('24195523346960389', 'MT-KS51', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
    //let preTelemetry = device?.telemetry_data?.[thingModelId];
    let port=msg?.userdata?.port || null;
    function parseSharedAttrs(payload) {
        if (port!=214||payload[0]!=0x2F) { return null}
        let shared_attrs = {};
        if (payload.length<5) { return null}
        shared_attrs.content = payload.toString(''hex'');
        let size=payload.length-4
        let regAddress=payload[2]
        for (let i=0; i<size; i++) {
            regAddress=payload[2]+i
            switch (regAddress) {
                case  58:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_data = payload.readUInt16LE(4+i)
                    break;
                default: break
            }
        }
        if (Object.keys(shared_attrs).length == 0) {
            return null
        }
        return shared_attrs;
    }
    function parseTelemetry(payload){
        if (port!=11) { return null}
        if (payload[0]!=0x82||payload[1]!=0x21||payload[2]!=0x12){  return null }
        if (payload.length <7) {    return null }
        let telemetry_data = {};
        if (payload[3]>0) {
            telemetry_data.status="fault"
            return telemetry_data
        }
        telemetry_data.status="normal"
        telemetry_data.detected=0
        if (payload.readUint8(3)>0){    telemetry_data.detected=1   }
        telemetry_data.vbat=Number(((payload.readUInt8(4)*1.6/254)+2).toFixed(2))
        return telemetry_data
    }
    let tdata=parseTelemetry(payload)
    let sdata=parseSharedAttrs(payload)
    return {
        telemetry_data: tdata,
        server_attrs: null,
        shared_attrs: sdata
    }', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,"water leakage"}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"vbat": {"icon": "<svg t=\"1758355813974\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5140\" width=\"200\" height=\"200\"><path d=\"M229.437808 137.515153l565.137325 0 0 869.673988-565.137325 0 0-869.673988Z\" fill=\"#1296db\" p-id=\"5141\"></path><path d=\"M756.488638 1024H267.524303A54.949119 54.949119 0 0 1 212.626949 969.115588V175.614589A54.949119 54.949119 0 0 1 267.511362 120.730177h488.977276a54.949119 54.949119 0 0 1 54.884413 54.884412v793.500999a54.949119 54.949119 0 0 1-54.884413 54.884412z m-488.977276-869.661047a21.301519 21.301519 0 0 0-21.236813 21.275636v793.500999a21.301519 21.301519 0 0 0 21.275637 21.275636h488.938452a21.301519 21.301519 0 0 0 21.275637-21.275636V175.614589a21.301519 21.301519 0 0 0-21.275637-21.275636H267.524303z\" fill=\"#1296db\" p-id=\"5142\"></path><path d=\"M307.021409 256.912368l409.970123 0 0 630.8925-409.970123 0 0-630.8925Z\" fill=\"#1296db\" p-id=\"5143\"></path><path d=\"M678.905038 904.602785H345.094962a54.949119 54.949119 0 0 1-54.819705-54.87147V294.998863a54.949119 54.949119 0 0 1 54.884412-54.884413h333.745369a54.949119 54.949119 0 0 1 54.884412 54.884413V849.731315a54.949119 54.949119 0 0 1-54.884412 54.87147zM345.094962 273.710285a21.301519 21.301519 0 0 0-21.275636 21.275636V849.731315a21.301519 21.301519 0 0 0 21.275636 21.275636h333.810076a21.301519 21.301519 0 0 0 21.275636-21.275636V294.998863a21.301519 21.301519 0 0 0-21.275636-21.288578H345.094962z\" fill=\"#1296db\" p-id=\"5144\"></path><path d=\"M374.018957 16.797917l275.987969 0 0 120.717236-275.987969 0 0-120.717236Z\" fill=\"#1296db\" p-id=\"5145\"></path><path d=\"M611.920431 154.326012H412.092511a54.949119 54.949119 0 0 1-54.884413-54.884413V54.884412A54.949119 54.949119 0 0 1 412.092511 0h199.82792a54.949119 54.949119 0 0 1 54.884412 54.884412v44.557187a54.949119 54.949119 0 0 1-54.884412 54.884413zM412.092511 33.608776a21.301519 21.301519 0 0 0-21.275637 21.275636v44.557187a21.301519 21.301519 0 0 0 21.275637 21.275637h199.82792a21.301519 21.301519 0 0 0 21.301519-21.275637V54.884412a21.301519 21.301519 0 0 0-21.275637-21.275636H412.092511z\" fill=\"#1296db\" p-id=\"5146\"></path><path d=\"M503.601041 525.74375l-13.433157-136.751611 124.327882 157.936658-94.083866 63.516316 31.926396 141.60463-142.821121-181.528802 94.083866-44.777191z\" fill=\"#1296db\" p-id=\"5147\"></path><path d=\"M552.338296 768.860602a16.8238 16.8238 0 0 1-13.213154-6.470692L396.304021 580.912873a16.8238 16.8238 0 0 1 5.97892-25.559234l83.407224-39.704169-12.281374-125.000834a16.8238 16.8238 0 0 1 29.920481-12.035487l124.340824 157.884892a16.8238 16.8238 0 0 1-3.804767 24.316862l-84.546066 57.136213 29.402826 130.410333a16.8238 16.8238 0 0 1-16.383793 20.499153zM435.710538 576.668099l83.886055 106.624068-15.529662-69.145818a16.8238 16.8238 0 0 1 6.988348-17.613225l79.058919-53.383211-77.648308-98.587468 7.764831 79.563632a16.8238 16.8238 0 0 1-9.498977 16.8238z\" fill=\"#1296db\" p-id=\"5148\"></path></svg>", "name": "vbat", "type": "number", "unit": "v", "order": 3, "field_name": "vbat"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 1, "field_name": "status"}, "detected": {"icon": "<svg t=\"1758942674928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6810\" width=\"200\" height=\"200\"><path d=\"M229.376 891.8528A132.7104 132.7104 0 0 1 137.472 855.04a30.72 30.72 0 1 1 42.496-44.4416 71.3216 71.3216 0 0 0 98.816 0 132.8128 132.8128 0 0 1 183.808 0 71.3216 71.3216 0 0 0 98.816 0 132.8128 132.8128 0 0 1 183.808 0 71.3216 71.3216 0 0 0 98.816 0 30.72 30.72 0 0 1 42.496 44.4416 132.8128 132.8128 0 0 1-183.808 0 71.3216 71.3216 0 0 0-98.816 0 132.8128 132.8128 0 0 1-183.808 0 71.3216 71.3216 0 0 0-98.816 0 132.608 132.608 0 0 1-91.904 36.8128zM794.624 689.1008a132.608 132.608 0 0 1-91.904-36.9664 71.3216 71.3216 0 0 0-98.816 0 132.8128 132.8128 0 0 1-183.808 0 71.3216 71.3216 0 0 0-98.816 0 132.8128 132.8128 0 0 1-183.808 0 30.72 30.72 0 0 1 42.496-44.4416 71.3216 71.3216 0 0 0 98.816 0 132.8128 132.8128 0 0 1 183.808 0 71.3216 71.3216 0 0 0 98.816 0 132.8128 132.8128 0 0 1 183.808 0 71.3216 71.3216 0 0 0 98.816 0 30.72 30.72 0 0 1 42.496 44.4416 132.608 132.608 0 0 1-91.904 36.9664z\" fill=\"#1296db\" p-id=\"6811\"></path><path d=\"M566.9376 660.48a30.72 30.72 0 0 1-27.2384-44.9024L706.56 295.168l-174.4896-90.7776-228.7616 439.7056a30.72 30.72 0 1 1-54.4768-28.3648l242.944-466.944a30.72 30.72 0 0 1 41.4208-13.056l228.9152 119.0912a30.72 30.72 0 0 1 13.056 41.472l-180.9408 347.8016a30.72 30.72 0 0 1-27.2896 16.384z\" fill=\"#1296db\" p-id=\"6812\"></path></svg>", "name": "detected", "type": "number", "unit": "", "order": 2, "field_name": "detected"}}}', '{}', '{"fields": {"vbat": {"rpcs": [], "unit": "noUnits", "field_name": "vbat", "object_type": "analogValue", "cov_increment": 0, "default_value": 0, "object_name_suffix": "vbat"}, "detected": {"rpcs": [], "unit": "noUnits", "field_name": "detected", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "detected"}}}', 'CUSTOMER', '{"fields": {"vbat": {"name": "vbat", "extra": {}, "component": "sensor", "field_name": "vbat", "unit_of_measurement": "v"}, "status": {"name": "status", "extra": {}, "component": "sensor", "field_name": "status"}, "detected": {"name": "detected", "extra": {}, "component": "sensor", "field_name": "detected"}}}', 'mt_ks51', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('24194975885430789', 'MT-KS32', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port || null;
    function parseSharedAttrs(payload) {
        if (port!=214||payload[0]!=0x2F) { return null}
        let shared_attrs = {};
        if (payload.length<5) { return null}
        shared_attrs.content = payload.toString(''hex'');
        let size=payload.length-4
        let regAddress=payload[2]
        for (let i=0; i<size; i++) {
            regAddress=payload[2]+i
            switch (regAddress) {
                case  58:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_data = payload.readUInt16LE(4+i)
                    break;
                case 100:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.base_header = payload.readUInt16LE(4+i)
                case 102:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base1 = payload.readUInt32LE(4+i)
                    break;
                case 106:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base2 = payload.readUInt32LE(4+i)
                    break;
                case 110:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base3 = payload.readUInt32LE(4+i)
                    break;
                case 114:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base4 = payload.readUInt32LE(4+i)
                    break;
                case 118:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base5 = payload.readUInt32LE(4+i)
                    break;
                case 122:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.base6 = payload.readUInt32LE(4+i)
                    break;
                default: break
            }
        }
        if (Object.keys(shared_attrs).length == 0) {    return null }
        return shared_attrs;
    }
    function parseTelemetry(payload){
        if (port!=15) { return null}
        if (payload[0]!=0x82||payload[1]!=0x24|| payload[2]!=0x1A){ return null }
        if (payload.length <30) {   return null }
        let telemetry_data = {};
        if (payload[4]>0) {
            telemetry_data.status="fault"
            return telemetry_data
        }
        telemetry_data.vbat=Number(((payload.readUInt8(5)*1.6/254)+2).toFixed(2))
        let diVal=payload[3]
        telemetry_data.chan1=((diVal&0x01)==0x01)?1:0
        telemetry_data.chan2=((diVal&0x02)==0x02)?1:0
        telemetry_data.chan3=((diVal&0x04)==0x04)?1:0
        telemetry_data.chan4=((diVal&0x08)==0x08)?1:0
        telemetry_data.chan5=((diVal&0x10)==0x10)?1:0
        telemetry_data.chan6=((diVal&0x20)==0x20)?1:0
        telemetry_data.counter1=payload.readInt32LE(6)
        telemetry_data.counter2=payload.readInt32LE(10)
        telemetry_data.counter3=payload.readInt32LE(14)
        telemetry_data.counter4=payload.readInt32LE(18)
        telemetry_data.counter5=payload.readInt32LE(22)
        telemetry_data.counter6=payload.readInt32LE(26)
        return telemetry_data
    }
    let tdata=parseTelemetry(payload)
    let sdata=parseSharedAttrs(payload)
    return {
        telemetry_data: tdata,
        server_attrs: null,
        shared_attrs: sdata
    }', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,"dry contanct"}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"vbat": {"icon": "<svg t=\"1758627362545\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"8603\" width=\"200\" height=\"200\"><path d=\"M554.666667 341.333333v128h85.333333l-128 213.333334V554.666667h-85.333333l128-213.333334z m384 170.666667c0 234.666667-192 426.666667-426.666667 426.666667S85.333333 746.666667 85.333333 512 277.333333 85.333333 512 85.333333v128c-166.4 0-298.666667 132.266667-298.666667 298.666667s132.266667 298.666667 298.666667 298.666667 298.666667-132.266667 298.666667-298.666667h128z m-46.933334 42.666667h-42.666666c-21.333333 166.4-166.4 298.666667-337.066667 298.666666-187.733333 0-341.333333-153.6-341.333333-341.333333C170.666667 337.066667 302.933333 196.266667 469.333333 174.933333v-42.666666C277.333333 153.6 128 315.733333 128 512c0 213.333333 170.666667 384 384 384 196.266667 0 358.4-149.333333 379.733333-341.333333z m-89.6-106.666667l123.733334-29.866667C891.733333 256 763.733333 128 601.6 93.866667l-29.866667 123.733333c119.466667 29.866667 204.8 115.2 230.4 230.4z\" fill=\"#1296db\" p-id=\"8604\"></path></svg>", "name": "vbat", "type": "number", "unit": "", "order": 14, "field_name": "vbat"}, "chan1": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan1", "type": "number", "unit": "", "order": 2, "field_name": "chan1"}, "chan2": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan2", "type": "number", "unit": "", "order": 3, "field_name": "chan2"}, "chan3": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan3", "type": "number", "unit": "", "order": 4, "field_name": "chan3"}, "chan4": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan4", "type": "number", "unit": "", "order": 5, "field_name": "chan4"}, "chan5": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan5", "type": "number", "unit": "", "order": 6, "field_name": "chan5"}, "chan6": {"icon": "<svg t=\"1758942791928\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7863\" width=\"200\" height=\"200\"><path d=\"M480 704H64V576h416L768 320l64 96L480 704zM960 576h-192v128h192V576z\" p-id=\"7864\" fill=\"#1296db\"></path></svg>", "name": "chan6", "type": "number", "unit": "", "order": 7, "field_name": "chan6"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 1, "field_name": "status"}, "counter1": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter1", "type": "number", "unit": "", "order": 8, "field_name": "counter1"}, "counter2": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter2", "type": "number", "unit": "", "order": 9, "field_name": "counter2"}, "counter3": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter3", "type": "number", "unit": "", "order": 10, "field_name": "counter3"}, "counter4": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter4", "type": "number", "unit": "", "order": 11, "field_name": "counter4"}, "counter5": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter5", "type": "number", "unit": "", "order": 12, "field_name": "counter5"}, "counter6": {"icon": "<svg t=\"1758942943361\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"9286\" width=\"200\" height=\"200\"><path d=\"M303.07 360.36v303.29h-34.81V402.78c-18.71 19.28-42.51 33.16-71.36 41.64v-34.81c13.27-3.7 27.41-9.92 42.47-18.71 13.88-8.49 26.02-18.71 36.55-30.59h27.15v0.05z m180.89-5.88c28.07 0 51.13 8.05 69.27 24.19 18.1 16.41 27.15 37.81 27.15 64.14 0 26.07-9.88 49.82-29.72 71.36-11.62 12.18-32.55 28.46-62.88 48.82-38.51 25.8-60.57 49-66.23 69.66h159.26v31.02H378.65c0-28.02 10.01-53.09 30.16-75.19 13.01-14.71 34.94-32.72 65.83-53.96 24.06-17.28 39.9-29.85 47.56-37.77 15.58-16.97 23.37-35.12 23.37-54.39 0-18.41-5.53-32.72-16.54-42.9-11.09-10.18-26.54-15.27-46.34-15.27-21.24 0-37.25 7.05-48 21.23-12.18 13.88-18.41 34.11-18.71 60.74h-34.81c0-33.72 9.49-60.74 28.46-81.15 18.72-20.35 43.52-30.53 74.33-30.53z m239.93 0c29.46 0 52.96 7.35 70.49 22.06 17.58 15.01 26.37 35.12 26.37 60.31 0 34.29-16.58 56.92-49.74 67.97 18.14 5.66 31.76 14.32 40.82 25.89 10.18 11.92 15.27 26.76 15.27 44.6 0 27.5-9.62 50-28.89 67.53-19.54 17.84-44.99 26.76-76.45 26.76-28.28 0-51.78-7.35-70.49-22.06-21.54-17.84-33.55-43.77-36.12-77.71h35.25c0.87 23.76 8.79 41.9 23.8 54.35 13.05 10.44 28.89 15.71 47.56 15.71 21.54 0 38.94-6.22 52.22-18.71 12.18-12.19 18.28-26.98 18.28-44.56 0-18.15-5.92-32.29-17.84-42.47-11.57-9.92-28.02-14.88-49.26-14.88h-24.63v-27.28h23.37c20.1 0 35.55-4.53 46.3-13.58 10.75-9.36 16.1-22.54 16.1-39.51 0-16.71-5.22-29.89-15.67-39.51-10.79-9.92-26.19-14.84-46.3-14.84-20.67 0-36.55 5.35-47.6 16.1-11.57 10.79-18.54 26.5-20.8 47.17h-34.37c2.52-29.16 13.27-52.09 32.24-68.8 17.58-16.45 40.9-24.63 70.1-24.63v0.09z m0 0\" p-id=\"9287\" fill=\"#1296db\"></path><path d=\"M794.17 147.91c45.16 0.2 81.71 36.76 81.92 81.92v564.34c-0.2 45.16-36.76 81.71-81.92 81.92H229.83c-45.16-0.2-81.71-36.76-81.92-81.92V229.83c0.2-45.16 36.76-81.71 81.92-81.92h564.34m0-45.51H229.83c-70.09 0-127.43 57.34-127.43 127.43v564.34c0 70.08 57.34 127.43 127.43 127.43h564.34c70.08 0 127.43-57.34 127.43-127.43V229.83c0-70.09-57.34-127.43-127.43-127.43z m0 0\" p-id=\"9288\" fill=\"#1296db\"></path></svg>", "name": "counter6", "type": "number", "unit": "", "order": 13, "field_name": "counter6"}}}', '{}', '{"fields": {"vbat": {"rpcs": [], "unit": "noUnits", "field_name": "vbat", "object_type": "analogValue", "cov_increment": 0, "default_value": 0, "object_name_suffix": "vbat"}, "chan1": {"rpcs": [], "unit": "noUnits", "field_name": "chan1", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan1"}, "chan2": {"rpcs": [], "unit": "noUnits", "field_name": "chan2", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan2"}, "chan3": {"rpcs": [], "unit": "noUnits", "field_name": "chan3", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan3"}, "chan4": {"rpcs": [], "unit": "noUnits", "field_name": "chan4", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan4"}, "chan5": {"rpcs": [], "unit": "noUnits", "field_name": "chan5", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan5"}, "chan6": {"rpcs": [], "unit": "noUnits", "field_name": "chan6", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan6"}, "counter1": {"rpcs": [], "unit": "noUnits", "field_name": "counter1", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter1"}, "counter2": {"rpcs": [], "unit": "noUnits", "field_name": "counter2", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter2"}, "counter3": {"rpcs": [], "unit": "noUnits", "field_name": "counter3", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter3"}, "counter4": {"rpcs": [], "unit": "noUnits", "field_name": "counter4", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter4"}, "counter5": {"rpcs": [], "unit": "noUnits", "field_name": "counter5", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter5"}, "counter6": {"rpcs": [], "unit": "noUnits", "field_name": "counter6", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "counter6"}}}', 'CUSTOMER', '{"fields": {"vbat": {"name": "vbat", "extra": {}, "component": "sensor", "field_name": "vbat", "unit_of_measurement": "v"}, "chan1": {"name": "chan1", "extra": {}, "component": "sensor", "field_name": "chan1"}, "chan2": {"name": "chan2", "extra": {}, "component": "sensor", "field_name": "chan2"}, "chan3": {"name": "chan3", "extra": {}, "component": "sensor", "field_name": "chan3"}, "chan4": {"name": "chan4", "extra": {}, "component": "sensor", "field_name": "chan4"}, "chan5": {"name": "chan5", "extra": {}, "component": "sensor", "field_name": "chan5"}, "chan6": {"name": "chan6", "extra": {}, "component": "sensor", "field_name": "chan6"}, "status": {"name": "status", "extra": {}, "component": "sensor", "field_name": "status"}, "counter1": {"name": "counter1", "extra": {}, "component": "sensor", "field_name": "counter1"}, "counter2": {"name": "counter2", "extra": {}, "component": "sensor", "field_name": "counter2"}, "counter3": {"name": "counter3", "extra": {}, "component": "sensor", "field_name": "counter3"}, "counter4": {"name": "counter4", "extra": {}, "component": "sensor", "field_name": "counter4"}, "counter5": {"name": "counter5", "extra": {}, "component": "sensor", "field_name": "counter5"}, "counter6": {"name": "counter6", "extra": {}, "component": "sensor", "field_name": "counter6"}}}', 'mt_ks32', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('24194240544247813', 'MT-KS31', ' let payload = Buffer.from(msg?.userdata?.payload, "base64");
    //let preTelemetry = device?.telemetry_data?.[thingModelId];
    let port=msg?.userdata?.port || null;
    function parseSharedAttrs(payload) {
        if (port!=214||payload[0]!=0x2F) { return null}
        let shared_attrs = {};
        if (payload.length<5) { return null}
        shared_attrs.content = payload.toString(''hex'');
        let size=payload.length-4
        let regAddress=payload[2]
        for (let i=0; i<size; i++) {
            regAddress=payload[2]+i
            switch (regAddress) {
                case  58:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_data = payload.readUInt16LE(4+i)
                    break;
                case 150:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_enable = "0x"+payload[4+i].toString(16).padStart(2,''0'')
                case 152:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_measure = payload.readUInt16LE(4+i)
                    break;
                case 154:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.chan1 = payload.readUInt32LE(4+i)
                    break;
                case 158:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.chan2 = payload.readUInt32LE(4+i)
                    break;
                case 162:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.chan3 = payload.readUInt32LE(4+i)
                    break;
                case 166:
                    if  ( size<(4+i) ) { break }
                    shared_attrs.chan4 = payload.readUInt32LE(4+i)
                    break;
                default: break
            }
        }
        if (Object.keys(shared_attrs).length == 0) {    return null }
        return shared_attrs;
    }
    function parseTelemetry(payload){
        if (msg.userdata.port!=11) { return null}
        if (payload[0]!=0x82||payload[1]!=0x25){    return null }
        if (payload.length <21) {   return null }
        let telemetry_data = {}
        let powerVal=10
        if (payload[2]==0x17) {
            powerVal=11
            telemetry_data.type="4-20mA"
        }else if (payload[1]==0x18){
            powerVal=10
            telemetry_data.type="0-10V"
        }else {
            return null
        }
        if (payload[3]>0) {
            telemetry_data.status="fault"
            return telemetry_data
        }
        telemetry_data.status="normal"
        telemetry_data.chan1=Number((payload.readInt32LE(4)*powerVal/64000).toFixed(2))
        telemetry_data.chan2=Number((payload.readInt32LE(8)*powerVal/64000).toFixed(2))
        telemetry_data.chan3=Number((payload.readInt32LE(12)*powerVal/64000).toFixed(2))
        telemetry_data.chan4=Number((payload.readInt32LE(16)*powerVal/64000).toFixed(2))
        telemetry_data.vbat=Number(((payload.readUInt8(20)*1.6/254)+2).toFixed(2))
        return telemetry_data
    }
    let appData= parseTelemetry(payload)
    return {
        telemetry_data: appData,
        server_attrs: (appData==null)?null:{"type":appData?.type},
        shared_attrs: null,
    }', 'mtfac', '
return {
  eui: device.eui,
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,4-20mA,0-10V}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"vbat": {"icon": "<svg t=\"1758355813974\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5140\" width=\"200\" height=\"200\"><path d=\"M229.437808 137.515153l565.137325 0 0 869.673988-565.137325 0 0-869.673988Z\" fill=\"#1296db\" p-id=\"5141\"></path><path d=\"M756.488638 1024H267.524303A54.949119 54.949119 0 0 1 212.626949 969.115588V175.614589A54.949119 54.949119 0 0 1 267.511362 120.730177h488.977276a54.949119 54.949119 0 0 1 54.884413 54.884412v793.500999a54.949119 54.949119 0 0 1-54.884413 54.884412z m-488.977276-869.661047a21.301519 21.301519 0 0 0-21.236813 21.275636v793.500999a21.301519 21.301519 0 0 0 21.275637 21.275636h488.938452a21.301519 21.301519 0 0 0 21.275637-21.275636V175.614589a21.301519 21.301519 0 0 0-21.275637-21.275636H267.524303z\" fill=\"#1296db\" p-id=\"5142\"></path><path d=\"M307.021409 256.912368l409.970123 0 0 630.8925-409.970123 0 0-630.8925Z\" fill=\"#1296db\" p-id=\"5143\"></path><path d=\"M678.905038 904.602785H345.094962a54.949119 54.949119 0 0 1-54.819705-54.87147V294.998863a54.949119 54.949119 0 0 1 54.884412-54.884413h333.745369a54.949119 54.949119 0 0 1 54.884412 54.884413V849.731315a54.949119 54.949119 0 0 1-54.884412 54.87147zM345.094962 273.710285a21.301519 21.301519 0 0 0-21.275636 21.275636V849.731315a21.301519 21.301519 0 0 0 21.275636 21.275636h333.810076a21.301519 21.301519 0 0 0 21.275636-21.275636V294.998863a21.301519 21.301519 0 0 0-21.275636-21.288578H345.094962z\" fill=\"#1296db\" p-id=\"5144\"></path><path d=\"M374.018957 16.797917l275.987969 0 0 120.717236-275.987969 0 0-120.717236Z\" fill=\"#1296db\" p-id=\"5145\"></path><path d=\"M611.920431 154.326012H412.092511a54.949119 54.949119 0 0 1-54.884413-54.884413V54.884412A54.949119 54.949119 0 0 1 412.092511 0h199.82792a54.949119 54.949119 0 0 1 54.884412 54.884412v44.557187a54.949119 54.949119 0 0 1-54.884412 54.884413zM412.092511 33.608776a21.301519 21.301519 0 0 0-21.275637 21.275636v44.557187a21.301519 21.301519 0 0 0 21.275637 21.275637h199.82792a21.301519 21.301519 0 0 0 21.301519-21.275637V54.884412a21.301519 21.301519 0 0 0-21.275637-21.275636H412.092511z\" fill=\"#1296db\" p-id=\"5146\"></path><path d=\"M503.601041 525.74375l-13.433157-136.751611 124.327882 157.936658-94.083866 63.516316 31.926396 141.60463-142.821121-181.528802 94.083866-44.777191z\" fill=\"#1296db\" p-id=\"5147\"></path><path d=\"M552.338296 768.860602a16.8238 16.8238 0 0 1-13.213154-6.470692L396.304021 580.912873a16.8238 16.8238 0 0 1 5.97892-25.559234l83.407224-39.704169-12.281374-125.000834a16.8238 16.8238 0 0 1 29.920481-12.035487l124.340824 157.884892a16.8238 16.8238 0 0 1-3.804767 24.316862l-84.546066 57.136213 29.402826 130.410333a16.8238 16.8238 0 0 1-16.383793 20.499153zM435.710538 576.668099l83.886055 106.624068-15.529662-69.145818a16.8238 16.8238 0 0 1 6.988348-17.613225l79.058919-53.383211-77.648308-98.587468 7.764831 79.563632a16.8238 16.8238 0 0 1-9.498977 16.8238z\" fill=\"#1296db\" p-id=\"5148\"></path></svg>", "name": "vbat", "type": "number", "unit": "V", "order": 5, "field_name": "vbat"}, "chan1": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "chan1", "type": "number", "unit": "", "order": 1, "field_name": "chan1"}, "chan2": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "chan2", "type": "number", "unit": "", "order": 2, "field_name": "chan2"}, "chan3": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "chan3", "type": "number", "unit": "", "order": 3, "field_name": "chan3"}, "chan4": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "chan4", "type": "number", "unit": "", "order": 4, "field_name": "chan4"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 6, "field_name": "status"}}}', '{}', '{"fields": {"vbat": {"rpcs": [], "unit": "volts", "field_name": "vbat", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "vbat"}, "chan2": {"rpcs": [], "unit": "noUnits", "field_name": "chan2", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan2"}, "chan3": {"rpcs": [], "unit": "noUnits", "field_name": "chan3", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan3"}, "chan4": {"rpcs": [], "unit": "noUnits", "field_name": "chan4", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "chan4"}}}', 'CUSTOMER', '{"fields": {"vbat": {"name": "vbat", "extra": {}, "component": "text", "field_name": "vbat", "unit_of_measurement": "V"}, "chan1": {"name": "chan1", "extra": {}, "component": "sensor", "field_name": "chan1", "unit_of_measurement": ""}, "chan2": {"name": "chan2", "extra": {}, "component": "sensor", "field_name": "chan2", "unit_of_measurement": ""}, "chan3": {"name": "chan3", "extra": {}, "component": "sensor", "field_name": "chan3", "unit_of_measurement": ""}, "chan4": {"name": "chan4", "extra": {}, "component": "sensor", "field_name": "chan4", "unit_of_measurement": ""}}}', 'mt_ks31', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('23103614448832517', 'MT-KS61', 'let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port;
    //let preTelemetry = device?.telemetry_data?.[thingModelId];
    function parseSharedAttrs(payload) {
        if (port!=214||payload[0]!=0x2F) { return null}
        let shared_attrs ={}
        shared_attrs.content = payload.toString(''hex'')
        if (payload.length<5) { return null}
        let size=payload.length-4
        let regAddress=payload[2]
        for (let i=0; i<size; i++) {
            regAddress=payload[2]+i
            switch (regAddress) {
                case  58:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_data = payload.readUInt16LE(4+i)
                    break;
                case 152:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.enable = "0x"+payload.readUInt8(4+i).toString(16).padStart(2, ''0'')
                    break;
                case 153:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_temperatrue = payload.readUInt8(4+i)*0.1
                    break;
                case 154:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_humidity = payload.readUInt8(4+i)
                    break;
                case 155:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_tvoc = payload.readUInt8(4+i)
                    break;
                case 156:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_co2 = payload.readUInt8(4+i)
                    break;
                case 157:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_pm25 = payload.readUInt8(4+i)
                    break;
                case 158:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.pir_delay = payload.readUInt16LE(4+i)
                    break;
                case 160:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.lux_threshold1 = payload.readUInt16LE(4+i)
                    break;
                case 162:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.lux_threshold2 = payload.readUInt16LE(4+i)
                    break;
                case 164:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.lux_threshold3 = payload.readUInt16LE(4+i)
                    break;
                case 166:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.pir_mask ="0x"+ payload.readUInt8(4+i).toString(16).padStart(2, ''0'')
                    break;
                default: break
            }
        }
        if (Object.keys(shared_attrs).length == 0) {
            return null
        }
        return shared_attrs;
    }
    function parseTelemetry(payload){
        if (port!=11) { return null}
        if (payload[0]!=0x82||payload[1]!=0x24||payload[2]!=0x07){  return null }
        let telemetryData={}
        if (payload.length <24) {   return null }
        if (payload[3]>0) {
            telemetryData.status="fault"
            return telemetryData
        }
        telemetryData.temperatrue=Number((payload.readInt16LE(4)/10).toFixed(1))
        telemetryData.humidity=Number((payload.readInt16LE(6)/10).toFixed(1))
        telemetryData.co2=Number(payload.readInt16LE(8))
        telemetryData.light=Number(payload.readInt16LE(10))
        telemetryData.tvoc=Number(payload.readInt32LE(12))
        let pirval=payload.readUInt8(17)
        telemetryData.pir= (pirval>0)?1:0
        let relayval =payload.readUInt8(18)
        telemetryData.relay1=((relayval&0x01)===0x01)?1:0
        telemetryData.relay2=((relayval&0x02)===0x02)?1:0
        telemetryData.relay3=((relayval&0x04)===0x04)?1:0
        telemetryData.pm25=Number((payload.readFloatLE(20)).toFixed(2))
        return telemetryData
    }
    let appData= parseTelemetry(payload)
    let sattrs=parseSharedAttrs(payload)
    return {
        telemetry_data: appData,
        server_attrs: null,
        shared_attrs: sattrs,
    }', 'mtfac', '
return {
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{IAQ,KS61,ManThink}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"co2": {"icon": "<svg t=\"1758627509833\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"14320\" width=\"200\" height=\"200\"><path d=\"M464.82 67.51h-116.9l-8.18 10.55H473l-8.18-10.55zM584.07 88.6H387.56l-8.18-10.54h212.87l-8.18 10.54zM290.37 106.54h116.9L415.45 96H282.19l8.18 10.54zM250.74 85.45h116.9L375.82 96H242.56l8.18-10.55zM605.87 67.51h116.9l8.18 10.55H597.69l8.18-10.55z\" fill=\"#0EBBCB\" p-id=\"14321\"></path><path d=\"M566.24 88.6h116.89l8.18-10.54H558.05l8.19 10.54zM780.31 106.54H663.42L655.24 96h133.25l-8.18 10.54zM819.94 85.45H703.05L694.87 96h133.26l-8.19-10.55zM605.87 153.72h116.9l8.18-10.55H597.69l8.18 10.55zM486.62 132.63h196.51l8.18 10.54H478.44l8.18-10.54zM780.31 114.68H663.42l-8.18 10.54h133.25l-8.18-10.54zM819.95 135.77h-116.9l-8.18-10.55h133.26l-8.18 10.55zM464.82 153.72H347.93l-8.19-10.55H473l-8.18 10.55z\" fill=\"#0EBBCB\" p-id=\"14322\"></path><path d=\"M504.45 132.63H387.56l-8.18 10.54h133.25l-8.18-10.54zM290.37 114.68h116.9l8.18 10.54H282.2l8.17-10.54zM250.74 135.77h116.9l8.18-10.55H242.56l8.18 10.55z\" fill=\"#0EBBCB\" p-id=\"14323\"></path><path d=\"M605.62 898.85H722.51l8.18-10.55H597.43l8.19 10.55zM486.36 877.76H682.88l8.18 10.54H478.18l8.18-10.54zM780.06 859.81h-116.9l-8.17 10.55h133.25l-8.18-10.55zM819.69 880.9h-116.9l-8.18-10.54h133.26l-8.18 10.54zM464.56 898.85H347.67l-8.18-10.55h133.26l-8.19 10.55z\" fill=\"#0EBBCB\" p-id=\"14324\"></path><path d=\"M504.2 877.76H387.3l-8.18 10.54h133.26l-8.18-10.54zM290.12 859.81h116.9l8.18 10.55H281.94l8.18-10.55zM250.49 880.9H367.38l8.19-10.54H242.31l8.18 10.54zM464.56 812.64H347.67l-8.18 10.55h133.26l-8.19-10.55zM583.82 833.73H387.3l-8.18-10.54H592l-8.18 10.54zM290.12 851.68h116.9l8.18-10.54H281.94l8.18 10.54zM250.49 830.59H367.38l8.19 10.55H242.31l8.18-10.55zM605.61 812.64h116.9l8.18 10.55H597.43l8.18-10.55z\" fill=\"#0EBBCB\" p-id=\"14325\"></path><path d=\"M565.98 833.73h116.9l8.18-10.54H557.8l8.18 10.54zM780.06 851.68h-116.9l-8.18-10.54h133.26l-8.18 10.54zM819.69 830.59h-116.9l-8.18 10.55h133.26l-8.18-10.55z\" fill=\"#0EBBCB\" p-id=\"14326\"></path><path d=\"M698.79 618.13a99.81 99.81 0 0 1 2.3-22.53 83.31 83.31 0 0 1 7.43-20 106.36 106.36 0 0 1 12.54-18.43 191.06 191.06 0 0 1 17.66-18.44L753.57 525a81.89 81.89 0 0 0 10-10 41.87 41.87 0 0 0 5.9-9.21 34.81 34.81 0 0 0 2.55-10 96.76 96.76 0 0 0 0-12.28A18.17 18.17 0 0 0 754.09 461a16.66 16.66 0 0 0-17.16 10.49 36.38 36.38 0 0 0-2.81 11.27v13.57h-35.33v-6.15a52.73 52.73 0 0 1 13.57-38.91 58.34 58.34 0 0 1 42.75-13.56 57.35 57.35 0 0 1 41 12.79 48.5 48.5 0 0 1 13.31 36.61 80.82 80.82 0 0 1-1.54 16.13 61.72 61.72 0 0 1-4.88 14.29 67.75 67.75 0 0 1-8.7 13.56 129.33 129.33 0 0 1-13.06 13.32l-20.48 18.94a76.59 76.59 0 0 0-12.8 14.34 41.85 41.85 0 0 0-5.91 12.31h67.59v28.15H698.79z m-157.7-96a139.28 139.28 0 0 0 5.63 33.54A37.11 37.11 0 0 0 559 574.61a40.43 40.43 0 0 0 42.24 0 37 37 0 0 0 12.29-18.94 140 140 0 0 0 5.63-33.54q1.55-20.73 1.54-51.2t-1.54-51.2a142.3 142.3 0 0 0-5.63-33.53 37.39 37.39 0 0 0-12.29-18.95 40.47 40.47 0 0 0-42.24 0 37.47 37.47 0 0 0-12.29 18.95 142.3 142.3 0 0 0-5.63 33.53q-1.53 20.52-1.54 51.2t1.54 51.2z m-57.34-111.36a135.31 135.31 0 0 1 13.57-48.12 76.85 76.85 0 0 1 30.2-31.24 129.6 129.6 0 0 1 105.73 0 76.81 76.81 0 0 1 30.21 31.24A135.51 135.51 0 0 1 677 410.77a614.33 614.33 0 0 1 0 122.63 135 135 0 0 1-13.57 47.87A71.94 71.94 0 0 1 633.25 612a136.44 136.44 0 0 1-105.73 0 71.91 71.91 0 0 1-30.2-30.72 135 135 0 0 1-13.57-47.87 614.33 614.33 0 0 1 0-122.63zM384.16 378a28.41 28.41 0 0 0-27.64-14.6 27.71 27.71 0 0 0-18.18 5.89 39.43 39.43 0 0 0-11.26 19.2 164.17 164.17 0 0 0-5.63 34.82q-1.54 21.51-1.54 52.73a510.74 510.74 0 0 0 2.3 53.77 118.07 118.07 0 0 0 6.92 31.74 28.72 28.72 0 0 0 11.77 15.1 33.54 33.54 0 0 0 16.64 3.84 38.55 38.55 0 0 0 14.59-2.56 25.59 25.59 0 0 0 11.78-10.75 69.48 69.48 0 0 0 7.68-22.53 206.62 206.62 0 0 0 2.81-38.4h58.89a264.7 264.7 0 0 1-3.59 45.06 102.28 102.28 0 0 1-13.82 37.37 68.14 68.14 0 0 1-28.16 25.6 106.92 106.92 0 0 1-47.36 9 111.39 111.39 0 0 1-52.74-10.75 71.94 71.94 0 0 1-30.21-30.72 135.46 135.46 0 0 1-13.57-47.87 614.33 614.33 0 0 1 0-122.63 135.51 135.51 0 0 1 13.57-48.12 76.88 76.88 0 0 1 30.21-31.24 106.37 106.37 0 0 1 52.74-11.26A102.46 102.46 0 0 1 410 330.9a69.88 69.88 0 0 1 27.14 25.6 90.33 90.33 0 0 1 11.26 34.05 283.34 283.34 0 0 1 2.3 34.3h-58.86a106 106 0 0 0-7.68-46.85z m0 0\" fill=\"#0EBBCB\" p-id=\"14327\"></path></svg>", "name": "co2", "type": "number", "unit": "ppm", "order": 2, "field_name": "co2"}, "pir": {"icon": "<svg t=\"1758627571879\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"16273\" width=\"200\" height=\"200\"><path d=\"M654.245872 518.507186c0 61.301342-5.716593 74.923863 19.339114 133.914242l102.168904 232.677515c44.273192 68.112602-48.773489 106.669201-80.640456 45.367858l-91.952013-177.092766c-20.433781-38.556598-43.178525-90.857346-73.829196-49.989785-35.150968 39.772895-55.584749 62.396009-67.017936 86.23542-13.62252 28.339708-14.717187 60.206675-14.717187 127.102981 0 65.801639-86.23542 62.396009-86.23542 6.81126 0-118.102387-1.094667-174.781803 70.423566-286.07293 46.584155-70.423566 49.989785-37.461931 39.772894-126.008314-3.40563-20.433781-4.500297-105.574534-40.867561-87.451717-13.62252 6.81126-53.395415 93.04668-155.564319 102.168904-40.867561 3.40563-52.179119-38.556598-19.339114-56.801045 51.084452-28.339708 104.479867-53.395415 128.319278-112.385794 22.744744-57.895712 1.094667-90.857346 81.735123-133.914242 26.150374-14.717187 54.490082-20.433781 79.42416-10.21689l157.753652 78.329492c32.961634 14.717187 41.962228 27.245041 41.962228 62.396009v139.630836c0 49.989785-57.895712 44.273192-57.895712 2.310963l-2.310963-98.763274c0-20.433781-5.716593-38.556598-21.528448-52.179118-13.62252-11.311557-36.367265-19.339114-49.989785-26.150375-24.934078-11.311557-18.122817 12.527854-10.21689 26.150375 7.905927 12.527854 20.433781 35.150968 31.745338 60.206675 20.55541 46.705785 19.460744 64.828602 19.460743 113.72372zM428.257988 210.784179c41.962228 0 74.923863-32.961634 74.923863-74.923863 0-40.867561-32.961634-74.923863-74.923863-74.923863-40.867561 0-74.923863 34.056301-74.923863 74.923863 0 42.083858 34.056301 74.923863 74.923863 74.923863z\" fill=\"#1296db\" p-id=\"16274\"></path></svg>", "name": "pir", "type": "number", "unit": "", "order": 5, "field_name": "pir"}, "pm25": {"icon": "<svg t=\"1758627646912\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"18146\" width=\"200\" height=\"200\"><path d=\"M75.434667 577.194667c-21.560889 0-39.111111 16.711111-39.111111 37.304889 0 20.579556 17.550222 37.319111 39.111111 37.319111 21.589333 0 39.139556-16.739556 39.139555-37.319111 0-20.593778-17.550222-37.304889-39.139555-37.304889z m148.679111-59.733334c-17.251556 0-31.288889 13.397333-31.288889 29.880889 0 16.426667 13.980444 29.767111 31.288889 29.852445 17.28 0 31.331556-13.397333 31.331555-29.852445 0-16.426667-13.994667-29.795556-31.331555-29.866666z m-39.111111-343.281777c21.575111 0 39.111111-16.739556 39.111111-37.304889 0-20.579556-17.507556-37.319111-39.111111-37.319111-21.560889 0-39.125333 16.739556-39.125334 37.319111 0 20.593778 17.536 37.304889 39.139556 37.304889z m696.462222 59.704888c17.251556 0 31.288889-13.397333 31.288889-29.852444 0-16.426667-13.952-29.767111-31.288889-29.852444-17.265778 0-31.303111 13.397333-31.303111 29.852444 0 16.426667 13.980444 29.767111 31.288889 29.852444z m-242.631111 74.624c30.250667 0 54.812444-23.424 54.812444-52.238222s-24.561778-52.238222-54.769778-52.238222c-30.208 0-54.769778 23.424-54.769777 52.238222s24.561778 52.238222 54.755555 52.238222h-0.014222z m-226.872889-74.624c-26.026667 0.113778-47.032889 20.138667-46.976 44.771556-0.056889 24.661333 20.963556 44.686222 46.933333 44.8 25.912889 0 46.976-20.110222 46.976-44.8 0.056889-24.632889-20.949333-44.657778-46.961778-44.771556h0.028445zM821.902222 639.032889c-36.209778 0-65.635556 28.088889-65.635555 62.634667 0 34.56 29.454222 62.648889 65.635555 62.648888 36.224 0 65.678222-28.088889 65.678222-62.648888 0-34.545778-29.454222-62.634667-65.678222-62.634667z m-269.141333 57.528889c-17.28 0-31.331556 13.397333-31.331556 29.866666 0 16.412444 13.994667 29.752889 31.331556 29.838223 17.251556 0 31.288889-13.397333 31.288889-29.852445 0-16.426667-13.980444-29.795556-31.288889-29.852444z m62.606222-117.290667c17.351111 0.085333 31.331556 13.425778 31.288889 29.880889 0 16.426667-14.037333 29.866667-31.288889 29.866667-17.351111-0.099556-31.331556-13.44-31.303111-29.866667 0-16.483556 14.037333-29.866667 31.288889-29.866667z m146.275556 355.868445c-108.472889 0-184.177778-42.936889-189.312-45.980445-313.685333-191.701333-510.179556-4.465778-518.4 3.598222a32.455111 32.455111 0 0 1-44.231111 0.753778 28.885333 28.885333 0 0 1-0.896-42.126222c2.304-2.304 239.118222-231.438222 596.736-12.8 6.528 3.740444 177.692444 99.271111 368.654222-33.507556a32.384 32.384 0 0 1 23.296-5.390222 31.672889 31.672889 0 0 1 20.437333 11.904c10.168889 13.312 7.111111 31.985778-6.883555 41.713778-90.225778 62.72-177.066667 81.834667-249.400889 81.834667z\" fill=\"#1296db\" p-id=\"18147\"></path><path d=\"M123.704889 365.383111h79.729778c44.785778 0 67.171556 19.114667 67.171555 57.344 0 38.499556-22.656 57.884444-67.441778 57.884445h-57.073777V560.355556H123.704889V365.383111z m22.385778 19.384889v76.458667h55.978666c15.843556 0 27.306667-3.271111 34.958223-9.557334 7.367111-6.272 11.192889-15.829333 11.192888-28.942222 0-13.098667-3.825778-22.656-11.477333-28.401778-7.637333-6.542222-19.114667-9.557333-34.673778-9.557333h-55.978666z m152.917333-19.384889V560.355556h22.385778V405.248h0.824889L389.660444 560.355556h20.209778l67.456-155.107556h0.810667V560.355556h22.4V365.383111h-27.861333l-72.362667 166.300445h-0.810667l-72.647111-166.300445h-27.847111z m305.834667-3.825778c-19.655111 0-35.768889 6.556444-47.786667 19.669334-12.017778 12.828444-18.289778 30.307556-18.289778 52.152889h22.385778c0.284444-17.208889 4.366222-30.307556 12.017778-39.054223 7.096889-9.272889 17.479111-13.653333 30.862222-13.653333 12.558222 0 22.656 3.271111 29.752889 9.841778 7.111111 6.542222 10.652444 15.559111 10.652444 27.576889 0 12.558222-5.191111 24.305778-15.018666 34.944-5.191111 5.461333-15.288889 13.383111-30.577778 24.32-20.764444 14.193778-34.688 25.927111-42.325333 34.673777-13.112889 14.464-19.399111 30.577778-19.399112 48.327112h129.991112v-19.939556h-102.4c3.555556-13.098667 17.749333-28.117333 42.595555-44.771556 20.195556-13.653333 33.578667-24.32 40.405333-31.402666 12.572444-13.653333 19.114667-28.956444 19.114667-45.880889s-6.001778-30.862222-17.464889-41.244445c-11.747556-10.368-26.496-15.559111-44.515555-15.559111z m115.228444 166.300445c-4.906667 0-8.732444 1.635556-11.733333 4.920889-3.271111 3.271111-4.920889 7.096889-4.920889 12.017777 0 4.636444 1.635556 8.462222 4.920889 11.733334 3.000889 3.271111 6.826667 4.920889 11.733333 4.920889 4.380444 0 8.476444-1.635556 11.747556-4.920889 3.271111-3.271111 4.920889-7.096889 4.920889-11.733334a16.071111 16.071111 0 0 0-4.920889-12.017777 16.327111 16.327111 0 0 0-11.747556-4.920889z m64.711111-162.474667l-10.368 107.591111h21.304889a38.684444 38.684444 0 0 1 17.479111-17.479111c7.367111-4.096 15.559111-6.001778 24.846222-6.001778 14.193778 0 25.386667 4.096 33.308445 12.828445 8.192 8.462222 12.558222 20.48 12.558222 36.053333 0 13.653333-4.636444 24.846222-13.368889 33.578667-9.016889 8.746667-20.209778 13.112889-33.863111 13.112889-12.017778 0-22.115556-3.000889-29.767111-8.746667-8.732444-6.542222-13.653333-16.099556-14.748444-28.387556h-22.115556c1.365333 17.749333 8.732444 31.943111 22.385778 42.325334 12.017778 9.272889 26.766222 13.923556 43.975111 13.923555 19.114667 0 35.498667-6.016 48.597333-17.749333 13.937778-12.558222 21.034667-28.672 21.034667-48.341333 0-21.020444-6.016-37.404444-17.493333-49.422223-11.463111-11.733333-26.481778-17.479111-45.041778-17.479111-9.016889 0-17.208889 1.365333-24.846222 4.650667a50.688 50.688 0 0 0-21.034667 14.748444h-1.095111l6.556444-65.28h95.032889v-19.911111H784.782222z\" fill=\"#1296db\" p-id=\"18148\"></path></svg>", "name": "pm2.5", "type": "number", "unit": "ug/m³", "order": 5, "field_name": "pm25"}, "tvoc": {"icon": "<svg t=\"1758627718315\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"19334\" width=\"200\" height=\"200\"><path d=\"M73.649231 674.185846a19.692308 19.692308 0 1 1 36.785231-14.099692 413.656615 413.656615 0 0 0 771.820307 1.732923 19.692308 19.692308 0 1 1 36.706462 14.257231 453.041231 453.041231 0 0 1-845.312-1.890462z m858.781538-286.129231a19.692308 19.692308 0 0 1-37.888 10.752 413.696 413.696 0 0 0-796.750769 3.741539 19.692308 19.692308 0 0 1-38.006154-10.397539 453.080615 453.080615 0 0 1 872.644923-4.096z m-810.141538 45.252923H283.569231v25.639385H217.954462V630.153846h-29.77477v-171.204923H122.289231v-25.639385z m167.069538 0h32.531693l55.965538 163.209847h0.827077l55.689846-163.209847h32.531692L396.327385 630.153846h-36.391385l-70.577231-196.844308z m285.341539-3.859692c29.774769 0 53.484308 9.649231 70.852923 29.223385 16.541538 18.471385 24.812308 43.008 24.812307 73.334154 0 30.050462-8.270769 54.311385-24.812307 73.058461-17.368615 19.298462-41.078154 28.947692-70.852923 28.947692-30.050462 0-53.76-9.924923-70.852923-29.223384-16.541538-18.747077-24.536615-43.008-24.536616-72.782769 0-30.050462 7.995077-54.311385 24.536616-73.058462 17.092923-19.849846 40.802462-29.499077 70.852923-29.499077z m0 26.466462c-20.952615 0-37.218462 6.892308-48.797539 21.228307-11.027692 13.508923-16.541538 31.704615-16.541538 54.86277 0 22.882462 5.513846 41.078154 16.541538 54.587077 11.579077 13.784615 27.844923 20.952615 48.797539 20.952615 20.952615 0 37.218462-6.892308 48.521846-20.401231 11.027692-13.233231 16.817231-31.704615 16.817231-55.138461 0-23.709538-5.789538-42.180923-16.817231-55.689847-11.303385-13.784615-27.569231-20.401231-48.521846-20.40123z m211.456-26.466462c22.882462 0 41.905231 5.789538 56.792615 17.92 14.336 11.579077 23.158154 27.569231 26.190769 47.419077h-29.223384c-3.308308-13.233231-9.649231-23.158154-19.02277-29.499077-9.373538-6.340923-20.952615-9.373538-35.288615-9.373538-21.228308 0-37.218462 7.168-47.970461 21.779692-10.200615 13.233231-15.163077 31.428923-15.163077 54.311385 0 23.709538 4.962462 41.905231 14.887384 54.862769 10.476308 13.784615 26.742154 20.676923 48.797539 20.676923 14.336 0 26.466462-3.584 35.84-10.752 9.924923-7.719385 16.817231-19.298462 20.676923-34.737231h29.223384c-4.411077 22.882462-14.611692 40.802462-30.877538 53.76-15.163077 12.130462-33.358769 18.195692-54.587077 18.195692-32.256 0-56.516923-10.476308-72.782769-30.877538-14.336-17.644308-21.228308-41.353846-21.228308-71.128615 0-29.223385 7.168-52.932923 22.055385-71.404308 16.541538-20.952615 40.251077-31.153231 71.68-31.153231z\" fill=\"#1296db\" p-id=\"19335\"></path></svg>", "name": "tvoc", "type": "number", "unit": "", "order": 4, "field_name": "tvoc"}, "light": {"icon": "<svg t=\"1758627756975\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"20427\" width=\"200\" height=\"200\"><path d=\"M851.3 532.4c-11.8 0-21.4-9.6-21.4-21.5h-0.4c-6.6-173.8-147.1-313.1-320.9-317.6v-0.3c-11.8 0-21.4-9.6-21.4-21.5s9.6-21.5 21.4-21.5c1.4 0 2.8 0.1 4 0.4C706.6 156.8 863 312 872 505.9c0.4 1.6 0.6 3.2 0.6 4.9 0.1 11.9-9.5 21.6-21.3 21.6z m-158.5-8.6C692.8 630.6 606.5 717 500 717s-192.8-86.6-192.8-193.2c0-106.8 86.3-193.2 192.8-193.2 106.6-0.1 192.8 86.5 192.8 193.2zM304.9 362.6L253.4 311c-10-10.1-10-26.3 0-36.4 10-10.1 26.3-10.1 36.3 0l51.5 51.6c10 10.1 10 26.3 0 36.4-10 10-26.3 10-36.3 0z m-29.5 159.3c0 14.2-11.5 25.7-25.7 25.7H177c-14.2 0-25.7-11.5-25.7-25.7s11.5-25.7 25.7-25.7h72.9c14-0.1 25.5 11.4 25.5 25.7z m29.5 159.2c10-10.1 26.3-10.1 36.3 0 10 10.1 10 26.3 0 36.4l-51.5 51.6c-10 10.1-26.3 10.1-36.3 0-10-10.1-10-26.3 0-36.4l51.5-51.6z m195.2 66c14.2 0 25.7 11.5 25.7 25.7v73c0 14.2-11.5 25.7-25.7 25.7s-25.7-11.5-25.7-25.7v-73c0.1-14.1 11.5-25.7 25.7-25.7z m195.2-66l51.5 51.6c10 10.1 10 26.3 0 36.4-10 10.1-26.3 10.1-36.3 0L659 717.5a25.652 25.652 0 0 1 0-36.4c10-10 26.2-10 36.3 0z m44.6-176.6c0-0.7 0.1-1.4 0.2-2.2H739C728.5 383.7 632.3 290 513 283.6v-0.6c-12-1.1-21.4-11.1-21.4-23.4 0-13.1 10.6-23.7 23.6-23.7 2.2 0 4.2 0.4 6.3 1 135.8 11.1 247.6 127 265.6 261 0.2 1.6 0.4 3 0.5 4.3h-0.7c0.1 0.7 0.2 1.4 0.2 2.2 0 13.1-10.6 23.6-23.6 23.6-13 0-23.6-10.4-23.6-23.5z\" p-id=\"20428\" fill=\"#1296db\"></path></svg>", "name": "light", "type": "number", "unit": "lux", "order": 3, "field_name": "light"}, "relay1": {"icon": "<svg t=\"1758627797189\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"21489\" width=\"200\" height=\"200\"><path d=\"M652.899 189.266c-16.036-7.058-34.761 0.22-41.82 16.258-7.059 16.038 0.221 34.761 16.258 41.819 104.649 46.06 172.27 149.682 172.27 263.991 0 77-29.986 149.392-84.434 203.839s-126.839 84.434-203.839 84.434-149.393-29.986-203.84-84.434c-54.448-54.447-84.433-126.839-84.433-203.839 0-114.963 68.159-218.821 173.642-264.591 16.075-6.975 23.451-25.659 16.477-41.733-6.975-16.075-25.662-23.452-41.734-16.477-128.688 55.837-211.839 182.544-211.839 322.8 0 47.469 9.304 93.535 27.653 136.917 17.717 41.887 43.073 79.499 75.365 111.791 32.292 32.291 69.903 57.647 111.791 75.364 43.383 18.35 89.449 27.653 136.918 27.653 47.468 0 93.535-9.304 136.917-27.653 41.888-17.717 79.499-43.073 111.791-75.364 32.291-32.292 57.647-69.904 75.364-111.791 18.35-43.383 27.653-89.448 27.653-136.917 0.001-139.458-82.493-265.877-210.16-322.067z\" fill=\"#1296db\" p-id=\"21490\"></path><path d=\"M512 479.517c17.522 0 31.727-14.205 31.727-31.727V128.228c0-17.522-14.204-31.727-31.727-31.727s-31.727 14.205-31.727 31.727V447.79c0 17.522 14.205 31.727 31.727 31.727z\" fill=\"#1296db\" p-id=\"21491\"></path></svg>", "name": "switch1", "type": "number", "unit": "", "order": 6, "field_name": "relay1"}, "relay2": {"icon": "<svg t=\"1758627797189\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"21489\" width=\"200\" height=\"200\"><path d=\"M652.899 189.266c-16.036-7.058-34.761 0.22-41.82 16.258-7.059 16.038 0.221 34.761 16.258 41.819 104.649 46.06 172.27 149.682 172.27 263.991 0 77-29.986 149.392-84.434 203.839s-126.839 84.434-203.839 84.434-149.393-29.986-203.84-84.434c-54.448-54.447-84.433-126.839-84.433-203.839 0-114.963 68.159-218.821 173.642-264.591 16.075-6.975 23.451-25.659 16.477-41.733-6.975-16.075-25.662-23.452-41.734-16.477-128.688 55.837-211.839 182.544-211.839 322.8 0 47.469 9.304 93.535 27.653 136.917 17.717 41.887 43.073 79.499 75.365 111.791 32.292 32.291 69.903 57.647 111.791 75.364 43.383 18.35 89.449 27.653 136.918 27.653 47.468 0 93.535-9.304 136.917-27.653 41.888-17.717 79.499-43.073 111.791-75.364 32.291-32.292 57.647-69.904 75.364-111.791 18.35-43.383 27.653-89.448 27.653-136.917 0.001-139.458-82.493-265.877-210.16-322.067z\" fill=\"#1296db\" p-id=\"21490\"></path><path d=\"M512 479.517c17.522 0 31.727-14.205 31.727-31.727V128.228c0-17.522-14.204-31.727-31.727-31.727s-31.727 14.205-31.727 31.727V447.79c0 17.522 14.205 31.727 31.727 31.727z\" fill=\"#1296db\" p-id=\"21491\"></path></svg>", "name": "switch2", "type": "number", "unit": "", "order": 7, "field_name": "relay2"}, "relay3": {"icon": "<svg t=\"1758627797189\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"21489\" width=\"200\" height=\"200\"><path d=\"M652.899 189.266c-16.036-7.058-34.761 0.22-41.82 16.258-7.059 16.038 0.221 34.761 16.258 41.819 104.649 46.06 172.27 149.682 172.27 263.991 0 77-29.986 149.392-84.434 203.839s-126.839 84.434-203.839 84.434-149.393-29.986-203.84-84.434c-54.448-54.447-84.433-126.839-84.433-203.839 0-114.963 68.159-218.821 173.642-264.591 16.075-6.975 23.451-25.659 16.477-41.733-6.975-16.075-25.662-23.452-41.734-16.477-128.688 55.837-211.839 182.544-211.839 322.8 0 47.469 9.304 93.535 27.653 136.917 17.717 41.887 43.073 79.499 75.365 111.791 32.292 32.291 69.903 57.647 111.791 75.364 43.383 18.35 89.449 27.653 136.918 27.653 47.468 0 93.535-9.304 136.917-27.653 41.888-17.717 79.499-43.073 111.791-75.364 32.291-32.292 57.647-69.904 75.364-111.791 18.35-43.383 27.653-89.448 27.653-136.917 0.001-139.458-82.493-265.877-210.16-322.067z\" fill=\"#1296db\" p-id=\"21490\"></path><path d=\"M512 479.517c17.522 0 31.727-14.205 31.727-31.727V128.228c0-17.522-14.204-31.727-31.727-31.727s-31.727 14.205-31.727 31.727V447.79c0 17.522 14.205 31.727 31.727 31.727z\" fill=\"#1296db\" p-id=\"21491\"></path></svg>", "name": "switch3", "type": "number", "unit": "", "order": 8, "field_name": "relay3"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 9, "field_name": "status"}, "humidity": {"icon": "<svg t=\"1758347519822\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"3979\" width=\"200\" height=\"200\"><path d=\"M784.818037 464.149179l0.688685 0.415462L521.206174 34.767851 256.923022 464.565664l0.734734-0.480954c-43.695175 56.418964-69.969585 127.013789-69.969585 203.88762 0 184.197162 149.322887 333.522096 333.518003 333.522096 184.213535 0 333.535399-149.324934 333.535399-333.522096C854.741573 591.113849 828.483536 520.535397 784.818037 464.149179zM521.206174 923.30667c-141.011594 0-255.334339-114.322745-255.334339-255.335363 0-70.080102 28.256554-133.515876 73.966619-179.657776l-0.063445 0 161.005974-248.52526 20.424168-33.035394 35.81674 63.209624 135.324058 208.890564c51.588959 46.715975 84.209914 114.016777 84.209914 189.118242C776.556886 808.983925 662.235165 923.30667 521.206174 923.30667z\" p-id=\"3980\" fill=\"#1296db\"></path><path d=\"M480.100988 640.306224c10.867512-12.145621 16.302291-27.966958 16.302291-47.468105 0-19.61064-4.924149-34.890648-14.784728-45.868677-9.860579-10.980076-23.573905-16.461927-41.154305-16.461927-18.331507 0-32.891108 5.960759-43.710524 17.900695-10.82044 11.93789-16.22145 28.0171-16.22145 48.267307 0 18.651802 5.113461 33.611515 15.343453 44.909839 10.227945 11.298324 23.861454 16.940834 40.914852 16.940834C454.799742 658.526191 469.231429 652.453892 480.100988 640.306224zM414.093645 626.88147c-5.960759-7.465019-8.949836-18.059308-8.949836-31.804357 0-13.954827 3.067872-24.853038 9.188266-32.685423 6.121418-7.830339 14.464433-11.744485 25.012673-11.744485 10.339486 0 18.34788 3.755534 24.052812 11.266601 5.705955 7.511067 8.549723 18.140149 8.549723 31.884175 0 14.06432-2.907213 24.963555-8.710382 32.683377-5.8001 7.720845-14.031575 11.587919-24.691355 11.587919C428.207084 638.069277 420.054403 634.346489 414.093645 626.88147z\" p-id=\"3981\" fill=\"#1296db\"></path><path d=\"M588.61954 657.088446c-18.219967 0-32.729425 6.0416-43.550888 18.140149-10.819416 12.099572-16.223496 28.256554-16.223496 48.504714 0 18.331507 5.082762 33.211403 15.263635 44.671409 10.181897 11.45796 23.847128 17.180288 40.995693 17.180288 17.691941 0 32.012088-6.0416 42.993187-18.140149 10.980076-12.099572 16.46295-27.841092 16.46295-47.227628 0-20.024056-4.954849-35.561937-14.863523-46.588061S606.0884 657.088446 588.61954 657.088446zM611.394243 753.301741c-5.8001 7.782244-14.031575 11.665691-24.691355 11.665691-10.339486 0-18.492166-3.755534-24.452925-11.266601-5.960759-7.511067-8.949836-17.97949-8.949836-31.404244 0-13.954827 2.989077-24.853038 8.949836-32.683377 5.959735-7.832386 14.382569-11.747555 25.252127-11.747555 10.116405 0 18.092054 3.675716 23.892153 11.028171 5.803169 7.351432 8.710382 17.947767 8.710382 31.804357C620.103602 734.649939 617.197412 745.518474 611.394243 753.301741z\" p-id=\"3982\" fill=\"#1296db\"></path><path d=\"M577.592392 534.184255 418.567539 783.347035 445.260481 783.347035 604.283288 534.184255Z\" p-id=\"3983\" fill=\"#1296db\"></path></svg>", "name": "humidity", "type": "number", "unit": "%", "order": 1, "field_name": "humidity"}, "temperatrue": {"icon": "<svg t=\"1758077725642\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6151\" width=\"200\" height=\"200\"><path d=\"M613.14042 610.221648V118.112778c0-56.482882-45.952284-102.438363-102.435166-102.438363-56.489276 0-102.444757 45.955481-102.444756 102.438363v492.10887c-67.051844 37.087272-109.637788 108.461328-109.637789 185.685717 0 116.939515 95.139833 212.076151 212.082545 212.076151 116.936318 0 212.072954-95.136636 212.072955-212.076151 0-77.230783-42.582748-148.601642-109.637789-185.685717zM510.705254 963.226874c-92.262621 0-167.325903-75.060086-167.325903-167.319509 0-64.75327 37.963223-124.298786 96.719104-151.699441a22.378321 22.378321 0 0 0 12.918685-20.281153v-214.250045h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-16.633487c0-31.805988 25.87893-57.681721 57.688114-57.68172 31.802791 0 57.678524 25.875733 57.678524 57.68172v505.813993a22.371927 22.371927 0 0 0 12.921882 20.281153c58.752683 27.394262 96.715906 86.939777 96.715907 151.699441 0 92.262621-75.060086 167.322706-167.316313 167.322706z\" fill=\"#009FE8\" p-id=\"6152\"></path><path d=\"M622.884581 777.151135a22.378321 22.378321 0 0 0-22.378321 22.378321c0 49.520027-40.287372 89.807399-89.8074 89.807399s-89.807399-40.287372-89.807399-89.807399c0-34.756729 20.380257-66.719366 51.917705-81.428316a22.378321 22.378321 0 0 0-18.912878-40.565503c-47.237439 22.029859-77.761469 69.913072-77.761469 121.990622 0 74.196922 60.363922 134.564041 134.564041 134.564041s134.564041-60.363922 134.564042-134.564041a22.378321 22.378321 0 0 0-22.378321-22.375124z\" fill=\"#009FE8\" p-id=\"6153\"></path></svg>", "name": "temperatrue", "type": "number", "unit": "℃", "order": 0, "field_name": "temperatrue"}}}', '{}', '{"fields": {"co2": {"rpcs": [], "unit": "partsPerMillion", "field_name": "co2", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "co2"}, "pir": {"rpcs": [], "unit": "noUnits", "field_name": "pir", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "pir"}, "pm25": {"rpcs": [], "unit": "microgramsPerCubicMeter", "field_name": "pm25", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "pm25"}, "tvoc": {"rpcs": [], "unit": "noUnits", "field_name": "tvoc", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "tvoc"}, "light": {"rpcs": [], "unit": "luxes", "field_name": "light", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "light"}, "relay1": {"rpcs": [], "unit": "noUnits", "field_name": "relay1", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "relay1"}, "relay2": {"rpcs": [], "unit": "noUnits", "field_name": "relay2", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "relay2"}, "relay3": {"rpcs": [], "unit": "noUnits", "field_name": "relay3", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "relay3"}, "humidity": {"rpcs": [], "unit": "percentRelativeHumidity", "field_name": "humidity", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "humidity"}, "temperatrue": {"rpcs": [], "unit": "degreesCelsius", "field_name": "temperatrue", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "temperatrue"}}}', 'CUSTOMER', '{"fields": {"co2": {"name": "co2", "extra": {}, "component": "sensor", "field_name": "co2", "unit_of_measurement": "ppm"}, "pir": {"name": "pir", "extra": {}, "component": "sensor", "field_name": "pir"}, "pm25": {"name": "pm25", "extra": {}, "component": "sensor", "field_name": "pm25", "unit_of_measurement": "ug/m³"}, "tvoc": {"name": "tvoc", "extra": {}, "component": "sensor", "field_name": "tvoc"}, "light": {"name": "light", "extra": {}, "component": "sensor", "field_name": "light", "unit_of_measurement": "lux"}, "relay1": {"name": "relay1", "extra": {}, "component": "sensor", "field_name": "relay1"}, "relay2": {"name": "relay2", "extra": {}, "component": "sensor", "field_name": "relay2"}, "relay3": {"name": "relay3", "extra": {}, "component": "sensor", "field_name": "relay3"}, "humidity": {"name": "humidity", "extra": {}, "component": "sensor", "field_name": "humidity", "unit_of_measurement": "%"}, "temperatrue": {"name": "temperatrue", "extra": {}, "component": "sensor", "field_name": "temperatrue", "unit_of_measurement": "℃"}}}', 'mt_ks61', 'ANY');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('23052087352889349', 'MT-DTU-Emeter', ' let payload = Buffer.from(msg?.userdata?.payload, "base64");
    let port=msg?.userdata?.port;
    let preTelemetry = device?.telemetry_data?.[thingModelId];
    function parseTelemetry(payload){

        if (port!=12||payload[0]!=0x21||payload[1]!=0x05) { return {sdevice:null,tdata:null}}
        if (payload.length <39) {return {sdevice:null,tdata:null}}
        if ((payload[38]&0x01)==0x01) {return {sdevice:null,tdata:null}}
        let telemetryData={}
        let subDevice=payload.readUInt32LE(2).toString(10).padStart(12, ''0'')
        telemetryData.ua=Number((payload.readUInt16LE(10)/10).toFixed(1))
        telemetryData.ub=Number((payload.readUInt16LE(12)/10).toFixed(1))
        telemetryData.uc=Number((payload.readUInt16LE(14)/10).toFixed(1))
        telemetryData.ia=Number((payload.readUInt16LE(16)/10).toFixed(1))
        telemetryData.ib=Number((payload.readUInt16LE(18)/10).toFixed(1))
        telemetryData.ic=Number((payload.readUInt16LE(20)/10).toFixed(1))
        telemetryData.yz=Number((payload.readUInt32LE(22)/10).toFixed(1))
        telemetryData.yf=Number((payload.readUInt32LE(26)/10).toFixed(1))
        telemetryData.wz=Number((payload.readUInt32LE(30)/10).toFixed(1))
        telemetryData.wf=Number((payload.readUInt32LE(34)/10).toFixed(1))
        return {
            sdevice: subDevice,
            tdata: telemetryData
        }
    }
    let appData= parseTelemetry(payload)
    return {
        sub_device: appData.sdevice,
        telemetry_data: appData.tdata,
        server_attrs:  (appData.sdevice===null)?null:{"sub_addr":appData.sdevice},
        shared_attrs: null
    }', 'mtfac', '
return {
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,DTU,Emeter}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"ia": {"icon": "<svg t=\"1758627235459\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"4756\" width=\"200\" height=\"200\"><path d=\"M861.49632 586.16832c-41.07264 193.13152-230.9376 316.40064-424.06912 275.328-193.1264-41.07264-316.40064-230.9376-275.328-424.06912 41.07776-193.1264 230.9376-316.40064 424.06912-275.32288 56.832 12.0832 107.61728 37.05344 149.9392 71.20384 5.28384 4.25984 12.92288 4.13696 17.88416-0.49664 5.75488-5.36576 5.62688-14.5408-0.4864-19.50208-45.61408-37.00224-100.43392-64.0512-161.82784-77.1072-207.4368-44.11904-411.36128 88.27904-455.4752 295.71584-44.11904 207.44192 88.27904 411.3664 295.71584 455.48032 207.44192 44.11392 411.3664-88.28416 455.48032-295.72096a384.1024 384.1024 0 0 0 7.06048-113.14688c-0.74752-8.58624-9.55392-13.8496-17.6128-10.8032-5.71904 2.16576-9.21088 7.936-8.69888 14.0288a357.62176 357.62176 0 0 1-6.65088 104.41216z\" fill=\"#1296db\" p-id=\"4757\"></path><path d=\"M859.76064 429.33248c1.88928 7.95136 10.28096 12.65664 17.92512 9.76384 6.0416-2.28352 9.55392-8.62208 8.07936-14.90944a383.90272 383.90272 0 0 0-13.87008-45.9008c-2.77504-7.45984-11.58656-10.48576-18.52928-6.58432-5.8368 3.28192-8.29952 10.38848-5.98016 16.67584a357.30432 357.30432 0 0 1 12.37504 40.96zM774.7072 249.70752c5.2224-4.87424 13.39392-4.73088 18.2528 0.50176a386.0992 386.0992 0 0 1 56.56576 78.82752c3.35872 6.20544 0.98816 13.89056-5.16096 17.34656-6.59968 3.70688-14.93504 1.11616-18.56-5.5296a359.40864 359.40864 0 0 0-51.63008-71.94624c-5.07392-5.49376-4.93568-14.10048 0.53248-19.2zM473.17504 312.32c11.70944-34.71872 60.82048-34.71872 72.52992 0l144.24064 374.5024c8.00768 20.7872-7.33696 43.136-29.60896 43.136a31.72352 31.72352 0 0 1-29.81376-20.87424l-30.3616-83.38432a5.12512 5.12512 0 0 0-4.8128-3.36896H422.94784a5.12 5.12 0 0 0-4.8128 3.36896l-30.42816 83.56352a31.45728 31.45728 0 0 1-29.55776 20.69504c-22.08256 0-37.29408-22.15936-29.35808-42.76736L473.17504 312.32z m-31.9744 250.47552a5.12 5.12 0 0 0 4.80768 6.89152h126.30016a5.12 5.12 0 0 0 4.8128-6.87616L511.01184 381.85472a1.67424 1.67424 0 1 0-3.14368 0l-66.6624 180.9408z\" fill=\"#1296db\" p-id=\"4758\"></path></svg>", "name": "ia", "type": "number", "unit": "A", "order": 4, "field_name": "ia"}, "ib": {"icon": "<svg t=\"1758627235459\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"4756\" width=\"200\" height=\"200\"><path d=\"M861.49632 586.16832c-41.07264 193.13152-230.9376 316.40064-424.06912 275.328-193.1264-41.07264-316.40064-230.9376-275.328-424.06912 41.07776-193.1264 230.9376-316.40064 424.06912-275.32288 56.832 12.0832 107.61728 37.05344 149.9392 71.20384 5.28384 4.25984 12.92288 4.13696 17.88416-0.49664 5.75488-5.36576 5.62688-14.5408-0.4864-19.50208-45.61408-37.00224-100.43392-64.0512-161.82784-77.1072-207.4368-44.11904-411.36128 88.27904-455.4752 295.71584-44.11904 207.44192 88.27904 411.3664 295.71584 455.48032 207.44192 44.11392 411.3664-88.28416 455.48032-295.72096a384.1024 384.1024 0 0 0 7.06048-113.14688c-0.74752-8.58624-9.55392-13.8496-17.6128-10.8032-5.71904 2.16576-9.21088 7.936-8.69888 14.0288a357.62176 357.62176 0 0 1-6.65088 104.41216z\" fill=\"#1296db\" p-id=\"4757\"></path><path d=\"M859.76064 429.33248c1.88928 7.95136 10.28096 12.65664 17.92512 9.76384 6.0416-2.28352 9.55392-8.62208 8.07936-14.90944a383.90272 383.90272 0 0 0-13.87008-45.9008c-2.77504-7.45984-11.58656-10.48576-18.52928-6.58432-5.8368 3.28192-8.29952 10.38848-5.98016 16.67584a357.30432 357.30432 0 0 1 12.37504 40.96zM774.7072 249.70752c5.2224-4.87424 13.39392-4.73088 18.2528 0.50176a386.0992 386.0992 0 0 1 56.56576 78.82752c3.35872 6.20544 0.98816 13.89056-5.16096 17.34656-6.59968 3.70688-14.93504 1.11616-18.56-5.5296a359.40864 359.40864 0 0 0-51.63008-71.94624c-5.07392-5.49376-4.93568-14.10048 0.53248-19.2zM473.17504 312.32c11.70944-34.71872 60.82048-34.71872 72.52992 0l144.24064 374.5024c8.00768 20.7872-7.33696 43.136-29.60896 43.136a31.72352 31.72352 0 0 1-29.81376-20.87424l-30.3616-83.38432a5.12512 5.12512 0 0 0-4.8128-3.36896H422.94784a5.12 5.12 0 0 0-4.8128 3.36896l-30.42816 83.56352a31.45728 31.45728 0 0 1-29.55776 20.69504c-22.08256 0-37.29408-22.15936-29.35808-42.76736L473.17504 312.32z m-31.9744 250.47552a5.12 5.12 0 0 0 4.80768 6.89152h126.30016a5.12 5.12 0 0 0 4.8128-6.87616L511.01184 381.85472a1.67424 1.67424 0 1 0-3.14368 0l-66.6624 180.9408z\" fill=\"#1296db\" p-id=\"4758\"></path></svg>", "name": "ib", "type": "number", "unit": "A", "order": 5, "field_name": "ib"}, "ic": {"icon": "<svg t=\"1758627235459\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"4756\" width=\"200\" height=\"200\"><path d=\"M861.49632 586.16832c-41.07264 193.13152-230.9376 316.40064-424.06912 275.328-193.1264-41.07264-316.40064-230.9376-275.328-424.06912 41.07776-193.1264 230.9376-316.40064 424.06912-275.32288 56.832 12.0832 107.61728 37.05344 149.9392 71.20384 5.28384 4.25984 12.92288 4.13696 17.88416-0.49664 5.75488-5.36576 5.62688-14.5408-0.4864-19.50208-45.61408-37.00224-100.43392-64.0512-161.82784-77.1072-207.4368-44.11904-411.36128 88.27904-455.4752 295.71584-44.11904 207.44192 88.27904 411.3664 295.71584 455.48032 207.44192 44.11392 411.3664-88.28416 455.48032-295.72096a384.1024 384.1024 0 0 0 7.06048-113.14688c-0.74752-8.58624-9.55392-13.8496-17.6128-10.8032-5.71904 2.16576-9.21088 7.936-8.69888 14.0288a357.62176 357.62176 0 0 1-6.65088 104.41216z\" fill=\"#1296db\" p-id=\"4757\"></path><path d=\"M859.76064 429.33248c1.88928 7.95136 10.28096 12.65664 17.92512 9.76384 6.0416-2.28352 9.55392-8.62208 8.07936-14.90944a383.90272 383.90272 0 0 0-13.87008-45.9008c-2.77504-7.45984-11.58656-10.48576-18.52928-6.58432-5.8368 3.28192-8.29952 10.38848-5.98016 16.67584a357.30432 357.30432 0 0 1 12.37504 40.96zM774.7072 249.70752c5.2224-4.87424 13.39392-4.73088 18.2528 0.50176a386.0992 386.0992 0 0 1 56.56576 78.82752c3.35872 6.20544 0.98816 13.89056-5.16096 17.34656-6.59968 3.70688-14.93504 1.11616-18.56-5.5296a359.40864 359.40864 0 0 0-51.63008-71.94624c-5.07392-5.49376-4.93568-14.10048 0.53248-19.2zM473.17504 312.32c11.70944-34.71872 60.82048-34.71872 72.52992 0l144.24064 374.5024c8.00768 20.7872-7.33696 43.136-29.60896 43.136a31.72352 31.72352 0 0 1-29.81376-20.87424l-30.3616-83.38432a5.12512 5.12512 0 0 0-4.8128-3.36896H422.94784a5.12 5.12 0 0 0-4.8128 3.36896l-30.42816 83.56352a31.45728 31.45728 0 0 1-29.55776 20.69504c-22.08256 0-37.29408-22.15936-29.35808-42.76736L473.17504 312.32z m-31.9744 250.47552a5.12 5.12 0 0 0 4.80768 6.89152h126.30016a5.12 5.12 0 0 0 4.8128-6.87616L511.01184 381.85472a1.67424 1.67424 0 1 0-3.14368 0l-66.6624 180.9408z\" fill=\"#1296db\" p-id=\"4758\"></path></svg>", "name": "ic", "type": "number", "unit": "A", "order": 6, "field_name": "ic"}, "ua": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "ua", "type": "number", "unit": "V", "order": 1, "field_name": "ua"}, "ub": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "ub", "type": "number", "unit": "V", "order": 2, "field_name": "ub"}, "uc": {"icon": "<svg t=\"1758627280472\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5834\" width=\"200\" height=\"200\"><path d=\"M512 723.2c-19.2 0-38.4-6.4-44.8-19.2L262.4 345.6c-6.4-12.8 6.4-32 25.6-44.8 19.2-6.4 44.8 0 57.6 19.2L512 614.4 678.4 320c6.4-19.2 38.4-25.6 57.6-19.2 19.2 6.4 32 25.6 25.6 44.8L556.8 704c-6.4 12.8-25.6 19.2-44.8 19.2z\" p-id=\"5835\" fill=\"#1296db\"></path><path d=\"M512 1024c-281.6 0-512-230.4-512-512s230.4-512 512-512c108.8 0 211.2 32 300.8 96 12.8 12.8 19.2 32 6.4 44.8s-32 19.2-44.8 6.4C697.6 89.6 608 64 512 64 262.4 64 64 262.4 64 512s198.4 448 448 448 448-198.4 448-448c0-76.8-19.2-153.6-57.6-224-6.4-12.8-6.4-32 12.8-44.8 12.8-6.4 32-6.4 44.8 12.8 38.4 76.8 64 166.4 64 256 0 281.6-230.4 512-512 512z\" p-id=\"5836\" fill=\"#1296db\"></path></svg>", "name": "uc", "type": "number", "unit": "V", "order": 3, "field_name": "uc"}, "wf": {"icon": "<svg t=\"1758627362545\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"8603\" width=\"200\" height=\"200\"><path d=\"M554.666667 341.333333v128h85.333333l-128 213.333334V554.666667h-85.333333l128-213.333334z m384 170.666667c0 234.666667-192 426.666667-426.666667 426.666667S85.333333 746.666667 85.333333 512 277.333333 85.333333 512 85.333333v128c-166.4 0-298.666667 132.266667-298.666667 298.666667s132.266667 298.666667 298.666667 298.666667 298.666667-132.266667 298.666667-298.666667h128z m-46.933334 42.666667h-42.666666c-21.333333 166.4-166.4 298.666667-337.066667 298.666666-187.733333 0-341.333333-153.6-341.333333-341.333333C170.666667 337.066667 302.933333 196.266667 469.333333 174.933333v-42.666666C277.333333 153.6 128 315.733333 128 512c0 213.333333 170.666667 384 384 384 196.266667 0 358.4-149.333333 379.733333-341.333333z m-89.6-106.666667l123.733334-29.866667C891.733333 256 763.733333 128 601.6 93.866667l-29.866667 123.733333c119.466667 29.866667 204.8 115.2 230.4 230.4z\" fill=\"#1296db\" p-id=\"8604\"></path></svg>", "name": "wf", "type": "number", "unit": "kvarh", "order": 10, "field_name": "wf"}, "wz": {"icon": "<svg t=\"1758627362545\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"8603\" width=\"200\" height=\"200\"><path d=\"M554.666667 341.333333v128h85.333333l-128 213.333334V554.666667h-85.333333l128-213.333334z m384 170.666667c0 234.666667-192 426.666667-426.666667 426.666667S85.333333 746.666667 85.333333 512 277.333333 85.333333 512 85.333333v128c-166.4 0-298.666667 132.266667-298.666667 298.666667s132.266667 298.666667 298.666667 298.666667 298.666667-132.266667 298.666667-298.666667h128z m-46.933334 42.666667h-42.666666c-21.333333 166.4-166.4 298.666667-337.066667 298.666666-187.733333 0-341.333333-153.6-341.333333-341.333333C170.666667 337.066667 302.933333 196.266667 469.333333 174.933333v-42.666666C277.333333 153.6 128 315.733333 128 512c0 213.333333 170.666667 384 384 384 196.266667 0 358.4-149.333333 379.733333-341.333333z m-89.6-106.666667l123.733334-29.866667C891.733333 256 763.733333 128 601.6 93.866667l-29.866667 123.733333c119.466667 29.866667 204.8 115.2 230.4 230.4z\" fill=\"#1296db\" p-id=\"8604\"></path></svg>", "name": "wz", "type": "number", "unit": "kvarh", "order": 9, "field_name": "wz"}, "yf": {"icon": "<svg t=\"1758627362545\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"8603\" width=\"200\" height=\"200\"><path d=\"M554.666667 341.333333v128h85.333333l-128 213.333334V554.666667h-85.333333l128-213.333334z m384 170.666667c0 234.666667-192 426.666667-426.666667 426.666667S85.333333 746.666667 85.333333 512 277.333333 85.333333 512 85.333333v128c-166.4 0-298.666667 132.266667-298.666667 298.666667s132.266667 298.666667 298.666667 298.666667 298.666667-132.266667 298.666667-298.666667h128z m-46.933334 42.666667h-42.666666c-21.333333 166.4-166.4 298.666667-337.066667 298.666666-187.733333 0-341.333333-153.6-341.333333-341.333333C170.666667 337.066667 302.933333 196.266667 469.333333 174.933333v-42.666666C277.333333 153.6 128 315.733333 128 512c0 213.333333 170.666667 384 384 384 196.266667 0 358.4-149.333333 379.733333-341.333333z m-89.6-106.666667l123.733334-29.866667C891.733333 256 763.733333 128 601.6 93.866667l-29.866667 123.733333c119.466667 29.866667 204.8 115.2 230.4 230.4z\" fill=\"#1296db\" p-id=\"8604\"></path></svg>", "name": "yf", "type": "number", "unit": "kWh", "order": 8, "field_name": "yf"}, "yz": {"icon": "<svg t=\"1758627362545\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"8603\" width=\"200\" height=\"200\"><path d=\"M554.666667 341.333333v128h85.333333l-128 213.333334V554.666667h-85.333333l128-213.333334z m384 170.666667c0 234.666667-192 426.666667-426.666667 426.666667S85.333333 746.666667 85.333333 512 277.333333 85.333333 512 85.333333v128c-166.4 0-298.666667 132.266667-298.666667 298.666667s132.266667 298.666667 298.666667 298.666667 298.666667-132.266667 298.666667-298.666667h128z m-46.933334 42.666667h-42.666666c-21.333333 166.4-166.4 298.666667-337.066667 298.666666-187.733333 0-341.333333-153.6-341.333333-341.333333C170.666667 337.066667 302.933333 196.266667 469.333333 174.933333v-42.666666C277.333333 153.6 128 315.733333 128 512c0 213.333333 170.666667 384 384 384 196.266667 0 358.4-149.333333 379.733333-341.333333z m-89.6-106.666667l123.733334-29.866667C891.733333 256 763.733333 128 601.6 93.866667l-29.866667 123.733333c119.466667 29.866667 204.8 115.2 230.4 230.4z\" fill=\"#1296db\" p-id=\"8604\"></path></svg>", "name": "yz", "type": "number", "unit": "kWh", "order": 7, "field_name": "yz"}}}', '{}', '{"fields": {"ia": {"rpcs": [], "unit": "amperes", "field_name": "ia", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "ia"}, "ib": {"rpcs": [], "unit": "amperes", "field_name": "ib", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "ib"}, "ic": {"rpcs": [], "unit": "amperes", "field_name": "ic", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "ic"}, "ua": {"rpcs": [], "unit": "volts", "field_name": "ua", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "ua"}, "ub": {"rpcs": [], "unit": "volts", "field_name": "ub", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "ub"}, "uc": {"rpcs": [], "unit": "volts", "field_name": "uc", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "uc"}, "wf": {"rpcs": [], "unit": "kilovoltAmpereHours", "field_name": "wf", "object_type": "analogValue", "cov_increment": 0, "default_value": 0, "object_name_suffix": "wf"}, "wz": {"rpcs": [], "unit": "kilovoltAmpereHours", "field_name": "wz", "object_type": "analogValue", "cov_increment": 0, "default_value": 0, "object_name_suffix": "wz"}, "yf": {"rpcs": [], "unit": "kilowattHours", "field_name": "yf", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "yf"}, "yz": {"rpcs": [], "unit": "kilowattHours", "field_name": "yz", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "yz"}}}', 'CUSTOMER', '{"fields": {"ia": {"name": "ia", "extra": {}, "component": "sensor", "field_name": "ia", "unit_of_measurement": "A"}, "ib": {"name": "ib", "extra": {}, "component": "sensor", "field_name": "ib", "unit_of_measurement": "A"}, "ic": {"name": "ic", "extra": {}, "component": "sensor", "field_name": "ic", "unit_of_measurement": "A"}, "ua": {"name": "ua", "extra": {}, "component": "sensor", "field_name": "ua", "unit_of_measurement": "V"}, "ub": {"name": "ub", "extra": {}, "component": "sensor", "field_name": "ub", "unit_of_measurement": "V"}, "uc": {"name": "uc", "extra": {}, "component": "sensor", "field_name": "uc", "unit_of_measurement": "V"}, "wf": {"name": "wf", "extra": {}, "component": "sensor", "field_name": "wf", "unit_of_measurement": "kvarh"}, "wz": {"name": "wz", "extra": {}, "component": "sensor", "field_name": "wz", "unit_of_measurement": "kvarh"}, "yf": {"name": "yf", "extra": {}, "component": "sensor", "field_name": "yf", "unit_of_measurement": "kWh"}, "yz": {"name": "yz", "extra": {}, "component": "sensor", "field_name": "yz", "unit_of_measurement": "kWh"}}}', 'mt_dtu_emeter', 'SUB_DEVICE');
INSERT INTO "system_base"."thing_model" ("id", "name", "payload_parser", "tenant_code", "outer_forward", "inner_forward_enabled", "outer_forward_enabled", "update_time", "tags", "params", "system_params", "telemetry_config", "translate", "bacnet_config", "payload_parser_type", "ha_config", "id_name", "apply_to") VALUES ('22321109718274053', 'MT-KS52', 'let isTKL=true
    let payload
    let port
    if (typeof msg === ''undefined'') {
        isTKL=false
        payload = input.bytes
        port = input.fport
    }else {
        payload = Buffer.from(msg?.userdata?.payload, "base64");
        port=msg?.userdata?.port || null;
    }
    function parseSharedAttrs(payload) {
        if (port!=214||payload[0]!=0x2F) { return null}
        let shared_attrs = {};
        if (payload.length<5) { return null}
        shared_attrs.content = payload.toString(''hex'');
        let size=payload.length-4
        let regAddress=payload[2]
        for (let i=0; i<size; i++) {
            regAddress=payload[2]+i
            switch (regAddress) {
                case  58:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_data = payload.readUInt16LE(4+i)
                    break;
                case 142:
                    if  ( size<(2+i) ) { break }
                    shared_attrs.period_measure = payload.readUInt16LE(4+i)
                    break;
                case 144:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_temperatrue = payload.readUInt8(4+i)*0.1
                    break;
                case 145:
                    if  ( size<(1+i) ) { break }
                    shared_attrs.cov_humidity = payload.readUInt8(4+i)*0.1
                    break;
                default: break
            }
        }
        if (Object.keys(shared_attrs).length == 0) {
            return null
        }
        return shared_attrs;
    }
    function parseTelemetry(payload){
        if (port!=11||payload[0]!=0x21||payload[1]!=0x07||payload[2]!=0x03||payload.length !=15){
            return null
        }
        let telemetry_data = {};
        telemetry_data.period_data =payload.readUInt16LE(5)
        telemetry_data.status ="normal"
        if ((payload[7]&0x01)!=0){  telemetry_data.status ="fault" }
        telemetry_data.temperatrue=Number(((payload.readUInt16LE(8)-1000)/10.00).toFixed(2))
        telemetry_data.humidity=Number((payload.readUInt16LE(10)/10.0).toFixed(2))
        let vbat=payload.readUInt8(12)
        telemetry_data.vbat=Number(((vbat*1.6)/254 +2.0).toFixed(2))
        telemetry_data.rssi=msg.gwrx[0].rssi
        telemetry_data.snr=msg.gwrx[0].lsnr
        return telemetry_data
    }
    let tdata=parseTelemetry(payload)
    let sdata=parseSharedAttrs(payload)
    if (tdata?.period_data!=null){
        if (sdata===null) {sdata={}}
        sdata.period_data = tdata.period_data
    }
    if (isTKL) {
        return {
            telemetry_data: tdata,
            server_attrs: null,
            shared_attrs: sdata
        }
    }
    return {
        data:tdata
    }', 'mtfac', '
return {
  ...device.telemetry_data
}
', NULL, NULL, '2025-12-22 06:25:17.686+00', '{ManThink,Temperature,Humidity}', '{}', '{"client_attrs": {}, "shared_attrs": {}}', '{"fields": {"snr": {"icon": "<svg t=\"1758435259426\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5839\" width=\"200\" height=\"200\"><path d=\"M298.666667 789.333333V234.666667h42.666666v554.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5840\"></path><path d=\"M300.906667 478.869333l-106.666667-213.333333 38.186667-19.072 106.666666 213.333333-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5841\"></path><path d=\"M339.093333 478.869333l106.666667-213.333333-38.186667-19.072-106.666666 213.333333 38.186666 19.072zM682.666667 789.333333V362.666667h42.666666v426.666666h-42.666666z\" fill=\"#1296db\" p-id=\"5842\"></path><path d=\"M684.906667 559.936l-85.333334-170.666667 38.186667-19.072 85.333333 170.666667-38.186666 19.072z\" fill=\"#1296db\" p-id=\"5843\"></path><path d=\"M723.093333 559.936l85.333334-170.666667-38.186667-19.072-85.333333 170.666667 38.186666 19.072zM533.333333 128v768h-42.666666V128h42.666666z\" fill=\"#1296db\" p-id=\"5844\"></path><path d=\"M128 149.333333a21.333333 21.333333 0 0 1 21.333333-21.333333h725.333334a21.333333 21.333333 0 0 1 21.333333 21.333333v725.333334a21.333333 21.333333 0 0 1-21.333333 21.333333H149.333333a21.333333 21.333333 0 0 1-21.333333-21.333333V149.333333z m42.666667 21.333334v682.666666h682.666666V170.666667H170.666667z\" fill=\"#1296db\" p-id=\"5845\"></path></svg>", "name": "SNR", "type": "number", "unit": "dB", "order": 4, "field_name": "snr"}, "rssi": {"icon": "<svg t=\"1758435292502\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6054\" width=\"200\" height=\"200\"><path d=\"M34.048 648.704h132.1472v207.616H34.048zM241.92 535.4496h132.1472v320.8704H241.92z\" fill=\"#1296db\" p-id=\"6055\"></path><path d=\"M449.7408 412.8768h132.1472v443.4432H449.7408zM657.6128 290.304h132.096v566.016h-132.096z\" fill=\"#1296db\" p-id=\"6056\"></path><path d=\"M865.4336 167.7312h132.096v688.5888h-132.096z\" fill=\"#1296db\" p-id=\"6057\"></path></svg>", "name": "RSSI", "type": "number", "unit": "dBm", "order": 3, "field_name": "rssi"}, "vbat": {"icon": "<svg t=\"1758355813974\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"5140\" width=\"200\" height=\"200\"><path d=\"M229.437808 137.515153l565.137325 0 0 869.673988-565.137325 0 0-869.673988Z\" fill=\"#1296db\" p-id=\"5141\"></path><path d=\"M756.488638 1024H267.524303A54.949119 54.949119 0 0 1 212.626949 969.115588V175.614589A54.949119 54.949119 0 0 1 267.511362 120.730177h488.977276a54.949119 54.949119 0 0 1 54.884413 54.884412v793.500999a54.949119 54.949119 0 0 1-54.884413 54.884412z m-488.977276-869.661047a21.301519 21.301519 0 0 0-21.236813 21.275636v793.500999a21.301519 21.301519 0 0 0 21.275637 21.275636h488.938452a21.301519 21.301519 0 0 0 21.275637-21.275636V175.614589a21.301519 21.301519 0 0 0-21.275637-21.275636H267.524303z\" fill=\"#1296db\" p-id=\"5142\"></path><path d=\"M307.021409 256.912368l409.970123 0 0 630.8925-409.970123 0 0-630.8925Z\" fill=\"#1296db\" p-id=\"5143\"></path><path d=\"M678.905038 904.602785H345.094962a54.949119 54.949119 0 0 1-54.819705-54.87147V294.998863a54.949119 54.949119 0 0 1 54.884412-54.884413h333.745369a54.949119 54.949119 0 0 1 54.884412 54.884413V849.731315a54.949119 54.949119 0 0 1-54.884412 54.87147zM345.094962 273.710285a21.301519 21.301519 0 0 0-21.275636 21.275636V849.731315a21.301519 21.301519 0 0 0 21.275636 21.275636h333.810076a21.301519 21.301519 0 0 0 21.275636-21.275636V294.998863a21.301519 21.301519 0 0 0-21.275636-21.288578H345.094962z\" fill=\"#1296db\" p-id=\"5144\"></path><path d=\"M374.018957 16.797917l275.987969 0 0 120.717236-275.987969 0 0-120.717236Z\" fill=\"#1296db\" p-id=\"5145\"></path><path d=\"M611.920431 154.326012H412.092511a54.949119 54.949119 0 0 1-54.884413-54.884413V54.884412A54.949119 54.949119 0 0 1 412.092511 0h199.82792a54.949119 54.949119 0 0 1 54.884412 54.884412v44.557187a54.949119 54.949119 0 0 1-54.884412 54.884413zM412.092511 33.608776a21.301519 21.301519 0 0 0-21.275637 21.275636v44.557187a21.301519 21.301519 0 0 0 21.275637 21.275637h199.82792a21.301519 21.301519 0 0 0 21.301519-21.275637V54.884412a21.301519 21.301519 0 0 0-21.275637-21.275636H412.092511z\" fill=\"#1296db\" p-id=\"5146\"></path><path d=\"M503.601041 525.74375l-13.433157-136.751611 124.327882 157.936658-94.083866 63.516316 31.926396 141.60463-142.821121-181.528802 94.083866-44.777191z\" fill=\"#1296db\" p-id=\"5147\"></path><path d=\"M552.338296 768.860602a16.8238 16.8238 0 0 1-13.213154-6.470692L396.304021 580.912873a16.8238 16.8238 0 0 1 5.97892-25.559234l83.407224-39.704169-12.281374-125.000834a16.8238 16.8238 0 0 1 29.920481-12.035487l124.340824 157.884892a16.8238 16.8238 0 0 1-3.804767 24.316862l-84.546066 57.136213 29.402826 130.410333a16.8238 16.8238 0 0 1-16.383793 20.499153zM435.710538 576.668099l83.886055 106.624068-15.529662-69.145818a16.8238 16.8238 0 0 1 6.988348-17.613225l79.058919-53.383211-77.648308-98.587468 7.764831 79.563632a16.8238 16.8238 0 0 1-9.498977 16.8238z\" fill=\"#1296db\" p-id=\"5148\"></path></svg>", "name": "baterry voltage", "type": "number", "unit": "v", "order": 2, "field_name": "vbat"}, "status": {"icon": "<svg t=\"1758435346218\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"7076\" width=\"200\" height=\"200\"><path d=\"M187.97568 565.98528c14.88896 73.1648 51.58912 138.98752 106.09664 190.31552a32.68608 32.68608 0 0 0 27.1872 8.56064 32.7424 32.7424 0 0 0 23.60832-16.00512l42.56768-73.72288a32.768 32.768 0 0 0-4.096-38.36928 214.13376 214.13376 0 0 1-47.39072-86.06208 32.75264 32.75264 0 0 0-31.55456-24.00256H220.05248a32.68096 32.68096 0 0 0-25.34912 12.03712 32.65024 32.65024 0 0 0-6.72768 27.24864zM621.11744 717.53728a32.70656 32.70656 0 0 0-35.3536-15.64672 210.88256 210.88256 0 0 1-106.46016-4.22912 32.78336 32.78336 0 0 0-37.90848 14.9504l-41.78944 72.4224a32.74752 32.74752 0 0 0-2.42688 27.48416 32.62464 32.62464 0 0 0 19.44576 19.57376c39.58784 14.62272 81.40288 22.0416 124.2368 22.0416 35.41504 0 70.37952-5.11488 103.89504-15.22176a32.82944 32.82944 0 0 0 20.992-19.28192 32.73216 32.73216 0 0 0-2.0992-28.4416l-42.53184-73.6512zM771.584 217.3696a32.70144 32.70144 0 0 0-20.96128-7.60832c-1.89952 0-3.83488 0.19968-5.7344 0.52736a32.73728 32.73728 0 0 0-22.59968 15.872l-41.8816 72.47872a32.80384 32.80384 0 0 0 6.00064 40.30976 210.65216 210.65216 0 0 1 59.36128 98.19136 32.768 32.768 0 0 0 31.58528 24.07424h84.352a32.75776 32.75776 0 0 0 25.3184-12.00128 32.62464 32.62464 0 0 0 6.75328-27.22304c-16.09728-79.7696-59.48928-152.44288-122.19392-204.6208zM665.74848 168.27392a32.76288 32.76288 0 0 0-20.992-19.28704 359.80288 359.80288 0 0 0-103.89504-15.25248c-42.83392 0-84.64896 7.41376-124.2368 22.03648a32.78336 32.78336 0 0 0-17.01888 47.104l41.78944 72.41216a32.78336 32.78336 0 0 0 37.90848 14.9504 210.7392 210.7392 0 0 1 61.56288-9.14944c14.98624 0 30.1056 1.6384 44.89728 4.8896a32.74752 32.74752 0 0 0 35.3536-15.61088l42.53696-73.66144a32.70656 32.70656 0 0 0 2.09408-28.43136zM861.70624 526.6944h-84.352a32.73216 32.73216 0 0 0-31.58528 24.06912 210.74944 210.74944 0 0 1-59.36128 98.19648 32.73728 32.73728 0 0 0-6.00064 40.2688l41.8816 72.50944a32.70144 32.70144 0 0 0 22.59968 15.87712c1.89952 0.32768 3.83488 0.49152 5.7344 0.49152a32.67584 32.67584 0 0 0 20.96128-7.57248c62.70464-52.21376 106.09664-124.85632 122.19392-204.61568a32.6144 32.6144 0 0 0-6.75328-27.22304 32.6656 32.6656 0 0 0-25.3184-12.00128zM194.69824 449.17248a32.69632 32.69632 0 0 0 25.34912 12.03712h84.352a32.75776 32.75776 0 0 0 31.55456-24.00256 214.15424 214.15424 0 0 1 47.39072-86.0928 32.7168 32.7168 0 0 0 4.096-38.33856L344.87296 239.0528a32.8704 32.8704 0 0 0-23.60832-16.03584 32.70656 32.70656 0 0 0-4.75648-0.32768c-8.26368 0-16.3328 3.1488-22.43072 8.91904C239.5648 282.9312 202.86464 348.7488 187.97568 421.91872a32.68608 32.68608 0 0 0 6.72256 27.25376z\" fill=\"#1296db\" p-id=\"7077\"></path></svg>", "name": "status", "type": "string", "unit": "", "order": 5, "field_name": "status"}, "humidity": {"icon": "<svg t=\"1758347519822\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"3979\" width=\"200\" height=\"200\"><path d=\"M784.818037 464.149179l0.688685 0.415462L521.206174 34.767851 256.923022 464.565664l0.734734-0.480954c-43.695175 56.418964-69.969585 127.013789-69.969585 203.88762 0 184.197162 149.322887 333.522096 333.518003 333.522096 184.213535 0 333.535399-149.324934 333.535399-333.522096C854.741573 591.113849 828.483536 520.535397 784.818037 464.149179zM521.206174 923.30667c-141.011594 0-255.334339-114.322745-255.334339-255.335363 0-70.080102 28.256554-133.515876 73.966619-179.657776l-0.063445 0 161.005974-248.52526 20.424168-33.035394 35.81674 63.209624 135.324058 208.890564c51.588959 46.715975 84.209914 114.016777 84.209914 189.118242C776.556886 808.983925 662.235165 923.30667 521.206174 923.30667z\" p-id=\"3980\" fill=\"#1296db\"></path><path d=\"M480.100988 640.306224c10.867512-12.145621 16.302291-27.966958 16.302291-47.468105 0-19.61064-4.924149-34.890648-14.784728-45.868677-9.860579-10.980076-23.573905-16.461927-41.154305-16.461927-18.331507 0-32.891108 5.960759-43.710524 17.900695-10.82044 11.93789-16.22145 28.0171-16.22145 48.267307 0 18.651802 5.113461 33.611515 15.343453 44.909839 10.227945 11.298324 23.861454 16.940834 40.914852 16.940834C454.799742 658.526191 469.231429 652.453892 480.100988 640.306224zM414.093645 626.88147c-5.960759-7.465019-8.949836-18.059308-8.949836-31.804357 0-13.954827 3.067872-24.853038 9.188266-32.685423 6.121418-7.830339 14.464433-11.744485 25.012673-11.744485 10.339486 0 18.34788 3.755534 24.052812 11.266601 5.705955 7.511067 8.549723 18.140149 8.549723 31.884175 0 14.06432-2.907213 24.963555-8.710382 32.683377-5.8001 7.720845-14.031575 11.587919-24.691355 11.587919C428.207084 638.069277 420.054403 634.346489 414.093645 626.88147z\" p-id=\"3981\" fill=\"#1296db\"></path><path d=\"M588.61954 657.088446c-18.219967 0-32.729425 6.0416-43.550888 18.140149-10.819416 12.099572-16.223496 28.256554-16.223496 48.504714 0 18.331507 5.082762 33.211403 15.263635 44.671409 10.181897 11.45796 23.847128 17.180288 40.995693 17.180288 17.691941 0 32.012088-6.0416 42.993187-18.140149 10.980076-12.099572 16.46295-27.841092 16.46295-47.227628 0-20.024056-4.954849-35.561937-14.863523-46.588061S606.0884 657.088446 588.61954 657.088446zM611.394243 753.301741c-5.8001 7.782244-14.031575 11.665691-24.691355 11.665691-10.339486 0-18.492166-3.755534-24.452925-11.266601-5.960759-7.511067-8.949836-17.97949-8.949836-31.404244 0-13.954827 2.989077-24.853038 8.949836-32.683377 5.959735-7.832386 14.382569-11.747555 25.252127-11.747555 10.116405 0 18.092054 3.675716 23.892153 11.028171 5.803169 7.351432 8.710382 17.947767 8.710382 31.804357C620.103602 734.649939 617.197412 745.518474 611.394243 753.301741z\" p-id=\"3982\" fill=\"#1296db\"></path><path d=\"M577.592392 534.184255 418.567539 783.347035 445.260481 783.347035 604.283288 534.184255Z\" p-id=\"3983\" fill=\"#1296db\"></path></svg>", "name": "humidity", "type": "number", "unit": "RH%", "order": 1, "field_name": "humidity"}, "temperatrue": {"icon": "<svg t=\"1758077725642\" class=\"icon\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" p-id=\"6151\" width=\"200\" height=\"200\"><path d=\"M613.14042 610.221648V118.112778c0-56.482882-45.952284-102.438363-102.435166-102.438363-56.489276 0-102.444757 45.955481-102.444756 102.438363v492.10887c-67.051844 37.087272-109.637788 108.461328-109.637789 185.685717 0 116.939515 95.139833 212.076151 212.082545 212.076151 116.936318 0 212.072954-95.136636 212.072955-212.076151 0-77.230783-42.582748-148.601642-109.637789-185.685717zM510.705254 963.226874c-92.262621 0-167.325903-75.060086-167.325903-167.319509 0-64.75327 37.963223-124.298786 96.719104-151.699441a22.378321 22.378321 0 0 0 12.918685-20.281153v-214.250045h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-31.96903h57.68172a22.378321 22.378321 0 1 0 0-44.756642h-57.68172v-16.633487c0-31.805988 25.87893-57.681721 57.688114-57.68172 31.802791 0 57.678524 25.875733 57.678524 57.68172v505.813993a22.371927 22.371927 0 0 0 12.921882 20.281153c58.752683 27.394262 96.715906 86.939777 96.715907 151.699441 0 92.262621-75.060086 167.322706-167.316313 167.322706z\" fill=\"#009FE8\" p-id=\"6152\"></path><path d=\"M622.884581 777.151135a22.378321 22.378321 0 0 0-22.378321 22.378321c0 49.520027-40.287372 89.807399-89.8074 89.807399s-89.807399-40.287372-89.807399-89.807399c0-34.756729 20.380257-66.719366 51.917705-81.428316a22.378321 22.378321 0 0 0-18.912878-40.565503c-47.237439 22.029859-77.761469 69.913072-77.761469 121.990622 0 74.196922 60.363922 134.564041 134.564041 134.564041s134.564041-60.363922 134.564042-134.564041a22.378321 22.378321 0 0 0-22.378321-22.375124z\" fill=\"#009FE8\" p-id=\"6153\"></path></svg>", "name": "temperatrue", "type": "number", "unit": "℃", "order": 0, "field_name": "temperatrue"}}}', '{}', '{"fields": {"snr": {"rpcs": [], "unit": "noUnits", "field_name": "snr", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "snr"}, "rssi": {"rpcs": [], "unit": "noUnits", "field_name": "rssi", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "rssi"}, "vbat": {"rpcs": [], "unit": "volts", "field_name": "vbat", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "vbat"}, "humidity": {"rpcs": [], "unit": "percentRelativeHumidity", "field_name": "humidity", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "humidity"}, "temperatrue": {"rpcs": [], "unit": "degreesCelsius", "field_name": "temperatrue", "object_type": "analogInput", "cov_increment": 0, "default_value": 0, "object_name_suffix": "temperatrue"}}}', 'CUSTOMER', '{"fields": {"snr": {"name": "snr", "extra": {}, "component": "sensor", "field_name": "snr", "unit_of_measurement": "dB"}, "rssi": {"name": "rssi", "extra": {}, "component": "sensor", "field_name": "rssi", "unit_of_measurement": "dBm"}, "vbat": {"name": "vbat", "extra": {}, "component": "sensor", "field_name": "vbat", "unit_of_measurement": "v"}, "status": {"name": "status", "extra": {}, "component": "sensor", "field_name": "status", "unit_of_measurement": ""}, "humidity": {"name": "humidity", "extra": {}, "component": "sensor", "field_name": "humidity", "unit_of_measurement": "RH%"}, "temperatrue": {"name": "temperatrue", "extra": {}, "component": "sensor", "field_name": "temperatrue", "unit_of_measurement": "℃"}}}', 'mt_ks52', 'ANY');


--  RPC
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('44112566355496965', '{}', 'function encode(params) {
        let buffer = Buffer.from("8902004E", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] get all paras', '', '{}', '2025-12-22 06:25:25.202+00', 'mtget_cf_all_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41935819161735173', '{}', 'function encode(params) {
        let buffer = Buffer.from("89020002", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] get excnf', '', '{}', '2025-12-22 06:25:25.202+00', 'mtget_cf_excnf', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41886965276086277', '{}', 'function encode(params) {
        let buffer = Buffer.from("81024F0C", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":0,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT FW] get paras', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_fw_para', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41886445295636485', '{"reTx": {"name": "reTx", "type": "number", "alias": "reTx", "order": 1, "options": [], "dftValue": 5}, "swPublic": {"name": "swPublic", "type": "boolean", "alias": "swPublic", "order": 8, "options": [], "dftValue": true}, "devTimeReqDuty": {"name": "devTimeReqDuty", "type": "number", "alias": "devTimeReqDuty", "order": 7, "options": [], "dftValue": 255}}', 'function encode(params) {
        let buffer =Buffer.alloc(16)
        buffer[0]=0xC1;buffer[1]=0x0E;buffer[2]=0x4F;buffer[3]=0x0C
        buffer[4]=params.reTx;
        buffer[5]=0
        //buffer[5]=params.globalDutyRate;
        buffer.writeUint16LE(0,6)
        buffer.writeUint16LE(0,8)
        buffer.writeUint16LE(0,10)
        buffer.writeUint16LE(0,12)
        buffer[14]=params.devTimeReqDuty
        buffer[15]=6
        if (params.swPublic) {
            buffer[15]=0x07
        }
        //buffer.writeUint16LE(params.dutyBand1,6)
        //buffer.writeUint16LE(params.dutyBand2,8)
        //buffer.writeUint16LE(params.dutyBand3,10)
        //buffer.writeUint16LE(params.dutyBand4,11)
        return buffer.toString("base64");
    }
    let payload=encode(params);
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": payload,
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT FW] set paras', '', '{}', '2025-12-22 06:25:25.203+00', 'mtset_fw_para', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41601231033995269', '{"baudRate": {"name": "baudRate", "type": "number", "unit": "bps", "alias": "baudRate", "order": 1, "options": [{"id": 1763031935547, "label": "38400", "value": 38400}, {"id": 1763031943879, "label": "19200", "value": 19200}, {"id": 1763031951563, "label": "9600", "value": 9600}, {"id": 1763031961635, "label": "4800", "value": 4800}, {"id": 1763031968738, "label": "2400", "value": 2400}, {"id": 1763031975615, "label": "1200", "value": 1200}], "dftValue": 9600}, "dataBits": {"name": "dataBits", "type": "number", "alias": "dataBits", "order": 2, "options": [], "dftValue": 8}, "stopBits": {"name": "stopBits", "type": "number", "alias": "stopBits", "order": 3, "options": [], "dftValue": 1}, "checkBits": {"name": "checkBits", "type": "number", "alias": "checkBits", "order": 4, "options": [{"id": 1763032081596, "label": "none", "value": 0}, {"id": 1763032084495, "label": "odd", "value": 1}, {"id": 1763032096167, "label": "even", "value": 2}], "dftValue": 0}}', 'function encode(params) {
        let buffer = Buffer.from("CF040C020000", "hex")
        let baudRate = params.baudRate/1200;
        buffer.writeUint8(baudRate,4)
        buffer[5]=(params.dataBits)&0x0F
        let stopBits=(params.stopBits&0x03)<<4
        buffer[5]|=stopBits;
        let checkBits=(params.checkBits&0x03)<<6
        buffer[5]|=checkBits;
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] set uart', '', '{}', '2025-12-22 06:25:25.203+00', 'mtset_app_uart', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41526370722910213', '{"data": {"name": "data", "type": "string", "alias": "data", "order": 1, "options": [], "dftValue": "C70403123456"}, "swBW": {"name": "swBW", "type": "string", "unit": "kHz", "alias": "swBW", "order": 4, "options": [{"id": 1764290860172, "label": "125", "value": "125"}, {"id": 1764290864294, "label": "250", "value": "250"}, {"id": 1764290869773, "label": "500", "value": "500"}], "dftValue": "500"}, "swSF": {"name": "swSF", "type": "string", "alias": "swSF", "order": 3, "options": [{"id": 1764290727213, "label": "5", "value": 5}, {"id": 1764290732209, "label": "6", "value": 6}, {"id": 1764290734864, "label": "7", "value": 7}, {"id": 1764290738418, "label": "8", "value": 8}, {"id": 1764290740984, "label": "9", "value": 9}, {"id": 1764290744209, "label": "10", "value": 10}, {"id": 1764290748884, "label": "11", "value": 11}, {"id": 1764290753477, "label": "12", "value": 12}], "dftValue": "7"}, "swFreq": {"name": "swFreq", "type": "number", "unit": "Hz", "alias": "swFreq", "order": 2, "options": [], "dftValue": 923300000}, "swPeriod": {"name": "swPeriod", "type": "number", "unit": "ms", "alias": "swPeriod", "order": 5, "options": [], "dftValue": 8000}}', '  function crc16Modbus(buf,  len, poly=0xa001) {
    let i,j;
    let crc;
    for(i=0,crc=0xffff;i< len;i++)
    {
        crc ^= buf[i];
        for(j=0;j<8;j++)
        {
            if(crc & 0x01)  crc = (crc >> 1) ^ poly;
            else            crc >>= 1;
            crc&=0xFFFF
        }
    }
    return crc&0xFFFF;
  }
  function encode(msg) {
      let rawCmdBuf = Buffer.from(params.data.replaceAll(" ", ""), "hex")
      if (rawCmdBuf.length<1) {
          throw new Error("no data to download");
          return ""
      }
      let cmdBuf = Buffer.alloc(5+rawCmdBuf.length)
      cmdBuf[0]=0xFF;cmdBuf[1]=0xAA
      rawCmdBuf.copy(cmdBuf,2)
      let crc=crc16Modbus(cmdBuf,rawCmdBuf.length+2)
      cmdBuf.writeUInt16LE(crc,2+rawCmdBuf.length)
      cmdBuf[4+rawCmdBuf.length]=0x40
      let payBuffer =Buffer.alloc(9+cmdBuf.length);
      payBuffer[0]=0xdc
      let devEuiBuffer=Buffer.from(device.eui,''hex'')
      let devEui=devEuiBuffer.readBigUInt64BE(0)
      payBuffer.writeBigUint64LE(devEui,1)
      cmdBuf.copy(payBuffer,9);
      return payBuffer.toString("base64");
  }
  function timingPerformanceCalc(sf, bw, swPeriod) {
    let minSf = 5;
    let maxSf = 12;
    let bwList = [500, 250, 125]; 
    let baseSymbolTime = 0.064;
    if (sf < minSf) sf = 5;
    if (sf > maxSf) sf = 12;
    if (!bwList.includes(bw)) bw = 500;
    let powerOf2 =  ((sf - minSf) + (bwList.indexOf(bw)))

    let symbolTime = baseSymbolTime * (2 ** powerOf2);
    return Math.ceil((swPeriod + 300) / symbolTime)

  }

  let sf = Number(params?.swSF == "NC" ? device?.shared_attrs?.swSF : params?.swSF);
  let bw = Number(params?.swBW == "NC" ? device?.shared_attrs?.swBW.replace("kHz", "") : params?.swBW);
  
  let swPeriod = Number(params?.swPeriod || device?.shared_attrs?.swPeriod);
  let freq = Number(params?.swFreq ||  device?.shared_attrs?.swFreq) / 1000000;
  let datr = `SF` + sf + "BW" + bw
  let prea = timingPerformanceCalc(sf, bw, swPeriod);

  return [
      {
          sleepTimeMs: 0,
          dnMsg: {
              "version":"3.0",
              "type":params.type,
              "if":"loraSW",
              "moteeui": device.eui,
              "token": new Date().getTime(),
              "userdata":{
                  "payload":encode(params),
                  "specify": {
                    txpk: {
                        "imme": true,  
                        "tmst": 0,   
                        "tmms": 0,  
                        "time": "", 
                        "rfch": 0,  
                        "powe": 22, 
                        "modu": "LORA",  
                        "codr": "4/5",  
                        "fdev": 0, 
                        "ipol": false,  
                        "ncrc": false,
                        freq,
                        datr,
                        prea
                    }
                    
                  }
              }
          }
      }
  ]', '{}', 'mtfac', '[MT SW] data down', '', '{}', '2025-12-22 06:25:25.203+00', 'mt_sw_dn', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('35431228547010565', '{}', ' function encode(params) {
        let buffer = Buffer.from("CF043D020807", "hex")
        buffer.writeUInt16LE(params.period,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": encode(params),
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }

        }
    ]', '{}', 'mtfac', '[MT APP] get data period', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_period_data', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41239002052825093', '{"bw": {"name": "bw", "type": "number", "alias": "BW", "order": 2, "options": [{"id": 1762997445489, "label": "500kHz", "value": "9"}, {"id": 1762997464472, "label": "250kHz", "value": 8}, {"id": 1762997474523, "label": "125kHz", "value": 7}], "dftValue": 7}, "sf": {"name": "sf", "type": "number", "alias": "SF", "order": 1, "options": [], "dftValue": 9}, "swFreq": {"name": "swFreq", "type": "number", "unit": "Hz", "alias": "swFreq", "order": 3, "options": [], "dftValue": 901300000}, "swPeriod": {"name": "swPeriod", "type": "number", "unit": "ms", "alias": "swPeriod", "order": 4, "options": [], "dftValue": 3000}, "upRepeat": {"name": "upRepeat", "type": "number", "alias": "upRepeat", "order": 5, "options": [], "dftValue": 1}}', ' function encode(params) {
        let buffer =Buffer.alloc(12)
        buffer[0]=0xC9;buffer[1]=0x0A;buffer[2]=0x3C;buffer[3]=0x08
        buffer[4]=params.sf;
        buffer[5]=params.bw;
        buffer.writeUint32LE(params.swFreq,6)
        buffer[10]=params.swPeriod/50;
        buffer[11]=params.upRepeat
        return buffer.toString("base64");
    }
    let payload=encode(params);
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": payload,
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] set sw paras ', '', '{}', '2025-12-22 06:25:25.203+00', 'mtset_cf_sw', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41214202022465541', '{}', 'function encode(params) {
        let buffer = Buffer.from("89023C08", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":0,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] get sw para', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_cf_sw', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41212245631307781', '{"appSkey": {"name": "appSkey", "type": "string", "alias": "appSkey", "order": 3, "options": [], "dftValue": "f1f2f3f4f5f6f7f8f1f2f3f4f5f6f7f9"}, "nkwSkey": {"name": "nkwSkey", "type": "string", "alias": "nkwSkey", "order": 2, "options": [], "dftValue": "f1f2f3f4f5f6f7f8f1f2f3f4f5f6f7f8"}, "gbroadAddr": {"name": "gbroadAddr", "type": "string", "alias": "gbroadAddr", "order": 1, "options": [], "dftValue": "f1000001"}}', 'function encode(params) {
        let buffer =Buffer.alloc(40)
        buffer[0]=0xC9;buffer[1]=0x26;buffer[2]=0x02;buffer[3]=0x24
        if (params.gbroadAddr?.length!=8) {
            throw new Error("wrong gbroadAddr")
            return ""
        }
        if (params.nkwSkey?.replaceAll(" ","").length!=32) {
            throw new Error("wrong nkwSkey")
            return ""
        }
        if (params.appSkey?.replaceAll(" ","").length!=32) {
            throw new Error("wrong appSkey")
            return ""
        }
        let gbroadAddr=parseInt(params.gbroadAddr, 16)
        buffer.writeUInt32LE(gbroadAddr,4)
        let nkwSkeyBuffer=Buffer.from(params.nkwSkey.replaceAll(" ",""),"hex")
        nkwSkeyBuffer.copy(buffer,8)
        let appSkeyBuffer=Buffer.from(params.appSkey.replaceAll(" ",""),"hex")
        appSkeyBuffer.copy(buffer,24)
        return buffer.toString("base64");
    }
    let payload=encode(params);
    if (payload.length<1) { return null}
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": payload,
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] set gbroad para', '', '{}', '2025-12-22 06:25:25.203+00', 'mtset_cf_gbroad', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('41207876781346821', '{}', 'function encode(params) {
        let buffer = Buffer.from("89020224", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":0,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT CF] get gbroad para', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_cf_gbroad', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('38534049215549445', '{"freq1": {"name": "freq1", "type": "string", "unit": "", "alias": "freq1", "order": 1, "options": [], "dftValue": "923200000,0,5,true"}, "freq2": {"name": "freq2", "type": "string", "alias": "freq2", "order": 2, "options": [], "dftValue": "923400000,0,5,true"}, "freq3": {"name": "freq3", "type": "string", "alias": "freq3", "order": 3, "options": [], "dftValue": "923600000,0,5,true"}, "freq4": {"name": "freq4", "type": "string", "alias": "freq4", "order": 4, "options": [], "dftValue": "923800000,0,5,true"}, "freq5": {"name": "freq5", "type": "string", "alias": "freq5", "order": 5, "options": [], "dftValue": "924000000,0,5,true"}, "freq6": {"name": "freq6", "type": "string", "alias": "freq6", "order": 6, "options": [], "dftValue": "924200000,0,5,true"}, "freq7": {"name": "freq7", "type": "string", "alias": "freq7", "order": 7, "options": [], "dftValue": "924600000,0,5,true"}, "freq8": {"name": "freq8", "type": "string", "alias": "freq8", "order": 8, "options": [], "dftValue": "924800000,0,5,true"}, "freq9": {"name": "freq9", "type": "string", "alias": "freq9", "order": 9, "options": [], "dftValue": "925000000,0,5,false"}, "power": {"name": "power", "type": "number", "alias": "power", "order": 0, "options": [], "dftValue": 22}, "freq10": {"name": "freq10", "type": "string", "alias": "freq10", "order": 10, "options": [], "dftValue": "925200000,0,5,false"}, "freq11": {"name": "freq11", "type": "string", "alias": "freq11", "order": 11, "options": [], "dftValue": "925400000,0,5,false"}, "freq12": {"name": "freq12", "type": "string", "alias": "freq12", "order": 12, "options": [], "dftValue": "925600000,0,5,false"}, "freq13": {"name": "freq13", "type": "string", "alias": "freq13", "order": 13, "options": [], "dftValue": "925800000,0,5,false"}, "freq14": {"name": "freq14", "type": "string", "alias": "freq14", "order": 14, "options": [], "dftValue": "926000000,0,5,false"}, "freq15": {"name": "freq15", "type": "string", "alias": "freq15", "order": 15, "options": [], "dftValue": "926200000,0,5,false"}, "freq16": {"name": "freq16", "type": "string", "alias": "freq16", "order": 16, "options": [], "dftValue": "926400000,0,5,false\t"}}', ' const strToBoolean = (str) => {
        return str.toLowerCase() === "true";
    }
    function getFreq(value){
        if (!value) {return null }
        let freq=value.replaceAll(" ","").split(",")
        if (freq.length!=4){
            return null
        }
        let drRangeL=parseInt(freq[1])
        let drRangeH=parseInt(freq[2])
        return {
            freq: parseInt(freq[0]),
            drRange: drRangeL|(drRangeH<<4),
            enable:strToBoolean(freq[3]),
        }
    }
    function encode(params) {
        let buffer = Buffer.alloc(87)
        buffer[0]=0xC2;buffer[1]=85;buffer[2]=5;buffer[3]=83
        buffer.writeUint8(params.power,6)
        let channelMap=0
        for (let i=0; i<16; i++) {
            let freq=getFreq(params["freq" + (i+1)])
            if(!freq) throw Error("freq" + (i+1));
            buffer.writeUint32LE(freq.freq,i*5+7)
            buffer.writeUint8(freq.drRange,i*5+11)
            if (freq.enable){ channelMap|=(1<<i) }
        }
        if (channelMap==0){
            return ""
        }
        buffer.writeUInt16LE(channelMap,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT RADIO] set frequencies', '', '{}', '2025-12-22 06:25:25.203+00', 'mtset_radio_para', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('38273241294311429', '{}', 'function encode(params) {
        let buffer = Buffer.from("82020059", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT RADIO] get frequencies', 'to get specify frequencies paras of  ManThink''s LoRaWAN devices ', '{}', '2025-12-22 06:25:25.203+00', 'mtget_frequencies', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24231031439626245', '{}', 'function encode(msg) {
    let buffer = Buffer.from("CF03090104", "hex")
    return buffer.toString("base64");
    }
return [
    {
        sleepTimeMs: 0,
        dnMsg: {
            "version":"3.0",
            "type":"data",
            "if":"loraWAN",
            "moteeui": device.eui,
            "token": new Date().getTime(),
            "userdata":{
                "confirmed":false,
                "fpend":false,
                "port":214,
                "TxUTCtime":"",
                "payload":encode(params),
                "dnWaitms":0,
                "type":"data",
                "intervalms":0
            }
        }
    }
]', '{}', 'mtfac', '[MT APP] join', '', '{}', '2025-12-22 06:25:25.204+00', 'mt_app_join', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('28944881661513733', '{"data": {"name": "data", "type": "string", "alias": "data", "order": 2, "dftValue": "1234"}, "port": {"name": "port", "type": "number", "alias": "port", "order": 1, "dftValue": 12}, "type": {"name": "type", "type": "string", "alias": "type", "order": 4, "options": [{"id": 1761604165663, "label": "data", "value": "data"}, {"id": 1761604173431, "label": "dataClear", "value": "dataClear"}], "dftValue": "data"}, "confirmed": {"name": "confirmed", "type": "boolean", "alias": "confirmed", "order": 2, "dftValue": false}}', 'function encode(msg) {
        let buffer = Buffer.from(params.data.replaceAll(" ", ""), "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":params.type,
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":params.confirmed,
                    "fpend":false,
                    "port":params.port,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":0,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT DATA] down data', '', '{}', '2025-12-22 06:25:25.203+00', 'mt_dn_data', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24846903489335301', '{}', 'function encode(params) {
        let buffer = Buffer.from("8F027801", "hex")
        buffer[2]=60
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] get multi device count', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_app_device_count', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24597181948235781', '{"is_hex": {"name": "is_hex", "type": "boolean", "alias": "is Hex", "order": 1, "dftValue": true}, "sub_addr1": {"name": "sub_addr1", "type": "string", "alias": "addr 1", "order": 2, "dftValue": "nc"}, "sub_addr2": {"name": "sub_addr2", "type": "string", "alias": "addr 2", "order": 3, "dftValue": "nc"}, "sub_addr3": {"name": "sub_addr3", "type": "string", "alias": "addr 3", "order": 4, "dftValue": "nc"}, "sub_addr4": {"name": "sub_addr4", "type": "string", "alias": "addr 4", "order": 5, "dftValue": "nc"}, "sub_addr5": {"name": "sub_addr5", "type": "string", "alias": "addr 5", "order": 6, "dftValue": "nc"}, "sub_addr6": {"name": "sub_addr6", "type": "string", "alias": "addr 6", "order": 7, "dftValue": "nc"}, "query_index": {"name": "query_index", "type": "number", "alias": "query index", "order": 8, "dftValue": 0}, "sub_addr_size": {"name": "sub_addr_size", "type": "number", "alias": "length of addr", "order": 9, "dftValue": 4}}', 'let classMode = (device && device.shared_attrs && device.shared_attrs.class_mode) || "ClassA";
    let sleepMs = classMode === "ClassA" ? 0 : 5000;
    let isClassA = classMode === "ClassA";

    function processSubAddr(subAddr, subAddrSize, isHex) {
        let num;
        try {
            num = isHex ? parseInt(subAddr, 16) : parseInt(subAddr, 10);
            if (isNaN(num)) { throw new Error("Invalid number"); }
        } catch (e) { num = 0; }
        subAddrSize = Number(subAddrSize) || 1;
        const buffer = Buffer.alloc(subAddrSize);
        let hexStr = num.toString(16);
        if (hexStr.length % 2 !== 0) { hexStr = ''0'' + hexStr; }
        const numBuffer = Buffer.from(hexStr, ''hex'');
        if (numBuffer.length > subAddrSize) {
            console.warn(''subAddr '' + subAddr + '' exceeds size '' + subAddrSize + '', truncating'');
        }
        const startPos = Math.max(0, numBuffer.length - subAddrSize);
        const offset = Math.max(0, subAddrSize - numBuffer.length);
        numBuffer.copy(buffer, offset, startPos);
        return buffer;
    }

    function encode(params) {
        let queryIndex = params.query_index || 0;
        let subAddrSize = params.sub_addr_size || 1;
        let deviceCounts = 0;
        for (let i = 1; i <= 6; i++) {
            if (!params[''sub_addr'' + i]) { break; }
            const saddr = params[''sub_addr'' + i].trim().toLowerCase();
            if (saddr=== ""||saddr=="nc") {
                break;
            }
            deviceCounts++;
        }
        let buffer = Buffer.alloc(6 + subAddrSize * deviceCounts);
        buffer[0] = 0xCF;
        buffer[1] = 4 + subAddrSize * deviceCounts;
        buffer[2] = 120;
        buffer[3] = subAddrSize * deviceCounts+2;
        buffer.writeUInt8(queryIndex, 4);
        buffer.writeUInt8(subAddrSize, 5);
        for (let i = 0; i < deviceCounts; i++) {
            const subAddr = params[''sub_addr'' + (i + 1)];
            const payload = processSubAddr(subAddr, subAddrSize, params.is_hex);
            payload.copy(buffer, 6 + i * subAddrSize);
        }
        let devCountsBuffer = Buffer.from([0xCF, 0x03, 0x3C, 0x01, deviceCounts]);
        return {
            subAddrReg: buffer.toString("base64"),
            deviceCounts: devCountsBuffer.toString("base64")
        };
    }

    let retData = encode(params);
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": isClassA,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": retData.subAddrReg,
                    "dnWaitms": 3000,
                    "type": "data",
                    "intervalms": 0
                }
            }
        },
        {
            sleepTimeMs: sleepMs,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": retData.deviceCounts,
                    "dnWaitms": 3000,
                    "type": "data",
                    "intervalms": 0
                }
            }
        }
    ];', '{}', 'mtfac', '[MT APP] configure multi devices', 'set paras of multi devices', '{}', '2025-12-22 06:25:25.203+00', 'mtset_dtu_multi_device', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24577580598300677', '{"addr_len": {"name": "addr_len", "type": "number", "alias": "length of addr", "order": 2, "options": [], "dftValue": 4}, "device_counts": {"name": "device_counts", "type": "number", "alias": "counts of device", "order": 0, "dftValue": 6}}', 'function encode(params) {
        let buffer = Buffer.from("8F027814", "hex")
        buffer.writeUInt8(2+(params.addr_len)*(params.device_counts),3)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ];', '{}', 'mtfac', '[MT APP] get multi devices', '', '{}', '2025-12-22 06:25:25.203+00', 'mtget_app_multi_device_para', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24574845555576837', '{}', ' function encode(params) {
        let buffer = Buffer.from("8F023A0C", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": false,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": encode(params),
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }

        }
    ]', '{}', 'mtfac', '[MT APP] get heart period ', '', '{}', '2025-12-22 06:25:25.204+00', 'mtget_period_heart', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24232175968718853', '{"payload": {"name": "payload", "type": "string", "alias": "payload", "order": 0}}', 'function encode(params) {
        let buffer = Buffer.from(params.payload.replaceAll(" ",""), "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":51,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] transparent', 'transparent data by 51 port', '{}', '2025-12-22 06:25:25.204+00', 'mt_data_transparent', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24230824261980165', '{}', 'function encode(msg) {
    let buffer = Buffer.from("CF03090102", "hex")
    return buffer.toString("base64");
    }
    return [
    {
        sleepTimeMs: 0,
        dnMsg: {
            "version":"3.0",
            "type":"data",
            "if":"loraWAN",
            "moteeui": device.eui,
            "token": new Date().getTime(),
            "userdata":{
                "confirmed":false,
                "fpend":false,
                "port":214,
                "TxUTCtime":"",
                "payload":encode(params),
                "dnWaitms":0,
                "type":"data",
                "intervalms":0
            }
        }
    }
]', '{}', 'mtfac', '[MT APP] redo', '', '{}', '2025-12-22 06:25:25.204+00', 'mt_app_redo', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24197409982648325', '{"ks32_base1": {"name": "ks32_base1", "type": "number", "alias": "base1", "order": 1, "dftValue": 0}, "ks32_base2": {"name": "ks32_base2", "type": "number", "alias": "base2", "order": 2, "dftValue": 0}, "ks32_base3": {"name": "ks32_base3", "type": "number", "alias": "base3", "order": 3, "dftValue": 0}, "ks32_base4": {"name": "ks32_base4", "type": "number", "alias": "base4", "order": 4, "dftValue": 0}, "ks32_base5": {"name": "ks32_base5", "type": "number", "alias": "base5", "order": 5, "dftValue": 0}, "ks32_base6": {"name": "ks32_base6", "type": "number", "alias": "base6", "order": 6, "dftValue": 0}}', 'function encode(params) {
        let buffer = Buffer.from("CF1C641Afafa010000000200000003000000040000000500000006000000", "hex")
        buffer.writeUint32LE(params.base1,6)
        buffer.writeUint32LE(params.base2,10)
        buffer.writeUint32LE(params.base3,14)
        buffer.writeUint32LE(params.base4,18)
        buffer.writeUint32LE(params.base5,22)
        buffer.writeUint32LE(params.base6,26)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS32] configure base counter', '', '{}', '2025-12-22 06:25:25.204+00', 'mtset_ks32_base', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24196569100193797', '{}', 'function encode(params) {
        let buffer = Buffer.from("8F02980F", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS61] get paras', '', '{}', '2025-12-22 06:25:25.204+00', 'mtget_ks61_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24196240119959557', '{}', 'function encode(params) {
        let buffer = Buffer.from("8F02641A", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS32] get paras', '', '{}', '2025-12-22 06:25:25.204+00', 'mtget_ks32_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24196044204019717', '{}', 'function encode(params) {
        let buffer = Buffer.from("8F029614", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS31] get paras', '', '{}', '2025-12-22 06:25:25.204+00', 'mtget_ks31_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24047007505059845', '{"value": {"name": "value", "type": "number", "alias": "value", "order": 1}, "start_addr": {"name": "start_addr", "type": "number", "alias": "start addr", "order": 0}}', 'function encode(params) {
        let buffer = Buffer.from("CF068E04aabbccdd", "hex")
        buffer.writeUint8(params.start_addr,2)
        buffer.writeUint32LE(params.value,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] set uint32le para', 'set uint32LE paras of devices based on EB', '{}', '2025-12-22 06:25:25.205+00', 'mtset_app_uint32le', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24046828542496773', '{"value": {"name": "value", "type": "number", "alias": "value", "order": 1}, "start_addr": {"name": "start_addr", "type": "number", "alias": "start addr", "order": 0}}', 'function encode(params) {
        let buffer = Buffer.from("CF048E02aabb", "hex")
        buffer.writeUint8(params.start_addr,2)
        buffer.writeUint16LE(params.value,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] set uint16le para', 'set uint16LE paras of devices based on EB', '{}', '2025-12-22 06:25:25.205+00', 'mtset_app_uint16le', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24046455186526213', '{"value": {"name": "value", "type": "number", "alias": "value", "order": 1}, "start_addr": {"name": "start_addr", "type": "number", "alias": "start addr", "order": 0}}', 'function encode(params) {
        let buffer = Buffer.from("CF038E01aa", "hex")
        buffer.writeUint8(params.start_addr,2)
        buffer.writeUint8(params.value,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] set uint8 para', 'set uint8 paras of devices based on EB', '{}', '2025-12-22 06:25:25.205+00', 'mtset_app_uint8', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24040650571780101', '{"reg_count": {"name": "reg_count", "type": "number", "alias": "reg count", "order": 1, "dftValue": 40}, "start_addr": {"name": "start_addr", "type": "number", "alias": "start addr", "order": 0, "dftValue": 0}}', 'function encode(params) {
        let buffer = Buffer.from("8F028E04", "hex")
        buffer.writeUint8(params.start_addr,2)
        buffer.writeUint8(params.reg_count,3)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT APP] get paras', 'get app paras of  devices based on EB default is 40 registers', '{}', '2025-12-22 06:25:25.205+00', 'mtget_app_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('24014202611961861', '{}', 'function encode(params) {
        let buffer = Buffer.from("8F028E04", "hex")
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":214,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS52] get cov paras', 'get cov paras of ks52', '{}', '2025-12-22 06:25:25.205+00', 'mtget_ks52_paras', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('23107467097411589', '{"status": {"id": 0, "name": "status", "type": "boolean", "alias": "status", "index": 0}}', ' let switchStatus=params?.status
    function encode(params) {
        let buffer = Buffer.from("820804", "hex")
        if (switchStatus){
            buffer[2]=0x44
        }else {
            buffer[2]=0x04
        }
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":12,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS61] switch3', 'KS61', '{}', '2025-12-22 06:25:25.205+00', 'mt_ks61_switch3', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('23107289644797957', '{"status": {"id": 0, "name": "status", "type": "boolean", "alias": "status", "index": 0}}', ' let switchStatus=params?.status
    function encode(params) {
        let buffer = Buffer.from("820802", "hex")
        if (switchStatus){
            buffer[2]=0x22
        }else {
            buffer[2]=0x02
        }
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":12,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS61] switch2', 'KS61 switch2', '{}', '2025-12-22 06:25:25.205+00', 'mt_ks61_switch2', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('23107024292155397', '{"status": {"id": 0, "name": "status", "type": "boolean", "alias": "status", "index": 0}}', '     let switchStatus=params?.status
    function encode(params) {
        let buffer = Buffer.from("820801", "hex")
        if (switchStatus){
            buffer[2]=0x11
        }else {
            buffer[2]=0x01
        }
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version":"3.0",
                "type":"data",
                "if":"loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata":{
                    "confirmed":false,
                    "fpend":false,
                    "port":12,
                    "TxUTCtime":"",
                    "payload":encode(params),
                    "dnWaitms":3000,
                    "type":"data",
                    "intervalms":0
                }
            }
        }
    ]', '{}', 'mtfac', '[MT KS61] switch1', 'KS61', '{}', '2025-12-22 06:25:25.205+00', 'mt_ks61_switch1', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('20932439878668293', '{"period": {"name": "period", "type": "number", "unit": "min", "alias": "周期", "order": 0, "options": [], "dftValue": 1440}}', 'function encode(params) {
        let buffer = Buffer.from("CF043A020807", "hex")
        buffer.writeUInt16LE(params.period,4)
        return buffer.toString("base64");
    }
    return [
        {
            sleepTimeMs: 0,
            dnMsg: {
                "version": "3.0",
                "type": "data",
                "if": "loraWAN",
                "moteeui": device.eui,
                "token": new Date().getTime(),
                "userdata": {
                    "confirmed": true,
                    "fpend": false,
                    "port": 214,
                    "TxUTCtime": "",
                    "payload": encode(params),
                    "dnWaitms": 0,
                    "type": "data",
                    "intervalms": 0
                }
            }

        }
    ]', '{}', 'mtfac', '[MT APP] configure heart period', 'general heart period based on EB', '{}', '2025-12-22 06:25:25.205+00', 'mtset_period_heart', '{}', NULL);
INSERT INTO "system_base"."rpc" ("id", "template", "rpc_script", "params", "tenant_code", "name", "remark", "translate", "update_time", "id_name", "tags", "inherit") VALUES ('20927106749829125', '{}', '
function encode(msg) {
  let buffer = Buffer.from("CF03090101", "hex")
  return buffer.toString("base64");
} 
  
return [
  {
    sleepTimeMs: 0, 
    dnMsg: {
      "version":"3.0",
      "type":"data",
      "if":"loraWAN",
      "moteeui": device.eui,
      "token": new Date().getTime(),
      "userdata":{
        "confirmed":false,
        "fpend":false,
        "port":214,
        "TxUTCtime":"",
        "payload":encode(params),
        "dnWaitms":0,
        "type":"data",
        "intervalms":0
      }
    }
  }
]
', '{}', 'mtfac', '[MT APP] reset', 'reset the device', '{}', '2025-12-22 06:25:25.205+00', 'mt_app_reset', '{}', NULL);


-- 设备模板
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('7', 'MT-KS32', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{"base1": {"key": "base1", "type": "number", "alias": "base1", "order": 102, "dftValue": 0}, "base2": {"key": "base2", "type": "number", "alias": "base2", "order": 106, "dftValue": 0}, "base3": {"key": "base3", "type": "number", "alias": "base3", "order": 110, "dftValue": 0}, "base4": {"key": "base4", "type": "number", "alias": "base4", "order": 114, "dftValue": 0}, "base5": {"key": "base5", "type": "number", "alias": "base5", "order": 118, "dftValue": 0}, "base6": {"key": "base6", "type": "number", "alias": "base6", "order": 122, "dftValue": 0}, "content": {"key": "content", "type": "string", "alias": "content", "order": 1, "dftValue": 0}, "period_data": {"key": "period_data", "type": "number", "alias": "period_data", "order": 58, "dftValue": 900}}', '{}', '{}', '{}', '{}', '{24194975885430789}', '{}', '{}', '{20932439878668293,24574845555576837,24196240119959557,24197409982648325}', NULL, 't', 900, '{ManThink,KS32}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('6', 'MT-KS61', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{"enable": {"key": "enable", "type": "string", "alias": "cov enable", "order": 152, "dftValue": 0}, "content": {"key": "content", "type": "string", "alias": "content", "order": 1, "dftValue": 0}, "cov_co2": {"key": "cov_co2", "type": "number", "alias": "cov_co2", "order": 156, "dftValue": 0}, "cov_pm25": {"key": "cov_pm25", "type": "number", "alias": "cov_pm25", "order": 157, "dftValue": 0}, "cov_tvoc": {"key": "cov_tvoc", "type": "number", "alias": "cov_tvoc", "order": 155, "dftValue": 0}, "pir_mask": {"key": "pir_mask", "type": "string", "alias": "pir_mask", "order": 166, "dftValue": 0}, "pir_delay": {"key": "pir_delay", "type": "number", "alias": "pir_delay", "order": 158, "dftValue": 0}, "period_data": {"key": "period_data", "type": "number", "alias": "period_data", "order": 2, "dftValue": 900}, "cov_humidity": {"key": "cov_humidity", "type": "number", "alias": "cov_humidity", "order": 154, "dftValue": 0}, "lux_threshold1": {"key": "lux_threshold1", "type": "number", "alias": "lux_threshold1", "order": 160, "dftValue": 0}, "lux_threshold2": {"key": "lux_threshold2", "type": "number", "alias": "lux_threshold2", "order": 162, "dftValue": 0}, "lux_threshold3": {"key": "lux_threshold3", "type": "number", "alias": "lux_threshold3", "order": 164, "dftValue": 0}, "cov_temperatrue": {"key": "cov_temperatrue", "type": "number", "alias": "cov_temperatrue", "order": 153, "dftValue": 0}}', '{}', '{}', '{}', '{}', '{23103614448832517}', '{}', '{}', '{23107024292155397,23107467097411589,23107289644797957,20932439878668293,24046455186526213,24046828542496773,24047007505059845,24196569100193797,24574845555576837}', NULL, 't', 900, '{ManThink,IAQ,KS61}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('5', 'MT-DTU', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{"SwUp": {"key": "SwUp", "type": "boolean", "alias": "[APP-014] SwUp", "order": 14, "dftValue": false}, "reTx": {"key": "reTx", "type": "number", "alias": "[FW-079]", "order": 379, "dftValue": 5}, "swBW": {"key": "swBW", "type": "string", "alias": "[CF-61]", "order": 261, "dftValue": "500kHz"}, "swSF": {"key": "swSF", "type": "number", "alias": "[CF-60] swSF", "order": 260, "dftValue": 7}, "SWTXF": {"key": "SWTXF", "type": "boolean", "alias": "[CF-00] SWTXF", "order": 201, "dftValue": false}, "Tmode": {"key": "Tmode", "type": "boolean", "alias": "[CF-00] Tmode", "order": 201, "dftValue": false}, "BzType": {"key": "BzType", "type": "number", "alias": "[APP-004] BzType", "order": 4, "dftValue": 0}, "HwType": {"key": "HwType", "type": "string", "alias": "[APP-001] HwType", "order": 1, "dftValue": "OM822"}, "KeepRx": {"key": "KeepRx", "type": "boolean", "alias": "[APP-014] KeepRx", "order": 14, "dftValue": false}, "SWRXON": {"key": "SWRXON", "type": "boolean", "alias": "[CF-00] SWRXON", "order": 201, "dftValue": false}, "swFreq": {"key": "swFreq", "type": "number", "alias": "[CF-62] swFreq", "order": 262, "dftValue": 477300000}, "Battery": {"key": "Battery", "type": "boolean", "alias": "[APP-014] Battery", "order": 14, "dftValue": false}, "JoinRst": {"key": "JoinRst", "type": "boolean", "alias": "[APP-014] JoinRst", "order": 14, "dftValue": false}, "OtaMask": {"key": "OtaMask", "type": "number", "alias": "[APP-007] OtaMask", "order": 7, "dftValue": 0}, "Wait60s": {"key": "Wait60s", "type": "boolean", "alias": "[APP-014] Wait60s", "order": 14, "dftValue": false}, "content": {"key": "content", "type": "string", "alias": "content", "order": -2, "dftValue": 0}, "retries": {"key": "retries", "type": "number", "alias": "[APP-034] retries", "order": 34, "remark": "retries times when query failed", "dftValue": 2}, "BackHaul": {"key": "BackHaul", "type": "string", "alias": "[APP-011] BackHaul", "order": 11, "dftValue": "bh_lorawan"}, "BaudRate": {"key": "BaudRate", "type": "number", "unit": "bps", "alias": "[APP-012] BaudRate", "order": 12, "dftValue": 9600}, "Checkbit": {"key": "Checkbit", "type": "string", "alias": "[APP-013] Checkbit", "order": 13, "dftValue": "none"}, "DataBits": {"key": "DataBits", "type": "number", "alias": "[APP-013] DataBits", "order": 13, "dftValue": 8}, "RstHours": {"key": "RstHours", "type": "number", "alias": "[APP-018] RstHours", "order": 18, "dftValue": 0}, "StopBits": {"key": "StopBits", "type": "number", "alias": "[APP-013] StopBits", "order": 13, "dftValue": 1}, "WakeupIn": {"key": "WakeupIn", "type": "boolean", "alias": "[APP-011] WakeupIn", "order": 11, "dftValue": false}, "mulASkey": {"key": "mulASkey", "type": "string", "alias": "[CF-22] mulASkey", "order": 222, "dftValue": "101112131415161718191a1b1c1d1e1f"}, "mulNSkey": {"key": "mulNSkey", "type": "string", "alias": "[CF-06] mulNSkey", "order": 206, "dftValue": "0102030405060708090a0b0c0d0e0f01"}, "portPara": {"key": "portPara", "type": "number", "alias": "[APP-016] portPara", "order": 16, "dftValue": 214}, "standard": {"key": "standard", "type": "string", "alias": "[CF-00] standard", "order": 201, "dftValue": "AS923"}, "swPeriod": {"key": "swPeriod", "type": "number", "unit": "ms", "alias": "[CF-66] swPeriod", "order": 266, "dftValue": 8000}, "swPublic": {"key": "swPublic", "type": "number", "alias": "[FW-090] swPublic", "order": 390, "dftValue": 0}, "upRepeat": {"key": "upRepeat", "type": "number", "alias": "[CF-67] upRepeat", "order": 267, "dftValue": 0}, "BzVersion": {"key": "BzVersion", "type": "number", "alias": "[APP-006] BzVersion", "order": 6, "dftValue": 0}, "HwVersion": {"key": "HwVersion", "type": "number", "alias": "[APP-002] HwVersion", "order": 2, "dftValue": 1}, "PowerCtrl": {"key": "PowerCtrl", "type": "boolean", "alias": "[APP-014] PowerCtrl", "order": 14, "dftValue": false}, "SwVersion": {"key": "SwVersion", "type": "number", "alias": "[APP-003] SwVersion", "order": 3, "dftValue": 0}, "Uart1Used": {"key": "Uart1Used", "type": "boolean", "alias": "[APP-014] Uart1Used", "order": 14, "dftValue": false}, "WakeupOut": {"key": "WakeupOut", "type": "boolean", "alias": "[APP-011] WakeupOut", "order": 11, "dftValue": false}, "dutyBand1": {"key": "dutyBand1", "type": "number", "alias": "[FW-81] dutyBand1", "order": 381, "dftValue": 0}, "dutyBand2": {"key": "dutyBand2", "type": "number", "alias": "[FW-083] dutyBand2", "order": 383, "dftValue": 0}, "dutyBand3": {"key": "dutyBand3", "type": "number", "alias": "[FW-085] dutyBand3", "order": 385, "dftValue": 0}, "dutyBand4": {"key": "dutyBand4", "type": "number", "alias": "[FW-087] dutyBand4", "order": 387, "dftValue": 0}, "sub_addr1": {"key": "sub_addr1", "type": "number", "alias": "[APP-USR-122]sub addr 1", "order": 122, "remark": "app addr is 122 , and the length is len", "dftValue": 1}, "sub_addr2": {"key": "sub_addr2", "type": "number", "alias": "[APP-USR-123] sub addr 2", "order": 123, "remark": "app addr is 122+len , and the length is len", "dftValue": 0}, "sub_addr3": {"key": "sub_addr3", "type": "number", "alias": "[APP-USR-124] sub addr 3", "order": 124, "remark": "app addr is 122+len*2 , and the length is len", "dftValue": 0}, "sub_addr4": {"key": "sub_addr4", "type": "number", "alias": "[APP-USR-125] sub addr 4", "order": 125, "remark": "app addr is 122+len*3 , and the length is len", "dftValue": 0}, "sub_addr5": {"key": "sub_addr5", "type": "number", "alias": "[APP-USR-126] sub addr 5", "order": 126, "remark": "app addr is 122+len*4 , and the length is len", "dftValue": 0}, "sub_addr6": {"key": "sub_addr6", "type": "number", "alias": "[APP-USR-127] sub addr6", "order": 127, "remark": "app addr is 122+len*5 , and the length is len", "dftValue": 0}, "FilterMask": {"key": "FilterMask", "type": "number", "alias": "[APP-007] FilterMask", "order": 7, "dftValue": 0}, "TimeOffset": {"key": "TimeOffset", "type": "number", "alias": "[APP-020] TimeOffset", "order": 20, "dftValue": 0}, "class_mode": {"key": "class_mode", "type": "string", "alias": "class_mode", "order": -1, "dftValue": 0}, "field_mode": {"key": "field_mode", "type": "boolean", "alias": "[APP-008] field_mode", "order": 8, "dftValue": false}, "mulDevAddr": {"key": "mulDevAddr", "type": "string", "alias": "[CF-02]mulDevAddr", "order": 202, "dftValue": "10121314"}, "ConfirmDuty": {"key": "ConfirmDuty", "type": "number", "alias": "[APP-015] ConfirmDuty", "order": 15, "dftValue": 50}, "query_index": {"key": "query_index", "type": "number", "alias": "[APP-USR-0120]query index", "order": 120, "remark": "app addr is 120 ,index of query packet  when copy sub addr to ", "dftValue": 1}, "utc_seconds": {"key": "utc_seconds", "type": "number", "alias": "[APP-025] utc_seconds", "order": 25, "dftValue": 0}, "FuotaVersion": {"key": "FuotaVersion", "type": "number", "alias": "[APP] FuotaVersion", "order": 0, "dftValue": 1}, "battery_base": {"key": "battery_base", "type": "number", "alias": "[APP-024] battery_base", "order": 24, "dftValue": 0}, "chip_voltage": {"key": "chip_voltage", "type": "number", "unit": "v", "alias": "[APP-031] chip_voltage", "order": 31, "dftValue": 0}, "period_heart": {"key": "period_heart", "type": "number", "alias": "[APP-USR-058] heart period", "order": 58, "dftValue": 86400}, "relay_enable": {"key": "relay_enable", "type": "boolean", "alias": "[APP-008] relay_enable", "order": 8, "dftValue": false}, "query_timeout": {"key": "query_timeout", "type": "number", "unit": "ms", "alias": "[APP-032] query timeout", "order": 32, "remark": "timeout when uart read", "dftValue": 2000}, "sub_addr_size": {"key": "sub_addr_size", "type": "number", "alias": "[APP-USR-121]length of sub addr", "order": 121, "remark": "app addr is  121 , the length of sub addr", "dftValue": 0}, "TransparentBit": {"key": "TransparentBit", "type": "boolean", "alias": "[APP-014] TransparentBit", "order": 14, "dftValue": false}, "devTimeReqDuty": {"key": "devTimeReqDuty", "type": "number", "alias": "[FW-089] devTimeReqDuty", "order": 389, "dftValue": 0}, "globalDutyRate": {"key": "globalDutyRate", "type": "number", "alias": "[FW-080] globalDutyRate", "order": 380, "dftValue": 0}, "portTransparent": {"key": "portTransparent", "type": "number", "alias": "[APP-017] portTransparent", "order": 17, "dftValue": 0}, "sleepWakeEnable": {"key": "sleepWakeEnable", "type": "boolean", "alias": "[CF-00] sleepWakeEnable", "order": 201, "dftValue": true}, "chip_temperature": {"key": "chip_temperature", "type": "number", "unit": "℃", "alias": "[APP-029] chip_temperature", "order": 29, "dftValue": 0}, "uart_calibration": {"key": "uart_calibration", "type": "number", "alias": "[APP-035] uart_calibration", "order": 35, "dftValue": 0}, "sub_device_counts": {"key": "sub_device_counts", "type": "number", "alias": "[APP-USR-060]sub device counts", "order": 60, "remark": "app addr is 60, sub device counts when EB reading multi same devices . ", "dftValue": 1}, "calibration_groups": {"key": "calibration_groups", "type": "number", "alias": "[APP-036] calibration_groups", "order": 36, "dftValue": 0}, "calibration_method": {"key": "calibration_method", "type": "number", "alias": "[APP-035] calibration_method", "order": 35, "dftValue": 0}, "periodic_join_interval": {"key": "periodic_join_interval", "type": "number", "alias": "[APP-037] periodic_join_interval", "order": 37, "dftValue": 0}, "peripheral_power_delay": {"key": "peripheral_power_delay", "type": "number", "unit": "ms", "alias": "[APP-038] peripheral power delay", "order": 38, "remark": "app addr is 38-39,delay time before uart send query packet", "dftValue": 5}}', '{}', '{}', '{}', '{}', '{24220289923551238}', '{}', '{}', '{24232175968718853,24040650571780101,24597181948235781,24846903489335301,24577580598300677,24046828542496773,24046455186526213,24047007505059845,28944881661513733,20932439878668293,24574845555576837,41207876781346821,41214202022465541,41935819161735173,38273241294311429,41886965276086277,24231031439626245,20927106749829125,38534049215549445,44112566355496965,41212245631307781,41239002052825093,41886445295636485,41601231033995269,41526370722910213}', NULL, 't', 86400, '{ManThink,DTU}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('4', 'MT-KS52', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{"content": {"key": "content", "type": "string", "alias": "content", "order": 1, "dftValue": 0}, "period_data": {"key": "period_data", "type": "number", "unit": "min", "alias": "period_data", "order": 58, "dftValue": 0}, "cov_humidity": {"key": "cov_humidity", "type": "number", "unit": "RH%", "alias": "cov_humidity", "order": 145, "dftValue": 0}, "period_measure": {"key": "period_measure", "type": "number", "unit": "s", "alias": "period_measure", "order": 142, "dftValue": 0}, "cov_temperatrue": {"key": "cov_temperatrue", "type": "number", "unit": "℃", "alias": "cov_temperatrue", "order": 144, "dftValue": 0}}', '{}', '{}', '{}', '{}', '{22321109718274053}', '{}', '{}', '{20932439878668293,24014202611961861,24574845555576837,24046455186526213,24046828542496773,24047007505059845}', NULL, 't', 86400, '{}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('3', 'MT-DTU-Emeter', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{}', '{}', '{}', '{}', '{}', '{23052087352889349}', '{}', '{}', '{23077054421405701,23077859421589509,20932439878668293,20927106749829125}', NULL, 't', 900, '{ManThink,645,Emeter}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('2', 'MT-KS51', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{"content": {"key": "content", "type": "string", "alias": "content", "order": 1, "dftValue": 0}, "period_data": {"key": "period_data", "type": "number", "unit": "s", "alias": "period_data", "order": 2, "dftValue": 0}}', '{}', '{}', '{}', '{}', '{24195523346960389}', '{}', '{}', '{20932439878668293,24574845555576837}', NULL, 't', 86400, '{}', '2025-12-22 06:25:54.013+00', NULL, NULL);
INSERT INTO "system_base"."device_config_template" ("id", "name", "things_board", "home_assistant", "bacnet", "modbus_tcp", "location_id", "tenant_code", "client_attrs", "shared_attrs", "server_attrs", "other_attrs", "mac_attrs", "telemetry_data", "thing_model", "trigger", "alarm", "rpc", "condition", "real_time_storage", "heart_period", "tags", "update_time", "third_party", "cron_task") VALUES ('1', 'default', NULL, NULL, NULL, NULL, NULL, 'mtfac', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{28944881661513733}', NULL, 't', 86400, '{default}', '2025-12-22 06:25:54.013+00', NULL, NULL);
