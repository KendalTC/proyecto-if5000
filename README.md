# Proyecto IF5000 — Redes y Comunicaciones de Datos

**Universidad de Costa Rica — Sede de Occidente**  
**Curso:** IF5000 Redes y Comunicaciones de Datos — Bach. Informática Empresarial  
**Profesor:** MCi. W. Mauricio Fernández Araya  
**Fecha de entrega:** Lunes 29 de junio de 2026 — Presencial

---

## Descripción general

Implementación de un entorno cliente-servidor sobre Ubuntu Server 24.04 ejecutado en VirtualBox. El servidor expone múltiples servicios mediante Docker y es accesible de forma remota a través de SSH y VPN (Tailscale). El objetivo es demostrar la instalación, configuración y operación de servicios de red en un entorno virtualizado.

---

## Arquitectura del sistema

```
Clientes (PC / Celular con Tailscale)
             |
    Internet / Tailscale VPN
             |
  Servidor Linux — Ubuntu Server 24.04
          (VirtualBox — Bridged Adapter)
             |
       Docker Engine
         ├── Nextcloud       (puerto 8080) — Almacenamiento en la nube
         ├── Jellyfin        (puerto 8096) — Servidor multimedia
         ├── Portainer       (puerto 9000) — Administración de Docker
         ├── Pi-hole         (puerto 8053) — DNS y bloqueador de anuncios
         ├── Dashboard       (puerto 8001) — Panel de control del servidor
         ├── Prometheus      (puerto 9090) — Recolección de métricas
         ├── Grafana         (puerto 3000) — Visualización de métricas
         ├── Node Exporter   (puerto 9100) — Métricas del sistema
         └── cAdvisor        (puerto 8082) — Métricas de contenedores
             |
       Servicios del SO (systemd — sin contenedor)
         ├── Suricata IDS    — Detección de intrusiones de red → eve.json
         ├── Fail2ban        — Bloqueo automático de IPs por fuerza bruta
         └── SOC Alerting    — Scripts que leen logs y envían alertas a Discord
```

---

## Tabla de servicios

### Servicios Docker

| Servicio       | Puerto | URL Local                          | URL Tailscale                        |
|----------------|--------|------------------------------------|--------------------------------------|
| Nextcloud      | 8080   | http://192.168.50.100:8080         | http://100.91.206.50:8080           |
| Jellyfin       | 8096   | http://192.168.50.100:8096         | http://100.91.206.50:8096           |
| Portainer      | 9000   | http://192.168.50.100:9000         | http://100.91.206.50:9000           |
| Pi-hole        | 8053   | http://192.168.50.100:8053/admin   | http://100.91.206.50:8053/admin     |
| Dashboard IF5000 | 8001 | http://192.168.50.100:8001         | http://100.91.206.50:8001           |
| Prometheus     | 9090   | http://192.168.50.100:9090         | http://100.91.206.50:9090           |
| Grafana        | 3000   | http://192.168.50.100:3000         | http://100.91.206.50:3000           |
| cAdvisor       | 8082   | http://192.168.50.100:8082         | http://100.91.206.50:8082           |
| Node Exporter  | 9100   | (interno)                          | (interno)                           |
| SSH            | 22     | ssh adminuser@192.168.50.100       | ssh adminuser@100.91.206.50         |

### Servicios del sistema (sin contenedor)

| Servicio         | Tipo    | Estado   | Descripción |
|------------------|---------|----------|-------------|
| Suricata IDS     | systemd | activo   | Detección de intrusiones — genera alertas en `/var/log/suricata/eve.json` |
| Fail2ban         | systemd | activo   | Bloqueo automático de IPs con fuerza bruta SSH |
| suricata-watcher | systemd | activo   | Script SOC — alertas Suricata agregadas → Discord |
| fail2ban-watcher | systemd | activo   | Script SOC — detección SCAN/Nmap en tiempo real → Discord |
| ssh-monitor      | systemd | activo   | Script SOC — alertas de login SSH → Discord |

---

## Datos del servidor

| Campo             | Valor                    |
|-------------------|--------------------------|
| Hostname          | servidor-if5000          |
| Usuario admin     | adminuser                |
| IP estática local | 192.168.50.100           |
| Subred            | 192.168.50.0/24          |
| Gateway           | 192.168.50.1             |
| DNS               | 8.8.8.8                  |
| IP Tailscale      | 100.91.206.50            |
| SO                | Ubuntu Server 24.04.4 LTS |
| RAM asignada      | 6046 MB                  |
| CPUs              | 4                        |
| Disco             | 50 GB VDI dinámico       |
| Red VirtualBox    | Bridged Adapter          |

---

## Dispositivos en la red Tailscale

| Dispositivo         | IP Tailscale     |
|---------------------|-----------------|
| servidor-if5000     | 100.91.206.50   |
| iPhone-15-pro       | 100.68.123.84   |
| kendalltc (Windows) | 100.67.254.26   |

---

## Rubros de evaluación

| Rubro                                        | Puntos |
|----------------------------------------------|--------|
| Configuración servidor Linux                 | 15 pts |
| Virtualización (VirtualBox)                  | 10 pts |
| Acceso remoto SSH                            | 10 pts |
| Docker y Docker Compose                      | 15 pts |
| Almacenamiento (Nextcloud)                   | 20 pts |
| Servidor multimedia (Jellyfin)               | 10 pts |
| Servicios de red (VPN + Pi-hole)             | 10 pts |
| Administración remota (Portainer)            |  5 pts |
| Aplicación adicional                         |  5 pts |
| Exposición y demostración                    | 10 pts |
| **Opcional:** Monitoreo (Prometheus+Grafana) | +15 pts |
| **Opcional:** Mejor rendimiento CPU/RAM      |  +5 pts |

---

## Cómo levantar el servidor

Conectarse al servidor y levantar todos los servicios:

```bash
# Conectar vía SSH
ssh adminuser@100.91.206.50

# Verificar Portainer (siempre activo por restart=always)
docker ps

# Levantar Nextcloud
cd ~/nextcloud && docker compose up -d

# Levantar Jellyfin
cd ~/jellyfin && docker compose up -d

# Levantar Pi-hole
cd ~/pihole && docker compose up -d

# Levantar Dashboard
cd ~/dashboard-if5000 && docker compose up -d

# Levantar stack de monitoreo
cd ~/monitoring && docker compose up -d

# Verificar todos los contenedores
docker ps
```

### Verificar servicios de seguridad (systemd)

Los servicios de Suricata, Fail2ban y el sistema SOC se inician automáticamente con el servidor. Para verificar su estado:

```bash
# Estado de los servicios de seguridad
sudo systemctl status suricata
sudo systemctl status fail2ban

# Estado de los daemons SOC
sudo systemctl status suricata-watcher
sudo systemctl status fail2ban-watcher
sudo systemctl status ssh-monitor

# Ver alertas recientes de Suricata
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'

# Ver bans activos de Fail2ban
sudo fail2ban-client status sshd

# Dashboard CLI de seguridad
bash /home/mariangel/soc-alerting/scripts/soc-dashboard.sh
```

---

## Documentación

### Infraestructura base

| # | Documento | Descripción |
|---|-----------|-------------|
| 01 | [Configuración de VirtualBox](docs/01-virtualbox.md) | Creación y configuración de la VM |
| 02 | [Instalación de Ubuntu Server](docs/02-ubuntu-server.md) | Instalación del sistema operativo |
| 03 | [Configuración de red — Netplan](docs/03-red-netplan.md) | IP estática y configuración de red |
| 04 | [Acceso remoto SSH](docs/04-ssh.md) | Conexión SSH local y vía Tailscale |
| 05 | [Instalación de Docker](docs/05-docker.md) | Docker Engine y Docker Compose |

### Servicios Docker

| # | Documento | Puerto |
|---|-----------|--------|
| 06 | [Portainer — Administración de Docker](docs/06-portainer.md) | 9000 |
| 07 | [Nextcloud — Almacenamiento en la nube](docs/07-nextcloud.md) | 8080 |
| 08 | [Jellyfin — Servidor multimedia](docs/08-jellyfin.md) | 8096 |
| 09 | [Pi-hole — DNS y bloqueador de anuncios](docs/09-pihole.md) | 8053 |
| 10 | [Tailscale — VPN](docs/10-tailscale.md) | — |
| — | [Dashboard IF5000](docs/dashboard.md) | 8001 |

### Seguridad y SOC

| # | Documento | Descripción |
|---|-----------|-------------|
| 14 | [Suricata IDS](docs/14-suricata.md) | Detección de intrusiones de red |
| 15 | [Fail2ban](docs/15-fail2ban.md) | Bloqueo automático de IPs por fuerza bruta |
| 16 | [SOC — Alertas a Discord](docs/16-soc-discord.md) | Sistema de alertas en tiempo real con scripts y systemd |

### Opcionales / En desarrollo

| # | Documento | Estado |
|---|-----------|--------|
| 11 | [Aplicación adicional](docs/11-app-adicional.md) | ⏳ Pendiente |
| 12 | [Monitoreo — Prometheus + Grafana](docs/12-monitoreo-opcional.md) | ✅ Completado |
| 13 | [Tabla de puertos del servidor](docs/13-puertos.md) | ✅ Completado |

### Evidencias visuales

- [Capturas de pantalla — índice y estado](screenshots/README.md)

---

## Estructura del repositorio

```
proyecto-if5000/
├── README.md                    ← Este archivo
├── docs/                        ← Documentación completa (ver tabla anterior)
│   ├── 01-virtualbox.md
│   ├── 02-ubuntu-server.md
│   ├── 03-red-netplan.md
│   ├── 04-ssh.md
│   ├── 05-docker.md
│   ├── 06-portainer.md
│   ├── 07-nextcloud.md
│   ├── 08-jellyfin.md
│   ├── 09-pihole.md
│   ├── 10-tailscale.md
│   ├── 11-app-adicional.md
│   ├── 12-monitoreo-opcional.md
│   ├── 13-puertos.md
│   ├── 14-suricata.md           ← Suricata IDS
│   ├── 15-fail2ban.md           ← Fail2ban
│   └── 16-soc-discord.md       ← Sistema SOC + alertas Discord
├── scripts/                     ← Scripts SOC (se despliegan en el servidor)
│   ├── suricata-watcher.sh      ← Alertas Suricata agregadas → Discord
│   ├── soc-engine.sh            ← Monitor SSH (logins/logouts) → Discord
│   ├── soc-v2.sh                ← Motor de correlación Suricata+Fail2ban → Discord
│   ├── fail2ban-watcher.sh      ← Detección SCAN/Nmap en tiempo real → Discord
│   ├── fail2ban-realtime.sh     ← Bans de Fail2ban en tiempo real → Discord
│   ├── fail2ban-alerta.sh       ← Test manual de alerta simulada
│   ├── soc-dashboard.sh         ← Dashboard CLI (IPs baneadas, uptime)
│   └── test-discord.sh          ← Test de conectividad del webhook
├── systemd/                     ← Archivos de servicio systemd para los daemons SOC
│   ├── suricata-watcher.service
│   ├── fail2ban-watcher.service
│   └── ssh-monitor.service
├── compose/
│   ├── nextcloud/docker-compose.yml
│   ├── jellyfin/docker-compose.yml
│   ├── pihole/docker-compose.yml
│   ├── dashboard/docker-compose.yml
│   └── monitoring/
│       ├── docker-compose.yml
│       └── prometheus.yml
├── config/
│   └── netplan/
│       ├── 00-installer-config-static.yaml
│       └── 00-installer-config-dhcp.yaml
└── screenshots/
    ├── README.md                ← Índice de capturas con estado
    ├── virtualbox/
    ├── ubuntu/
    ├── ssh/
    ├── docker/
    ├── portainer/
    ├── nextcloud/
    ├── jellyfin/
    ├── pihole/
    ├── tailscale/
    ├── monitoreo/
    ├── soc/                     ← Capturas del sistema SOC y alertas Discord
    └── app-adicional/
```

---

## Pendientes para la entrega — 29 de junio de 2026

### Infraestructura y servicios
- [x] Crear usuarios individuales por integrante del grupo en el servidor
- [x] Implementar el stack de monitoreo opcional — Prometheus + Grafana (`docs/12-monitoreo-opcional.md`)
- [x] Instalar y configurar Suricata IDS (`docs/14-suricata.md`)
- [x] Instalar y configurar Fail2ban (`docs/15-fail2ban.md`)
- [x] Implementar sistema SOC con alertas a Discord (`docs/16-soc-discord.md`)
- [ ] Definir e implementar la aplicación adicional (`docs/11-app-adicional.md`)

### Demostraciones pendientes
- [ ] **Pi-hole** — Configurar DNS en un dispositivo (celular o PC) apuntando a `192.168.50.100` y demostrar bloqueo de anuncios en tiempo real
- [ ] **Jellyfin** — Subir archivos multimedia al servidor para demostrar reproducción de video/audio
- [ ] **Nextcloud** — Subir archivos y demostrar sincronización y compartir desde un segundo dispositivo
- [ ] **Tailscale** — Verificar y fotografiar acceso a los servicios desde celular vía VPN

### Documentación
- [ ] Completar y exportar el archivo Word (`DOCUMENTACION.docx`) con secciones de monitoreo y SOC
- [ ] Agregar capturas faltantes en `screenshots/` (app-adicional, tailscale-admin-panel)

### Presentación y entrega
- [ ] Crear presentación (diapositivas) con arquitectura, servicios y demostración del proyecto
- [ ] Planear el orden de la demostración en vivo para la exposición del 29 de junio
- [ ] Ensayar la demostración completa con todos los integrantes
