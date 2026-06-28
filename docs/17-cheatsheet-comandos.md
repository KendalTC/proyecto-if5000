# 17 — Cheatsheet de Comandos IF5000

> Uso rápido durante la demostración.

## Índice

-   [1. Verificación inicial](#1-verificación-inicial)
-   [2. Red y Netplan](#2-red-y-netplan)
-   [3. SSH](#3-ssh)
-   [4. Docker](#4-docker)
-   [5. Nextcloud](#5-nextcloud)
-   [6. Jellyfin](#6-jellyfin)
-   [7. Pi-hole](#7-pi-hole)
-   [8. Portainer](#8-portainer)
-   [9. Dashboard](#9-dashboard)
-   [10. Monitoreo](#10-monitoreo)
-   [11. Suricata y Fail2Ban](#11-suricata-y-fail2ban)
-   [12. Tailscale](#12-tailscale)
-   [13. Logs](#13-logs)
-   [14. Diagnóstico](#14-diagnóstico)
-   [15. Apagado y reinicio](#15-apagado-y-reinicio)

---

# 1. Verificación inicial

``` bash
hostname
whoami
who
date
uptime
free -h
df -h
ip a
```

``` bash
ping -c 3 8.8.8.8
ping -c 3 google.com
```

---

# 2. Red y Netplan

``` bash
ls /etc/netplan
cat /etc/netplan/50-cloud-init.yaml
sudo nano /etc/netplan/50-cloud-init.yaml
sudo chmod 600 /etc/netplan/50-cloud-init.yaml
sudo netplan apply
ip a
ip route
```

---

# 3. SSH

``` bash
systemctl status ssh
sudo systemctl restart ssh
sudo systemctl enable ssh
ss -tlnp | grep :22
```

Conexión

``` bash
ssh usuario@IP
```

Copiar archivos

``` bash
scp archivo usuario@IP:~
scp -r carpeta usuario@IP:~
```

Usuarios

``` bash
who
w
last
groups
id usuario
```

---

# 4. Docker

Versiones

``` bash
docker --version
docker compose version
```

Estado

``` bash
docker ps
docker ps -a
docker images
docker volume ls
docker network ls
docker stats
```

Logs

``` bash
docker logs CONTENEDOR
docker logs -f CONTENEDOR
```

Entrar

``` bash
docker exec -it CONTENEDOR bash
```

Reinicio

``` bash
docker restart CONTENEDOR
docker stop CONTENEDOR
docker start CONTENEDOR
```

Docker daemon

``` bash
sudo systemctl status docker
sudo systemctl restart docker
```

---

# 5. Nextcloud

``` bash
cd ~/nextcloud
docker compose up -d
docker compose down
docker compose ps
docker logs nextcloud
```

Trusted domains

``` bash
docker exec -it nextcloud php occ config:system:get trusted_domains
```

---

# 6. Jellyfin

``` bash
cd ~/jellyfin
docker compose up -d
docker logs jellyfin
```

---

# 7. Pi-hole

``` bash
cd ~/pihole
docker compose up -d
docker logs pihole
docker exec -it pihole pihole status
docker exec -it pihole pihole setpassword NUEVA_CLAVE
```

---

# 8. Portainer

``` bash
docker logs portainer
docker restart portainer
```

---

# 9. Dashboard

``` bash
cd ~/dashboard-if5000
docker compose up -d --build
docker logs dashboard-if5000
```

---

# 10. Monitoreo

``` bash
cd ~/monitoring
docker compose up -d
docker logs prometheus
docker logs grafana
docker logs cadvisor
docker logs node-exporter
```

---

# 11. Suricata y Fail2Ban

Servicios

``` bash
sudo systemctl status suricata
sudo systemctl status fail2ban
sudo systemctl status ssh-monitor
sudo systemctl status suricata-watcher
sudo systemctl status fail2ban-watcher
```

Reiniciar

``` bash
sudo systemctl restart suricata
sudo systemctl restart fail2ban
```

Fail2Ban

``` bash
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

---

# 12. Tailscale

``` bash
tailscale ip
tailscale status
tailscale whois IP
tailscale version
sudo tailscale up
```

---

# 13. Logs

``` bash
tail -f /var/log/auth.log
tail -f /var/log/fail2ban.log
tail -f /var/log/suricata/eve.json
tail -f /var/log/suricata/fast.log
journalctl -xe
dmesg | tail
```

---

# 14. Diagnóstico

Puertos

``` bash
ss -tlnp
```

Procesos

``` bash
ps aux
top
```

Espacio

``` bash
du -sh *
```

Contenedores

``` bash
docker inspect CONTENEDOR
docker compose ps
```

---

# 15. Apagado y reinicio

``` bash
sudo reboot
sudo shutdown now
sudo poweroff
```

Contenedores

``` bash
docker compose down
docker compose up -d
```

Servidor completo

``` bash
sudo systemctl restart docker
docker ps
systemctl status ssh
ip a
ping -c 3 google.com
```
