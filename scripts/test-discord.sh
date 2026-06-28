#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

curl -H "Content-Type: application/json" \
-X POST \
-d '{
"username":"IF5000 SOC",
"content":"Alerta de prueba desde Ubuntu Server"
}' \
"$WEBHOOK"
