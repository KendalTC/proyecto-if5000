# 13 — Tabla de Puertos del Servidor

## Servicios Docker

| Puerto | Protocolo | Servicio         | Descripción                        |
|--------|-----------|------------------|------------------------------------|
| 22     | TCP       | SSH              | Acceso remoto seguro               |
| 53     | TCP/UDP   | Pi-hole DNS      | Servidor DNS                       |
| 8001   | TCP       | Dashboard IF5000 | Panel de control del servidor      |
| 8053   | TCP       | Pi-hole Web UI   | Interfaz web de administración     |
| 8080   | TCP       | Nextcloud        | Almacenamiento en la nube          |
| 8096   | TCP       | Jellyfin         | Servidor multimedia                |
| 9000   | TCP       | Portainer        | Administración de Docker           |
| 3000   | TCP       | Grafana          | Visualización de métricas          |
| 8082   | TCP       | cAdvisor         | Métricas de contenedores Docker    |
| 9090   | TCP       | Prometheus       | Recolección y almacenamiento de métricas |
| 9100   | TCP       | Node Exporter    | Métricas del sistema operativo     |

## Servicios del sistema (sin puerto expuesto)

| Servicio         | Tipo    | Puerto | Descripción |
|------------------|---------|--------|-------------|
| Suricata IDS     | systemd | —      | Monitorea el tráfico de red, genera alertas en `/var/log/suricata/eve.json` |
| Fail2ban         | systemd | —      | Bloquea IPs via iptables, no expone puerto propio |
| suricata-watcher | systemd | —      | Daemon SOC — lee eve.json y envía alertas a Discord |
| fail2ban-watcher | systemd | —      | Daemon SOC — detecta SCAN/Nmap y envía alertas a Discord |
| ssh-monitor      | systemd | —      | Daemon SOC — monitorea auth.log y envía alertas de login a Discord |
