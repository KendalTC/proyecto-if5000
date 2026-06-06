> ⚠️ Esta sección está pendiente de implementar. Corresponde al elemento opcional (+15 pts).

# 12 — Monitoreo del Sistema (Opcional — +15 pts)

| Campo         | Valor                            |
|---------------|----------------------------------|
| Prometheus    | Puerto 9090 — http://100.127.183.41:9090 |
| Grafana       | Puerto 3000 — http://100.127.183.41:3000 |
| cAdvisor      | Puerto 8081 — http://100.127.183.41:8081 |

---

## 1. Stack de monitoreo

La solución de monitoreo propuesta utiliza tres herramientas complementarias:

| Herramienta  | Función                                                    |
|-------------|-------------------------------------------------------------|
| **Prometheus**  | Recolector de métricas del sistema y de los contenedores |
| **Grafana**     | Visualización de métricas en dashboards interactivos     |
| **cAdvisor**    | Exporter de métricas de los contenedores Docker          |

---

## 2. Instalación

El archivo `docker-compose.yml` del stack de monitoreo se encuentra en `compose/monitoring/docker-compose.yml`.

```bash
mkdir -p ~/monitoring
cd ~/monitoring
# Copiar el docker-compose.yml del repositorio
docker compose up -d
```

**[COMPLETAR]** — Incluir el archivo `prometheus.yml` de configuración con los targets a monitorear.

Ejemplo de `prometheus.yml`:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

---

## 3. Configuración de Grafana

1. Acceder a `http://100.127.183.41:3000`.
2. Iniciar sesión con `admin` / `admin` (cambiar contraseña al primer acceso).
3. Agregar Prometheus como datasource:
   - **Configuration** → **Data Sources** → **Add data source**.
   - Tipo: Prometheus.
   - URL: `http://prometheus:9090`.
4. Importar dashboard predefinido:
   - **+** → **Import**.
   - Dashboard ID de Grafana.com: `193` (cAdvisor Docker) o `1860` (Node Exporter).

---

## 4. Dashboard de métricas

**[COMPLETAR]** — Describir las métricas monitoreadas:

- Uso de CPU por contenedor y del sistema completo
- Uso de RAM (total, disponible, por contenedor)
- Actividad de red (bytes enviados/recibidos)
- Procesos activos del sistema
- Uso de disco

---

## Capturas de pantalla

![Dashboard de Grafana con métricas de CPU y RAM](../screenshots/monitoreo/grafana-dashboard.png)

![Panel de Prometheus con targets activos](../screenshots/monitoreo/prometheus-targets.png)

![cAdvisor mostrando uso de recursos por contenedor](../screenshots/monitoreo/cadvisor-contenedores.png)
