# Guía de capturas de pantalla

Este directorio contiene las evidencias visuales del proyecto. Cada subdirectorio corresponde a un servicio o componente del sistema. A continuación se detalla qué capturar en cada carpeta.

---

## `virtualbox/`

- VM creada con los parámetros correctos (RAM 4096 MB, 2 CPUs, disco 50 GB)
- Configuración de red Bridged Adapter con MediaTek Wi-Fi 6 MT7921
- Lista de snapshots: "Ubuntu base actualizado", "Docker instalado OK", "Portainer instalado OK", "Acceso remoto Tailscale verificado", "Nextcloud instalado OK", "Jellyfin instalado OK"
- Consola de VirtualBox mostrando la VM en ejecución

## `ubuntu/`

- Terminal con la salida de `ip a` (mostrando IP 192.168.50.100)
- Terminal con la salida de `free -h` (memoria RAM disponible)
- Terminal con la salida de `df -h` (uso del disco)
- Terminal con `uname -a` (versión del SO)
- Proceso de actualización del sistema (`apt update && apt upgrade`)

## `ssh/`

- Conexión SSH exitosa desde PowerShell en Windows (`ssh adminuser@192.168.50.100`)
- Conexión SSH exitosa vía Tailscale (`ssh adminuser@100.127.183.41`)
- Conexión SSH desde el celular (app Termius u otra)
- Salida de `who` mostrando múltiples usuarios conectados simultáneamente

## `docker/`

- Salida de `docker ps` con todos los contenedores corriendo
- Salida de `docker run hello-world` (verificación inicial)
- Salida de `docker images` listando las imágenes descargadas

## `portainer/`

- Panel principal de Portainer en el navegador (`http://100.127.183.41:9000`)
- Vista de contenedores activos en Portainer
- Detalle de un contenedor (logs, estadísticas)

## `nextcloud/`

- Pantalla de login de Nextcloud (`http://100.127.183.41:8080`)
- Panel principal con archivos
- Subida de un archivo
- Compartir un archivo con enlace
- Acceso desde el celular (app Nextcloud)

## `jellyfin/`

- Panel principal de Jellyfin (`http://100.127.183.41:8096`)
- Biblioteca de películas/música configurada
- Reproducción de un archivo multimedia
- Acceso desde el celular (app Jellyfin)

## `pihole/`

- Dashboard de Pi-hole con estadísticas de DNS (`http://100.127.183.41:8053/admin`)
- Gráfico de consultas DNS bloqueadas vs. permitidas
- Lista de dominios bloqueados

## `tailscale/`

- Panel de admin.tailscale.com mostrando todos los dispositivos conectados
- IP de Tailscale en el servidor (`tailscale ip`)
- Ping exitoso desde un cliente al servidor vía Tailscale

## `monitoreo/`

- Dashboard de Grafana con métricas de CPU, RAM y red
- Panel de Prometheus mostrando métricas recolectadas
- Vista de cAdvisor con uso de recursos por contenedor

---

**Instrucciones para insertar capturas:**

1. Tomar la captura y guardarla en la carpeta correspondiente con un nombre descriptivo (ej: `docker-ps-corriendo.png`).
2. En el archivo `.md` correspondiente en `docs/`, insertar la imagen con:
   ```markdown
   ![Descripción de la imagen](../screenshots/servicio/nombre-archivo.png)
   ```
