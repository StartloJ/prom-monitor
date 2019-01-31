#! /bin/sh

#############################################
#####    Initial setup Node_exporter    #####
#############################################
echo "[+] Initial setup : in create prome-user and copy script."
useradd -r -s /bin/bash prometheus
mkdir /etc/node_exporter
cp ./node_exporter*/* /etc/node_exporter/
echo "[+] Initial setup : success.."
#############################################
#####         Change permission         #####
#############################################
echo "[+] Change permission : for any file script."
chown prometheus:prometheus /etc/node_exporter/*
chmod +x /etc/node_exporter/*
echo "[+] Change permission : success.."
#############################################
#####   Create .service file startup    #####
#############################################
echo "[+] Create service file"
cat <<EOF | tee /etc/systemd/system/node_exporter.service
#### Node_exporter for OS metrics ####

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/etc/node_exporter/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
#############################################
#####    Start node_exporter service    #####
#############################################
echo "[+] Warm reload configuration file on service"
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter