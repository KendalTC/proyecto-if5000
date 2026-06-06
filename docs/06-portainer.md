# 06 — Portainer (Administración de Docker)

| Campo         | Valor                            |
|---------------|----------------------------------|
| Servicio      | Portainer Community Edition      |
| Puerto        | 9000                             |
| URL local     | http://192.168.50.100:9000       |
| URL Tailscale | http://100.91.206.50:9000       |

---

## 1. ¿Qué es Portainer?

Portainer es una interfaz web para administrar Docker. Permite visualizar y gestionar contenedores, imágenes, volúmenes y redes sin necesidad de usar la línea de comandos. Es ideal para supervisar el estado de todos los servicios del proyecto desde el navegador.

**Funcionalidades principales:**
- Ver contenedores en ejecución y su estado
- Iniciar, detener y reiniciar contenedores
- Ver los logs de cualquier contenedor en tiempo real
- Monitorear el uso de CPU y memoria por contenedor
- Administrar imágenes y volúmenes

---

## 2. Instalación

Portainer se instala directamente con Docker, sin necesidad de `docker-compose.yml`.

```bash
# Crear el volumen para persistir los datos de Portainer
docker volume create portainer_data

# Ejecutar el contenedor de Portainer
docker run -d \
  -p 8000:8000 \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

Verificar que el contenedor esté activo:

```bash
docker ps | grep portainer
```

---

## 3. Primera configuración

1. Abrir el navegador y acceder a `http://100.91.206.50:9000`.
2. La primera vez, Portainer solicita crear un usuario administrador:
   - **Username:** admin
   - **Password:** (definida por el grupo — mínimo 12 caracteres)
3. Seleccionar **Get Started** para conectar con el entorno Docker local.
4. Seleccionar el ambiente **local** y hacer clic en **Connect**.

---

## 4. Navegación básica en Portainer

- **Home:** Vista general de todos los ambientes Docker conectados.
- **Containers:** Lista de todos los contenedores con su estado, IP y puertos.
- **Images:** Imágenes descargadas localmente.
- **Volumes:** Volúmenes persistentes de Docker.
- **Networks:** Redes virtuales de Docker.
- **Logs:** Ver los logs de un contenedor en tiempo real desde el navegador.
- **Console:** Acceso a la terminal de un contenedor directamente desde el navegador.

---

## 5. Verificar que Portainer inicia automáticamente

La opción `--restart=always` asegura que Portainer se reinicie automáticamente si el servidor se reinicia:

```bash
# Verificar la política de reinicio
docker inspect portainer | grep -i restart
```

---

## Capturas de pantalla

![Panel principal de Portainer con el ambiente local conectado](../screenshots/portainer/portainer-home.png)

![Lista de contenedores activos en Portainer](../screenshots/portainer/portainer-contenedores.png)

![Logs de un contenedor desde el navegador](../screenshots/portainer/portainer-logs.png)

![Estadísticas de uso de recursos por contenedor](../screenshots/portainer/portainer-stats.png)
