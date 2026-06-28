# 03 — Configuración de Red con Netplan

| Campo          | Valor              |
|----------------|--------------------|
| Interfaz       | enp0s3             |
| IP estática    | 192.168.50.100/24  |
| Gateway        | 192.168.50.1       |
| DNS            | 8.8.8.8            |
| IP Tailscale   | 100.91.206.50      |

---

## 1. ¿Qué es Netplan?

Netplan es la herramienta de configuración de red por defecto en Ubuntu 20.04 y versiones posteriores. Utiliza archivos YAML ubicados en `/etc/netplan/` para describir la configuración de las interfaces de red.

Los cambios se aplican con el comando `sudo netplan apply`, que reconfigura la red sin necesidad de reiniciar el sistema.

---

> **Nota:** En Ubuntu Server 24.04, el archivo de configuración de red generado 
> automáticamente por el instalador se llama `50-cloud-init.yaml`. 
> Los cambios de red se realizan sobre este archivo.

## 2. Ver la configuración actual

```bash
# Listar archivos de configuración de Netplan
ls /etc/netplan/

# Ver el archivo de configuración activo
cat /etc/netplan/50-cloud-init.yaml

# Ver interfaces y direcciones IP actuales
ip a
```

---

## 3. Configuración con IP estática

Usar esta configuración cuando el servidor opera en la red fija de laboratorio (192.168.50.0/24).

```bash
sudo nano /etc/netplan/50-cloud-init.yaml
```

Contenido:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      addresses:
        - 192.168.50.100/24
      gateway4: 192.168.50.1
      nameservers:
        addresses: [8.8.8.8]
```

El archivo de referencia se encuentra en: `config/netplan/00-installer-config-static.yaml`

---

## 4. Configuración con DHCP

Usar esta configuración cuando el servidor se conecta a una red distinta (por ejemplo, la red de la universidad o una red doméstica diferente). En este caso, la IP es asignada automáticamente por el router.

```bash
sudo nano /etc/netplan/50-cloud-init.yaml
```

Contenido:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
```

El archivo de referencia se encuentra en: `config/netplan/00-installer-config-dhcp.yaml`

> **Nota:** Con DHCP la IP del servidor puede cambiar. Para el acceso remoto desde fuera de la red local, Tailscale mantiene siempre la misma IP (`100.91.206.50`) independientemente de cuál sea la IP local.

---

## 5. Aplicar los cambios

Después de editar el archivo:

```bash
# Ajustar permisos (requerido por Netplan)
sudo chmod 600 /etc/netplan/50-cloud-init.yaml

# Aplicar la configuración
sudo netplan apply
```

> Si aparece un warning de permisos, corregirlo con:
> ```bash
> sudo chmod 600 /etc/netplan/50-cloud-init.yaml
> sudo netplan apply
> ```

> **Nota:** Si hay problemas de conectividad con `apt`, forzar IPv4:
> ```bash
> sudo apt-get -o Acquire::ForceIPv4=true update
> ```

---

## 6. Verificación

```bash
# Ver la IP asignada
ip a

# Verificar conectividad a la red local
ping -c 3 192.168.50.1

# Verificar conectividad a Internet
ping -c 3 8.8.8.8

# Verificar resolución DNS
ping -c 3 google.com
```

---

## 7. Cuándo usar cada configuración

| Situación                                      | Configuración a usar |
|------------------------------------------------|----------------------|
| Red de laboratorio fija (192.168.50.0/24)      | IP estática          |
| Universidad u otra red desconocida             | DHCP                 |
| Acceso remoto desde cualquier red (Tailscale)  | Cualquiera           |

---

## Capturas de pantalla

**Verificación — IP aplicada:**

![Salida de ip a mostrando la IP estática 192.168.50.100 en enp0s3](../screenshots/ubuntu/20-ip-a-resultado.png)

**Verificación — Conectividad:**

![Ping exitoso a 8.8.8.8 — conectividad a Internet verificada](../screenshots/ubuntu/21-ping-internet.png)

![Ping exitoso a google.com — resolución DNS funcionando](../screenshots/ubuntu/22-ping-dns.png)
