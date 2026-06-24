# 12 — Monitoreo (Prometheus + Grafana) — Opcional

Resumen
Esta guía describe cómo desplegar un stack de monitoreo ligero con Prometheus, Grafana, node_exporter y cAdvisor para recolectar métricas del host y de contenedores.

Contenido
- Archivos: compose/monitoring/docker-compose.yml, compose/monitoring/prometheus.yml

Despliegue rápido
1. Copiar compose/monitoring/* en el servidor (por ejemplo, ~/monitoring)
2. Ejecutar: docker compose up -d
3. Abrir Grafana: http://<IP>:3000 (usuario: admin / contraseña: admin)
4. Abrir Prometheus: http://<IP>:9090

Notas de configuración
- node_exporter: para métricas del host, ejecutar con network_mode: host o instalar node_exporter directamente en el host.
- cAdvisor: expone métricas de contenedores en :8080; Prometheus las scrapea como "cadvisor" target.
- Si Docker no dispone de host.docker.internal, reemplazar targets en prometheus.yml por la IP del host.

Provisionamiento de Grafana
- Se puede provisionar datasource y dashboards mediante archivos en ./provisioning.
- Alternativa rápida: iniciar sesión (admin/admin) y añadir Prometheus como datasource apuntando a http://prometheus:9090
- Importar dashboards: official Node Exporter / cAdvisor dashboards (JSON) o crear paneles básicos: CPU, memoria, uso de disco y uso de contenedores.

Criterios de aceptación
- Prometheus scraping funcionando (ver Status -> Targets)
- Grafana puede consultar Prometheus y mostrar al menos un panel con métricas de CPU o memoria

Siguientes pasos (mejoras)
- Añadir alertmanager y reglas de alerta
- Provisionar dashboards de ejemplo en repo (docs + provisioning)
