# Capturas de pantalla

Convención de nombres: `##-descripcion-significativa.png`

- `01–19` → instalación (proceso paso a paso)
- `20–39` → pruebas (servicios funcionando, accesos, demos)
- `40+`   → opcionales (monitoreo, app adicional)

---

## `virtualbox/`

| Archivo | Estado |
|---------|--------|
| `01-vm-hardware-configuracion.png` | ⏳ pendiente |
| `02-vm-disco-50gb.png` | ⏳ pendiente |
| `03-vm-red-bridged-adapter.png` | ✅ |
| `20-vm-corriendo.png` | ✅ |
| `21-vm-snapshots-lista.png` | ✅ |

## `ubuntu/`

| Archivo | Estado |
|---------|--------|
| `01-instalador-red-dhcp.png` | ✅ |
| `02-instalador-mirror.png` | ✅ |
| `03-instalador-disco.png` | ✅ |
| `04-instalador-perfil.png` | ✅ |
| `05-instalador-openssh.png` | ✅ |
| `06-instalador-instalando.png` | ✅ |
| `07-instalador-ip-estatica.png` | ✅ |
| `20-ubuntu-apt-update.png` | ✅ |
| `21-ping-internet.png` | ⏳ pendiente |
| `22-ping-dns.png` | ⏳ pendiente |

## `ssh/`

| Archivo | Estado |
|---------|--------|
| `01-ssh-primera-conexion-windows.png` | ✅ |
| `20-ssh-tailscale-conexion.png` | ✅ |
| `21-ssh-otra-red-tailscale.png` | ⏳ pendiente |

## `docker/`

| Archivo | Estado |
|---------|--------|
| `01-docker-version.png` | ✅ |
| `02-docker-hello-world.png` | ✅ |
| `03-docker-instalacion-repositorio.png` | ✅ |
| `20-docker-ps-todos-servicios.png` | ✅ |
| `21-docker-images.png` | ✅ |

## `portainer/`

| Archivo | Estado |
|---------|--------|
| `01-portainer-docker-ps.png` | ✅ |
| `20-portainer-home.png` | ✅ |
| `21-portainer-contenedores.png` | ✅ |
| `22-portainer-logs.png` | ⏳ pendiente |
| `23-portainer-stats.png` | ⏳ pendiente |

## `nextcloud/`

| Archivo | Estado |
|---------|--------|
| `01-nextcloud-docker-compose-up.png` | ✅ |
| `02-nextcloud-instalador.png` | ✅ |
| `20-nextcloud-login.png` | ✅ |
| `21-nextcloud-panel.png` | ✅ |
| `22-nextcloud-subida-archivo.png` | ✅ |
| `23-nextcloud-compartir.png` | ✅ |
| `24-nextcloud-celular.png` | ⏳ pendiente |

## `jellyfin/`

| Archivo | Estado |
|---------|--------|
| `01-jellyfin-docker-ps.png` | ✅ |
| `02-jellyfin-instalador.png` | ✅ |
| `03-jellyfin-biblioteca.png` | ✅ |
| `20-jellyfin-panel.png` | ✅ |
| `21-jellyfin-reproduccion.png` | ✅ |
| `22-jellyfin-celular.png` | ⏳ pendiente |

## `pihole/`

| Archivo | Estado |
|---------|--------|
| `01-pihole-docker-compose-up.png` | ✅ |
| `20-pihole-dashboard.png` | ✅ |
| `21-pihole-blocklist.png` | ✅ |
| `22-pihole-grafico-consultas.png` | ✅ |
| `23-pihole-cliente-dns.png` | ⏳ pendiente |

## `tailscale/`

| Archivo | Estado |
|---------|--------|
| `01-tailscale-ip.png` | ✅ |
| `02-tailscale-status.png` | ✅ |
| `20-tailscale-admin-panel.png` | ⏳ pendiente |
| `21-tailscale-ssh.png` | ⏳ pendiente |
| `22-tailscale-ssh-otra-red.png` | ⏳ pendiente |

## `monitoreo/`

| Archivo | Estado |
|---------|--------|
| `40-grafana-dashboard.png` | ✅ |
| `41-prometheus-targets.png` | ✅ |
| `42-cadvisor-contenedores.png` | ✅ |

## `dashboard/`

| Archivo | Estado |
|---------|--------|
| `01-dashboard-docker-compose-yml.png` | ✅ |
| `02-dashboard-docker-compose-up-build.png` | ✅ |
| `20-dashboard-panel-servicios.png` | ✅ |
| `21-dashboard-panel-completo.png` | ✅ |

---

**Para insertar capturas en los docs:**

```markdown
![Descripción](../screenshots/servicio/##-nombre.png)
```
