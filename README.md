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
         ├── Nextcloud     (puerto 8080) — Almacenamiento en la nube
         ├── Jellyfin      (puerto 8096) — Servidor multimedia
         ├── Portainer     (puerto 9000) — Administración de Docker
         └── Pi-hole       (puerto 8053) — DNS y bloqueador de anuncios
```

---

## Tabla de servicios

| Servicio   | Puerto | URL Local                          | URL Tailscale                        |
|------------|--------|------------------------------------|--------------------------------------|
| Nextcloud  | 8080   | http://192.168.50.100:8080         | http://100.127.183.41:8080           |
| Jellyfin   | 8096   | http://192.168.50.100:8096         | http://100.127.183.41:8096           |
| Portainer  | 9000   | http://192.168.50.100:9000         | http://100.127.183.41:9000           |
| Pi-hole    | 8053   | http://192.168.50.100:8053/admin   | http://100.127.183.41:8053/admin     |
| SSH        | 22     | ssh adminuser@192.168.50.100       | ssh adminuser@100.127.183.41         |

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
| IP Tailscale      | 100.127.183.41           |
| SO                | Ubuntu Server 24.04.4 LTS |
| RAM asignada      | 4096 MB                  |
| CPUs              | 2                        |
| Disco             | 50 GB VDI dinámico       |
| Red VirtualBox    | Bridged Adapter          |

---

## Dispositivos en la red Tailscale

| Dispositivo         | IP Tailscale     |
|---------------------|-----------------|
| servidor-if5000     | 100.127.183.41  |
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
ssh adminuser@100.127.183.41

# Verificar Portainer (siempre activo por restart=always)
docker ps

# Levantar Nextcloud
cd ~/nextcloud && docker compose up -d

# Levantar Jellyfin
cd ~/jellyfin && docker compose up -d

# Levantar Pi-hole
cd ~/pihole && docker compose up -d

# Verificar todos los contenedores
docker ps
```

---

## Estructura del repositorio

```
proyecto-if5000/
├── README.md                    ← Este archivo
├── .gitignore
├── docs/
│   ├── 01-virtualbox.md         ← Configuración de la VM
│   ├── 02-ubuntu-server.md      ← Instalación del SO
│   ├── 03-red-netplan.md        ← Configuración de red
│   ├── 04-ssh.md                ← Acceso remoto SSH
│   ├── 05-docker.md             ← Instalación de Docker
│   ├── 06-portainer.md          ← Administración Docker UI
│   ├── 07-nextcloud.md          ← Almacenamiento en la nube
│   ├── 08-jellyfin.md           ← Servidor multimedia
│   ├── 09-pihole.md             ← DNS y bloqueador de anuncios
│   ├── 10-tailscale.md          ← VPN Tailscale
│   ├── 11-app-adicional.md      ← Aplicación adicional (pendiente)
│   └── 12-monitoreo-opcional.md ← Monitoreo opcional (pendiente)
├── compose/
│   ├── nextcloud/docker-compose.yml
│   ├── jellyfin/docker-compose.yml
│   ├── pihole/docker-compose.yml
│   └── monitoring/docker-compose.yml
├── config/
│   └── netplan/
│       ├── 00-installer-config-static.yaml
│       └── 00-installer-config-dhcp.yaml
└── screenshots/
    ├── README.md                ← Guía de capturas
    ├── virtualbox/
    ├── ubuntu/
    ├── ssh/
    ├── docker/
    ├── portainer/
    ├── nextcloud/
    ├── jellyfin/
    ├── pihole/
    ├── tailscale/
    └── monitoreo/
```

---

## Pendientes (checklist)

- [ ] Definir e implementar la aplicación adicional (`docs/11-app-adicional.md`)
- [ ] Implementar el stack de monitoreo opcional (`docs/12-monitoreo-opcional.md`)
- [ ] Agregar capturas de pantalla en todas las carpetas `screenshots/`
- [ ] Crear usuarios individuales por integrante del grupo en el servidor
- [ ] Verificar acceso desde celular vía Tailscale
- [ ] Preparar demostración para la fecha de entrega (29 de junio)
