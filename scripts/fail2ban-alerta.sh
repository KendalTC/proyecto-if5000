#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

curl -H "Content-Type: application/json" \
-X POST \
-d '{
"username":"Fail2ban SOC",
"content":"🚫 ALERTA SOC\nServicio: SSH\nEvento: Intento de acceso bloqueado\nServidor: servidor-if5000\nEstado: SIMULADO"
}' \
"$WEBHOOK"
