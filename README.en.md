# ThinkLink

## Description

ThinkLink (hereinafter referred to as TKL) is a comprehensive and highly integrated IoT system designed for building efficient, secure, and scalable LoRaWAN IoT solutions. TKL has a built-in complete LoRaWAN network server (NS) function, which can centrally manage LoRaWAN devices and gateways to ensure stable network operation and secure device access.

At the same time, TKL supports accessing data from third-party systems through the standard MQTT protocol, realizing the integration and unified management of multi-source data, and greatly enhancing the openness and compatibility of the platform.

### Deployment Flexibility

TKL provides high deployment flexibility. You can choose any of the following deployment methods based on project requirements and environment characteristics:

- **Cloud Server (Cloud)**: Applicable to scenarios that need to get started quickly and do not need local resources.
- **Edge Server (TKE)**: Meets applications that require data localization and low-latency communication, and supports private deployment.
- **Gateway Internal (TKG)**: The NS function is directly embedded in the gateway device to achieve lightweight and low-cost local network management.

This "cloud-edge-end" integrated deployment capability enables TKL to flexibly adapt to various requirements from small-scale testing to large-scale enterprise applications.

### Core Features Overview

TKL provides a series of powerful function modules, covering the entire life cycle of IoT applications from device access to business analysis:

- **Network Data Debugging**: Can listen to LoRaWAN gateway-side data (NS data) and NS output data (AS data), helping users to quickly debug LoRaWAN sensors, locate communication problems, and accelerate project development and deployment.
- **Thing Model**: Parses raw data from LoRaWAN or MQTT into structured application-layer data, and supports visual display through tables, charts, or custom dashboards.
- **RPC**: Supports remote configuration of equipment parameters and issues control instructions to realize remote management and maintenance of terminal equipment.
- **Asset Model**: Aggregates data from multiple devices through the thing model to form a higher-dimensional "asset" view for comprehensive data analysis and business insight.
- **Sub-device Management**: Supports the management of sub-device data read by DTU or acquisition units through interfaces such as RS-485 and M-Bus as independent devices, realizing hierarchical device organization.
- **EB Cloud Compiler**: Compile and download EB (Embedded Business) code in the cloud, simplifying the process of developing and updating embedded business logic.
- **Alarm Model**: Can set alarm rules based on multiple data types and implement alarm notifications through multiple channels (such as email and SMS) to ensure timely response to key events.
- **Linkage Model**: Realizes automatic linkage between devices, triggers corresponding actions according to preset conditions, and improves the intelligent level of the system.
- **Scheduled Task**: Tasks can be set to execute periodically, calling RPC through periodic tasks to achieve automated, cyclical operations.
- **Protocol Docking**: Through flexible configuration, it can seamlessly connect with mainstream protocols such as BACnet, Home Assistant, ThingsBoard, Modbus TCP, etc.

[Note]: The interface between BACnet and Modbus TCP protocol is only available in TKE/TKG mode.

## Installation

### ThinkLink Installation and Configuration Guide

#### 1. Obtaining the ThinkLink Installation Package

You can obtain the installation package by contacting ManThink Technology (info@manthink.cn) or by downloading it directly from GitHub.

If you download a compressed package, please decompress it into any target folder.

#### 2. Environment Requirements and Installation

##### 2.1 Operating System Requirements

The system must be Ubuntu 24.0 or a higher version, supporting both arm64 and x64 architectures.

##### 2.2 Required Dependencies

The environment installation mainly involves the following tools:

- PostgreSQL 16
- TimeScaleDB 2.24
- Node.js v22.21.0
- EMQX 5.8
- npm
- Redis
- Nginx

##### 2.3 One-Click Environment Installation

Navigate to the installation package directory and execute the `install-env-tkl.sh` script to complete the environment installation with a single command. This script is idempotent; already installed environments will not be reinstalled, so it can be safely executed repeatedly.

```bash
cd tkl-pkg-2.00.010
sudo ./install-env-tkl.sh
```

#### 3. Port Configuration

To ensure external access, the following TCP ports need to be opened:

- 1883, 8083, 18083, 5432, 80, 443

If GWMP protocol support is required, please also open UDP port 1770.

#### 4. EMQX Configuration

EMQX is configured via a Web interface, accessible at `http://[IP]:18083`.

The default EMQX login credentials are `admin/public`. It is strongly recommended to change the password immediately after installation to ensure security.

**Important Note**: In EMQX version 5.10.0, the `allow_anonymous` parameter has been removed. The logic has been changed to: Anonymous access is allowed by default when no authentication rules are configured; once any authentication rule is configured, anonymous access is automatically disabled.

##### 4.1 Configuring Superusers

1. Log in to the Dashboard (`http://<IP>:18083`) → "Access Control" → "Client Authentication" → "Create".
2. Select the authentication method (e.g., Password-Based → Built-in Database) → "Next".
3. Keep the default settings and add at least one user (Username/Client ID + Password) → "Create".
4. In "Client Authentication" → "Built-in Database" → "User Management", add a Super Administrator:
   - Username (u): `thinklink`
   - Password (p): `tkl_1705`

##### 4.2 Enabling PostgreSQL Account Authentication

1. Log in to the Dashboard (`http://<IP>:18083`) → "Access Control" → "Client Authentication" → "Create".
2. Select the authentication method (e.g., Password-Based → PostgreSQL) → "Next".
3. Modify the server connection information and SQL query statement. Use the corresponding PostgreSQL database password for the password field.
4. Click "Update" after filling in the information.

```sql
SELECT password_hash, salt FROM system_base.mqtt_user where username = ${username} LIMIT 1
```

##### 4.3 ACL Authorization Configuration

1. Log in to the Dashboard (`http://<IP>:18083`) → "Access Control" → "Client Authorization" → "Settings".
2. Edit the default rule:
   - Go to "Client Authorization" → "Data Source" → "File" → Click the "Settings" icon.
   - In the ACL File, delete the line `{allow, all}`.
   - The change takes effect automatically upon saving (no EMQX restart required).
3. Configure Authorization Policy:
   - In "Client Authorization" → "Authorization Settings", set "Execute if no match" to **deny**, and set "Execute if denied" to **disconnect**.

##### 4.4 Enabling PostgreSQL ACL Permission Management

1. Log in to the Dashboard (`http://<IP>:18083`) → "Access Control" → "Client Authorization" → "Settings".
2. Select the authentication method (e.g., Password-Based → PostgreSQL) → "Next".
3. Modify the server connection information and SQL query statement. Use the corresponding PostgreSQL database password for the password field.
4. Click "Update" after filling in the information.

```sql
SELECT action, permission, topic FROM system_base.mqtt_acl where username = ${username} or username='PUBLIC'
```

#### 5. Installing the Application

Navigate to the installation package directory and execute the `install-app-tkl.sh` script to complete the application installation with a single command.

```bash
sudo ./install-app-tkl.sh
```

After the installation is complete, the system will print the default information.

#### 6. Default Information and Password Modification

##### 6.1 Default Login Credentials

- **MQTT Broker Superuser**: user=`thinklink` password=`tkl_1705`
- **ThinkLink Platform Login**: `http://[IP]`, Username `admin`, Password `TKedge_0801`

##### 6.2 Method for Modifying Account Passwords

ThinkLink relies on EMQX, PostgreSQL, and Redis. Default accounts and passwords are used after installation. If you need to modify the passwords for these three components, please complete the modification first, and then update the ThinkLink configuration using the following steps:

1. Configure a file named `conf.json`. Passwords are shown in ciphertext in the example, but actual users can input them in plaintext when modifying.

**Note**: It is not recommended to modify parameters other than passwords, unless you are fully aware of the potential impact of the changes.

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

2. Execute the following command to complete the password modification:

```bash
tkl-chpswd -f conf.json
```

## Instructions

For detailed usage instructions, please refer to the [ThinkLink User Guide](https://mensikeji.yuque.com/staff-zesscp/gqdw7f/md29a2ixuug2aik2?singleDoc#).

## Contribution

ManThink Technology - please contact info@manthink.cn

More info: https://www.manthink.cn
