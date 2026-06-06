# 04 — Acceso Remoto SSH

| Campo         | Valor                          |
|---------------|-------------------------------|
| Puerto SSH    | 22                             |
| Usuario       | adminuser                      |
| IP local      | 192.168.50.100                 |
| IP Tailscale  | 100.127.183.41                 |

---

## 1. Estado del servicio SSH

El servidor OpenSSH se instala durante la instalación de Ubuntu Server (paso "Install OpenSSH server"). Al primer arranque, el servicio ya está activo.

```bash
# Verificar estado del servicio
systemctl status ssh

# Habilitar inicio automático
sudo systemctl enable ssh

# Iniciar el servicio (si está detenido)
sudo systemctl start ssh

# Reiniciar el servicio
sudo systemctl restart ssh
```

---

## 2. Conexión desde Windows (PowerShell)

```powershell
# Conexión por red local
ssh adminuser@192.168.50.100

# Conexión vía Tailscale (desde cualquier red)
ssh adminuser@100.127.183.41
```

Al conectarse por primera vez se solicita aceptar la clave del host:

```
The authenticity of host '192.168.50.100' can't be established.
ED25519 key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

Ingresar `yes` para continuar.

---

## 3. Conexión desde Mac / Linux

```bash
# Red local
ssh adminuser@192.168.50.100

# Via Tailscale
ssh adminuser@100.127.183.41
```

---

## 4. Conexión desde celular

- **iOS/Android:** Instalar la app **Termius** o similar.
- Configurar un host con:
  - Hostname: `100.127.183.41`
  - Username: `adminuser`
  - Password: (contraseña del servidor)
- Requiere tener **Tailscale** instalado y activo en el celular.

---

## 5. Transferencia de archivos con SCP

```powershell
# Subir un archivo de video al servidor
scp "C:\ruta\archivo.mp4" adminuser@192.168.50.100:~/media/peliculas/

# Subir una carpeta completa
scp -r "C:\ruta\carpeta" adminuser@192.168.50.100:~/media/

# Descargar un archivo desde el servidor
scp adminuser@192.168.50.100:~/archivo.txt C:\destino\
```

---

## 6. Comandos de comunicación entre usuarios

```bash
# Enviar mensaje a todos los usuarios conectados
wall "El servidor se reiniciará en 5 minutos"

# Enviar mensaje a un usuario específico
write adminuser

# Ver todos los usuarios conectados
who

# Ver información detallada de sesiones
w
```

---

## 7. Crear usuarios por integrante del grupo

El proyecto requiere que cada integrante tenga su propio usuario en el servidor.

```bash
# Crear usuario
sudo adduser nombre_integrante

# Agregar al grupo sudo (acceso administrativo)
sudo usermod -aG sudo nombre_integrante

# Verificar que el usuario fue creado
id nombre_integrante

# Listar todos los usuarios del sistema
cat /etc/passwd | grep -v nologin | grep -v false
```

---

## 8. Configuración de SSH (opcional — seguridad adicional)

Editar `/etc/ssh/sshd_config` para reforzar la seguridad:

```bash
sudo nano /etc/ssh/sshd_config
```

Parámetros recomendados:

```
PermitRootLogin no
PasswordAuthentication yes
MaxAuthTries 3
```

Aplicar cambios:

```bash
sudo systemctl restart ssh
```

---

## Capturas de pantalla

![Conexión SSH exitosa desde PowerShell en Windows](../screenshots/ssh/ssh-windows-powershell.png)

![Conexión SSH exitosa vía Tailscale](../screenshots/ssh/ssh-tailscale.png)

![Conexión SSH desde el celular (Termius)](../screenshots/ssh/ssh-celular.png)

![Salida de who mostrando múltiples usuarios conectados](../screenshots/ssh/who-usuarios.png)
