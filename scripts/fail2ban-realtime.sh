#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

tail -Fn0 /var/log/fail2ban.log | while read line
do
    echo "$line" | grep "Ban" > /dev/null

    if [ $? = 0 ]; then

        IP=$(echo "$line" | awk '{print $NF}')
        TIME=$(date)

        curl -H "Content-Type: application/json" \
        -X POST \
        -d "{
        \"username\":\"Fail2ban SOC\",
        \"content\":\"🚨 ALERTA REAL SOC\\nIP bloqueada: $IP\\nEvento: Fail2ban BAN\\nServidor: servidor-if5000\\nHora: $TIME\"
        }" \
        "$WEBHOOK"
    fi
done
