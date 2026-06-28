#!/bin/bash

WEBHOOK="WEBHOOK_HERE"
LOG="/var/log/auth.log"

declare -A LAST_IP
declare -A SEEN_LOGOUT

echo "[SOC ENGINE] monitoreando logins..."

while read -r line; do

    # =========================
    # LOGIN EXITOSO
    # =========================
    if echo "$line" | grep -qE "Accepted password|Accepted publickey"; then

        USER=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}')
        IP=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')
        PORT=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="port") print $(i+1)}')
        METHOD=$(echo "$line" | grep -q "password" && echo "password" || echo "ssh-key")

        DEVICE=$(uname -a)

        # =========================
        # GEOLOCALIZACIÓN
        # =========================
        GEO=$(curl -s "http://ip-api.com/json/$IP")

        COUNTRY=$(echo "$GEO" | jq -r '.country // "N/A"')
        CITY=$(echo "$GEO" | jq -r '.city // "N/A"')
        ISP=$(echo "$GEO" | jq -r '.isp // "N/A"')

        if [[ "$COUNTRY" == "N/A" || "$COUNTRY" == "null" ]]; then
            GEO_INFO="IP privada o sin geolocalización"
        else
            GEO_INFO="$CITY, $COUNTRY | ISP: $ISP"
        fi

        # detectar nueva IP
        if [[ "${LAST_IP[$USER]}" != "$IP" ]]; then
            NEW_IP="🆕 NUEVA IP DETECTADA"
        else
            NEW_IP="IP conocida"
        fi

        LAST_IP[$USER]=$IP

        MESSAGE="🔐 LOGIN EXITOSO
User: $USER
IP: $IP
Port: $PORT
Auth: $METHOD
$NEW_IP
Geo: $GEO_INFO
Device: $DEVICE
Server: $(hostname)"

        PAYLOAD=$(jq -n --arg msg "$MESSAGE" '{"content":$msg}')

        curl -s -H "Content-Type: application/json" \
            -X POST -d "$PAYLOAD" "$WEBHOOK" > /dev/null
    fi


    # =========================
    # LOGOUT (ANTI DUPLICADO)
    # =========================
    if echo "$line" | grep -q "session closed for user"; then

        USER=$(echo "$line" | sed -n 's/.*session closed for user \([^ ]*\).*/\1/p')

        KEY="logout_${USER}"

        # anti spam logout
        if [[ "${SEEN_LOGOUT[$KEY]}" == "1" ]]; then
            continue
        fi

        SEEN_LOGOUT[$KEY]=1

        MESSAGE="🔴 SESIÓN CERRADA
User: $USER
Time: $(date)
Server: $(hostname)"

        PAYLOAD=$(jq -n --arg msg "$MESSAGE" '{"content":$msg}')

        curl -s -H "Content-Type: application/json" \
            -X POST -d "$PAYLOAD" "$WEBHOOK" > /dev/null
    fi

done < <(tail -Fn0 "$LOG")
