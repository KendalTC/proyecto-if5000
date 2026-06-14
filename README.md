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
         ├── Pi-hole       (puerto 8053) — DNS y bloqueador de anuncios
         └── Dashboard     (puerto 8001) — Panel de control del servidor
```

---

## Tabla de servicios

| Servicio   | Puerto | URL Local                          | URL Tailscale                        |
|------------|--------|------------------------------------|--------------------------------------|
| Nextcloud  | 8080   | http://192.168.50.100:8080         | http://100.91.206.50:8080           |
| Jellyfin   | 8096   | http://192.168.50.100:8096         | http://100.91.206.50:8096           |
| Portainer  | 9000   | http://192.168.50.100:9000         | http://100.91.206.50:9000           |
| Pi-hole          | 8053   | http://192.168.50.100:8053/admin   | http://100.91.206.50:8053/admin     |
| Dashboard IF5000 | 8001   | http://192.168.50.100:8001         | http://100.91.206.50:8001           |
| SSH              | 22     | ssh adminuser@192.168.50.100       | ssh adminuser@100.91.206.50         |

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

# Verificar todos los contenedores
docker ps
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

### Opcionales / En desarrollo

| # | Documento | Estado |
|---|-----------|--------|
| 11 | [Aplicación adicional](docs/11-app-adicional.md) | ⏳ Pendiente |
| 12 | [Monitoreo — Prometheus + Grafana](docs/12-monitoreo-opcional.md) | ⏳ Pendiente |
| 13 | [Tabla de puertos del servidor](docs/13-puertos.md) | ✅ Completado |

### Evidencias visuales

- [Capturas de pantalla — índice y estado](screenshots/README.md)

---

## Estructura del repositorio

```
proyecto-if5000/
├── README.md                    ← Este archivo
├── docs/                        ← Documentación completa (ver tabla anterior)
├── compose/
│   ├── nextcloud/docker-compose.yml
│   ├── jellyfin/docker-compose.yml
│   ├── pihole/docker-compose.yml
│   ├── dashboard/docker-compose.yml
│   └── monitoring/docker-compose.yml
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
    └── app-adicional/
```

---

## Pendientes (checklist)

- [x] Crear usuarios individuales por integrante del grupo en el servidor
- [ ] Definir e implementar la aplicación adicional (`docs/11-app-adicional.md`)
- [ ] Implementar el stack de monitoreo opcional (`docs/12-monitoreo-opcional.md`)
- [ ] Agregar capturas de pantalla en todas las carpetas `screenshots/`
- [ ] Verificar acceso desde celular vía Tailscale
- [ ] Preparar demostración para la fecha de entrega (29 de junio)
