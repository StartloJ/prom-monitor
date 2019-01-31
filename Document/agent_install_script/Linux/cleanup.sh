#!/bin/sh
#############################################
#####    Initial clean Node_exporter    #####
#############################################
echo "[+] Stop and disabled node_exporter service."
systemctl stop node_exporter
systemctl disable node_exporter

sleep 2
echo "[+] Force delete service file"
rm -rf /etc/node_exporter/
rm /etc/systemd/system/node_exporter.service
echo "[+] Delete prome-user"
userdel prometheus
echo "[+] Cleaning complete."