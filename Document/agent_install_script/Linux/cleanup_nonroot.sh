#!/bin/sh
#############################################
#####    Initial clean Node_exporter    #####
#############################################

systemctl stop node_exporter
systemctl disable node_exporter

sleep 3

rm -rf /etc/node_exporter/
rm /etc/systemd/system/node_exporter.service