#! /bin/sh

######################################################################
##### Start config auto deploy node-exporter to docker container #####
######################################################################
echo "Upload docker images with local file."
docker load -i node_*.docker
docker load -i cadvisor*.docker

##### Running Node-exporter #####
echo "[+] Run docker {node_exporter}."
docker run -d --name node-exporter \
-v /proc:/host/proc \
-v /sys:/host/sys \
-v /:/rootfs \
-p 9100:9100 \
prom/node-exporter:v0.17.0 \
--path.procfs=/host/proc \
--path.sysfs=/host/sys \
--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"

##### Running cAvisor #####
echo "[+] Run docker {cAdvisor}."
docker run -d --name cadvisor \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8081:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:v0.32.0

##### Verify docker running ps #####
docker ps