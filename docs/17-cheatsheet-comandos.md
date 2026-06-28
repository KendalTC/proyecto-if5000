# 🖥️ Cheatsheet de Comandos — IF5000

> Guía rápida con descripción de cada comando para la demostración del servidor.

## Índice

- [1. Verificación del sistema](#1-verificación-del-sistema)
- [2. Red y Netplan](#2-red-y-netplan)
- [3. SSH](#3-ssh)
- [4. Docker](#4-docker)
- [5. Nextcloud](#5-nextcloud)
- [6. Jellyfin](#6-jellyfin)
- [7. Pi-hole](#7-pi-hole)
- [8. Portainer](#8-portainer)
- [9. Dashboard](#9-dashboard)
- [10. Monitoreo](#10-monitoreo)
- [11. Suricata y Fail2Ban](#11-suricata-y-fail2ban)
- [12. Tailscale](#12-tailscale)
- [13. Logs del sistema](#13-logs-del-sistema)
- [14. Diagnóstico](#14-diagnóstico)
- [15. Apagado y reinicio](#15-apagado-y-reinicio)

---

## 1. Verificación del sistema

Comandos para confirmar que el servidor está sano al inicio de la demo.

### Identidad y tiempo

| Comando | Qué hace |
|---|---|
| `hostname` | Muestra el nombre del servidor |
| `whoami` | Muestra el usuario con el que estás conectado |
| `who` | Lista quién está conectado al servidor en este momento |
| `date` | Muestra la fecha y hora actual del sistema |
| `uptime` | Cuánto tiempo lleva encendido el servidor y la carga de CPU |

### Recursos

| Comando | Qué hace |
|---|---|
| `free -h` | Memoria RAM disponible y usada (en MB/GB legibles) |
| `df -h` | Espacio en disco de todas las particiones montadas |
| `ip a` | Muestra todas las interfaces de red y sus IPs asignadas |

### Conectividad

| Comando | Qué hace |
|---|---|
| `ping -c 3 8.8.8.8` | Prueba conexión a internet directo por IP (sin DNS) |
| `ping -c 3 google.com` | Prueba que la resolución de nombres (DNS) funcione |

---

## 2. Red y Netplan

Comandos para ver y modificar la configuración de red del servidor.

| Comando | Qué hace |
|---|---|
| `ls /etc/netplan` | Lista los archivos de configuración de red existentes |
| `cat /etc/netplan/50-cloud-init.yaml` | Muestra la configuración actual (IP estática, gateway, DNS) |
| `sudo nano /etc/netplan/50-cloud-init.yaml` | Edita la configuración de red en el editor nano |
| `sudo chmod 600 /etc/netplan/50-cloud-init.yaml` | Protege el archivo para que solo root pueda leerlo |
| `sudo netplan apply` | Aplica los cambios de red **sin reiniciar** el servidor |
| `ip a` | Verifica la IP asignada después de aplicar cambios |
| `ip route` | Muestra la puerta de enlace (gateway) predeterminada |

---

## 3. SSH

### Estado del servicio

| Comando | Qué hace |
|---|---|
| `systemctl status ssh` | Verifica si SSH está activo (verde = funcionando) |
| `sudo systemctl restart ssh` | Reinicia el servicio SSH si hay problemas de conexión |
| `sudo systemctl enable ssh` | Hace que SSH arranque automáticamente al encender el servidor |
| `ss -tlnp \| grep :22` | Confirma que SSH está escuchando en el puerto 22 |

### Conexión y transferencia de archivos

| Comando | Qué hace |
|---|---|
| `ssh usuario@IP` | Conectarse al servidor por SSH desde otra máquina |
| `scp archivo usuario@IP:~` | Copiar un archivo al servidor (en el home del usuario) |
| `scp -r carpeta usuario@IP:~` | Copiar una carpeta completa al servidor (recursivo) |

### Usuarios conectados

| Comando | Qué hace |
|---|---|
| `who` | Muestra quién está conectado ahora mismo |
| `w` | Usuarios conectados con detalle de actividad y tiempo idle |
| `last` | Historial de conexiones anteriores al servidor |
| `groups` | Grupos a los que pertenece el usuario actual |
| `id usuario` | UID, GID y grupos de un usuario específico |

---

## 4. Docker

### Versiones

| Comando | Qué hace |
|---|---|
| `docker --version` | Versión del motor Docker instalado |
| `docker compose version` | Versión de Docker Compose |

### Estado del sistema

| Comando | Qué hace |
|---|---|
| `docker ps` | Contenedores en ejecución ahora mismo |
| `docker ps -a` | Todos los contenedores, incluidos los detenidos |
| `docker images` | Imágenes descargadas en el servidor |
| `docker volume ls` | Volúmenes de datos persistentes creados |
| `docker network ls` | Redes virtuales entre contenedores |
| `docker stats` | Uso en tiempo real de CPU y RAM por contenedor |

### Logs

| Comando | Qué hace |
|---|---|
| `docker logs CONTENEDOR` | Ver los registros de un contenedor |
| `docker logs -f CONTENEDOR` | Ver logs en tiempo real (streaming continuo, Ctrl+C para salir) |

### Acceso y control

| Comando | Qué hace |
|---|---|
| `docker exec -it CONTENEDOR bash` | Abrir una terminal dentro del contenedor |
| `docker restart CONTENEDOR` | Reiniciar un contenedor sin perder datos |
| `docker stop CONTENEDOR` | Detener un contenedor (queda guardado, no se elimina) |
| `docker start CONTENEDOR` | Arrancar un contenedor que estaba detenido |

> **Tip:** `CONTENEDOR` puede ser el nombre o el ID. Las primeras 3 letras del ID también funcionan.

### Daemon de Docker

| Comando | Qué hace |
|---|---|
| `sudo systemctl status docker` | Estado del servicio principal de Docker en el sistema |
| `sudo systemctl restart docker` | Reiniciar el motor Docker (afecta a todos los contenedores) |

---

## 5. Nextcloud

Nube privada de archivos y documentos.

```bash
cd ~/nextcloud                  # Ir al directorio de configuración
docker compose up -d            # Levantar todos los servicios en segundo plano
docker compose down             # Detener y eliminar los contenedores
docker compose ps               # Ver el estado actual de los contenedores
docker logs nextcloud           # Ver registros del contenedor principal
```

### Trusted domains (dominios autorizados)

```bash
# Listar las IPs/dominios desde donde se puede acceder
docker exec -it nextcloud php occ config:system:get trusted_domains
```

---

## 6. Jellyfin

Servidor de medios para películas, series y música.

```bash
cd ~/jellyfin                   # Ir al directorio de configuración
docker compose up -d            # Levantar el servidor de medios en segundo plano
docker logs jellyfin            # Ver registros (útil si no carga o falla)
```

---

## 7. Pi-hole

Bloqueador de anuncios y servidor DNS local.

```bash
cd ~/pihole                     # Ir al directorio de configuración
docker compose up -d            # Levantar Pi-hole en segundo plano
docker logs pihole              # Ver registros del contenedor
```

### Comandos internos de Pi-hole

| Comando | Qué hace |
|---|---|
| `docker exec -it pihole pihole status` | Verificar si Pi-hole está activo y bloqueando DNS |
| `docker exec -it pihole pihole setpassword NUEVA_CLAVE` | Cambiar la contraseña del panel web |

---

## 8. Portainer

Panel visual para administrar Docker desde el navegador.

| Comando | Qué hace |
|---|---|
| `docker logs portainer` | Ver los registros del panel Portainer |
| `docker restart portainer` | Reiniciar el panel si no carga o hay errores de sesión |

> **Acceso web:** `https://IP:9443` desde la red local.

---

## 9. Dashboard

Panel principal del proyecto IF5000.

```bash
cd ~/dashboard-if5000           # Ir al directorio del dashboard
docker compose up -d --build    # Reconstruir y levantar (usar si hubo cambios en el código)
docker logs dashboard-if5000    # Ver logs para detectar errores de inicio
```

---

## 10. Monitoreo

Stack completo: Prometheus (métricas) + Grafana (gráficas) + cAdvisor + Node Exporter.

```bash
cd ~/monitoring                 # Ir al directorio del stack de monitoreo
docker compose up -d            # Levantar todos los servicios de monitoreo juntos
```

### Logs por servicio

| Comando | Qué hace |
|---|---|
| `docker logs prometheus` | Logs del recolector de métricas |
| `docker logs grafana` | Logs del panel de visualización de gráficas |
| `docker logs cadvisor` | Logs del monitor de contenedores Docker |
| `docker logs node-exporter` | Logs del exportador de métricas del hardware |

---

## 11. Suricata y Fail2Ban

**Suricata** analiza el tráfico de red en tiempo real buscando amenazas. **Fail2Ban** bloquea IPs con demasiados intentos fallidos de login.

### Estado de los servicios

| Comando | Qué hace |
|---|---|
| `sudo systemctl status suricata` | Estado del sistema de detección de intrusos (IDS) |
| `sudo systemctl status fail2ban` | Estado del servicio de bloqueo de IPs |
| `sudo systemctl status ssh-monitor` | Estado del monitor de SSH personalizado del proyecto |
| `sudo systemctl status suricata-watcher` | Estado del watcher que procesa alertas de Suricata |
| `sudo systemctl status fail2ban-watcher` | Estado del watcher que procesa eventos de Fail2Ban |

### Reinicio

| Comando | Qué hace |
|---|---|
| `sudo systemctl restart suricata` | Reiniciar Suricata (recarga las reglas de detección) |
| `sudo systemctl restart fail2ban` | Reiniciar Fail2Ban (recarga las listas de IPs bloqueadas) |

### Ver IPs bloqueadas por Fail2Ban

| Comando | Qué hace |
|---|---|
| `sudo fail2ban-client status` | Lista todas las "jails" activas y cuántas IPs bloqueó cada una |
| `sudo fail2ban-client status sshd` | Ver qué IPs intentaron atacar SSH y fueron bloqueadas |

---

## 12. Tailscale

VPN mesh para acceso remoto seguro entre dispositivos.

| Comando | Qué hace |
|---|---|
| `tailscale ip` | Muestra la IP asignada dentro de la red VPN de Tailscale |
| `tailscale status` | Lista todos los dispositivos conectados a la red Tailscale |
| `tailscale whois IP` | Consulta información de un dispositivo por su IP de Tailscale |
| `tailscale version` | Versión del cliente Tailscale instalado |
| `sudo tailscale up` | Conectar (o reconectar) el servidor a la red Tailscale |

---

## 13. Logs del sistema

Todos estos comandos muestran eventos en tiempo real. Usar **Ctrl+C** para salir.

| Comando | Qué hace |
|---|---|
| `tail -f /var/log/auth.log` | Monitorear intentos de login SSH en tiempo real |
| `tail -f /var/log/fail2ban.log` | Ver en tiempo real qué IPs bloquea Fail2Ban |
| `tail -f /var/log/suricata/eve.json` | Alertas de Suricata en formato JSON (tráfico sospechoso) |
| `tail -f /var/log/suricata/fast.log` | Alertas de Suricata en formato legible (resumen rápido) |
| `journalctl -xe` | Ver errores recientes del sistema (servicios que fallaron, etc.) |
| `dmesg \| tail` | Últimos mensajes del kernel (hardware, arranque, errores de disco) |

---

## 14. Diagnóstico

### Puertos abiertos

| Comando | Qué hace |
|---|---|
| `ss -tlnp` | Lista todos los puertos TCP que están escuchando y qué proceso los usa |

### Procesos

| Comando | Qué hace |
|---|---|
| `ps aux` | Lista todos los procesos con usuario y uso de recursos |
| `top` | Monitor interactivo de procesos y uso de CPU/RAM en tiempo real |

### Espacio en disco

| Comando | Qué hace |
|---|---|
| `du -sh *` | Muestra el tamaño de cada carpeta en el directorio actual |

### Contenedores

| Comando | Qué hace |
|---|---|
| `docker inspect CONTENEDOR` | Información detallada de configuración de un contenedor |
| `docker compose ps` | Estado de todos los contenedores del archivo compose actual |

---

## 15. Apagado y reinicio

### Apagar o reiniciar el servidor

| Comando | Qué hace |
|---|---|
| `sudo reboot` | Reinicia el servidor completamente |
| `sudo shutdown now` | Apaga el servidor de forma segura e inmediata |
| `sudo poweroff` | Apaga completamente el hardware (sin reinicio) |

### Contenedores

| Comando | Qué hace |
|---|---|
| `docker compose down` | Detiene y elimina los contenedores del directorio actual |
| `docker compose up -d` | Vuelve a levantar los contenedores en segundo plano |

### ✅ Secuencia de verificación post-reinicio

Después de reiniciar el servidor, seguir este orden:

```bash
sudo systemctl restart docker   # ① Asegurar que el motor Docker arrancó bien
docker ps                       # ② Confirmar que los contenedores están corriendo
systemctl status ssh            # ③ Verificar que SSH sigue activo
ip a                            # ④ Ver las IPs asignadas al servidor
ping -c 3 google.com            # ⑤ Confirmar que hay acceso a internet
```
