#!/bin/bash
#set -e
if [ "$EUID" -ne 0 ]; then
  echo "please using root account to run this script"
  exit 1
fi
os=`uname`
echo "[ ManThink ThinkLink install ] system is "$os
arch=`uname -m`
echo "[ ManThink ThinkLink install ] arch is "$arch
ubuntuVersion=`lsb_release -cs | grep noble`
if [ "$ubuntuVersion" = "" ]; then
  ubuntuVersion=`lsb_release -cs | grep jammy`
  if [ "$ubuntuVersion" = "" ]; then
    ubuntuVersion=noversion
  fi
else
  ubuntuVersion=noble
fi
echo "[ ManThink ThinkLink install ] os version is ${ubuntuVersion}"
installPath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/
toolsPath=${installPath}tools/
sysFilesPath=${installPath}sysFiles/
gwmPath=${installPath}tools/arm64/
if [ "$os" != "Linux" ]; then
   echo "[ ManThink ThinkLink install ] don't support the sytem and break the install"
   exit 0
fi
if [ "$arch" = "aarch64" ]; then
  gwmPath=${installPath}tools/arm64/
elif [ "$arch" = "x86_64" ]; then
  gwmPath=${installPath}tools/x64/
else
  echo "[ ManThink ThinkLink install ] don't support the arch and break the install"
  exit 0
fi
cp ${gwmPath}gwm /usr/bin/
chmod 755 /usr/bin/gwm
cp ${installPath}tkl-chpswd  /usr/bin/
mkdir -p /usr/local/mt/
sudo apt update
sudo apt install -y wget dpkg-dev
#######################################################################
echo "#######################################################################"
echo "                start install the environment of ThinkLink "
echo "                more infomation please contact info@manthink.cn"
echo "#######################################################################"
echo "************************************* [ nginx install ]*************************************"
nginxExist=`which nginx`
if [ "$nginxExist" = "" ]; then
  sudo apt-get install -y nginx
else
    echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [nginx] already exist ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
fi
gwm -sys service -f nginx
#######################################################################
echo "************************************* start install redis *************************************"
redisExist=`which redis-server` 
if [ "$redisExist" = "" ]; then
  sudo apt-get install -y redis-server
  sudo sed -i 's/# requirepass foobared/requirepass TKredis_0801/g' /etc/redis/redis.conf
  sudo systemctl enable redis-server
  sudo systemctl restart redis-server
else
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ redis already exist ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
fi
gwm -sys service -f  redis-server
#######################################################################
#echo "[ manthink ThinkLink install ] - [3. node] 安装node环境(3种方法包管理器（如apt）、nvm，或者直接下载二进制文件解压)"
#echo "[ manthink ThinkLink install ] - [3.1] 从官网https://nodejs.org/zh-cn/download下载安装包node-v22.17.0-linux-arm64.tar.xz,上传并解压到服务器/usr/src文件夹中(建议后面将Node.js解压到/usr/local/lib/（更符合 Linux目录规范）)"
echo "[ ManThink ThinkLink install ] - [3. node] install"
nodeExist=`which node`
nodeAuto="true"
if [ "$nodeExist" = "" ]; then
 # if [ "$arch" = "aarch64" ]; then
 #   file="${toolsPath}node-v22.17.0-linux-arm64.tar.xz"
 # else
 #   file="${toolsPath}node-v22.17.0-linux-x64.tar.xz"
 # fi
 # if [ -f "$file" ]; then
    #以下是离线安装方法，先吧安装包下载到本地，如果本地没有安装包，则通过atp进行安装
 #   echo "************************************* [node install ] will be installed from file ${file} *************************************"
 #   tar -xf ${file} -C /usr/local/lib/
 #   if [ "$arch" = "aarch64" ]; then
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-arm64/bin/npm /usr/local/bin/npm
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-arm64/bin/node /usr/bin/node
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-arm64/bin/npx /usr/local/bin/npx
 #   else
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-x64/bin/npm /usr/local/bin/npm
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-x64/bin/node /usr/bin/node
 #     sudo ln -sf /usr/local/lib/node-v22.17.0-linux-x64/bin/npx /usr/local/bin/npx
 #   fi
 #   nodeAuto="false"
 # else
    echo "************************************* node install auto *************************************"
    apt install -y curl gnupg2 ca-certificates
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    apt install -y nodejs
    apt install npm
 # fi
else 
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ node already exist ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
fi 
node -v
npm -v
npx -v
#######################################################################
echo "************************************* pgsql install start *************************************"
#pgsqlExist=`systemctl list-units --type=service | grep -q 'postgresql.service'`
if [ -f "/usr/lib/systemd/system/postgresql.service" ]; then
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ pgsql already installed ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
else
  sudo apt-get -y install postgresql-16
  echo "[ ManThink ThinkLink install ] open pgsql "
  sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/16/main/postgresql.conf
  echo "[ ManThink ThinkLink install ] set  timezone"
  #sed -i "s#timezone = 'Etc/UTC'#timezone = 'Asia/Hong_Kong'#g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s#timezone = 'Etc/UTC'#timezone = 'Asia/Shanghai'#g" /etc/postgresql/16/main/postgresql.conf
  echo "[ ManThink ThinkLink install ] config log"
  sed -i "s/#log_destination = 'stderr'/log_destination = 'stderr'/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#logging_collector = off/logging_collector = on/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#log_directory = 'log'/log_directory = 'pg_log'/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/log_filename = 'postgresql-%a.log'/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#log_rotation_age = 1d/log_rotation_age = 1d/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#log_rotation_size = 10MB/log_rotation_size = 0/g" /etc/postgresql/16/main/postgresql.conf
  sed -i "s/#log_truncate_on_rotation = off/log_truncate_on_rotation = on/g" /etc/postgresql/16/main/postgresql.conf
  echo "[ ManThink ThinkLink install ] set pg_hba.conf"
  echo "[ ManThink ThinkLink install ] allow all ip "
  echo 'host 	all		all		0.0.0.0/0		scram-sha-256' >> /etc/postgresql/16/main/pg_hba.conf
  sudo systemctl restart postgresql
  echo "[ ManThink ThinkLink install ] set default password"
  PG_PASSWORD='TKpg_0801'
  sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD '$PG_PASSWORD';"
  sudo systemctl restart postgresql
fi
gwm -sys service -f postgresql
#######################################################################
echo "************************************* install TimeScaleDB *************************************"
#!/bin/bash

if psql -t -c "SELECT 1 FROM pg_extension WHERE extname='timescaledb';" 2>/dev/null | grep -q 1; then
    echo "TimescaleDB is installed"
else
  echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
  wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y timescaledb-2-postgresql-16
  sudo timescaledb-tune --quiet --yes
  sudo systemctl restart postgresql
  sudo -u postgres psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;"
  echo "TimescaleDB Version: $(sudo -u postgres psql -d template1 -t -c "SELECT extversion FROM pg_extension WHERE extname = 'timescaledb';" 2>/dev/null | tr -d ' ')"
fi
#######################################################################
echo "************************************* install emqx5.8.7  *************************************"
emqxExist=`which emqx`
if [ "$emqxExist" = "" ]; then
  x64Path=${toolsPath}x64
  arm64Path=${toolsPath}arm64
  if [ "$arch" = "x86_64" ]; then
    #if [ "$ubuntuVersion" = "noble" ];then
      emqxName=emqx-5.8.7-ubuntu24.04-amd64.deb
    #elif [ "$ubuntuVersion" = "jammy" ];then
    #  emqxName=emqx-5.8.7-ubuntu22.04-amd64.deb
    #else
    #  emqxName=emqx-5.8.7-ubuntu20.04-amd64.deb
    #fi
    if [ ! -f "${x64Path}/${emqxName}" ];then
          wget  https://www.emqx.com/en/downloads/broker/5.8.7/${emqxName} -O ${x64Path}
    fi
    sudo apt install ${x64Path}/${emqxName}
  else
    #if [ "$ubuntuVersion" = "noble" ];then
          emqxName=emqx-5.8.7-ubuntu24.04-arm64.deb
    #    elif [ "$ubuntuVersion" = "jammy" ];then
    #      emqxName=emqx-5.8.7-ubuntu22.04-arm64.deb
    #    else
    #      emqxName=emqx-5.8.7-ubuntu20.04-arm64.deb
    #    fi
    if [ ! -f "${arm64Path}/${emqxName}" ];then
      wget  https://www.emqx.com/en/downloads/broker/5.8.7/${emqxName} -O ${arm64Path}
    fi
    sudo apt install ${arm64Path}/${emqxName}
  fi
  sudo systemctl enable emqx
  sudo systemctl restart emqx
else
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ emqx alread installed ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
fi
echo "【start checking ....】***************************************************"
echo "node : "
node  --version
which node
echo "npm : "
which npm
gwm -sys service -f nginx
gwm -sys service -f  redis-server
gwm -sys service -f postgresql
gwm -sys service -f emqx
echo "***************************************************"
echo "Dashboard http://<IP>:18083
            admin public
            Change password to TKedge_0801
        Create authentication rules using the built-in database
            (Note: EMQX 5.10.0 removed the \`allow_anonymous\` parameter, adopting logic: \
            \"Anonymous access is allowed by default when no rules exist, but disabled after any rule is added.\")
            1. Log in to Dashboard (http://<IP>:18083) → 'Access Control' → 'Client Authentication' → 'Create'
            2. Select method (e.g., Password-Based → Built-in Database) → 'Next'
            3. Keep defaults; add at least one user (Username/Client ID + Password) → 'Create'
            4. Go to 'Client Authentication' → 'Built-in Database' → 'User Management' → 'Add'
                Add four superusers:
                u=thinklink p=tkl_1705
        Steps to configure ACL:
            1. Log in to Dashboard (http://<IP>:18083) → 'Access Control' → 'Client Authorization' → 'Settings'
            2. Under 'Authorization Settings' → Set 'When No Rules Matched': deny, 'On Deny Action': ignore → 'Save'
            3. Edit default rules: 'Client Authorization' → 'Data Sources' → 'File' → Click the gear icon
                Delete in ACL File:
                {allow, all}.
                %%ADD_HERE
                Changes apply automatically (no restart).

        Configure Time Beacon:
            Under Client Authorization → Authorization Settings → Set 'When No Rules Matched': deny, 'On Deny Action': disconnect."
echo "#######################################################################"
echo "                            end                                        "
echo "#######################################################################"





