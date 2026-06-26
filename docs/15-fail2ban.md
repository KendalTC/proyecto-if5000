# 15 — Fail2ban (Bloqueo Automático de IPs)

| Campo        | Valor                                      |
|--------------|--------------------------------------------|
| Herramienta  | Fail2ban                                   |
| Tipo         | Protección activa contra fuerza bruta      |
| Log de eventos | `/var/log/fail2ban.log`                  |
| Jail activo  | `sshd` (SSH)                               |
| Integración  | SOC Discord Alerting                       |

---

## 1. ¿Qué es Fail2ban?

Fail2ban es una herramienta de seguridad que monitorea los archivos de log del sistema y bloquea automáticamente las direcciones IP que muestran comportamiento malicioso, como múltiples intentos fallidos de autenticación SSH.

**Flujo de funcionamiento:**

```
Intento SSH fallido → /var/log/auth.log → Fail2ban detecta patrón
        ↓
  Supera el umbral (maxretry = 5 intentos)
        ↓
  Fail2ban ejecuta regla iptables → IP bloqueada
        ↓
  Evento "Ban" escrito en /var/log/fail2ban.log
        ↓
  Script fail2ban-realtime.sh detecta el ban → Alerta Discord
```

---

## 2. Instalación

```bash
sudo apt update
sudo apt install fail2ban -y
```

Verificar la versión:

```bash
fail2ban-client --version
```

---

## 3. Configuración del jail SSH

Fail2ban usa archivos de configuración llamados "jails". La configuración base está en `/etc/fail2ban/jail.conf`, pero se recomienda crear un archivo local para no perder cambios en actualizaciones:

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Parámetros relevantes para el jail SSH (ya habilitado por defecto en Ubuntu):

```ini
[sshd]
enabled  = true
port     = ssh
logpath  = /var/log/auth.log
maxretry = 5
bantime  = 600
findtime = 600
```

| Parámetro | Valor | Significado |
|-----------|-------|-------------|
| `maxretry` | 5 | Intentos fallidos antes de banear |
| `bantime` | 600 | Duración del ban en segundos (10 min) |
| `findtime` | 600 | Ventana de tiempo para contar intentos |

---

## 4. Habilitar e iniciar el servicio

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo systemctl status fail2ban
```

---

## 5. Verificar el estado del jail SSH

```bash
# Estado del jail sshd
sudo fail2ban-client status sshd
```

Salida esperada:

```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 2
|  |- Total failed:     47
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     3
   `- Banned IP list:   203.0.113.45
```

---

## 6. Comandos de administración

```bash
# Ver todos los jails activos
sudo fail2ban-client status

# Ver IPs baneadas en SSH
sudo fail2ban-client status sshd

# Desbanear una IP manualmente
sudo fail2ban-client set sshd unbanip 203.0.113.45

# Ver el log de eventos en tiempo real
sudo tail -f /var/log/fail2ban.log

# Filtrar solo eventos de ban
sudo grep "Ban" /var/log/fail2ban.log | tail -20
```

---

## 7. Dashboard CLI del SOC

El script `soc-dashboard.sh` del repositorio muestra un resumen rápido del estado de seguridad:

```bash
bash /home/mariangel/soc-alerting/scripts/soc-dashboard.sh
```

Salida esperada:

```
===== SOC DASHBOARD =====
Blocked IPs:
|- Banned IP list: 45.142.212.100 198.51.100.23

System status:
 14:32:01 up 3 days, 4:15,  2 users,  load average: 0.12, 0.08, 0.05

Recent bans:
2026-06-25 14:20:01,234 fail2ban.actions [1234]: NOTICE [sshd] Ban 45.142.212.100
2026-06-25 14:31:45,891 fail2ban.actions [1234]: NOTICE [sshd] Ban 198.51.100.23
```

---

## 8. Integración con el sistema SOC

| Script | Qué hace con Fail2ban |
|---|---|
| `fail2ban-realtime.sh` | Detecta eventos "Ban" en `fail2ban.log` → alerta Discord con IP |
| `soc-v2.sh` | Busca IPs de Suricata en `fail2ban.log` para score de correlación (+30 pts) |
| `soc-dashboard.sh` | Muestra IPs baneadas actuales y bans recientes |

Ver documentación completa del sistema SOC: [16-soc-discord.md](16-soc-discord.md)

---

## Fuentes

- Fail2ban Documentation: https://github.com/fail2ban/fail2ban
- Ubuntu Security — Fail2ban: https://ubuntu.com/server/docs/fail2ban
