# 13 — Tabla de Puertos del Servidor

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
