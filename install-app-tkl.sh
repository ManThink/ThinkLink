#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "please use root to run this script"
  exit 1
fi
os=`uname`
echo "[ ManThink ThinkLink install ] system is "$os
arch=`uname -m`
echo "[ ManThink ThinkLink install ] arch is "$arch
tenantName=administrator
ip=localhost
workPath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/
cd ${workPath}
mkdir -p /usr/local/mt
aim_path=/usr/local/mt/
tkl_dir=${aim_path}tkl
nginx_dir=${aim_path}nginx-config
www_dir=${aim_path}www
lws_dir=${aim_path}lws
cp ${workPath}tools/neteui /usr/bin/
if [ -d "$www_dir" ]; then
    echo "www have already been installed"
else
  tar -xf ${workPath}mtFiles/www* -C ${aim_path}
  ln -s /usr/local/mt/www/tkl-web/index.html /usr/local/mt/www/index.html
fi
# 配置 tkl 以及 bacnet服务
if [ -d "$tkl_dir" ]; then
  echo "tkl have already been installed"
else 
  cp -r ${workPath}mtFiles/tkl ${aim_path}
  cp ${workPath}service/tkl-main.service /usr/lib/systemd/system/
  cp ${workPath}service/tkl-bacnet-bridge.service /usr/lib/systemd/system/
  systemctl enable tkl-main.service
  systemctl enable tkl-bacnet-bridge.service
  systemctl daemon-reload
  systemctl restart tkl-main.service
  systemctl restart tkl-bacnet-bridge.service
  # mkdir ${aim_path}ssl
  # mkdir -p ${ssl_dir}
  # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${ssl_dir}/server.key -out ${ssl_dir}/server.csr -subj "/C=CN/ST=manthink/L=manthink/O=manthink/CN=$ip/emailAddress=xxxx@mail.com"
  # mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
  # ln -s ${ssl_dir}/ /etc/nginx/ssl
  # cp ${aim_path}/nginx.conf /etc/nginx/nginx.conf
fi
# 配置nginx
if  [ -d "$nginx_dir" ]; then
  echo "niginx have alreay been installed"
else 
  cp -r ${workPath}mtFiles/nginx-config ${aim_path}
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${nginx_dir}/ssl/server.key -out ${nginx_dir}/ssl/server.csr -subj "/C=CN/ST=manthink/L=manthink/O=manthink/CN=$ip/emailAddress=info@manthink.cn"
  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
  ln -s ${nginx_dir}/ssl/ /etc/nginx/ssl
  ln -s ${nginx_dir}/nginx.conf /etc/nginx/nginx.conf
  systemctl enable nginx
  sudo systemctl restart nginx
fi
if [ -d "$lws_dir" ]; then
    echo "lws have already been installed"
else
  if [ -d "${workPath}mtFiles/lws" ];then
      echo "exist directory lws"
  else
      mkdir ${workPath}mtFiles/lws
      tar -xf ${workPath}mtFiles/lwsInstall* -C ${workPath}mtFiles/lws
  fi
  cd ${workPath}mtFiles/lws
  ./install_lws.sh -f ${workPath}config/lws-conf.json
fi
gwm -sys service -f lws-thinkOne
gwm -sys service -f lws-nsbrg
gwm -sys service -f tkl-main
gwm -sys service -f tkl-bacnet-bridge

