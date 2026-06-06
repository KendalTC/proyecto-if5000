# 07 — Nextcloud (Almacenamiento en la Nube)

| Campo         | Valor                            |
|---------------|----------------------------------|
| Servicio      | Nextcloud                        |
| Puerto        | 8080                             |
| URL local     | http://192.168.50.100:8080       |
| URL Tailscale | http://100.91.206.50:8080       |
| Usuario admin | admin                            |

---

## 1. ¿Qué es Nextcloud?

Nextcloud es una plataforma de almacenamiento y colaboración en la nube de código abierto. Ofrece funcionalidades similares a Google Drive o Dropbox, pero alojada en el propio servidor. Permite subir, sincronizar y compartir archivos desde cualquier dispositivo.

**Funcionalidades a demostrar:**
- Subir y descargar archivos desde el navegador
- Compartir archivos con enlace público
- Acceso desde el celular con la app oficial de Nextcloud
- Sincronización de archivos entre dispositivos

---

## 2. Directorio del servicio

```bash
mkdir -p ~/nextcloud
cd ~/nextcloud
```

El archivo `docker-compose.yml` se encuentra en este directorio y también en `compose/nextcloud/docker-compose.yml` del repositorio.

---

## 3. Archivo docker-compose.yml

```yaml
services:
  nextcloud:
    image: nextcloud
    container_name: nextcloud
    ports:
      - "8080:80"
    volumes:
      - nextcloud_data:/var/www/html
    environment:
      - NEXTCLOUD_ADMIN_USER=admin
      - NEXTCLOUD_ADMIN_PASSWORD=admin1234
    restart: always

volumes:
  nextcloud_data:
```

---

## 4. Levantar el servicio

```bash
cd ~/nextcloud
docker compose up -d
```

Verificar que el contenedor esté activo:

```bash
docker ps | grep nextcloud
```

---

> **Problema frecuente:** Si aparece el error "Can't write into config directory",
> corregirlo con:
> ```bash
> docker exec -it nextcloud chown -R www-data:www-data /var/www/html/config
> ```
> Luego recargar el navegador.

> **Base de datos:** Para este proyecto se usa SQLite por simplicidad.
> Es suficiente para un entorno de demostración. Para producción se
> recomienda MySQL/MariaDB.

## 5. Detener el servicio

```bash
cd ~/nextcloud
docker compose down
```

---

## 6. Configuración de trusted_domains para Tailscale

Por defecto, Nextcloud solo acepta conexiones desde el dominio o IP configurada durante la instalación. Para permitir el acceso vía Tailscale, se deben agregar los dominios permitidos:

```bash
# Agregar IP de Tailscale como dominio confiable
docker exec -it nextcloud php occ config:system:set trusted_domains 1 --value=192.168.50.100:8080
docker exec -it nextcloud php occ config:system:set trusted_domains 2 --value=100.91.206.50
docker exec -it nextcloud php occ config:system:set trusted_domains 3 --value=100.91.206.50:8080

# Reiniciar el contenedor para aplicar los cambios
docker restart nextcloud
```

**trusted_domains configurados:**

| Índice | Dominio                  |
|--------|--------------------------|
| 0      | localhost                |
| 1      | 192.168.50.100:8080      |
| 2      | 100.91.206.50           |
| 3      | 100.91.206.50:8080      |

---

## 7. Primer acceso

1. Abrir el navegador y navegar a `http://100.91.206.50:8080`.
2. Iniciar sesión con:
   - Usuario: `admin`
   - Contraseña: `admin1234`
3. Completar el asistente de configuración inicial.

---

## 8. App de Nextcloud en el celular

- **iOS:** Buscar "Nextcloud" en App Store.
- **Android:** Buscar "Nextcloud" en Play Store.
- Configurar la URL del servidor: `http://100.91.206.50:8080`
- Iniciar sesión con el usuario `admin`.

---

## Capturas de pantalla

![Salida de docker compose up -d](../screenshots/nextcloud/01-nextcloud-docker-compose-up.png)

![Pantalla de instalación inicial](../screenshots/nextcloud/02-nextcloud-instalador.png)

![Pantalla de login de Nextcloud](../screenshots/nextcloud/20-nextcloud-login.png)

![Panel principal de Nextcloud con archivos](../screenshots/nextcloud/21-nextcloud-panel.png)

![Subida de un archivo a Nextcloud](../screenshots/nextcloud/22-nextcloud-subida-archivo.png)

![Enlace de compartir un archivo](../screenshots/nextcloud/23-nextcloud-compartir.png)

![Acceso desde el celular con la app de Nextcloud](../screenshots/nextcloud/24-nextcloud-celular.png)
