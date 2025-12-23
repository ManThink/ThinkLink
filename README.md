# ThinkLink

#### 介绍
ThinkLink（以下简称 TKL）是一个功能全面、高度集成的综合性物联网系统，专为构建高效、安全、可扩展的 LoRaWAN 物联网解决方案而设计。TKL 内置了完整的 LoRaWAN 网络服务器（NS）功能，能够对 LoRaWAN 设备与网关进行集中化管理，确保网络的稳定运行与设备的安全接入。
同时，TKL 支持通过标准 MQTT 协议接入来自第三方系统的数据，实现了多源数据的融合与统一管理，极大地增强了平台的开放性与兼容性。

1. TKL 具备极高的部署灵活性，可根据项目需求和环境特点，选择以下任意一种部署方式：
    1. 云服务器（Cloud）：适用于需要快速上手、无需本地运维资源的场景。
    2. 边缘服务器（TKE）：满足对数据本地化、低延迟通信有要求的应用，支持私有化部署。
    3. 网关内部（TKG）：将 NS 功能直接嵌入网关设备，实现轻量化、低成本的本地网络管理。
    
    这种“云-边-端”一体化的部署能力，使 TKL 能够灵活适应从中小规模测试到大型企业级应用的各类需求。

2. 核心功能概览
    TKL 提供了一系列强大的功能模块，覆盖物联网应用从设备接入到业务分析的全生命周期：
    1. **网络数据调试**：可实时侦听LoRaWAN 网关侧数据（NS数据）和 NS输出的数据（AS数据），帮助用户快速调试 LoRaWAN 传感器，定位通信问题，加速项目开发与部署。
    2. **物模型**：将来自 LoRaWAN 或 MQTT 的原始数据解析为结构化的应用层数据，并支持通过表格、图表或自定义仪表板进行可视化展示。
    3. **RPC 模型**：支持远程配置设备参数及下发控制指令，实现对终端设备的远程管理与维护。
    4. **资产模型**：通过物模型对多个设备的数据进行聚合，形成更高维度的“资产”视图，便于进行综合数据分析与业务洞察。
    5. **子设备管理**：支持 DTU 或采集单元通过 RS-485、M-Bus 等接口读取的子设备数据作为独立设备进行管理，实现层级化设备组织。
    6. **EB 云编译**：在云端完成 EB（Embedded Business）代码的编译与下载，简化嵌入式业务逻辑的开发与更新流程。
    7. **告警模型**：支持基于多种数据类型设置告警规则，并通过多种渠道（如邮件、短信等）实现告警通知，确保关键事件及时响应。
    8. **联动模型**：实现设备间的自动化联动，根据预设条件触发相应动作，提升系统智能化水平。
    9. **定时任务**：可设置周期性执行的任务，通过周期性任务调用RPC从而实现自动化周期执行的工作
    10. **协议对接**：通过灵活的物模型配置，可无缝对接 BACnet、Home Assistant、ThingsBoard、Modbus TCP 等主流协议，打通异构系统。
    
    【注意】：BACnet 与 Modbus TCP 协议对接功能仅在 TKE 边缘服务器或网关内部(TKG)部署模式下可用。

#### 安装教程

1. 获取 ThinkLink 安装包
    您可以通过联系门思科技 (info@manthink.cn)获取安装包。
    如果下载的是压缩包，请将其解压至任意目标文件夹。

2. 环境要求与安装
    1. **操作系统要求**
        系统需为 Ubuntu 24.0 或更高版本，支持 arm64 和 x64 两种架构。
    2. **依赖工具**
        环境安装主要涉及以下工具：
        *   PostgreSQL 16
        *   TimeScaleDB 2.24
        *   Node.js v22.21.0
        *   EMQX 5.8
        *   npm
        *   Redis
        *   Nginx
    3. **一键环境安装**
        进入安装包目录，执行 `install-env-tkl.sh` 脚本即可一键完成环境安装。该脚本具备幂等性，已安装的环境不会重复安装，因此可以安全地重复执行。
        
        ```bash
        cd tkl-pkg-2.00.010
        sudo ./install-env-tkl.sh
        ```

3. 端口配置
    为确保外部访问，需要开放以下 TCP 端口：
    *   `1883`, `8083`, `18083`, `5432`, `80`, `443`
    如需支持 GWMP 协议，请同时开放 UDP `1770` 端口。

4. EMQX 配置
    EMQX 通过 Web 界面进行配置，访问地址为 `http://[IP]:18083`。
    EMQX 的默认登录凭证为 `admin/public`，强烈建议在安装完成后立即修改密码以保障安全。
    
    **重要提示**： 在 EMQX 5.10.0 版本中，`allow_anonymous` 参数已被移除。其逻辑变更为：未配置任何认证规则时默认允许匿名访问；一旦配置了任何认证规则，将自动禁用匿名访问。

    1. **配置超级用户**
        1. 登录 Dashboard（`http://<IP>:18083`）→ "访问控制" → "客户端认证" → "创建"。
        2. 选择认证方式（例如：Password-Based → Built-in Database）→ "下一步"。
        3. 保持默认设置，并添加至少一个用户（Username/Client ID + 密码）→ "创建"。
        4. 在 "客户端认证" → "内置数据库" → "用户管理" 中，添加一个超级管理员：
            ```
            用户名 (u): thinklink
            密码 (p): tkl_1705
            ```

    2. **启用 PostgreSQL 账号认证**
        1. 登录 Dashboard（`http://<IP>:18083`）→ "访问控制" → "客户端认证" → "创建"。
        2. 选择认证方式（例如：Password-Based → PostgreSQL）→ "下一步"。
        3. 修改服务器连接信息和 SQL 查询语句。密码字段请使用对应的 PostgreSQL 数据库密码。
        4. 填写完成后点击 "更新"。
        
        ```sql
        SELECT password_hash, salt FROM system_base.mqtt_user where username = ${username} LIMIT 1
        ```

    3. **ACL 授权配置**
        1. 登录 Dashboard（`http://<IP>:18083`）→ "访问控制" → "客户端授权" → "设置"。
        2. 编辑默认规则：
            *   进入 "客户端授权" → "数据源" → "File" → 点击 "设置" 图标。
            *   在 ACL File 中，删除 `{allow, all}.` 这一行。
            *   保存后自动生效（无需重启 EMQX）。
        3. 配置授权策略：
            *   在 "客户端授权" → "授权设置" 中，将 "未匹配时执行" 设置为 `deny`，将 "拒绝时执行" 设置为 `disconnect`。

    4. **启用 PostgreSQL ACL 权限管理**
        1. 登录 Dashboard（`http://<IP>:18083`）→ "访问控制" → "客户端授权" → "设置"。
        2. 选择认证方式（例如：Password-Based → PostgreSQL）→ "下一步"。
        3. 修改服务器连接信息和 SQL 查询语句。密码字段请使用对应的 PostgreSQL 数据库密码。
        4. 填写完成后点击 "更新"。
        
        ```sql
        SELECT action, permission, topic FROM system_base.mqtt_acl where username = ${username} or username='PUBLIC'
        ```

5. 安装应用程序
    进入安装包目录，执行 `install-app-tkl.sh` 脚本即可一键完成应用程序安装。
    
    ```bash
    sudo ./install-app-tkl.sh
    ```
    
    安装完成后，系统将打印以下默认信息：

6. 默认信息与密码修改
    1. **默认登录凭证**
        *   MQTT Broker 超级用户： `user=thinklink password=tkl_1705`
        *   ThinkLink 平台登录： `http://[IP]`，用户名 `admin`，密码 `TKedge_0801`
    2. **账号密码修改方法**
        ThinkLink 依赖于 EMQX、PostgreSQL 和 Redis，安装后均采用默认账号和密码。如需修改这三个组件的密码，请先完成修改，然后按照以下步骤更新 ThinkLink 的配置：
        1. 配置一个名为 `conf.json` 的文件。示例中密码使用密文表示，实际用户修改时可直接使用明文输入。
        
        **注意**： 除密码外，不建议修改其他参数，除非您完全清楚修改后可能带来的影响。
        
        ```json
        {
            "redispswd": "Z4fZr1eRW+ZcczXtbU9ebQ==", 
            "ns": {
            "broker": "localhost:1883",
            "username": "thinklink",
            "password": "Z4fZr1eRW+ZcczXtbU9ebQ=="
            },
            "as": {
            "broker": "localhost:1883",
            "username": "thinklink",
            "password": "Z4fZr1eRW+ZcczXtbU9ebQ=="
            },
            "dms": {
            "broker": "localhost:1883",
            "username": "thinklink",
            "password": "Z4fZr1eRW+ZcczXtbU9ebQ=="
            },
            "postgre": {
            "server": "localhost:5432",
            "dbName": "thinklink_old",
            "user": "postgres",
            "pswd": "pUbLbJNq0ugS/M0bepY5TA=="
            },
            "postgrebk": {
            "server": "localhost:5432",
            "dbName": "thinklink",
            "user": "postgres",
            "pswd": "pUbLbJNq0ugS/M0bepY5TA=="
            }
        }
        ```
        
        *   Redis 密码： 修改 `redispswd` 字段。
        *   Broker 密码： 建议统一修改所有 Broker（`ns`, `as`, `dms`）的密码，保留 `thinklink` 用户名不变。
        *   PostgreSQL 密码： `postgre` 和 `postgrebk` 的 `user` 字段保持为 `postgres`，两个配置的密码必须保持一致。
        
        2. 执行以下命令，完成密码修改：
        
        ```bash
        tkl-chpswd -f conf.json
        ```

#### 使用说明
[《[CN] ThinkLink 使用说明书》](https://mensikeji.yuque.com/staff-zesscp/gqdw7f/lyh7hfbvi9sumrs2?singleDoc)

#### 贡献
北京门思科技有限公司 [www.manthink.cn](http://www.manthink.cn)
更多信息联系 [info@manthink.cn](mailto:info@manthink.cn)
