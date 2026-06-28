#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

SURICATA_LOG="/var/log/suricata/eve.json"
FAIL2BAN_LOG="/var/log/fail2ban.log"

declare -A SCORE
declare -A DETAILS

echo "[SOC v2] iniciado..."

tail -F "$SURICATA_LOG" | while read line; do

    echo "$line" | jq -c '.' 2>/dev/null | while read json; do

        EVENT_TYPE=$(echo "$json" | jq -r '.event_type // empty')
        SIG=$(echo "$json" | jq -r '.alert.signature // empty')
        SRC=$(echo "$json" | jq -r '.src_ip // empty')

        # =========================
        # PORT SCAN DETECTION
        # =========================
        if [[ "$SIG" == *"SCAN"* || "$SIG" == *"Nmap"* ]]; then
            SCORE["$SRC"]=$(( ${SCORE["$SRC"]} + 50 ))
            DETAILS["$SRC"]+="- Port Scan detected\n"
        fi

        # =========================
        # FAIL2BAN BRUTE FORCE
        # =========================
        if grep -q "$SRC" "$FAIL2BAN_LOG" 2>/dev/null; then
            SCORE["$SRC"]=$(( ${SCORE["$SRC"]} + 30 ))
            DETAILS["$SRC"]+="- SSH brute force detected\n"
        fi

        # =========================
        # WEB PROBING (HTTP)
        # =========================
        if [[ "$SIG" == *"HTTP"* ]]; then
            SCORE["$SRC"]=$(( ${SCORE["$SRC"]} + 20 ))
            DETAILS["$SRC"]+="- HTTP probing detected\n"
        fi

        # =========================
        # SI SCORE ES ALTO → ALERTA
        # =========================
        if [[ ${SCORE["$SRC"]} -ge 60 ]]; then

            MESSAGE="🚨 SOC v2 - THREAT CORRELATED
IP: $SRC
Risk Score: ${SCORE["$SRC"]}/100

Events:
${DETAILS["$SRC"]}

Server: servidor-if5000"

            curl -H "Content-Type: application/json" -X POST -d "{
                \"username\":\"SOC v2 ENGINE\",
                \"content\":\"$MESSAGE\"
            }" "$WEBHOOK"

            # reset después de alertar
            SCORE["$SRC"]=0
            DETAILS["$SRC"]=""

        fi

    done

done
