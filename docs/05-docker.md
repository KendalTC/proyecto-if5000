# 05 — Instalación de Docker

| Campo         | Valor              |
|---------------|--------------------|
| Servidor      | servidor-if5000    |
| IP local      | 192.168.50.100     |
| IP Tailscale  | 100.127.183.41     |

---

## 1. ¿Qué es Docker?

Docker es una plataforma de contenedores que permite ejecutar aplicaciones de forma aislada y reproducible. Cada servicio del proyecto (Nextcloud, Jellyfin, Pi-hole, Portainer) corre dentro de su propio contenedor Docker, lo que facilita la instalación, actualización y mantenimiento.

**Docker Compose** es una herramienta complementaria que permite definir y levantar múltiples contenedores con un solo archivo YAML (`docker-compose.yml`).

---

## 2. Instalación de Docker desde el repositorio oficial

Ejecutar los siguientes comandos en orden:

```bash
# Instalar dependencias
sudo apt install -y ca-certificates curl gnupg

# Crear directorio para claves GPG
sudo install -m 0755 -d /etc/apt/keyrings

# Descargar la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Agregar el repositorio oficial de Docker
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Actualizar la lista de paquetes
sudo apt update

# Instalar Docker Engine y Docker Compose Plugin
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Agregar el usuario adminuser al grupo docker (para ejecutar sin sudo)
sudo usermod -aG docker adminuser
```

> Después de ejecutar `usermod`, cerrar sesión y volver a iniciar para que el cambio de grupo tenga efecto.

---

## 3. Verificación de la instalación

```bash
# Ejecutar el contenedor de prueba
docker run hello-world

# Ver contenedores activos
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a

# Ver versión instalada
docker --version
docker compose version
```

La salida de `hello-world` debe incluir el mensaje:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

---

## 4. Comandos esenciales de Docker

```bash
# Iniciar un contenedor detenido
docker start nombre_contenedor

# Detener un contenedor
docker stop nombre_contenedor

# Reiniciar un contenedor
docker restart nombre_contenedor

# Ver los logs de un contenedor
docker logs nombre_contenedor

# Ver logs en tiempo real
docker logs -f nombre_contenedor

# Acceder a la terminal de un contenedor
docker exec -it nombre_contenedor bash

# Ver el uso de recursos de los contenedores
docker stats

# Listar imágenes descargadas
docker images

# Eliminar un contenedor (debe estar detenido)
docker rm nombre_contenedor

# Eliminar una imagen
docker rmi nombre_imagen
```

---

## 5. Comandos de Docker Compose

```bash
# Levantar los servicios definidos en docker-compose.yml
docker compose up -d

# Detener y eliminar los contenedores
docker compose down

# Ver logs de los servicios
docker compose logs -f

# Ver el estado de los servicios
docker compose ps

# Reconstruir y levantar los contenedores
docker compose up -d --build
```

---

## 6. Estructura de directorios para los servicios

Cada servicio tiene su propio directorio en el home del usuario:

```
~/
├── nextcloud/
│   └── docker-compose.yml
├── jellyfin/
│   └── docker-compose.yml
├── pihole/
│   └── docker-compose.yml
└── media/
    ├── peliculas/
    ├── musica/
    └── fotos/
```

---

## Capturas de pantalla

![Salida de docker run hello-world](../screenshots/docker/hello-world.png)

![Salida de docker ps con todos los contenedores corriendo](../screenshots/docker/docker-ps.png)

![Salida de docker images](../screenshots/docker/docker-images.png)
