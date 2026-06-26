# 14 — Suricata IDS (Detección de Intrusiones)

| Campo        | Valor                              |
|--------------|------------------------------------|
| Herramienta  | Suricata 7.x                       |
| Tipo         | IDS — Intrusion Detection System   |
| Log de alertas | `/var/log/suricata/eve.json`     |
| Integración  | SOC Discord Alerting               |

---

## 1. ¿Qué es Suricata?

Suricata es un motor de detección de intrusiones de red (IDS) de código abierto. Analiza el tráfico de red en tiempo real y genera alertas cuando detecta patrones maliciosos definidos en sus reglas, como:

- Escaneos de puertos (Nmap, port scan)
- Ataques de fuerza bruta
- Exploits conocidos
- Tráfico HTTP sospechoso
- Conexiones a IPs maliciosas

Todas las alertas se escriben en formato JSON en el archivo `/var/log/suricata/eve.json`, que es la fuente principal del sistema SOC implementado.

---

## 2. Instalación

```bash
sudo apt update
sudo apt install suricata -y
```

Verificar la versión instalada:

```bash
suricata --version
```

---

## 3. Habilitar e iniciar el servicio

```bash
sudo systemctl enable suricata
sudo systemctl start suricata
sudo systemctl status suricata
```

La salida esperada muestra `active (running)`.

---

## 4. Actualizar las reglas (Emerging Threats)

Suricata incluye `suricata-update` para descargar y actualizar las reglas de detección:

```bash
sudo suricata-update
sudo systemctl restart suricata
```

Esto descarga el conjunto de reglas **Emerging Threats Open**, que incluye firmas para escaneos, malware, exploits y más.

---

## 5. Archivo de configuración

El archivo de configuración principal es `/etc/suricata/suricata.yaml`.

Parámetro clave — interfaz de red a monitorear:

```yaml
af-packet:
  - interface: enp0s3   # ajustar según la interfaz del servidor
```

Para verificar cuál es la interfaz activa:

```bash
ip a
```

Después de editar, reiniciar el servicio:

```bash
sudo systemctl restart suricata
```

---

## 6. Verificar que Suricata genera alertas

El archivo de log en formato JSON (`eve.json`) es la fuente de todos los eventos:

```bash
# Ver los últimos eventos en tiempo real
sudo tail -f /var/log/suricata/eve.json

# Filtrar solo alertas (event_type = alert)
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'
```

Estructura de una alerta en `eve.json`:

```json
{
  "timestamp": "2026-06-25T14:32:01.123456+0000",
  "event_type": "alert",
  "src_ip": "203.0.113.45",
  "src_port": 52341,
  "dest_ip": "192.168.50.100",
  "dest_port": 22,
  "alert": {
    "action": "allowed",
    "signature_id": 2010943,
    "signature": "ET SCAN Nmap Scripting Engine User-Agent Detected",
    "category": "Attempted Information Leak"
  }
}
```

---

## 7. Probar la detección con Nmap (desde otra máquina)

Para simular un escaneo de puertos y verificar que Suricata lo detecta:

```bash
# Desde Windows/otro equipo en la misma red
nmap -sV 192.168.50.100
```

Luego verificar que aparece la alerta en el log:

```bash
sudo tail -n 20 /var/log/suricata/eve.json | jq 'select(.event_type=="alert") | .alert.signature'
```

---

## 8. Integración con el sistema SOC

Los scripts del sistema SOC consumen `eve.json` en tiempo real:

| Script | Qué hace con Suricata |
|---|---|
| `suricata-watcher.sh` | Agrega alertas por IP+firma en ventanas de 60s → Discord |
| `fail2ban-watcher.sh` | Alerta inmediata si detecta SCAN o Nmap → Discord |
| `soc-v2.sh` | Asigna score de amenaza basado en tipo de alerta |

Ver documentación completa del sistema SOC: [16-soc-discord.md](16-soc-discord.md)

---

## Fuentes

- Suricata Documentation: https://docs.suricata.io
- Suricata Update (reglas): https://suricata-update.readthedocs.io
- Emerging Threats Rules: https://rules.emergingthreats.net
