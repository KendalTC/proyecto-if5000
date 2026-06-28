#!/bin/bash

WEBHOOK="WEBHOOK_HERE"

tail -F /var/log/suricata/eve.json | while read -r line; do

    echo "$line" | jq -e '.event_type=="alert"' >/dev/null 2>&1 || continue

    ALERT_SIG=$(echo "$line" | jq -r '.alert.signature // empty')
    SRC_IP=$(echo "$line" | jq -r '.src_ip // empty')

    if [[ "$ALERT_SIG" == *"SCAN"* || "$ALERT_SIG" == *"Nmap"* ]]; then
        MESSAGE="🚨 SOC ALERT - PORT SCAN DETECTED | IP: $SRC_IP | Sig: $ALERT_SIG"

        PAYLOAD=$(jq -n --arg msg "$MESSAGE" '{"content":$msg}')

        curl -s -H "Content-Type: application/json" \
            -X POST \
            -d "$PAYLOAD" \
            "$WEBHOOK"
    fi

done
