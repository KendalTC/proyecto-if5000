# 10 — Tailscale (VPN Mesh)

| Campo         | Valor              |
|---------------|--------------------|
| Servicio      | Tailscale          |
| IP del servidor | 100.91.206.50   |

---

## 1. ¿Qué es Tailscale y por qué lo usamos?

Tailscale es una VPN de tipo mesh basada en el protocolo WireGuard. A diferencia de las VPN tradicionales (que requieren un servidor central), Tailscale crea una red privada directa entre todos los dispositivos, sin importar desde qué red se conecten.

**Ventajas para este proyecto:**
- Acceso al servidor desde cualquier red (casa, universidad, celular) con la misma IP fija (`100.91.206.50`).
- No requiere configurar port-forwarding en el router.
- Cifrado extremo a extremo de todo el tráfico.
- Funciona aunque el servidor cambie de IP local (DHCP).

---

## 2. Instalación en el servidor (Ubuntu Server)

```bash
# Instalar Tailscale con el script oficial
curl -fsSL https://tailscale.com/install.sh | sh

# Autenticar y conectar el servidor
sudo tailscale up

# Verificar IP asignada
tailscale ip
```

> El script detecta automáticamente la versión de Ubuntu y configura 
> el repositorio correcto. Internamente ejecuta los mismos pasos que 
> el método manual pero en un solo comando.

> **Ventaja demostrada:** Durante la instalación se cambió de red WiFi 
> sin perder la conexión SSH al servidor. La IP de Tailscale 
> (`100.91.206.50`) se mantuvo estable independientemente de la red local.

La IP asignada al servidor es: **100.91.206.50**

---

## 3. Verificar el estado de Tailscale

```bash
# Ver estado de la conexión
tailscale status

# Ver la IP de Tailscale
tailscale ip

# Reiniciar la conexión (útil cuando se cambia de red)
sudo tailscale up
```

---

## 4. Instalación en clientes Windows

```powershell
# Instalar via winget
winget install Tailscale.Tailscale

# Autenticar (abre el navegador para hacer login)
tailscale up
```

También se puede descargar el instalador desde el sitio oficial de Tailscale.

---

## 5. Instalación en iOS / Android

- **iOS:** Buscar "Tailscale" en App Store → Instalar → Iniciar sesión con la cuenta del grupo.
- **Android:** Buscar "Tailscale" en Play Store → Instalar → Iniciar sesión.

Tras iniciar sesión, el dispositivo obtiene automáticamente su IP en la red Tailscale.

---

## 6. Dispositivos conectados

| Dispositivo         | IP Tailscale     | Sistema Operativo |
|---------------------|-----------------|-------------------|
| servidor-if5000     | 100.91.206.50  | Ubuntu Server 24.04 |
| iPhone-15-pro       | 100.68.123.84   | iOS               |
| kendalltc (Windows) | 100.67.254.26   | Windows 11        |

---

## 7. Agregar compañeros del grupo

Para que todos los integrantes del grupo puedan acceder al servidor con sus propios dispositivos:

1. Ir a `login.tailscale.com` → **Settings** → **Users** → **Invite users**.
2. Ingresar el correo de cada integrante.
3. Cada integrante acepta la invitación e instala Tailscale.
4. Sus dispositivos aparecen en el panel de administración.

---

## 8. Reconectar al cambiar de red

Cuando el servidor se mueve a una red diferente (DHCP), la IP local cambia pero la IP de Tailscale permanece igual. Solo se debe reconectar Tailscale:

```bash
sudo tailscale up
tailscale ip
```

---

## 9. Verificar conectividad desde un cliente

```bash
# Hacer ping al servidor desde un cliente con Tailscale activo
ping 100.91.206.50

# Conectar por SSH
ssh adminuser@100.91.206.50
```

---

## Fuentes

- Tailscale Documentation: https://tailscale.com/kb
- Tailscale Download Linux: https://tailscale.com/download/linux

---

## Capturas de pantalla

**Instalación y autenticación:**

![Salida de tailscale ip con la IP asignada: 100.91.206.50](../screenshots/tailscale/01-tailscale-ip.png)

![Salida de tailscale status — servidor conectado y activo](../screenshots/tailscale/02-tailscale-status.png)

**Verificación — Panel de administración:**

![Panel de admin.tailscale.com con todos los dispositivos de la red](../screenshots/tailscale/20-tailscale-admin-panel.png)

**Verificación — Acceso remoto:**

![Conexión SSH exitosa al servidor vía Tailscale](../screenshots/tailscale/21-tailscale-ssh.png)

![Conexión SSH desde una red diferente — demostración de acceso independiente de red local](../screenshots/tailscale/22-tailscale-ssh-otra-red.png)
