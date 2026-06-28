#!/bin/bash

WEBHOOK="WEBHOOK_HERE"
LOG="/var/log/suricata/eve.json"

echo "[SURICATA SOC] AGREGACIÓN INICIADA..."

declare -A COUNT
declare -A LAST_SEND

WINDOW=60

flush_alert() {
    key=$1
    signature=$2
    src=$3
    count=$4

    geo=$(curl -s "http://ip-api.com/json/$src?fields=country,regionName,city" \
        | jq -r '"\(.city), \(.regionName), \(.country)"')

    MESSAGE="🚨 SURICATA ALERT (AGREGADA)
Signature: $signature
Source IP: $src
Events: $count en ${WINDOW}s
Location: $geo
Server: $(hostname)"

    PAYLOAD=$(jq -n --arg msg "$MESSAGE" '{"content":$msg}')

    curl -s -H "Content-Type: application/json" \
        -X POST -d "$PAYLOAD" "$WEBHOOK" > /dev/null
}

tail -Fn0 "$LOG" | jq -c 'select(.event_type=="alert")' | while read -r line; do

    SIGNATURE=$(echo "$line" | jq -r '.alert.signature // "unknown"')
    SRC=$(echo "$line" | jq -r '.src_ip // "unknown"')

    # filtrar LAN
    [[ "$SRC" == 192.168.* || "$SRC" == 10.* ]] && continue

    KEY="${SRC}_${SIGNATURE}"

    NOW=$(date +%s)

    # incrementar contador
    COUNT[$KEY]=$((COUNT[$KEY]+1))

    # inicializar timer
    if [[ -z "${LAST_SEND[$KEY]}" ]]; then
        LAST_SEND[$KEY]=$NOW
    fi

    DIFF=$((NOW - LAST_SEND[$KEY]))

    # si pasa ventana de tiempo → enviar resumen
    if [[ $DIFF -ge $WINDOW ]]; then

        if [[ ${COUNT[$KEY]} -gt 0 ]]; then
            flush_alert "$KEY" "$SIGNATURE" "$SRC" "${COUNT[$KEY]}"
        fi

        COUNT[$KEY]=0
        LAST_SEND[$KEY]=$NOW
    fi

done
