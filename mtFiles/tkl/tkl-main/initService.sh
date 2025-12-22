
cat <<EOF > /lib/systemd/system/tkl-main.service
[Unit]
Description=[tkl-main] tkl-main
#ConditionFileIsExecutable=/usr/local/mt/tkl/tkl-main/
After=emqx.service 

[Service]
Type=simple
WorkingDirectory=/usr/local/mt/tkl/tkl-main/
ExecStart=/usr/bin/node ./tkl-main.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload 
systemctl enable tkl-main.service
systemctl start tkl-main.service



# [Unit]
# Description=[tkl-main] tkl-main
# #ConditionFileIsExecutable=/usr/local/mt/tkl/tkl-main/
# After=board-scan.service postgresql.service redis.service mosquitto.service
# Requires=postgresql.service redis.service mosquitto.service

# [Service]
# Type=simple
# WorkingDirectory=/usr/local/mt/tkl/tkl-main/
# ExecStartPre=/bin/sleep 10
# ExecStart=/usr/local/bin/node ./tkl-main.js
# Restart=always
# RestartSec=5

# [Install]
# WantedBy=multi-user.target