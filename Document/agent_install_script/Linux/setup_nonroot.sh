#! /bin/sh

#############################################
#####    Initial setup Node_exporter    #####
#############################################

mkdir /etc/node_exporter
cp ./node_exporter*/* /etc/node_exporter/

#############################################
#####         Change permission         #####
#############################################

chmod 755 /etc/node_exporter/*

#############################################
#####   Create .service file startup    #####
#############################################

cat <<EOF | tee /etc/systemd/system/node_exporter.service
#### Node_exporter for OS metrics ####

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

#############################################
#####    Start node_exporter service    #####
#############################################

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter