#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

curl -H "Content-Type: application/json" \
-X POST \
-d '{
"username":"IF5000 SOC",
"content":"Alerta de prueba desde Ubuntu Server"
}' \
"$WEBHOOK"
#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

curl -H "Content-Type: application/json" \
-X POST \
-d '{
"username":"Fail2ban SOC",
"content":" IP bloqueada por Fail2ban\nServicio: SSH\nServidor: servidor-if5000\nEstado: DEMO"
}' \
"$WEBHOOK"
