# Dashboard IF5000

| Campo         | Valor                              |
|---------------|------------------------------------|
| Servicio      | Dashboard IF5000                   |
| Puerto        | 8001                               |
| URL local     | http://192.168.50.100:8001         |
| URL Tailscale | http://100.91.206.50:8001          |
| Tecnología    | Python 3.12 / Django 5.x           |

Dashboard central del servidor Linux para el proyecto final de IF5000.  
Universidad de Costa Rica — Sede de Occidente, 2026.

**Integrantes:** Kendall · Sebas · Mariangel · Alejandro  
**Profesor:** MCi. W. Mauricio Fernández Araya

---

## ¿Qué hace?

- Muestra el estado en tiempo real de los servicios Docker (Nextcloud, Jellyfin, Portainer, Pi-hole)
- Métricas del servidor: CPU, RAM, Disco, Uptime, Procesos
- Lista de contenedores Docker con su estado
- Se actualiza automáticamente cada 30 segundos

---

## Stack tecnológico

| Capa       | Tecnología                        |
|------------|-----------------------------------|
| Backend    | Django 5.x / Python 3.12         |
| Métricas   | psutil                            |
| Docker API | Docker Python SDK                 |
| Frontend   | HTML + CSS + JavaScript (vanilla) |

---

## Correr localmente (desarrollo)

```bash
# 1. Clonar el repositorio
git clone <url-del-repo>
cd dashboard-if5000

# 2. Crear entorno virtual
python -m venv venv
venv\Scripts\activate    # Windows
source venv/bin/activate # Linux/Mac

# 3. Instalar dependencias
pip install -r requirements.txt

# 4. Correr el servidor
python manage.py runserver
```

Abrir http://127.0.0.1:8000

---

## Desplegar en el servidor con Docker

```bash
# 1. Clonar el repositorio en el servidor
git clone <url-del-repo>
cd dashboard-if5000

# 2. Construir y levantar el contenedor
docker compose up -d --build

# 3. Verificar que está corriendo
docker ps | grep dashboard
```

El dashboard queda disponible en:
```
http://100.91.206.50:8001
```

---

## docker-compose.yml

El archivo se encuentra en `compose/dashboard/docker-compose.yml`.

```yaml
services:
  dashboard:
    build: .
    container_name: dashboard-if5000
    ports:
      - "8001:8000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
```

> El volumen `/var/run/docker.sock` permite que Django consulte el estado
> de los contenedores Docker desde dentro del contenedor.
> El puerto externo es `8001` para evitar conflictos con otros servicios.

---

## Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

---

## Dependencias (requirements.txt)

```
django>=5.0
psutil
docker
requests
```

---

## Estructura del proyecto

```
dashboard-if5000/
├── README.md
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── manage.py
├── dashboard_if5000/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── servicios/
    ├── views.py
    ├── urls.py
    ├── utils.py
    ├── templates/
    │   └── servicios/
    │       └── index.html
    └── static/
        └── servicios/
            ├── css/
            │   └── style.css
            ├── js/
            │   └── dashboard.js
            └── logos/
                ├── nextcloud.png
                ├── jellyfin.png
                ├── portainer.png
                └── pihole.png
```

---

## Capturas de pantalla

**Configuración en el servidor:**

![docker-compose.yml con volúmenes para Docker socket, Fail2ban y Suricata](../screenshots/dashboard/01-dashboard-docker-compose-yml.png)

![Construcción y arranque del contenedor con docker compose up --build](../screenshots/dashboard/02-dashboard-docker-compose-up-build.png)

**Dashboard funcionando:**

![Dashboard versión inicial — servicios y métricas del servidor](../screenshots/dashboard/20-dashboard-panel-servicios.png)

![Dashboard completo — 7 servicios, métricas, contenedores y sección SOC](../screenshots/dashboard/21-dashboard-panel-completo.png)

---

## Fuentes

- Django Documentation: https://docs.djangoproject.com
- psutil Documentation: https://psutil.readthedocs.io
- Docker SDK for Python: https://docker-py.readthedocs.io
